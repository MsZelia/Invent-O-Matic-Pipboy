package
{
   import Shared.EnumHelper;
   
   public class NewPipBoyShared
   {
      
      public static const PAGE_SET:String = "NewPipBoyMenu::PageSet";
      
      public static const TAB_SET:String = "NewPipBoyMenu::TabSet";
      
      public static const PAGE_CYCLE:String = "NewPipBoyMenu::PageCycle";
      
      public static const TAB_CYCLE:String = "NewPipBoyMenu::TabCycle";
      
      public static const REQUEST_PLACE_CAMP:String = "NewPipBoyMenu::RequestPlaceCampMode";
      
      public static const VIEW_PERKS:String = "NewPipBoyMenu::ViewPerks";
      
      public static const INV_SELECTION_CHANGE:String = "INV::SelectionChange";
      
      public static const INV_DROP_ITEM:String = "INV::Drop";
      
      public static const INV_FAV_ITEM:String = "INV::Fav";
      
      public static const INV_LOCK_ITEM:String = "INV::ToggleLock";
      
      public static const INV_USE_ITEM:String = "INV::Use";
      
      public static const INV_INSPECT_ITEM:String = "INV::Inspect";
      
      public static const INV_TAG_SEARCH:String = "INV::TagForSearch";
      
      public static const INV_TOGGLE_SUBVIEW:String = "INV::ToggleSubView";
      
      public static const INV_TOGGLE_COMPONENT_VIEW:String = "INV::ToggleComponentView";
      
      public static const INV_SORT:String = "INV::Sort";
      
      public static const INV_TOGGLE_QUANTITY_MODAL:String = "INV::ToggleQuantityModal";
      
      public static const RADIO_TOGGLE_ACTIVE:String = "RADIO::ToggleStation";
      
      public static const RADIO_HIGHLIGHT:String = "RADIO::HighlightStation";
      
      public static const DATA_FX_SMALL_TRANSITION:String = "NewPipBoyMenu::PlaySmallTransition";
      
      public static const DATA_ON_QUEST_SELECT:String = "NewPipBoyMenu::onQuestSelection";
      
      public static const DATA_SET_QUEST_ACTIVE:String = "NewPipBoyMenu::SetQuestActive";
      
      public static const DATA_REJECT_QUEST:String = "NewPipBoyMenu::RejectQuest";
      
      public static const DATA_SHOW_ON_MAP:String = "NewPipBoyMenu::ShowOnMap";
      
      public static const DATA_CLEAR_QUEUE:String = "NewPipBoyMenu::ClearQuestInstance";
      
      public static const STAT_NEW_TITLE:String = "STAT::Title";
      
      public static const PAGE_CLICKED:String = "Pipboy_Header::PageClicked";
      
      public static const TAB_CLICKED:String = "Pipboy_Header::TabClicked";
      
      public static const DIRECTION_NONE:uint = EnumHelper.GetEnum(0);
      
      public static const DIRECTION_UP:uint = EnumHelper.GetEnum();
      
      public static const DIRECTION_RIGHT:uint = EnumHelper.GetEnum();
      
      public static const DIRECTION_DOWN:uint = EnumHelper.GetEnum();
      
      public static const DIRECTION_LEFT:uint = EnumHelper.GetEnum();
      
      public static const NULL_PAGE:uint = EnumHelper.GetEnum(0);
      
      public static const STATS_PAGE:uint = EnumHelper.GetEnum();
      
      public static const INV_PAGE:uint = EnumHelper.GetEnum();
      
      public static const DATA_PAGE:uint = EnumHelper.GetEnum();
      
      public static const RADIO_PAGE:uint = EnumHelper.GetEnum();
      
      public static const STATS_TAB_NULL:uint = EnumHelper.GetEnum(0);
      
      public static const STATS_TAB_STATUS:uint = EnumHelper.GetEnum();
      
      public static const STATS_TAB_EFFECTS:uint = EnumHelper.GetEnum();
      
      public static const STATS_TAB_PERKS:uint = EnumHelper.GetEnum();
      
      public static const STATS_TAB_SPECIAL:uint = EnumHelper.GetEnum();
      
      public static const STATS_TAB_COLLECTIONS:uint = EnumHelper.GetEnum();
      
      public static const STATS_TAB_PREFIX:uint = EnumHelper.GetEnum();
      
      public static const STATS_TAB_SUFFIX:uint = EnumHelper.GetEnum();
      
      public static const DATA_TAB_NULL:uint = EnumHelper.GetEnum(0);
      
      public static const DATA_TAB_PRIMARY:uint = EnumHelper.GetEnum();
      
      public static const DATA_TAB_SECONDARY:uint = EnumHelper.GetEnum();
      
      public static const DATA_TAB_DAILY:uint = EnumHelper.GetEnum();
      
      public static const DATA_TAB_LEADS:uint = EnumHelper.GetEnum();
      
      public static const DATA_TAB_MISC:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_NULL:uint = EnumHelper.GetEnum(0);
      
      public static const INV_TAB_NEW:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_WEAPONS:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_ARMOR:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_APPAREL:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_FOODWATER:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_AID:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_MISC:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_HOLO:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_NOTES:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_JUNK:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_MODS:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_AMMO:uint = EnumHelper.GetEnum();
      
      public static const INV_TAB_NAMES:* = new Array("","$InventoryCategoryNew","$InventoryCategoryWeapons","$InventoryCategoryArmor","$InventoryCategoryApparel","$InventoryCategoryFoodWater","$InventoryCategoryAid","$InventoryCategoryMisc","$InventoryCategoryHolo","$InventoryCategoryNotes","$InventoryCategoryJunk","$InventoryCategoryMods","$InventoryCategoryAmmo");
      
      public static const DATA_TAB_NAMES:* = new Array("","$QUESTS_PRIMARY","$QUESTS_SECONDARY","$QUESTS_DAILY","$QUESTS_LEADS","$QUESTS_MISC");
      
      public static const DATA_TAB_PROVIDER:* = new Array("","PipBoyDATAMainQuestProvider","PipBoyDATASideQuestProvider","PipBoyDATADailyQuestProvider","PipBoyDATALeadsQuestProvider","PipBoyDATAMiscQuestProvider");
      
      public static const STATS_TAB_NAMES:* = new Array("","$PipboyConditionCategory","$ACTIVE EFFECTS","$PipboyPerksCategory","$PipboySPECIALCategory","$PipboyCollectionsCategory","$NAME_PREFIX","$NAME_SUFFIX");
      
      public static const SPECIAL_CLIP_SWFS:* = new Array("Strength","Perception","Endurance","Charisma","Intelligence","Agility","Luck");
      
      private static const ALL_PROVIDERS:Vector.<Vector.<String>> = new <Vector.<String>>[new <String>[""],new <String>["PipBoySTATStatusProvider","PipBoySTATSEffectsProvider","PipBoySTATSSpecialProvider","PipBoySTATSCollectionsProvider","PipBoySTATSTitlesProvider"],new <String>["PipBoyINVProvider","PipBoyINVSelectionProvider"],new <String>["PipBoyDATAMainSideDailyQuestProvider","PipBoyDATALeadsMiscQuestProvider"],new <String>["PipBoyRADIOProvider"]];
      
      public function NewPipBoyShared()
      {
         super();
      }
      
      public static function GetProviderForPageTab(aPage:uint, aTab:*) : String
      {
         var provider:String = "";
         switch(aPage)
         {
            case STATS_PAGE:
               switch(aTab)
               {
                  case STATS_TAB_STATUS:
                     provider = ALL_PROVIDERS[STATS_PAGE][0];
                     break;
                  case STATS_TAB_EFFECTS:
                  case STATS_TAB_PERKS:
                     provider = ALL_PROVIDERS[STATS_PAGE][1];
                     break;
                  case STATS_TAB_SPECIAL:
                     provider = ALL_PROVIDERS[STATS_PAGE][2];
                     break;
                  case STATS_TAB_COLLECTIONS:
                     provider = ALL_PROVIDERS[STATS_PAGE][3];
                     break;
                  case STATS_TAB_PREFIX:
                  case STATS_TAB_SUFFIX:
                     provider = ALL_PROVIDERS[STATS_PAGE][4];
               }
               break;
            case INV_PAGE:
               provider = ALL_PROVIDERS[INV_PAGE][0];
               break;
            case DATA_PAGE:
               switch(aTab)
               {
                  case DATA_TAB_PRIMARY:
                  case DATA_TAB_SECONDARY:
                  case DATA_TAB_DAILY:
                     provider = ALL_PROVIDERS[DATA_PAGE][0];
                     break;
                  case DATA_TAB_LEADS:
                  case DATA_TAB_MISC:
                     provider = ALL_PROVIDERS[DATA_PAGE][1];
               }
               break;
            case RADIO_PAGE:
               provider = ALL_PROVIDERS[RADIO_PAGE][0];
         }
         return provider;
      }
   }
}

