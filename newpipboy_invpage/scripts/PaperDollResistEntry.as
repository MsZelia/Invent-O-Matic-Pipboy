package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol446")]
   public class PaperDollResistEntry extends MovieClip
   {
      
      public var Icon_mc:MovieClip;
      
      public var Value_tf:TextField;
      
      public function PaperDollResistEntry()
      {
         super();
         TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function setData(aType:uint, aVal:Number) : void
      {
         this.Icon_mc.gotoAndStop(aType);
         this.Value_tf.text = Math.round(aVal).toString();
      }
   }
}

