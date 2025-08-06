package
{
   import Shared.GlobalFunc;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol58")]
   public class ItemCard_MultiEntry_Value extends ItemCard_Entry
   {
      
      public function ItemCard_MultiEntry_Value()
      {
         super();
      }
      
      override public function PopulateEntry(param1:Object) : *
      {
         super.PopulateEntry(param1);
         if(param1.duration)
         {
            Value_tf.appendText("  /  " + GlobalFunc.ShortTimeString(param1.duration));
            setIconPosition();
         }
         else if(Boolean(param1.projectileCount) && param1.projectileCount > 1)
         {
            Value_tf.text = getValueTextWithPrecision(param1.value / param1.projectileCount,param1.precision,param1.scaleWithDuration,param1.duration);
            Value_tf.appendText(" x " + param1.projectileCount);
            setIconPosition();
         }
      }
   }
}

