package
{
   public class ItemCard_FireModeEntry extends ItemCard_Entry
   {
       
      
      public function ItemCard_FireModeEntry()
      {
         super();
      }
      
      override public function PopulateEntry(param1:Object) : *
      {
         if(totalFrames > 1)
         {
            gotoAndStop(param1.difference != 0 ? "difference" : "default");
         }
         super.PopulateEntry(param1);
      }
   }
}
