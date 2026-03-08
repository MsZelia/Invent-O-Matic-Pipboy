package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol61")]
   public class ItemCard_MultiEntry extends ItemCard_Entry
   {
      
      public static const DMG_WEAP_ID:String = "$dmg";
      
      public static const DMG_ARMO_ID:String = "$dr";
      
      public var EntryHolder_mc:MovieClip;
      
      public var Background_mc:MovieClip;
      
      private var m_EntrySpacing:Number = 3.5;
      
      private var m_EntryCount:int = 0;
      
      public function ItemCard_MultiEntry()
      {
         super();
      }
      
      public static function IsEntryValid(aEntryObj:Object) : Boolean
      {
         return aEntryObj.value != 0 || ShouldShowDifference(aEntryObj) && aEntryObj.text == DMG_ARMO_ID;
      }
      
      public function set entrySpacing(aSpacing:Number) : *
      {
         this.m_EntrySpacing = aSpacing;
      }
      
      public function get entryCount() : int
      {
         return this.m_EntryCount;
      }
      
      public function PopulateMultiEntry(aInfoObj:Array, aPropName:String) : *
      {
         var newEntry:ItemCard_MultiEntry_Value = null;
         if(Label_tf != null)
         {
            GlobalFunc.SetText(Label_tf,aPropName,false);
         }
         while(this.EntryHolder_mc.numChildren > 0)
         {
            this.EntryHolder_mc.removeChildAt(0);
         }
         var currY:Number = 0;
         this.m_EntryCount = 0;
         for(var dataIdx:uint = 0; dataIdx < aInfoObj.length; dataIdx++)
         {
            if(aInfoObj[dataIdx].text == aPropName && IsEntryValid(aInfoObj[dataIdx]))
            {
               newEntry = new ItemCard_MultiEntry_Value();
               newEntry.Icon_mc.gotoAndStop(aPropName == DMG_WEAP_ID ? aInfoObj[dataIdx].damageType + GlobalFunc.NUM_DAMAGE_TYPES : aInfoObj[dataIdx].damageType);
               newEntry.PopulateEntry(aInfoObj[dataIdx]);
               this.EntryHolder_mc.addChild(newEntry);
               ++this.m_EntryCount;
               if(currY > 0)
               {
                  currY += this.m_EntrySpacing;
               }
               newEntry.y = currY;
               if(newEntry.Sizer_mc != null)
               {
                  currY += newEntry.Sizer_mc.height;
               }
               else
               {
                  currY += newEntry.height;
               }
            }
         }
         if(this.Background_mc != null)
         {
            this.Background_mc.height = currY;
         }
      }
   }
}

