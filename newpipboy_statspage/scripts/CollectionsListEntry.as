package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol195")]
   public class CollectionsListEntry extends BSScrollingListEntry
   {
      
      public var Value_tf:TextField;
      
      public var CurrencyName_tf:TextField;
      
      public function CollectionsListEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         gotoAndStop(selected ? "selected" : "unselected");
         this.Value_tf.text = aEntryObject.Value.toString();
         this.CurrencyName_tf.text = aEntryObject.Name.toString();
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

