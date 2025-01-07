package
{
   public class ItemTypes
   {
      
      public static const ITEM_TYPES:Object = {
         "POWER_ARMOR":[0],
         "WEAPON":[4,5],
         "ARMOR":[8,9],
         "APPAREL":[16,17],
         "FOOD_WATER":[32,33],
         "AID":[64,65],
         "NOTES":[1024],
         "MISC":[4096,266240],
         "MODS":[16384],
         "AMMO":[32768],
         "HOLO":[65536],
         "JUNK":[8192,270336]
      };
       
      
      public function ItemTypes()
      {
         super();
      }
      
      public static function getName(key:int) : String
      {
         for(var k in ITEM_TYPES)
         {
            if(ITEM_TYPES[k].indexOf(key) != -1)
            {
               return k;
            }
         }
         return null;
      }
   }
}
