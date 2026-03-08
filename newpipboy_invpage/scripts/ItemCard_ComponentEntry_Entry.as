package
{
   import Shared.AS3.BSScrollingListEntry;
   import flash.display.MovieClip;
   import flash.text.TextLineMetrics;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol277")]
   public class ItemCard_ComponentEntry_Entry extends BSScrollingListEntry
   {
      
      public static const ICON_SPACING:Number = 15;
      
      public var FavIcon_mc:MovieClip;
      
      public function ItemCard_ComponentEntry_Entry()
      {
         super();
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         var textMetrics:TextLineMetrics = null;
         var rightTextX:Number = NaN;
         super.SetEntryText(aEntryObject,astrTextOption);
         if(aEntryObject.count != 1 && aEntryObject.count != undefined)
         {
            textField.appendText(" (" + aEntryObject.count + ")");
         }
         if(this.FavIcon_mc != null)
         {
            textMetrics = textField.getLineMetrics(0);
            rightTextX = textField.x + textMetrics.x + textMetrics.width + this.FavIcon_mc.width / 2 + ICON_SPACING;
            this.FavIcon_mc.x = rightTextX;
            this.FavIcon_mc.visible = aEntryObject.favorite > 0 || Boolean(aEntryObject.taggedForSearch);
         }
      }
   }
}

