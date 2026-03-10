package
{
   import flash.events.Event;
   
   public class NewPipboy_StatsPage extends IPipBoyPage
   {
      
      public var StatusTab_mc:StatsPage_StatusTab;
      
      public var SPECIALTab_mc:StatsPage_SpecialTab;
      
      public var EffectsTab_mc:StatsPage_EffectsTab;
      
      public var PerksTab_mc:StatsPage_PerksTab;
      
      public var CollectionsTab_mc:StatsPage_CollectionsTab;
      
      public var TitlesPrefixTab_mc:StatsPage_TitlesTab;
      
      public var TitlesSuffixTab_mc:StatsPage_TitlesTab;
      
      public function NewPipboy_StatsPage()
      {
         super();
         m_EventPrefix = "STATS::";
      }
      
      override public function onAddedToStage(aEvent:Event) : void
      {
         AddTab(this.StatusTab_mc);
         AddTab(this.EffectsTab_mc);
         AddTab(this.PerksTab_mc);
         AddTab(this.SPECIALTab_mc);
         AddTab(this.CollectionsTab_mc);
         AddTab(this.TitlesPrefixTab_mc);
         AddTab(this.TitlesSuffixTab_mc);
      }
      
      override public function processProvider(aData:Object, aType:uint = 0) : void
      {
         PageData = aData;
         if(CurrentTab != null)
         {
            CurrentTab.processProvider(aData);
         }
      }
      
      override public function refreshCurrentTab() : void
      {
         switch(CurrentTabIndex)
         {
            case NewPipBoyShared.STATS_TAB_STATUS:
               CurrentTab = this.StatusTab_mc;
               break;
            case NewPipBoyShared.STATS_TAB_EFFECTS:
               CurrentTab = this.EffectsTab_mc;
               break;
            case NewPipBoyShared.STATS_TAB_PERKS:
               CurrentTab = this.PerksTab_mc;
               break;
            case NewPipBoyShared.STATS_TAB_SPECIAL:
               CurrentTab = this.SPECIALTab_mc;
               break;
            case NewPipBoyShared.STATS_TAB_COLLECTIONS:
               CurrentTab = this.CollectionsTab_mc;
               break;
            case NewPipBoyShared.STATS_TAB_PREFIX:
               CurrentTab = this.TitlesPrefixTab_mc;
               break;
            case NewPipBoyShared.STATS_TAB_SUFFIX:
               CurrentTab = this.TitlesSuffixTab_mc;
               break;
            default:
               CurrentTab = null;
         }
         SetTabVisibility();
      }
      
      override public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
      {
         if(CurrentTab)
         {
            return CurrentTab.ProcessUserEvent(strEventName,abPressed);
         }
         return false;
      }
      
      override public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean, auiController:uint, auiKeyboard:uint) : void
      {
         this.StatusTab_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
         this.EffectsTab_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
         this.PerksTab_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
         this.SPECIALTab_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
         this.CollectionsTab_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
         this.TitlesPrefixTab_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
         this.TitlesSuffixTab_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
      }
      
      override public function set SharedData(aData:Object) : void
      {
         super.SharedData = aData;
         if(CurrentTab == this.StatusTab_mc)
         {
            this.StatusTab_mc.setSharedInfo(aData);
         }
      }
   }
}

