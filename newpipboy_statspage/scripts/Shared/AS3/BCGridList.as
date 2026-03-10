package Shared.AS3
{
   import Shared.AS3.Events.CustomEvent;
   import Shared.AS3.Events.PlatformChangeEvent;
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.getDefinitionByName;
   
   public class BCGridList extends MovieClip
   {
      
      public static const TEXT_OPTION_NONE:String = "None";
      
      public static const TEXT_OPTION_SHRINK_TO_FIT:String = "Shrink To Fit";
      
      public static const TEXT_OPTION_MULTILINE:String = "Multi-Line";
      
      public static const SELECTION_CHANGE:String = "BCGridList::selectionChange";
      
      public static const ITEM_PRESS:String = "BCGridList::itemPress";
      
      public static const LIST_PRESS:String = "BCGridList::listPress";
      
      public static const MOUSE_OVER_ITEM:String = "BCGridList::mouseOverItem";
      
      public static const LIST_UPDATED:String = "BCGridList::listUpdated";
      
      public static const SELECTION_EDGE_BOUNCE:String = "BCGridList::selectionEdgeBounce";
      
      public static const ITEM_CLICKED:String = "BCGridList::itemClicked";
      
      public var Body_mc:MovieClip;
      
      public var ScrollUp_mc:MovieClip;
      
      public var ScrollDown_mc:MovieClip;
      
      public var ScrollLeft_mc:MovieClip;
      
      public var ScrollRight_mc:MovieClip;
      
      public var ScrollVert_mc:BSSlider;
      
      public var ScrollHoriz_mc:BSSlider;
      
      private var EntryHolder_mc:MovieClip;
      
      private var m_ListItemClassName:String = "BSScrollingListEntry";
      
      private var m_ListItemClass:Class;
      
      private var m_MaxRows:uint = 7;
      
      private var m_MaxCols:uint = 1;
      
      private var m_TextBehavior:String;
      
      private var m_ScrollVertical:Boolean = true;
      
      private var m_DisableSelection:Boolean = false;
      
      private var m_DisableInput:Boolean = false;
      
      private var m_DisableMouseWheel:Boolean = false;
      
      private var m_WheelSelectionScroll:Boolean = false;
      
      private var m_SelectionScrollLock:Boolean = false;
      
      private var m_SelectionScrollLockOffset:int = 0;
      
      private var m_IdName:String = "";
      
      private var m_EntriesLayeredInOrder:Boolean = false;
      
      private var m_SetSelectedIndexOnFirstEntryDataInit:Boolean = false;
      
      private var m_SelectedIndex:int = -1;
      
      private var m_SelectedClip:BSScrollingListEntry;
      
      private var m_SelectedDisplayIndex:int = -1;
      
      protected var m_DisplayedItemCount:uint = 0;
      
      private var m_MaxDisplayedItems:uint = 0;
      
      protected var m_ListStartIndex:uint = 0;
      
      private var m_ShowSelectedItem:Boolean = true;
      
      private var m_PrevSelectedIndex:int = -1;
      
      protected var m_AnimatedArrows:Boolean = false;
      
      protected var m_Active:Boolean = true;
      
      private var m_IsDirty:Boolean = false;
      
      private var m_NeedRecalculateScrollMax:Boolean = true;
      
      private var m_NeedRecreateClips:Boolean = false;
      
      protected var m_NeedRedraw:Boolean = true;
      
      private var m_NeedSliderUpdate:Boolean = true;
      
      private var m_QueueSelectUnderMouse:Boolean = false;
      
      private var m_RowScrollPos:uint = 0;
      
      private var m_RowScrollPosMax:int = 0;
      
      private var m_ColScrollPos:uint = 0;
      
      private var m_ColScrollPosMax:int = 0;
      
      private var m_DisplayWidth:Number = 0;
      
      private var m_DisplayHeight:Number = 0;
      
      private var m_LastNavDirection:int = -1;
      
      private var m_NavChangeFromInput:Boolean = false;
      
      private var m_SelectedEntryId:* = null;
      
      private var m_SelectionChangeCount:int = 0;
      
      private var m_UseVariableWidth:Boolean = false;
      
      private var m_UseVariableHeight:Boolean = false;
      
      private var m_IgnoreMouse:Boolean = false;
      
      private var m_uiController:* = 0;
      
      protected var m_Entries:Array;
      
      protected var m_ClipVector:Vector.<BSScrollingListEntry>;
      
      public function BCGridList()
      {
         super();
         this.m_Entries = [];
         this.m_ClipVector = new Vector.<BSScrollingListEntry>();
         if(this.Body_mc == null)
         {
            throw new Error("BCGridList : Required instance Body_mc null or invalid.");
         }
         this.EntryHolder_mc = new MovieClip();
         this.EntryHolder_mc.name = "EntryHolder_mc";
         this.Body_mc.addChildAt(this.EntryHolder_mc,this.EntryHolder_mc.numChildren);
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.visible = false;
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.visible = false;
         }
         if(this.ScrollLeft_mc != null)
         {
            this.ScrollLeft_mc.visible = false;
         }
         if(this.ScrollRight_mc != null)
         {
            this.ScrollRight_mc.visible = false;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         if(this.ScrollHoriz_mc != null)
         {
            this.ScrollHoriz_mc.visible = false;
            this.ScrollHoriz_mc.handleSizeViaContents = true;
         }
         if(this.ScrollVert_mc != null)
         {
            this.ScrollVert_mc.bVertical = true;
            this.ScrollVert_mc.visible = false;
            this.ScrollVert_mc.handleSizeViaContents = true;
         }
      }
      
      public function get entryClips() : Vector.<BSScrollingListEntry>
      {
         return this.m_ClipVector;
      }
      
      public function set showSelectedItem(aShow:Boolean) : void
      {
         this.m_ShowSelectedItem = aShow;
         this.m_NeedRedraw = true;
         this.setIsDirty();
      }
      
      public function get showSelectedItem() : Boolean
      {
         return this.m_ShowSelectedItem;
      }
      
      public function set textBehavior(aBehavior:String) : void
      {
         this.m_TextBehavior = aBehavior;
      }
      
      public function get textBehavior() : String
      {
         return this.m_TextBehavior;
      }
      
      public function set maxRows(aRows:uint) : void
      {
         if(aRows != this.m_MaxRows || this.m_MaxDisplayedItems <= 0)
         {
            this.m_MaxRows = aRows;
            this.invalidateData();
         }
      }
      
      public function set maxCols(aCols:uint) : void
      {
         if(aCols != this.m_MaxCols || this.m_MaxDisplayedItems <= 0)
         {
            this.m_MaxCols = aCols;
            this.invalidateData();
         }
      }
      
      public function invalidateData() : void
      {
         this.m_NeedRecreateClips = true;
         this.m_NeedRecalculateScrollMax = true;
         this.m_NeedRedraw = true;
         this.setIsDirty();
      }
      
      public function set scrollVertical(aVert:Boolean) : void
      {
         this.m_ScrollVertical = aVert;
         this.m_NeedRecalculateScrollMax = true;
         this.m_NeedRedraw = true;
         this.setIsDirty();
      }
      
      public function get scrollVertical() : Boolean
      {
         return this.m_ScrollVertical;
      }
      
      public function get selectedEntry() : Object
      {
         return this.m_Entries[this.m_SelectedIndex];
      }
      
      public function get rowScrollPos() : int
      {
         return this.m_RowScrollPos;
      }
      
      public function get colScrollPos() : int
      {
         return this.m_ColScrollPos;
      }
      
      public function get displayWidth() : Number
      {
         return this.m_DisplayWidth;
      }
      
      public function get displayHeight() : Number
      {
         return this.m_DisplayHeight;
      }
      
      public function set useVariableWidth(aBool:Boolean) : void
      {
         this.m_UseVariableWidth = aBool;
      }
      
      public function get useVariableWidth() : Boolean
      {
         return this.m_UseVariableWidth;
      }
      
      public function set useVariableHeight(aBool:Boolean) : void
      {
         this.m_UseVariableHeight = aBool;
      }
      
      public function get useVariableHeight() : Boolean
      {
         return this.m_UseVariableHeight;
      }
      
      public function set AnimatedArrows(aAnimated:Boolean) : void
      {
         this.m_AnimatedArrows = aAnimated;
      }
      
      public function get AnimatedArrows() : Boolean
      {
         return this.m_AnimatedArrows;
      }
      
      public function set rowScrollPos(aPos:int) : void
      {
         aPos = GlobalFunc.Clamp(aPos,0,this.m_RowScrollPosMax);
         if(aPos != this.m_RowScrollPos)
         {
            this.m_RowScrollPos = aPos;
            this.m_NeedRedraw = true;
            this.m_NeedSliderUpdate = true;
            this.setIsDirty();
         }
      }
      
      public function set colScrollPos(aPos:int) : void
      {
         aPos = GlobalFunc.Clamp(aPos,0,this.m_ColScrollPosMax);
         if(aPos != this.m_ColScrollPos)
         {
            this.m_ColScrollPos = aPos;
            this.m_NeedRedraw = true;
            this.m_NeedSliderUpdate = true;
            this.setIsDirty();
         }
      }
      
      public function get disableInput() : Boolean
      {
         return this.m_DisableInput;
      }
      
      public function set disableInput(aDisabled:Boolean) : void
      {
         this.m_DisableInput = aDisabled;
      }
      
      public function get disableMouseWheel() : Boolean
      {
         return this.m_DisableMouseWheel;
      }
      
      public function set disableMouseWheel(aBool:Boolean) : void
      {
         this.m_DisableMouseWheel = aBool;
      }
      
      public function get disableSelection() : Boolean
      {
         return this.m_DisableSelection;
      }
      
      public function set disableSelection(aBool:Boolean) : void
      {
         this.m_DisableSelection = aBool;
      }
      
      public function get ignoreMouse() : Boolean
      {
         return this.m_IgnoreMouse;
      }
      
      public function get selectedCol() : uint
      {
         return this.getColFromIndex(this.m_SelectedIndex);
      }
      
      public function get selectedRow() : uint
      {
         return this.getRowFromIndex(this.m_SelectedIndex);
      }
      
      public function get displayedItemCount() : uint
      {
         return this.m_DisplayedItemCount;
      }
      
      public function get maxDisplayedItems() : uint
      {
         return this.m_MaxDisplayedItems;
      }
      
      public function get entryCount() : uint
      {
         return this.m_Entries.length;
      }
      
      public function get idName() : String
      {
         return this.m_IdName;
      }
      
      public function set idName(aString:String) : void
      {
         this.m_IdName = aString;
      }
      
      public function get selectedEntryId() : *
      {
         return this.m_SelectedEntryId;
      }
      
      public function get selectedIndex() : int
      {
         return this.m_SelectedIndex;
      }
      
      public function set selectedIndex(aIndex:int) : *
      {
         var newIndex:int = GlobalFunc.Clamp(aIndex,-1,this.m_Entries.length - 1);
         if(newIndex != this.m_SelectedIndex)
         {
            this.m_PrevSelectedIndex = this.m_SelectedIndex;
            this.m_SelectedIndex = newIndex;
            if(this.idName != "" && this.entryData && this.m_SelectedIndex < this.entryData.length && this.m_SelectedIndex > -1)
            {
               this.m_SelectedEntryId = this.entryData[this.m_SelectedIndex][this.idName];
            }
            ++this.m_SelectionChangeCount;
            dispatchEvent(new CustomEvent(SELECTION_CHANGE,{"navFromInput":this.m_NavChangeFromInput},true,true));
            this.m_NavChangeFromInput = false;
            this.constrainScrollToSelection();
            this.m_NeedRedraw = true;
            this.setIsDirty();
         }
      }
      
      public function get selectedClip() : BSScrollingListEntry
      {
         return this.m_SelectedClip;
      }
      
      public function set listItemClassName(aName:String) : void
      {
         this.m_ListItemClass = getDefinitionByName(aName) as Class;
         this.m_ListItemClassName = aName;
         this.m_NeedRedraw = true;
      }
      
      public function get entryData() : Array
      {
         return this.m_Entries;
      }
      
      public function set entryData(aEntries:Array) : void
      {
         var i:uint = 0;
         this.m_Entries = aEntries;
         if(this.m_Entries == null)
         {
            this.m_Entries = new Array();
         }
         this.m_NeedRecalculateScrollMax = true;
         this.m_NeedRedraw = true;
         if(this.setSelectedIndexOnFirstEntryDataInit && aEntries && aEntries.length > 0 && this.selectedIndex <= -1)
         {
            this.m_NavChangeFromInput = false;
            this.selectedIndex = 0;
         }
         else if(this.idName != "" && this.selectedEntryId != null)
         {
            for(i = 0; i < this.entryData.length; i++)
            {
               if(this.entryData[i][this.idName] === this.selectedEntryId)
               {
                  this.m_NavChangeFromInput = false;
                  this.selectedIndex = i;
                  break;
               }
            }
         }
         this.setIsDirty();
      }
      
      public function set needRedraw(aNeed:*) : void
      {
         this.m_NeedRedraw = aNeed;
      }
      
      public function set wheelSelectionScroll(aEnabled:Boolean) : void
      {
         this.m_WheelSelectionScroll = aEnabled;
      }
      
      public function get wheelSelectionScroll() : Boolean
      {
         return this.m_WheelSelectionScroll;
      }
      
      public function set selectionScrollLockOffset(aOffset:int) : void
      {
         this.m_SelectionScrollLockOffset = aOffset;
      }
      
      public function get selectionScrollLockOffset() : int
      {
         return this.m_SelectionScrollLockOffset;
      }
      
      public function set selectionScrollLock(aLocked:Boolean) : void
      {
         this.m_SelectionScrollLock = aLocked;
      }
      
      public function get selectionScrollLock() : Boolean
      {
         return this.m_SelectionScrollLock;
      }
      
      public function get lastNavDirection() : int
      {
         return this.m_LastNavDirection;
      }
      
      public function set entriesLayeredInOrder(aBool:Boolean) : void
      {
         this.m_EntriesLayeredInOrder = aBool;
      }
      
      public function get entriesLayeredInOrder() : Boolean
      {
         return this.m_EntriesLayeredInOrder;
      }
      
      public function set setSelectedIndexOnFirstEntryDataInit(aBool:Boolean) : void
      {
         this.m_SetSelectedIndexOnFirstEntryDataInit = aBool;
      }
      
      public function get setSelectedIndexOnFirstEntryDataInit() : Boolean
      {
         return this.m_SetSelectedIndexOnFirstEntryDataInit;
      }
      
      public function get prevSelectedIndex() : int
      {
         return this.m_PrevSelectedIndex;
      }
      
      public function get selectionChangeCount() : int
      {
         return this.m_SelectionChangeCount;
      }
      
      public function get isInitialSelection() : Boolean
      {
         return this.m_SelectionChangeCount == 1;
      }
      
      private function getRowFromIndex(aIndex:int) : uint
      {
         if(aIndex > 0)
         {
            return Math.floor(aIndex / (this.m_MaxCols + this.m_ColScrollPosMax));
         }
         return 0;
      }
      
      private function getColFromIndex(aIndex:int) : uint
      {
         if(aIndex > 0)
         {
            return aIndex % (this.m_MaxCols + this.m_ColScrollPosMax);
         }
         return 0;
      }
      
      public function setIsDirty() : void
      {
         if(!this.m_IsDirty)
         {
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.m_IsDirty = true;
         }
      }
      
      private function onEnterFrame(a:Event) : void
      {
         this.m_NavChangeFromInput = false;
         this.selectedIndex = this.selectedIndex;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.m_IsDirty = false;
         if(this.m_NeedRecalculateScrollMax)
         {
            this.calculateListScrollMax();
         }
         if(this.m_NeedRecreateClips)
         {
            this.createEntryClips();
         }
         if(this.m_NeedRedraw || this.m_QueueSelectUnderMouse)
         {
            this.m_ListStartIndex = this.m_ScrollVertical ? this.m_MaxCols * this.m_RowScrollPos : this.m_MaxRows * this.m_ColScrollPos;
         }
         if(this.m_QueueSelectUnderMouse)
         {
            this.selectItemUnderMouse();
         }
         if(this.m_NeedRedraw)
         {
            this.redrawList();
         }
      }
      
      public function getIndexFromGridPos(aRow:uint, aCol:uint) : int
      {
         return aRow * this.m_MaxCols + aCol;
      }
      
      public function ForceRedraw() : void
      {
         this.createEntryClips();
         this.redrawList();
      }
      
      private function constrainScrollToSelection() : void
      {
         var row:uint = 0;
         var col:uint = 0;
         var minViewableRow:uint = 0;
         var maxViewableRow:uint = 0;
         var minViewableCol:uint = 0;
         var maxViewableCol:uint = 0;
         if(this.m_NeedRecalculateScrollMax)
         {
            this.calculateListScrollMax();
         }
         if(this.selectedIndex > 0)
         {
            row = this.selectedRow;
            col = this.selectedCol;
            if(this.m_SelectionScrollLock)
            {
               if(this.m_ScrollVertical)
               {
                  this.rowScrollPos = row + this.m_SelectionScrollLockOffset;
               }
               else
               {
                  this.colScrollPos = col + this.m_SelectionScrollLockOffset;
               }
            }
            else if(this.m_ScrollVertical)
            {
               minViewableRow = this.m_RowScrollPos;
               maxViewableRow = this.m_RowScrollPos + this.m_MaxRows - 1;
               if(row < minViewableRow)
               {
                  this.rowScrollPos = row;
               }
               else if(row > maxViewableRow)
               {
                  this.rowScrollPos = row - (this.m_MaxRows - 1);
               }
            }
            else
            {
               minViewableCol = this.m_ColScrollPos;
               maxViewableCol = this.m_ColScrollPos + this.m_MaxCols - 1;
               if(col < minViewableCol)
               {
                  this.colScrollPos = col;
               }
               else if(col > maxViewableCol)
               {
                  this.colScrollPos = col - (this.m_MaxCols - 1);
               }
            }
         }
         else
         {
            this.rowScrollPos = 0;
            this.colScrollPos = 0;
         }
      }
      
      public function onKeyDown(event:KeyboardEvent) : *
      {
         var row:uint = 0;
         var col:uint = 0;
         var selectionChange:Boolean = false;
         var validKey:Boolean = false;
         if(!this.m_DisableInput)
         {
            row = this.selectedRow;
            col = this.selectedCol;
            selectionChange = false;
            validKey = false;
            switch(event.keyCode)
            {
               case Keyboard.UP:
                  validKey = true;
                  if(row > 0)
                  {
                     selectionChange = true;
                     row--;
                  }
                  event.stopPropagation();
                  break;
               case Keyboard.DOWN:
                  validKey = true;
                  if(row < this.getRowFromIndex(this.m_Entries.length - 1))
                  {
                     selectionChange = true;
                     row++;
                  }
                  event.stopPropagation();
                  break;
               case Keyboard.LEFT:
                  validKey = true;
                  if(col > 0)
                  {
                     selectionChange = true;
                     col--;
                  }
                  event.stopPropagation();
                  break;
               case Keyboard.RIGHT:
                  validKey = true;
                  if(col < this.m_MaxCols - 1 + this.m_ColScrollPosMax && this.selectedIndex < this.entryCount - 1)
                  {
                     selectionChange = true;
                     col++;
                  }
                  event.stopPropagation();
            }
            this.m_LastNavDirection = event.keyCode;
            this.m_IgnoreMouse = this.m_IgnoreMouse || selectionChange || validKey;
            if(selectionChange)
            {
               this.m_NavChangeFromInput = true;
               this.selectedIndex = this.getIndexFromGridPos(row,col);
            }
            else if(validKey)
            {
               dispatchEvent(new CustomEvent(SELECTION_EDGE_BOUNCE,{"dir":this.lastNavDirection},true,true));
            }
         }
      }
      
      public function onKeyUp(event:KeyboardEvent) : *
      {
         if(!this.m_DisableInput && !this.m_DisableSelection && event.keyCode == Keyboard.ENTER)
         {
            this.onItemPress(event);
            event.stopPropagation();
         }
      }
      
      private function onItemClick(aEvent:Event) : void
      {
         this.m_IgnoreMouse = false;
         if(this.m_WheelSelectionScroll && this.m_uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            if((aEvent.target as BSScrollingListEntry).itemIndex != this.m_SelectedIndex)
            {
               this.selectedIndex = (aEvent.target as BSScrollingListEntry).itemIndex;
            }
            else
            {
               if(!this.m_DisableInput && !this.m_DisableSelection && this.m_SelectedIndex != -1)
               {
                  dispatchEvent(new Event(ITEM_CLICKED,true,true));
               }
               this.onItemPress(aEvent);
            }
         }
         else
         {
            if(!this.m_DisableInput && !this.m_DisableSelection && this.m_SelectedIndex != -1)
            {
               dispatchEvent(new Event(ITEM_CLICKED,true,true));
            }
            this.onItemPress(aEvent);
         }
      }
      
      public function onItemPress(eEvent:Event) : void
      {
         if(!this.m_DisableInput && !this.m_DisableSelection && this.m_SelectedIndex != -1)
         {
            dispatchEvent(new Event(ITEM_PRESS,true,true));
         }
         else
         {
            dispatchEvent(new Event(LIST_PRESS,true,true));
         }
      }
      
      private function onItemMouseOver(aEvent:MouseEvent) : void
      {
         if(!this.m_DisableInput && !this.m_DisableSelection && !this.m_WheelSelectionScroll && !this.m_IgnoreMouse && this.m_uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            this.m_NavChangeFromInput = true;
            this.selectedIndex = (aEvent.currentTarget as BSScrollingListEntry).itemIndex;
            dispatchEvent(new Event(MOUSE_OVER_ITEM,true,true));
         }
      }
      
      private function onMouseMove(aEvent:MouseEvent) : void
      {
         this.m_IgnoreMouse = false;
      }
      
      private function onMouseWheel(aEvent:MouseEvent) : void
      {
         var posAdd:* = false;
         this.m_IgnoreMouse = false;
         if(!this.m_DisableInput && !this.m_DisableMouseWheel && this.m_uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            this.m_NavChangeFromInput = true;
            posAdd = aEvent.delta < 0;
            if(this.m_WheelSelectionScroll)
            {
               if(posAdd)
               {
                  this.m_LastNavDirection = this.m_ScrollVertical ? int(Keyboard.UP) : int(Keyboard.RIGHT);
                  ++this.selectedIndex;
               }
               else if(this.selectedIndex > 0)
               {
                  this.m_LastNavDirection = this.m_ScrollVertical ? int(Keyboard.DOWN) : int(Keyboard.LEFT);
                  --this.selectedIndex;
               }
            }
            else
            {
               this.m_QueueSelectUnderMouse = true;
               if(this.m_ScrollVertical)
               {
                  this.scrollRow(posAdd);
               }
               else
               {
                  this.scrollCol(posAdd);
               }
            }
            aEvent.stopPropagation();
         }
      }
      
      public function scrollRow(aAdd:Boolean, aWrap:* = false) : void
      {
         var row:int = aAdd ? this.m_RowScrollPos + 1 : int(this.m_RowScrollPos - 1);
         if(aWrap)
         {
            if(row < 0)
            {
               row = this.m_RowScrollPosMax - 1;
            }
            else if(row >= this.m_RowScrollPosMax)
            {
               row = 0;
            }
         }
         else
         {
            row = Math.max(0,row);
         }
         this.rowScrollPos = row;
      }
      
      public function scrollCol(aAdd:Boolean, aWrap:* = false) : void
      {
         var col:int = aAdd ? this.m_ColScrollPos + 1 : int(this.m_ColScrollPos - 1);
         if(aWrap)
         {
            if(col < 0)
            {
               col = this.m_ColScrollPosMax - 1;
            }
            else if(col >= this.m_ColScrollPosMax)
            {
               col = 0;
            }
         }
         else
         {
            col = Math.max(0,col);
         }
         this.colScrollPos = col;
      }
      
      private function onSliderValueChange(aEvent:CustomEvent) : void
      {
         if(this.m_ScrollVertical && this.ScrollVert_mc != null && aEvent.target == this.ScrollVert_mc)
         {
            this.rowScrollPos = aEvent.params as uint;
         }
         if(!this.m_ScrollVertical && this.ScrollHoriz_mc != null && aEvent.target == this.ScrollHoriz_mc)
         {
            this.colScrollPos = aEvent.params as uint;
         }
      }
      
      private function onPlatformChange(aEvent:PlatformChangeEvent) : void
      {
         this.m_uiController = aEvent.uiController;
      }
      
      private function onAddedToStage(e:Event) : void
      {
         if(this.ScrollUp_mc != null)
         {
            this.ScrollUp_mc.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):*
            {
               scrollRow(false);
            });
         }
         if(this.ScrollDown_mc != null)
         {
            this.ScrollDown_mc.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):*
            {
               scrollRow(true);
            });
         }
         if(this.ScrollLeft_mc != null)
         {
            this.ScrollLeft_mc.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):*
            {
               scrollCol(false);
            });
         }
         if(this.ScrollRight_mc != null)
         {
            this.ScrollRight_mc.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):*
            {
               scrollCol(true);
            });
         }
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         addEventListener(BSSlider.VALUE_CHANGED,this.onSliderValueChange);
         stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onPlatformChange);
         stage.focus = this;
      }
      
      protected function populateEntryClip(aEntryClip:BSScrollingListEntry, aEntryData:Object) : *
      {
         if(aEntryClip != null)
         {
            aEntryClip.selected = aEntryData == this.selectedEntry && this.m_ShowSelectedItem;
            if(aEntryClip.selected)
            {
               this.m_SelectedClip = aEntryClip;
            }
            try
            {
               aEntryClip.SetEntryText(aEntryData,this.m_TextBehavior);
            }
            catch(e:Error)
            {
               trace("BCGridList::populateEntryClip -- SetEntryText error: " + e.getStackTrace());
            }
         }
      }
      
      private function calculateListScrollMax() : void
      {
         var totalRows:uint = 0;
         var totalCols:uint = 0;
         if(this.m_ScrollVertical)
         {
            this.m_ColScrollPosMax = 0;
            totalRows = Math.ceil(this.m_Entries.length / this.m_MaxCols);
            this.m_RowScrollPosMax = totalRows - this.m_MaxRows;
            if(this.ScrollVert_mc != null)
            {
               this.ScrollVert_mc.dispatchOnValueChange = false;
               this.ScrollVert_mc.minValue = 0;
               this.ScrollVert_mc.maxValue = this.m_RowScrollPosMax;
               this.ScrollVert_mc.dispatchOnValueChange = true;
            }
         }
         else
         {
            this.m_RowScrollPosMax = 0;
            totalCols = Math.ceil(this.m_Entries.length / this.m_MaxRows);
            this.m_ColScrollPosMax = totalCols - this.m_MaxCols;
            if(this.ScrollHoriz_mc != null)
            {
               this.ScrollHoriz_mc.dispatchOnValueChange = false;
               this.ScrollHoriz_mc.minValue = 0;
               this.ScrollHoriz_mc.maxValue = this.m_ColScrollPosMax;
               this.ScrollHoriz_mc.dispatchOnValueChange = true;
            }
         }
         this.m_NeedRecalculateScrollMax = false;
         this.m_NeedRedraw = true;
      }
      
      public function clearList() : void
      {
         this.m_Entries.splice(0,this.m_Entries.length);
      }
      
      private function getNewEntryClip() : BSScrollingListEntry
      {
         return new this.m_ListItemClass() as BSScrollingListEntry;
      }
      
      private function createEntryClip(aIndex:uint, aRow:uint, aCol:uint) : Boolean
      {
         var newClip:BSScrollingListEntry = this.getNewEntryClip();
         if(newClip != null)
         {
            newClip.parentClip = this.parent as MovieClip;
            newClip.clipIndex = aIndex;
            newClip.clipRow = aRow;
            newClip.clipCol = aCol;
            newClip.addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
            newClip.addEventListener(MouseEvent.CLICK,this.onItemClick);
            if(this.m_EntriesLayeredInOrder)
            {
               this.EntryHolder_mc.addChildAt(newClip,0);
            }
            else
            {
               this.EntryHolder_mc.addChild(newClip);
            }
            this.m_ClipVector.push(newClip);
            return true;
         }
         trace("BCGridList::createEntryClip -- m_ListItemClass is invalid or does not derive from BSScrollingListEntry.");
         return false;
      }
      
      private function createEntryClips() : void
      {
         var clip:BSScrollingListEntry = null;
         while(this.EntryHolder_mc.numChildren > 0)
         {
            clip = this.getClipByIndex(0);
            clip.Dtor();
            this.EntryHolder_mc.removeChildAt(0);
         }
         this.m_ClipVector = new Vector.<BSScrollingListEntry>();
         var clipIndex:uint = 0;
         var curRow:uint = 0;
         var curCol:uint = 0;
         if(this.m_ScrollVertical)
         {
            for(curRow = 0; curRow < this.m_MaxRows; curRow++)
            {
               for(curCol = 0; curCol < this.m_MaxCols; curCol++)
               {
                  if(this.createEntryClip(clipIndex,curRow,curCol))
                  {
                     clipIndex++;
                  }
               }
            }
         }
         else
         {
            for(curCol = 0; curCol < this.m_MaxCols; curCol++)
            {
               for(curRow = 0; curRow < this.m_MaxRows; curRow++)
               {
                  if(this.createEntryClip(clipIndex,curRow,curCol))
                  {
                     clipIndex++;
                  }
               }
            }
         }
         this.m_MaxDisplayedItems = clipIndex;
         this.m_NeedRecreateClips = false;
      }
      
      public function getClipByIndex(aIndex:uint) : BSScrollingListEntry
      {
         return aIndex < this.EntryHolder_mc.numChildren ? this.m_ClipVector[aIndex] as BSScrollingListEntry : null;
      }
      
      public function ToggleActiveState(aActive:Boolean) : void
      {
         this.m_Active = aActive;
         if(Boolean(this.ScrollUp_mc) && Boolean(this.ScrollDown_mc))
         {
            if(this.m_AnimatedArrows)
            {
               this.animateArrows();
            }
            else
            {
               this.ScrollUp_mc.visible = this.m_Active;
               this.ScrollDown_mc.visible = this.m_Active;
            }
         }
      }
      
      private function animateArrows() : void
      {
         this.ScrollUp_mc.visible = true;
         this.ScrollDown_mc.visible = true;
         if(this.m_RowScrollPos > 0 && this.m_Active)
         {
            this.ScrollUp_mc.gotoAndPlay("Active");
         }
         else
         {
            this.ScrollUp_mc.gotoAndStop("Disabled");
         }
         if(this.m_RowScrollPos < this.m_RowScrollPosMax && this.m_Active)
         {
            this.ScrollDown_mc.gotoAndPlay("Active");
         }
         else
         {
            this.ScrollDown_mc.gotoAndStop("Disabled");
         }
      }
      
      private function updateScrollIndicators() : void
      {
         if(this.m_ScrollVertical && this.ScrollUp_mc && Boolean(this.ScrollDown_mc))
         {
            if(this.m_AnimatedArrows)
            {
               this.animateArrows();
            }
            else
            {
               this.ScrollUp_mc.visible = this.m_ScrollVertical && this.m_RowScrollPos > 0;
               this.ScrollDown_mc.visible = this.m_ScrollVertical && this.m_RowScrollPos < this.m_RowScrollPosMax;
            }
         }
         if(this.ScrollLeft_mc != null)
         {
            this.ScrollLeft_mc.visible = !this.m_ScrollVertical && this.m_ColScrollPos > 0;
         }
         if(this.ScrollRight_mc != null)
         {
            this.ScrollRight_mc.visible = !this.m_ScrollVertical && this.m_ColScrollPos < this.m_ColScrollPosMax;
         }
         if(this.ScrollVert_mc != null)
         {
            if(this.m_ScrollVertical && this.m_RowScrollPosMax > 0)
            {
               if(this.m_NeedSliderUpdate)
               {
                  this.ScrollVert_mc.doSetValue(this.m_RowScrollPos,false);
               }
               this.ScrollVert_mc.visible = true;
            }
            else
            {
               this.ScrollVert_mc.visible = false;
            }
         }
         if(this.ScrollHoriz_mc != null)
         {
            if(!this.m_ScrollVertical && this.m_ColScrollPosMax > 0)
            {
               if(this.m_NeedSliderUpdate)
               {
                  this.ScrollHoriz_mc.doSetValue(this.m_ColScrollPos,false);
               }
               this.ScrollHoriz_mc.visible = true;
            }
            else
            {
               this.ScrollHoriz_mc.visible = false;
            }
         }
         this.m_NeedSliderUpdate = false;
      }
      
      private function selectItemUnderMouse() : void
      {
         var i:uint = 0;
         var curClip:BSScrollingListEntry = null;
         var hitTarget:MovieClip = null;
         var testPoint:Point = null;
         if(!this.m_DisableSelection && !this.m_DisableInput && this.m_uiController == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
         {
            this.m_QueueSelectUnderMouse = false;
            for(i = 0; i < this.m_MaxDisplayedItems; i++)
            {
               curClip = this.m_ClipVector[i];
               hitTarget = curClip as MovieClip;
               if(curClip.HitTarget_mc != null)
               {
                  hitTarget = curClip.HitTarget_mc;
               }
               else if(curClip.Sizer_mc != null)
               {
                  hitTarget = curClip.Sizer_mc;
               }
               testPoint = localToGlobal(new Point(mouseX,mouseY));
               if(hitTarget.hitTestPoint(testPoint.x,testPoint.y,false))
               {
                  this.selectedIndex = this.m_ListStartIndex + i;
               }
            }
         }
      }
      
      protected function redrawList() : void
      {
         var startIndex:uint = 0;
         var endIndex:uint = 0;
         var clipIndex:uint = 0;
         var clipWidth:Number = NaN;
         var clipHeight:Number = NaN;
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var xPosMax:Number = NaN;
         var yPosMax:Number = NaN;
         var nextX:Number = NaN;
         var nextY:Number = NaN;
         var i:uint = 0;
         var curClip:BSScrollingListEntry = null;
         this.m_DisplayWidth = 0;
         this.m_DisplayHeight = 0;
         this.m_DisplayedItemCount = 0;
         this.m_SelectedClip = null;
         if(this.m_MaxDisplayedItems > 0)
         {
            startIndex = this.m_ListStartIndex;
            endIndex = this.m_Entries.length;
            clipIndex = 0;
            xPos = 0;
            yPos = 0;
            xPosMax = 0;
            yPosMax = 0;
            nextX = 0;
            nextY = 0;
            for(i = 0; i < this.m_MaxDisplayedItems; i++)
            {
               curClip = this.m_ClipVector[i];
               if(curClip != null)
               {
                  if(i + startIndex < endIndex)
                  {
                     curClip.itemIndex = i + startIndex;
                     this.populateEntryClip(curClip,this.m_Entries[i + startIndex]);
                     ++this.m_DisplayedItemCount;
                     if(curClip.Sizer_mc != null)
                     {
                        clipWidth = curClip.Sizer_mc.width;
                        clipHeight = curClip.Sizer_mc.height;
                     }
                     else
                     {
                        clipWidth = curClip.width;
                        clipHeight = curClip.height;
                     }
                     curClip.visible = true;
                     if(this.useVariableWidth)
                     {
                        curClip.x = curClip.clipCol != 0 ? nextX : 0;
                     }
                     else
                     {
                        curClip.x = clipWidth * curClip.clipCol;
                     }
                     if(this.useVariableHeight)
                     {
                        curClip.y = nextY;
                     }
                     else
                     {
                        curClip.y = clipHeight * curClip.clipRow;
                     }
                     xPosMax = Math.max(xPosMax,curClip.x + clipWidth);
                     yPosMax = Math.max(yPosMax,curClip.y + clipHeight);
                  }
                  else
                  {
                     curClip.visible = false;
                     curClip.itemIndex = int.MAX_VALUE;
                  }
                  nextX = curClip.x + clipWidth;
                  nextY = curClip.y + clipHeight;
               }
            }
            this.m_DisplayWidth = xPosMax;
            this.m_DisplayHeight = yPosMax;
            this.updateScrollIndicators();
         }
         else
         {
            trace("BCGridList::redrawList -- List configuration resulted in m_MaxDisplayedItems < 1 (unable to display any items) - " + this.name);
         }
         dispatchEvent(new Event(LIST_UPDATED,true,true));
         this.m_NeedRedraw = false;
      }
   }
}

