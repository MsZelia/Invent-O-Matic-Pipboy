package utils
{
   public class ItemProtection
   {
      
      public static const FAVORITE:String = "Favorite";
      
      public static const EQUIPPED:String = "Equipped";
      
      public static const UNIQUE:String = "Unique";
      
      public static const NAMED:String = "Named";
      
      private static var _protectionReason:String = "";
      
      private static var itemProtection:* = {};
      
      public function ItemProtection()
      {
         super();
      }
      
      public static function get ProtectionReason() : String
      {
         return _protectionReason;
      }
      
      public static function isValidLockConfig(config:Object) : Boolean
      {
         if(!config || !config.itemLocking || !config.itemLocking.enabled)
         {
            return false;
         }
         if(config.dropProtection && config.dropProtection.enabled)
         {
            return true;
         }
         return false;
      }
      
      public static function isProtected(item:Object, config:Object) : Boolean
      {
         _protectionReason = "";
         if(!item || !config || !config.enabled)
         {
            return false;
         }
         if(itemProtection[item.ItemHandle] != null)
         {
            _protectionReason = itemProtection[item.ItemHandle];
            return itemProtection[item.ItemHandle];
         }
         if(config.unique && item.hasUniqueEffect)
         {
            _protectionReason = UNIQUE;
            itemProtection[item.ItemHandle] = UNIQUE;
            return true;
         }
         if(config.equipped && item.EquipState == 1)
         {
            _protectionReason = EQUIPPED;
            itemProtection[item.ItemHandle] = EQUIPPED;
            return true;
         }
         if(config.favorite && item.IsFavorited)
         {
            _protectionReason = FAVORITE;
            itemProtection[item.ItemHandle] = FAVORITE;
            return true;
         }
         if(config.named && config.itemNames && config.itemNames.length > 0 && config.matchMode)
         {
            var i:int = 0;
            while(i < config.itemNames.length)
            {
               if(ItemWorker.isItemMatchingConfig(item,config.itemNames[i],config.matchMode))
               {
                  _protectionReason = NAMED;
                  itemProtection[item.ItemHandle] = NAMED;
                  return true;
               }
               i++;
            }
         }
         itemProtection[item.ItemHandle] = false;
         return false;
      }
   }
}

