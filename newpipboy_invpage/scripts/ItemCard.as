package
{
   import Shared.AS3.BSUIComponent;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol440")]
   public class ItemCard extends BSUIComponent
   {
      
      public static const EVENT_ITEM_CARD_UPDATED:String = "ItemCard::Updated";
      
      private var _InfoObj:Array;
      
      private var _showItemDesc:Boolean;
      
      private var _showValueEntry:Boolean;
      
      private var bItemHealthEnabled:Boolean;
      
      private var m_Count:uint = 0;
      
      private const ET_STANDARD:uint = 0;
      
      private const ET_AMMO:uint = 1;
      
      private const ET_DMG_WEAP:uint = 2;
      
      private const ET_DMG_ARMO:uint = 3;
      
      private const ET_TIMED_EFFECT:uint = 4;
      
      private const ET_COMPONENTS_LIST:uint = 5;
      
      private const ET_ITEM_DESCRIPTION:uint = 6;
      
      private const ET_LEGENDARY_AND_LEVEL:uint = 7;
      
      private const ET_ITEM_HEALTH:uint = 8;
      
      private const ET_VALUE:uint = 9;
      
      private const ET_FIRE_MODE:uint = 10;
      
      private const ET_HIDE_DIFFERENCE:uint = 11;
      
      private const ET_UNSPECIFIED:uint = 12;
      
      private var m_BlankEntryFillTarget:uint = 0;
      
      private var m_EntrySpacing:Number = -3.5;
      
      private var m_EntrySpacingChanged:Boolean = false;
      
      private var m_EntryCount:int = 0;
      
      private var m_BottomUp:Boolean = true;
      
      private var _currencyType:uint = 0;
      
      public function ItemCard()
      {
         super();
         this._InfoObj = new Array();
         this._showItemDesc = true;
         this._showValueEntry = true;
         this.bItemHealthEnabled = true;
      }
      
      public function set blankEntryFillTarget(aValue:uint) : void
      {
         this.m_BlankEntryFillTarget = aValue;
      }
      
      public function get blankEntryFillTarget() : uint
      {
         return this.m_BlankEntryFillTarget;
      }
      
      public function set entrySpacing(aSpacing:Number) : *
      {
         this.m_EntrySpacing = aSpacing;
         this.m_EntrySpacingChanged = true;
      }
      
      public function get entryCount() : int
      {
         return this.m_EntryCount;
      }
      
      public function get entrySpacing() : Number
      {
         return this.m_EntrySpacing;
      }
      
      public function set bottomUp(aUp:Boolean) : *
      {
         this.m_BottomUp = aUp;
      }
      
      public function get bottomUp() : Boolean
      {
         return this.m_BottomUp;
      }
      
      public function set currencyType(aCurrencyType:uint) : *
      {
         this._currencyType = aCurrencyType;
      }
      
      public function get InfoObj() : Array
      {
         return this._InfoObj;
      }
      
      public function set InfoObj(aNewArray:Array) : *
      {
         this._InfoObj = aNewArray;
      }
      
      public function set showItemDesc(aVal:Boolean) : *
      {
         this._showItemDesc = aVal;
      }
      
      public function get showItemDesc() : Boolean
      {
         return this._showItemDesc;
      }
      
      public function set showValueEntry(aVal:Boolean) : *
      {
         this._showValueEntry = aVal;
      }
      
      public function get showValueEntry() : Boolean
      {
         return this._showValueEntry;
      }
      
      public function get Count() : uint
      {
         return this.m_Count;
      }
      
      public function set Count(aCount:uint) : void
      {
         this.m_Count = aCount;
      }
      
      public function onDataChange() : *
      {
         SetIsDirty();
      }
      
      override public function redrawUIComponent() : void
      {
         var newEntry:ItemCard_Entry = null;
         var legendaryModsAndLevelEntry:Object = null;
         var durability:Number = NaN;
         var itemLevel:Number = NaN;
         var dataIdx:int = 0;
         var text:String = null;
         var underscoreIndex:uint = 0;
         var damageType:uint = 0;
         var armorType:uint = 0;
         var entryType:uint = 0;
         var stackWTEntry:ItemCard_Entry = null;
         var dataEntry:Object = null;
         var newDescriptionEntry:ItemCard_DescriptionEntry = null;
         super.redrawUIComponent();
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         var currY:Number = 0;
         var newEntries:Vector.<ItemCard_Entry> = new Vector.<ItemCard_Entry>();
         var hasDMGEntry:Boolean = false;
         var hasDREntry:Boolean = false;
         var descriptionEntries:Array = new Array();
         var itemHealthEntry:Object = new Object();
         var legendaryMods:Number = 0;
         for(dataIdx = int(this._InfoObj.length - 1); dataIdx >= 0; dataIdx--)
         {
            switch(this._InfoObj[dataIdx].text)
            {
               case ItemCard_MultiEntry.DMG_WEAP_ID:
                  hasDMGEntry ||= ItemCard_MultiEntry.IsEntryValid(this._InfoObj[dataIdx]);
                  break;
               case ItemCard_MultiEntry.DMG_ARMO_ID:
                  hasDREntry ||= ItemCard_MultiEntry.IsEntryValid(this._InfoObj[dataIdx]);
                  break;
               case "$health":
                  itemHealthEntry.currentHealth = this._InfoObj[dataIdx].currentHealth;
                  itemHealthEntry.maxMeterHealth = this._InfoObj[dataIdx].maximumHealth;
                  itemHealthEntry.maximumHealth = this._InfoObj[dataIdx].maximumHealth;
                  break;
               case "currentHealth":
                  itemHealthEntry.currentHealth = this._InfoObj[dataIdx].value;
                  break;
               case "maxMeterHealth":
                  itemHealthEntry.maxMeterHealth = this._InfoObj[dataIdx].value;
                  break;
               case "minMeterHealth":
                  itemHealthEntry.minMeterHealth = this._InfoObj[dataIdx].value;
                  break;
               case "healthPercent":
               case "canSpoil":
               case "isSpoiled":
                  break;
               case "maximumHealth":
                  itemHealthEntry.maxMeterHealth = this._InfoObj[dataIdx].value;
                  itemHealthEntry.maximumHealth = this._InfoObj[dataIdx].value;
                  break;
               case "legendaryMods":
                  legendaryMods = Number(this._InfoObj[dataIdx].value);
                  if(ItemCard_DurabilityEntry.IsEntryValid(this._InfoObj[dataIdx]))
                  {
                     legendaryModsAndLevelEntry = this._InfoObj[dataIdx];
                  }
                  break;
               case "$StatDurability":
               case "durability":
                  itemHealthEntry.durability = this._InfoObj[dataIdx].value;
                  break;
               case "$StatLevel":
               case "itemLevel":
                  itemLevel = Number(this._InfoObj[dataIdx].value);
                  break;
               default:
                  text = this._InfoObj[dataIdx].text;
                  if(text.search("dmg_") != -1)
                  {
                     hasDMGEntry = true;
                     underscoreIndex = uint(text.indexOf("_"));
                     damageType = uint(text.substr(underscoreIndex + 1));
                     this._InfoObj[dataIdx].damageType = damageType;
                     this._InfoObj[dataIdx].text = ItemCard_MultiEntry.DMG_WEAP_ID;
                  }
                  else if(text.search("dr_") != -1)
                  {
                     hasDREntry = true;
                     underscoreIndex = uint(text.indexOf("_"));
                     armorType = uint(text.substr(underscoreIndex + 1));
                     this._InfoObj[dataIdx].damageType = armorType;
                     this._InfoObj[dataIdx].text = ItemCard_MultiEntry.DMG_ARMO_ID;
                  }
                  else if(this._InfoObj[dataIdx].entryType != this.ET_ITEM_DESCRIPTION || this._InfoObj[dataIdx].showAsDescription != undefined && !this._InfoObj[dataIdx].showAsDescription)
                  {
                     if(ItemCard_DurabilityEntry.IsEntryValid(this._InfoObj[dataIdx]))
                     {
                        legendaryModsAndLevelEntry = this._InfoObj[dataIdx];
                     }
                     else
                     {
                        entryType = this.GetEntryType(this._InfoObj[dataIdx]);
                        newEntry = this.CreateEntry(entryType);
                        if(newEntry != null)
                        {
                           if(this._InfoObj[dataIdx].text == "$wt" && this.m_Count > 1)
                           {
                              stackWTEntry = new ItemCard_StandardEntry();
                              stackWTEntry.populateStackWeight(this._InfoObj[dataIdx],this.m_Count);
                              newEntries.push(stackWTEntry);
                           }
                           newEntry.PopulateEntry(this._InfoObj[dataIdx]);
                           newEntries.push(newEntry);
                        }
                     }
                  }
                  break;
            }
         }
         if(this._showItemDesc)
         {
            for each(dataEntry in this._InfoObj)
            {
               if((dataEntry.showAsDescription == true || dataEntry.entryType == this.ET_ITEM_DESCRIPTION) && dataEntry.value != "")
               {
                  descriptionEntries.push(dataEntry);
               }
            }
         }
         if(itemLevel)
         {
            legendaryModsAndLevelEntry = {
               "itemLevel":itemLevel,
               "legendaryMods":legendaryMods
            };
         }
         if(hasDMGEntry)
         {
            newEntry = this.CreateEntry(this.ET_DMG_WEAP);
            if(newEntry != null)
            {
               (newEntry as ItemCard_MultiEntry).PopulateMultiEntry(this._InfoObj,ItemCard_MultiEntry.DMG_WEAP_ID);
               newEntries.push(newEntry);
            }
         }
         if(hasDREntry)
         {
            newEntry = this.CreateEntry(this.ET_DMG_ARMO);
            if(newEntry != null)
            {
               (newEntry as ItemCard_MultiEntry).PopulateMultiEntry(this._InfoObj,ItemCard_MultiEntry.DMG_ARMO_ID);
               newEntries.push(newEntry);
            }
         }
         if(itemHealthEntry.maxMeterHealth > 0 && itemHealthEntry.currentHealth != -1 && this.bItemHealthEnabled)
         {
            newEntry = this.CreateEntry(this.ET_ITEM_HEALTH);
            if(newEntry != null)
            {
               (newEntry as ItemCard_ItemHealthEntry).PopulateEntry(itemHealthEntry);
               newEntries.push(newEntry);
            }
         }
         if(legendaryModsAndLevelEntry != null)
         {
            newEntry = this.CreateEntry(this.ET_LEGENDARY_AND_LEVEL);
            if(newEntry != null)
            {
               (newEntry as ItemCard_DurabilityEntry).PopulateEntry(legendaryModsAndLevelEntry);
               newEntries.push(newEntry);
            }
         }
         if(descriptionEntries.length > 0)
         {
            newEntry = this.CreateEntry(this.ET_ITEM_DESCRIPTION);
            newDescriptionEntry = newEntry as ItemCard_DescriptionEntry;
            if(newDescriptionEntry != null)
            {
               newDescriptionEntry.PopulateEntries(descriptionEntries);
               newEntries.push(newEntry);
            }
         }
         this.FillBlankEntries(newEntries);
         var newEntriesLen:int = int(newEntries.length);
         if(!this.m_BottomUp)
         {
            newEntries.reverse();
         }
         this.m_EntryCount = 0;
         for(var i:int = 0; i < newEntriesLen; i++)
         {
            addChild(newEntries[i]);
            if(newEntries[i] is ItemCard_MultiEntry)
            {
               this.m_EntryCount += (newEntries[i] as ItemCard_MultiEntry).entryCount;
            }
            else if(newEntries[i] is ItemCard_ComponentsEntry)
            {
               this.m_EntryCount += (newEntries[i] as ItemCard_ComponentsEntry).entryCount;
            }
            else
            {
               ++this.m_EntryCount;
            }
            if(this.m_BottomUp)
            {
               if(currY < 0)
               {
                  currY -= this.m_EntrySpacing;
               }
               currY -= newEntries[i].height;
               newEntries[i].y = currY;
            }
            else
            {
               newEntries[i].y = currY;
               currY += newEntries[i].height + this.m_EntrySpacing;
            }
         }
         dispatchEvent(new Event(EVENT_ITEM_CARD_UPDATED,true));
      }
      
      private function FillBlankEntries(aEntries:Vector.<ItemCard_Entry>) : void
      {
         var newEntry:ItemCard_Entry = null;
         var blankIndex:uint = 0;
         var actualNumEntries:int = 0;
         var entriesLen:int = int(aEntries.length);
         for(var i:int = 0; i < entriesLen; i++)
         {
            if(aEntries[i] is ItemCard_MultiEntry)
            {
               actualNumEntries += (aEntries[i] as ItemCard_MultiEntry).entryCount;
            }
            else if(aEntries[i] is ItemCard_ComponentsEntry)
            {
               actualNumEntries += (aEntries[i] as ItemCard_ComponentsEntry).entryCount;
            }
            else
            {
               actualNumEntries++;
            }
         }
         if(actualNumEntries < this.m_BlankEntryFillTarget)
         {
            for(blankIndex = uint(actualNumEntries); blankIndex < this.m_BlankEntryFillTarget; blankIndex++)
            {
               newEntry = new ItemCard_StandardEntry();
               newEntry.PopulateEntry({
                  "text":"",
                  "value":""
               });
               aEntries.unshift(newEntry);
            }
         }
      }
      
      private function GetEntryType(aEntryObj:Object) : uint
      {
         var returnVal:uint = this.ET_STANDARD;
         if(aEntryObj.text == "$val")
         {
            returnVal = this.ET_VALUE;
         }
         else if(aEntryObj.damageType == 10 || aEntryObj.entryType == this.ET_AMMO)
         {
            returnVal = this.ET_AMMO;
         }
         else if(aEntryObj.duration != null && aEntryObj.duration > 0)
         {
            returnVal = this.ET_TIMED_EFFECT;
         }
         else if(aEntryObj.components is Array && aEntryObj.components.length > 0)
         {
            returnVal = this.ET_COMPONENTS_LIST;
         }
         else if(aEntryObj.text == "$ATTACKMODE")
         {
            returnVal = this.ET_FIRE_MODE;
         }
         else if(aEntryObj.hideDifferenceValue == true)
         {
            returnVal = this.ET_HIDE_DIFFERENCE;
         }
         return returnVal;
      }
      
      private function CreateEntry(aEntryType:uint) : ItemCard_Entry
      {
         var returnVal:ItemCard_Entry = null;
         switch(aEntryType)
         {
            case this.ET_VALUE:
               if(this._showValueEntry)
               {
                  returnVal = new ItemCard_ValueEntry();
                  (returnVal as ItemCard_ValueEntry).currencyType = this._currencyType;
               }
               break;
            case this.ET_STANDARD:
               returnVal = new ItemCard_StandardEntry();
               break;
            case this.ET_AMMO:
               returnVal = new ItemCard_AmmoEntry();
               break;
            case this.ET_DMG_WEAP:
            case this.ET_DMG_ARMO:
               returnVal = new ItemCard_MultiEntry();
               if(this.m_EntrySpacingChanged)
               {
                  (returnVal as ItemCard_MultiEntry).entrySpacing = this.m_EntrySpacing;
               }
               break;
            case this.ET_TIMED_EFFECT:
               returnVal = new ItemCard_TimedEntry();
               break;
            case this.ET_COMPONENTS_LIST:
               returnVal = new ItemCard_ComponentsEntry();
               break;
            case this.ET_ITEM_DESCRIPTION:
               returnVal = new ItemCard_DescriptionEntry();
               break;
            case this.ET_LEGENDARY_AND_LEVEL:
               returnVal = new ItemCard_DurabilityEntry();
               break;
            case this.ET_ITEM_HEALTH:
               returnVal = new ItemCard_ItemHealthEntry();
               break;
            case this.ET_FIRE_MODE:
               returnVal = new ItemCard_FireModeEntry();
               break;
            case this.ET_HIDE_DIFFERENCE:
               returnVal = new ItemCard_HideDifferenceEntry();
         }
         return returnVal;
      }
      
      public function HideItemHealth() : *
      {
         this.bItemHealthEnabled = false;
      }
   }
}

