package
{
   import Shared.EnumHelper;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol477")]
   public class NewPaperDoll extends MovieClip
   {
      
      public var Helmet_mc:MovieClip;
      
      public var LeftLeg_mc:MovieClip;
      
      public var LeftArm_mc:MovieClip;
      
      public var Torso_mc:MovieClip;
      
      public var Goggles_mc:MovieClip;
      
      public var GasMask_mc:MovieClip;
      
      public var RightLeg_mc:MovieClip;
      
      public var RightArm_mc:MovieClip;
      
      public var HeadResist_mc:PaperDollResistEntry;
      
      public var TorsoResist_mc:PaperDollResistEntry;
      
      public var LArmResist_mc:PaperDollResistEntry;
      
      public var RArmResist_mc:PaperDollResistEntry;
      
      public var LLegResist_mc:PaperDollResistEntry;
      
      public var RLegResist_mc:PaperDollResistEntry;
      
      private const IDX_UNDERWEAR:uint = EnumHelper.GetEnum(0);
      
      private const IDX_LEFT_LEG:uint = EnumHelper.GetEnum();
      
      private const IDX_RIGHT_LEG:uint = EnumHelper.GetEnum();
      
      private const IDX_LEFT_ARM:uint = EnumHelper.GetEnum();
      
      private const IDX_RIGHT_ARM:uint = EnumHelper.GetEnum();
      
      private const IDX_TORSO:uint = EnumHelper.GetEnum();
      
      private const IDX_HELMET:uint = EnumHelper.GetEnum();
      
      private const IDX_GOGGLES:uint = EnumHelper.GetEnum();
      
      private const IDX_GAS_MASK:uint = EnumHelper.GetEnum();
      
      private const UNDERWEAR_NONE:uint = 0;
      
      private const UNDERWEAR_GENERIC:uint = 0;
      
      private const UNDERWEAR_VAULT:uint = 0;
      
      private var m_DisplayedDamageType:uint;
      
      private var m_SlotResists:Array;
      
      private var m_Slots:Array;
      
      private var m_UnderwearType:uint;
      
      private var m_DisplayDamageTypes:Array = new Array(1,4,6);
      
      public function NewPaperDoll()
      {
         super();
         addFrameScript(0,this.frame1);
         this.m_Slots = new Array();
         this.m_UnderwearType = 0;
         this.m_DisplayedDamageType = 0;
      }
      
      public function get slots() : Array
      {
         return this.m_Slots;
      }
      
      public function set slots(aSlots:Array) : void
      {
         this.m_Slots = aSlots;
      }
      
      public function set underwearType(aVal:uint) : *
      {
         this.m_UnderwearType = aVal;
      }
      
      public function set slotResists(aVal:Array) : *
      {
         this.m_SlotResists = aVal;
      }
      
      public function incrementDisplayedDamageType() : *
      {
         if(this.m_DisplayedDamageType == this.m_DisplayDamageTypes.length - 1)
         {
            this.m_DisplayedDamageType = 0;
         }
         else
         {
            ++this.m_DisplayedDamageType;
         }
      }
      
      public function onDataChange() : *
      {
         var currResistVal:Number = NaN;
         if(this.m_Slots.length > 0 && this.m_SlotResists != null)
         {
            gotoAndStop(this.m_UnderwearType + 1);
            if(this.m_Slots[this.IDX_LEFT_LEG])
            {
               this.LeftLeg_mc.gotoAndPlay("Animate");
            }
            else
            {
               this.LeftLeg_mc.gotoAndStop("Shown");
            }
            this.LeftLeg_mc.visible = Boolean(this.m_Slots[this.IDX_LEFT_LEG]) || Boolean(this.m_SlotResists[this.IDX_LEFT_LEG].HasTypeValue);
            if(this.m_Slots[this.IDX_RIGHT_LEG])
            {
               this.RightLeg_mc.gotoAndPlay("Animate");
            }
            else
            {
               this.RightLeg_mc.gotoAndStop("Shown");
            }
            this.RightLeg_mc.visible = Boolean(this.m_Slots[this.IDX_RIGHT_LEG]) || Boolean(this.m_SlotResists[this.IDX_RIGHT_LEG].HasTypeValue);
            if(this.m_Slots[this.IDX_LEFT_ARM])
            {
               this.LeftArm_mc.gotoAndPlay("Animate");
            }
            else
            {
               this.LeftArm_mc.gotoAndStop("Shown");
            }
            this.LeftArm_mc.visible = Boolean(this.m_Slots[this.IDX_LEFT_ARM]) || Boolean(this.m_SlotResists[this.IDX_LEFT_ARM].HasTypeValue);
            if(this.m_Slots[this.IDX_RIGHT_ARM])
            {
               this.RightArm_mc.gotoAndPlay("Animate");
            }
            else
            {
               this.RightArm_mc.gotoAndStop("Shown");
            }
            this.RightArm_mc.visible = Boolean(this.m_Slots[this.IDX_RIGHT_ARM]) || Boolean(this.m_SlotResists[this.IDX_RIGHT_ARM].HasTypeValue);
            if(this.m_Slots[this.IDX_TORSO])
            {
               this.Torso_mc.gotoAndPlay("Animate");
            }
            else
            {
               this.Torso_mc.gotoAndStop("Shown");
            }
            this.Torso_mc.visible = Boolean(this.m_Slots[this.IDX_TORSO]) || Boolean(this.m_SlotResists[this.IDX_TORSO].HasTypeValue);
            if(this.m_Slots[this.IDX_HELMET])
            {
               this.Helmet_mc.gotoAndPlay("Animate");
            }
            else
            {
               this.Helmet_mc.gotoAndStop("Shown");
            }
            this.Helmet_mc.visible = Boolean(this.m_Slots[this.IDX_HELMET]) || Boolean(this.m_SlotResists[this.IDX_HELMET].HasTypeValue);
            if(this.m_Slots[this.IDX_GOGGLES])
            {
               this.Goggles_mc.gotoAndPlay("Animate");
            }
            else
            {
               this.Goggles_mc.gotoAndStop("Shown");
            }
            this.Goggles_mc.visible = Boolean(this.m_Slots[this.IDX_GOGGLES]) || Boolean(this.m_SlotResists[this.IDX_GOGGLES].HasTypeValue);
            if(this.m_Slots[this.IDX_GAS_MASK])
            {
               this.GasMask_mc.gotoAndPlay("Animate");
            }
            else
            {
               this.GasMask_mc.gotoAndStop("Shown");
            }
            this.GasMask_mc.visible = Boolean(this.m_Slots[this.IDX_GAS_MASK]) || Boolean(this.m_SlotResists[this.IDX_GAS_MASK].HasTypeValue);
            currResistVal = 0;
            currResistVal = this.getSlotResist(this.IDX_HELMET);
            currResistVal += this.getSlotResist(this.IDX_GOGGLES);
            currResistVal += this.getSlotResist(this.IDX_GAS_MASK);
            this.HeadResist_mc.setData(this.m_DisplayDamageTypes[this.m_DisplayedDamageType],currResistVal);
            currResistVal = this.getSlotResist(this.IDX_TORSO);
            currResistVal += this.getSlotResist(this.IDX_UNDERWEAR);
            this.TorsoResist_mc.setData(this.m_DisplayDamageTypes[this.m_DisplayedDamageType],currResistVal);
            currResistVal = this.getSlotResist(this.IDX_LEFT_ARM);
            currResistVal += this.getSlotResist(this.IDX_UNDERWEAR);
            this.LArmResist_mc.setData(this.m_DisplayDamageTypes[this.m_DisplayedDamageType],currResistVal);
            currResistVal = this.getSlotResist(this.IDX_RIGHT_ARM);
            currResistVal += this.getSlotResist(this.IDX_UNDERWEAR);
            this.RArmResist_mc.setData(this.m_DisplayDamageTypes[this.m_DisplayedDamageType],currResistVal);
            currResistVal = this.getSlotResist(this.IDX_LEFT_LEG);
            currResistVal += this.getSlotResist(this.IDX_UNDERWEAR);
            this.LLegResist_mc.setData(this.m_DisplayDamageTypes[this.m_DisplayedDamageType],currResistVal);
            currResistVal = this.getSlotResist(this.IDX_RIGHT_LEG);
            currResistVal += this.getSlotResist(this.IDX_UNDERWEAR);
            this.RLegResist_mc.setData(this.m_DisplayDamageTypes[this.m_DisplayedDamageType],currResistVal);
            visible = true;
         }
         else
         {
            visible = false;
         }
      }
      
      private function getSlotResist(aSlotIndex:uint) : Number
      {
         var info:Object = null;
         var retVal:Number = 0;
         for each(info in this.m_SlotResists[aSlotIndex].DamageTypes)
         {
            if(info.Type == this.m_DisplayDamageTypes[this.m_DisplayedDamageType])
            {
               retVal = Number(info.Value);
            }
         }
         return retVal;
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

