package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol282")]
   public class ItemCard_AmmoEntry extends ItemCard_Entry
   {
      
      public function ItemCard_AmmoEntry()
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

