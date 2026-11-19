import struct,json,hashlib,argparse
from pathlib import Path
parser=argparse.ArgumentParser()
parser.add_argument('--input',default='Output/font-style/outline-core.elf')
parser.add_argument('--output',default='script/experiments/innerjapi/font_outline_core_bytes.lua')
parser.add_argument('--manifest',default='Output/font-style/outline-core.json')
args=parser.parse_args()
b=Path(args.input).read_bytes()
assert b[:6]==b'\x7fELF\x01\x01'
shoff=struct.unpack_from('<I',b,32)[0];ents,num,strings=struct.unpack_from('<HHH',b,46)
sections=[struct.unpack_from('<10I',b,shoff+i*ents) for i in range(num)]
assert not any(s[1] in (4,9) and s[5] for s in sections),'unresolved relocation'
for section in sections:
 if section[1]==6:
  assert all(struct.unpack_from('<I',b,off)[0]!=1 for off in range(section[4],section[4]+section[5],8)), 'external library dependency'
# Copy only allocated sections to their link-time offsets; PC-relative code needs no loader.
end=max(s[3]+s[5] for s in sections if s[2]&2)
image=bytearray(end)
for s in sections:
 if s[2]&2 and s[1]!=8:image[s[3]:s[3]+s[5]]=b[s[4]:s[4]+s[5]]
symbols={}
for s in sections:
 if s[1]!=2:continue
 st=sections[s[6]];names=b[st[4]:st[4]+st[5]]
 for off in range(s[4],s[4]+s[5],s[9]):
  name,value,size,info,other,section=struct.unpack_from('<IIIBBH',b,off)
  name=names[name:].split(b'\0',1)[0].decode()
  if name.startswith('outline_'):symbols[name]=value
parts=['"'+''.join('\\%03d'%c for c in image[i:i+512])+'"' for i in range(0,len(image),512)]
Path(args.output).write_text('-- Generated PIC x86 code/data, no DLL/imports/relocations. See research/innerjapi-font-outline-core.\nreturn {offsets={'+','.join(k+'='+str(v) for k,v in symbols.items())+'},bytes='+ '\n..'.join(parts)+'}\n',encoding='utf-8')
Path(args.manifest).write_text(json.dumps({'bytes':len(image),'sha256':hashlib.sha256(image).hexdigest(),'offsets':symbols},indent=2))
print(len(image),symbols)
