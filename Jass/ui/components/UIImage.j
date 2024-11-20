library UIImage requires UIComponent
    struct UIImage extends UIComponent
        string texturePath

        method setTexture takes string path returns nothing
            set this.texturePath = path
            call SetFrameTexture(this.handle, path)
        endmethod

        static method create takes string name, framehandle parent returns thistype
            local thistype this = thistype.allocate()
            set this.handle = CreateFrame("BACKDROP", name, parent, 0, 0)
            return this
        endmethod
    endstruct
endlibrary