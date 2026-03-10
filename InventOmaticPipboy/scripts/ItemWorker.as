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
      
      public static const DELAY_BETWEEN_TABS:int = 250;
      
      public static const DELAY_BETWEEN_CONFIGS:int = 100;
      
      public static const DELAY_BETWEEN_ITEMS:int = 20;
      
      public static const MIN_DELAY:int = 20;
      
      public var parent:MovieClip;
      
      public var iomPip:MovieClip;
      
      public var activeEffects:Array;
      
      public var consumeQueueId:int;
      
      public var consumeQueue:Array;
      
      public var config:Object;
      
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
         if(itemText === null || itemText == null || itemText.length < 1 || itemText === "" || itemText == "")
         {
            return false;
         }
         if(itemConfig === null || itemConfig == null || itemConfig.length < 1 || itemConfig === "" || itemConfig == "")
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
      
      public function isTragedyProtected(item:Object, sectionConfig:Object) : Boolean
      {
         var types:Array = null;
         var matchingFilterFlags:Array = null;
         var i:int = 0;
         var teenoodleTragedyProtection:Object = sectionConfig.teenoodleTragedyProtection;
         if(teenoodleTragedyProtection)
         {
            if(Boolean(sectionConfig.types) && sectionConfig.types.length > 0)
            {
               types = sectionConfig.types;
               matchingFilterFlags = [];
               i = 0;
               while(i < types.length)
               {
                  matchingFilterFlags = matchingFilterFlags.concat(ItemTypes.ITEM_TYPES[types[i]]);
                  i++;
               }
               if(!matchingFilterFlags.some(function(flag:int):Boolean
               {
                  return item.filterFlag & flag;
               }))
               {
                  return true;
               }
            }
            if(teenoodleTragedyProtection.ignoreLegendaries)
            {
               if(item.IsLegendary)
               {
                  return true;
               }
            }
            if(teenoodleTragedyProtection.ignoreNonTradable)
            {
               if(IsTradableMap[item.serverHandleID] != null && !IsTradableMap[item.serverHandleID])
               {
                  return true;
               }
            }
            if(Boolean(teenoodleTragedyProtection.excluded) && teenoodleTragedyProtection.excluded.length > 0)
            {
               i = 0;
               teenoodleTragedyProtection.excluded = appendItemGroupNames(teenoodleTragedyProtection.excluded);
               while(i < teenoodleTragedyProtection.excluded.length)
               {
                  if(item.Name.toLowerCase().indexOf(teenoodleTragedyProtection.excluded[i].toLowerCase()) != -1)
                  {
                     return true;
                  }
                  i++;
               }
            }
         }
         return false;
      }
      
      public function isMatchingType(item:Object, config:Object) : Boolean
      {
         var TODO:*;
         var types:Array = config.types;
         var matchingFilterFlags:Array = [];
         var i:int = 0;
         try
         {
            TODO = "DEBUG ONLY FOR NOW";
            if(true)
            {
               return true;
            }
            if(!Boolean(types) || types.length == 0)
            {
               return true;
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
      
      public function appendItemGroupNames(itemNames:Array) : Array
      {
         if(!config.itemNamesGroupConfig)
         {
            return itemNames;
         }
         var _itemNames:Array = [];
         var i:int = 0;
         while(i < itemNames.length)
         {
            if(config.itemNamesGroupConfig[itemNames[i]] != null)
            {
               _itemNames = _itemNames.concat(config.itemNamesGroupConfig[itemNames[i]]);
            }
            else
            {
               _itemNames.push(itemNames[i]);
            }
            i++;
         }
         return _itemNames;
      }
      
      public function isActiveEffect(itemNames:Array) : Boolean
      {
         var e:int = 0;
         var i:int = 0;
         while(e < this.activeEffects.length)
         {
            var effectName:String = this.activeEffects[e].text.toLowerCase();
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
         var isMatching:Boolean = false;
         var listMc:Array = parent.List_mc.entryList;
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
                  sectionConfig.itemNames[indexNames] = appendItemGroupNames(sectionConfig.itemNames[indexNames]);
                  while(indexNamesAlts < sectionConfig.itemNames[indexNames].length)
                  {
                     isMatching = Boolean(isItemMatchingConfig(item,sectionConfig.itemNames[indexNames][indexNamesAlts],sectionConfig.matchMode));
                     if(isMatching)
                     {
                        newMatches[indexNames][indexNamesAlts].push({
                           "nodeID":item.nodeID,
                           "ItemHandle":item.ItemHandle,
                           "text":item.text
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
            if(onlyInactiveEffects && isActiveEffect(sectionConfig.itemNames[indexNames]))
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
                  if(matches[indexNames][indexNamesAlts].length == 0)
                  {
                     Logger.get().info("No items matching: " + sectionConfig.itemNames[indexNames][indexNamesAlts]);
                  }
                  index = 0;
                  while(index < matches[indexNames][indexNamesAlts].length)
                  {
                     Logger.get().info("Queued (" + sectionConfig.itemNames[indexNames][indexNamesAlts] + "): " + matches[indexNames][indexNamesAlts][index].text);
                     filtered.push(matches[indexNames][indexNamesAlts][index]);
                     if(onlyInactiveEffects)
                     {
                        indexNamesAlts = int(matches[indexNames].length);
                        break;
                     }
                     index++;
                  }
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
         var delay:int;
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
            delay = Math.max(Number(this.config.delayTabSwitching) || DELAY_BETWEEN_TABS,DELAY_BETWEEN_TABS);
            this.inventory = [];
            this.queuedTabs = tabs;
            if(this.queuedTabs.length)
            {
               this.lastSelectedTabId = this.parent.CurrentTabIndex;
               if(this.lastSelectedTabId == this.queuedTabs[0])
               {
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
                  setTimeout(this.setTab,delay * i,this.queuedTabs[i]);
                  i++;
               }
               setTimeout(function():void
               {
                  queuedTabs = [];
               },delay * (this.queuedTabs.length + 1));
            }
            return delay * (this.queuedTabs.length + 1);
         }
         catch(e:*)
         {
            Logger.get().error("Building inventory failed: " + e);
         }
         return -1;
      }
      
      public function appendTabInventory(param1:*) : void
      {
         var newFilterFlag:uint;
         var newItems:Array;
         var errorCode:String = "";
         try
         {
            if(this.queuedTabs.length)
            {
               if(this.lastSelectedTabId != this.parent.CurrentTabIndex)
               {
                  Logger.get().info("Tab changed: " + this.lastSelectedTabId + " -> " + this.parent.CurrentTabIndex);
                  this.lastSelectedTabId = this.parent.CurrentTabIndex;
                  errorCode = "newFilterFlag";
                  newFilterFlag = uint(ItemTypes.ITEM_TYPES[PipboyTabs.PIPBOY_TAB_IDS[this.parent.CurrentTabIndex]][0]);
                  errorCode = "clone";
                  newItems = GlobalFunc.CloneObject(param1 is CustomEvent ? param1.params.InventoryA : param1.data.InventoryA);
                  errorCode = "filterFlag";
                  newItems.forEach(function(item:Object):void
                  {
                     item.filterFlag = newFilterFlag;
                  });
                  errorCode = "concat";
                  this.inventory = this.inventory.concat(newItems);
                  Logger.get().info("Appending inv for tab " + this.lastSelectedTabId + " : " + PipboyTabs.PIPBOY_TAB_IDS[this.parent.CurrentTabIndex] + ", filterFlag: " + newFilterFlag);
                  Logger.get().info("Inv size: " + this.inventory.length + ", added: " + newItems.length);
               }
            }
         }
         catch(e:*)
         {
            Logger.get().error("appendTabInventory error: " + e);
         }
      }
      
      public function prepConsumeConfig(sectionConfig:Object) : Object
      {
         var i:int = 0;
         var prepItemNames:Array = new Array(sectionConfig.itemNames.length);
         while(i < sectionConfig.itemNames.length)
         {
            prepItemNames[i] = new Array();
            if(sectionConfig.itemNames[i] is Array)
            {
               for each(item in sectionConfig.itemNames[i])
               {
                  prepItemNames[i].push(item);
               }
            }
            else if(sectionConfig.itemNames[i] is String)
            {
               prepItemNames[i].push(sectionConfig.itemNames[i]);
            }
            if(sectionConfig.altItemNames && sectionConfig.altItemNames.length > i)
            {
               if(sectionConfig.altItemNames[i] is Array)
               {
                  for each(item in sectionConfig.altItemNames[i])
                  {
                     prepItemNames[i].push(item);
                  }
               }
               else if(sectionConfig.altItemNames[i] is String)
               {
                  prepItemNames[i].push(sectionConfig.altItemNames[i]);
               }
            }
            i++;
         }
         return prepItemNames;
      }
      
      public function consumeItemsCallback(sectionConfig:Object, delayModifier:int = 0) : *
      {
         var delay:int;
         var filtered:Array;
         var index:int;
         var errorMessage:String = "init";
         try
         {
            index = 0;
            sectionConfig.itemNames = prepConsumeConfig(sectionConfig);
            errorMessage = "preparedConfig";
            filtered = this.filterActiveEffects(this.findMatches(sectionConfig),sectionConfig);
            errorMessage = "filteredItems";
            if(sectionConfig.testRun)
            {
               Logger.get().debugMode = true;
               Logger.get().info(sectionConfig.name + " TEST RUN START");
            }
            setTimeout(function():void
            {
               errorMessage = "setTimeout";
               consumeQueueId = 0;
               consumeQueue = filtered;
               delay = Math.max(Parser2.parsePositiveNumber(sectionConfig.delay,DELAY_BETWEEN_ITEMS),MIN_DELAY);
               errorMessage = "delayParsed";
               if(delay > 0)
               {
                  errorMessage = "delay > 0";
                  while(index < consumeQueue.length)
                  {
                     setTimeout(function():void
                     {
                        updateNodeID(consumeQueue[consumeQueueId]);
                        Logger.get().info("Using: " + consumeQueue[consumeQueueId].Name);
                        if(!sectionConfig.testRun)
                        {
                           consumeItem(consumeQueue[consumeQueueId].nodeID);
                        }
                        ++consumeQueueId;
                        if(sectionConfig.testRun && consumeQueueId == consumeQueue.length)
                        {
                           Logger.get().info("If you\'re satisfied with result, set testRun to false in config file for: " + sectionConfig.name);
                           Logger.get().info("Scroll wheel is enabled in this window if text is off-screen");
                           Logger.get().info(sectionConfig.name + " TEST RUN FINISHED");
                        }
                     },index * delay);
                     ++index;
                  }
                  errorMessage = "delay > 0 while";
                  if(consumeQueue.length == 0 && sectionConfig.testRun)
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
                     updateNodeID(consumeQueue[index]);
                     Logger.get().info("Using: " + consumeQueue[index].Name);
                     if(!sectionConfig.testRun)
                     {
                        consumeItem(consumeQueue[index].nodeID);
                     }
                     ++index;
                  }
                  errorMessage = "delay = 0 while";
                  if(sectionConfig.testRun && index == consumeQueue.length)
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
            return 0;
         }
      }
      
      public function dropItemsCallback(sectionConfig:Object, delayModifier:int = 0) : *
      {
         var item:Object;
         var matches:Boolean;
         var amount:int;
         var listMc:Array;
         var index:int;
         var delay:int;
         var droppedItems:int;
         var itemNameIndex:int;
         var itemName:String;
         var dropQueueId:int;
         var dropQueue:Array;
         try
         {
            dropQueueId = 0;
            dropQueue = [];
            droppedItems = 0;
            itemNameIndex = 0;
            listMc = this.inventory;
            delay = Math.max(Parser2.parsePositiveNumber(sectionConfig.delay,DELAY_BETWEEN_ITEMS),MIN_DELAY);
            sectionConfig.itemNames = appendItemGroupNames(sectionConfig.itemNames);
            while(itemNameIndex < sectionConfig.itemNames.length)
            {
               itemName = sectionConfig.itemNames[itemNameIndex];
               item = null;
               matches = false;
               amount = 0;
               index = 0;
               while(index < listMc.length)
               {
                  item = listMc[index];
                  if(item.IsTransferLocked)
                  {
                     index++;
                  }
                  else
                  {
                     matches = Boolean(isItemMatchingConfig(item,itemName,sectionConfig.matchMode));
                     if(matches && !isTragedyProtected(item,sectionConfig))
                     {
                        if(item.IsFavorited && !Boolean(sectionConfig.dropFavorite))
                        {
                           index++;
                           continue;
                        }
                        if(item.EquipState == 1 && !Boolean(sectionConfig.dropEquipped))
                        {
                           index++;
                           continue;
                        }
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
                                 dropItem(dropQueue[dropQueueId].ItemHandle,dropQueue[dropQueueId].count);
                                 Logger.get().info("Dropping item: " + dropQueue[dropQueueId].Name + " (" + dropQueue[dropQueueId].count + ")");
                                 ++dropQueueId;
                              },delayModifier + droppedItems++ * delay);
                           }
                           else
                           {
                              dropItem(item.ItemHandle,uint(amount));
                           }
                        }
                     }
                     index++;
                  }
               }
               itemNameIndex++;
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
         var matchingFilterFlags:Array;
         var listMc:Array;
         var i:int;
         try
         {
            item = null;
            matchingFilterFlags = [];
            listMc = this.inventory;
            i = 0;
            if(sectionConfig.types && sectionConfig.types.length > 0)
            {
               types = sectionConfig.types;
               i = 0;
               while(i < types.length)
               {
                  matchingFilterFlags = matchingFilterFlags.concat(ItemTypes.ITEM_TYPES[types[i]]);
                  i++;
               }
            }
            configFav = Boolean(sectionConfig.onlyIfFavorite);
            configEqp = Boolean(sectionConfig.onlyIfEquipped);
            i = 0;
            while(i < listMc.length)
            {
               item = listMc[i];
               if(isInvalidCondition(item,sectionConfig,false) && (item.IsFavorited && configFav || item.EquipState == 1 && configEqp || !configFav && !configEqp) && matchingFilterFlags.some(function(flag:int):Boolean
               {
                  return item.filterFlag & flag;
               }))
               {
                  Logger.get().info("Examining item: " + item.Name + ", cnd:" + (100 * ConditionMap[item.Name]).toFixed(1) + "%, fav:" + item.IsFavorited + ", eqp:" + (item.EquipState == 1));
                  examineItem(item.ItemHandle);
                  break;
               }
               i++;
            }
            if(i == listMc.length)
            {
               Logger.get().info("No items found for repair: cnd<" + sectionConfig.conditionUnder + "%, only if fav:" + configFav + ", only if eqp:" + configEqp);
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
         var delay:int;
         var lockQueueId:int;
         var lockQueue:Array;
         var lockConfig:Object;
         try
         {
            lockConfig = sectionConfig.itemLocking;
            item = null;
            listMc = this.inventory;
            delay = Math.max(Parser2.parsePositiveNumber(lockConfig.delay,50),MIN_DELAY);
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
                     },lockQueue.length * delay);
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
   }
}

