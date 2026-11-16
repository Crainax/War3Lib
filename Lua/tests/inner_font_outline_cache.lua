-- Execute the real PIC code/bridges with native-shaped stubs, no Lua FFI callbacks.
local ffi=require 'ffi'
local core=require 'script.experiments.innerjapi.font_outline_cache_core'
local k=ffi.load('kernel32')
local function addr(p)return tonumber(ffi.cast('uintptr_t',p))end
local function mem(n)return ffi.cast('unsigned char*',k.VirtualAlloc(nil,n,0x3000,0x40))end
local function put(p,v)ffi.cast('unsigned int*',p)[0]=v end
local function get(p)return tonumber(ffi.cast('unsigned int*',p)[0])end
local function real(p,v)ffi.cast('float*',p)[0]=v end
local function bytes(p,s)ffi.copy(p,s,#s)end
local function u(v)return string.pack('<I4',v%4294967296)end
local function invoke(p,o)ffi.cast('void (__fastcall *)(void*,void*)',ffi.cast('uintptr_t',p))(o,nil)end
local game=mem(0xBD0000);local code=mem(4096);local counters=mem(128)
local frame,obj,h,group,groups,list,batch=mem(0x250),mem(256),mem(16),mem(32),mem(4),mem(4),mem(96)
put(frame+0x204,addr(h));put(h+8,addr(obj));put(obj+0x50,1);put(obj+0x54,addr(groups));put(groups,addr(group));put(group+12,1);put(group+16,addr(list));put(list,addr(batch));put(obj+0x70,8)
real(frame+0x210,0.001);real(frame+0x214,0);put(obj+44,0xff123456)
for _,a in ipairs({{8,12},{24,12},{40,4},{56,8},{72,2}})do put(batch+a[1],8192);put(batch+a[1]+4,a[1]==72 and 6 or 4);put(batch+a[1]+8,addr(mem(8192*a[2])))end
local m=ffi.cast('float*',get(batch+16));for v=0,255 do m[v*3]=v*10;m[v*3+1]=100;m[v*3+2]=0 end
local uv=ffi.cast('float*',get(batch+64));for v=0,8191 do uv[v*2]=v/8192;uv[v*2+1]=1-v/8192 end
local ix=ffi.cast('unsigned short*',get(batch+80));for q=0,1023 do for i,v in ipairs({0,1,2,2,3,0})do ix[q*6+i-1]=q*4+v end end
real(counters+64,2400);real(counters+68,1800)
for i,r in ipairs({0xD0380,0xD0310})do bytes(game+r,'\xd9\x44\x24\x04\xd8\x0d'..u(addr(counters+60+i*4))..'\xc2\x04\x00')end
bytes(game+0xD7E30,'\x55\x8b\xec\x83\xec\x38\xc9\xc3')
bytes(game+0xAA2D0,'\x53\x8b\xdc\x83\xec\x08\x8b\x81\x04\x02\x00\x00\x8b\x40\x08\x8b\x91\x10\x02\x00\x00\x89\x50\x34\x8b\x91\x14\x02\x00\x00\x89\x50\x38\x8b\xe3\x5b\xc3')
bytes(game+0xD6650,'\x55\x8b\xec\x83\xec\x24\xc9\xc3')
bytes(game+0xA92B0,'\x55\x8b\xec\x6a\xff\x83\xc4\x04\x5d\xc3')
bytes(game+0x98F50,'\x55\x8b\xec\x56\x57\x8b\x45\x08\xa3'..u(addr(counters+72))..'\x5f\x5e\x5d\xc2\x04\x00')
bytes(game+0xD5910,'\x56\x57\x8b\xf1\xe8\xc7\x1c\x00\x00\x5f\x5e\xc3');bytes(game+0xD75E0,'\xc3')
bytes(game+0xDC510,'\xe8\x5b\x71\x00\x00\xc3')
bytes(game+0xE3670,'\xff\x05'..u(addr(counters))..'\xc3')
bytes(game+0xE35B0,'\x89\x0d'..u(addr(counters+4))..'\x89\x15'..u(addr(counters+8))..'\x8b\x44\x24\x10\xa3'..u(addr(counters+12))..'\x8b\x00\xa3'..u(addr(counters+20))..'\x8b\x44\x24\x20\xa3'..u(addr(counters+24))..'\xff\x05'..u(addr(counters+32))..'\x01\x0d'..u(addr(counters+40))..'\xc2\x2c\x00')
bytes(game+0xE3520,'\x89\x15'..u(addr(counters+16))..'\x8b\x44\x24\x04\xa3'..u(addr(counters+28))..'\xff\x05'..u(addr(counters+36))..'\xc2\x04\x00')
local harness='\x55\x8b\xec\x83\xec\x20\x53\x56\x57\xbf'..u(addr(obj))..'\xbe'..u(addr(batch))..'\x31\xdb\xc7\x45\xf0\x00\x00\x00\x00\xc7\x45\xec'..u(0xff000000)
harness=harness..'\xb8'..u(addr(game+0xDC510))..'\xff\xd0\x5f\x5e\x5b\xc9\xc3';bytes(code,harness)
local originalMain=ffi.string(ffi.cast('char*',m),4*12)
core.install(game);core.set(addr(frame),8)
assert(core.validate(addr(frame)));assert(get(batch+12)==4 and get(batch+28)==4 and get(batch+60)==4)
assert(ffi.string(ffi.cast('char*',m),4*12)==originalMain and get(obj+0x70)==0x80000008)
local snap=core.inspect(addr(frame));local cache=ffi.cast('unsigned char*',snap.cache)
assert(get(cache)==1 and get(cache+4)==1 and get(cache+8)==4)
local entry=cache+12+129*4;local points=ffi.cast('float*',get(entry+8))
-- Independent polar reference reconstructed from KK: length+angle, n extra turns.
local radius,angle=2.4,0
for a=1,8 do angle=angle+2*math.pi/9;assert(math.abs(tonumber(points[(a-1)*12])-radius*math.cos(angle))<0.00001);assert(math.abs(tonumber(points[(a-1)*12+1])-100-radius*math.sin(angle))<0.00001)end
invoke(code,nil);assert(get(counters)==2 and get(counters+4)==32 and get(counters+16)==48)
assert(core.stats().extraDraws==8 and core.stats().submissions==1 and core.stats().draws==1)
assert(get(counters+20)==0xff000000 and get(counters+24)==get(entry+16) and get(counters+28)==get(entry+20))
-- Exact primitive expansion: same XYZ, UV and triangle order as eight old draws.
local joined=ffi.cast('unsigned short*',get(entry+20));local joinedUV=ffi.cast('float*',get(entry+16))
for a=0,7 do
 for i=0,5 do assert(joined[a*6+i]==ix[i]+a*4)end
 for i=0,7 do assert(joinedUV[a*8+i]==uv[i])end
end
-- Runtime color/alpha stays a live argument, not baked into the cache.
local alphaHarness=harness:gsub(u(0xff000000),function()return u(0x80402010)end)
local unchanged=core.stats().builds;bytes(code,alphaHarness);invoke(code,nil)
assert(get(counters+20)==0x80402010 and core.stats().builds==unchanged);bytes(code,harness)
local before=core.stats();for i=1,100 do invoke(code,nil)end
assert(core.stats().builds==before.builds and core.stats().allocations==before.allocations and core.stats().reallocations==before.reallocations)
assert(core.validate(addr(frame)) and ffi.string(ffi.cast('char*',m),4*12)==originalMain)
-- Shadow-only and same-address TEXT reconstruction generate caches at the event itself.
invoke(game+0xD6650,obj);assert(core.validate(addr(frame)) and core.stats().shadowUpdates==1)
invoke(game+0xAA2D0,frame);assert(core.validate(addr(frame)) and core.stats().liveBlocks==1)
-- Full reconstruction must retain TEXT-owned allocation even when raw identity changes.
local stable=core.inspect(addr(frame));local counts=core.stats()
for i=1,1000 do invoke(game+0xAA2D0,frame)end
assert(core.inspect(addr(frame)).cache==stable.cache and core.stats().allocations==counts.allocations and core.stats().releases==counts.releases)
local other=mem(256);ffi.copy(other,obj,256);put(other+0x70,8);put(h+8,addr(other))
invoke(game+0xAA2D0,frame);assert(core.validate(addr(frame)) and core.inspect(addr(frame)).cache==stable.cache)
assert(get(obj+0x70)==8 and get(other+0x70)==0x80000008)
put(h+8,addr(obj));invoke(game+0xAA2D0,frame);assert(core.validate(addr(frame)) and get(other+0x70)==8)
real(frame+0x210,-0.001);real(frame+0x214,0.002);core.set(addr(frame),3)
snap=core.inspect(addr(frame));cache=ffi.cast('unsigned char*',snap.cache);entry=cache+12+129*4;points=ffi.cast('float*',get(entry+8))
radius=math.sqrt(2.4^2+3.6^2);angle=math.atan(3.6,-2.4)
for a=1,3 do angle=angle+2*math.pi/4;assert(math.abs(tonumber(points[(a-1)*12])-radius*math.cos(angle))<0.00002);assert(math.abs(tonumber(points[(a-1)*12+1])-100-radius*math.sin(angle))<0.00002)end
core.set(addr(frame),16);assert(core.validate(addr(frame)))
for _,off in ipairs({12,28,44,60})do put(batch+off,256)end;put(batch+76,384)
invoke(game+0xD6650,obj);assert(core.validate(addr(frame)) and core.stats().reallocations>=1)
-- A non-divisible split: 11 copies of 1024 vertices -> 4+4+3, all logical copies survive.
for _,off in ipairs({12,28,44,60})do put(batch+off,1024)end;put(batch+76,1536)
core.set(addr(frame),11);assert(core.validate(addr(frame)));local calls=core.stats();local verts=get(counters+40)
invoke(code,nil)
assert(core.stats().submissions-calls.submissions==3 and core.stats().extraDraws-calls.extraDraws==11)
assert(get(counters+40)-verts==1024*11 and get(counters+4)==3072 and get(counters+16)==4608)
-- The last draw starts at the ninth copy, with zero-based indices/UV again.
snap=core.inspect(addr(frame));entry=ffi.cast('unsigned char*',snap.cache)+12+129*4
assert(get(counters+8)==get(entry+8)+8*1024*12)
-- Above the packing limit each direction uses original UV/indices, without truncation.
for _,off in ipairs({12,28,44,60})do put(batch+off,4100)end;put(batch+76,6150)
for i=6144,6149 do ix[i]=4096+({0,1,2,2,3,0})[i-6143]end
core.set(addr(frame),3);assert(core.validate(addr(frame)));calls=core.stats();invoke(code,nil)
assert(core.stats().submissions-calls.submissions==3 and get(counters+4)==4100 and get(counters+16)==6150)
assert(get(counters+24)==get(batch+64) and get(counters+28)==get(batch+80))
local capacity=core.inspect(addr(frame)).capacity
for _,off in ipairs({12,28,44,60})do put(batch+off,4)end;put(batch+76,6)
invoke(game+0xD6650,obj);assert(core.validate(addr(frame)) and core.inspect(addr(frame)).capacity==capacity)
invoke(game+0xD5910,obj);assert(core.stats().liveBlocks==0 and core.stats().liveBytes==0 and core.stats().active==1 and core.stats().rawDestroys==1)
assert(get(obj+0x70)==8)
invoke(game+0xAA2D0,frame);assert(core.validate(addr(frame)))
invoke(game+0xA92B0,frame);assert(core.stats().active==0 and core.stats().liveBytes==0)
-- Logical destruction releases immediately, passes its stack argument unchanged,
-- and the later real destructor cannot double free the allocation.
core.set(addr(frame),8);local frees=core.stats().releases
ffi.cast('void (__fastcall *)(void*,void*,unsigned int)',ffi.cast('uintptr_t',game+0x98F50))(frame,nil,0x12345678)
assert(get(counters+72)==0x12345678 and core.stats().destroyRequests==1 and core.stats().active==0 and core.stats().liveBytes==0)
invoke(game+0xA92B0,frame);assert(core.stats().releases==frees+1 and core.stats().lastDestroyedFrame==addr(frame))
-- Destruction re-entering from original frame reconstruction cannot resurrect a slot.
core.set(addr(frame),8);local body=ffi.string(game+0xAA2D6,64)
bytes(game+0xAA2D6,'\x6a\x01\xb8'..u(addr(game+0x98F50))..'\xff\xd0\x8b\xe3\x5b\xc3')
invoke(game+0xAA2D0,frame)
assert(core.stats().active==0 and core.stats().liveBytes==0 and core.inspect(addr(frame))==nil)
bytes(game+0xAA2D6,body)
local last=core.stop();assert(last.errors==0 and last.liveBlocks==0)
assert(ffi.string(game+0xDC510,5)=='\xe8\x5b\x71\x00\x00' and ffi.string(game+0xD5910,9)=='\x56\x57\x8b\xf1\xe8\xc7\x1c\x00\x00')
assert(ffi.string(game+0x98F50,5)=='\x55\x8b\xec\x56\x57')
print('PASS: separate cache geometry/ABI, 1000 full rebuilds reuse capacity, changed raw identity, growth/shrink, request-time cleanup, deferred destructor, reentrant destruction, raw cleanup, zero live memory, restored hooks')
