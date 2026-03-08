package Shared
{
   public class EnumHelper
   {
      
      private static var Counter:int = 0;
      
      public function EnumHelper()
      {
         super();
      }
      
      public static function GetEnum(aValue:int = -2147483648) : int
      {
         if(aValue == int.MIN_VALUE)
         {
            aValue = Counter;
         }
         else
         {
            Counter = aValue;
         }
         ++Counter;
         return aValue;
      }
   }
}

