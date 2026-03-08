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
      
      public static function IsEntryValid(aEntryObj:Object) : Boolean
      {
         return aEntryObj.itemLevel != null && aEntryObj.itemLevel > 0;
      }
      
      public function ItemCard_TimedEntry() : *
      {
         this.m_DurabilityFrames = this.Durability_mc.totalFrames;
      }
      
      override public function PopulateEntry(aInfoObj:Object) : *
      {
         Value_tf.text = "$$ItemLevel " + aInfoObj.itemLevel;
         this.Durability_mc.gotoAndStop(Math.min(aInfoObj.legendaryMods + 1,this.m_DurabilityFrames));
      }
   }
}

