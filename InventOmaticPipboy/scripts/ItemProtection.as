package
{
   import utils.*;
   
   public class ItemProtection
   {
      
      private static const FAVORITE:String = "Favorite";
      
      private static const EQUIPPED:String = "Equipped";
      
      private static const NAMED:String = "Named";
      
      private static var _protectionReason:String = "";
       
      
      public function ItemProtection()
      {
         super();
      }
      
      public static function get ProtectionReason() : String
      {
         return _protectionReason;
      }
      
      public static function isProtected(item:Object, config:Object) : Boolean
      {
         _protectionReason = "";
         if(!item || !config || !config.enabled)
         {
            return false;
         }
         if(config.equipped && item.equipState == 1)
         {
            _protectionReason = EQUIPPED;
            return true;
         }
         if(config.favorite && item.favorite)
         {
            _protectionReason = FAVORITE;
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
                  return true;
               }
               i++;
            }
         }
         return false;
      }
   }
}
