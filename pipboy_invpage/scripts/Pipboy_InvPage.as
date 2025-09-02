package
{
   import Shared.AS3.BGSExternalInterface;
   import Shared.AS3.BSButtonHintData;
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.COMPANIONAPP.CompanionAppMode;
   import Shared.AS3.COMPANIONAPP.MobileQuantityMenu;
   import Shared.AS3.Events.PlatformChangeEvent;
   import Shared.AS3.StyleSheet;
   import Shared.AS3.Styles.Pipboy_InvPage_ComponentListStyle;
   import Shared.AS3.Styles.Pipboy_InvPage_ComponentOwnedListStyle;
   import Shared.AS3.Styles.Pipboy_InvPage_InvListStyle;
   import Shared.GlobalFunc;
   import Shared.QuantityMenuNEW;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.ui.Keyboard;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class Pipboy_InvPage extends PipboyPage
   {
      
      public static var ShowDurability:Boolean = false;
      
      public static var CheckItemProtectionOnSelectionChange:Boolean = false;
      
      private static var m_IsTransferLockingFeatureEnabled:Boolean = false;
      
      public static const EVENT_LOCK_ITEM:String = "Container::TransferLockToggle";
      
      public var List_mc:BSScrollingList;
      
      public var ComponentList_mc:BSScrollingList;
      
      public var ComponentOwnersList_mc:BSScrollingList;
      
      public var ItemCardScrollable_mc:ItemCardScrollable;
      
      public var ModalFadeRect_mc:MovieClip;
      
      public var PaperDoll_mc:PaperDoll;
      
      private var _QuantityMenu:QuantityMenuNEW;
      
      private const DROP_ITEM_COUNT_THRESHOLD:uint = 5;
      
      private var _ShowingQuantity:Boolean;
      
      private var _CurrentTab:int = -1;
      
      private var _HolotapePlaying:Boolean;
      
      private var _HolotapeServerHandleID:uint;
      
      private var _ComponentViewMode:Boolean;
      
      private var _SortMode:uint;
      
      private var _SortSelectionRestoreIndex:int;
      
      private var _quantityMenuOnItemID:uint;
      
      private var _overMaxWeight:Boolean;
      
      private var _canDropCurrentItem:Boolean;
      
      private var _canDestroyCurrentItem:Boolean;
      
      private var _SelectedIndex:int = 0;
      
      private var _InventoryList:Array;
      
      private var m_PreviousNodeID:uint = 0;
      
      private var m_KeyringView:Boolean = false;
      
      private var m_KeysList:Array;
      
      private var m_LockHolding:Boolean = false;
      
      private var m_LockHoldStartTimeout:int = -1;
      
      private var m_TransferLockText:String = "$LOCK";
      
      private var m_TransferUnlockText:String = "$UNLOCK";
      
      private var HolotapeButton:BSButtonHintData;
      
      private var NoteReadButton:BSButtonHintData;
      
      private var InspectRepairButton:BSButtonHintData;
      
      private var DropButton:BSButtonHintData;
      
      private var FavButton:BSButtonHintData;
      
      private var AcceptButton:BSButtonHintData;
      
      private var CancelButton:BSButtonHintData;
      
      private var ComponentToggleButton:BSButtonHintData;
      
      private var SortButton:BSButtonHintData;
      
      private var KeyringButton:BSButtonHintData;
      
      private var LockButton:BSButtonHintData;
      
      private const MISC_TAB:uint = 6;
      
      private const HOLO_TAB:uint = 7;
      
      private const NOTES_TAB:uint = 8;
      
      private const JUNK_TAB:uint = 9;
      
      private const CLEAR_ITEM:uint = 4294967295;
      
      private var SortText:Array = ["$SORT","$SORT_DMG","$SORT_ROF","$SORT_RNG","$SORT_ACC","$SORT_VAL","$SORT_WT","$SORT_SW","$SORT_SPL","$SORT_LOCK"];
      
      private var previousSelectedNodeId:*;
      
      public var __modLoader:Loader;
      
      public var __modLoader2:Loader;
      
      public function Pipboy_InvPage()
      {
         this.HolotapeButton = new BSButtonHintData("$HolotapePlay","Space","PSN_A","Xenon_A",1,this.SelectItem);
         this.NoteReadButton = new BSButtonHintData("$READ","Space","PSN_A","Xenon_A",1,this.SelectItem);
         this.InspectRepairButton = new BSButtonHintData("$INSPECT","X","PSN_R3","Xenon_R3",1,this.InspectRepairItem);
         this.DropButton = new BSButtonHintData("$DROP","R","PSN_X","Xenon_X",1,this.DropItem);
         this.FavButton = new BSButtonHintData("$FAV","C","PSN_R1","Xenon_R1",1,this.onFavButtonPress);
         this.AcceptButton = new BSButtonHintData("$ACCEPT","Space","PSN_A","Xenon_A",1,this.onAcceptPress);
         this.CancelButton = new BSButtonHintData("$CANCEL","Tab","PSN_B","Xenon_B",1,this.onCancelPress);
         this.ComponentToggleButton = new BSButtonHintData("$COMPONENT VIEW","C","PSN_R1","Xenon_R1",1,this.ToggleComponentViewMode);
         this.SortButton = new BSButtonHintData("$SORT","Q","PSN_L3","Xenon_L3",1,this.onSortPress);
         this.KeyringButton = new BSButtonHintData("$OPEN","C","PSN_R1","Xenon_R1",1,this.onKeyringButtonPress);
         this.LockButton = new BSButtonHintData("$LOCK","L","PSN_Y","Xenon_Y",1,this.onLockButton);
         super();
         StyleSheet.apply(this.List_mc,false,Pipboy_InvPage_InvListStyle);
         StyleSheet.apply(this.ComponentOwnersList_mc,false,Pipboy_InvPage_ComponentOwnedListStyle);
         StyleSheet.apply(this.ComponentList_mc,false,Pipboy_InvPage_ComponentListStyle);
         _TabNames = new Array("$InventoryCategoryNew","$InventoryCategoryWeapons","$InventoryCategoryArmor","$InventoryCategoryApparel","$InventoryCategoryFoodWater","$InventoryCategoryAid","$InventoryCategoryMisc","$InventoryCategoryHolo","$InventoryCategoryNotes","$InventoryCategoryJunk","$InventoryCategoryMods","$InventoryCategoryAmmo");
         this.ModalFadeRect_mc.visible = false;
         this._CurrentTab = uint.MAX_VALUE;
         this._ShowingQuantity = false;
         this._HolotapePlaying = false;
         this._HolotapeServerHandleID = uint.MAX_VALUE;
         this._ComponentViewMode = false;
         this._SortMode = 0;
         this._SortSelectionRestoreIndex = -1;
         this._canDropCurrentItem = true;
         this._canDestroyCurrentItem = false;
         this.ComponentOwnersList_mc.disableInput_Inspectable = true;
         this.ComponentOwnersList_mc.disableSelection_Inspectable = true;
         this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange,false,0,true);
         this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed,false,0,true);
         this.ComponentList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onComponentSelectionChange,false,0,true);
         addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onPlatformChange);
         if(CompanionAppMode.isOn)
         {
            this.previousSelectedNodeId = uint.MAX_VALUE;
         }
         this.loadInventOmaticPipboy();
         this.loadBetterInventory();
      }
      
      public static function get IsTransferLockingFeatureEnabled() : Boolean
      {
         return m_IsTransferLockingFeatureEnabled;
      }
      
      public function loadInventOmaticPipboy() : *
      {
         try
         {
            this.__modLoader = new Loader();
            addChild(this.__modLoader);
            this.__modLoader.load(new URLRequest("InventOmaticPipboy.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
            trace("InventOmaticPipboy loaded");
         }
         catch(e:Object)
         {
            GlobalFunc.ShowHUDMessage("Error loading InventOmaticPipboy: " + e);
         }
      }
      
      public function loadBetterInventory() : *
      {
         try
         {
            this.__modLoader2 = new Loader();
            addChild(this.__modLoader2);
            this.__modLoader2.load(new URLRequest("BetterInventory.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
            trace("BetterInventory loaded");
         }
         catch(e:Object)
         {
            trace("Error loading BetterInventory " + e);
         }
      }
      
      public function showDurabilityValue(value:Boolean) : void
      {
         ShowDurability = value;
      }
      
      public function checkItemProtectionOnSelectionChange(value:Boolean) : void
      {
         CheckItemProtectionOnSelectionChange = value;
      }
      
      public function isItemProtected(item:Object, isSelectionChanged:Boolean = false) : Boolean
      {
         if(isSelectionChanged && !CheckItemProtectionOnSelectionChange)
         {
            return false;
         }
         if(this.__modLoader && this.__modLoader.content && this.__modLoader.content.isItemProtected(item))
         {
            return true;
         }
         return false;
      }
      
      public function isItemEquipProtected(item:Object) : Boolean
      {
         if(this.__modLoader && this.__modLoader.content && this.__modLoader.content.isItemEquipProtected(item))
         {
            return true;
         }
         return false;
      }
      
      public function log(string:String) : void
      {
         if(this.__modLoader != null && this.__modLoader.content != null)
         {
            this.__modLoader.content.log(string);
         }
      }
      
      override protected function PopulateButtonHintData() : *
      {
         _buttonHintDataV.push(this.ComponentToggleButton);
         _buttonHintDataV.push(this.HolotapeButton);
         _buttonHintDataV.push(this.NoteReadButton);
         if(!CompanionAppMode.isOn)
         {
            _buttonHintDataV.push(this.InspectRepairButton);
         }
         _buttonHintDataV.push(this.LockButton);
         _buttonHintDataV.push(this.DropButton);
         _buttonHintDataV.push(this.AcceptButton);
         _buttonHintDataV.push(this.CancelButton);
         _buttonHintDataV.push(this.SortButton);
         _buttonHintDataV.push(this.FavButton);
         _buttonHintDataV.push(this.KeyringButton);
      }
      
      override public function InitCodeObj(param1:Object) : *
      {
         super.InitCodeObj(param1);
         BGSExternalInterface.call(this.codeObj,"UpdateInventoryMenuObj",this);
      }
      
      override public function onRemovedFromStage() : void
      {
         this.List_mc.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
         this.List_mc.removeEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
         this.ComponentList_mc.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.onComponentSelectionChange);
         super.onRemovedFromStage();
      }
      
      private function onPlatformChange(param1:PlatformChangeEvent) : void
      {
         this.SetButtons();
      }
      
      override protected function GetUpdateMask() : PipboyUpdateMask
      {
         return PipboyUpdateMask.Inventory;
      }
      
      override protected function UpdateFocus(param1:uint) : *
      {
         if(this._ShowingQuantity)
         {
            stage.focus = this._QuantityMenu;
         }
         else if(this._ComponentViewMode)
         {
            stage.focus = this.ComponentList_mc;
         }
         else
         {
            stage.focus = this.List_mc;
         }
      }
      
      override public function onPageChange(param1:Boolean, param2:uint) : *
      {
         this.ItemCardScrollable_mc.ShouldUpdateItemCardScroll = true;
         super.onPageChange(param1,param2);
         if(this.List_mc.selectedEntry != null)
         {
            this.m_PreviousNodeID = this.List_mc.selectedEntry.nodeID;
         }
         if(this.shouldShow3DItem())
         {
            BGSExternalInterface.call(this.codeObj,"updateItem3D",param1 && Boolean(this.List_mc.selectedEntry) ? this.List_mc.selectedEntry.nodeID as int : -1 as int);
         }
      }
      
      override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(visible == false)
         {
            this.List_mc.disableInput_Inspectable = true;
            this.ItemCardScrollable_mc.DisableInput = true;
            return;
         }
         this.List_mc.SetPlatform(uiPlatform,bPS3Switch,uiController,uiKeyboard);
         this.List_mc.disableInput_Inspectable = this._ComponentViewMode;
         this.List_mc.enableScrollWrap = true;
         this.ComponentList_mc.SetPlatform(uiPlatform,bPS3Switch,uiController,uiKeyboard);
         this.ItemCardScrollable_mc.DisableInput = this._ComponentViewMode;
         super.onPipboyChangeEvent(param1);
         var _loc2_:* = this._CurrentTab != param1.DataObj.CurrentTab;
         m_IsTransferLockingFeatureEnabled = param1.DataObj.IsTransferLockingFeatureEnabled;
         if(param1.DataObj.CurrentTab != this.JUNK_TAB)
         {
            this._ComponentViewMode = false;
         }
         if(CompanionAppMode.isOn)
         {
            if(_loc2_)
            {
               this.List_mc.scrollList.needFullRefresh = true;
            }
         }
         this._overMaxWeight = param1.DataObj.CurrWeight >= param1.DataObj.AbsoluteWeightLimit;
         this._CurrentTab = param1.DataObj.CurrentTab;
         this._InventoryList = param1.DataObj.InvItems;
         this.m_KeysList = param1.DataObj.InvKeyItems;
         if(param1.DataObj.CurrentTab == 0)
         {
            this.List_mc.textOption_Inspectable = "Time";
            _loc3_ = param1.DataObj.InvNewItems;
            if(param1.DataObj.SortMode == 0)
            {
               _loc3_.sort(this.sortFunction);
            }
            this.List_mc.entryList = _loc3_;
            this.List_mc.filterer.itemFilter = 4294967295;
         }
         else if(this.m_KeyringView)
         {
            this.List_mc.entryList = this.m_KeysList;
         }
         else
         {
            this.List_mc.textOption_Inspectable = "None";
            this.List_mc.entryList = param1.DataObj.InvItems;
            this.List_mc.filterer.itemFilter = param1.DataObj.InvFilter;
         }
         if(this.List_mc.entryList != null && this.List_mc.selectedEntry != null && !this.List_mc.filterer.EntryMatchesFilter(this.List_mc.selectedEntry))
         {
            this.updateSelectionOnDataChanged();
         }
         if(!this._ComponentViewMode)
         {
            this.List_mc.InvalidateData();
         }
         if(this.List_mc.selectedEntry != null)
         {
            if(this._ShowingQuantity && this._quantityMenuOnItemID != this.List_mc.selectedEntry.nodeID)
            {
               this.HideQuantity();
            }
         }
         this.ComponentList_mc.entryList = param1.DataObj.InvComponents;
         this.ComponentList_mc.entryList.sortOn("text");
         if(this._ComponentViewMode)
         {
            this.ComponentList_mc.InvalidateData();
         }
         if(visible == true)
         {
            if(!this._ShowingQuantity)
            {
               stage.focus = this._ComponentViewMode ? this.ComponentList_mc : this.List_mc;
            }
            else
            {
               stage.focus = this._QuantityMenu;
            }
         }
         if(_loc2_)
         {
            this.previousSelectedNodeId = param1.DataObj.InvSelectedItems[this._CurrentTab];
         }
         if(this._SortSelectionRestoreIndex != -1)
         {
            if(this._CurrentTab == 0)
            {
               this._SortSelectionRestoreIndex = this.getNewItemsSavedIndex(this._SortSelectionRestoreIndex);
            }
            this.List_mc.selectedIndex = this._SortSelectionRestoreIndex;
            this._SortSelectionRestoreIndex = -1;
         }
         this.PaperDoll_mc.slotResists = param1.DataObj.SlotResists;
         this.PaperDoll_mc.underwearType = param1.DataObj.UnderwearType;
         this.PaperDoll_mc.onDataChange();
         this._HolotapePlaying = param1.DataObj.HolotapePlaying;
         this._HolotapeServerHandleID = param1.DataObj.HolotapeServerHandleID;
         this._SortMode = param1.DataObj.SortMode;
         this.updateSelectionOnDataChanged();
         this.SetButtons();
         SetIsDirty();
         if(this._CurrentTab == 0)
         {
            this._SelectedIndex = this.getItemIndex();
         }
         else
         {
            this._SelectedIndex = this.List_mc.selectedIndex;
         }
         if(this.List_mc.selectedEntry != null && this.m_PreviousNodeID != this.List_mc.selectedEntry.nodeID)
         {
            _loc4_ = -1;
            if(!this._ComponentViewMode)
            {
               this.m_PreviousNodeID = this.List_mc.selectedEntry.nodeID;
               _loc4_ = this._SelectedIndex;
            }
            if(this.shouldShow3DItem())
            {
               BGSExternalInterface.call(this.codeObj,"updateItem3D",this.List_mc.selectedEntry.nodeID as int);
            }
            this.ItemCardScrollable_mc.ShouldUpdateItemCardScroll = true;
         }
         else if(this.List_mc.selectedEntry == null)
         {
            BGSExternalInterface.call(this.codeObj,"updateItem3D",this.CLEAR_ITEM);
         }
         if(this.List_mc.selectedEntry)
         {
            _loc5_ = int(this.List_mc.selectedEntry.nodeID);
            BGSExternalInterface.call(this.codeObj,"onInvItemSelection",_loc5_,this.ItemCardScrollable_mc.ItemCard_mc.InfoObj,this.PaperDoll_mc.selectedInfoObj,this,this.List_mc.selectedEntry != null ? this.List_mc.selectedEntry.serverHandleID : 0);
         }
      }
      
      private function sortFunction(param1:Object, param2:Object) : Number
      {
         var _loc3_:* = param1.time - param2.time;
         if(_loc3_ == 0)
         {
            if(param1.text < param2.text)
            {
               return -1;
            }
            return 0;
         }
         return _loc3_;
      }
      
      private function getNewItemsSavedIndex(param1:*) : int
      {
         var _loc2_:* = undefined;
         if(param1 != -1)
         {
            _loc2_ = 0;
            while(_loc2_ < this.List_mc.entryList.length)
            {
               if(this.List_mc.entryList[_loc2_].nodeID == this._InventoryList[param1].nodeID)
               {
                  return _loc2_;
               }
               _loc2_++;
            }
         }
         return 0;
      }
      
      private function getItemIndex() : int
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._InventoryList.length)
         {
            if(this.List_mc.selectedEntry != null && this._InventoryList[_loc1_].nodeID == this.List_mc.selectedEntry.nodeID)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      private function updateSelectionOnDataChanged() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!this._ComponentViewMode && (this.List_mc.selectedEntry || this.previousSelectedNodeId != -1))
         {
            if(this.previousSelectedNodeId != -1 || this.List_mc.selectedEntry && this.List_mc.selectedEntry.nodeID != this.previousSelectedNodeId)
            {
               _loc1_ = this.List_mc.selectedIndex;
               _loc2_ = false;
               _loc3_ = _loc1_ >= 0 ? _loc1_ : 0;
               while(_loc3_ < this.List_mc.entryList.length)
               {
                  if(this.List_mc.entryList[_loc3_].nodeID == this.previousSelectedNodeId)
                  {
                     this.List_mc.selectedIndex = _loc3_;
                     _loc2_ = true;
                     break;
                  }
                  _loc3_++;
               }
               if(!_loc2_)
               {
                  _loc3_ = _loc1_;
                  while(_loc3_ >= 0)
                  {
                     if(this.List_mc.entryList[_loc3_].nodeID == this.previousSelectedNodeId)
                     {
                        this.List_mc.selectedIndex = _loc3_;
                        _loc2_ = true;
                        break;
                     }
                     _loc3_--;
                  }
               }
               if(!_loc2_)
               {
                  this.List_mc.selectedIndex = _loc1_;
               }
            }
            if(!this.List_mc.filterer.EntryMatchesFilter(this.List_mc.selectedEntry))
            {
               _loc4_ = this.List_mc.filterer.GetPrevFilterMatch(this.List_mc.selectedIndex);
               if(_loc4_ == int.MAX_VALUE)
               {
                  _loc4_ = this.List_mc.filterer.GetNextFilterMatch(this.List_mc.selectedIndex);
               }
               if(_loc4_ == int.MAX_VALUE)
               {
                  this.List_mc.selectedIndex = -1;
               }
               else
               {
                  this.List_mc.selectedIndex = _loc4_;
               }
            }
         }
         else
         {
            if(this.List_mc.selectedIndex == -1)
            {
               this.List_mc.selectedIndex = this.List_mc.filterer.GetPrevFilterMatch(this.List_mc.entryList.length);
               if(this._CurrentTab == 0)
               {
                  this._SelectedIndex = this.getItemIndex();
               }
            }
            _loc5_ = -1;
            if(!this._ComponentViewMode)
            {
               if(this.List_mc.selectedEntry != null)
               {
                  this.m_PreviousNodeID = this.List_mc.selectedEntry.nodeID;
               }
               _loc5_ = this._SelectedIndex;
            }
            if(this.List_mc.selectedEntry)
            {
               _loc6_ = int(this.List_mc.selectedEntry.nodeID);
               if(this.shouldShow3DItem())
               {
                  BGSExternalInterface.call(this.codeObj,"updateItem3D",_loc6_);
               }
            }
         }
         if(this._CurrentTab == this.HOLO_TAB)
         {
            this.SetButtons();
         }
      }
      
      override protected function onReadOnlyChanged(param1:Boolean) : void
      {
         super.onReadOnlyChanged(param1);
         SetScrollingListReadOnly(this.List_mc,param1);
         if(param1)
         {
            this.HideQuantity();
         }
         this.SetButtons();
      }
      
      override protected function HandleMobileBackButton() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._ShowingQuantity)
         {
            this.HideQuantity();
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function onItemPressed(param1:Event) : *
      {
         this.SelectItem();
         param1.stopPropagation();
      }
      
      private function shouldShow3DItem() : Boolean
      {
         return Boolean(this.List_mc) && Boolean(this.List_mc.selectedEntry) && !this.List_mc.selectedEntry.isKeyring && !this._ComponentViewMode;
      }
      
      private function SelectItem() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.List_mc.selectedEntry) && !this.List_mc.selectedEntry.isKeyring)
         {
            if(!this.isItemEquipProtected(this.List_mc.selectedEntry))
            {
               _loc1_ = int(this.List_mc.selectedEntry.nodeID);
               BGSExternalInterface.call(this.codeObj,"SelectItem",_loc1_);
               this.SetButtons();
            }
         }
         else if(Boolean(this.List_mc.selectedEntry) && Boolean(this.List_mc.selectedEntry.isKeyring))
         {
            this.ToggleKeyringView();
            this.SetButtons();
         }
      }
      
      override public function redrawUIComponent() : void
      {
         super.redrawUIComponent();
         this.ModalFadeRect_mc.visible = this._ShowingQuantity;
         this.ItemCardScrollable_mc.visible = !this._ComponentViewMode && this._SelectedIndex != -1;
         this.ItemCardScrollable_mc.DisableInput = this._ComponentViewMode;
         this.ComponentList_mc.visible = this._ComponentViewMode;
         this.ComponentList_mc.disableInput_Inspectable = !this._ComponentViewMode;
         this.ComponentOwnersList_mc.visible = this._ComponentViewMode;
         this.List_mc.visible = !this._ComponentViewMode;
         this.List_mc.disableInput_Inspectable = this._ComponentViewMode;
      }
      
      public function get InspectSelectionIndex() : uint
      {
         return this._SelectedIndex;
      }
      
      public function UpdateInspectSelectionIndex(param1:Boolean) : void
      {
         if(param1)
         {
            this.List_mc.moveSelectionDown();
         }
         else
         {
            this.List_mc.moveSelectionUp();
         }
      }
      
      public function onListSelectionChange() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._CurrentTab == 0)
         {
            this._SelectedIndex = this.getItemIndex();
         }
         else
         {
            this._SelectedIndex = this.List_mc.selectedIndex;
         }
         if(this.List_mc.selectedEntry != null)
         {
            _loc1_ = int(this.List_mc.selectedEntry.nodeID);
            BGSExternalInterface.call(this.codeObj,"onInvItemSelection",_loc1_,this.ItemCardScrollable_mc.ItemCard_mc.InfoObj,this.PaperDoll_mc.selectedInfoObj,this,this.List_mc.selectedEntry.serverHandleID);
            _loc2_ = -1;
            if(!this._ComponentViewMode)
            {
               this.m_PreviousNodeID = this.List_mc.selectedEntry.nodeID;
               _loc2_ = this._SelectedIndex;
            }
            this.previousSelectedNodeId = this.List_mc.selectedEntry.nodeID;
            if(this.shouldShow3DItem())
            {
               BGSExternalInterface.call(this.codeObj,"updateItem3D",_loc1_);
            }
            if(this.List_mc.selectedEntry.isKeyring)
            {
               this.ItemCardScrollable_mc.ItemCard_mc.InfoObj = new Array();
               this.ItemCardScrollable_mc.ItemCard_mc.onDataChange();
               this.SetButtons();
            }
            this.ItemCardScrollable_mc.ShouldUpdateItemCardScroll = true;
         }
      }
      
      public function onListSelectionChangeCallback(param1:Boolean, param2:Boolean) : *
      {
         this.ItemCardScrollable_mc.ItemCard_mc.onDataChange();
         this.PaperDoll_mc.onDataChange();
         dispatchEvent(new Event(PipboyPage.BOTTOM_BAR_UPDATE,true,true));
         this._canDropCurrentItem = param1;
         this._canDestroyCurrentItem = param2;
         this.SetButtons();
         SetIsDirty();
      }
      
      private function onComponentSelectionChange() : *
      {
         if(this.ComponentList_mc.selectedEntry != null)
         {
            this.ComponentOwnersList_mc.entryList = this.ComponentList_mc.selectedEntry.componentOwners;
            this.ComponentOwnersList_mc.entryList.sortOn("text");
         }
         else
         {
            this.ComponentOwnersList_mc.entryList = null;
         }
         this.ComponentOwnersList_mc.InvalidateData();
      }
      
      private function SetButtons() : *
      {
         var _loc1_:* = 1 << 13;
         var _loc2_:* = 1 << 7;
         this.HolotapeButton.ButtonText = this._HolotapePlaying && this.List_mc.selectedEntry != null && this.List_mc.selectedEntry.serverHandleID == this._HolotapeServerHandleID ? "$HolotapeStop" : "$HolotapePlay";
         this.HolotapeButton.ButtonVisible = this._CurrentTab == this.HOLO_TAB && this.List_mc.selectedEntry != null && (this.List_mc.selectedEntry.filterFlag & _loc1_) != 0;
         this.HolotapeButton.ButtonEnabled = !_ReadOnlyMode || (_ReadOnlyModeType == READ_ONLY_OFFLINE || _ReadOnlyModeType == READ_ONLY_DEMO) && this.List_mc.selectedEntry != null && Boolean(this.List_mc.selectedEntry.isMinigame);
         this.NoteReadButton.ButtonVisible = this._CurrentTab == this.NOTES_TAB && this.List_mc.selectedEntry != null && (this.List_mc.selectedEntry.filterFlag & _loc2_) != 0;
         this.NoteReadButton.ButtonEnabled = !_ReadOnlyMode && this.List_mc.selectedEntry != null && !this.List_mc.selectedEntry.isLearned;
         this.NoteReadButton.ButtonText = this.List_mc.selectedEntry != null && Boolean(this.List_mc.selectedEntry.isLearnable) ? "$Learn" : "$READ";
         this.SortButton.ButtonText = this.SortText[this._SortMode];
         this.SortButton.ButtonVisible = !this._ShowingQuantity && !this._ComponentViewMode;
         this.SortButton.ButtonEnabled = !_ReadOnlyMode;
         this.InspectRepairButton.ButtonVisible = !this._ShowingQuantity && !this._ComponentViewMode;
         this.InspectRepairButton.ButtonEnabled = this.List_mc.selectedEntry != null;
         if(this.List_mc.selectedEntry != null && Boolean(this.List_mc.selectedEntry.isRepairable))
         {
            this.InspectRepairButton.ButtonText = "$INSPECT/REPAIR";
         }
         else
         {
            this.InspectRepairButton.ButtonText = "$INSPECT";
         }
         var _loc3_:Object = this.List_mc.selectedEntry;
         this.LockButton.ButtonVisible = !this._ShowingQuantity && !this._ComponentViewMode && _loc3_ != null && !_loc3_.isKeyring;
         if(m_IsTransferLockingFeatureEnabled)
         {
            this.LockButton.ButtonEnabled = _loc3_ != null && Boolean(_loc3_.canBeTransferLocked);
            this.LockButton.ButtonText = _loc3_ != null && Boolean(_loc3_.isTransferLocked) ? this.m_TransferUnlockText : this.m_TransferLockText;
            this.LockButton.canHold = uiController != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE;
         }
         else
         {
            this.LockButton.ButtonVisible = false;
            this.LockButton.ButtonText = this.m_TransferLockText;
         }
         this.DropButton.ButtonVisible = !this._ShowingQuantity && !this._ComponentViewMode && !(this.List_mc.selectedEntry && this.List_mc.selectedEntry.isKeyring);
         this.DropButton.ButtonEnabled = this.List_mc.selectedEntry != null && !_ReadOnlyMode && !(m_IsTransferLockingFeatureEnabled && _loc3_.isTransferLocked) && !this.isItemProtected(this.List_mc.selectedEntry,true);
         this.DropButton.ButtonText = this._overMaxWeight && this._canDestroyCurrentItem ? "$DESTROY" : "$DROP";
         this.FavButton.ButtonText = "$FAV";
         this.FavButton.ButtonVisible = !this._ShowingQuantity && this._CurrentTab != this.JUNK_TAB && this._CurrentTab < this.MISC_TAB;
         this.FavButton.ButtonEnabled = (!this._ComponentViewMode && this.List_mc.selectedEntry != null && this.List_mc.selectedEntry.canFavorite == true || this._ComponentViewMode && this.ComponentList_mc.selectedEntry != null) && !_ReadOnlyMode;
         this.AcceptButton.ButtonVisible = this._ShowingQuantity || this._ComponentViewMode;
         this.AcceptButton.ButtonText = this._ComponentViewMode ? "$TAG FOR SEARCH" : "$ACCEPT";
         this.CancelButton.ButtonVisible = this._ShowingQuantity;
         this.ComponentToggleButton.ButtonText = this._ComponentViewMode ? "$ITEM VIEW" : "$COMPONENT VIEW";
         this.ComponentToggleButton.ButtonVisible = this._CurrentTab == this.JUNK_TAB && !this._ShowingQuantity;
         if(this.List_mc.selectedEntry && this.List_mc.selectedEntry.isKeyring || this.m_KeyringView)
         {
            this.KeyringButton.ButtonVisible = true;
            this.KeyringButton.ButtonText = this.m_KeyringView ? "$CLOSE" : "$OPEN";
         }
         else
         {
            this.KeyringButton.ButtonVisible = false;
         }
      }
      
      override public function CanLowerPipboy() : Boolean
      {
         return !this._ShowingQuantity;
      }
      
      private function onKeyUp(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.onAcceptPress();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.onCancelPress();
         }
      }
      
      private function onAcceptPress() : *
      {
         if(this._ShowingQuantity)
         {
            BGSExternalInterface.call(this.codeObj,"ItemDrop",this.List_mc.selectedEntry.serverHandleID,this._QuantityMenu.count);
            this.HideQuantity();
         }
         else if(this._ComponentViewMode)
         {
            this.onFavButtonPress();
         }
      }
      
      private function onCancelPress() : *
      {
         if(this._ShowingQuantity)
         {
            this.HideQuantity();
         }
      }
      
      override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:* = this.__modLoader2.content;
         if(_loc3_)
         {
            if(_loc3_.ProcessUserEvent(param1,param2))
            {
               return true;
            }
         }
         _loc3_ = false;
         if(this.ModalFadeRect_mc.visible == true)
         {
            _loc3_ = true;
         }
         if(this._ShowingQuantity)
         {
            this._QuantityMenu.ProcessUserEvent(param1,param2);
         }
         if(!_loc3_)
         {
            if(!param2)
            {
               if(this.List_mc.selectedEntry != null)
               {
                  if(param1 == "XButton" && this.DropButton.ButtonVisible)
                  {
                     this.DropItem();
                     _loc3_ = true;
                  }
                  else if(param1 == "R3" && this.InspectRepairButton.ButtonVisible)
                  {
                     this.InspectRepairItem();
                     _loc3_ = true;
                  }
                  else if(param1 == "RShoulder" && this.FavButton.ButtonVisible && this.FavButton.ButtonEnabled && this._CurrentTab != this.JUNK_TAB)
                  {
                     _loc4_ = int(this.List_mc.selectedEntry.nodeID);
                     BGSExternalInterface.call(this.codeObj,"ToggleQuickkey",_loc4_);
                     _loc3_ = true;
                  }
                  else if(param1 == "RShoulder" && (this.List_mc.selectedEntry && this.List_mc.selectedEntry.isKeyring || this.m_KeyringView))
                  {
                     this.onKeyringButtonPress();
                     _loc3_ = true;
                  }
                  else if(param1 == "TransferLockItem_Press" && this.LockButton.ButtonVisible && this.LockButton.ButtonEnabled)
                  {
                     this.onLockButton();
                     _loc3_ = true;
                  }
                  else if(param1 == "TransferLockItem_Hold" && this.LockButton.ButtonVisible && this.LockButton.ButtonEnabled)
                  {
                     if(this.m_LockHolding)
                     {
                        this.m_LockHolding = false;
                        this.stopItemLockHold();
                        _loc3_ = true;
                     }
                     else if(this.m_LockHoldStartTimeout != -1)
                     {
                        this.stopItemLockHold();
                     }
                  }
               }
               if(param1 == "Accept" && this.AcceptButton.ButtonVisible)
               {
                  this.onAcceptPress();
               }
               if(!_loc3_ && param1 == "RShoulder")
               {
                  if(this.ComponentToggleButton.ButtonVisible)
                  {
                     this.ToggleComponentViewMode();
                  }
                  else if(this.m_KeyringView)
                  {
                     this.onKeyringButtonPress();
                     _loc3_ = true;
                  }
               }
               if(param1 == "L3")
               {
                  this.onSortPress();
               }
            }
            else if(param1 == "TransferLockItem_Hold")
            {
               if(this.m_LockHoldStartTimeout == -1 && this.LockButton.ButtonVisible && !this.LockButton.ButtonDisabled && this.LockButton.canHold)
               {
                  this.m_LockHoldStartTimeout = setTimeout(this.startItemLockHold,GlobalFunc.HOLD_METER_DELAY);
                  _loc3_ = true;
               }
            }
         }
         return _loc3_;
      }
      
      private function startItemLockHold() : void
      {
         this.m_LockHolding = true;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.m_LockHolding)
         {
            this.LockButton.holdPercent += GlobalFunc.HOLD_METER_TICK_AMOUNT;
            if(this.LockButton.holdPercent >= 1)
            {
               this.onLockButton();
               this.stopItemLockHold();
            }
         }
      }
      
      private function stopItemLockHold() : *
      {
         if(this.m_LockHoldStartTimeout != -1)
         {
            clearTimeout(this.m_LockHoldStartTimeout);
            this.m_LockHoldStartTimeout = -1;
         }
         this.LockButton.holdPercent = 0;
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onSortPress() : *
      {
         BGSExternalInterface.call(this.codeObj,"SortItemList",this);
      }
      
      public function onSortComplete(param1:int) : *
      {
         this._SortSelectionRestoreIndex = param1;
      }
      
      private function InspectRepairItem() : void
      {
         var _loc1_:int = int(this.List_mc.selectedEntry.nodeID);
         BGSExternalInterface.call(this.codeObj,"ExamineItem",_loc1_);
      }
      
      private function DropItem() : void
      {
         if(this.isItemProtected(this.List_mc.selectedEntry))
         {
            return;
         }
         var _loc1_:uint = 0;
         if(m_IsTransferLockingFeatureEnabled && Boolean(this.List_mc.selectedEntry.isTransferLocked))
         {
            GlobalFunc.ShowHUDMessage("$CannotDropLockedItem");
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_CANCEL);
         }
         else if(this.List_mc.selectedEntry.count > this.DROP_ITEM_COUNT_THRESHOLD)
         {
            this.ShowQuantity(this.List_mc.selectedEntry.count);
         }
         else
         {
            _loc1_ = 1;
            BGSExternalInterface.call(this.codeObj,"ItemDrop",this.List_mc.selectedEntry.serverHandleID,_loc1_);
         }
      }
      
      private function onFavButtonPress() : *
      {
         if(this._ComponentViewMode)
         {
            BGSExternalInterface.call(this.codeObj,"ToggleComponentFavorite",this.ComponentList_mc.selectedEntry.formID);
         }
      }
      
      private function onLockButton() : void
      {
         if(this.List_mc.selectedEntry != null)
         {
            BGSExternalInterface.call(this.codeObj,"onItemTransferLockToggle",this.List_mc.selectedEntry.serverHandleID);
         }
         GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_OK);
      }
      
      private function ShowQuantity(param1:uint) : *
      {
         if(!this._ShowingQuantity)
         {
            this._QuantityMenu = CompanionAppMode.isOn ? new MobileQuantityMenu(param1) : new QuantityMenuNEW(param1);
            addEventListener(CompanionAppMode.isOn ? MobileQuantityMenu.QUANTITY_CHANGED : QuantityMenuNEW.QUANTITY_CHANGED,this.onQuantityModified);
            GlobalFunc.SetText(this._QuantityMenu.Header_tf,this._overMaxWeight && this._canDestroyCurrentItem ? "$DESTROY" : "$DROP",false);
            this.List_mc.disableInput_Inspectable = true;
            this.ItemCardScrollable_mc.DisableInput = true;
            stage.focus = this._QuantityMenu;
            this._ShowingQuantity = true;
            this._quantityMenuOnItemID = this.List_mc.selectedEntry.nodeID;
            BGSExternalInterface.call(this.codeObj,"toggleMovementToDirectional",true);
            BGSExternalInterface.call(this.codeObj,"onModalOpen",true);
            addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            dispatchEvent(new Event(PipboyPage.LOWER_PIPBOY_ALLOW_CHANGE,true,true));
            this.ModalFadeRect_mc.addChild(this._QuantityMenu);
            this.SetButtons();
            SetIsDirty();
         }
      }
      
      private function HideQuantity() : *
      {
         if(this._ShowingQuantity)
         {
            this._QuantityMenu = null;
            removeEventListener(CompanionAppMode.isOn ? MobileQuantityMenu.QUANTITY_CHANGED : QuantityMenuNEW.QUANTITY_CHANGED,this.onQuantityModified);
            this.List_mc.disableInput_Inspectable = this._ComponentViewMode;
            this.ItemCardScrollable_mc.DisableInput = this._ComponentViewMode;
            stage.focus = this.List_mc;
            this._ShowingQuantity = false;
            BGSExternalInterface.call(this.codeObj,"onModalOpen",false);
            BGSExternalInterface.call(this.codeObj,"toggleMovementToDirectional",false);
            removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            dispatchEvent(new Event(PipboyPage.LOWER_PIPBOY_ALLOW_CHANGE,true,true));
            while(this.ModalFadeRect_mc.numChildren > 1)
            {
               this.ModalFadeRect_mc.removeChildAt(this.ModalFadeRect_mc.numChildren - 1);
            }
            this.SetButtons();
            SetIsDirty();
         }
      }
      
      private function ToggleComponentViewMode() : *
      {
         this._ComponentViewMode = !this._ComponentViewMode;
         stage.focus = this._ComponentViewMode ? this.ComponentList_mc : this.List_mc;
         if(this._ComponentViewMode)
         {
            this.ComponentList_mc.InvalidateData();
            this.ComponentList_mc.selectedIndex = 0;
         }
         else
         {
            this.List_mc.InvalidateData();
         }
         this.SetButtons();
         SetIsDirty();
         BGSExternalInterface.call(this.codeObj,"onComponentViewToggle",this._ComponentViewMode);
      }
      
      public function onQuantityModified(param1:Event) : *
      {
         BGSExternalInterface.call(this.codeObj,"PlaySound","UIMenuQuantity");
      }
      
      override public function CanSwitchTabs(param1:uint, param2:String = "") : Boolean
      {
         return super.CanSwitchTabs(param1,param2) && !this.ModalFadeRect_mc.visible;
      }
      
      override public function onTabChange() : void
      {
         this.ItemCardScrollable_mc.ItemCard_mc.InfoObj = new Array();
         this.PaperDoll_mc.selectedInfoObj = new Array();
         if(this.m_KeyringView)
         {
            this.ToggleKeyringView();
         }
         this.ItemCardScrollable_mc.ItemCard_mc.onDataChange();
         this.PaperDoll_mc.onDataChange();
         this.ItemCardScrollable_mc.ShouldUpdateItemCardScroll = true;
      }
      
      override public function ProcessRightThumbstickInput(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this._ComponentViewMode)
         {
            if(param1 == 1)
            {
               --this.ComponentOwnersList_mc.scrollPosition;
            }
            else if(param1 == 3)
            {
               this.ComponentOwnersList_mc.scrollPosition += 1;
            }
            _loc2_ = true;
         }
         else
         {
            _loc2_ = this.ItemCardScrollable_mc.ProcessRightThumbstickInput(param1);
         }
         return _loc2_;
      }
      
      private function onKeyringButtonPress() : void
      {
         this.ToggleKeyringView();
      }
      
      private function ToggleKeyringView() : void
      {
         this.m_KeyringView = !this.m_KeyringView;
         GlobalFunc.PlayMenuSound(this.m_KeyringView ? "UIPipBoyKeyringOpen" : "UIPipBoyKeyringClose");
         this.List_mc.entryList = this.m_KeyringView ? this.m_KeysList : this._InventoryList;
         this.List_mc.InvalidateData();
         this.List_mc.selectedIndex = this.m_KeyringView ? 0 : int(this.List_mc.entryList.length - 1);
      }
   }
}

