package
{
   public class ItemCard_FireModeEntry extends ItemCard_Entry
   {
      
      public function ItemCard_FireModeEntry()
      {
         super();
      }
      
      override public function PopulateEntry(aInfoObj:Object) : *
      {
         if(totalFrames > 1)
         {
            gotoAndStop(aInfoObj.difference != 0 ? "difference" : "default");
         }
         super.PopulateEntry(aInfoObj);
      }
   }
}

