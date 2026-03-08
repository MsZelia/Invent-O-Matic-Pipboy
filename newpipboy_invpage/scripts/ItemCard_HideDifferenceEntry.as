package
{
   public class ItemCard_HideDifferenceEntry extends ItemCard_Entry
   {
      
      public function ItemCard_HideDifferenceEntry()
      {
         super();
      }
      
      override public function PopulateEntry(aInfoObj:Object) : *
      {
         if(totalFrames > 1)
         {
            gotoAndStop(aInfoObj.difference != 0 ? (aInfoObj.difference > 0 ? "good" : "bad") : "default");
         }
         super.PopulateEntry(aInfoObj);
      }
   }
}

