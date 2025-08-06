package
{
   import Shared.AS3.BSButtonHint;
   import Shared.AS3.BSButtonHintData;
   import fl.transitions.Tween;
   import fl.transitions.easing.Regular;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol460")]
   public class ItemCardScrollable extends MovieClip
   {
      
      private static const ITEM_CARD_SCROLL_PADDING:Number = 4;
      
      private static const TWEEN_TIME_MODIFIER:Number = 0.06;
      
      private static const SCROLL_SPEED:Number = 30;
      
      private static const SCROLL_MIN_HEIGHT_DIFF:Number = 40;
      
      public var ItemCard_mc:ItemCard;
      
      public var MaskSizer_mc:MovieClip;
      
      public var ScrollUp_mc:MovieClip;
      
      public var ScrollDown_mc:MovieClip;
      
      public var ScrollButton_mc:BSButtonHint;
      
      private var m_OriginalItemCardY:Number;
      
      private var m_OriginalMaskSizerY:Number;
      
      private var m_OriginalMaskSizerHeight:Number;
      
      private var m_HeightDifference:Number = 0;
      
      private var m_ShouldUpdateItemCardScroll:Boolean = false;
      
      private var m_DisableInput:Boolean = false;
      
      private var m_AllowAutoScroll:Boolean = true;
      
      private var m_ItemCardTween:Tween;
      
      private var ScrollButtonData:BSButtonHintData = new BSButtonHintData("","","PSN_RS","Xenon_RS",1,null);
      
      public function ItemCardScrollable()
      {
         super();
         this.m_OriginalItemCardY = this.ItemCard_mc.y;
         this.m_OriginalMaskSizerY = this.MaskSizer_mc.y;
         this.m_OriginalMaskSizerHeight = this.MaskSizer_mc.height;
         this.ScrollUp_mc.visible = false;
         this.ScrollDown_mc.visible = false;
         this.ItemCard_mc.addEventListener(ItemCard.EVENT_ITEM_CARD_UPDATED,this.onItemCardUpdated);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,false,0,true);
         this.ScrollButton_mc.ButtonHintData = this.ScrollButtonData;
         this.ScrollButtonData.ButtonVisible = false;
      }
      
      public function get ShouldUpdateItemCardScroll() : Boolean
      {
         return this.m_ShouldUpdateItemCardScroll;
      }
      
      public function set ShouldUpdateItemCardScroll(param1:Boolean) : void
      {
         this.m_ShouldUpdateItemCardScroll = param1;
      }
      
      public function get DisableInput() : Boolean
      {
         return this.m_DisableInput;
      }
      
      public function set DisableInput(param1:Boolean) : void
      {
         this.m_DisableInput = param1;
      }
      
      public function get AllowAutoScroll() : Boolean
      {
         return this.m_AllowAutoScroll;
      }
      
      public function set AllowAutoScroll(param1:Boolean) : void
      {
         this.m_AllowAutoScroll = param1;
      }
      
      public function ProcessRightThumbstickInput(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.isItemCardScrollable() && !this.DisableInput && visible)
         {
            if(param1 == 1)
            {
               this.scrollItemCard(true);
            }
            else if(param1 == 3)
            {
               this.scrollItemCard(false);
            }
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:Point = localToGlobal(new Point(mouseX,mouseY));
         if(this.isItemCardScrollable() && !this.DisableInput && visible && hitTestPoint(_loc2_.x,_loc2_.y))
         {
            if(param1.delta > 0)
            {
               this.scrollItemCard(true);
            }
            else if(param1.delta < 0)
            {
               this.scrollItemCard(false);
            }
            param1.stopPropagation();
         }
      }
      
      public function isItemCardScrollable() : Boolean
      {
         return this.ItemCard_mc.height > this.m_OriginalMaskSizerHeight;
      }
      
      private function scrollItemCard(param1:Boolean) : void
      {
         var _loc2_:Number = this.m_OriginalItemCardY + this.m_HeightDifference;
         this.clearTween();
         if(param1)
         {
            if(this.ItemCard_mc.y < _loc2_)
            {
               this.ItemCard_mc.y = Math.min(this.ItemCard_mc.y + SCROLL_SPEED,_loc2_);
            }
         }
         else if(this.ItemCard_mc.y > this.m_OriginalItemCardY)
         {
            this.ItemCard_mc.y = Math.max(this.ItemCard_mc.y - SCROLL_SPEED,this.m_OriginalItemCardY);
         }
         this.ScrollUp_mc.visible = this.ItemCard_mc.y != _loc2_;
         this.ScrollDown_mc.visible = this.ItemCard_mc.y != this.m_OriginalItemCardY;
      }
      
      private function onItemCardUpdated() : void
      {
         var _loc1_:* = false;
         var _loc2_:Number = NaN;
         if(this.m_ShouldUpdateItemCardScroll)
         {
            this.m_ShouldUpdateItemCardScroll = false;
            this.m_HeightDifference = this.ItemCard_mc.height - this.m_OriginalMaskSizerHeight;
            _loc1_ = this.m_HeightDifference >= SCROLL_MIN_HEIGHT_DIFF;
            if(this.isItemCardScrollable())
            {
               this.ScrollUp_mc.visible = _loc1_;
               this.ScrollDown_mc.visible = _loc1_;
               this.ScrollButtonData.ButtonVisible = _loc1_;
               this.ItemCard_mc.y = this.m_OriginalItemCardY + this.m_HeightDifference;
               if(_loc1_)
               {
                  this.clearTween();
                  this.MaskSizer_mc.height = this.m_OriginalMaskSizerHeight;
                  this.MaskSizer_mc.y = this.m_OriginalMaskSizerY;
                  if(this.m_AllowAutoScroll)
                  {
                     _loc2_ = this.m_HeightDifference * TWEEN_TIME_MODIFIER;
                     this.m_ItemCardTween = new Tween(this.ItemCard_mc,"y",Regular.easeInOut,this.ItemCard_mc.y,this.m_OriginalItemCardY,_loc2_,true);
                     this.m_ItemCardTween.looping = true;
                  }
               }
               else
               {
                  this.clearTween();
                  this.ItemCard_mc.y = this.m_OriginalItemCardY;
                  this.MaskSizer_mc.height = this.m_OriginalMaskSizerHeight + this.m_HeightDifference;
                  this.MaskSizer_mc.y = this.m_OriginalMaskSizerY - this.m_HeightDifference;
               }
            }
            else
            {
               this.ScrollUp_mc.visible = false;
               this.ScrollDown_mc.visible = false;
               this.ScrollButtonData.ButtonVisible = false;
               this.ItemCard_mc.y = this.m_OriginalItemCardY;
               this.MaskSizer_mc.height = this.m_OriginalMaskSizerHeight;
               this.MaskSizer_mc.y = this.m_OriginalMaskSizerY;
               this.m_HeightDifference = 0;
               this.clearTween();
            }
         }
      }
      
      private function clearTween() : void
      {
         if(this.m_ItemCardTween != null)
         {
            this.m_ItemCardTween.stop();
            this.m_ItemCardTween = null;
         }
      }
   }
}

