package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class IPipBoyPage extends MovieClip
   {
      
      private var m_CurrentTab:IPipBoyTab;
      
      private var m_CurrentTabIndex:uint = 0;
      
      private var m_PageData:Object;
      
      private var m_SharedData:Object;
      
      private var m_SelectedID:uint = 4294967295;
      
      private var m_Tabs:Vector.<IPipBoyTab> = new Vector.<IPipBoyTab>();
      
      protected var m_EventPrefix:String = "NULL::";
      
      public function IPipBoyPage()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function get CurrentTabIndex() : uint
      {
         return this.m_CurrentTabIndex;
      }
      
      public function set CurrentTabIndex(aIndex:uint) : *
      {
         if(this.m_CurrentTabIndex != aIndex)
         {
            this.m_CurrentTabIndex = aIndex;
         }
      }
      
      protected function get CurrentTab() : IPipBoyTab
      {
         return this.m_CurrentTab;
      }
      
      protected function set CurrentTab(aTab:IPipBoyTab) : void
      {
         if(this.m_CurrentTab != aTab)
         {
            this.m_CurrentTab = aTab;
         }
      }
      
      public function get SharedData() : Object
      {
         return this.m_SharedData;
      }
      
      public function set SharedData(aData:Object) : void
      {
         this.m_SharedData = aData;
      }
      
      public function get PageData() : Object
      {
         return this.m_PageData;
      }
      
      public function set PageData(aData:Object) : void
      {
         this.m_PageData = aData;
      }
      
      public function get SelectedID() : uint
      {
         return this.m_CurrentTab != null ? this.m_CurrentTab.SelectedID : this.m_SelectedID;
      }
      
      public function set SelectedID(aID:uint) : *
      {
         this.m_SelectedID = aID;
      }
      
      public function get EventPrefix() : String
      {
         return this.m_EventPrefix;
      }
      
      public function AddTab(aTab:IPipBoyTab) : void
      {
         if(this.m_Tabs.length == 0)
         {
            this.m_Tabs.push(null);
         }
         aTab.SetVisibility(false);
         this.m_Tabs.push(aTab);
      }
      
      public function SetVisibility(aVisible:Boolean) : void
      {
         this.SetTabVisibility(aVisible);
         var changed:* = this.visible != aVisible;
         this.visible = aVisible;
         if(aVisible && changed)
         {
            this.OnEntry();
         }
      }
      
      protected function SetTabVisibility(aVisible:Boolean = true) : void
      {
         for(var i:uint = 0; i < this.m_Tabs.length; i++)
         {
            if(this.m_Tabs[i])
            {
               this.m_Tabs[i].SetVisibility(aVisible && i == this.m_CurrentTabIndex);
            }
         }
      }
      
      public function CanSwitchTabs(aEventName:String, aDirection:int) : Boolean
      {
         var canSwitch:Boolean = true;
         if(this.m_Tabs.length != 0 && this.CurrentTab != null)
         {
            canSwitch = this.CurrentTab.CanSwitchTabs(aEventName);
         }
         return canSwitch;
      }
      
      public function processProvider(aData:Object, aType:uint = 0) : void
      {
      }
      
      public function onAddedToStage(aEvent:Event) : void
      {
      }
      
      public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
      {
         return false;
      }
      
      public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean, auiController:uint, auiKeyboard:uint) : void
      {
      }
      
      public function OnEntry() : void
      {
      }
      
      public function refreshCurrentTab() : void
      {
      }
      
      public function ProcessRightThumbstickInput(auiDirection:uint) : Boolean
      {
         if(this.CurrentTab)
         {
            return this.CurrentTab.ProcessRightThumbstickInput(auiDirection);
         }
         return false;
      }
   }
}

