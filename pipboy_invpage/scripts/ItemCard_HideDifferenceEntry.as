package
{
   public class ItemCard_HideDifferenceEntry extends ItemCard_Entry
   {
       
      
      public function ItemCard_HideDifferenceEntry()
      {
         super();
      }
      
      override public function PopulateEntry(param1:Object) : *
      {
         if(totalFrames > 1)
         {
            gotoAndStop(param1.difference != 0 ? (param1.difference > 0 ? "good" : "bad") : "default");
         }
         super.PopulateEntry(param1);
      }
   }
}
