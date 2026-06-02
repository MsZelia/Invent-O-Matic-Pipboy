package Shared.AS3.Events
{
   import flash.events.Event;
   
   public class PlatformChangeEvent extends Event
   {
      
      public static const PLATFORM_PC_KB_MOUSE:uint = 0;
      
      public static const PLATFORM_PC_GAMEPAD:uint = 1;
      
      public static const PLATFORM_XB1:uint = 2;
      
      public static const PLATFORM_PS4:uint = 3;
      
      public static const PLATFORM_MOBILE:uint = 4;
      
      public static const PLATFORM_INVALID:uint = uint.MAX_VALUE;
      
      public static const PLATFORM_PC_KB_ENG:uint = 0;
      
      public static const PLATFORM_PC_KB_FR:uint = 1;
      
      public static const PLATFORM_PC_KB_BE:uint = 2;
      
      public static const PLATFORM_CHANGE:String = "SetPlatform";
      
      internal var _uiPlatform:uint = 4294967295;
      
      internal var _bIsGen9:Boolean = false;
      
      internal var _uiController:uint = 4294967295;
      
      internal var _uiKeyboard:uint = 4294967295;
      
      public function PlatformChangeEvent(auiPlatform:uint, abIsGen9:Boolean, auiController:uint, auiKeyboard:uint)
      {
         super(PLATFORM_CHANGE,true,true);
         this.uiPlatform = auiPlatform;
         this.bIsGen9 = abIsGen9;
         this.uiController = auiController;
         this.uiKeyboard = auiKeyboard;
      }
      
      public function get uiPlatform() : *
      {
         return this._uiPlatform;
      }
      
      public function set uiPlatform(auiPlatform:uint) : *
      {
         this._uiPlatform = auiPlatform;
      }
      
      public function get bIsGen9() : *
      {
         return this._bIsGen9;
      }
      
      public function set bIsGen9(abIsGen9:Boolean) : *
      {
         this._bIsGen9 = abIsGen9;
      }
      
      public function get bPS3Switch() : *
      {
         return this._bIsGen9;
      }
      
      public function get uiController() : *
      {
         return this._uiController;
      }
      
      public function set uiController(auiController:uint) : *
      {
         this._uiController = auiController;
      }
      
      public function get uiKeyboard() : *
      {
         return this._uiKeyboard;
      }
      
      public function set uiKeyboard(auiKeyboard:uint) : *
      {
         this._uiKeyboard = auiKeyboard;
      }
      
      override public function clone() : Event
      {
         return new PlatformChangeEvent(this.uiPlatform,this.bIsGen9,this.uiController,this.uiKeyboard);
      }
   }
}

