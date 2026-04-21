package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol190")]
   public class SpecialListEntry extends BSScrollingListEntry
   {
      
      public var Name_tf:TextField;
      
      public var Value_tf:TextField;
      
      public function SpecialListEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         gotoAndStop(selected ? "selected" : "unselected");
         this.Name_tf.text = aEntryObject.Type;
         var valueText:* = "";
         if(aEntryObject.isBonus != 0)
         {
            if(aEntryObject.isBonus < 0)
            {
               valueText += "( - ) ";
            }
            else if(aEntryObject.isBonus > 0)
            {
               valueText += "( + ) ";
            }
         }
         valueText += aEntryObject.Score.toString();
         this.Value_tf.text = valueText;
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

