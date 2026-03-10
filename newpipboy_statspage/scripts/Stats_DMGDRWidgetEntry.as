package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol27")]
   public class Stats_DMGDRWidgetEntry extends MovieClip
   {
      
      public var Icon_mc:MovieClip;
      
      public var Value_tf:TextField;
      
      public function Stats_DMGDRWidgetEntry()
      {
         super();
         Extensions.enabled = true;
         TextFieldEx.setTextAutoSize(this.Value_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
      }
      
      public function redraw(aUseWeaponIcon:Boolean, aType:uint, aVal:Number) : *
      {
         this.Icon_mc.gotoAndStop(aUseWeaponIcon ? aType + GlobalFunc.NUM_DAMAGE_TYPES : aType);
         GlobalFunc.SetText(this.Value_tf,Math.floor(aVal).toString(),false);
      }
   }
}

