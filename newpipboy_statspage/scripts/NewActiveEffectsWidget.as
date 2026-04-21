package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol169")]
   public class NewActiveEffectsWidget extends MovieClip
   {
      
      public var IconBackground_mc:MovieClip;
      
      public var Icon_mc:MovieClip;
      
      public var TimerIcon_mc:MovieClip;
      
      public var EffectsBackground_mc:MovieClip;
      
      public var EntryHolder_mc:MovieClip;
      
      public var IconText_tf:TextField;
      
      public var PlusMinus_tf:TextField;
      
      private const ICON_SCALE:Number = 0.9;
      
      private const EFFECT_BG_SPACING:Number = 23;
      
      private var m_EffectType:String;
      
      private var m_ShowingEffects:Boolean;
      
      private var m_ShowingTimer:Boolean;
      
      private var m_EntryClips:Vector.<NewActiveEffectsEntry>;
      
      private var m_OriginalHeight:Number;
      
      public function NewActiveEffectsWidget()
      {
         super();
         this.m_ShowingEffects = true;
         this.m_ShowingTimer = false;
         this.m_EntryClips = new Vector.<NewActiveEffectsEntry>();
         this.IconText_tf.visible = false;
         this.m_OriginalHeight = this.height;
      }
      
      public function set EffectType(aVal:String) : void
      {
         this.m_EffectType = aVal;
      }
      
      public function set showingEffects(aVal:Boolean) : *
      {
         this.m_ShowingEffects = aVal;
      }
      
      public function set showingTimer(aVal:Boolean) : *
      {
         this.m_ShowingTimer = aVal;
      }
      
      public function set percentage(aText:String) : *
      {
         this.IconText_tf.text = aText;
         this.IconText_tf.visible = aText != "";
      }
      
      public function SetWidgetInfo(aEffects:Array) : void
      {
         var sourceInfo:Object = null;
         var newEntry:NewActiveEffectsEntry = null;
         this.m_EntryClips.splice(0,this.m_EntryClips.length);
         while(this.EntryHolder_mc.numChildren > 0)
         {
            this.EntryHolder_mc.removeChildAt(0);
         }
         this.m_ShowingTimer = false;
         var name:String = "";
         var accumY:Number = 0;
         if(Boolean(aEffects) && this.m_ShowingEffects)
         {
            for each(sourceInfo in aEffects)
            {
               if(sourceInfo.IconType == this.m_EffectType)
               {
                  newEntry = new NewActiveEffectsEntry();
                  this.m_ShowingTimer = sourceInfo.TimeRemainingLabel != "";
                  this.IconText_tf.visible = sourceInfo.IconLabel != "";
                  this.IconText_tf.text = sourceInfo.IconLabel;
                  newEntry.y = accumY;
                  newEntry.SetEffects(sourceInfo.EffectEntriesA,sourceInfo.Name,sourceInfo.TimeRemainingLabel);
                  this.EntryHolder_mc.addChild(newEntry);
                  accumY += newEntry.height;
               }
            }
            this.EffectsBackground_mc.height = this.EntryHolder_mc.height + this.EFFECT_BG_SPACING;
            this.IconBackground_mc.height = this.EffectsBackground_mc.height;
         }
         else
         {
            this.EffectsBackground_mc.height = this.EntryHolder_mc.height;
            this.IconBackground_mc.height = this.m_OriginalHeight;
         }
         if(this.IconText_tf.visible)
         {
            this.Icon_mc.scaleX = this.Icon_mc.scaleY = this.ICON_SCALE;
            this.Icon_mc.y -= 10;
            this.IconText_tf.y = this.Icon_mc.y + this.Icon_mc.height + 15;
         }
         this.Icon_mc.gotoAndStop(this.m_EffectType);
         this.EffectsBackground_mc.visible = this.m_ShowingEffects;
         this.EntryHolder_mc.visible = this.m_ShowingEffects;
         this.TimerIcon_mc.visible = this.m_ShowingTimer;
         this.PlusMinus_tf.visible = !this.m_ShowingEffects;
      }
   }
}

