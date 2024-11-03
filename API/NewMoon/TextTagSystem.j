#ifndef TextTagSystemIncluded
#define TextTagSystemIncluded

#include "XYwebase.j"

   //! zinc
   #define radii GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)/CameraFlo
   #define Top   GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)/TopY
   #define Bot   GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)/BotY
   #define diam  GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)/Dis
   #define GetDistance(speed)  speed > diam
   library TextTagSystem requires XYwebase
   {
       constant timer TextTag_Timer = CreateTimer();
       constant real RunningTime = 0.02;
       constant real Defalut = 0.23;
       constant location loc = null;
       constant timer Demo_Timer = CreateTimer();
       constant real CameraFlo = 1.736;
       constant real TopY = 2.75;
       constant real BotY = 3.437;
       constant real Dis  = .868;
       public boolean Mask[11][11];
       public boolean Hide[11];
       integer Struct_Array[];
       integer Struct_NowIndex = 0;
       integer Demo_Array[];
       integer Demo_Index = 0;
       texttag TurnTag = null;
       integer Clear_array[100][11];
       boolean IsTextTagFoggedToAllPlayer = true;
     function GetRandomBoolean() -> boolean
     {
          return GetRandomInt(0,1) == 0;
     }
 
     function GetRad(integer i) -> real
     {
       if (i==1){return radii;}
       else if (i==2){return Top;}
       else if (i==3){return Bot;}
       else if (i==4){return diam;}
       return .0;
     }
     function CheckDisPlayerex(texttag tag,player p)
     {
        integer i = 11;
        while (i >= 0)
        {       if (GetLocalPlayer() == p)
                {
                SetTextTagVisibility( tag, true);
                }
                else if (GetLocalPlayer() != p)
                {
                SetTextTagVisibility( tag, false );
                }
                i = i - 1;
        }
        p = null;
     }
     
     function ResetArray(integer data)
     {
        integer i = 11;
        while (i >= 0)
        {       
                Clear_array[data][i] = 0;
                i = i - 1;
        }
     }
     
     function CheckDisPlayer(texttag tag,real x,real y)
     {
        integer i = 11;
        player p;
        MoveLocation(loc,x,y);
        while (i >= 0)
        {       if (Player(i) == GetLocalPlayer())
                {
                p = GetLocalPlayer();
                if (IsLocationFoggedToPlayer(loc, p) == true) SetTextTagVisibility( tag, false);
                else if (IsLocationFoggedToPlayer(loc, p) == false) SetTextTagVisibility( tag, true );
                }
                p = null;
                i = i - 1;
        }
        p = null;
     }
     
     function CheckZ(real x,real y) -> real
     {
      MoveLocation(loc,x,y);
      return GetLocationZ(loc);
     }
     
     
     function Masking(texttag tag,player p)
     {
       integer i = 11;
           while (i >= 0)
           {      
               if (GetLocalPlayer()==Player(i) && Mask[GetPlayerId(p)][i])
                {
                   SetTextTagVisibility(tag, false);
                }
                i = i - 1;
           }           
     }
     
     
     function MoveDemo(texttag tag,real speed,real y1)
     {
       integer i = 11;
       real x=.0,y=.0,x1=.0;
                x1 = GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)/CameraFlo;
                x = GetCameraTargetPositionX();
                y = GetCameraTargetPositionY();   
                x = x + x1;
                y =  y + y1;
                x = x - speed;
                SetTextTagPos(tag, x, y, CheckZ(x,y));                  
     }
     struct Demo
     {
     texttag tag;
     real speeds;
     real speed;
     real y;
     integer c;
     boolean IsPause;
     static Demo data;

         static method ClearDemo(player p)
    {
        integer i = 0;
        while (i != Demo_Index)
        {
            data = Demo_Array[i];
            Clear_array[data][GetPlayerId(p)] = 1;
            if (GetLocalPlayer() ==p)
            {
               SetTextTagVisibility(data.tag, false);
            }
             i = i + 1;
        }
    }
    
     static method TimeOut()
     {
        real x=.0,y=.0;
        integer i = 0;
        integer i1 = 11;
        while (i != Demo_Index)
        {
            data = Demo_Array[i];
            if (data.IsPause == true)
           {    
                DestroyTextTag(data.tag);
                ResetArray(data);
                Demo_Index = Demo_Index - 1;
                Demo_Array[i] = Demo_Array[Demo_Index];
                i = i - 1;
                data.destroy();
           }
           else
           {
           data.speed = data.speed + data.speeds;
           MoveDemo(data.tag,data.speed,data.y);
           if (GetDistance(data.speed))
           {
             data.c = data.c + 1;
             if (data.c >= 100)
             {
             data.IsPause = true;
             }
           }
           }
             i = i + 1;
        }
        if (Demo_Index == 0)
        {
        PauseTimer(Demo_Timer);
        }
     }


    method onDestroy()
    {
        this.tag = null;
        this.IsPause = false;
        this.speed = .0;
        this.c = 0;
    }
     }
     
   public function ClearDemo(player p)
   {
     XYweuiOpenAll2();
     Demo.ClearDemo(p);
   }
   
   public function DisplayDemo(player p,player p1,boolean is)
   {
       XYweuiOpenAll2();
       Mask[GetPlayerId(p)][GetPlayerId(p1)] = is;
   }
   
   public function Demos(string txt,real speeds,real size)
   {
       real x=.0,y=.0;
       boolean b = GetRandomBoolean();
       Demo dat;
       dat = Demo.create();
       Demo_Array[Demo_Index] = dat;
       Demo_Index = Demo_Index + 1;
       dat.speeds = speeds;
       if (size > 0.5)
       {
       size = 0.5;
       }
       dat.tag = CreateTextTag();
       x = GetCameraTargetPositionX() + GetRad(1);
       y = GetCameraTargetPositionY();
       if (b)
       {
       dat.y = I2R(GetRandomInt(0,R2I(GetRad(2))));
       y = y + dat.y;
       }
       else
       {
       dat.y = I2R(GetRandomInt(0,R2I(GetRad(3))));
       y = y - dat.y;
       dat.y = dat.y * -1.;
       }
       XYweuiOpenAll2();
       SetTextTagText(dat.tag, txt, size * Defalut);
       SetTextTagPos(dat.tag, x, y, .0);
       SetTextTagPermanent( dat.tag, false );
            if (Demo_Index == 1)
            {
            TimerStart(Demo_Timer, RunningTime, true, function Demo.TimeOut);
            }
   }
   
     struct  TextTag
     {
     texttag tag;
     string str;
     unit u;
     real NowSize;
     real MaxSize;
     real ChangeSize;
     real x;
     real y;
     real zOffset;
     boolean IsMaxSize;
     boolean IsPause;
     boolean IsFollowUnit;
     static TextTag data ;
    static method TimeOut()
    {
        integer i = 0;
        while (i != Struct_NowIndex)
        {
            data = Struct_Array[i];
            if (data.IsPause == true)
           {    
                DestroyTextTag(data.tag);
                Struct_NowIndex = Struct_NowIndex - 1;
                Struct_Array[i] = Struct_Array[Struct_NowIndex];
                i = i - 1;
                data.destroy();
           }
           else
           {
           if (data.IsFollowUnit == true)
           {
           data.x = GetUnitX(data.u);
           data.y = GetUnitY(data.u);
           data.zOffset = GetUnitFlyHeight(data.u);
           }
           if (IsTextTagFoggedToAllPlayer == true) CheckDisPlayer(data.tag,data.x,data.y);
           if (data.IsMaxSize == false)
           {
           MoveLocation(loc,data.x,data.y);
           data.zOffset = data.zOffset + GetLocationZ(loc);
           data.NowSize = data.NowSize + data.ChangeSize; 
           SetTextTagText(data.tag, data.str, data.NowSize * Defalut);
           SetTextTagPos(data.tag, data.x, data.y, data.zOffset);
              if (data.NowSize>=data.MaxSize)
              {
              data.IsMaxSize = true;
              }
           }
           else
           {
           data.NowSize = data.NowSize - data.ChangeSize; 
           SetTextTagText(data.tag, data.str, data.NowSize * Defalut);
           SetTextTagPos(data.tag, data.x, data.y, data.zOffset);
              if (data.NowSize<=.0)
              {
              data.IsPause = true;
              }
           }
           }
             i = i + 1;
        }
        if (Struct_NowIndex == 0)
        {
        PauseTimer(TextTag_Timer);
        }
    }
    
    static method RestTextTagLoc(texttag tag,real x,real y)
    {
         integer i = 0;
       while (i !=Struct_NowIndex)
       {
         data = Struct_Array[i];
         if (data.tag == tag)
         {
         data.x = x;
         data.y = y;
         return;
         }
         i = i + 1;
       }
    }
    
    static method FollowUnit(texttag tag,unit u)
    {
         integer i = 0;
       while (i !=Struct_NowIndex)
       {
         data = Struct_Array[i];
         if (data.tag == tag)
         {
         data.IsFollowUnit = true;
         data.u = u;
         return;
         }
         i = i + 1;
       }
    }
    method onDestroy()
    {
                this.tag = null;
                this.u = null;
                this.IsMaxSize = false;
                this.IsPause = false;
                this.IsFollowUnit = false;
                this.NowSize = .0;
    }
    
     }     
   
   public function SetTextTag(real x,real y,real zOffset,string text,/*
   */real MaxSize,real ChangeSize ) -> texttag
   {
       TextTag dat;
       dat = TextTag.create();
       Struct_Array[Struct_NowIndex] = dat;
       Struct_NowIndex = Struct_NowIndex + 1;
       if (MaxSize > 0.5)
       {
       MaxSize = 0.5;
       }
       dat.tag = CreateTextTag();
       dat.zOffset = zOffset;
       dat.str = text;
       SetTextTagText(dat.tag, dat.str, ChangeSize * Defalut);
       SetTextTagPos(dat.tag, x, y, zOffset);
       SetTextTagPermanent( dat.tag, false );
       dat.MaxSize = MaxSize; 
       dat.ChangeSize = ChangeSize;
       dat.x = x;
       dat.y = y;
            if (Struct_NowIndex == 1)
            {
            TimerStart(TextTag_Timer, RunningTime, true, function TextTag.TimeOut);
            }
       return dat.tag;
   }

      public function CreatedTextTag(real x,real y,real zOffset,string text,/*
   */real MaxSize,real ChangeSize )
   {
       bj_lastCreatedTextTag = SetTextTag(x,y,zOffset,text,MaxSize,ChangeSize);
   }
   
   public function RestTextTag(texttag tag,real x,real y)
   {
        TextTag.RestTextTagLoc(tag,x,y);
   }
   
   public function FollowUnit(texttag tag,unit u)
   {
        TextTag.FollowUnit(tag,u);
   }
   
   }
   //! endzinc
   
#endif /// TextTagSystemIncluded
