"""Step 3 regressions: python Lua/tests/model_compress.py (requires lua on PATH)."""

from pathlib import Path
import subprocess
import tempfile


SEQUENCES = (
    'Sequences 2 { Anim "Stand" { Interval { 0, 100 }, } '
    'Anim "Death" { Interval { 200, 300 }, } }\n'
)


def run_case(root, script, name, body, *, present=(), absent=(), success=True,
             prefix=SEQUENCES, extra_args=()):
    path = root / (name + '.mdl')
    original = (prefix + 'Bone "node" { ObjectId 0,\n' + body + '\n}\n').encode()
    path.write_bytes(original)
    process = subprocess.run(
        ['lua', str(script), str(path), *extra_args], capture_output=True, text=True, errors='replace'
    )
    assert (process.returncode == 0) == success, (name, process.stdout, process.stderr)
    output = path.read_bytes()
    backups = list(root.glob(name + '.mdl.bak.*'))
    if output != original:
        assert len(backups) == 1 and backups[0].read_bytes() == original, name
    else:
        assert not backups, name
    if not success:
        assert output == original, name
    text = output.decode()
    assert all(part in text for part in present), (name, present)
    assert not any(part in text for part in absent), (name, absent)
    if success:
        second = subprocess.run(
            ['lua', str(script), str(path), *extra_args], capture_output=True, text=True, errors='replace'
        )
        assert second.returncode == 0, (name, second.stdout, second.stderr)
        assert path.read_bytes() == output, name
        assert len(list(root.glob(name + '.mdl.bak.*'))) == len(backups), name
    print('PASS:', name)


def main():
    source = Path(__file__).resolve().parents[1] / 'model' / '模型第3步_压缩.lua'
    with tempfile.TemporaryDirectory(prefix='war3_model_compress_') as temporary:
        root = Path(temporary)
        # Snapshot the script under an ASCII filename for Windows Lua code pages.
        script = root / 'model_compress.lua'
        script.write_bytes(source.read_bytes())
        run_case(root, script, 'real_scale',
                 'Scaling 4 { DontInterp, 0: {1,1,1}, 100: {1,1,1}, '
                 '200: {0.0001,0.0001,0.0001}, 300: {10000,10000,10000}, }',
                 present=('Scaling 4', '0.0001', '10000'))
        run_case(root, script, 'boundaries',
                 'Rotation 6 { DontInterp, 0: {0,0,0,1}, 50: {0,0,0,1}, '
                 '100: {0,0,0,1}, 200: {0,0,0,1}, 250: {0,0,0,1}, 300: {0,0,0,1}, }',
                 present=('Rotation 4', '0:', '100:', '200:', '300:'), absent=('50:',))
        run_case(root, script, 'linear_plateau',
                 'Translation 4 { Linear, 0: {1,0,0}, 25: {1,0,0}, '
                 '50: {1,0,0}, 100: {2,0,0}, }',
                 present=('Translation 3', '50:', '100:'), absent=('25:',))
        run_case(root, script, 'default_tracks',
                 'Scaling 2 { Linear, 0: {1,1,1}, 100: {1,1,1}, }\n'
                 'Translation 1 { DontInterp, 0: {0,0,0}, }',
                 absent=('Scaling', 'Translation'))
        hermite = (
            'Translation 2 { Hermite, 0: {0,0,0}, InTan {1,0,0}, OutTan {1,0,0}, '
            '100: {0,0,0}, InTan {-1,0,0}, OutTan {-1,0,0}, }'
        )
        run_case(root, script, 'hermite_tangents', hermite, present=(hermite,))
        bezier = hermite.replace('Hermite', 'Bezier')
        run_case(root, script, 'bezier_tangents', bezier, present=(bezier,))
        global_track = (
            'Scaling 3 { DontInterp, GlobalSeqId 0, 0: {1,1,1}, '
            '50: {1,1,1}, 100: {1,1,1}, }'
        )
        run_case(root, script, 'global_sequence', global_track, present=(global_track,))
        tiny = 'Translation 2 { Linear, 0: {1e-8,+2.5E+2,-.5}, 100: {2e-8,+2.5E+2,-.5}, }'
        run_case(root, script, 'scientific_and_tiny', tiny, present=(tiny,))
        run_case(root, script, 'comments_static',
                 '// Scaling 99 { invalid }\nstatic Scaling {1,1,1},\n'
                 'Rotation 2 { DontInterp, 0: {0,0,0,1}, 100: {0,0,0,1}, }',
                 present=('// Scaling 99 { invalid }', 'static Scaling {1,1,1}'))
        gap = (
            'Rotation 4 { DontInterp, 0: {0,0,0,1}, 100: {0,0,0,1}, '
            '150: {0,0,0,1}, 300: {0,0,0,1}, }'
        )
        run_case(root, script, 'gap_keys', gap, present=(gap,))
        run_case(root, script, 'bad_count',
                 'Rotation 5 { DontInterp, 0: {0,0,0,1}, }', success=False)
        run_case(root, script, 'unclosed',
                 'Rotation 1 { DontInterp, 0: {0,0,0,1},', success=False)
        run_case(root, script, 'no_sequences', gap, prefix='', present=(gap,))
        near_rotation = (
            'Rotation 3 { DontInterp, 0: {0,0,0,1}, '
            '50: {0.000005,0,0,1}, 100: {0,0,0,1}, }'
        )
        run_case(root, script, 'default_epsilon', near_rotation,
                 present=('Rotation 2', '0:', '100:'), absent=('50:',))
        run_case(root, script, 'zero_epsilon', near_rotation,
                 present=(near_rotation,), extra_args=('--epsilon', '0'))
        run_case(root, script, 'custom_epsilon',
                 'Translation 3 { DontInterp, 0: {1,0,0}, 50: {1.0005,0,0}, 100: {1,0,0}, }',
                 present=('Translation 2',), absent=('50:',), extra_args=('--epsilon=0.001',))
        run_case(root, script, 'bounded_drift',
                 'Translation 6 { DontInterp, 0: {1,0,0}, 20: {1.000006,0,0}, '
                 '40: {1.000012,0,0}, 60: {1.000018,0,0}, 80: {1.000024,0,0}, 100: {1.00003,0,0}, }',
                 present=('Translation 4', '0:', '40:', '80:', '100:'), absent=('20:', '60:'))
        outside_epsilon = 'Rotation 3 { DontInterp, 0: {0,0,0,1}, 50: {0.00002,0,0,1}, 100: {0,0,0,1}, }'
        run_case(root, script, 'outside_epsilon', outside_epsilon, present=(outside_epsilon,))
        nonunit_scale = 'Scaling 2 { DontInterp, 0: {1.000005,1,1}, 100: {1.000005,1,1}, }'
        run_case(root, script, 'nonunit_scale_is_not_default', nonunit_scale, present=(nonunit_scale,))
        run_case(root, script, 'invalid_epsilon', near_rotation, success=False, extra_args=('--epsilon', '-1'))
        normalized = root / 'model_compress_normalize.lua'
        source_text = script.read_text(encoding='utf-8')
        marker = 'local NORMALIZE_NUMBERS = false'
        assert source_text.count(marker) == 1
        normalized.write_text(source_text.replace(marker, 'local NORMALIZE_NUMBERS = true'),
                              encoding='utf-8')
        run_case(root, normalized, 'normalize', tiny,
                 present=('0: {0,250,-0.5}', '100: {0,250,-0.5}'))
        run_case(root, normalized, 'normalize_convergence',
                 'Translation 2 { Linear, 0: {1e-8,0,0}, 100: {2e-8,0,0}, }',
                 absent=('Translation',))
        for mode in ('backup_failure', 'replace_failure'):
            path = root / (mode + '.mdl')
            original = (SEQUENCES +
                        'Bone "node" { ObjectId 0, Scaling 1 { DontInterp, 0: {1,1,1}, } }').encode()
            path.write_bytes(original)
            wrapper = root / (mode + '.lua')
            condition = 'true' if mode == 'backup_failure' else 'a:find(".tmp", 1, true) ~= nil'
            wrapper.write_text(
                'local source, target = arg[1], arg[2]\n'
                'local rename = os.rename\n'
                'os.rename = function(a,b) if ' + condition +
                ' then return nil, "injected failure" end return rename(a,b) end\n'
                'arg = {[1] = target}\ndofile(source)\n', encoding='utf-8'
            )
            process = subprocess.run(
                ['lua', str(wrapper), str(script), str(path)],
                capture_output=True, text=True, errors='replace'
            )
            assert process.returncode != 0 and path.read_bytes() == original, (
                mode, process.stdout, process.stderr
            )
            print('PASS:', mode)
    print('PASS: all 24 model compression checks')


if __name__ == '__main__':
    main()
