package
{
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import Shared.QuantityMenuNEW;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class NewPipboy_InvPage extends IPipBoyPage
   {
      
      public static var CheckItemProtectionOnSelectionChange:Boolean = false;
      
      public static const PROVIDER_INVENTORY_DATA:* = 0;
      
      public static const PROVIDER_SELECTION_DATA:* = 1;
      
      public var List_mc:BSScrollingList;
      
      public var ComponentList_mc:BSScrollingList;
      
      public var ComponentOwnersList_mc:BSScrollingList;
      
      public var ItemCardScrollable_mc:ItemCardScrollable;
      
      public var ItemCardScrollableMini_mc:ItemCardScrollable;
      
      public var ModalFadeRect_mc:MovieClip;
      
      public var PaperDoll_mc:NewPaperDoll;
      
      private var m_QuantityMenu:QuantityMenuNEW;
      
      private var m_TransferLockText:String = "$LOCK";
      
      private var m_TransferUnlockText:String = "$UNLOCK";
      
      private var m_IsTransferLockingFeatureEnabled:Boolean = false;
      
      private var m_ComponentViewMode:Boolean = false;
      
      private var m_InventoryList:Array;
      
      private var m_ShowingQuantity:Boolean = false;
      
      private var m_CanDestroyCurrentItem:Boolean = false;
      
      private var m_CanDropCurrentItem:Boolean = false;
      
      public var __iomLoader:Loader;
      
      public var __betterInventoryLoader:Loader;
      
      public function NewPipboy_InvPage()
      {
         super();
         this.List_mc.enableScrollWrap = true;
         this.List_mc.listEntryClass_Inspectable = "PipBoyInvListEntry";
         this.List_mc.numListItems_Inspectable = 9;
         this.List_mc.textOption_Inspectable = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
         this.ComponentList_mc.enableScrollWrap = true;
         this.ComponentList_mc.listEntryClass_Inspectable = "ComponentListEntry";
         this.ComponentList_mc.numListItems_Inspectable = 9;
         this.ComponentList_mc.textOption_Inspectable = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
         this.ComponentOwnersList_mc.listEntryClass_Inspectable = "ComponentOwnerListEntry";
         this.ComponentOwnersList_mc.numListItems_Inspectable = 9;
         this.ComponentOwnersList_mc.textOption_Inspectable = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
         this.ComponentOwnersList_mc.disableInput_Inspectable = true;
         this.ComponentOwnersList_mc.disableSelection_Inspectable = true;
         this.ModalFadeRect_mc.visible = false;
         m_EventPrefix = "INV::";
         this.loadInventOmaticPipboy();
         this.loadBetterInventory();
      }
      
      public function loadInventOmaticPipboy() : *
      {
         try
         {
            this.__iomLoader = new Loader();
            addChild(this.__iomLoader);
            this.__iomLoader.load(new URLRequest("InventOmaticPipboy.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
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
            this.__betterInventoryLoader = new Loader();
            addChild(this.__betterInventoryLoader);
            this.__betterInventoryLoader.load(new URLRequest("BetterInventory.swf"),new LoaderContext(false,ApplicationDomain.currentDomain));
            trace("BetterInventory loaded");
         }
         catch(e:Object)
         {
            trace("Error loading BetterInventory " + e);
         }
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
         if(this.__iomLoader && this.__iomLoader.content && this.__iomLoader.content.isItemProtected(item))
         {
            return true;
         }
         return false;
      }
      
      public function isItemEquipProtected(item:Object) : Boolean
      {
         if(this.__iomLoader && this.__iomLoader.content && this.__iomLoader.content.isItemEquipProtected(item))
         {
            return true;
         }
         return false;
      }
      
      override public function OnEntry() : void
      {
         if(Boolean(PageData) && Boolean(PageData.InventoryA))
         {
            this.List_mc.entryList = PageData.InventoryA;
            this.List_mc.InvalidateData();
         }
         stage.focus = this.m_ShowingQuantity ? this.m_QuantityMenu : (this.m_ComponentViewMode ? this.ComponentList_mc : this.List_mc);
      }
      
      override public function processProvider(aData:Object, aType:uint = 0) : void
      {
         var selectedIndex:uint = 0;
         if(aData.AutoScrollItemCard)
         {
            this.ItemCardScrollable_mc.AllowAutoScroll = aData.AutoScrollItemCard;
            this.ItemCardScrollableMini_mc.AllowAutoScroll = aData.AutoScrollItemCard;
         }
         switch(aType)
         {
            case PROVIDER_INVENTORY_DATA:
               PageData = aData;
               this.m_InventoryList = aData.InventoryA;
               this.List_mc.entryList = this.m_InventoryList;
               this.List_mc.InvalidateData();
               stage.focus = this.m_ShowingQuantity ? this.m_QuantityMenu : (this.m_ComponentViewMode ? this.ComponentList_mc : this.List_mc);
               selectedIndex = Math.max(this.List_mc.selectedIndex,0);
               this.m_InventoryList.forEach(function(item:Object, index:int, array:Array):void
               {
                  if(Boolean(item) && item.ItemHandle == aData.SelectedHandle)
                  {
                     selectedIndex = index;
                  }
               });
               if(this.m_InventoryList.length <= 0)
               {
                  BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_SELECTION_CHANGE,{"ID":uint.MAX_VALUE}));
               }
               else if(selectedIndex != this.List_mc.selectedIndex)
               {
                  this.List_mc.selectedIndex = selectedIndex;
               }
               else if(selectedIndex < this.m_InventoryList.length)
               {
                  SelectedID = this.m_InventoryList[selectedIndex].ItemHandle;
                  BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_SELECTION_CHANGE,{"ID":SelectedID}));
               }
               this.ComponentList_mc.entryList = aData.ComponentsA.sortOn("text");
               this.ComponentList_mc.visible = this.m_ComponentViewMode;
               stage.dispatchEvent(new CustomEvent("IOMPipboyINVChange",{"InventoryA":aData.InventoryA}));
               break;
            case PROVIDER_SELECTION_DATA:
               this.PaperDoll_mc.underwearType = aData.PaperDoll.UnderwearType;
               this.PaperDoll_mc.slotResists = aData.PaperDoll.SlotResistancesA;
               this.PaperDoll_mc.slots = aData.PaperDoll.SlotsAnimatedA ? aData.PaperDoll.SlotsAnimatedA : new Array();
               this.PaperDoll_mc.onDataChange();
               if(this.PaperDoll_mc.slots.length > 0)
               {
                  trace("mini");
                  this.ItemCardScrollable_mc.visible = false;
                  this.ItemCardScrollableMini_mc.visible = true;
                  this.ItemCardScrollableMini_mc.ShouldUpdateItemCardScroll = true;
                  this.ItemCardScrollableMini_mc.ItemCard_mc.InfoObj = aData.ItemDetails.InfoCardData ? aData.ItemDetails.InfoCardData : new Array();
                  this.ItemCardScrollableMini_mc.ItemCard_mc.onDataChange();
               }
               else
               {
                  trace("large");
                  this.ItemCardScrollable_mc.visible = true;
                  this.ItemCardScrollableMini_mc.visible = false;
                  this.ItemCardScrollable_mc.ShouldUpdateItemCardScroll = true;
                  this.ItemCardScrollable_mc.ItemCard_mc.InfoObj = aData.ItemDetails.InfoCardData ? aData.ItemDetails.InfoCardData : new Array();
                  this.ItemCardScrollable_mc.ItemCard_mc.onDataChange();
               }
         }
      }
      
      override public function onAddedToStage(aEvent:Event) : void
      {
         this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
         this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
         this.ComponentList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onComponentListSelectionChange);
         this.ComponentList_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
      }
      
      override public function SetVisibility(aVisible:Boolean) : void
      {
         this.ItemCardScrollable_mc.DisableInput = !aVisible;
         this.ItemCardScrollableMini_mc.DisableInput = !aVisible;
         super.SetVisibility(aVisible);
      }
      
      private function onListSelectionChange(aEvent:Event) : void
      {
         if(this.List_mc.selectedEntry)
         {
            this.m_CanDestroyCurrentItem = this.List_mc.selectedEntry.canDestroy;
            this.m_CanDropCurrentItem = Boolean(this.List_mc.selectedEntry.canDrop) && !this.isItemProtected(this.List_mc.selectedEntry,true);
            SelectedID = this.List_mc.selectedEntry.ItemHandle;
            BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_SELECTION_CHANGE,{"ID":SelectedID}));
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_FOCUS_CHANGE);
            this.ItemCardScrollableMini_mc.visible = !this.m_ComponentViewMode && this.PaperDoll_mc.slots.length > 0;
            this.ItemCardScrollable_mc.visible = !this.ItemCardScrollableMini_mc.visible && !this.m_ComponentViewMode;
         }
         else
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_SELECTION_CHANGE,{"ID":uint.MAX_VALUE}));
            this.ItemCardScrollable_mc.visible = false;
         }
      }
      
      private function onItemPressed(aEvent:Event) : void
      {
         this.selectItem();
      }
      
      private function selectItem() : void
      {
         if(this.m_ComponentViewMode && Boolean(this.ComponentList_mc.selectedEntry))
         {
            BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_TAG_SEARCH,{"ID":this.ComponentList_mc.selectedEntry.componentFormID}));
         }
         else if(this.List_mc.selectedEntry && !this.List_mc.selectedEntry.isKeyring && !this.m_ShowingQuantity)
         {
            SelectedID = this.List_mc.selectedEntry.ItemHandle;
            if(!this.isItemEquipProtected(this.List_mc.selectedEntry))
            {
               BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_USE_ITEM,{"ID":SelectedID}));
            }
         }
      }
      
      private function toggleComponentViewMode() : *
      {
         this.m_ComponentViewMode = !this.m_ComponentViewMode;
         stage.focus = this.m_ComponentViewMode ? this.ComponentList_mc : this.List_mc;
         this.ItemCardScrollable_mc.visible = !this.m_ComponentViewMode;
         this.ItemCardScrollable_mc.DisableInput = this.m_ComponentViewMode;
         this.ComponentList_mc.visible = this.m_ComponentViewMode;
         this.ComponentList_mc.disableInput_Inspectable = !this.m_ComponentViewMode;
         this.ComponentOwnersList_mc.visible = this.m_ComponentViewMode;
         this.List_mc.visible = !this.m_ComponentViewMode;
         this.List_mc.disableInput_Inspectable = this.m_ComponentViewMode;
         if(this.m_ComponentViewMode)
         {
            this.ComponentList_mc.InvalidateData();
            this.ComponentList_mc.selectedIndex = 0;
         }
         else
         {
            this.List_mc.InvalidateData();
         }
         BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_TOGGLE_COMPONENT_VIEW,{"componentView":this.m_ComponentViewMode}));
      }
      
      private function onComponentListSelectionChange(aEvent:Event) : void
      {
         if(this.ComponentList_mc.selectedEntry)
         {
            this.ComponentOwnersList_mc.entryList = this.ComponentList_mc.selectedEntry.componentOwners;
            this.ComponentOwnersList_mc.entryList.sortOn("text");
            GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_FOCUS_CHANGE);
         }
         else
         {
            this.ComponentOwnersList_mc.entryList = null;
         }
         this.ComponentOwnersList_mc.InvalidateData();
      }
      
      private function showQuantity(aCount:uint) : *
      {
         var weightData:Object = null;
         var overWeight:* = false;
         if(!this.m_ShowingQuantity)
         {
            this.m_QuantityMenu = new QuantityMenuNEW(aCount);
            addEventListener(QuantityMenuNEW.QUANTITY_CHANGED,this.onQuantityModified);
            weightData = BSUIDataManager.GetDataFromClient("PipBoyINVFooterProvider").data;
            overWeight = weightData.CurrentWeight >= weightData.AbsoluteWeightLimit;
            this.m_QuantityMenu.Header_tf.text = overWeight && this.m_CanDestroyCurrentItem ? "$DESTROY" : "$DROP";
            this.List_mc.disableInput_Inspectable = true;
            this.ComponentList_mc.disableInput_Inspectable = true;
            this.ItemCardScrollable_mc.DisableInput = true;
            stage.focus = this.m_QuantityMenu;
            this.m_ShowingQuantity = true;
            this.List_mc.removeEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
            this.ComponentList_mc.removeEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
            BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_TOGGLE_QUANTITY_MODAL,{"modalView":this.m_ShowingQuantity}));
            this.ModalFadeRect_mc.addChild(this.m_QuantityMenu);
            this.ModalFadeRect_mc.visible = true;
         }
      }
      
      private function hideQuantity() : *
      {
         if(this.m_ShowingQuantity)
         {
            this.m_QuantityMenu = null;
            removeEventListener(QuantityMenuNEW.QUANTITY_CHANGED,this.onQuantityModified);
            this.List_mc.disableInput_Inspectable = this.m_ComponentViewMode;
            this.ComponentList_mc.disableInput_Inspectable = this.m_ComponentViewMode;
            this.ItemCardScrollable_mc.DisableInput = this.m_ComponentViewMode;
            stage.focus = null;
            this.m_ShowingQuantity = false;
            this.List_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
            this.ComponentList_mc.addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
            BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_TOGGLE_QUANTITY_MODAL,{"modalView":this.m_ShowingQuantity}));
            while(this.ModalFadeRect_mc.numChildren > 1)
            {
               this.ModalFadeRect_mc.removeChildAt(this.ModalFadeRect_mc.numChildren - 1);
            }
            this.ModalFadeRect_mc.visible = false;
         }
      }
      
      private function onQuantityModified(aEvent:Event) : *
      {
         GlobalFunc.PlayMenuSound("UIMenuQuantity");
      }
      
      override public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean, auiController:uint, auiKeyboard:uint) : void
      {
         this.List_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
         this.ComponentList_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
         this.ComponentOwnersList_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
      }
      
      override public function ProcessRightThumbstickInput(auiDirection:uint) : Boolean
      {
         if(Boolean(this.ItemCardScrollable_mc) && this.ItemCardScrollable_mc.visible)
         {
            this.ItemCardScrollable_mc.ProcessRightThumbstickInput(auiDirection);
         }
         else if(Boolean(this.ItemCardScrollableMini_mc) && this.ItemCardScrollableMini_mc.visible)
         {
            this.ItemCardScrollableMini_mc.ProcessRightThumbstickInput(auiDirection);
         }
         return true;
      }
      
      override public function ProcessUserEvent(strEventName:String) : Boolean
      {
         var bhandled:* = this.__betterInventoryLoader.content;
         if(bhandled)
         {
            if(bhandled.ProcessUserEvent(strEventName,abPressed))
            {
               return true;
            }
         }
         bhandled = false;
         var convertedString:String = null;
         if(this.m_ShowingQuantity)
         {
            convertedString = strEventName;
            if(strEventName == "MoveCamp")
            {
               convertedString = "LShoulder";
            }
            else if(strEventName == "ShowOnMap")
            {
               convertedString = "RShoulder";
            }
            bhandled = this.m_QuantityMenu.ProcessUserEvent(convertedString,false);
         }
         if(!bhandled)
         {
            switch(strEventName)
            {
               case "Accept":
                  if(this.m_ShowingQuantity)
                  {
                     if(!this.isItemProtected(this.List_mc.selectedEntry))
                     {
                        BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_DROP_ITEM,{
                           "ID":SelectedID,
                           "count":this.m_QuantityMenu.count
                        }));
                     }
                     this.hideQuantity();
                  }
                  bhandled = true;
                  break;
               case "Drop":
                  if(!this.m_ComponentViewMode && this.List_mc.selectedEntry && (this.m_CanDestroyCurrentItem || this.m_CanDropCurrentItem))
                  {
                     if(!this.isItemProtected(this.List_mc.selectedEntry))
                     {
                        if(this.List_mc.selectedEntry.IsTransferLocked)
                        {
                           GlobalFunc.ShowHUDMessage("$CannotDropLockedItem");
                           GlobalFunc.PlayMenuSound(GlobalFunc.MENU_SOUND_CANCEL);
                        }
                        else if(this.List_mc.selectedEntry.Count > 1)
                        {
                           this.showQuantity(this.List_mc.selectedEntry.Count);
                        }
                        else
                        {
                           BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_DROP_ITEM,{
                              "ID":SelectedID,
                              "count":1
                           }));
                        }
                     }
                     bhandled = true;
                  }
                  break;
               case "ShowOnMap":
                  if(CurrentTabIndex == NewPipBoyShared.INV_TAB_JUNK)
                  {
                     this.toggleComponentViewMode();
                     bhandled = true;
                  }
                  else
                  {
                     BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_FAV_ITEM,{"ID":SelectedID}));
                  }
                  break;
               case "TransferLockItem_Press":
                  BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_LOCK_ITEM,{"ID":SelectedID}));
                  break;
               case "CloseMenu":
                  if(this.m_ShowingQuantity)
                  {
                     this.hideQuantity();
                  }
                  if(stage.focus == null)
                  {
                     stage.focus = this.m_ComponentViewMode ? this.ComponentList_mc : this.List_mc;
                  }
                  break;
               case "Inspect":
                  BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.INV_INSPECT_ITEM,{"ID":SelectedID}));
            }
         }
         return bhandled;
      }
   }
}

