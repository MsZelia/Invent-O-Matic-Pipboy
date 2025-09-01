package utils
{
   public class ItemProtection
   {
      
      public static const FAVORITE:String = "Favorite";
      
      public static const EQUIPPED:String = "Equipped";
      
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
         if(itemProtection[item.serverHandleID] != null)
         {
            return itemProtection[item.serverHandleID];
         }
         if(config.equipped && item.equipState == 1)
         {
            _protectionReason = EQUIPPED;
            itemProtection[item.serverHandleID] = true;
            return true;
         }
         if(config.favorite && item.favorite)
         {
            _protectionReason = FAVORITE;
            itemProtection[item.serverHandleID] = true;
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
                  itemProtection[item.serverHandleID] = true;
                  return true;
               }
               i++;
            }
         }
         itemProtection[item.serverHandleID] = false;
         return false;
      }
   }
}

