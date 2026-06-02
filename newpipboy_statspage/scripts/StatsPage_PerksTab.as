package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol234")]
   public class StatsPage_PerksTab extends IPipBoyTab
   {
      
      private static const EFFECT_SPACING:Number = 3;
      
      private static const SCROLL_AMOUNT:Number = 50;
      
      private static const HEIGHT_OFFSET:Number = 50;
      
      public var ActiveEffects_mc:MovieClip;
      
      public var ScrollDown_mc:MovieClip;
      
      public var ScrollUp_mc:MovieClip;
      
      public var HideRect_mc:MovieClip;
      
      public var MaskRect_mc:MovieClip;
      
      private var m_EffectClips:Vector.<NewActiveEffectsWidget>;
      
      private var m_ShowingEffects:Boolean;
      
      private var m_EffectOrigY:Number;
      
      public function StatsPage_PerksTab()
      {
         super();
         this.m_EffectClips = new Vector.<NewActiveEffectsWidget>();
         this.m_EffectOrigY = this.ActiveEffects_mc.y;
         TabIndex = NewPipBoyShared.STATS_TAB_PERKS;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      override public function processProvider(aData:Object) : void
      {
         var info:Object = null;
         var newWidget:* = undefined;
         stage.focus = this;
         this.m_EffectClips.forEach(this.removeActiveEffectsWidget);
         this.m_EffectClips.splice(0,this.m_EffectClips.length);
         aData.EffectsA.sortOn(["IconType","Name"]);
         var currType:String = "";
         var accumY:Number = 0;
         for each(info in aData.EffectsA)
         {
            if(info.IconType != currType)
            {
               newWidget = new NewActiveEffectsWidget();
               newWidget.showingEffects = true;
               newWidget.EffectType = info.IconType;
               newWidget.SetWidgetInfo(aData.EffectsA);
               this.m_EffectClips.push(newWidget);
               this.ActiveEffects_mc.addChild(newWidget);
               newWidget.y = accumY;
               accumY += newWidget.height + EFFECT_SPACING;
               currType = info.IconType;
            }
         }
         this.ScrollActiveEffects(0);
      }
      
      private function removeActiveEffectsWidget(aItem:NewActiveEffectsWidget) : void
      {
         this.ActiveEffects_mc.removeChild(aItem);
      }
      
      private function onMouseWheel(aEvent:MouseEvent) : void
      {
         if(aEvent.delta > 0)
         {
            this.ScrollActiveEffects(SCROLL_AMOUNT);
         }
         else if(aEvent.delta < 0)
         {
            this.ScrollActiveEffects(-SCROLL_AMOUNT);
         }
         aEvent.stopPropagation();
      }
      
      private function ScrollActiveEffects(aDelta:Number) : void
      {
         var oldY:Number = this.ActiveEffects_mc.y;
         var maxScroll:Number = this.ActiveEffects_mc.height - this.HideRect_mc.height;
         maxScroll += HEIGHT_OFFSET;
         maxScroll = Math.max(0,maxScroll);
         var newPosition:Number = this.ActiveEffects_mc.y + aDelta;
         newPosition = Math.min(newPosition,this.m_EffectOrigY);
         newPosition = Math.max(newPosition,this.m_EffectOrigY - maxScroll);
         this.ActiveEffects_mc.y = newPosition;
         this.CheckScroll();
         if(oldY != this.ActiveEffects_mc.y)
         {
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_FOCUS_CHANGE);
         }
      }
      
      private function CheckScroll() : *
      {
         var scrollUpVis:* = false;
         var scrollDownVis:* = false;
         if(this.ActiveEffects_mc.height + HEIGHT_OFFSET > this.HideRect_mc.height)
         {
            scrollUpVis = this.ActiveEffects_mc.y < this.m_EffectOrigY;
            scrollDownVis = this.m_EffectOrigY + this.HideRect_mc.height < this.ActiveEffects_mc.y + this.ActiveEffects_mc.height + HEIGHT_OFFSET;
         }
         this.ScrollUp_mc.visible = scrollUpVis;
         this.ScrollDown_mc.visible = scrollDownVis;
      }
      
      override public function ProcessUserEvent(eventName:String) : Boolean
      {
         var handled:Boolean = false;
         var isUp:* = eventName == "Up";
         var isDown:* = eventName == "Down";
         if(isUp || isDown)
         {
            this.ScrollActiveEffects(isUp ? SCROLL_AMOUNT : -SCROLL_AMOUNT);
            handled = true;
         }
         return handled;
      }
      
      override public function ProcessRightThumbstickInput(auiDirection:uint) : Boolean
      {
         switch(auiDirection)
         {
            case NewPipBoyShared.DIRECTION_UP:
               this.ScrollActiveEffects(SCROLL_AMOUNT);
               break;
            case NewPipBoyShared.DIRECTION_DOWN:
               this.ScrollActiveEffects(-SCROLL_AMOUNT);
         }
         return true;
      }
   }
}

