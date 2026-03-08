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
      
      internal var _bPS3Switch:Boolean = false;
      
      internal var _uiController:uint = 4294967295;
      
      internal var _uiKeyboard:uint = 4294967295;
      
      public function PlatformChangeEvent(auiPlatform:uint, abPS3Switch:Boolean, auiController:uint, auiKeyboard:uint)
      {
         super(PLATFORM_CHANGE,true,true);
         this.uiPlatform = auiPlatform;
         this.bPS3Switch = abPS3Switch;
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
      
      public function get bPS3Switch() : *
      {
         return this._bPS3Switch;
      }
      
      public function set bPS3Switch(abPS3Switch:Boolean) : *
      {
         this._bPS3Switch = abPS3Switch;
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
         return new PlatformChangeEvent(this.uiPlatform,this.bPS3Switch,this.uiController,this.uiKeyboard);
      }
   }
}

