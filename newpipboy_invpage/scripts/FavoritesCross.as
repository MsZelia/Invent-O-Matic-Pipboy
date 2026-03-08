package
{
   import Shared.AS3.BSUIComponent;
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol433")]
   public class FavoritesCross extends BSUIComponent
   {
      
      public static const SELECTION_UPDATE:String = "FavoritesCross::selectionUpdate";
      
      public static const ITEM_PRESS:String = "FavoritesCross::itemPress";
      
      public static const FS_LEFT_3:uint = 0;
      
      public static const FS_LEFT_2:uint = 1;
      
      public static const FS_LEFT_1:uint = 2;
      
      public static const FS_RIGHT_1:uint = 3;
      
      public static const FS_RIGHT_2:uint = 4;
      
      public static const FS_RIGHT_3:uint = 5;
      
      public static const FS_UP_3:uint = 6;
      
      public static const FS_UP_2:uint = 7;
      
      public static const FS_UP_1:uint = 8;
      
      public static const FS_DOWN_1:uint = 9;
      
      public static const FS_DOWN_2:uint = 10;
      
      public static const FS_DOWN_3:uint = 11;
      
      public static const FS_NONE:uint = 12;
      
      public var EntryHolder_mc:MovieClip;
      
      public var Selection_mc:MovieClip;
      
      private var _FavoritesInfoA:Array;
      
      private var _SelectedIndex:uint;
      
      private var _HideEmptySlots:Boolean;
      
      private var OverEntry:Boolean = false;
      
      private const _UpDirectory:Array = [FS_UP_1,FS_UP_1,FS_UP_1,FS_UP_1,FS_UP_1,FS_UP_1,FS_UP_3,FS_UP_3,FS_UP_2,FS_UP_1,FS_DOWN_1,FS_DOWN_2,FS_UP_1];
      
      private const _DownDirectory:Array = [FS_DOWN_1,FS_DOWN_1,FS_DOWN_1,FS_DOWN_1,FS_DOWN_1,FS_DOWN_1,FS_UP_2,FS_UP_1,FS_DOWN_1,FS_DOWN_2,FS_DOWN_3,FS_DOWN_3,FS_DOWN_1];
      
      private const _LeftDirectory:Array = [FS_LEFT_3,FS_LEFT_3,FS_LEFT_2,FS_LEFT_1,FS_RIGHT_1,FS_RIGHT_2,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1,FS_LEFT_1];
      
      private const _RightDirectory:Array = [FS_LEFT_2,FS_LEFT_1,FS_RIGHT_1,FS_RIGHT_2,FS_RIGHT_3,FS_RIGHT_3,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_1];
      
      private const _InDirectory:Array = [FS_LEFT_2,FS_LEFT_1,FS_LEFT_1,FS_RIGHT_1,FS_RIGHT_1,FS_RIGHT_2,FS_UP_2,FS_UP_1,FS_UP_1,FS_DOWN_1,FS_DOWN_1,FS_DOWN_2,FS_NONE];
      
      private const _OutDirectory:Array = [FS_LEFT_3,FS_LEFT_3,FS_LEFT_2,FS_RIGHT_2,FS_RIGHT_3,FS_RIGHT_3,FS_UP_3,FS_UP_3,FS_UP_2,FS_DOWN_2,FS_DOWN_3,FS_DOWN_3,FS_NONE];
      
      public function FavoritesCross()
      {
         super();
         this._SelectedIndex = FS_NONE;
         this._HideEmptySlots = false;
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         addEventListener(FavoritesEntry.MOUSE_OVER,this.onFavEntryMouseover);
         addEventListener(FavoritesEntry.MOUSE_LEAVE,this.onFavEntryMouseleave);
      }
      
      public function CanAcceptAimlessClicking() : Boolean
      {
         return this._SelectedIndex != FS_NONE && !this.OverEntry;
      }
      
      public function set infoArray(aVal:Array) : *
      {
         this._FavoritesInfoA = aVal;
         var prevVal:int = int(this._SelectedIndex);
         this.selectedIndex = this.ClampSelection(this.selectedIndex);
         dispatchEvent(new CustomEvent(SELECTION_UPDATE,prevVal,true,true));
         SetIsDirty();
      }
      
      public function get selectedIndex() : uint
      {
         return this._SelectedIndex;
      }
      
      public function set selectedIndex(aVal:uint) : *
      {
         var prevVal:int = 0;
         var newVal:int = int(this.ClampSelection(aVal));
         if(this._SelectedIndex != newVal)
         {
            prevVal = int(this._SelectedIndex);
            this._SelectedIndex = newVal;
            dispatchEvent(new CustomEvent(SELECTION_UPDATE,prevVal,true,true));
            SetIsDirty();
         }
      }
      
      public function get selectedEntry() : Object
      {
         return this._FavoritesInfoA != null && this._SelectedIndex >= 0 && this._SelectedIndex < this._FavoritesInfoA.length ? this._FavoritesInfoA[this._SelectedIndex] : null;
      }
      
      public function set hideEmptySlots(aVal:Boolean) : *
      {
         this._HideEmptySlots = aVal;
         this.selectedIndex = this.ClampSelection(this.selectedIndex);
         SetIsDirty();
      }
      
      public function get selectionSound() : String
      {
         var returnVal:String = "";
         switch(this.selectedIndex)
         {
            case FS_UP_1:
            case FS_DOWN_1:
            case FS_LEFT_1:
            case FS_RIGHT_1:
               returnVal = "UIPipBoyFavoriteMenuDPadA";
               break;
            case FS_UP_2:
            case FS_DOWN_2:
            case FS_LEFT_2:
            case FS_RIGHT_2:
               returnVal = "UIPipBoyFavoriteMenuDPadB";
               break;
            case FS_UP_3:
            case FS_DOWN_3:
            case FS_LEFT_3:
            case FS_RIGHT_3:
               returnVal = "UIPipBoyFavoriteMenuDPadC";
         }
         return returnVal;
      }
      
      public function GetEntryClip(aIndex:uint) : FavoritesEntry
      {
         return this.EntryHolder_mc.getChildByName("Entry_" + aIndex) as FavoritesEntry;
      }
      
      override public function redrawUIComponent() : void
      {
         var info:Object = null;
         var currClip:FavoritesEntry = null;
         var foundIcon:Boolean = false;
         super.redrawUIComponent();
         var infoIdx:uint = 0;
         while(this._FavoritesInfoA != null && infoIdx < this._FavoritesInfoA.length)
         {
            info = this._FavoritesInfoA[infoIdx];
            currClip = this.GetEntryClip(infoIdx);
            foundIcon = false;
            if(currClip != null)
            {
               if(info != null)
               {
                  currClip.Icon_mc.gotoAndStop(info.FavIconType);
               }
               else
               {
                  currClip.Icon_mc.gotoAndStop(1);
               }
               currClip.visible = !this._HideEmptySlots || !this.ShouldHideSlot(infoIdx);
            }
            infoIdx++;
         }
         var selectedEntry:FavoritesEntry = this.GetEntryClip(this.selectedIndex);
         if(selectedEntry != null)
         {
            this.Selection_mc.x = this.EntryHolder_mc.x + selectedEntry.x;
            this.Selection_mc.y = this.EntryHolder_mc.y + selectedEntry.y;
            this.Selection_mc.visible = true;
         }
         else
         {
            this.Selection_mc.visible = false;
         }
      }
      
      private function ShouldHideSlot(aSlotIdx:uint) : Boolean
      {
         return this._FavoritesInfoA == null || this._FavoritesInfoA[aSlotIdx] == null && this._FavoritesInfoA[this._OutDirectory[aSlotIdx]] == null && this._FavoritesInfoA[this._OutDirectory[this._OutDirectory[aSlotIdx]]] == null && aSlotIdx != FS_UP_1 && aSlotIdx != FS_DOWN_1 && aSlotIdx != FS_LEFT_1 && aSlotIdx != FS_RIGHT_1;
      }
      
      private function ClampSelection(aVal:uint) : uint
      {
         var clampedVal:int = int(aVal);
         if(this._HideEmptySlots)
         {
            if(this.ShouldHideSlot(clampedVal))
            {
               clampedVal = int(this._InDirectory[clampedVal]);
            }
            if(this.ShouldHideSlot(clampedVal))
            {
               clampedVal = int(this._InDirectory[clampedVal]);
            }
            if(this.ShouldHideSlot(clampedVal))
            {
               clampedVal = int(FS_NONE);
            }
         }
         return clampedVal;
      }
      
      public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
      {
         var quickkeyIdx:Number = NaN;
         var bhandled:Boolean = false;
         if(!abPressed)
         {
            bhandled = true;
            switch(strEventName)
            {
               case "PrimaryAttack":
                  if(this.CanAcceptAimlessClicking())
                  {
                     dispatchEvent(new Event(ITEM_PRESS,true,true));
                  }
                  break;
               default:
                  quickkeyIdx = Number(strEventName.substr(8));
                  if(quickkeyIdx >= 1 && quickkeyIdx <= FS_NONE)
                  {
                     this.selectedIndex = quickkeyIdx - 1;
                     this.SelectItem();
                  }
                  else
                  {
                     bhandled = false;
                  }
            }
         }
         return bhandled;
      }
      
      public function onKeyUp(event:KeyboardEvent) : *
      {
         switch(event.keyCode)
         {
            case Keyboard.UP:
               this.selectedIndex = this.ClampSelection(this._UpDirectory[this.selectedIndex]);
               break;
            case Keyboard.DOWN:
               this.selectedIndex = this.ClampSelection(this._DownDirectory[this.selectedIndex]);
               break;
            case Keyboard.LEFT:
               this.selectedIndex = this.ClampSelection(this._LeftDirectory[this.selectedIndex]);
               break;
            case Keyboard.RIGHT:
               this.selectedIndex = this.ClampSelection(this._RightDirectory[this.selectedIndex]);
               break;
            case Keyboard.ENTER:
               if(this.selectedIndex != FS_NONE)
               {
                  this.SelectItem();
                  event.stopPropagation();
               }
         }
      }
      
      public function SelectItem() : *
      {
         dispatchEvent(new Event(ITEM_PRESS,true,true));
      }
      
      protected function onFavEntryMouseover(event:Event) : *
      {
         this.selectedIndex = event.target.entryIndex;
         this.OverEntry = true;
      }
      
      protected function onFavEntryMouseleave(event:Event) : *
      {
         this.OverEntry = false;
      }
   }
}

