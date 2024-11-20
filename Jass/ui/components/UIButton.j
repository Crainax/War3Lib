library UIButton requires UIComponent
    struct UIButton extends UIComponent
        trigger clickTrigger

        method onClick takes code func returns nothing
            call TriggerAddAction(this.clickTrigger, func)
        endmethod

        static method create takes string name, framehandle parent returns thistype
            local thistype this = thistype.allocate()
            set this.handle = CreateFrame("BUTTON", name, parent, 0, 0)
            set this.clickTrigger = CreateTrigger()
            call BlzTriggerRegisterFrameEvent(this.clickTrigger, this.handle, FRAMEEVENT_CONTROL_CLICK)
            return this
        endmethod

        method destroy takes nothing returns nothing
            call DestroyTrigger(this.clickTrigger)
            call super.destroy()
        endmethod
    endstruct
endlibrary