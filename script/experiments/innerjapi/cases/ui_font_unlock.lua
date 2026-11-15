local M = {}
local jass = require 'jass.common'
local japi = require 'jass.japi'
local font = require 'script.experiments.innerjapi.font_size'
local frames, sample, info, slider, timer, boot, chat = {}, nil, nil, nil, nil, nil, nil
local path = 'Fonts\\dfst-m3u.ttf'
local request, settling, phase, waiting, baseline, lastHeight = 0.084, 0, 1, 0, nil, nil
local values = {0.080, 0.020, 0.040, 0.084, 0.085, 0.086}
local sliderMax=0.1
local thumb,dragging,previousWindowCallback,windowCallback
local function check(ok, description)
    if not ok then font.record('FAIL: '..description) end
    assert(ok, '[InnerFont] ' .. description)
end
local function create(kind, template)
    local f=japi.CreateFrameByTagName(kind, 'FontUnlock' .. (#frames+1), japi.GetGameUI(), template, 0)
    check(f and f~=0, kind .. ' created')
    frames[#frames+1]=f
    return f
end
local function text(value,x,y,size)
    local f=create('TEXT','T1')
    japi.FrameSetAbsolutePoint(f,4,x,y)
    japi.FrameSetText(f,value)
    font.set(f,path,size or 0.005)
    return f
end
local function apply(value)
    request=value
    font.set(sample,path,request)
    settling=3
end
local function setSlider(value)
    value=math.max(0.001,math.min(sliderMax,math.floor(value*100000+0.5)/100000))
    japi.FrameSetAbsolutePoint(thumb,4,0.1+(value-0.001)/(sliderMax-0.001)*0.6,0.18)
    apply(value)
end
local function mouseEvent(id)
    if phase<=#values then return false end
    local x=japi.GetMouseVectorX()/1024*0.8
    local y=(768-japi.GetMouseVectorY())/768*0.6
    if id==1 and x>=0.09 and x<=0.71 and y>=0.165 and y<=0.195 then dragging=true end
    if dragging and (id==1 or id==5) then setSlider(0.001+(x-0.1)/0.6*(sliderMax-0.001));return true end
    if id==2 and dragging then dragging=false;return true end
    return false
end
local function readout()
    local ppem,w,h=font.measure(sample)
    japi.FrameSetText(info,string.format('InnerJAPI single TEXT | request=%.5f | ppem=%d\nW=%.6f H=%.6f | step=0.00001',request,ppem,w,h))
    return ppem,w,h
end
local function tick()
    if phase<=#values then
        if waiting==0 then
            if phase==1 or phase==5 then font.restore() else font.enable() end
            apply(values[phase]); waiting=4
            return
        end
        waiting=waiting-1
        if waiting>0 then return end
        local ppem,w,h=readout()
        check(w>0 and h>0,'nonzero intrinsic dimensions')
        check(math.abs(h-japi.FrameGetTextHeight(sample))<0.00001,'native and InnerJAPI text height agree')
        print(string.format('[InnerFont][SAMPLE] phase=%d handle=%d request=%.5f ppem=%d W=%.8f H=%.8f',phase,sample,request,ppem,w,h))
        if phase==1 then
            check(ppem==32,'baseline capped at 32'); baseline=h
            -- Raw War3 and editor launch may use different resolutions. Derive
            -- requests from the measured baseline instead of assuming 4K pixels.
            local unit=h/ppem
            for i,n in ipairs({50,99,209,211,214}) do values[i+1]=unit*n end
            sliderMax=math.max(0.1,values[6]*1.1)
        elseif phase==5 then
            check(ppem==32 and math.abs(h-baseline)<0.00001,'restore returns same TEXT to 32')
        else
            check(ppem>32,'same TEXT exceeds 32')
            if phase==3 or phase==4 then check(h>lastHeight*1.5,'same TEXT grows with larger request') end
            if phase==6 then check(ppem>96 and h>baseline*6,'unlocked again after restore') end
        end
        lastHeight=h; phase=phase+1
        if phase>#values then
            setSlider(request)
            font.arm_exit()
            font.record('[INNER_FONT_LUA_UI_DONE] same TEXT scan passed')
            print('[INNER_FONT_UI_DONE] font unlock, same TEXT resizing and explicit restore passed')
            if font.exit_test()==1 and not package.inner_font_reload_verified then
                package.inner_font_reload_verified=true
                local reload=jass.CreateTimer()
                jass.TimerStart(reload,0.1,false,function()
                    jass.DestroyTimer(reload)
                    print('[InnerFont] verifying hot reload: destroy UI, restore, recreate and unlock again')
                    require('script.experiments.innerjapi.runner').reload()
                end)
                return
            end
            if font.exit_test()>0 then
                print('[InnerFont] requesting actual map exit; Lua VM finalizer will restore clamps')
                jass.EndGame(false)
            end
        end
        return
    end
    if settling>0 then settling=settling-1; if settling==0 then readout() end end
end
local function guarded_tick()
    local ok,err=xpcall(tick,debug.traceback)
    if not ok then
        font.record('FAIL: '..tostring(err))
        print('FAIL: [InnerFont] '..tostring(err))
        if timer then jass.PauseTimer(timer) end
        pcall(font.restore)
    end
end
local function build()
    font.init()
    japi.LoadToc('ui\\Crainax.toc')
    sample=text('Ag09 中文',0.4,0.40,0.008)
    info=text('',0.4,0.25,0.0045)
    text('InnerJAPI font unlock | Lua only\nOne TEXT, original font. Slider adapts to client resolution.',0.4,0.55,0.005)
    text('-font 0.04 : exact size | -font-exit : leave map and verify restore\n-lua-reload : destroy UI, restore, reload',0.4,0.12,0.0045)
    slider=create('BACKDROP','')
    japi.FrameSetSize(slider,0.60,0.015); japi.FrameSetAbsolutePoint(slider,4,0.4,0.18)
    japi.FrameSetTexture(slider,'ui\\slider\\nandu_slider_bg.blp',0)
    thumb=create('BACKDROP','')
    japi.FrameSetSize(thumb,0.015,0.024)
    japi.FrameSetTexture(thumb,'ui\\slider\\nandu_slider_button.blp',0)
    japi.FrameSetAbsolutePoint(thumb,4,0.1,0.18)
    previousWindowCallback=_G.WindowEventCallBack
    windowCallback=function(id)
        if mouseEvent(id) then return true end
        if previousWindowCallback then return previousWindowCallback(id) end
        return false
    end
    _G.WindowEventCallBack=windowCallback
    chat=jass.CreateTrigger()
    jass.TriggerRegisterPlayerChatEvent(chat,jass.GetLocalPlayer(),'-',false)
    jass.TriggerAddAction(chat,function()
        if phase<=#values then return end
        local message=jass.GetEventPlayerChatString()
        if message=='-font-exit' then font.arm_exit(); jass.EndGame(false); return end
        local n=tonumber(message:match('^%-font%s+([%d.]+)$'))
        if n and n>=0.001 and n<=sliderMax then setSlider(n) end
    end)
    timer=jass.CreateTimer(); jass.TimerStart(timer,0.2,true,guarded_tick)
end
function M.start()
    assert(not timer and not boot,'Font test already running')
    boot=jass.CreateTimer()
    jass.TimerStart(boot,1.5,false,function()
        jass.DestroyTimer(boot); boot=nil
        local ok,err=xpcall(build,debug.traceback)
        if not ok then font.record('FAIL: '..tostring(err)); print('FAIL: [InnerFont] '..tostring(err)); M.stop() end
    end)
end
function M.stop()
    for _,t in ipairs({boot or false,timer or false}) do if t then jass.PauseTimer(t); jass.DestroyTimer(t) end end
    boot,timer=nil,nil
    if chat then jass.DestroyTrigger(chat); chat=nil end
    if _G.WindowEventCallBack==windowCallback then _G.WindowEventCallBack=previousWindowCallback end
    windowCallback,previousWindowCallback,dragging=nil,nil,false
    for i=#frames,1,-1 do japi.DestroyFrame(frames[i]) end
    frames={}; sample,info,slider=nil,nil,nil
    font.restore()
end
return M
