package
{
   import Shared.AS3.BSButtonHint;
   import Shared.AS3.BSButtonHintData;
   import fl.transitions.Tween;
   import fl.transitions.easing.Regular;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol444")]
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
      
      public function set ShouldUpdateItemCardScroll(aBool:Boolean) : void
      {
         this.m_ShouldUpdateItemCardScroll = aBool;
      }
      
      public function get DisableInput() : Boolean
      {
         return this.m_DisableInput;
      }
      
      public function set DisableInput(aBool:Boolean) : void
      {
         this.m_DisableInput = aBool;
      }
      
      public function get AllowAutoScroll() : Boolean
      {
         return this.m_AllowAutoScroll;
      }
      
      public function set AllowAutoScroll(aBool:Boolean) : void
      {
         this.m_AllowAutoScroll = aBool;
      }
      
      public function ProcessRightThumbstickInput(auiDirection:uint) : Boolean
      {
         var bHandled:Boolean = false;
         if(this.isItemCardScrollable() && !this.DisableInput && visible)
         {
            if(auiDirection == 1)
            {
               this.scrollItemCard(true);
            }
            else if(auiDirection == 3)
            {
               this.scrollItemCard(false);
            }
            bHandled = true;
         }
         return bHandled;
      }
      
      public function onMouseWheel(event:MouseEvent) : void
      {
         var globalMouse:Point = localToGlobal(new Point(mouseX,mouseY));
         if(this.isItemCardScrollable() && !this.DisableInput && visible && hitTestPoint(globalMouse.x,globalMouse.y))
         {
            if(event.delta > 0)
            {
               this.scrollItemCard(true);
            }
            else if(event.delta < 0)
            {
               this.scrollItemCard(false);
            }
            event.stopPropagation();
         }
      }
      
      public function isItemCardScrollable() : Boolean
      {
         return this.ItemCard_mc.height > this.m_OriginalMaskSizerHeight;
      }
      
      private function scrollItemCard(aIsScrollUp:Boolean) : void
      {
         var maxY:Number = this.m_OriginalItemCardY + this.m_HeightDifference;
         this.clearTween();
         if(aIsScrollUp)
         {
            if(this.ItemCard_mc.y < maxY)
            {
               this.ItemCard_mc.y = Math.min(this.ItemCard_mc.y + SCROLL_SPEED,maxY);
            }
         }
         else if(this.ItemCard_mc.y > this.m_OriginalItemCardY)
         {
            this.ItemCard_mc.y = Math.max(this.ItemCard_mc.y - SCROLL_SPEED,this.m_OriginalItemCardY);
         }
         this.ScrollUp_mc.visible = this.ItemCard_mc.y != maxY;
         this.ScrollDown_mc.visible = this.ItemCard_mc.y != this.m_OriginalItemCardY;
      }
      
      private function onItemCardUpdated() : void
      {
         var isMinHeightDiff:* = false;
         var tweenTime:Number = NaN;
         if(this.m_ShouldUpdateItemCardScroll)
         {
            this.m_ShouldUpdateItemCardScroll = false;
            this.m_HeightDifference = this.ItemCard_mc.height - this.m_OriginalMaskSizerHeight;
            isMinHeightDiff = this.m_HeightDifference >= SCROLL_MIN_HEIGHT_DIFF;
            if(this.isItemCardScrollable())
            {
               this.ScrollUp_mc.visible = isMinHeightDiff;
               this.ScrollDown_mc.visible = isMinHeightDiff;
               this.ScrollButtonData.ButtonVisible = isMinHeightDiff;
               this.ItemCard_mc.y = this.m_OriginalItemCardY + this.m_HeightDifference;
               if(isMinHeightDiff)
               {
                  this.clearTween();
                  this.MaskSizer_mc.height = this.m_OriginalMaskSizerHeight;
                  this.MaskSizer_mc.y = this.m_OriginalMaskSizerY;
                  if(this.m_AllowAutoScroll)
                  {
                     tweenTime = this.m_HeightDifference * TWEEN_TIME_MODIFIER;
                     this.m_ItemCardTween = new Tween(this.ItemCard_mc,"y",Regular.easeInOut,this.ItemCard_mc.y,this.m_OriginalItemCardY,tweenTime,true);
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

