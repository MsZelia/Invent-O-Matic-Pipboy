package
{
   import Shared.AS3.SWFLoaderClip;
   import Shared.AS3.SecureTradeShared;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol27")]
   public class ItemCard_ValueEntry extends ItemCard_Entry
   {
      
      private var _currencyType:uint = 0;
      
      private var currencyImageInstance:MovieClip;
      
      public function ItemCard_ValueEntry()
      {
         var currencyIcon:SWFLoaderClip = null;
         super();
         Extensions.enabled = true;
         if(Label_tf != null)
         {
            TextFieldEx.setTextAutoSize(Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         if(Value_tf != null)
         {
            TextFieldEx.setTextAutoSize(Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         if(Boolean(Icon_mc) && Icon_mc is SWFLoaderClip)
         {
            currencyIcon = Icon_mc as SWFLoaderClip;
            currencyIcon.clipWidth = currencyIcon.width * (1 / currencyIcon.scaleX);
            currencyIcon.clipHeight = currencyIcon.height * (1 / currencyIcon.scaleY);
         }
      }
      
      public function set currencyType(aCurrencyType:Number) : *
      {
         this._currencyType = aCurrencyType;
      }
      
      override public function PopulateText(aText:String) : *
      {
         if(Label_tf != null)
         {
            GlobalFunc.SetText(Label_tf,aText,false);
         }
      }
      
      override public function PopulateEntry(aInfoObj:Object) : *
      {
         var valueText:String = null;
         this.PopulateText(aInfoObj.text);
         if(Value_tf != null)
         {
            valueText = aInfoObj.value;
            GlobalFunc.SetText(Value_tf,valueText,false);
            if(Icon_mc != null)
            {
               Icon_mc.x = Value_tf.x + Value_tf.width - Value_tf.getLineMetrics(0).width - Icon_mc.width - 8;
               if(Icon_mc is SWFLoaderClip)
               {
                  if(this.currencyImageInstance != null)
                  {
                     Icon_mc.removeChild(this.currencyImageInstance);
                     this.currencyImageInstance = null;
                  }
                  this.currencyImageInstance = SecureTradeShared.setCurrencyIcon(Icon_mc as SWFLoaderClip,this._currencyType);
               }
            }
         }
      }
   }
}

