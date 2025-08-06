package Shared
{
   import Shared.AS3.BSSlider;
   import Shared.AS3.BSUIComponent;
   import Shared.AS3.Events.CustomEvent;
   import flash.display.LineScaleMode;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol17")]
   public class QuantityMenuNEW extends BSUIComponent
   {
      
      public static const QUANTITY_CHANGED:* = "QuantityChanged";
      
      public var Header_tf:TextField;
      
      public var TopBracketHolder_mc:MovieClip;
      
      public var Count_tf:TextField;
      
      public var Slider_mc:BSSlider;
      
      public var Background_mc:MovieClip;
      
      private var _CurrCount:uint;
      
      private var _MaxCount:uint;
      
      private var _init:Boolean = false;
      
      public function QuantityMenuNEW(param1:uint)
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Header_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Count_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         this.Count_tf.addEventListener(MouseEvent.CLICK,this.onValueClicked);
         this._MaxCount = param1;
         if(this.Slider_mc != null)
         {
            this.Slider_mc.maxValue = this._MaxCount;
            this.Slider_mc.minValue = 1;
            this.Slider_mc.value = this._MaxCount;
            this.Slider_mc.controllerBumberJumpSize = Math.max(param1 / 20,1);
            this.Slider_mc.controllerTriggerJumpSize = Math.max(param1 / 4,1);
         }
         this.count = param1;
         addEventListener(BSSlider.VALUE_CHANGED,this.onSliderValueChanged,false,0,true);
         this.Slider_mc.addParentScrollEvents();
         this.visible = false;
         this.Count_tf.restrict = "0-9";
         this.Count_tf.selectable = true;
         this.Count_tf.type = TextFieldType.INPUT;
         this.Count_tf.border = true;
         this.Count_tf.borderColor = 16777215;
      }
      
      override public function onRemovedFromStage() : void
      {
         removeEventListener(BSSlider.VALUE_CHANGED,this.onSliderValueChanged);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.Count_tf.removeEventListener(MouseEvent.CLICK,this.onValueClicked);
      }
      
      override public function onAddedToStage() : void
      {
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      public function onValueClicked(param1:MouseEvent) : *
      {
         stage.focus = this;
         this.Count_tf.setSelection(0,this.Count_tf.text.length);
      }
      
      public function onKeyDown(param1:KeyboardEvent) : *
      {
         if(!_init)
         {
            this.onValueClicked(null);
            _init = true;
         }
         if(param1.keyCode >= Keyboard.NUMBER_0 && param1.keyCode <= Keyboard.NUMBER_9 || param1.keyCode >= Keyboard.NUMPAD_0 && param1.keyCode <= Keyboard.NUMPAD_9)
         {
            if(this.Count_tf.selectionEndIndex - this.Count_tf.selectionBeginIndex == this.Count_tf.text.length)
            {
               this.Count_tf.text = "";
            }
            if(stage.focus != this.Count_tf)
            {
               this.Count_tf.text += String.fromCharCode(param1.charCode);
            }
            this.updateQuantityInput(uint(this.Count_tf.text));
         }
         else if(param1.keyCode == Keyboard.BACKSPACE)
         {
            if(this.Count_tf.selectionEndIndex - this.Count_tf.selectionBeginIndex == this.Count_tf.text.length)
            {
               this.Count_tf.text = "";
            }
            else if(stage.focus != this.Count_tf)
            {
               if(this.Count_tf.text.length > 0)
               {
                  this.Count_tf.text = this.Count_tf.text.substr(0,this.Count_tf.text.length - 1);
               }
            }
            if(this.Count_tf.text.length > 0)
            {
               this.updateQuantityInput(uint(this.Count_tf.text));
            }
         }
      }
      
      public function updateQuantityInput(value:uint) : void
      {
         if(this.Slider_mc)
         {
            this.Slider_mc.value = value;
            this.count = this.Slider_mc.value;
         }
      }
      
      public function get count() : uint
      {
         return this._CurrCount;
      }
      
      public function set count(param1:uint) : *
      {
         this._CurrCount = param1;
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         var _loc1_:Point = null;
         var _loc2_:int = 0;
         var _loc3_:Shape = null;
         var _loc4_:Shape = null;
         super.redrawUIComponent();
         if(this.TopBracketHolder_mc.numChildren == 0)
         {
            _loc1_ = new Point();
            _loc2_ = this.Header_tf.x + this.Header_tf.getLineMetrics(0).x;
            _loc1_.x = _loc2_ + this.Header_tf.getCharBoundaries(0).x;
            _loc1_.y = _loc2_ + this.Header_tf.getCharBoundaries(this.Header_tf.text.length - 1).right;
            _loc3_ = new Shape();
            _loc3_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
            _loc3_.graphics.moveTo(0,0);
            _loc3_.graphics.lineTo(this.Header_tf.getCharBoundaries(0).x + 12.5,0);
            this.TopBracketHolder_mc.addChild(_loc3_);
            _loc4_ = new Shape();
            _loc4_.graphics.lineStyle(2,16777215,1,true,LineScaleMode.NONE);
            _loc4_.graphics.moveTo(this.Header_tf.getCharBoundaries(this.Header_tf.text.length - 1).right + 25,0);
            _loc4_.graphics.lineTo(this.Background_mc.x + this.Background_mc.width - this.TopBracketHolder_mc.x - 4,0);
            this.TopBracketHolder_mc.addChild(_loc4_);
         }
         GlobalFunc.SetText(this.Count_tf,this.count.toString(),false);
         this.visible = true;
      }
      
      public function onSliderValueChanged(param1:CustomEvent) : *
      {
         var _loc2_:uint = param1.params as uint;
         if(this.count != _loc2_)
         {
            this.count = _loc2_;
            dispatchEvent(new CustomEvent(QUANTITY_CHANGED,_loc2_,true));
         }
      }
      
      public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         return this.Slider_mc.ProcessUserEvent(param1,param2);
      }
   }
}

