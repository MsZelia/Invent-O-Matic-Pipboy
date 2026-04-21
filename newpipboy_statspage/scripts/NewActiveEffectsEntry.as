package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol172")]
   public class NewActiveEffectsEntry extends MovieClip
   {
      
      private static const DEFAULT_TEXT_SIZE:uint = 28;
      
      public var Source_tf:TextField;
      
      public var Effects_tf:TextField;
      
      private var m_ExtraTextfields:Array;
      
      private var m_DefaultTextFormat:TextFormat;
      
      public function NewActiveEffectsEntry()
      {
         super();
         this.m_ExtraTextfields = new Array();
         this.m_DefaultTextFormat = this.Effects_tf.getTextFormat();
         this.m_DefaultTextFormat.font = "$MAIN_Font_Bold";
         this.m_DefaultTextFormat.size = DEFAULT_TEXT_SIZE;
         this.m_DefaultTextFormat.color = 16777215;
         TextFieldEx.setTextAutoSize(this.Effects_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
         TextFieldEx.setTextAutoSize(this.Source_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function SetEffects(aEffects:Array, aSource:String, aTimeRemaining:String) : *
      {
         var effectInfo:Object = null;
         var newText:TextField = null;
         for(var i:* = 0; i < this.m_ExtraTextfields.length; i++)
         {
            this.removeChild(this.m_ExtraTextfields[i]);
         }
         this.m_ExtraTextfields = new Array();
         var firstIter:Boolean = true;
         var newY:* = 0;
         for each(effectInfo in aEffects)
         {
            if(effectInfo.Label != "")
            {
               if(firstIter)
               {
                  firstIter = false;
                  this.Effects_tf.text = this.setLabel(effectInfo);
                  newY = this.Effects_tf.y + this.Effects_tf.height;
                  this.Source_tf.text = aTimeRemaining != "" ? aSource + " (" + aTimeRemaining + "):" : aSource + ":";
               }
               else
               {
                  newText = new TextField();
                  newText.setTextFormat(this.m_DefaultTextFormat);
                  newText.text = this.setLabel(effectInfo);
                  this.addChild(newText);
                  newText.x = this.Effects_tf.x;
                  newText.y = newY;
                  newText.width = this.Effects_tf.width;
                  newText.height = this.Effects_tf.height;
                  newY = newText.y + newText.height;
                  this.m_ExtraTextfields.push(newText);
               }
            }
         }
      }
      
      private function setLabel(effectInfo:Object) : String
      {
         var effectText:String = null;
         if(effectInfo.MagnitudeText != "" && (effectInfo.Label as String).search(/\d/) == -1)
         {
            effectText = effectInfo.MagnitudeText + " " + effectInfo.Label;
         }
         else
         {
            effectText = effectInfo.Label;
         }
         return effectText;
      }
   }
}

