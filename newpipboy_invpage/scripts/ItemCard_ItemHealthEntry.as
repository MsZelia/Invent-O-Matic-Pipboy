package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol260")]
   public class ItemCard_ItemHealthEntry extends ItemCard_Entry
   {
      
      public var ConditionMeter_mc:MovieClip;
      
      private var m_ConditionLengthFrames:int = 100;
      
      private var m_ConditionFrames:int = 110;
      
      public function ItemCard_ItemHealthEntry()
      {
         super();
      }
      
      public static function IsEntryValid(aEntryObj:Object) : Boolean
      {
         return aEntryObj.currentHealth != -1;
      }
      
      override public function PopulateEntry(aInfoObj:Object) : *
      {
         GlobalFunc.updateConditionMeter(this.ConditionMeter_mc,aInfoObj.currentHealth,aInfoObj.maximumHealth,aInfoObj.durability);
      }
   }
}

