package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6")]
   public class TitlesEntry extends BSScrollingListEntry
   {
      
      public var TitleName_tf:TextField;
      
      public var EquipIcon_mc:MovieClip;
      
      public function TitlesEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         gotoAndStop(selected ? "selected" : "unselected");
         this.TitleName_tf.text = aEntryObject.title as String;
         GlobalFunc.TruncateSingleLineText(this.TitleName_tf);
         this.EquipIcon_mc.visible = aEntryObject.formID == StatsPage_TitlesTab.SelectedForm;
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

