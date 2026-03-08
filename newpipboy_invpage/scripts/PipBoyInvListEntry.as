package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol300")]
   public class PipBoyInvListEntry extends BSScrollingListEntry
   {
      
      private static const TEXT_PADDING:Number = 15;
      
      private static const ICON_OFFSET:Number = 10;
      
      public var EquipIcon_mc:MovieClip;
      
      public var FavIcon_mc:MovieClip;
      
      public var SearchIcon_mc:MovieClip;
      
      public var questItemIcon_mc:MovieClip;
      
      public var SetBonusIcon_mc:MovieClip;
      
      public var ItemLockIcon_mc:MovieClip;
      
      private var m_BaseTextFieldWidth:*;
      
      public function PipBoyInvListEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4);
         this.m_BaseTextFieldWidth = textField.width;
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         var frameSuffix:String = aEntryObject.CanEquip ? "" : "CantEquip";
         gotoAndStop(selected ? "selected" + frameSuffix : "unselected" + frameSuffix);
         TextFieldEx.setTextAutoSize(textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
         textField.text = aEntryObject.Name;
         var textFieldWidthDelta:* = 0;
         var numIcons:* = 0;
         var starsText:* = this.BuildLegendaryStarsGlyphString(aEntryObject);
         if(this.FavIcon_mc != null)
         {
            this.FavIcon_mc.gotoAndStop(selected ? "selected" : "unselected");
            this.FavIcon_mc.visible = aEntryObject.IsFavorited > 0;
            if(numIcons > 0)
            {
               textFieldWidthDelta += this.FavIcon_mc.width / 2 + ICON_OFFSET;
            }
            numIcons++;
         }
         if(this.SearchIcon_mc != null)
         {
            this.SearchIcon_mc.gotoAndStop(selected ? "selected" : "unselected");
            this.SearchIcon_mc.visible = aEntryObject.IsTaggedForSearch;
            if(numIcons > 0)
            {
               textFieldWidthDelta += this.SearchIcon_mc.width / 2 + ICON_OFFSET;
            }
         }
         if(this.questItemIcon_mc != null)
         {
            this.questItemIcon_mc.gotoAndStop(selected ? "selected" : "unselected");
            this.questItemIcon_mc.visible = aEntryObject.IsQuestItem;
            if(numIcons > 0)
            {
               textFieldWidthDelta += this.questItemIcon_mc.width / 2 + ICON_OFFSET;
            }
         }
         if(this.SetBonusIcon_mc != null)
         {
            this.SetBonusIcon_mc.gotoAndStop(selected ? "selected" : "unselected");
            this.SetBonusIcon_mc.visible = aEntryObject.isSetItem;
            if(this.SetBonusIcon_mc.visible == true)
            {
               this.SetBonusIcon_mc.gotoAndStop(Boolean(aEntryObject.isSetBonusActive) && aEntryObject.EquipState > 0 ? "active" : "inactive");
            }
            if(numIcons > 0)
            {
               textFieldWidthDelta += this.SetBonusIcon_mc.width / 2 + ICON_OFFSET;
            }
         }
         textField.width = this.m_BaseTextFieldWidth - textFieldWidthDelta;
         if(aEntryObject.IsLegendary)
         {
            textField.appendText(starsText);
            this.TruncateSingleLineLegendary(textField,aEntryObject.LegendaryStarsCount,GlobalFunc.MAX_TRUNCATED_TEXT_LENGTH);
         }
         else
         {
            GlobalFunc.SetText(textField,textField.text,false,false,true);
         }
         if(aEntryObject.Count != 1 || aEntryObject.formID != null)
         {
            textField.appendText(" (" + aEntryObject.Count + ")");
         }
         if(aEntryObject.Time != -1)
         {
            textField.appendText(" [" + GlobalFunc.LocalizeFormattedString("$TimeAgo",GlobalFunc.ShortTimeStringMinutes(aEntryObject.Time)) + "]");
         }
         GlobalFunc.SetText(textField,textField.text,false);
         var rightTextX:Number = this.textField.getLineMetrics(0).width + this.textField.x + TEXT_PADDING;
         if(this.ItemLockIcon_mc != null)
         {
            this.ItemLockIcon_mc.visible = aEntryObject.IsTransferLocked;
            if(this.ItemLockIcon_mc.visible)
            {
               this.ItemLockIcon_mc.gotoAndStop(Boolean(aEntryObject.IsTransferLocked) && aEntryObject.EquipState > 0 ? "isEquipped" : "isUnequipped");
            }
         }
         if(this.EquipIcon_mc != null)
         {
            this.EquipIcon_mc.visible = aEntryObject.EquipState > 0 && !this.ItemLockIcon_mc.visible;
         }
         if(this.FavIcon_mc != null && this.FavIcon_mc.visible)
         {
            this.FavIcon_mc.x = rightTextX;
            rightTextX += this.FavIcon_mc.width / 2 + ICON_OFFSET;
         }
         if(this.SearchIcon_mc != null && this.SearchIcon_mc.visible)
         {
            this.SearchIcon_mc.x = rightTextX;
            rightTextX += this.SearchIcon_mc.width / 2 + ICON_OFFSET;
         }
         if(this.questItemIcon_mc != null && this.questItemIcon_mc.visible)
         {
            this.questItemIcon_mc.x = rightTextX;
         }
         if(this.SetBonusIcon_mc != null && this.SetBonusIcon_mc.visible)
         {
            this.SetBonusIcon_mc.x = rightTextX;
         }
      }
      
      public function TruncateSingleLineLegendary(aTextField:TextField, aStars:int, aMaxLength:*) : *
      {
         var difference:int = 0;
         var beforeStars:String = null;
         var stars:String = null;
         if(aTextField.text.length > aMaxLength)
         {
            difference = aTextField.text.length - aMaxLength;
            beforeStars = aTextField.text.substr(0,aTextField.text.length - aStars);
            stars = aTextField.text.substr(aTextField.text.length - aStars,aStars);
            aTextField.text = beforeStars;
            aTextField.replaceText(aTextField.length - difference - aStars,aTextField.length,"…");
            aTextField.appendText(stars);
         }
      }
      
      private function BuildLegendaryStarsGlyphString(aEntryObject:Object) : String
      {
         var numLegendaryStars:uint = 0;
         var i:* = undefined;
         var textFieldTemp:TextField = null;
         var isLegendary:Boolean = false;
         var starsText:String = "";
         if(Boolean(aEntryObject.IsLegendary) && aEntryObject.LegendaryStarsCount > 0)
         {
            numLegendaryStars = uint(aEntryObject.LegendaryStarsCount);
            for(i = 0; i < numLegendaryStars; i++)
            {
               textFieldTemp = new TextField();
               textFieldTemp.text = "$LegendaryModGlyph";
               starsText += textFieldTemp.text;
            }
            starsText = " " + starsText;
         }
         return starsText;
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         stop();
      }
   }
}

