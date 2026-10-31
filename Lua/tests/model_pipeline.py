"""Run from any directory: python Lua/tests/model_pipeline.py (Lua 5.3+, war3mdlx)."""

from pathlib import Path
import re
import subprocess
import tempfile


REPO = Path(__file__).resolve().parents[2]
PIPELINE = REPO / 'Lua/model/一键处理模型.lua'
CONVERTER = Path(r'D:\War3\tools\war3mdlx.exe')


def fixture():
    vertices = ['{0,0,0}', '{1,0,0}', '{0,1,0}'] * 2
    normals = ['{0,0,1}'] * 3 + ['{0,1,0}'] * 3
    uv = ['{0,0}', '{1,0}', '{0,1}'] * 2
    blocks = []
    for index, name in enumerate(['Bip001 Head', 'Bip001 Spine2', 'Bip001 R Hand', 'Bip001 L Hand']):
        animation = ''
        if index == 0:
            animation = ('\tTranslation 3 {\n\t\tDontInterp,\n\t\t0: {1,0,0},\n'
                         '\t\t50: {1.000005,0,0},\n\t\t100: {1,0,0},\n\t}\n')
        blocks.append(f'Bone "{name}" {{\n\tObjectId {index},\n' + animation +
                      '\tGeosetId Multiple,\n\tGeosetAnimId None,\n}\n')
    return ('Version { FormatVersion 800, }\nModel "PipelineFixture" { BlendTime 150, }\n'
            'Sequences 1 { Anim "Stand" { Interval {0,100}, } }\n'
            'Textures 1 { Bitmap { Image "fixture.blp", } }\n'
            'Materials 1 { Material { Layer { FilterMode None, Unshaded, TwoSided, static TextureID 0, } } }\n'
            'Geoset {\n\tVertices 6 {\n\t\t' + ',\n\t\t'.join(vertices) + ',\n\t}\n'
            '\tNormals 6 {\n\t\t' + ',\n\t\t'.join(normals) + ',\n\t}\n'
            '\tTVertices 6 {\n\t\t' + ',\n\t\t'.join(uv) + ',\n\t}\n'
            '\tVertexGroup { 0,0,0,0,0,0, }\n'
            '\tFaces 1 6 { Triangles { {0,1,2,3,4,5}, } }\n'
            '\tGroups 1 1 { Matrices {0}, }\n\tMaterialID 0,\n\tSelectionGroup 0,\n}\n' +
            ''.join(blocks) +
            'PivotPoints 4 {\n\t{0,0,10},\n\t{0,0,5},\n\t{1,0,5},\n\t{-1,0,5},\n}\n').encode()


def run(arguments, success=True):
    result = subprocess.run(list(map(str, arguments)), capture_output=True)
    diagnostic = (result.stdout + result.stderr).decode(errors='replace').encode('ascii', 'backslashreplace').decode()
    assert (result.returncode == 0) == success, diagnostic
    return result


def verify_outputs(mdl, vertices=3, keys=2):
    text = mdl.read_text(encoding='utf-8')
    assert f'Vertices {vertices} ' in text
    assert f'Translation {keys} ' in text
    for name in ['Origin Ref', 'Overhead Ref', 'Head Ref', 'Chest Ref', 'Hand Right Ref', 'Hand Left Ref']:
        assert text.count('Attachment "' + name + '"') == 1
    pivots = int(re.search(r'PivotPoints\s+(\d+)', text)[1])
    ids = [int(value) for value in re.findall(r'ObjectId\s+(\d+)', text)]
    assert pivots >= max(ids) + 1
    binary = mdl.with_suffix('.mdx')
    assert binary.read_bytes().startswith(b'MDLX')
    verified = mdl.parent / 'check.mdx'
    run([CONVERTER, '-f', mdl, verified])
    assert verified.read_bytes() == binary.read_bytes()
    assert not list(mdl.parent.glob('*.pipeline.*'))


def main():
    assert CONVERTER.is_file(), 'Set CONVERTER to the local war3mdlx.exe path'
    with tempfile.TemporaryDirectory(prefix='war3_model_pipeline_') as temporary:
        root = Path(temporary)
        assert root.resolve().parent == Path(tempfile.gettempdir()).resolve()

        def case(name):
            path = root / name
            path.mkdir()
            return path / 'model.mdl'

        mdl = case('mdl input')
        mdl.write_bytes(fixture())
        old_mdx = b'existing MDX must be backed up before processing'
        mdl.with_suffix('.mdx').write_bytes(old_mdx)
        result = run(['lua', PIPELINE, mdl])
        assert result.stdout.find(b'Backup:') < result.stdout.find(b'[3/5]')
        assert next(mdl.parent.glob('model.mdl.bak.*')).read_bytes() == fixture()
        assert next(mdl.parent.glob('model.mdx.bak.*')).read_bytes() == old_mdx
        verify_outputs(mdl)
        print('PASS: MDL input, two original backups, three steps, matching MDL/MDX')

        mdx_mdl = case('mdx input')
        mdx_mdl.write_bytes(fixture())
        mdx = mdx_mdl.with_suffix('.mdx')
        run([CONVERTER, '-f', mdx_mdl, mdx])
        original_mdx = mdx.read_bytes()
        mdx_mdl.write_bytes(b'original sibling MDL')
        run(['lua', PIPELINE, mdx])
        verify_outputs(mdx_mdl)
        assert next(mdx.parent.glob('model.mdx.bak.*')).read_bytes() == original_mdx
        assert next(mdx.parent.glob('model.mdl.bak.*')).read_bytes() == b'original sibling MDL'
        print('PASS: MDX input, sibling backup and automatic MDL output')

        exact = case('exact and keep normals')
        exact.write_bytes(fixture())
        run(['lua', PIPELINE, exact, '--epsilon', '0', '--keep-normals'])
        verify_outputs(exact, vertices=6, keys=3)
        print('PASS: epsilon and normal settings passed to the existing steps')

        missing = case('attachment failure')
        original = fixture().replace(b'Bip001 Head', b'Missing')
        missing.write_bytes(original)
        missing.with_suffix('.mdx').write_bytes(old_mdx)
        run(['lua', PIPELINE, missing], success=False)
        assert missing.read_bytes() == original and missing.with_suffix('.mdx').read_bytes() == old_mdx
        assert next(missing.parent.glob('model.mdl.bak.*')).read_bytes() == original
        assert not list(missing.parent.glob('*.pipeline.*'))
        print('PASS: step-4 failure preserves both originals and the initial backup')

        for paired in (True, False):
            rollback = case('rollback_' + str(paired))
            rollback.write_bytes(fixture())
            if paired:
                rollback.with_suffix('.mdx').write_bytes(old_mdx)
            wrapper = rollback.parent / 'fail_install.lua'
            wrapper.write_text(
                'local pipeline=assert(loadfile(arg[1]))("model.pipeline")\n'
                'local source,target,converter=arg[2],arg[3],arg[4]\n'
                'local rename=os.rename\n'
                'os.rename=function(a,b) if b==target and a:match("%.final%.mdx$") then '
                'return nil,"injected second install failure" end return rename(a,b) end\n'
                'pipeline.processFile(source,{converterExe=converter})\n', encoding='utf-8'
            )
            run(['lua', wrapper, PIPELINE, rollback, rollback.with_suffix('.mdx'), CONVERTER], success=False)
            assert rollback.read_bytes() == fixture()
            if paired:
                assert rollback.with_suffix('.mdx').read_bytes() == old_mdx
            else:
                assert not rollback.with_suffix('.mdx').exists()
            assert not list(rollback.parent.glob('*.pipeline.*'))
            print('PASS: second output install failure rolls back ' + ('both existing outputs' if paired else 'the first output without creating a sibling'))

        help_result = run(['lua', PIPELINE, '--help'])
        assert b'--epsilon' in help_result.stdout
        print('PASS: help does not process the default model')

        unicode_case = case('unicode input').with_name('角色 模型 & test.mdl')
        unicode_case.write_bytes(fixture())
        run(['lua', PIPELINE, unicode_case])
        verify_outputs(unicode_case)
        assert next(unicode_case.parent.glob(unicode_case.name + '.bak.*')).read_bytes() == fixture()
        print('PASS: Chinese filenames, spaces and ampersands')
    print('PASS: all 8 model pipeline checks')


if __name__ == '__main__':
    main()
