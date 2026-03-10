package
{
   import Shared.AS3.*;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol208")]
   public class StatsPage_StatusTab extends IPipBoyTab
   {
      
      private static const EFFECT_SPACING:Number = 10;
      
      private static const INTERSTITIAL:Number = 20;
      
      private static const PIPBOY_WIDTH:Number = 876;
      
      private static const MAX_SIMPLE_EFFECTS:uint = 6;
      
      public var Name_tf:TextField;
      
      public var Head_Meter:Pipboy_Meter;
      
      public var Torso_Meter:Pipboy_Meter;
      
      public var LArm_Meter:Pipboy_Meter;
      
      public var RArm_Meter:Pipboy_Meter;
      
      public var LLeg_Meter:Pipboy_Meter;
      
      public var RLeg_Meter:Pipboy_Meter;
      
      public var DMGWidget_mc:Stats_DMGDRWidget;
      
      public var DRWidget_mc:Stats_DMGDRWidget;
      
      public var ActiveEffects_mc:MovieClip;
      
      public var ActiveEffects_HideRect:MovieClip;
      
      public var ActiveEffects_MaskRect:MovieClip;
      
      public var ConditionBoyBase_mc:MovieClip;
      
      public var ConditionBoy_mc:ConditionBoy;
      
      private var m_Data:Object;
      
      private var m_ShownEffectIconTypes:Array = new Array();
      
      public function StatsPage_StatusTab()
      {
         super();
         TabIndex = NewPipBoyShared.STATS_TAB_STATUS;
         this.ConditionBoy_mc = this.ConditionBoyBase_mc.ConditionBoy_mc;
         this.ConditionBoy_mc.isMenuInstance = true;
      }
      
      public function setSharedInfo(aData:*) : void
      {
         this.Torso_Meter.SetMeter(aData.CurrentHP,0,aData.MaxHP);
      }
      
      override public function processProvider(aData:Object) : void
      {
         this.m_Data = aData;
         this.setDisplay();
      }
      
      private function setDisplay() : void
      {
         var info:Object = null;
         var damageTypes:Object = null;
         var newWidget:NewActiveEffectsWidget = null;
         this.setName(this.m_Data.baseName,this.m_Data.prefix,this.m_Data.suffix);
         while(this.ActiveEffects_mc.numChildren > 0)
         {
            this.ActiveEffects_mc.removeChildAt(0);
         }
         this.m_ShownEffectIconTypes = new Array();
         var accumY:Number = 0;
         for each(info in this.m_Data.ActiveEffects)
         {
            if(this.m_ShownEffectIconTypes.indexOf(info.type) == -1 && this.ActiveEffects_mc.numChildren < MAX_SIMPLE_EFFECTS)
            {
               newWidget = new NewActiveEffectsWidget();
               newWidget.showingEffects = false;
               newWidget.showingTimer = info.hasDuration;
               newWidget.percentage = info.percentage;
               newWidget.EffectType = info.type;
               newWidget.SetWidgetInfo(this.m_Data.ActiveEffects);
               switch(info.plusMinus)
               {
                  case -1:
                     GlobalFunc.SetText(newWidget.PlusMinus_tf,"( - )",false);
                     break;
                  case 1:
                     GlobalFunc.SetText(newWidget.PlusMinus_tf,"( + )",false);
                     break;
                  default:
                     GlobalFunc.SetText(newWidget.PlusMinus_tf,"",false);
               }
               this.m_ShownEffectIconTypes.push(info.type);
               this.ActiveEffects_mc.addChild(newWidget);
               newWidget.y = accumY;
               accumY += newWidget.height + EFFECT_SPACING;
            }
         }
         this.Head_Meter.SetMeter(this.m_Data.HeadHealthCurrent,0,100);
         this.LArm_Meter.SetMeter(this.m_Data.LeftArmHealthCurrent,0,100);
         this.RArm_Meter.SetMeter(this.m_Data.RightArmHealthCurrent,0,100);
         this.LLeg_Meter.SetMeter(this.m_Data.LeftLegHealthCurrent,0,100);
         this.RLeg_Meter.SetMeter(this.m_Data.RightLegHealthCurrent,0,100);
         this.ConditionBoy_mc.SetData(this.m_Data.ConditionBoy);
         damageTypes = this.m_Data.DamageTypes;
         if(damageTypes)
         {
            this.DMGWidget_mc.redraw(true,[damageTypes.Physical,damageTypes.Poison,damageTypes.Fire,damageTypes.Energy,damageTypes.Frost,damageTypes.Rad,damageTypes.Bleed]);
         }
         var resistTypes:Object = this.m_Data.ResistTypes;
         if(resistTypes)
         {
            this.DRWidget_mc.redraw(false,[resistTypes.Physical,resistTypes.Poison,resistTypes.Fire,resistTypes.Energy,resistTypes.Frost,resistTypes.Rad,resistTypes.Bleed]);
         }
         var widgetStartX:Number = (PIPBOY_WIDTH - (this.DMGWidget_mc.width + this.DRWidget_mc.width + INTERSTITIAL)) / 2;
         this.DMGWidget_mc.x = widgetStartX;
         this.DRWidget_mc.x = this.DMGWidget_mc.x + this.DMGWidget_mc.width + INTERSTITIAL;
      }
      
      private function setName(aBase:String, aPrefix:String, aSuffix:String) : void
      {
         this.Name_tf.text = aBase;
         if(aPrefix != "" || aSuffix != "")
         {
            this.Name_tf.appendText(GlobalFunc.CUSTOM_TITLE_DIVIDER);
            if(aPrefix != "")
            {
               this.Name_tf.appendText(" " + aPrefix);
            }
            if(aSuffix != "")
            {
               this.Name_tf.appendText(" " + aSuffix);
            }
         }
         GlobalFunc.TruncateSingleLineText(this.Name_tf);
      }
   }
}

