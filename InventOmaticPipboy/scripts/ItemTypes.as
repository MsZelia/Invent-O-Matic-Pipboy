package
{
   public class ItemTypes
   {
      
      public static const ITEM_TYPES:Object = {
         "WEAPON":[4],
         "ARMOR":[8],
         "APPAREL":[16],
         "FOOD_WATER":[32],
         "AID":[64],
         "NOTES":[1024,2048],
         "MISC":[4096,8192],
         "MODS":[32768],
         "AMMO":[65536],
         "HOLO":[131072],
         "JUNK":[16384,262144]
      };
      
      public function ItemTypes()
      {
         super();
      }
      
      public static function getName(key:int) : String
      {
         var k:*;
         for(k in ITEM_TYPES)
         {
            if(ITEM_TYPES[k].some(function(flag:int):Boolean
            {
               return key & flag;
            }))
            {
               return k;
            }
         }
         return String(key);
      }
   }
}

