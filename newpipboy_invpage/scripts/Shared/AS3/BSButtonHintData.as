package Shared.AS3
{
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Data.FromClientDataEvent;
   import Shared.AS3.Data.UIDataFromClient;
   import Shared.AS3.Events.PlatformChangeEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public dynamic class BSButtonHintData extends EventDispatcher
   {
      
      public static const BUTTON_HINT_DATA_CHANGE:String = "ButtonHintDataChange";
      
      public static const EVENT_CONTROL_MAP_DATA:String = "ControlMapData";
      
      private var _strButtonText:String;
      
      private var _strPCKey:String;
      
      private var _strPSNButton:String;
      
      private var _strXenonButton:String;
      
      private var _uiJustification:uint;
      
      private var _callbackFunction:Function;
      
      private var _bButtonDisabled:Boolean;
      
      private var _bSecondaryButtonDisabled:Boolean;
      
      private var _bButtonVisible:Boolean;
      
      private var _bButtonFlashing:Boolean;
      
      private var m_DispatchEvent:String;
      
      private var m_UserEvent:String;
      
      private var _hasSecondaryButton:Boolean;
      
      private var _strSecondaryPCKey:String;
      
      private var _strSecondaryXenonButton:String;
      
      private var _strSecondaryPSNButton:String;
      
      private var _secondaryButtonCallback:Function;
      
      private var m_DisabledButtonCallback:Function;
      
      private var m_CanHold:Boolean = false;
      
      private var m_HoldPercent:Number = 0;
      
      private var m_bIgnorePCKeyMapping:Boolean = false;
      
      private var m_UserEventMapping:String = "";
      
      private var m_bForceUppercase:Boolean = true;
      
      private var _isWarning:Boolean;
      
      private var _strDynamicMovieClipName:String;
      
      public var onAnnounceDataChange:Function;
      
      public var onTextClickDisabled:Function;
      
      public var onTextClick:Function;
      
      public var onSecondaryButtonClick:Function;
      
      public function BSButtonHintData(astrButtonText:String, astrPCKey:String, astrPSNButton:String, astrXenonButton:String, auiJustification:uint, aFunction:Function, aDispatchEvent:String = "", aUserEvent:String = "")
      {
         this.onAnnounceDataChange = this.onAnnounceDataChange_Impl;
         this.onTextClickDisabled = this.onTextClickDisabled_Impl;
         this.onTextClick = this.onTextClick_Impl;
         this.onSecondaryButtonClick = this.onSecondaryButtonClick_Impl;
         super();
         this._strPCKey = astrPCKey;
         this._strButtonText = astrButtonText;
         this._strXenonButton = astrXenonButton;
         this._strPSNButton = astrPSNButton;
         this._uiJustification = auiJustification;
         this._callbackFunction = aFunction;
         this._bButtonDisabled = false;
         this._bButtonVisible = true;
         this._bButtonFlashing = false;
         this.m_DispatchEvent = aDispatchEvent;
         this.m_UserEvent = aUserEvent;
         this._hasSecondaryButton = false;
         this._strSecondaryPCKey = "";
         this._strSecondaryPSNButton = "";
         this._strSecondaryXenonButton = "";
         this._secondaryButtonCallback = null;
         this.m_DisabledButtonCallback = null;
         this._strDynamicMovieClipName = "";
         this._isWarning = false;
      }
      
      public function get PCKey() : String
      {
         return this._strPCKey;
      }
      
      public function get PSNButton() : String
      {
         return this._strPSNButton;
      }
      
      public function get XenonButton() : String
      {
         return this._strXenonButton;
      }
      
      public function get Justification() : uint
      {
         return this._uiJustification;
      }
      
      public function get DispatchEvent() : String
      {
         return this.m_DispatchEvent;
      }
      
      public function get UserEvent() : String
      {
         return this.m_UserEvent;
      }
      
      public function get SecondaryPCKey() : String
      {
         return this._strSecondaryPCKey;
      }
      
      public function get SecondaryPSNButton() : String
      {
         return this._strSecondaryPSNButton;
      }
      
      public function get SecondaryXenonButton() : String
      {
         return this._strSecondaryXenonButton;
      }
      
      public function get DynamicMovieClipName() : String
      {
         return this._strDynamicMovieClipName;
      }
      
      public function set DynamicMovieClipName(aDynamicMovieClipName:String) : void
      {
         if(this._strDynamicMovieClipName != aDynamicMovieClipName)
         {
            this._strDynamicMovieClipName = aDynamicMovieClipName;
            this.AnnounceDataChange();
         }
      }
      
      public function get canHold() : Boolean
      {
         return this.m_CanHold;
      }
      
      public function set canHold(aHold:Boolean) : void
      {
         if(this.m_CanHold != aHold)
         {
            this.m_CanHold = aHold;
            this.AnnounceDataChange();
         }
      }
      
      public function get holdPercent() : Number
      {
         return this.m_HoldPercent;
      }
      
      public function set holdPercent(aPercent:Number) : void
      {
         if(this.m_HoldPercent != aPercent)
         {
            this.m_HoldPercent = aPercent;
            this.AnnounceDataChange();
         }
      }
      
      public function get ignorePCKeyMapping() : Boolean
      {
         return this.m_bIgnorePCKeyMapping;
      }
      
      public function set ignorePCKeyMapping(aBool:Boolean) : void
      {
         if(this.m_bIgnorePCKeyMapping != aBool)
         {
            this.m_bIgnorePCKeyMapping = aBool;
            this.AnnounceDataChange();
         }
      }
      
      public function get forceUppercase() : Boolean
      {
         return this.m_bForceUppercase;
      }
      
      public function set forceUppercase(aBool:Boolean) : void
      {
         if(this.m_bForceUppercase != aBool)
         {
            this.m_bForceUppercase = aBool;
            this.AnnounceDataChange();
         }
      }
      
      public function get userEventMapping() : String
      {
         return this.m_UserEventMapping;
      }
      
      public function set userEventMapping(aString:String) : void
      {
         var controlMapData:UIDataFromClient = null;
         if(this.m_UserEventMapping != aString)
         {
            this.m_UserEventMapping = aString;
            if(this.m_UserEventMapping == "")
            {
               BSUIDataManager.Unsubscribe(EVENT_CONTROL_MAP_DATA,this.onControlMapData);
            }
            else
            {
               BSUIDataManager.Subscribe(EVENT_CONTROL_MAP_DATA,this.onControlMapData);
               controlMapData = BSUIDataManager.GetDataFromClient(EVENT_CONTROL_MAP_DATA);
               if(controlMapData && controlMapData.data && Boolean(controlMapData.data.buttonMappings) && controlMapData.data.uiController != null)
               {
                  this.updateButtonsFromMapping(controlMapData.data.uiController,controlMapData.data.buttonMappings);
               }
            }
            this.AnnounceDataChange();
         }
      }
      
      public function get ButtonDisabled() : Boolean
      {
         return this._bButtonDisabled;
      }
      
      public function set ButtonDisabled(abButtonDisabled:Boolean) : *
      {
         if(this._bButtonDisabled != abButtonDisabled)
         {
            this._bButtonDisabled = abButtonDisabled;
            this.AnnounceDataChange();
         }
      }
      
      public function get ButtonEnabled() : Boolean
      {
         return !this.ButtonDisabled;
      }
      
      public function set ButtonEnabled(abButtonEnabled:Boolean) : void
      {
         this.ButtonDisabled = !abButtonEnabled;
      }
      
      public function get SecondaryButtonDisabled() : Boolean
      {
         return this._bSecondaryButtonDisabled;
      }
      
      public function set SecondaryButtonDisabled(abSecondaryButtonDisabled:Boolean) : *
      {
         if(this._bSecondaryButtonDisabled != abSecondaryButtonDisabled)
         {
            this._bSecondaryButtonDisabled = abSecondaryButtonDisabled;
            this.AnnounceDataChange();
         }
      }
      
      public function get SecondaryButtonEnabled() : Boolean
      {
         return !this.SecondaryButtonDisabled;
      }
      
      public function set SecondaryButtonEnabled(abSecondaryButtonEnabled:Boolean) : void
      {
         this.SecondaryButtonDisabled = !abSecondaryButtonEnabled;
      }
      
      public function get ButtonText() : String
      {
         return this._strButtonText;
      }
      
      public function set ButtonText(astrButtonText:String) : void
      {
         if(this._strButtonText != astrButtonText)
         {
            this._strButtonText = astrButtonText;
            this.AnnounceDataChange();
         }
      }
      
      public function get ButtonVisible() : Boolean
      {
         return this._bButtonVisible;
      }
      
      public function set ButtonVisible(abButtonVisible:Boolean) : void
      {
         if(this._bButtonVisible != abButtonVisible)
         {
            this._bButtonVisible = abButtonVisible;
            this.AnnounceDataChange();
         }
      }
      
      public function get ButtonFlashing() : Boolean
      {
         return this._bButtonFlashing;
      }
      
      public function set ButtonFlashing(abButtonFlashing:Boolean) : void
      {
         if(this._bButtonFlashing != abButtonFlashing)
         {
            this._bButtonFlashing = abButtonFlashing;
            this.AnnounceDataChange();
         }
      }
      
      public function get hasSecondaryButton() : Boolean
      {
         return this._hasSecondaryButton;
      }
      
      public function get IsWarning() : Boolean
      {
         return this._isWarning;
      }
      
      public function set IsWarning(abIsWarning:Boolean) : void
      {
         if(this._isWarning != abIsWarning)
         {
            this._isWarning = abIsWarning;
            this.AnnounceDataChange();
         }
      }
      
      private function AnnounceDataChange() : void
      {
         dispatchEvent(new Event(BUTTON_HINT_DATA_CHANGE));
         if(this.onAnnounceDataChange is Function)
         {
            this.onAnnounceDataChange();
         }
      }
      
      private function onAnnounceDataChange_Impl() : void
      {
      }
      
      public function SetButtons(astrPCKey:String, astrPSNButton:String, astrXenonButton:String) : *
      {
         var buttonChange:Boolean = false;
         if(this._strPCKey != astrPCKey)
         {
            this._strPCKey = astrPCKey;
            buttonChange = true;
         }
         if(this._strPSNButton != astrPSNButton)
         {
            this._strPSNButton = astrPSNButton;
            buttonChange = true;
         }
         if(this._strXenonButton != astrXenonButton)
         {
            this._strXenonButton = astrXenonButton;
            buttonChange = true;
         }
         if(buttonChange)
         {
            this.AnnounceDataChange();
         }
      }
      
      public function SetSecondaryButtons(astrSecondaryPCKey:String, astrSecondaryPSNButton:String, astrSecondaryXenonButton:String) : *
      {
         this._hasSecondaryButton = true;
         var buttonChange:Boolean = false;
         if(this._strSecondaryPCKey != astrSecondaryPCKey)
         {
            this._strSecondaryPCKey = astrSecondaryPCKey;
            buttonChange = true;
         }
         if(this._strSecondaryPSNButton != astrSecondaryPSNButton)
         {
            this._strSecondaryPSNButton = astrSecondaryPSNButton;
            buttonChange = true;
         }
         if(this._strSecondaryXenonButton != astrSecondaryXenonButton)
         {
            this._strSecondaryXenonButton = astrSecondaryXenonButton;
            buttonChange = true;
         }
         if(buttonChange)
         {
            this.AnnounceDataChange();
         }
      }
      
      public function set secondaryButtonCallback(aSecondaryFunction:Function) : *
      {
         this._secondaryButtonCallback = aSecondaryFunction;
      }
      
      public function get disabledButtonCallback() : Function
      {
         return this.m_DisabledButtonCallback;
      }
      
      public function set disabledButtonCallback(aDisabledFunction:Function) : *
      {
         this.m_DisabledButtonCallback = aDisabledFunction;
      }
      
      private function onTextClickDisabled_Impl() : void
      {
         if(this.m_DisabledButtonCallback is Function)
         {
            this.m_DisabledButtonCallback();
         }
      }
      
      private function onTextClick_Impl() : void
      {
         if(this._callbackFunction is Function)
         {
            if(this.m_DispatchEvent != "")
            {
               this._callbackFunction.call(null,this.m_DispatchEvent);
            }
            else
            {
               this._callbackFunction.call();
            }
         }
      }
      
      private function onSecondaryButtonClick_Impl() : void
      {
         if(this._secondaryButtonCallback is Function)
         {
            this._secondaryButtonCallback.call();
         }
      }
      
      private function onControlMapData(aEvent:FromClientDataEvent) : void
      {
         if(this.userEventMapping != "" && aEvent && aEvent.data && Boolean(aEvent.data.buttonMappings) && aEvent.data.uiController != null)
         {
            this.updateButtonsFromMapping(aEvent.data.uiController,aEvent.data.buttonMappings);
         }
      }
      
      private function updateButtonsFromMapping(aUIController:uint, aButtonMappings:Array) : void
      {
         var buttonName:String = null;
         var i:uint = 0;
         if(aUIController != PlatformChangeEvent.PLATFORM_INVALID && this.userEventMapping != "" && (!this.ignorePCKeyMapping || aUIController != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE))
         {
            buttonName = "";
            for(i = 0; i < aButtonMappings.length; i++)
            {
               if(aButtonMappings[i].userEventName == this.userEventMapping)
               {
                  buttonName = aButtonMappings[i].buttonName;
                  break;
               }
            }
            if(buttonName != "")
            {
               switch(aUIController)
               {
                  case PlatformChangeEvent.PLATFORM_PC_KB_MOUSE:
                     this.SetButtons(buttonName,this.PSNButton,this.XenonButton);
                     break;
                  case PlatformChangeEvent.PLATFORM_PS4:
                     this.SetButtons(this.PCKey,buttonName,this.XenonButton);
                     break;
                  case PlatformChangeEvent.PLATFORM_PC_GAMEPAD:
                  case PlatformChangeEvent.PLATFORM_XB1:
                     this.SetButtons(this.PCKey,this.PSNButton,buttonName);
               }
            }
         }
      }
   }
}

