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
         var _loc1_:SWFLoaderClip = null;
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
            _loc1_ = Icon_mc as SWFLoaderClip;
            _loc1_.clipWidth = _loc1_.width * (1 / _loc1_.scaleX);
            _loc1_.clipHeight = _loc1_.height * (1 / _loc1_.scaleY);
         }
      }
      
      public function set currencyType(param1:Number) : *
      {
         this._currencyType = param1;
      }
      
      override public function PopulateText(param1:String) : *
      {
         if(Label_tf != null)
         {
            GlobalFunc.SetText(Label_tf,param1,false);
         }
      }
      
      override public function PopulateEntry(param1:Object) : *
      {
         var _loc2_:String = null;
         this.PopulateText(param1.text);
         if(Value_tf != null)
         {
            _loc2_ = param1.value;
            GlobalFunc.SetText(Value_tf,_loc2_,false);
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

