from pathlib import Path
import re
root=Path(__file__).parent
rows=re.findall(r'^\s*(\d+)\s+[0-9A-F]+\s+[0-9A-F]+\s+(\w+)\s*$',(root/'exports.txt').read_text(encoding='utf-8-sig'),re.M)
assert len(rows)>360
names=',\n'.join('"'+name+'"' for _,name in rows)
(root/'exports.inc').write_text('static const char* names[]={'+names+'};\nstatic const unsigned count=sizeof(names)/sizeof(*names);\nextern "C" { FARPROC targets[count]={}; }\n')
asm=['.386','.model flat, C','extern prepareGL:proc','extern targets:dword','.code']
exports=['LIBRARY OPENGL32','EXPORTS']
for i,(ordinal,name) in enumerate(rows):
    if name=='wglSwapLayerBuffers':
        exports.append(f'{name}=_captureSwap@8 @{ordinal}')
        continue
    sym=f'forward{i}'
    asm.extend([sym+' proc',f'cmp DWORD PTR [targets+{4*i}],0','jne loaded'+str(i),'pushad','call prepareGL','popad','loaded'+str(i)+':',f'jmp DWORD PTR [targets+{4*i}]',sym+' endp'])
    exports.append(f'{name}={sym} @{ordinal}')
(root/'forward.asm').write_text('\n'.join(asm+['end','']))
(root/'render.def').write_text('\n'.join(exports)+'\n')
