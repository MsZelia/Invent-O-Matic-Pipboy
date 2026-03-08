package Shared
{
   import Shared.AS3.BCGridList;
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.SWFLoaderClip;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.fscommand;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   import flash.utils.ByteArray;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import scaleform.gfx.Extensions;
   
   public class GlobalFunc
   {
      
      public static const PIPBOY_GREY_OUT_ALPHA:Number = 0.5;
      
      public static const SELECTED_RECT_ALPHA:Number = 1;
      
      public static const DIMMED_ALPHA:Number = 0.65;
      
      public static const NUM_DAMAGE_TYPES:uint = 6;
      
      public static const PLAYER_ICON_TEXTURE_BUFFER:String = "AvatarTextureBuffer";
      
      public static const STORE_IMAGE_TEXTURE_BUFFER:String = "StoreTextureBuffer";
      
      public static const ACCOUNT_UPGRADES_STORE_IMAGE_TEXTURE_BUFFER:String = "AccountUpgradesStoreTextureBuffer";
      
      public static const MAP_TEXTURE_BUFFER:String = "MapMenuTextureBuffer";
      
      public static const CHARACTER_PROFILE_TEXTURE_BUFFER:String = "CharacterProfileTextureBuffer";
      
      protected static const CLOSE_ENOUGH_EPSILON:Number = 0.001;
      
      public static const MAX_TRUNCATED_TEXT_LENGTH:* = 42;
      
      public static const PLAY_FOCUS_SOUND:String = "GlobalFunc::playFocusSound";
      
      public static const PLAY_MENU_SOUND:String = "GlobalFunc::playMenuSound";
      
      public static const SHOW_HUD_MESSAGE:String = "GlobalFunc::showHUDMessage";
      
      public static const MENU_SOUND_OK:String = "UIMenuOK";
      
      public static const MENU_SOUND_CANCEL:String = "UIMenuCancel";
      
      public static const MENU_SOUND_PREV_NEXT:String = "UIMenuPrevNext";
      
      public static const MENU_SOUND_POPUP:String = "UIMenuPopupGeneric";
      
      public static const MENU_SOUND_FOCUS_CHANGE:String = "UIMenuFocus";
      
      public static const MENU_SOUND_FRIEND_PROMPT_OPEN:String = "UIMenuPromptFriendRequestBladeOpen";
      
      public static const MENU_SOUND_FRIEND_PROMPT_CLOSE:String = "UIMenuPromptFriendRequestBladeClose";
      
      public static const BUTTON_BAR_ALIGN_CENTER:uint = 0;
      
      public static const BUTTON_BAR_ALIGN_LEFT:uint = 1;
      
      public static const BUTTON_BAR_ALIGN_RIGHT:uint = 2;
      
      public static const COLOR_TEXT_BODY:uint = 16777163;
      
      public static const COLOR_TEXT_HEADER:uint = 16108379;
      
      public static const COLOR_TEXT_SELECTED:uint = 1580061;
      
      public static const COLOR_TEXT_FRIEND:uint = COLOR_TEXT_HEADER;
      
      public static const COLOR_TEXT_ENEMY:uint = 16741472;
      
      public static const COLOR_TEXT_UNAVAILABLE:uint = 5661031;
      
      public static const COLOR_BACKGROUND_BOX:uint = 3225915;
      
      public static const COOR_WARNING:uint = 15089200;
      
      public static const COLOR_WARNING_ACCENT:uint = 16151129;
      
      public static const COLOR_RARITY_LEGENDARY:uint = 15046481;
      
      public static const COLOR_RARITY_EPIC:uint = 10763770;
      
      public static const COLOR_RARITY_RARE:uint = 4960214;
      
      public static const COLOR_RARITY_COMMON:uint = 9043803;
      
      public static const FRAME_RARITY_NONE:String = "None";
      
      public static const FRAME_RARITY_COMMON:String = "Common";
      
      public static const FRAME_RARITY_RARE:String = "Rare";
      
      public static const FRAME_RARITY_EPIC:String = "Epic";
      
      public static const FRAME_RARITY_LEGENDARY:String = "Legendary";
      
      public static var TEXT_SIZE_VERYSMALL:Number = 16;
      
      public static var TEXT_SIZE_MIN:Number = 14;
      
      public static var TEXT_LEADING_MIN:Number = -2;
      
      public static var MINIMUM_FONT_SIZE:Number = 27;
      
      public static const VOICE_STATUS_UNAVAILABLE:uint = 0;
      
      public static const VOICE_STATUS_AVAILABLE:uint = 1;
      
      public static const VOICE_STATUS_SPEAKING:uint = 2;
      
      public static const FIRST_PARTY_PLATFORM_BNET:uint = 0;
      
      public static const FIRST_PARTY_PLATFORM_XBL:uint = 1;
      
      public static const FIRST_PARTY_PLATFORM_PSN:uint = 2;
      
      public static const FIRST_PARTY_PLATFORM_STEAM:uint = 3;
      
      public static const FIRST_PARTY_PLATFORM_MSSTORE:uint = 4;
      
      public static const WORLD_TYPE_INVALID:uint = 0;
      
      public static const WORLD_TYPE_NORMAL:uint = 1;
      
      public static const WORLD_TYPE_SURVIVAL:uint = 2;
      
      public static const WORLD_TYPE_NWTEMP:uint = 3;
      
      public static const WORLD_TYPE_NUCLEARWINTER:uint = 4;
      
      public static const WORLD_TYPE_PRIVATE:uint = 5;
      
      public static const WORLD_TYPE_OPENCUSTOM:uint = 6;
      
      public static const WORLD_TYPE_PUBLICCUSTOM:uint = 7;
      
      public static const QUEST_DISPLAY_TYPE_NONE:uint = 0;
      
      public static const QUEST_DISPLAY_TYPE_MAIN:uint = 1;
      
      public static const QUEST_DISPLAY_TYPE_SIDE:uint = 2;
      
      public static const QUEST_DISPLAY_TYPE_MISC:uint = 3;
      
      public static const QUEST_DISPLAY_TYPE_EVENT:uint = 4;
      
      public static const QUEST_DISPLAY_TYPE_OTHER:uint = 5;
      
      public static const QUEST_DISPLAY_TYPE_FUEL:uint = 6;
      
      public static const STAT_VALUE_TYPE_INTEGER:uint = 0;
      
      public static const STAT_VALUE_TYPE_TIME:uint = 1;
      
      public static const STAT_VALUE_TYPE_CAPS:uint = 2;
      
      public static var STAT_TYPE_INVALID:uint = 20;
      
      public static var STAT_TYPE_SURVIVAL_SCORE:* = 29;
      
      public static const EVENT_USER_CONTEXT_MENU_ACTION:String = "UserContextMenu::MenuOptionSelected";
      
      public static const EVENT_OPEN_USER_CONTEXT_MENU:String = "UserContextMenu::UserSelected";
      
      public static const USER_MENU_CONTEXT_ALL:uint = 0;
      
      public static const USER_MENU_CONTEXT_FRIENDS:uint = 1;
      
      public static const USER_MENU_CONTEXT_TEAM:uint = 2;
      
      public static const USER_MENU_CONTEXT_RECENT:uint = 3;
      
      public static const USER_MENU_CONTEXT_BLOCKED:uint = 4;
      
      public static const USER_MENU_CONTEXT_MAP:uint = 5;
      
      public static const MTX_CURRENCY_ATOMS:uint = 0;
      
      public static const ALIGN_LEFT:uint = 0;
      
      public static const ALIGN_CENTER:uint = 1;
      
      public static const ALIGN_RIGHT:uint = 2;
      
      public static const HOLD_METER_TICK_AMOUNT:Number = 0.0667;
      
      public static const HOLD_METER_DELAY:uint = 250;
      
      public static const DURABILITY_MAX:uint = 100;
      
      public static const DIRECTION_NONE:* = 0;
      
      public static const DIRECTION_UP:* = 1;
      
      public static const DIRECTION_RIGHT:* = 2;
      
      public static const DIRECTION_DOWN:* = 3;
      
      public static const DIRECTION_LEFT:* = 4;
      
      public static const REWARD_TYPE_ENUM_ATOMS:* = 0;
      
      public static const REWARD_TYPE_ENUM_PERK_PACKS:* = 1;
      
      public static const REWARD_TYPE_ENUM_PHOTO_FRAMES:* = 2;
      
      public static const REWARD_TYPE_ENUM_EMOTES:* = 3;
      
      public static const REWARD_TYPE_ENUM_ICONS:* = 4;
      
      public static const REWARD_TYPE_ENUM_WEAPON:* = 5;
      
      public static const REWARD_TYPE_ENUM_WEAPON_MOD:* = 6;
      
      public static const REWARD_TYPE_ENUM_ARMOR:* = 7;
      
      public static const REWARD_TYPE_ENUM_ARMOR_MOD:* = 8;
      
      public static const REWARD_TYPE_ENUM_AMMO:* = 9;
      
      public static const REWARD_TYPE_ENUM_PHOTO_POSE:* = 10;
      
      public static const REWARD_TYPE_ENUM_COMPONENTS:* = 11;
      
      public static const REWARD_TYPE_ENUM_EXPERIENCE:* = 12;
      
      public static const REWARD_TYPE_ENUM_BADGES:* = 13;
      
      public static const REWARD_TYPE_ENUM_STIMPAKS:* = 14;
      
      public static const REWARD_TYPE_ENUM_CHEMS:* = 15;
      
      public static const REWARD_TYPE_ENUM_BOOK:* = 16;
      
      public static const REWARD_TYPE_ENUM_CAPS:* = 17;
      
      public static const REWARD_TYPE_ENUM_LEGENDARY_TOKENS:* = 18;
      
      public static const REWARD_TYPE_ENUM_POSSUM_BADGES:* = 19;
      
      public static const REWARD_TYPE_ENUM_TADPOLE_BADGES:* = 20;
      
      public static const REWARD_TYPE_ENUM_CUSTOM_ICON:* = 21;
      
      public static const REWARD_TYPE_ENUM_CAMP:* = 22;
      
      public static const REWARD_TYPE_ENUM_GOLD_BULLION:* = 23;
      
      public static const REWARD_TYPE_ENUM_SCORE:* = 24;
      
      public static const REWARD_TYPE_ENUM_ULTRACITE_BATTERY_FUEL:* = 25;
      
      public static const REWARD_TYPE_ENUM_REPAIR_KIT:* = 26;
      
      public static const REWARD_TYPE_ENUM_LUNCH_BOX:* = 27;
      
      public static const REWARD_TYPE_ENUM_PREMIUM:* = 28;
      
      public static const REWARD_TYPE_ENUM_SCORE_BOOST:* = 29;
      
      public static const REWARD_TYPE_ENUM_STAMPS:* = 30;
      
      public static const REWARD_TYPE_ENUM_SCOUT_BANNER:* = 31;
      
      public static const REWARD_TYPE_ENUM_FOOD_AND_DRINK:* = 32;
      
      public static const REWARD_TYPE_ENUM_RE_ROLLER:* = 33;
      
      public static const REWARD_TYPE_ENUM_PERK_COIN:* = 34;
      
      public static const REWARD_TYPE_ENUM_SCORE_BOOSTER_CONSUMABLE:* = 35;
      
      public static const REWARD_TYPE_ENUM_SCOUT_BACKPACK:* = 36;
      
      public static const REWARD_TYPE_ENUM_FLAIR:* = 37;
      
      public static const REWARD_TYPE_ENUM_TICKETS:* = 38;
      
      public static const REWARD_TYPE_ENUM_PLAYER_TITLE:* = 39;
      
      public static const CUSTOM_TITLE_DELIMITER:* = "<";
      
      public static const CUSTOM_TITLE_DIVIDER:* = " |";
      
      private static const ButtonMappingToFontKey:Object = {
         "Xenon_A":"A",
         "Xenon_B":"B",
         "Xenon_X":"C",
         "Xenon_Y":"D",
         "Xenon_Select":"E",
         "Xenon_LS":"F",
         "Xenon_L1":"G",
         "Xenon_L3":"H",
         "Xenon_L2":"I",
         "Xenon_L2R2":"J",
         "Xenon_RS":"K",
         "Xenon_R1":"L",
         "Xenon_R3":"M",
         "Xenon_R2":"N",
         "Xenon_Start":"O",
         "Xenon_L1R1":"Z",
         "Xenon_Positive":"P",
         "Xenon_Negative":"Q",
         "Xenon_Question":"R",
         "Xenon_Neutral":"S",
         "Xenon_Left":"T",
         "Xenon_Right":"U",
         "Xenon_Down":"V",
         "Xenon_Up":"W",
         "Xenon_R2_Alt":"X",
         "Xenon_L2_Alt":"Y",
         "_Positive":"P",
         "_Negative":"Q",
         "_Question":"R",
         "_Neutral":"S",
         "Left":"T",
         "Right":"U",
         "Down":"V",
         "Up":"W",
         "_DPad_All":"s",
         "_DPad_LR":"q",
         "_DPad_UD":"r",
         "_DPad_Left":"t",
         "_DPad_Right":"u",
         "_DPad_Down":"v",
         "_DPad_Up":"w",
         "PSN_Positive":"P",
         "PSN_Negative":"Q",
         "PSN_Question":"R",
         "PSN_Neutral":"S",
         "PSN_Left":"T",
         "PSN_Right":"U",
         "PSN_Down":"V",
         "PSN_Up":"W",
         "PSN_A":"a",
         "PSN_Y":"b",
         "PSN_X":"c",
         "PSN_B":"d",
         "PSN_Select":"z",
         "PSN_L3":"f",
         "PSN_L1":"g",
         "PSN_L1R1":"h",
         "PSN_LS":"i",
         "PSN_L2":"j",
         "PSN_L2R2":"k",
         "PSN_R3":"l",
         "PSN_R1":"m",
         "PSN_RS":"n",
         "PSN_R2":"o",
         "PSN_Start":"p",
         "PSN_R2_Alt":"x",
         "PSN_L2_Alt":"y"
      };
      
      public static const IMAGE_FRAME_MAP:Object = {
         "a":1,
         "b":2,
         "c":3,
         "d":4,
         "e":5,
         "f":6,
         "g":7,
         "h":8,
         "i":9,
         "j":10,
         "k":11,
         "l":12,
         "m":13,
         "n":14,
         "o":15,
         "p":16,
         "q":17,
         "r":18,
         "s":19,
         "t":20,
         "u":21,
         "v":22,
         "w":23,
         "x":24,
         "y":25,
         "z":26,
         0:1,
         1:2,
         2:3,
         3:4,
         4:5,
         5:6,
         6:7,
         7:8,
         8:9,
         9:10
      };
      
      public function GlobalFunc()
      {
         super();
      }
      
      public static function GetButtonFontKey(aMapping:String) : String
      {
         var fontKey:String = "";
         if(ButtonMappingToFontKey.hasOwnProperty(aMapping))
         {
            fontKey = ButtonMappingToFontKey[aMapping];
         }
         return fontKey;
      }
      
      public static function CloneObject(aObjectToClone:Object) : *
      {
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeObject(aObjectToClone);
         byteArray.position = 0;
         return byteArray.readObject();
      }
      
      public static function GenerateNameAndTitle(nameSource:String) : String
      {
         var x:uint = 0;
         var builtName:String = "";
         var splitNames:Array = nameSource.split(CUSTOM_TITLE_DELIMITER);
         builtName = splitNames[0];
         var hasTitle:Boolean = splitNames.length > 2 ? !(splitNames[1] == "" && splitNames[2] == "") : splitNames.length > 1 && splitNames[1] != "";
         if(hasTitle)
         {
            builtName += CUSTOM_TITLE_DIVIDER;
            for(x = 1; x < splitNames.length; x++)
            {
               builtName += " " + splitNames[x];
            }
         }
         return builtName;
      }
      
      public static function GenerateName(nameSource:String) : String
      {
         return nameSource.split(CUSTOM_TITLE_DELIMITER)[0];
      }
      
      public static function HasPlayerTitle(nameSource:String) : Boolean
      {
         return nameSource.indexOf(CUSTOM_TITLE_DELIMITER) > -1;
      }
      
      public static function HasCampTitle(nameSource:String) : Boolean
      {
         var splitNames:Array = nameSource.split(CUSTOM_TITLE_DELIMITER);
         return splitNames.length > 2 && !(splitNames[1] == "" && splitNames[2] == "");
      }
      
      public static function GenerateTitle(nameSource:String) : String
      {
         var x:uint = 0;
         var builtTitle:String = "";
         var splitNames:Array = nameSource.split(CUSTOM_TITLE_DELIMITER);
         if(splitNames.length > 1)
         {
            builtTitle = splitNames[1];
            for(x = 2; x < splitNames.length; x++)
            {
               if(splitNames[x].length > 0)
               {
                  builtTitle += " " + splitNames[x];
               }
            }
         }
         return builtTitle;
      }
      
      public static function GenerateNameAndTitleArray(nameSource:String) : Array
      {
         var x:uint = 0;
         var splitNames:Array = nameSource.split(CUSTOM_TITLE_DELIMITER);
         var builtTitle:String = "";
         if(splitNames.length > 1)
         {
            builtTitle = splitNames[1];
            for(x = 2; x < splitNames.length; x++)
            {
               if(splitNames[x].length > 0)
               {
                  builtTitle += " " + splitNames[x];
               }
            }
         }
         var builtStrings:Array = new Array(splitNames[0]);
         if(builtTitle != "")
         {
            builtStrings.push(builtTitle);
         }
         return builtStrings;
      }
      
      public static function Lerp(aTargetMin:Number, aTargetMax:Number, aSourceMin:Number, aSourceMax:Number, aSource:Number, abClamp:Boolean) : Number
      {
         var fresult:Number = aTargetMin + (aSource - aSourceMin) / (aSourceMax - aSourceMin) * (aTargetMax - aTargetMin);
         if(abClamp)
         {
            if(aTargetMin < aTargetMax)
            {
               fresult = Math.min(Math.max(fresult,aTargetMin),aTargetMax);
            }
            else
            {
               fresult = Math.min(Math.max(fresult,aTargetMax),aTargetMin);
            }
         }
         return fresult;
      }
      
      public static function PadNumber(aNumber:Number, aLength:uint) : String
      {
         var output:String = "" + aNumber;
         while(output.length < aLength)
         {
            output = "0" + output;
         }
         return output;
      }
      
      public static function setChallengeRewardIcon(aClip:SWFLoaderClip, aChallengeType:uint, aCustomIcon:String = "") : MovieClip
      {
         var rewardIcon:String = null;
         switch(aChallengeType)
         {
            case REWARD_TYPE_ENUM_ATOMS:
               rewardIcon = "IconCR_Atoms";
               break;
            case REWARD_TYPE_ENUM_PERK_PACKS:
               rewardIcon = "IconCR_PerkPack";
               break;
            case REWARD_TYPE_ENUM_PERK_COIN:
               rewardIcon = "IconCR_PerkCoin";
               break;
            case REWARD_TYPE_ENUM_PHOTO_FRAMES:
               rewardIcon = "IconCR_PhotoMode";
               break;
            case REWARD_TYPE_ENUM_EMOTES:
               rewardIcon = "IconCR_Emote";
               break;
            case REWARD_TYPE_ENUM_ICONS:
               rewardIcon = "IconCR_PlayerIcon";
               break;
            case REWARD_TYPE_ENUM_WEAPON:
               rewardIcon = "IconCR_Weapon";
               break;
            case REWARD_TYPE_ENUM_WEAPON_MOD:
               rewardIcon = "IconCR_WeaponMod";
               break;
            case REWARD_TYPE_ENUM_ARMOR:
               rewardIcon = "IconCR_Armor";
               break;
            case REWARD_TYPE_ENUM_ARMOR_MOD:
               rewardIcon = "IconCR_ArmorMod";
               break;
            case REWARD_TYPE_ENUM_AMMO:
               rewardIcon = "IconCR_Ammo";
               break;
            case REWARD_TYPE_ENUM_PHOTO_POSE:
               rewardIcon = "IconCR_PhotoMode";
               break;
            case REWARD_TYPE_ENUM_COMPONENTS:
               rewardIcon = "IconCR_Components";
               break;
            case REWARD_TYPE_ENUM_EXPERIENCE:
               rewardIcon = "IconCR_Experience";
               break;
            case REWARD_TYPE_ENUM_BADGES:
               rewardIcon = "IconCR_Badges";
               break;
            case REWARD_TYPE_ENUM_STIMPAKS:
               rewardIcon = "IconCR_Stimpaks";
               break;
            case REWARD_TYPE_ENUM_CHEMS:
               rewardIcon = "IconCR_Chems";
               break;
            case REWARD_TYPE_ENUM_BOOK:
               rewardIcon = "IconCR_Recipe";
               break;
            case REWARD_TYPE_ENUM_CAPS:
               rewardIcon = "IconCR_Caps";
               break;
            case REWARD_TYPE_ENUM_LEGENDARY_TOKENS:
               rewardIcon = "IconCR_LegendaryToken";
               break;
            case REWARD_TYPE_ENUM_POSSUM_BADGES:
            case REWARD_TYPE_ENUM_TADPOLE_BADGES:
               rewardIcon = "IconCR_Caps";
               break;
            case REWARD_TYPE_ENUM_CUSTOM_ICON:
               if(aCustomIcon.length > 0)
               {
                  rewardIcon = aCustomIcon;
                  break;
               }
               throw new Error("GlobalFunc.setChallengeRewardIcon: No custom icon specified.");
               break;
            case REWARD_TYPE_ENUM_CAMP:
               rewardIcon = "IconCR_Camp";
               break;
            case REWARD_TYPE_ENUM_GOLD_BULLION:
               rewardIcon = "IconCR_GoldBullion";
               break;
            case REWARD_TYPE_ENUM_SCORE:
               rewardIcon = "IconCR_Score";
               break;
            case REWARD_TYPE_ENUM_REPAIR_KIT:
               rewardIcon = "IconCR_RepairKit";
               break;
            case REWARD_TYPE_ENUM_LUNCH_BOX:
               rewardIcon = "IconCR_LunchBox";
               break;
            case REWARD_TYPE_ENUM_PREMIUM:
               rewardIcon = "IconCR_Premium";
               break;
            case REWARD_TYPE_ENUM_SCORE_BOOST:
               rewardIcon = "IconCR_ScoreBoost";
               break;
            case REWARD_TYPE_ENUM_STAMPS:
               rewardIcon = "IconCR_Stamps";
               break;
            case REWARD_TYPE_ENUM_SCOUT_BACKPACK:
               rewardIcon = "IconCR_ScoutBackpack";
               break;
            case REWARD_TYPE_ENUM_SCOUT_BANNER:
               rewardIcon = "IconCR_ScoutBanner";
               break;
            case REWARD_TYPE_ENUM_FOOD_AND_DRINK:
               rewardIcon = "IconCR_FoodAndDrink";
               break;
            case REWARD_TYPE_ENUM_RE_ROLLER:
               rewardIcon = "IconCR_ReRoller";
               break;
            case REWARD_TYPE_ENUM_SCORE_BOOSTER_CONSUMABLE:
               rewardIcon = "IconCR_ScoreBoosterConsumable";
               break;
            case REWARD_TYPE_ENUM_FLAIR:
               rewardIcon = "IconCR_Flair";
               break;
            case REWARD_TYPE_ENUM_TICKETS:
               rewardIcon = "IconCR_Ticket";
               break;
            case REWARD_TYPE_ENUM_PLAYER_TITLE:
               rewardIcon = "IconCR_PlayerTitle";
         }
         return aClip.setContainerIconClip(rewardIcon);
      }
      
      public static function parseStatValue(aValue:Number, aValueType:uint) : String
      {
         switch(aValueType)
         {
            case GlobalFunc.STAT_VALUE_TYPE_TIME:
               return ShortTimeString(aValue);
            default:
               return aValue.toString();
         }
      }
      
      public static function ShortTimeStringMinutes(aSeconds:Number) : String
      {
         var tmpText:TextField = new TextField();
         var remain:Number = 0;
         var days:Number = Math.floor(aSeconds / 86400);
         remain = aSeconds % 86400;
         var hours:Number = Math.floor(remain / 3600);
         remain = aSeconds % 3600;
         var mins:Number = Math.floor(remain / 60);
         var timeVal:* = 0;
         if(days >= 1)
         {
            tmpText.text = "$ShortTimeDays";
            timeVal = days;
         }
         else if(hours >= 1)
         {
            tmpText.text = "$ShortTimeHours";
            timeVal = hours;
         }
         else
         {
            tmpText.text = "$ShortTimeMinutes";
            timeVal = mins;
         }
         tmpText.text = tmpText.text.replace("{time}",timeVal.toString());
         return tmpText.text;
      }
      
      public static function ShortTimeString(aSeconds:Number) : String
      {
         var remain:Number = 0;
         var tmpText:TextField = new TextField();
         var days:Number = Math.floor(aSeconds / 86400);
         remain = aSeconds % 86400;
         var hours:Number = Math.floor(remain / 3600);
         remain = aSeconds % 3600;
         var mins:Number = Math.floor(remain / 60);
         remain = aSeconds % 60;
         var secs:Number = Math.floor(remain);
         var timeVal:* = 0;
         if(days >= 1)
         {
            tmpText.text = "$ShortTimeDays";
            timeVal = days;
         }
         else if(hours >= 1)
         {
            tmpText.text = "$ShortTimeHours";
            timeVal = hours;
         }
         else if(mins >= 1)
         {
            tmpText.text = "$ShortTimeMinutes";
            timeVal = mins;
         }
         else if(secs >= 1)
         {
            tmpText.text = "$ShortTimeSeconds";
            timeVal = secs;
         }
         else
         {
            tmpText.text = "$ShortTimeSecond";
            timeVal = secs;
         }
         if(timeVal != 0)
         {
            tmpText.text = tmpText.text.replace("{time}",timeVal.toString());
            return tmpText.text;
         }
         return "0";
      }
      
      public static function SimpleTimeString(aSeconds:Number) : String
      {
         var remain:Number = 0;
         var tmpText:TextField = new TextField();
         var days:Number = Math.floor(aSeconds / 86400);
         remain = aSeconds % 86400;
         var hours:Number = Math.floor(remain / 3600);
         remain = aSeconds % 3600;
         var mins:Number = Math.floor(remain / 60);
         remain = aSeconds % 60;
         var secs:Number = Math.floor(remain);
         var timeVal:* = 0;
         if(days > 1)
         {
            tmpText.text = "$SimpleTimeDays";
            timeVal = days;
         }
         else if(days == 1)
         {
            tmpText.text = "$SimpleTimeDay";
            timeVal = days;
         }
         else if(hours > 1)
         {
            tmpText.text = "$SimpleTimeHours";
            timeVal = hours;
         }
         else if(hours == 1)
         {
            tmpText.text = "$SimpleTimeHour";
            timeVal = hours;
         }
         else if(mins > 1)
         {
            tmpText.text = "$SimpleTimeMinutes";
            timeVal = mins;
         }
         else if(mins == 1)
         {
            tmpText.text = "$SimpleTimeMinute";
            timeVal = mins;
         }
         else if(secs > 1)
         {
            tmpText.text = "$SimpleTimeSeconds";
            timeVal = secs;
         }
         else if(secs == 1)
         {
            tmpText.text = "$SimpleTimeSecond";
            timeVal = secs;
         }
         if(timeVal != 0)
         {
            tmpText.text = tmpText.text.replace("{time}",timeVal.toString());
            return tmpText.text;
         }
         return "0";
      }
      
      public static function FormatTimeString(aSeconds:Number) : String
      {
         var remain:Number = 0;
         var days:Number = Math.floor(aSeconds / 86400);
         remain = aSeconds % 86400;
         var hours:Number = Math.floor(remain / 3600);
         remain = aSeconds % 3600;
         var minutes:Number = Math.floor(remain / 60);
         remain = aSeconds % 60;
         var seconds:Number = Math.floor(remain);
         var hasTime:Boolean = false;
         var output:* = "";
         if(days > 0)
         {
            output = PadNumber(days,2);
            hasTime = true;
         }
         if(days > 0 || hours > 0)
         {
            if(hasTime)
            {
               output += ":";
            }
            else
            {
               hasTime = true;
            }
            output += PadNumber(hours,2);
         }
         if(days > 0 || hours > 0 || minutes > 0)
         {
            if(hasTime)
            {
               output += ":";
            }
            else
            {
               hasTime = true;
            }
            output += PadNumber(minutes,2);
         }
         if(days > 0 || hours > 0 || minutes > 0 || seconds > 0)
         {
            if(hasTime)
            {
               output += ":";
            }
            else if(days == 0 && hours == 0 && minutes == 0)
            {
               output = "0:";
            }
            output += PadNumber(seconds,2);
         }
         return output;
      }
      
      public static function ImageFrameFromCharacter(aInput:String) : uint
      {
         var firstChar:String = null;
         if(aInput != null && aInput.length > 0)
         {
            firstChar = aInput.substring(0,1).toLowerCase();
            if(IMAGE_FRAME_MAP[firstChar] != null)
            {
               return IMAGE_FRAME_MAP[firstChar];
            }
         }
         return 1;
      }
      
      public static function GetAccountIconPath(aInput:String) : String
      {
         if(aInput == null || aInput.length == 0)
         {
            aInput = "Textures/ATX/Storefront/Player/PlayerIcons/ATX_PlayerIcon_VaultBoy_76.dds";
         }
         return aInput;
      }
      
      public static function RoundDecimal(aNumber:Number, aPrecision:Number) : Number
      {
         var decimal:Number = Math.pow(10,aPrecision);
         return Math.round(decimal * aNumber) / decimal;
      }
      
      public static function CloseToNumber(aNumber1:Number, aNumber2:Number, aEpsilon:Number = 0.001) : Boolean
      {
         return Math.abs(aNumber1 - aNumber2) < aEpsilon;
      }
      
      public static function Clamp(val:Number, min:Number, max:Number) : Number
      {
         return Math.max(min,Math.min(max,val));
      }
      
      public static function MaintainTextFormat() : *
      {
         TextField.prototype.SetText = function(aText:String, abHTMLText:Boolean = false, aUpperCase:Boolean = false):*
         {
            var oldSpacing:Number = NaN;
            var oldKerning:Boolean = false;
            if(!aText || aText == "")
            {
               aText = " ";
            }
            if(aUpperCase && aText.charAt(0) != "$")
            {
               aText = aText.toUpperCase();
            }
            var format:TextFormat = this.getTextFormat();
            if(abHTMLText)
            {
               oldSpacing = Number(format.letterSpacing);
               oldKerning = Boolean(format.kerning);
               this.htmlText = aText;
               format = this.getTextFormat();
               format.letterSpacing = oldSpacing;
               format.kerning = oldKerning;
               this.setTextFormat(format);
               this.htmlText = aText;
            }
            else
            {
               this.text = aText;
               this.setTextFormat(format);
               this.text = aText;
            }
         };
      }
      
      public static function TruncateSingleLineText(aTextField:TextField) : *
      {
         var lastVisibleIndex:int = 0;
         if(aTextField.text.length > 3)
         {
            lastVisibleIndex = aTextField.getCharIndexAtPoint(aTextField.width,0);
            if(lastVisibleIndex > 0)
            {
               aTextField.replaceText(lastVisibleIndex - 1,aTextField.length,"…");
            }
         }
      }
      
      public static function SetTruncatedMultilineText(aTextField:TextField, aText:String, abUpperCase:Boolean = false) : *
      {
         var stringToDisplay:* = null;
         var lastLineTextStartsAt:int = 0;
         var truncateAt:* = undefined;
         var metrics:TextLineMetrics = aTextField.getLineMetrics(0);
         var maxVisibleLines:int = aTextField.height / metrics.height;
         aTextField.text = "W";
         var maxCharactersPerLine:int = aTextField.width / aTextField.textWidth;
         GlobalFunc.SetText(aTextField,aText,false,abUpperCase);
         var numVisibleLines:int = Math.min(maxVisibleLines,aTextField.numLines);
         if(aTextField.numLines > maxVisibleLines)
         {
            stringToDisplay = aText;
            lastLineTextStartsAt = aTextField.getLineOffset(maxVisibleLines - 1);
            truncateAt = lastLineTextStartsAt + maxCharactersPerLine - 1;
            if(stringToDisplay.charAt(truncateAt - 1) == " ")
            {
               truncateAt--;
            }
            stringToDisplay = stringToDisplay.substr(0,truncateAt) + "…";
            GlobalFunc.SetText(aTextField,stringToDisplay,false,abUpperCase);
         }
      }
      
      public static function SetText(aTextField:TextField, aText:String, abHTMLText:Boolean = false, abUpperCase:Boolean = false, abTruncate:* = false) : *
      {
         var format:TextFormat = null;
         var oldSpacing:Number = NaN;
         var oldKerning:Boolean = false;
         if(!aText || aText == "")
         {
            aText = " ";
         }
         if(abUpperCase && aText.charAt(0) != "$")
         {
            aText = aText.toUpperCase();
         }
         if(abHTMLText)
         {
            format = aTextField.getTextFormat();
            oldSpacing = Number(format.letterSpacing);
            oldKerning = Boolean(format.kerning);
            aTextField.htmlText = aText;
            format = aTextField.getTextFormat();
            format.letterSpacing = oldSpacing;
            format.kerning = oldKerning;
            aTextField.setTextFormat(format);
         }
         else
         {
            aTextField.text = aText;
         }
         if(abTruncate)
         {
            if(aTextField.textWidth > aTextField.width)
            {
               GlobalFunc.TruncateSingleLineText(aTextField);
            }
            else if(aTextField.multiline)
            {
               GlobalFunc.SetTruncatedMultilineText(aTextField,aText,abUpperCase);
            }
         }
      }
      
      public static function LockToSafeRect(aDisplayObject:DisplayObject, aPosition:String, aSafeX:Number = 0, aSafeY:Number = 0) : *
      {
         var visibleRect:Rectangle = Extensions.visibleRect;
         var topLeft_Global:Point = new Point(visibleRect.x + aSafeX,visibleRect.y + aSafeY);
         var bottomRight_Global:Point = new Point(visibleRect.x + visibleRect.width - aSafeX,visibleRect.y + visibleRect.height - aSafeY);
         var topLeft:Point = aDisplayObject.parent.globalToLocal(topLeft_Global);
         var bottomRight:Point = aDisplayObject.parent.globalToLocal(bottomRight_Global);
         var centerPoint:Point = Point.interpolate(topLeft,bottomRight,0.5);
         if(aPosition == "T" || aPosition == "TL" || aPosition == "TR" || aPosition == "TC")
         {
            aDisplayObject.y = topLeft.y;
         }
         if(aPosition == "CR" || aPosition == "CC" || aPosition == "CL")
         {
            aDisplayObject.y = centerPoint.y;
         }
         if(aPosition == "B" || aPosition == "BL" || aPosition == "BR" || aPosition == "BC")
         {
            aDisplayObject.y = bottomRight.y;
         }
         if(aPosition == "L" || aPosition == "TL" || aPosition == "BL" || aPosition == "CL")
         {
            aDisplayObject.x = topLeft.x;
         }
         if(aPosition == "TC" || aPosition == "CC" || aPosition == "BC")
         {
            aDisplayObject.x = centerPoint.x;
         }
         if(aPosition == "R" || aPosition == "TR" || aPosition == "BR" || aPosition == "CR")
         {
            aDisplayObject.x = bottomRight.x;
         }
      }
      
      public static function AddMovieExploreFunctions() : *
      {
         MovieClip.prototype.getMovieClips = function():Array
         {
            var i:* = undefined;
            var movieClips:* = new Array();
            for(i in this)
            {
               if(this[i] is MovieClip && this[i] != this)
               {
                  movieClips.push(this[i]);
               }
            }
            return movieClips;
         };
         MovieClip.prototype.showMovieClips = function():*
         {
            var i:* = undefined;
            for(i in this)
            {
               if(this[i] is MovieClip && this[i] != this)
               {
                  trace(this[i]);
                  this[i].showMovieClips();
               }
            }
         };
      }
      
      public static function TraceFunction(bShowCallstack:Boolean = false, ... args) : *
      {
         var functionLine:Array = null;
         var paramString:* = null;
         var i:* = undefined;
         var callstackString:String = null;
         var callStack:String = new Error().getStackTrace();
         var callStackA:Array = callStack.split("\n");
         if(callStackA.length >= 2)
         {
            functionLine = callStackA[2].split(" ")[1].split("()");
            paramString = "";
            for(i = 0; i < args.length; i++)
            {
               paramString += args[i];
               if(i < args.length - 1)
               {
                  paramString += ", ";
               }
            }
            callstackString = "";
            if(bShowCallstack && callStackA.length > 2)
            {
               callstackString = "\n" + callStackA.slice(3).join("\n");
            }
            trace(new Array("[FUNCTION TRACE] ",functionLine[0],"(",paramString,")",callstackString).join(""));
         }
      }
      
      public static function InspectObject(aObject:Object, abRecursive:Boolean = false, abIncludeProperties:Boolean = false) : void
      {
         var className:String = getQualifiedClassName(aObject);
         trace("Inspecting object with type " + className);
         trace("{");
         InspectObjectHelper(aObject,abRecursive,abIncludeProperties);
         trace("}");
      }
      
      private static function InspectObjectHelper(aObject:Object, abRecursive:Boolean, abIncludeProperties:Boolean, astrIndent:String = "\t") : void
      {
         var member:XML = null;
         var constMember:XML = null;
         var id:String = null;
         var prop:XML = null;
         var propName:String = null;
         var propValue:Object = null;
         var memberName:String = null;
         var memberValue:Object = null;
         var constMemberName:String = null;
         var constMemberValue:Object = null;
         var value:Object = null;
         var subid:String = null;
         var subvalue:Object = null;
         var typeDef:XML = describeType(aObject);
         if(abIncludeProperties)
         {
            for each(prop in typeDef.accessor.(@access == "readwrite" || @access == "readonly"))
            {
               propName = prop.@name;
               propValue = aObject[prop.@name];
               trace(astrIndent + propName + " = " + propValue);
               if(abRecursive)
               {
                  InspectObjectHelper(propValue,abRecursive,abIncludeProperties,astrIndent + "\t");
               }
            }
         }
         for each(member in typeDef.variable)
         {
            memberName = member.@name;
            memberValue = aObject[memberName];
            trace(astrIndent + memberName + " = " + memberValue);
            if(abRecursive)
            {
               InspectObjectHelper(memberValue,true,abIncludeProperties,astrIndent + "\t");
            }
         }
         for each(constMember in typeDef.constant)
         {
            constMemberName = constMember.@name;
            constMemberValue = aObject[constMemberName];
            trace(astrIndent + constMemberName + " = " + constMemberValue + " --const");
            if(abRecursive)
            {
               InspectObjectHelper(constMemberValue,true,abIncludeProperties,astrIndent + "\t");
            }
         }
         for(id in aObject)
         {
            value = aObject[id];
            trace(astrIndent + id + " = " + value);
            if(abRecursive)
            {
               InspectObjectHelper(value,true,abIncludeProperties,astrIndent + "\t");
            }
            else
            {
               for(subid in value)
               {
                  subvalue = value[subid];
                  trace(astrIndent + "\t" + subid + " = " + subvalue);
               }
            }
         }
      }
      
      public static function AddReverseFunctions() : *
      {
         MovieClip.prototype.PlayReverseCallback = function(event:Event):*
         {
            if(event.currentTarget.currentFrame > 1)
            {
               event.currentTarget.gotoAndStop(event.currentTarget.currentFrame - 1);
            }
            else
            {
               event.currentTarget.removeEventListener(Event.ENTER_FRAME,event.currentTarget.PlayReverseCallback);
            }
         };
         MovieClip.prototype.PlayReverse = function():*
         {
            if(this.currentFrame > 1)
            {
               this.gotoAndStop(this.currentFrame - 1);
               this.addEventListener(Event.ENTER_FRAME,this.PlayReverseCallback);
            }
            else
            {
               this.gotoAndStop(1);
            }
         };
         MovieClip.prototype.PlayForward = function(aFrameLabel:String):*
         {
            delete this.onEnterFrame;
            this.gotoAndPlay(aFrameLabel);
         };
         MovieClip.prototype.PlayForward = function(aFrame:Number):*
         {
            delete this.onEnterFrame;
            this.gotoAndPlay(aFrame);
         };
      }
      
      public static function PlayPipboySound(aSoundID:String) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.PLAY_MENU_SOUND,{
            "soundID":aSoundID,
            "soundFormID":0,
            "overrideOutput":false
         }));
      }
      
      public static function PlayMenuSound(aSoundID:String) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.PLAY_MENU_SOUND,{
            "soundID":aSoundID,
            "soundFormID":0,
            "overrideOutput":true
         }));
      }
      
      public static function PlayMenuSoundWithFormID(aSoundFormID:uint) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.PLAY_MENU_SOUND,{
            "soundID":"",
            "soundFormID":aSoundFormID,
            "overrideOutput":true
         }));
      }
      
      public static function ShowHUDMessage(aMessage:String) : *
      {
         BSUIDataManager.dispatchEvent(new CustomEvent(GlobalFunc.SHOW_HUD_MESSAGE,{"text":aMessage}));
      }
      
      public static function updateConditionMeter(aBar:MovieClip, aCurrentHealth:Number, aMaximumHealth:Number, aDurability:Number) : void
      {
         var conditionInternal:MovieClip = null;
         if(aMaximumHealth > 0)
         {
            aBar.visible = true;
            conditionInternal = aBar.MeterClip_mc;
            aBar.gotoAndStop(GlobalFunc.Lerp(aBar.totalFrames,1,0,DURABILITY_MAX,aDurability,true));
            if(aCurrentHealth > 0)
            {
               conditionInternal.gotoAndStop(GlobalFunc.Lerp(conditionInternal.totalFrames,2,0,aMaximumHealth * 2,aCurrentHealth,true));
            }
            else
            {
               conditionInternal.gotoAndStop(1);
            }
         }
         else
         {
            aBar.visible = false;
         }
      }
      
      public static function updateVoiceIndicator(aClip:MovieClip, aVoiceEnabled:Boolean, aSpeaking:Boolean, aSameChannel:Boolean, aIsAlly:Boolean = true, aIsEnemy:Boolean = false) : void
      {
         if(!aVoiceEnabled)
         {
            aClip.gotoAndStop("muted");
         }
         else if(!aSameChannel)
         {
            aClip.gotoAndStop("hasMicSpeakingChannel");
         }
         else if(aSpeaking)
         {
            aClip.gotoAndStop("hasMicSpeaking");
         }
         else
         {
            aClip.gotoAndStop("hasMic");
         }
         if(aClip.Icon_mc)
         {
            if(aIsEnemy)
            {
               aClip.Icon_mc.gotoAndStop("enemy");
            }
            else if(aIsAlly)
            {
               aClip.Icon_mc.gotoAndStop("ally");
            }
            else
            {
               aClip.Icon_mc.gotoAndStop("neutral");
            }
         }
      }
      
      public static function quickMultiLineShrinkToFit(aField:TextField, aBaseSize:Number = 0, aBaseLeading:Number = 0) : void
      {
         var thisTextFormat:TextFormat = aField.getTextFormat();
         if(aBaseSize == 0)
         {
            aBaseSize = thisTextFormat.size as Number;
         }
         thisTextFormat.size = aBaseSize;
         thisTextFormat.leading = aBaseLeading;
         aField.setTextFormat(thisTextFormat);
         var needEvaluateSize:Boolean = false;
         if(getTextfieldSize(aField) > aField.height)
         {
            thisTextFormat.size = TEXT_SIZE_VERYSMALL;
            thisTextFormat.leading = TEXT_LEADING_MIN;
            aField.setTextFormat(thisTextFormat);
            needEvaluateSize = true;
         }
         if(needEvaluateSize && getTextfieldSize(aField) > aField.height)
         {
            thisTextFormat.size = TEXT_SIZE_MIN;
            thisTextFormat.leading = TEXT_LEADING_MIN;
            aField.setTextFormat(thisTextFormat);
         }
      }
      
      public static function shrinkMultiLineTextToFit(aField:TextField, aBaseSize:Number = 0, aBottomPadding:Number = 0) : void
      {
         var thisTextFormat:TextFormat = aField.getTextFormat();
         if(aBaseSize == 0)
         {
            aBaseSize = thisTextFormat.size as Number;
         }
         var curSize:Number = aBaseSize;
         thisTextFormat.size = curSize;
         aField.setTextFormat(thisTextFormat);
         while(getTextfieldSize(aField) > aField.height - aBottomPadding && curSize > TEXT_SIZE_MIN)
         {
            curSize--;
            thisTextFormat.size = curSize;
            aField.setTextFormat(thisTextFormat);
         }
      }
      
      public static function shrinkMultilineToFitLines(aTextField:TextField, aText:String, abUpperCase:Boolean = false) : *
      {
         var thisTextFormat:TextFormat = aTextField.getTextFormat();
         var curSize:Number = thisTextFormat.size as Number;
         var metrics:TextLineMetrics = aTextField.getLineMetrics(0);
         var maxVisibleLines:int = aTextField.height / metrics.height;
         GlobalFunc.SetText(aTextField,aText,false,abUpperCase);
         while(aTextField.numLines > maxVisibleLines && curSize > TEXT_SIZE_MIN)
         {
            curSize--;
            thisTextFormat.size = curSize;
            aTextField.setTextFormat(thisTextFormat);
            GlobalFunc.SetText(aTextField,aText,false,abUpperCase);
         }
      }
      
      public static function shrinkToFitText(aTextField:TextField) : *
      {
         var textFormat:TextFormat = aTextField.getTextFormat();
         var currentSize:Number = textFormat.size as Number;
         while(aTextField.textWidth > aTextField.width && currentSize >= MINIMUM_FONT_SIZE)
         {
            currentSize--;
            textFormat.size = currentSize;
            aTextField.setTextFormat(textFormat);
         }
      }
      
      public static function getTextfieldSize(aTextfield:TextField, aVertical:Boolean = true) : *
      {
         var totalSize:Number = NaN;
         var i:uint = 0;
         if(aTextfield.multiline)
         {
            totalSize = 0;
            for(i = 0; i < aTextfield.numLines; i++)
            {
               totalSize += aVertical ? aTextfield.getLineMetrics(i).height : aTextfield.getLineMetrics(i).width;
            }
            return totalSize;
         }
         return aVertical ? aTextfield.textHeight : aTextfield.textWidth;
      }
      
      public static function getDisplayObjectSize(aObject:DisplayObject, aVertical:Boolean = false) : *
      {
         if(aObject is BSScrollingList)
         {
            return (aObject as BSScrollingList).shownItemsHeight;
         }
         if(aObject is BCGridList)
         {
            return (aObject as BCGridList).displayHeight;
         }
         if(aObject is MovieClip)
         {
            if(aObject["Sizer_mc"] != undefined && aObject["Sizer_mc"] != null)
            {
               return aVertical ? aObject["Sizer_mc"].height : aObject["Sizer_mc"].width;
            }
            if(aObject["textField"] != null)
            {
               return getTextfieldSize(aObject["textField"],aVertical);
            }
            if(aObject["displayHeight"] != null)
            {
               return aObject["displayHeight"];
            }
            return aVertical ? aObject.height : aObject.width;
         }
         if(aObject is TextField)
         {
            return getTextfieldSize(aObject as TextField,aVertical);
         }
         throw new Error("GlobalFunc.getDisplayObjectSize: unsupported object type");
      }
      
      public static function arrangeItems(aItems:Array, aVertical:Boolean, aAlign:uint = 0, aSpacing:Number = 0, aReverse:Boolean = false, aOffset:Number = 0) : Number
      {
         var positionOrigin:Number = NaN;
         var offsetMultiplier:Number = NaN;
         var itemIndex:uint = 0;
         var curItem:Object = null;
         var itemSizes:Array = null;
         var itemCount:uint = 0;
         var itemLength:uint = aItems.length;
         var totalDistance:Number = 0;
         if(itemLength > 0)
         {
            positionOrigin = 0;
            offsetMultiplier = aReverse ? -1 : 1;
            itemSizes = [];
            itemCount = aItems.length;
            for(itemIndex = 0; itemIndex < itemCount; itemIndex++)
            {
               if(itemIndex > 0)
               {
                  totalDistance += aSpacing;
               }
               itemSizes[itemIndex] = getDisplayObjectSize(aItems[itemIndex],aVertical);
               totalDistance += itemSizes[itemIndex];
            }
            if(aAlign == ALIGN_CENTER)
            {
               positionOrigin = totalDistance * -0.5;
            }
            else if(aAlign == ALIGN_RIGHT)
            {
               positionOrigin = -totalDistance - itemSizes[0];
            }
            if(aReverse)
            {
               aItems.reverse();
               itemSizes.reverse();
            }
            positionOrigin += aOffset;
            for(itemIndex = 0; itemIndex < itemCount; itemIndex++)
            {
               if(aVertical)
               {
                  aItems[itemIndex].y = positionOrigin;
               }
               else
               {
                  aItems[itemIndex].x = positionOrigin;
               }
               positionOrigin += itemSizes[itemIndex] + aSpacing;
            }
         }
         return totalDistance;
      }
      
      public static function StringTrim(astrText:String) : String
      {
         var strResult:String = null;
         var startIndex:Number = 0;
         var endIndex:Number = 0;
         var strLength:Number = astrText.length;
         while(astrText.charAt(startIndex) == " " || astrText.charAt(startIndex) == "\n" || astrText.charAt(startIndex) == "\r" || astrText.charAt(startIndex) == "\t")
         {
            startIndex++;
         }
         strResult = astrText.substring(startIndex);
         endIndex = strResult.length - 1;
         while(strResult.charAt(endIndex) == " " || strResult.charAt(endIndex) == "\n" || strResult.charAt(endIndex) == "\r" || strResult.charAt(endIndex) == "\t")
         {
            endIndex--;
         }
         return strResult.substring(0,endIndex + 1);
      }
      
      public static function BSASSERT(abConditional:Boolean, asMessage:String) : void
      {
         var callStack:String = null;
         if(!abConditional)
         {
            callStack = new Error().getStackTrace();
            fscommand("BSASSERT",asMessage + "\nCallstack:\n" + callStack);
         }
      }
      
      public static function HasFFEvent(aDataObject:Object, asEventString:String) : Boolean
      {
         var obj:Object = null;
         var result:Boolean = false;
         try
         {
            if(aDataObject.eventArray.length > 0)
            {
               for each(obj in aDataObject.eventArray)
               {
                  if(obj.eventName == asEventString)
                  {
                     result = true;
                     break;
                  }
               }
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace() + " The following Fire Forget Event object could not be parsed:");
            GlobalFunc.InspectObject(aDataObject,true);
         }
         return result;
      }
      
      public static function ReceiveFFEvent(aDataObject:Object, asEventString:String, aOutObject:Object) : Boolean
      {
         var obj:Object = null;
         var i:String = null;
         var result:Boolean = false;
         try
         {
            if(aDataObject.eventArray.length > 0)
            {
               for each(obj in aDataObject.eventArray)
               {
                  if(obj.eventName == asEventString)
                  {
                     result = true;
                     for(i in obj)
                     {
                        aOutObject[i] = obj[i];
                     }
                     break;
                  }
               }
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace() + " The following Fire Forget Event object could not be parsed:");
            GlobalFunc.InspectObject(aDataObject,true);
         }
         return result;
      }
      
      public static function LocalizeFormattedString(aFormatString:String, ... aParameters) : String
      {
         var resultString:String = "";
         var localizationTextField:TextField = new TextField();
         localizationTextField.text = aFormatString;
         resultString = localizationTextField.text;
         for(var i:uint = 0; i < aParameters.length; i++)
         {
            localizationTextField.text = aParameters[i];
            resultString = resultString.replace("{" + (i + 1) + "}",localizationTextField.text);
         }
         return resultString;
      }
      
      public static function BuildLegendaryStarsGlyphString(aEntryObject:Object) : String
      {
         var legendaryModIndex:* = undefined;
         var textFieldTemp:TextField = null;
         var isLegendary:Boolean = false;
         var numLegendaryStars:Number = 0;
         var starsText:String = "";
         if(aEntryObject != null && Boolean(aEntryObject.hasOwnProperty("isLegendary")))
         {
            isLegendary = Boolean(aEntryObject.isLegendary);
            if(isLegendary && Boolean(aEntryObject.hasOwnProperty("numLegendaryStars")))
            {
               numLegendaryStars = Number(aEntryObject.numLegendaryStars);
               for(legendaryModIndex = 0; legendaryModIndex < numLegendaryStars; legendaryModIndex++)
               {
                  textFieldTemp = new TextField();
                  textFieldTemp.text = "$LegendaryModGlyph";
                  starsText += textFieldTemp.text;
               }
               starsText = " " + starsText;
            }
         }
         return starsText;
      }
      
      public static function TrimZeros(aValueText:String) : String
      {
         var currIndex:* = undefined;
         var indexOfDecimal:* = aValueText.indexOf(".");
         if(indexOfDecimal > -1)
         {
            for(currIndex = aValueText.length - 1; currIndex > indexOfDecimal; currIndex--)
            {
               if(aValueText.charAt(currIndex) != "0")
               {
                  break;
               }
            }
            aValueText = currIndex == indexOfDecimal ? aValueText.substring(0,indexOfDecimal) : aValueText.substring(0,currIndex + 1);
         }
         return aValueText;
      }
   }
}

