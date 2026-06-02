package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol203")]
   public class Stats_DMGDRWidget extends MovieClip
   {
      
      public static const NUM_ICON_FRAMES:uint = 13;
      
      public var Icon_mc:MovieClip;
      
      private const ENTRY_SPACING:uint = 3;
      
      public function Stats_DMGDRWidget()
      {
         super();
      }
      
      public function redraw(aUseWeaponIcon:Boolean, aInfoObj:Array) : *
      {
         var i:int = 0;
         while(this.numChildren > 1)
         {
            this.removeChildAt(this.numChildren - 1);
         }
         this.Icon_mc.gotoAndStop(aUseWeaponIcon ? "Weapon" : "Armor");
         var accumX:Number = this.Icon_mc.x + this.Icon_mc.width + this.ENTRY_SPACING;
         if(aInfoObj.length == 0)
         {
            accumX = this.AddEntry(aUseWeaponIcon,{
               "type":1,
               "value":0
            },accumX);
         }
         else
         {
            for(i = 0; i < aInfoObj.length; i++)
            {
               if(aInfoObj[i].value > 0)
               {
                  accumX = this.AddEntry(aUseWeaponIcon,aInfoObj[i],accumX);
               }
            }
         }
      }
      
      private function AddEntry(aUseWeaponIcon:Boolean, aInfoObj:Object, aAccumVal:Number) : Number
      {
         var newEntry:Stats_DMGDRWidgetEntry = null;
         if(aInfoObj.type + GlobalFunc.NUM_DAMAGE_TYPES <= NUM_ICON_FRAMES)
         {
            newEntry = new Stats_DMGDRWidgetEntry();
            newEntry.redraw(aUseWeaponIcon,aInfoObj.type,aInfoObj.value);
            this.addChild(newEntry);
            newEntry.x = aAccumVal;
            return aAccumVal + newEntry.width + this.ENTRY_SPACING;
         }
         return aAccumVal;
      }
   }
}

