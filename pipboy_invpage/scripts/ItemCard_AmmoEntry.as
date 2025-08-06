package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol281")]
   public class ItemCard_AmmoEntry extends ItemCard_Entry
   {
      
      public function ItemCard_AmmoEntry()
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

