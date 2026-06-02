package
{
   import Shared.AS3.BSScrollingList;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol228")]
   public class StatsPage_CollectionsTab extends IPipBoyTab
   {
      
      private static const SPACING:uint = 10;
      
      public var List_mc:BSScrollingList;
      
      public var Description_tf:TextField;
      
      public var Capacity_tf:TextField;
      
      public function StatsPage_CollectionsTab()
      {
         super();
         TabIndex = NewPipBoyShared.STATS_TAB_COLLECTIONS;
         this.List_mc.listEntryClass_Inspectable = "CollectionsListEntry";
         this.List_mc.numListItems_Inspectable = 12;
         this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectionChange);
         this.List_mc.enableScrollWrap = true;
      }
      
      override public function processProvider(aData:Object) : void
      {
         this.List_mc.entryList = aData.CollectionsA;
         this.List_mc.InvalidateData();
         this.List_mc.selectedIndex = 0;
      }
      
      override public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean, auiController:uint, auiKeyboard:uint) : void
      {
         this.List_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
      }
      
      override public function OnEntry() : void
      {
         stage.focus = this.List_mc;
      }
      
      private function onSelectionChange(aEvent:Event) : void
      {
         var obj:Object = this.List_mc.selectedEntry;
         this.Description_tf.text = obj.Description;
         this.Capacity_tf.text = obj.CapacityText;
         this.Capacity_tf.y = this.Description_tf.y + this.Description_tf.textHeight + SPACING;
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_FOCUS_CHANGE);
      }
   }
}

