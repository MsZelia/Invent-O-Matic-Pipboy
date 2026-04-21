package
{
   import Shared.AS3.BSUIComponent;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol205")]
   public class Pipboy_Meter extends BSUIComponent
   {
      
      public var Fill_mc:MovieClip;
      
      public var GhostFill_mc:MovieClip;
      
      private var m_Value:Number;
      
      private var m_GhostValue:Number;
      
      private var m_MaxValue:Number;
      
      private var m_InitialWidth:Number;
      
      public function Pipboy_Meter()
      {
         super();
         this.m_Value = 0;
         this.m_GhostValue = 0;
         this.m_MaxValue = 0;
         this.m_InitialWidth = this.width;
      }
      
      public function SetMeter(aValue:Number, aGhostValue:Number, aMaxValue:Number) : *
      {
         this.m_Value = Math.min(aValue,aMaxValue);
         this.m_GhostValue = aGhostValue;
         this.m_MaxValue = aMaxValue;
         if(this.Fill_mc != null)
         {
            this.Fill_mc.visible = this.m_Value > 0 && this.m_MaxValue > 0;
            if(this.Fill_mc.visible)
            {
               this.Fill_mc.width = this.m_Value / this.m_MaxValue * (this.m_InitialWidth / this.scaleX);
            }
         }
         if(this.GhostFill_mc != null)
         {
            this.GhostFill_mc.visible = this.m_GhostValue > 0 && this.m_MaxValue > 0;
            if(this.GhostFill_mc.visible)
            {
               this.GhostFill_mc.width = this.m_GhostValue / this.m_MaxValue * (this.m_InitialWidth / this.scaleX);
            }
         }
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         super.redrawUIComponent();
      }
   }
}

