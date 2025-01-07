package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol269")]
   public class ItemCard_DurabilityEntry extends ItemCard_Entry
   {
       
      
      public var Durability_mc:MovieClip;
      
      private var m_DurabilityFrames:int = 6;
      
      public function ItemCard_DurabilityEntry()
      {
         super();
      }
      
      public static function IsEntryValid(param1:Object) : Boolean
      {
         return param1.itemLevel != null && param1.itemLevel > 0;
      }
      
      public function ItemCard_TimedEntry() : *
      {
         this.m_DurabilityFrames = this.Durability_mc.totalFrames;
      }
      
      override public function PopulateEntry(param1:Object) : *
      {
         Value_tf.text = "$$ItemLevel " + param1.itemLevel;
         this.Durability_mc.gotoAndStop(Math.min(param1.legendaryMods + 1,this.m_DurabilityFrames));
      }
   }
}
