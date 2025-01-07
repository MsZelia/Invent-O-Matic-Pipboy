package
{
   import Shared.AS3.ItemListEntryBase;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol291")]
   public class InvListEntry extends ItemListEntryBase
   {
       
      
      public var EquipIcon_mc:MovieClip;
      
      public var FavIcon_mc:MovieClip;
      
      public var SearchIcon_mc:MovieClip;
      
      public var questItemIcon_mc:MovieClip;
      
      public var SetBonusIcon_mc:MovieClip;
      
      private var BaseTextFieldWidth:*;
      
      public function InvListEntry()
      {
         super();
         this.BaseTextFieldWidth = textField.width;
         TextFieldEx.setTextAutoSize(textField,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      override public function SetEntryText(param1:Object, param2:String) : *
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = GlobalFunc.BuildLegendaryStarsGlyphString(param1);
         if(this.FavIcon_mc != null)
         {
            this.FavIcon_mc.visible = param1.favorite > 0;
            if(_loc4_ > 0)
            {
               _loc3_ += this.FavIcon_mc.width / 2 + 10;
            }
            _loc4_++;
         }
         if(this.SearchIcon_mc != null)
         {
            this.SearchIcon_mc.visible = param1.taggedForSearch;
            if(_loc4_ > 0)
            {
               _loc3_ += this.SearchIcon_mc.width / 2 + 10;
            }
         }
         if(this.questItemIcon_mc != null)
         {
            this.questItemIcon_mc.visible = param1.isQuestItem;
            if(_loc4_ > 0)
            {
               _loc3_ += this.questItemIcon_mc.width / 2 + 10;
            }
         }
         if(this.SetBonusIcon_mc != null)
         {
            this.SetBonusIcon_mc.visible = param1.isSetItem;
            if(this.SetBonusIcon_mc.visible == true)
            {
               this.SetBonusIcon_mc.gotoAndStop(Boolean(param1.isSetBonusActive) && param1.equipState > 0 ? "active" : "inactive");
            }
            if(_loc4_ > 0)
            {
               _loc3_ += this.SetBonusIcon_mc.width / 2 + 10;
            }
         }
         textField.width = this.BaseTextFieldWidth - _loc3_;
         super.SetEntryText(param1,param2);
         if(param1.numLegendaryStars > 0)
         {
            textField.appendText(_loc5_);
            this.TruncateSingleLineLegendary(textField,param1.numLegendaryStars,GlobalFunc.MAX_TRUNCATED_TEXT_LENGTH);
         }
         else
         {
            GlobalFunc.SetText(textField,textField.text,false,false,true);
         }
         if(this.selected)
         {
            textField.textColor = 0;
         }
         else
         {
            textField.textColor = !!param1.canEquip ? 16777215 : 8421504;
         }
         var _loc6_:ColorTransform;
         (_loc6_ = border.transform.colorTransform).redOffset = !param1.canEquip ? -200 : 0;
         _loc6_.greenOffset = !param1.canEquip ? -200 : 0;
         _loc6_.blueOffset = !param1.canEquip ? -200 : 0;
         border.transform.colorTransform = _loc6_;
         if(param1.count != 1 || param1.formID != null)
         {
            textField.appendText(" (" + param1.count + ")");
         }
         if(param1.isNew && param1.time != null && param2 == "Time")
         {
            textField.appendText(" [" + GlobalFunc.LocalizeFormattedString("$TimeAgo",GlobalFunc.ShortTimeStringMinutes(param1.time)) + "]");
         }
         GlobalFunc.SetText(textField,textField.text,false);
         var _loc7_:Number = this.textField.getLineMetrics(0).width + this.textField.x + 15;
         if(this.EquipIcon_mc != null)
         {
            this.EquipIcon_mc.visible = param1.equipState > 0;
            if(this.EquipIcon_mc.visible)
            {
               SetColorTransform(this.EquipIcon_mc,this.selected);
            }
         }
         if(this.FavIcon_mc != null && this.FavIcon_mc.visible)
         {
            this.FavIcon_mc.x = _loc7_;
            _loc7_ += this.FavIcon_mc.width / 2 + 10;
            SetColorTransform(this.FavIcon_mc,this.selected);
         }
         if(this.SearchIcon_mc != null && this.SearchIcon_mc.visible)
         {
            this.SearchIcon_mc.x = _loc7_;
            _loc7_ += this.SearchIcon_mc.width / 2 + 10;
            SetColorTransform(this.SearchIcon_mc,this.selected);
         }
         if(this.questItemIcon_mc != null && this.questItemIcon_mc.visible)
         {
            this.questItemIcon_mc.x = _loc7_;
            SetColorTransform(this.questItemIcon_mc,this.selected);
         }
         if(this.SetBonusIcon_mc != null && this.SetBonusIcon_mc.visible)
         {
            this.SetBonusIcon_mc.x = _loc7_;
            SetColorTransform(this.SetBonusIcon_mc,this.selected);
         }
      }
      
      public function TruncateSingleLineLegendary(param1:TextField, param2:int, param3:*) : *
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(param1.text.length > param3)
         {
            _loc4_ = param1.text.length - param3;
            _loc5_ = param1.text.substr(0,param1.text.length - param2);
            _loc6_ = param1.text.substr(param1.text.length - param2,param2);
            param1.text = _loc5_;
            param1.replaceText(param1.length - _loc4_ - param2,param1.length,"…");
            param1.appendText(_loc6_);
         }
      }
   }
}
