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
      
      override public function PopulateEntry(aInfoObj:Object) : *
      {
         super.PopulateEntry(aInfoObj);
         if(aInfoObj.duration)
         {
            Value_tf.appendText("  /  " + GlobalFunc.ShortTimeString(aInfoObj.duration));
            setIconPosition();
         }
         else if(Boolean(aInfoObj.projectileCount) && aInfoObj.projectileCount > 1)
         {
            Value_tf.text = getValueTextWithPrecision(aInfoObj.value / aInfoObj.projectileCount,aInfoObj.precision,aInfoObj.scaleWithDuration,aInfoObj.duration);
            Value_tf.appendText(" x " + aInfoObj.projectileCount);
            setIconPosition();
         }
      }
   }
}

