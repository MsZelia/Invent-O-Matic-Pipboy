package
{
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol271")]
   public class ItemCard_DescriptionEntry extends ItemCard_Entry
   {
      
      public var Background_mc:MovieClip;
      
      public function ItemCard_DescriptionEntry()
      {
         super();
         TextFieldEx.setTextAutoSize(Label_tf,TextFieldEx.TEXTAUTOSZ_NONE);
         Label_tf.autoSize = TextFieldAutoSize.LEFT;
         Label_tf.multiline = true;
         Label_tf.wordWrap = true;
      }
      
      override public function PopulateEntry(aInfoObj:Object) : *
      {
         super.PopulateEntry(aInfoObj);
         this.Background_mc.height = Label_tf.textHeight + 5;
      }
      
      public function PopulateEntries(aInfoObjects:Array) : *
      {
         var infoObject:Object = null;
         super.PopulateEntry(aInfoObjects[0]);
         var combinedDescriptionString:String = "";
         for each(infoObject in aInfoObjects)
         {
            if(combinedDescriptionString == "")
            {
               combinedDescriptionString = infoObject.text == "Description" ? infoObject.value : infoObject.text;
            }
            else
            {
               combinedDescriptionString += infoObject.text == "Description" ? "$$ItemCard_DescriptionEntryConcatenator " + infoObject.value : "$$ItemCard_DescriptionEntryConcatenator " + infoObject.value;
            }
         }
         PopulateText(combinedDescriptionString);
         this.Background_mc.height = Label_tf.textHeight + 5;
      }
   }
}

