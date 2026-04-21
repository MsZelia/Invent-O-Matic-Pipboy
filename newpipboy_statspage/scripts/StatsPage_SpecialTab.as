package
{
   import Shared.AS3.BSScrollingList;
   import Shared.GlobalFunc;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol230")]
   public class StatsPage_SpecialTab extends IPipBoyTab
   {
      
      public var List_mc:BSScrollingList;
      
      public var Description_tf:TextField;
      
      public var VBHolder_mc:MovieClip;
      
      private var m_VBLoader:Loader;
      
      private var m_DescText:String = "";
      
      public function StatsPage_SpecialTab()
      {
         super();
         TabIndex = NewPipBoyShared.STATS_TAB_SPECIAL;
         this.List_mc.listEntryClass_Inspectable = "SpecialListEntry";
         this.List_mc.numListItems_Inspectable = 7;
         this.List_mc.restoreListIndex_Inspectable = false;
         this.List_mc.enableScrollWrap = true;
         this.m_VBLoader = new Loader();
         this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
      }
      
      override public function processProvider(aData:Object) : void
      {
         this.List_mc.entryList = aData.SpecialStatsA;
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
      
      private function onListSelectionChange(aEvent:Event) : *
      {
         var loadRequest:URLRequest = null;
         var currContext:LoaderContext = null;
         if(this.List_mc.selectedIndex != -1)
         {
            this.VBHolder_mc.removeChildren();
            if(this.List_mc.selectedIndex < NewPipBoyShared.SPECIAL_CLIP_SWFS.length)
            {
               loadRequest = new URLRequest("Components/VaultBoys/SPECIAL/" + NewPipBoyShared.SPECIAL_CLIP_SWFS[this.List_mc.selectedIndex] + ".swf");
               currContext = new LoaderContext(false,ApplicationDomain.currentDomain);
               this.m_VBLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onVBLoadComplete);
               this.m_VBLoader.load(loadRequest,currContext);
            }
            this.Description_tf.text = this.List_mc.selectedEntry.Description;
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_FOCUS_CHANGE);
         }
      }
      
      override public function ProcessRightThumbstickInput(auiDirection:uint) : Boolean
      {
         switch(auiDirection)
         {
            case NewPipBoyShared.DIRECTION_UP:
               --this.Description_tf.scrollV;
               break;
            case NewPipBoyShared.DIRECTION_DOWN:
               this.Description_tf.scrollV += 1;
         }
         return true;
      }
      
      private function onVBLoadComplete(aEvent:Event) : *
      {
         aEvent.target.removeEventListener(Event.COMPLETE,this.onVBLoadComplete);
         this.VBHolder_mc.addChild(aEvent.target.content);
      }
   }
}

