package
{
   import Shared.*;
   import Shared.AS3.*;
   import Shared.AS3.Data.*;
   import Shared.AS3.Events.*;
   import com.adobe.serialization.json.*;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   import utils.*;
   
   public class ItemWorker
   {
      
      public static var characterName:String;
      
      public static var accountName:String;
      
      public static var DelayCloseMenu:uint = 500;
      
      public static var DelayTabSwitching:uint = 250;
      
      public static var EFFECTS_TAB_ID:uint = 2;
      
      public static var OverrideCancelCloseMenu:Boolean = false;
      
      public static var OverrideTestRun:Boolean = false;
      
      public var parent:MovieClip;
      
      public var iomPip:MovieClip;
      
      public var activeEffects:Array;
      
      public var consumeQueueId:int;
      
      public var consumeQueue:Array;
      
      public var itemCardMap:* = null;
      
      public var PlayerInventoryData:* = null;
      
      public var IsTradableMap:* = {};
      
      public var ConditionMap:* = {};
      
      public var inventory:Array = [];
      
      public var lastSelectedTabId:int = 0;
      
      public var queuedTabs:Array = [];
      
      public function ItemWorker(parent:Object, iomp:Object)
      {
         super();
         this.parent = parent;
         this.iomPip = iomp;
         this.PlayerInventoryData = BSUIDataManager.GetDataFromClient("PlayerInventoryData").data;
         try
         {
            EFFECTS_TAB_ID = getDefinitionByName("NewPipBoyShared").STATS_TAB_EFFECTS;
         }
         catch(e:*)
         {
            this.iomPip.ShowHUDMessage("ERROR: NewPipBoyShared class not found! " + e,true);
         }
      }
      
      private static function isTestRun(configValue:Boolean) : Boolean
      {
         if(OverrideTestRun)
         {
            var overrideMode:String = config.testRunOverride.overrideMode;
            switch(overrideMode)
            {
               case TestrunOverrideMode.FORCE_ON:
                  return true;
               case TestrunOverrideMode.FORCE_OFF:
                  return false;
               case TestrunOverrideMode.INVERT:
                  return !configValue;
               default:
                  Logger.get().error("Invalid testRun overrideMode: " + overrideMode);
            }
         }
         return configValue;
      }
      
      public static function get AccountName() : String
      {
         if(!accountName)
         {
            accountName = getAccountName();
         }
         return accountName;
      }
      
      public static function get CharacterName() : String
      {
         if(!characterName)
         {
            characterName = getCharacterName();
         }
         return characterName;
      }
      
      public static function isItemMatchingConfig(item:Object, itemConfig:String, matchMode:String) : Boolean
      {
         if(matchMode === MatchMode.ALL)
         {
            return true;
         }
         var itemText:String = String(item.Name);
         if(itemText == null || !itemText.length)
         {
            return false;
         }
         if(itemConfig == null || !itemConfig.length)
         {
            return false;
         }
         var matches:Boolean = false;
         if(matchMode === MatchMode.EXACT)
         {
            matches = itemText === itemConfig;
         }
         else if(matchMode === MatchMode.CONTAINS)
         {
            matches = itemText.toLowerCase().indexOf(itemConfig.toLowerCase()) >= 0;
         }
         else if(matchMode === MatchMode.STARTS)
         {
            matches = itemText.toLowerCase().indexOf(itemConfig.toLowerCase()) === 0;
         }
         return matches;
      }
      
      public static function getCharacterName() : String
      {
         try
         {
            return BSUIDataManager.GetDataFromClient("CharacterInfoData").data.name;
         }
         catch(e:Error)
         {
            Logger.get().error("Error loading character data " + e);
         }
         return null;
      }
      
      public static function getAccountName() : String
      {
         try
         {
            return BSUIDataManager.GetDataFromClient("AccountInfoData").data.name;
         }
         catch(e:Error)
         {
            Logger.get().error("Error loading account data " + e);
         }
         return null;
      }
      
      public static function isMatchingConfigSection(e:KeyboardEvent, sectionConfig:Object) : Boolean
      {
         return e.keyCode === sectionConfig.hotkey && Boolean(sectionConfig.enabled) && Boolean(isTheSameCharacterName(sectionConfig));
      }
      
      public static function isConfigEnabled(config:Object, configName:String) : Boolean
      {
         return Boolean(config[configName]) && Boolean(config[configName].enabled) && Boolean(config[configName].configs) && config[configName].configs.length > 0;
      }
      
      public static function isTheSameCharacterName(sectionConfig:Object) : Boolean
      {
         if(sectionConfig.checkAccountName)
         {
            var configAccountNames:Array = [].concat(sectionConfig.accountName);
            if(configAccountNames.indexOf(AccountName) == -1)
            {
               Logger.get().error("Account name not matching in config: " + AccountName + " != " + sectionConfig.accountName);
               return false;
            }
         }
         if(sectionConfig.checkCharacterName)
         {
            var configCharacterNames:Array = [].concat(sectionConfig.characterName);
            if(configCharacterNames.indexOf(CharacterName) == -1)
            {
               Logger.get().error("Character name not matching in config: " + CharacterName + " != " + sectionConfig.characterName);
               return false;
            }
         }
         return true;
      }
      
      public static function get config() : Object
      {
         return InventOmaticConfig.get();
      }
      
      private static function isIgnoreItemName(itemName:String, ignoreItemNames:Array) : Boolean
      {
         if(!ignoreItemNames || ignoreItemNames.length == 0)
         {
            return false;
         }
         var i:uint = 0;
         var lowercaseName:String = itemName.toLowerCase();
         var len:uint = ignoreItemNames.length;
         i = 0;
         while(i < len)
         {
            var element:* = ignoreItemNames[i];
            if(element is String && element.length && lowercaseName.indexOf(element.toLowerCase()) != -1)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function isInvalidCondition(item:Object, sectionConfig:Object, dflt:Boolean = true) : *
      {
         var conditionMapItemData:* = ConditionMap[item.Name];
         if(Boolean(sectionConfig.conditionUnder) && conditionMapItemData != null && conditionMapItemData >= 0)
         {
            var cndUnder:Number = Number(sectionConfig.conditionUnder);
            if(!isNaN(cndUnder) && cndUnder > conditionMapItemData * 100)
            {
               return true;
            }
            return false;
         }
         return dflt;
      }
      
      public function mapPlayerInventory() : void
      {
         var i:int;
         var item:*;
         try
         {
            if(this.PlayerInventoryData != null && this.PlayerInventoryData.InventoryList != null)
            {
               i = 0;
               while(i < this.PlayerInventoryData.InventoryList.length)
               {
                  item = this.PlayerInventoryData.InventoryList[i];
                  IsTradableMap[item.text] = item.isTradable;
                  ConditionMap[item.text] = item.maximumHealth != uint.MAX_VALUE ? item.currentHealth / item.maximumHealth : -1;
                  i++;
               }
               Logger.get().info("PlayerInv mapped!");
            }
            else
            {
               Logger.get().error("PlayerInv not mapped, empty InvList!");
            }
         }
         catch(e:*)
         {
            Logger.get().error("Error mapping PlayerInv: " + e);
         }
      }
      
      public function isMatchingType(item:Object, types:Array) : Boolean
      {
         var matchingFilterFlags:Array = [];
         var i:int = 0;
         try
         {
            if(!types || types.length == 0 || item.filterFlag == null)
            {
               return false;
            }
            while(i < types.length)
            {
               matchingFilterFlags = matchingFilterFlags.concat(ItemTypes.ITEM_TYPES[types[i]]);
               i++;
            }
            return matchingFilterFlags.some(function(flag:int):Boolean
            {
               return item.filterFlag & flag;
            });
         }
         catch(e:Error)
         {
            Logger.get().error("Error checking type " + e);
         }
         return false;
      }
      
      public function isActiveEffect(itemNames:Array, matchMode:String) : Boolean
      {
         if(matchMode == null)
         {
            matchMode = MatchMode.CONTAINS;
         }
         var e:int = 0;
         var i:int = 0;
         if(matchMode == MatchMode.EXACT)
         {
            while(e < this.activeEffects.length)
            {
               var effectName:String = this.activeEffects[e].Name;
               i = 0;
               while(i < itemNames.length)
               {
                  if(effectName == itemNames[i])
                  {
                     return true;
                  }
                  i++;
               }
               e++;
            }
         }
         else
         {
            while(e < this.activeEffects.length)
            {
               effectName = this.activeEffects[e].Name.toLowerCase();
               i = 0;
               while(i < itemNames.length)
               {
                  var itemName:String = itemNames[i].toLowerCase();
                  if(effectName.indexOf(itemName) != -1)
                  {
                     return true;
                  }
                  i++;
               }
               e++;
            }
         }
         return false;
      }
      
      public function isValidEquipStatus(item:Object, sectionConfig:Object) : Boolean
      {
         if(Boolean(sectionConfig.onlyIfNotEquipped))
         {
            return item.EquipState == 0;
         }
         if(Boolean(sectionConfig.onlyIfEquipped))
         {
            return item.EquipState == 1;
         }
         return true;
      }
      
      private function findMatches(sectionConfig:Object) : Array
      {
         var index:int = 0;
         var indexNames:int = 0;
         var indexNamesAlts:int = 0;
         var item:Object = null;
         var listMc:Array = this.inventory;
         var newMatches:Array = new Array(sectionConfig.itemNames.length);
         while(indexNames < sectionConfig.itemNames.length)
         {
            indexNamesAlts = 0;
            newMatches[indexNames] = new Array(sectionConfig.itemNames[indexNames].length);
            while(indexNamesAlts < sectionConfig.itemNames[indexNames].length)
            {
               newMatches[indexNames][indexNamesAlts] = new Array();
               indexNamesAlts++;
            }
            indexNames++;
         }
         index = 0;
         while(index < listMc.length)
         {
            item = listMc[index];
            if(isValidEquipStatus(item,sectionConfig))
            {
               indexNames = 0;
               while(indexNames < sectionConfig.itemNames.length)
               {
                  indexNamesAlts = 0;
                  while(indexNamesAlts < sectionConfig.itemNames[indexNames].length)
                  {
                     if(isItemMatchingConfig(item,sectionConfig.itemNames[indexNames][indexNamesAlts],sectionConfig.matchMode) && isMatchingType(item,sectionConfig.types))
                     {
                        newMatches[indexNames][indexNamesAlts].push({
                           "ItemHandle":item.ItemHandle,
                           "Name":item.Name
                        });
                     }
                     indexNamesAlts++;
                  }
                  indexNames++;
               }
            }
            index++;
         }
         return newMatches;
      }
      
      private function filterActiveEffects(matches:Array, sectionConfig:Object) : Array
      {
         var index:int = 0;
         var indexNames:int = 0;
         var indexNamesAlts:int = 0;
         var filtered:Array = [];
         var onlyInactiveEffects:Boolean = Boolean(sectionConfig.onlyInactiveEffects);
         while(indexNames < matches.length)
         {
            if(onlyInactiveEffects && isActiveEffect(sectionConfig.itemNames[indexNames],sectionConfig.matchModeEffects))
            {
               Logger.get().info("Active effect: not using " + sectionConfig.itemNames[indexNames]);
            }
            else
            {
               if(matches[indexNames].length == 0)
               {
                  Logger.get().error("No itemNames specified for index: " + indexNames);
               }
               indexNamesAlts = 0;
               while(indexNamesAlts < matches[indexNames].length)
               {
                  if(matches[indexNames][indexNamesAlts].length != 0)
                  {
                     Logger.get().info("Queued: " + matches[indexNames][indexNamesAlts][0].Name);
                     filtered.push(matches[indexNames][indexNamesAlts][0]);
                     break;
                  }
                  Logger.get().info("No items matching: " + sectionConfig.itemNames[indexNames][indexNamesAlts]);
                  indexNamesAlts++;
               }
            }
            indexNames++;
         }
         return filtered;
      }
      
      private function updateNodeID(item:Object) : void
      {
         for each(var entry in parent.List_mc.entryList)
         {
            if(entry.serverHandleID == item.serverHandleID && entry.nodeID != item.nodeID)
            {
               Logger.get().info("nodeID updated for " + item.text + ": " + item.nodeID + " -> " + entry.nodeID);
               item.nodeID = entry.nodeID;
               break;
            }
         }
      }
      
      private function getAmmoType(itemCardEntries:Array) : int
      {
         for each(entry in itemCardEntries)
         {
            if(entry.damageType == 10)
            {
               return entry.value;
            }
         }
         return -1;
      }
      
      private function isRangedWeapon(itemCardEntries:Array) : Boolean
      {
         for each(entry in itemCardEntries)
         {
            if(entry.text == "$speed")
            {
               return false;
            }
            if(entry.text == "$ROF")
            {
               if(entry.value > 0)
               {
                  return true;
               }
            }
            else if(entry.text == "$rng")
            {
               if(entry.value > 0)
               {
                  return true;
               }
            }
            else if(entry.text == "$CAPACITY")
            {
               if(entry.value > 0)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function getUsedAmmoMap() : *
      {
         var item:Object = null;
         var usedAmmoMap:* = {};
         if(!itemCardMap || this.iomPip.isNewTab)
         {
            Logger.get().error("Ammo map not created: " + (!itemCardMap ? "ItemCardMap empty" : "Disabled in NEW tab"));
            return null;
         }
         var listMc:Array = parent.List_mc.entryList;
         var i:int = 0;
         while(i < listMc.length)
         {
            item = listMc[i];
            if(item.filterFlag & 4 && itemCardMap[item.serverHandleID] != null && isRangedWeapon(itemCardMap[item.serverHandleID]))
            {
               var ammoTypeCnt:int = getAmmoType(itemCardMap[item.serverHandleID]);
               if(ammoTypeCnt != -1)
               {
                  usedAmmoMap[ammoTypeCnt] = true;
               }
            }
            i++;
         }
         return usedAmmoMap;
      }
      
      public function buildInventory(configs:Array) : int
      {
         var types:Array;
         var configTypes:Array;
         var unique:*;
         var i:int;
         var j:int;
         var tabs:Array;
         var isSameTab:Boolean;
         try
         {
            this.mapPlayerInventory();
            types = [];
            unique = {};
            i = 0;
            while(i < configs.length)
            {
               configTypes = configs[i].types;
               if(configTypes && configTypes.length > 0)
               {
                  j = 0;
                  while(j < configTypes.length)
                  {
                     if(ItemTypes.ITEM_TYPES[configTypes[j]] != null && !unique[configTypes[j]])
                     {
                        types = types.concat(configTypes[j]);
                        unique[configTypes[j]] = true;
                     }
                     j++;
                  }
               }
               i++;
            }
            tabs = types.map(function(type:String):uint
            {
               return PipboyTabs.PIPBOY_TABS[type];
            });
            Logger.get().info("Building inventory for types: " + types.join(", ") + " - tabs: " + tabs.join(", "));
            this.inventory = [];
            this.queuedTabs = tabs;
            isSameTab = false;
            if(this.queuedTabs.length)
            {
               this.lastSelectedTabId = this.parent.CurrentTabIndex;
               if(this.lastSelectedTabId == this.queuedTabs[0])
               {
                  isSameTab = true;
                  this.lastSelectedTabId = -1;
                  this.appendTabInventory(BSUIDataManager.GetDataFromClient("PipBoyINVProvider"));
               }
               else
               {
                  this.setTab(this.queuedTabs[0]);
               }
               i = 1;
               while(i < this.queuedTabs.length)
               {
                  setTimeout(this.setTab,DelayTabSwitching * i,this.queuedTabs[i]);
                  i++;
               }
               setTimeout(function():void
               {
                  queuedTabs = [];
               },DelayTabSwitching * (this.queuedTabs.length + 1));
            }
            return DelayTabSwitching * (isSameTab && this.queuedTabs.length == 1 ? 0 : this.queuedTabs.length + 1);
         }
         catch(e:*)
         {
            Logger.get().error("Building inventory failed: " + e);
         }
         return -1;
      }
      
      public function appendTabInventory(event:*) : void
      {
         var newFilterFlag:uint;
         var newItems:Array;
         try
         {
            if(this.queuedTabs.length)
            {
               if(this.lastSelectedTabId != this.parent.CurrentTabIndex)
               {
                  Logger.get().info("Tab changed: " + this.lastSelectedTabId + " -> " + this.parent.CurrentTabIndex);
                  this.lastSelectedTabId = this.parent.CurrentTabIndex;
                  newFilterFlag = uint(ItemTypes.ITEM_TYPES[PipboyTabs.PIPBOY_TAB_IDS[this.parent.CurrentTabIndex]][0]);
                  newItems = GlobalFunc.CloneObject(event is CustomEvent ? event.params.InventoryA : event.data.InventoryA);
                  newItems.forEach(function(item:Object):void
                  {
                     item.filterFlag = newFilterFlag;
                  });
                  this.inventory = this.inventory.concat(newItems);
                  Logger.get().info("Appending inv for tab " + this.lastSelectedTabId + " : " + PipboyTabs.PIPBOY_TAB_IDS[this.parent.CurrentTabIndex] + ", filterFlag: " + newFilterFlag);
                  Logger.get().info("Inv size: " + this.inventory.length + ", added: " + newItems.length);
               }
            }
         }
         catch(e:*)
         {
            Logger.get().error("appendTabInventory failed: " + e);
         }
      }
      
      public function openEffectsTab() : int
      {
         try
         {
            this.setPage(1);
            setTimeout(this.setTab,DelayTabSwitching,EFFECTS_TAB_ID);
            setTimeout(this.setPage,DelayTabSwitching * 2,2);
            return DelayTabSwitching * 4;
         }
         catch(e:*)
         {
            Logger.get().error("openEffectsTab failed: " + e);
         }
         return -1;
      }
      
      public function updateEffects(event:*) : void
      {
         try
         {
            this.activeEffects = GlobalFunc.CloneObject(event.params.EffectsA);
            Logger.get().info("Effects updated (" + this.activeEffects.length + "): " + this.activeEffects.map(function(item:*):String
            {
               return item.Name;
            }).join(", "));
         }
         catch(e:*)
         {
            Logger.get().error("updateEffects failed: " + e);
         }
      }
      
      public function consumeItemsCallback(sectionConfig:Object, delayModifier:int = 0) : *
      {
         var delay:int;
         var filtered:Array;
         var index:int;
         var testRun:Boolean;
         var errorMessage:String = "init";
         try
         {
            testRun = isTestRun(sectionConfig.testRun);
            index = 0;
            errorMessage = "activeEffects";
            if(sectionConfig.onlyInactiveEffects && !this.activeEffects)
            {
               Logger.get().error("Active effects not found!");
               this.iomPip.ShowHUDMessage("ERROR: Active effects not found!",true);
               return 0;
            }
            filtered = this.filterActiveEffects(this.findMatches(sectionConfig),sectionConfig);
            errorMessage = "filteredItems";
            if(testRun)
            {
               Logger.get().debugMode = true;
               Logger.get().info(sectionConfig.name + " TEST RUN START");
            }
            setTimeout(function():void
            {
               errorMessage = "setTimeout";
               consumeQueueId = 0;
               consumeQueue = filtered;
               delay = sectionConfig.delay;
               errorMessage = "delayParsed";
               if(delay > 0)
               {
                  errorMessage = "delay > 0";
                  while(index < consumeQueue.length)
                  {
                     setTimeout(function():void
                     {
                        Logger.get().info("Using: " + consumeQueue[consumeQueueId].Name);
                        if(!testRun)
                        {
                           consumeItem(consumeQueue[consumeQueueId].ItemHandle);
                        }
                        ++consumeQueueId;
                        if(testRun && consumeQueueId == consumeQueue.length)
                        {
                           Logger.get().info("If you\'re satisfied with result, set testRun to false in config file for: " + sectionConfig.name);
                           Logger.get().info("Scroll wheel is enabled in this window if text is off-screen");
                           Logger.get().info(sectionConfig.name + " TEST RUN FINISHED");
                        }
                     },index * delay);
                     ++index;
                  }
                  errorMessage = "exit menu";
                  if(sectionConfig.closeMenu && !OverrideCancelCloseMenu)
                  {
                     setTimeout(exitMenu,index * delay + DelayCloseMenu);
                  }
                  errorMessage = "delay > 0 while";
                  if(consumeQueue.length == 0 && testRun)
                  {
                     Logger.get().info("If you\'re satisfied with result, set testRun to false in config file for: " + sectionConfig.name);
                     Logger.get().info("Scroll wheel is enabled in this window if text is off-screen");
                     Logger.get().info(sectionConfig.name + " TEST RUN FINISHED");
                  }
               }
               else
               {
                  errorMessage = "delay = 0";
                  while(index < consumeQueue.length)
                  {
                     Logger.get().info("Using: " + consumeQueue[index].Name);
                     if(!testRun)
                     {
                        consumeItem(consumeQueue[index].ItemHandle);
                     }
                     ++index;
                  }
                  errorMessage = "delay = 0 while";
                  if(testRun && index == consumeQueue.length)
                  {
                     Logger.get().info("If you\'re satisfied with result, set testRun to false in config file for: " + sectionConfig.name);
                     Logger.get().info("Scroll wheel is enabled in this window if text is off-screen");
                     Logger.get().info(name + " TEST RUN FINISHED");
                  }
               }
            },delayModifier);
            return filtered.length;
         }
         catch(e:Error)
         {
            Logger.get().error("consumeItemsCallback " + (sectionConfig != null ? sectionConfig.name : "null") + " : " + errorMessage + " : " + e);
         }
         return 0;
      }
      
      public function dropItemsCallback(sectionConfig:Object, delayModifier:int = 0) : *
      {
         var item:Object;
         var amount:int;
         var listMc:Array;
         var index:int;
         var delay:int;
         var droppedItems:int;
         var itemNameIndex:int;
         var configItemName:String;
         var dropQueueId:int;
         var dropQueue:Array;
         var testRun:Boolean;
         try
         {
            dropQueueId = 0;
            dropQueue = [];
            droppedItems = 0;
            itemNameIndex = 0;
            listMc = this.inventory;
            delay = int(sectionConfig.delay);
            testRun = isTestRun(sectionConfig.testRun);
            if(testRun)
            {
               Logger.get().debugMode = true;
               Logger.get().info(sectionConfig.name + " TEST RUN START");
            }
            while(itemNameIndex < sectionConfig.itemNames.length)
            {
               configItemName = sectionConfig.itemNames[itemNameIndex];
               item = null;
               amount = 0;
               index = 0;
               while(index < listMc.length)
               {
                  item = listMc[index];
                  if(item.IsTransferLocked)
                  {
                     index++;
                  }
                  else if(item.IsFavorited && !sectionConfig.dropFavorite)
                  {
                     index++;
                  }
                  else if(item.EquipState == 1 && !sectionConfig.dropEquipped)
                  {
                     index++;
                  }
                  else if(item.isLegendary && !sectionConfig.dropLegendaries)
                  {
                     index++;
                  }
                  else if(item.hasUniqueEffect && !sectionConfig.dropUniques)
                  {
                     index++;
                  }
                  else if(IsTradableMap[item.Name.replace("$$Known ","")] === false && !sectionConfig.dropNonTradable)
                  {
                     index++;
                  }
                  else if(item.IsTaggedForSearch && !sectionConfig.dropTaggedForSearch)
                  {
                     index++;
                  }
                  else if(!isMatchingType(item,sectionConfig.types))
                  {
                     index++;
                  }
                  else if(isItemMatchingConfig(item,configItemName,sectionConfig.matchMode) && !isIgnoreItemName(item,sectionConfig.ignoreItemNames))
                  {
                     amount = int(sectionConfig.amount);
                     if(!amount || isNaN(amount) || amount == 0 || amount >= item.Count)
                     {
                        amount = int(item.Count);
                     }
                     else if(amount < 0)
                     {
                        if(item.Count > -amount)
                        {
                           amount = item.Count + amount;
                        }
                        else
                        {
                           amount = 0;
                        }
                     }
                     if(amount != 0)
                     {
                        if(delay > 0 || delayModifier > 0)
                        {
                           dropQueue.push({
                              "ItemHandle":item.ItemHandle,
                              "Name":item.Name,
                              "count":uint(amount)
                           });
                           setTimeout(function():void
                           {
                              if(!testRun)
                              {
                                 dropItem(dropQueue[dropQueueId].ItemHandle,dropQueue[dropQueueId].count);
                              }
                              Logger.get().info("Dropping item: " + dropQueue[dropQueueId].Name + " (" + dropQueue[dropQueueId].count + ")");
                              ++dropQueueId;
                              if(testRun && dropQueueId == dropQueue.length)
                              {
                                 Logger.get().info("If you\'re satisfied with result, set testRun to false in config file for: " + sectionConfig.name);
                                 Logger.get().info("Scroll wheel is enabled in this window if text is off-screen");
                                 Logger.get().info(sectionConfig.name + " TEST RUN FINISHED");
                              }
                           },delayModifier + droppedItems++ * delay);
                        }
                        else
                        {
                           dropItem(item.ItemHandle,uint(amount));
                        }
                     }
                     index++;
                  }
                  else
                  {
                     index++;
                  }
               }
               itemNameIndex++;
            }
            if(testRun && dropQueue.length == 0)
            {
               Logger.get().info("If you\'re satisfied with result, set testRun to false in config file for: " + sectionConfig.name);
               Logger.get().info("Scroll wheel is enabled in this window if text is off-screen");
               Logger.get().info(sectionConfig.name + " TEST RUN FINISHED");
            }
            if(sectionConfig.closeMenu && !OverrideCancelCloseMenu)
            {
               setTimeout(exitMenu,delayModifier + droppedItems * delay + DelayCloseMenu);
            }
         }
         catch(e:Error)
         {
            Logger.get().error("dropItemCallback: " + e);
         }
         return droppedItems;
      }
      
      public function findRepairableItemCallback(sectionConfig:Object) : void
      {
         var types:Array;
         var configFav:Boolean;
         var configEqp:Boolean;
         var item:Object;
         var listMc:Array;
         var i:int;
         var repeatCount:int;
         try
         {
            item = null;
            listMc = this.inventory;
            configFav = Boolean(sectionConfig.onlyIfFavorite);
            configEqp = Boolean(sectionConfig.onlyIfEquipped);
            repeatCount = 0;
            i = 0;
            while(i < listMc.length)
            {
               item = listMc[i];
               if(isInvalidCondition(item,sectionConfig,false) && (item.IsFavorited && configFav || item.EquipState == 1 && configEqp || !configFav && !configEqp) && isMatchingType(item,sectionConfig.types))
               {
                  Logger.get().info("Examining item: " + item.Name + ", cnd:" + (100 * ConditionMap[item.Name]).toFixed(1) + "%, fav:" + item.IsFavorited + ", eqp:" + (item.EquipState == 1));
                  if(sectionConfig.repeatAfter == 0)
                  {
                     examineItem(item.ItemHandle);
                     break;
                  }
                  setTimeout(examineItem,repeatCount * sectionConfig.repeatAfter,item.ItemHandle);
                  repeatCount++;
               }
               i++;
            }
            if(i == listMc.length && repeatCount == 0)
            {
               Logger.get().info("No items found for repair: cnd<" + sectionConfig.conditionUnder + "%, only if fav:" + configFav + ", only if eqp:" + configEqp);
            }
            if(sectionConfig.closeMenu && !OverrideCancelCloseMenu)
            {
               setTimeout(exitMenu,repeatCount * sectionConfig.repeatAfter + DelayCloseMenu);
            }
         }
         catch(e:*)
         {
            Logger.get().error("findRepairableItemCallback: " + e);
         }
      }
      
      public function lockProtectedItemsCallback(sectionConfig:Object) : int
      {
         var item:Object;
         var listMc:Array;
         var i:int;
         var lockQueueId:int;
         var lockQueue:Array;
         var lockConfig:Object;
         try
         {
            lockConfig = sectionConfig.itemLocking;
            item = null;
            listMc = this.inventory;
            lockQueueId = 0;
            lockQueue = [];
            i = 0;
            while(i < listMc.length)
            {
               item = listMc[i];
               if(!item.IsTransferLocked)
               {
                  if(ItemProtection.isProtected(item,sectionConfig.dropProtection))
                  {
                     lockQueue.push({
                        "Name":item.Name,
                        "ItemHandle":item.ItemHandle
                     });
                     setTimeout(function():void
                     {
                        toggleLockItem(lockQueue[lockQueueId].ItemHandle);
                        if(lockConfig && lockConfig.debug)
                        {
                           Logger.get().info("Locking: " + lockQueue[lockQueueId].Name);
                        }
                        ++lockQueueId;
                     },lockQueue.length * lockConfig.delay);
                  }
               }
               i++;
            }
            return lockQueue.length;
         }
         catch(e:Error)
         {
            Logger.get().error("lockProtectedItemsCallback: " + e);
         }
         return lockQueueId;
      }
      
      public function toggleLockItem(itemHandle:uint) : void
      {
         try
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("INV::ToggleLock",{"ID":itemHandle}));
         }
         catch(e:Error)
         {
            Logger.get().error("Error locking item: " + e);
         }
      }
      
      public function consumeItem(itemHandle:uint) : void
      {
         try
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("INV::Use",{"ID":itemHandle}));
         }
         catch(e:Error)
         {
            Logger.get().error("Error consuming item: " + e);
         }
      }
      
      public function dropItem(itemHandle:uint, count:uint) : void
      {
         try
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("INV::Drop",{
               "ID":itemHandle,
               "count":count
            }));
         }
         catch(e:Error)
         {
            Logger.get().error("Error dropping item: " + e);
         }
      }
      
      public function examineItem(itemHandle:uint) : void
      {
         try
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("INV::Inspect",{"ID":itemHandle}));
         }
         catch(e:Error)
         {
            Logger.get().error("Error inspecting item: " + e);
         }
      }
      
      public function setTab(tabIndex:uint) : void
      {
         try
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("NewPipBoyMenu::TabSet",{"tabIndex":uint(tabIndex)}));
         }
         catch(e:Error)
         {
            Logger.get().error("Error setting tab: " + e);
         }
      }
      
      public function setPage(pageIndex:uint) : void
      {
         try
         {
            BSUIDataManager.dispatchEvent(new CustomEvent("NewPipBoyMenu::PageSet",{"pageIndex":uint(pageIndex)}));
         }
         catch(e:Error)
         {
            Logger.get().error("Error setting page: " + e);
         }
      }
      
      public function exitMenu() : void
      {
         try
         {
            if(!OverrideCancelCloseMenu)
            {
               BSUIDataManager.dispatchEvent(new Event("NewPipBoyMenu::Close"));
            }
         }
         catch(e:Error)
         {
            Logger.get().error("Error exiting menu: " + e);
         }
      }
   }
}

