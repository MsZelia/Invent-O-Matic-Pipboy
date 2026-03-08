package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   public class ItemCard_Entry extends MovieClip
   {
      
      public static var DynamicModDescEnable:Boolean = false;
      
      public static var AdvanceModDescMode:Boolean = false;
      
      public var Label_tf:TextField;
      
      public var Value_tf:TextField;
      
      public var Difference_mc:MovieClip;
      
      public var Comparison_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var Sizer_mc:MovieClip;
      
      private var m_Count:uint = 0;
      
      public function ItemCard_Entry()
      {
         super();
         Extensions.enabled = true;
      }
      
      public static function ShouldShowDifference(aInfoObj:Object) : Boolean
      {
         var precision:uint = aInfoObj.precision != undefined ? uint(aInfoObj.precision) : 0;
         var smallestStep:Number = 1;
         for(var radix:uint = 0; radix < precision; radix++)
         {
            smallestStep /= 10;
         }
         return Math.abs(aInfoObj.difference) >= smallestStep;
      }
      
      public function PopulateText(aText:String) : *
      {
         if(this.Label_tf != null)
         {
            GlobalFunc.SetText(this.Label_tf,aText,false);
            TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
      }
      
      public function PopulateEntry(aInfoObj:Object) : *
      {
         var adjustedDiff:Number = NaN;
         var valueText:* = null;
         if(ShouldShowDifference(aInfoObj))
         {
            if(Boolean(this.Difference_mc) && DynamicModDescEnable)
            {
               gotoAndStop(AdvanceModDescMode ? "numbers" : "symbols");
               switch(aInfoObj.text)
               {
                  case "$APCost":
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(aInfoObj.difference < 0 ? "Good" : "Bad");
                        this.Difference_mc.Difference_tf.text = (aInfoObj.difference > 0 ? "+" : "") + aInfoObj.difference.toFixed(aInfoObj.precision != undefined ? 1 : 0);
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(aInfoObj.difference < 0 ? "GoodDecrease" : "BadIncrease");
                     }
                     break;
                  case "$wt":
                     adjustedDiff = aInfoObj.difference * -1;
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(adjustedDiff < 0 ? "Good" : "Bad");
                        this.Difference_mc.Difference_tf.text = (adjustedDiff > 0 ? "+" : "") + adjustedDiff.toFixed(aInfoObj.precision != undefined ? 1 : 0);
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(adjustedDiff < 0 ? "GoodDecrease" : "BadIncrease");
                     }
                     break;
                  default:
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(aInfoObj.difference < 0 ? "Bad" : "Good");
                        this.Difference_mc.Difference_tf.text = (aInfoObj.difference > 0 ? "+" : "") + aInfoObj.difference.toFixed(aInfoObj.precision != undefined ? 1 : 0);
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(aInfoObj.difference < 0 ? "BadDecrease" : "GoodIncrease");
                     }
               }
               if(this.Difference_mc.Difference_tf)
               {
                  TextFieldEx.setTextAutoSize(this.Difference_mc.Difference_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               }
            }
            else if(this.Comparison_mc != null)
            {
               switch(aInfoObj.diffRating)
               {
                  case -3:
                     this.Comparison_mc.gotoAndStop("Worst");
                     break;
                  case -2:
                     this.Comparison_mc.gotoAndStop("Worse");
                     break;
                  case -1:
                     this.Comparison_mc.gotoAndStop("Bad");
                     break;
                  case 1:
                     this.Comparison_mc.gotoAndStop("Good");
                     break;
                  case 2:
                     this.Comparison_mc.gotoAndStop("Better");
                     break;
                  case 3:
                     this.Comparison_mc.gotoAndStop("Best");
                     break;
                  default:
                     this.Comparison_mc.gotoAndStop("None");
               }
            }
         }
         if(this.Label_tf != null)
         {
            TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         if(this.Value_tf != null)
         {
            TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         }
         this.PopulateText(aInfoObj.text);
         if(this.Value_tf != null)
         {
            if(aInfoObj.value is String)
            {
               valueText = aInfoObj.value;
            }
            else
            {
               valueText = this.getValueTextWithPrecision(aInfoObj.value,aInfoObj.precision,aInfoObj.scaleWithDuration,aInfoObj.duration);
               if(aInfoObj.showAsPercent)
               {
                  valueText += "%";
               }
            }
            GlobalFunc.SetText(this.Value_tf,valueText,false);
            this.setIconPosition();
         }
      }
      
      public function getValueTextWithPrecision(aValue:Number, aPrecision:uint, aScaleWithDuration:Boolean, aDuration:uint) : String
      {
         var valueText:String = null;
         var val:Number = aValue;
         if(aScaleWithDuration)
         {
            val *= aDuration;
         }
         var precision:uint = aPrecision ? aPrecision : 0;
         valueText = val.toFixed(precision);
         if(val > 0 && parseFloat(valueText) < 0.001)
         {
            valueText = "< 0.001";
         }
         return GlobalFunc.TrimZeros(valueText);
      }
      
      public function setIconPosition() : void
      {
         if(this.Icon_mc != null)
         {
            this.Icon_mc.x = this.Value_tf.x + this.Value_tf.width - this.Value_tf.getLineMetrics(0).width - this.Icon_mc.width / 2 - 8;
         }
      }
      
      public function populateStackWeight(aInfoObj:Object, aCount:uint) : void
      {
         var valueText:String = null;
         this.PopulateText("$StackWeight");
         TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         var val:Number = aInfoObj.value * aCount;
         if(val < 1)
         {
            valueText = "< 1";
         }
         else
         {
            valueText = val.toFixed(0);
         }
         GlobalFunc.SetText(this.Value_tf,valueText,false);
      }
   }
}

