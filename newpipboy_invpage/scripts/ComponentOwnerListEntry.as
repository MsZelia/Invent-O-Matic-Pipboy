package
{
   import Shared.AS3.BSScrollingListEntry;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol303")]
   public class ComponentOwnerListEntry extends BSScrollingListEntry
   {
      
      public function ComponentOwnerListEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
         TextFieldEx.setTextAutoSize(textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         textField.text = aEntryObject.toString();
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

