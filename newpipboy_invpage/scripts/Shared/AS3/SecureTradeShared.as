package Shared.AS3
{
   import flash.display.MovieClip;
   
   public class SecureTradeShared
   {
      
      public static const MODE_CONTAINER:uint = 0;
      
      public static const MODE_PLAYERVENDING:uint = 1;
      
      public static const MODE_NPCVENDING:uint = 2;
      
      public static const MODE_VENDING_MACHINE:int = 3;
      
      public static const MODE_DISPLAY_CASE:int = 4;
      
      public static const MODE_CAMP_DISPENSER:int = 5;
      
      public static const MODE_FERMENTER:int = 6;
      
      public static const MODE_REFRIGERATOR:int = 7;
      
      public static const MODE_ALLY:int = 8;
      
      public static const MODE_RECHARGER:int = 9;
      
      public static const MODE_FREEZER:int = 10;
      
      public static const MODE_PET:int = 11;
      
      public static const MODE_INVALID:uint = uint.MAX_VALUE;
      
      public static const SUB_MODE_STANDARD:uint = 0;
      
      public static const SUB_MODE_LEGENDARY_VENDOR:uint = 1;
      
      public static const SUB_MODE_LEGENDARY_VENDING_MACHINE:uint = 2;
      
      public static const SUB_MODE_POSSUM_VENDING_MACHINE:uint = 3;
      
      public static const SUB_MODE_TADPOLE_VENDING_MACHINE:uint = 4;
      
      public static const SUB_MODE_DISPENSER_AID_ONLY:uint = 5;
      
      public static const SUB_MODE_DISPENSER_AMMO_ONLY:uint = 6;
      
      public static const SUB_MODE_DISPENSER_JUNK_ONLY:uint = 7;
      
      public static const SUB_MODE_ARMOR_RACK:uint = 8;
      
      public static const SUB_MODE_GOLD_BULLION_VENDOR:uint = 9;
      
      public static const SUB_MODE_GOLD_BULLION_VENDING_MACHINE:uint = 10;
      
      public static const SUB_MODE_ALLY:uint = 11;
      
      public static const SUB_MODE_EXPEDITION_STAMPS_VENDOR:uint = 12;
      
      public static const SUB_MODE_WEAPON_DISPLAY:uint = 13;
      
      public static const SUB_MODE_POWER_ARMOR_DISPLAY:uint = 14;
      
      public static const SUB_MODE_APPAREL_DISPLAY:uint = 15;
      
      public static const SUB_MODE_FOODWATER_DISPLAY:uint = 16;
      
      public static const SUB_MODE_AID_DISPLAY:uint = 17;
      
      public static const SUB_MODE_BOOK_DISPLAY:uint = 18;
      
      public static const SUB_MODE_MISC_DISPLAY:uint = 19;
      
      public static const SUB_MODE_JUNK_DISPLAY:uint = 20;
      
      public static const SUB_MODE_HOLO_DISPLAY:uint = 21;
      
      public static const SUB_MODE_MODS_DISPLAY:uint = 22;
      
      public static const SUB_MODE_AMMO_DISPLAY:uint = 23;
      
      public static const CURRENCY_CAPS:uint = 0;
      
      public static const CURRENCY_LEGENDARY_TOKENS:uint = 1;
      
      public static const CURRENCY_POSSUM_BADGES:uint = 2;
      
      public static const CURRENCY_TADPOLE_BADGES:uint = 3;
      
      public static const CURRENCY_GOLD_BULLION:uint = 4;
      
      public static const CURRENCY_PERK_COINS:uint = 5;
      
      public static const CURRENCY_LEGENDARY_CORES_TIER_1:uint = 6;
      
      public static const CURRENCY_LEGENDARY_CORES_TIER_2:uint = 7;
      
      public static const CURRENCY_LEGENDARY_CORES_TIER_3:uint = 8;
      
      public static const CURRENCY_LEGENDARY_CORES_TIER_4:uint = 9;
      
      public static const CURRENCY_EXPEDITION_ULTRACITE_BATTERY:uint = 10;
      
      public static const CURRENCY_EXPEDITION_STAMPS:uint = 11;
      
      public static const CURRENCY_SUPPLIES:uint = 12;
      
      public static const CURRENCY_INVALID:uint = uint.MAX_VALUE;
      
      public static const MACHINE_TYPE_INVALID:* = 0;
      
      public static const MACHINE_TYPE_VENDING:* = 1;
      
      public static const MACHINE_TYPE_DISPLAY:* = 2;
      
      public static const MACHINE_TYPE_DISPENSER:* = 3;
      
      public static const MACHINE_TYPE_FERMENTER:* = 4;
      
      public static const MACHINE_TYPE_REFRIGERATOR:* = 5;
      
      public static const MACHINE_TYPE_ALLY:* = 6;
      
      public static const MACHINE_TYPE_RECHARGER:* = 7;
      
      public static const MACHINE_TYPE_FREEZER:* = 8;
      
      public static const MACHINE_TYPE_PET:* = 9;
      
      public static const LOOT:* = 0;
      
      public static const POWER_ARMOR:* = 3;
      
      public static const LIMITED_TYPE_STORAGE_SCRAP:* = 7;
      
      public static const LIMITED_TYPE_STORAGE_AMMO:* = 8;
      
      public static const LIMITED_TYPE_STORAGE_AID:* = 9;
      
      public function SecureTradeShared()
      {
         super();
      }
      
      public static function IsCampVendingMenuType(aMode:uint) : Boolean
      {
         return aMode == SecureTradeShared.MODE_VENDING_MACHINE || aMode == SecureTradeShared.MODE_DISPLAY_CASE || aMode == SecureTradeShared.MODE_ALLY || aMode == SecureTradeShared.MODE_CAMP_DISPENSER || aMode == SecureTradeShared.MODE_FERMENTER || aMode == SecureTradeShared.MODE_REFRIGERATOR || aMode == SecureTradeShared.MODE_RECHARGER || aMode == SecureTradeShared.MODE_FREEZER || aMode == SecureTradeShared.MODE_PET;
      }
      
      public static function DoesMachineTypeMatchMode(aMachineType:uint, aMode:uint) : Boolean
      {
         return aMachineType == MACHINE_TYPE_VENDING ? aMode == MODE_VENDING_MACHINE : (aMachineType == MACHINE_TYPE_DISPLAY ? aMode == MODE_DISPLAY_CASE : (aMachineType == MACHINE_TYPE_DISPENSER ? aMode == MODE_CAMP_DISPENSER : (aMachineType == MACHINE_TYPE_FERMENTER ? aMode == MODE_FERMENTER : (aMachineType == MACHINE_TYPE_REFRIGERATOR ? aMode == MODE_REFRIGERATOR : (aMachineType == MACHINE_TYPE_ALLY ? aMode == MODE_ALLY : (aMachineType == MACHINE_TYPE_RECHARGER ? aMode == MODE_RECHARGER : (aMachineType == MACHINE_TYPE_FREEZER ? aMode == MODE_FREEZER : (aMachineType == MACHINE_TYPE_PET ? aMode == MODE_PET : false))))))));
      }
      
      public static function setCurrencyIcon(aClip:SWFLoaderClip, aCurrencyType:uint, aIsHUD:Boolean = false) : MovieClip
      {
         var currencyIcon:String = null;
         switch(aCurrencyType)
         {
            case CURRENCY_CAPS:
               if(aIsHUD)
               {
                  currencyIcon = "IconCu_CapsHUD";
               }
               else
               {
                  currencyIcon = "IconCu_Caps";
               }
               break;
            case CURRENCY_LEGENDARY_TOKENS:
               if(aIsHUD)
               {
                  currencyIcon = "IconCu_LegendaryTokenHUD";
               }
               else
               {
                  currencyIcon = "IconCu_LegendaryToken";
               }
               break;
            case CURRENCY_POSSUM_BADGES:
               currencyIcon = "IconCu_Possum";
               break;
            case CURRENCY_TADPOLE_BADGES:
               currencyIcon = "IconCu_Tadpole";
               break;
            case CURRENCY_GOLD_BULLION:
               if(aIsHUD)
               {
                  currencyIcon = "IconCu_GBHUD";
               }
               else
               {
                  currencyIcon = "IconCu_GB";
               }
               break;
            case CURRENCY_PERK_COINS:
               if(aIsHUD)
               {
                  currencyIcon = "IconCu_LGNPerkCoinHUD";
               }
               else
               {
                  currencyIcon = "IconCu_LGNPerkCoin";
               }
               break;
            case CURRENCY_EXPEDITION_ULTRACITE_BATTERY:
               if(aIsHUD)
               {
                  currencyIcon = "IconCu_BatteryHUD";
               }
               break;
            case CURRENCY_EXPEDITION_STAMPS:
               if(aIsHUD)
               {
                  currencyIcon = "IconCu_StampsHUD";
               }
               else
               {
                  currencyIcon = "IconCu_Stamps";
               }
               break;
            case CURRENCY_SUPPLIES:
               currencyIcon = "IconCu_SuppliesHUD";
         }
         return aClip.setContainerIconClip(currencyIcon);
      }
   }
}

