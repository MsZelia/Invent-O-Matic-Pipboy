package
{
   import flash.display.MovieClip;
   
   public class IPipBoyTab extends MovieClip
   {
      
      private var m_TabIndex:uint = 0;
      
      private var m_SelectedID:uint = 4294967295;
      
      public function IPipBoyTab()
      {
         super();
      }
      
      public function get SelectedID() : uint
      {
         return this.m_SelectedID;
      }
      
      public function get TabIndex() : uint
      {
         return this.m_TabIndex;
      }
      
      public function set TabIndex(aIndex:uint) : void
      {
         if(this.m_TabIndex != aIndex)
         {
            this.m_TabIndex = aIndex;
         }
      }
      
      public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean, auiController:uint, auiKeyboard:uint) : void
      {
      }
      
      public function processProvider(aData:Object) : void
      {
      }
      
      public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
      {
         return false;
      }
      
      public function SetVisibility(aVisible:Boolean) : void
      {
         if(this.visible != aVisible)
         {
            if(aVisible)
            {
               this.OnEntry();
            }
            else
            {
               this.OnExit();
            }
            this.visible = aVisible;
         }
      }
      
      public function CanSwitchTabs(aEventName:String) : Boolean
      {
         return true;
      }
      
      public function OnEntry() : void
      {
      }
      
      public function OnExit() : void
      {
      }
      
      public function ProcessRightThumbstickInput(auiDirection:uint) : Boolean
      {
         return false;
      }
   }
}

