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
      
      public static function ShouldShowDifference(param1:Object) : Boolean
      {
         var _loc2_:uint = param1.precision != undefined ? uint(param1.precision) : 0;
         var _loc3_:Number = 1;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ /= 10;
            _loc4_++;
         }
         return Math.abs(param1.difference) >= _loc3_;
      }
      
      public function PopulateText(param1:String) : *
      {
         if(this.Label_tf != null)
         {
            GlobalFunc.SetText(this.Label_tf,param1,false);
         }
      }
      
      public function PopulateEntry(param1:Object) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = null;
         if(ShouldShowDifference(param1))
         {
            if(Boolean(this.Difference_mc) && DynamicModDescEnable)
            {
               gotoAndStop(AdvanceModDescMode ? "numbers" : "symbols");
               switch(param1.text)
               {
                  case "$APCost":
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(param1.difference < 0 ? "Good" : "Bad");
                        this.Difference_mc.Difference_tf.text = (param1.difference > 0 ? "+" : "") + param1.difference.toFixed(param1.precision != undefined ? 1 : 0);
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(param1.difference < 0 ? "GoodDecrease" : "BadIncrease");
                     }
                     break;
                  case "$wt":
                     _loc2_ = param1.difference * -1;
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(_loc2_ < 0 ? "Good" : "Bad");
                        this.Difference_mc.Difference_tf.text = (_loc2_ > 0 ? "+" : "") + _loc2_.toFixed(param1.precision != undefined ? 1 : 0);
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(_loc2_ < 0 ? "GoodDecrease" : "BadIncrease");
                     }
                     break;
                  default:
                     if(AdvanceModDescMode)
                     {
                        this.Difference_mc.gotoAndStop(param1.difference < 0 ? "Bad" : "Good");
                        this.Difference_mc.Difference_tf.text = (param1.difference > 0 ? "+" : "") + param1.difference.toFixed(param1.precision != undefined ? 1 : 0);
                     }
                     else
                     {
                        this.Difference_mc.gotoAndStop(param1.difference < 0 ? "BadDecrease" : "GoodIncrease");
                     }
               }
               if(this.Difference_mc.Difference_tf)
               {
                  TextFieldEx.setTextAutoSize(this.Difference_mc.Difference_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
               }
            }
            else if(this.Comparison_mc != null)
            {
               switch(param1.diffRating)
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
         this.PopulateText(param1.text);
         if(this.Value_tf != null)
         {
            if(param1.value is String)
            {
               _loc3_ = param1.value;
            }
            else
            {
               _loc3_ = this.getValueTextWithPrecision(param1.value,param1.precision,param1.scaleWithDuration,param1.duration);
               if(param1.showAsPercent)
               {
                  _loc3_ += "%";
               }
            }
            GlobalFunc.SetText(this.Value_tf,_loc3_,false);
            this.setIconPosition();
         }
      }
      
      public function getValueTextWithPrecision(param1:Number, param2:uint, param3:Boolean, param4:uint) : String
      {
         var _loc5_:String = null;
         var _loc6_:Number = param1;
         if(param3)
         {
            _loc6_ *= param4;
         }
         var _loc7_:uint = !!param2 ? param2 : 0;
         _loc5_ = _loc6_.toFixed(_loc7_);
         if(_loc6_ > 0 && parseFloat(_loc5_) < 0.001)
         {
            _loc5_ = "< 0.001";
         }
         return GlobalFunc.TrimZeros(_loc5_);
      }
      
      public function setIconPosition() : void
      {
         if(this.Icon_mc != null)
         {
            this.Icon_mc.x = this.Value_tf.x + this.Value_tf.width - this.Value_tf.getLineMetrics(0).width - this.Icon_mc.width / 2 - 8;
         }
      }
      
      public function populateStackWeight(param1:Object, param2:uint) : void
      {
         var _loc4_:String = null;
         this.PopulateText("$StackWeight");
         TextFieldEx.setTextAutoSize(this.Label_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         var _loc3_:Number = param1.value * param2;
         if(_loc3_ < 1)
         {
            _loc4_ = "< 1";
         }
         else
         {
            _loc4_ = _loc3_.toFixed(0);
         }
         GlobalFunc.SetText(this.Value_tf,_loc4_,false);
      }
   }
}
