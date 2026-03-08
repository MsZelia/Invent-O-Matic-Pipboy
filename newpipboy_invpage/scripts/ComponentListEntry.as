package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol306")]
   public class ComponentListEntry extends BSScrollingListEntry
   {
      
      private static const TEXT_PADDING:Number = 15;
      
      private static const ICON_OFFSET:Number = 10;
      
      public var EquipIcon_mc:MovieClip;
      
      public var SearchIcon_mc:MovieClip;
      
      private var m_BaseTextFieldWidth:*;
      
      public function ComponentListEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
         this.m_BaseTextFieldWidth = textField.width;
         TextFieldEx.setTextAutoSize(textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         var frameSuffix:String = aEntryObject.canEquip ? "" : "CantEquip";
         gotoAndStop(selected ? "selected" + frameSuffix : "unselected" + frameSuffix);
         textField.text = aEntryObject.text;
         var textFieldWidthDelta:* = 0;
         var numIcons:* = 0;
         if(this.SearchIcon_mc != null)
         {
            this.SearchIcon_mc.visible = aEntryObject.taggedForSearch;
            if(numIcons > 0)
            {
               textFieldWidthDelta += this.SearchIcon_mc.width / 2 + ICON_OFFSET;
            }
         }
         textField.width = this.m_BaseTextFieldWidth - textFieldWidthDelta;
         GlobalFunc.SetText(textField,textField.text,false,false,true);
         if(aEntryObject.count != 1 || aEntryObject.componentFormID != null)
         {
            textField.appendText(" (" + aEntryObject.count + ")");
         }
         GlobalFunc.SetText(textField,textField.text,false);
         var rightTextX:Number = this.textField.getLineMetrics(0).width + this.textField.x + TEXT_PADDING;
         if(this.EquipIcon_mc != null)
         {
            this.EquipIcon_mc.visible = aEntryObject.EquipState > 0;
         }
         if(this.SearchIcon_mc != null && this.SearchIcon_mc.visible)
         {
            this.SearchIcon_mc.x = rightTextX;
            rightTextX += this.SearchIcon_mc.width / 2 + ICON_OFFSET;
         }
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

