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
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.*;
   import utils.*;
   
   public class InventOmaticPipboy extends MovieClip
   {
      
      public static const MOD_NAME:String = "IOMP-uo";
      
      public static const DROP_ACTION:String = "drop";
      
      public static const CONSUME_ACTION:String = "consume";
      
      public static const FIND_ACTION:String = "findForRepair";
      
      public static const LOCK_ACTION:String = "itemLocking";
      
      public static const PIPBOY_TAB_NEW:int = 0;
      
      public static const PIPBOY_PAGE_INV:uint = 1;
      
      public var debugLogger:TextField;
      
      public var _parent:*;
      
      public var _itemWorker:ItemWorker;
      
      public var pipboyMenu:*;
      
      public var config:Object;
      
      public var consumeButtons:Vector.<BSButtonHintData>;
      
      public var dropButtons:Vector.<BSButtonHintData>;
      
      public var findButton:BSButtonHintData;
      
      public var lockAllButton:BSButtonHintData;
      
      public var toggleDebugKeyCode:uint = 192;
      
      public var findForRepairKeyCode:uint = 74;
      
      public var lockAllKeyCode:uint = 75;
      
      public var itemCardMap:* = {};
      
      public var paperDollMap:* = {};
      
      public var PipBoyINVProvider:*;
      
      public var ButtonBarData:*;
      
      private var buttonHintDataV:Vector.<BSButtonHintData>;
      
      public function InventOmaticPipboy()
      {
         super();
         Logger.DEBUG_MODE = false;
         Logger.init(this.debugLogger);
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      public static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         var children:String;
         var movieRoot:*;
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler,false,0,true);
         movieRoot = stage.getChildAt(0);
         this.pipboyMenu = "Menu_mc" in movieRoot ? movieRoot.Menu_mc : null;
         if(Boolean(this.pipboyMenu) && getQualifiedClassName(this.pipboyMenu) == "NewPipBoyMenu")
         {
            if(getQualifiedClassName(this.parent.parent) == "NewPipboy_InvPage")
            {
               try
               {
                  this._parent = this.parent.parent;
                  this._itemWorker = new ItemWorker(this._parent,this);
                  this.loadConfig();
                  this.init();
               }
               catch(e:*)
               {
                  ShowHUDMessage("init error " + e,true);
               }
            }
            else
            {
               children = "";
               for(ch in this.pipboyMenu)
               {
                  children += ch + "(" + this.pipboyMenu[ch] + "), ";
               }
               Logger.DEBUG_MODE = true;
               Logger.get().error("Pipboy_InvPage not found: " + children);
               ShowHUDMessage("NewPipboy_InvPage not found: " + children,true);
               ShowHUDMessage("p0: " + getQualifiedClassName(this.parent) + ", p1: " + getQualifiedClassName(this.parent.parent),true);
            }
         }
         else
         {
            Logger.DEBUG_MODE = true;
            Logger.get().error("Not injected into PipboyMenu");
            ShowHUDMessage("Not injected into PipboyMenu",true);
         }
      }
      
      public function removedFromStageHandler(param1:Event) : *
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStageHandler);
      }
      
      public function get isNewTab() : Boolean
      {
         return this.pipboyMenu.DataObj.CurrentPage == PIPBOY_PAGE_INV && this.pipboyMenu.DataObj.CurrentTab == PIPBOY_TAB_NEW;
      }
      
      public function isItemProtected(item:Object) : Boolean
      {
         var t1:*;
         try
         {
            if(!this.config || !this.config.protectionConfig)
            {
               Logger.get().error("Unable to check item protection, config not loaded");
               return false;
            }
            t1 = getTimer();
            if(this.config.protectionConfig.dropProtection && this.config.protectionConfig.dropProtection.itemNames)
            {
               this.config.protectionConfig.dropProtection.itemNames = this._itemWorker.appendItemGroupNames(this.config.protectionConfig.dropProtection.itemNames);
            }
            if(ItemProtection.isProtected(item,this.config.protectionConfig.dropProtection))
            {
               if(this.config.protectionConfig.debug)
               {
                  Logger.get().info(item.Name + " is Drop protected: " + ItemProtection.ProtectionReason + " (" + (getTimer() - t1) + "ms)");
               }
               return true;
            }
            if(false && this.config.protectionConfig.debug)
            {
               Logger.get().info(item.Name + " is not Drop protected (" + (getTimer() - t1) + "ms)");
            }
            return false;
         }
         catch(e:Error)
         {
            Logger.get().error("Error checking Item Drop Protection " + e);
            ShowHUDMessage("Error checking Item Drop Protection " + e,true);
         }
         return false;
      }
      
      public function isItemEquipProtected(item:Object) : Boolean
      {
         var t1:*;
         var i:int;
         var apparelType:*;
         try
         {
            t1 = getTimer();
            if(!this.config || !this.config.protectionConfig)
            {
               Logger.get().error("Unable to check Equip protection, config not loaded");
               return false;
            }
            if(!item)
            {
               Logger.get().error("Unable to check Equip protection, item not found");
               return false;
            }
            if([1,3,4].indexOf(this._parent.CurrentTabIndex) == -1)
            {
               Logger.get().error("Unable to check Equip protection, item not equippable");
               return false;
            }
            if(this.config.protectionConfig.equipProtection != null && this.config.protectionConfig.equipProtection.parts != null && this.config.protectionConfig.equipProtection.enabled)
            {
               if(this.paperDollMap[item.ItemHandle] == null)
               {
                  if(this.itemCardMap[item.ItemHandle] == null)
                  {
                     Logger.get().error("Unable to check Equip protection, missing item map");
                     return true;
                  }
                  Logger.get().error("Unable to check Equip protection, item does not have paperDoll");
                  return false;
               }
               if(this.paperDollMap[item.ItemHandle].length == 0)
               {
                  if(this.config.protectionConfig.debug)
                  {
                     Logger.get().info("Unable to check Equip protection, empty paperDollMap");
                  }
                  return false;
               }
               i = 0;
               while(i < this.config.protectionConfig.equipProtection.parts.length)
               {
                  apparelType = ApparelTypes.APPAREL_TYPES[this.config.protectionConfig.equipProtection.parts[i]];
                  if(apparelType != null && this.paperDollMap[item.ItemHandle].length > apparelType && this.paperDollMap[item.ItemHandle][int(apparelType)])
                  {
                     if(this.config.protectionConfig.debug)
                     {
                        Logger.get().info(item.Name + " is Equip protected: " + this.config.protectionConfig.equipProtection.parts[i] + " (" + (getTimer() - t1) + "ms)");
                     }
                     return true;
                  }
                  i++;
               }
               if(this.config.protectionConfig.equipProtection.apparel)
               {
                  i = 0;
                  while(i < this.paperDollMap[item.ItemHandle].length)
                  {
                     if(this.paperDollMap[item.ItemHandle][i])
                     {
                        break;
                     }
                     i++;
                  }
                  if(i == this.paperDollMap[item.ItemHandle].length && [1,4].indexOf(_parent.CurrentTabIndex) != -1)
                  {
                     if(this.config.protectionConfig.debug)
                     {
                        Logger.get().info(item.Name + " is Equip protected: APPAREL (" + (getTimer() - t1) + "ms)");
                     }
                     return true;
                  }
               }
            }
            if(false && this.config.protectionConfig.debug)
            {
               Logger.get().info(item.Name + " is not Equip protected (" + (getTimer() - t1) + "ms)");
            }
            return false;
         }
         catch(e:Error)
         {
            Logger.get().error("Error checking Item Equip Protection " + e);
            ShowHUDMessage("Error checking Item Equip Protection " + e,true);
         }
         return false;
      }
      
      private function init() : void
      {
         try
         {
            stage.getChildAt(0)["InventOmaticPipboy"] = this;
            this.PipBoyINVProvider = BSUIDataManager.GetDataFromClient("PipBoyINVProvider");
            BSUIDataManager.Subscribe("PipBoyINVSelectionProvider",this.onPipBoyInvSelectionUpdate);
            stage.addEventListener("IOMPipboyINVChange",this._itemWorker.appendTabInventory,false,0,true);
            stage.addEventListener("IOMPipboyEFFECTSChange",this._itemWorker.updateEffects,false,0,true);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            ButtonBarData = BSUIDataManager.GetDataFromClient("ButtonBarData");
            ButtonBarData.addEventListener(Event.CHANGE,this.UpdateButtonBar,false,int.MIN_VALUE);
            Logger.get().info("Mod initialized");
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error init()",e);
         }
      }
      
      private function UpdateButtonBar(param1:*) : void
      {
         var m_Buttons:*;
         var i:uint;
         var entry:Object;
         var dispatchEvent:String;
         var buttonHint:BSButtonHintData;
         var aData:Object;
         try
         {
            i = 0;
            entry = null;
            dispatchEvent = null;
            buttonHint = null;
            aData = param1.data;
            if(aData)
            {
               m_Buttons = new Vector.<BSButtonHintData>();
               i = 0;
               while(i < aData.EntryList.length)
               {
                  if(aData.EntryList[i].IsEnabled)
                  {
                     entry = aData.EntryList[i];
                     dispatchEvent = entry.ScriptFunc != "" ? entry.ScriptFunc : entry.Event;
                     buttonHint = new BSButtonHintData(entry.Name,entry.Mappings.PCButton,entry.Mappings.PSNButton,entry.Mappings.XboxButton,1,function():*
                     {
                        pipboyMenu.onButtonPressEvent(dispatchEvent,"",true);
                     },dispatchEvent,entry.Event);
                     buttonHint.canHold = entry.IsHold;
                     buttonHint.ButtonVisible = entry.IsVisible;
                     buttonHint.ButtonEnabled = entry.IsButtonEnabled;
                     buttonHint.ButtonFlashing = entry.IsFlashing;
                     m_Buttons.push(buttonHint);
                  }
                  i++;
               }
               m_Buttons = m_Buttons.concat(buttonHintDataV);
               pipboyMenu.ButtonHintBar_mc.SetButtonHintData(m_Buttons);
            }
         }
         catch(e:*)
         {
            Logger.get().error("UpdateButtonBar failed: " + e);
         }
      }
      
      private function onPipBoyInvSelectionUpdate(event:*) : void
      {
         try
         {
            if(!this.itemCardMap[_parent.SelectedID])
            {
               this.itemCardMap[_parent.SelectedID] = GlobalFunc.CloneObject(event.data.ItemDetails.InfoCardData);
               this.paperDollMap[_parent.SelectedID] = GlobalFunc.CloneObject(event.data.PaperDoll.SlotsAnimatedA);
            }
            if(false)
            {
               Logger.get().info("onPipBoyInvSelectionUpdate: " + toString(event.data));
               Logger.get().info("SelectedID: " + _parent.SelectedID);
               Logger.get().info("List.SelID: " + _parent.List_mc.selectedEntry.ItemHandle);
               ž;
               Logger.get().info("INV.Handle: " + this.PipBoyINVProvider.data.SelectedHandle);
            }
         }
         catch(e:*)
         {
            Logger.get().info("onPipBoyInvSelectionUpdate failed: " + e);
         }
      }
      
      private function initButtonHints() : void
      {
         var i:int;
         var sectionConfig:Object;
         var configName:String;
         var button:BSButtonHintData;
         var buttonIndex:int;
         try
         {
            buttonHintDataV = new Vector.<BSButtonHintData>();
            consumeButtons = new Vector.<BSButtonHintData>();
            dropButtons = new Vector.<BSButtonHintData>();
            findButton = null;
            lockAllButton = null;
            if(this.config)
            {
               this.toggleDebugKeyCode = Parser2.parseHotkey(this.config.toggleDebugHotkey,this.toggleDebugKeyCode);
               if(this.config.findForRepair)
               {
                  this.findForRepairKeyCode = Parser2.parseHotkey(this.config.findForRepair,this.findForRepairKeyCode);
                  this.config.findForRepair.hotkey = this.findForRepairKeyCode;
               }
               if(this.config.protectionConfig && this.config.protectionConfig.itemLocking)
               {
                  this.lockAllKeyCode = Parser2.parseHotkey(this.config.protectionConfig.itemLocking,this.lockAllKeyCode);
                  this.config.protectionConfig.itemLocking.hotkey = this.lockAllKeyCode;
               }
               if(ItemWorker.isConfigEnabled(this.config,CONSUME_ACTION))
               {
                  i = 0;
                  while(i < this.config.consume.configs.length)
                  {
                     this.config.consume.configs[i].hotkey = Parser2.parseHotkey(this.config.consume.configs[i]);
                     i++;
                  }
               }
               if(ItemWorker.isConfigEnabled(this.config,DROP_ACTION))
               {
                  i = 0;
                  while(i < this.config.drop.configs.length)
                  {
                     this.config.drop.configs[i].hotkey = Parser2.parseHotkey(this.config.drop.configs[i]);
                     i++;
                  }
               }
               if(config.orderButtons == null || !(config.orderButtons is Array))
               {
                  config.orderButtons = [DROP_ACTION,CONSUME_ACTION,FIND_ACTION,LOCK_ACTION];
               }
               buttonIndex = 0;
               while(buttonIndex < config.orderButtons.length)
               {
                  switch(config.orderButtons[buttonIndex])
                  {
                     case CONSUME_ACTION:
                        if(ItemWorker.isConfigEnabled(this.config,CONSUME_ACTION))
                        {
                           i = 0;
                           while(i < this.config.consume.configs.length)
                           {
                              sectionConfig = this.config.consume.configs[i];
                              if(sectionConfig.enabled && sectionConfig.showButton && ItemWorker.isTheSameCharacterName(sectionConfig))
                              {
                                 configName = "CONSUME_" + i;
                                 if(sectionConfig.name && sectionConfig.name != "")
                                 {
                                    configName = String(sectionConfig.name);
                                 }
                                 button = new BSButtonHintData(configName,Buttons.getButtonKey(sectionConfig.hotkey),Buttons.getButtonGamepad(sectionConfig.hotkey),Buttons.getButtonGamepad(sectionConfig.hotkey),1,null);
                                 consumeButtons.push(button);
                                 buttonHintDataV.push(button);
                              }
                              i++;
                           }
                        }
                        break;
                     case DROP_ACTION:
                        if(ItemWorker.isConfigEnabled(this.config,DROP_ACTION))
                        {
                           i = 0;
                           while(i < this.config.drop.configs.length)
                           {
                              sectionConfig = this.config.drop.configs[i];
                              if(sectionConfig.enabled && sectionConfig.showButton && ItemWorker.isTheSameCharacterName(sectionConfig))
                              {
                                 configName = "DROP_" + i;
                                 if(sectionConfig.name && sectionConfig.name != "")
                                 {
                                    configName = String(sectionConfig.name);
                                 }
                                 button = new BSButtonHintData(configName,Buttons.getButtonKey(sectionConfig.hotkey),Buttons.getButtonGamepad(sectionConfig.hotkey),Buttons.getButtonGamepad(sectionConfig.hotkey),1,null);
                                 dropButtons.push(button);
                                 buttonHintDataV.push(button);
                              }
                              i++;
                           }
                        }
                        break;
                     case FIND_ACTION:
                        if(Boolean(this.config[FIND_ACTION]) && Boolean(this.config[FIND_ACTION].enabled))
                        {
                           sectionConfig = this.config.findForRepair;
                           if(sectionConfig.showButton)
                           {
                              if(sectionConfig.name && sectionConfig.name != "")
                              {
                                 configName = String(sectionConfig.name);
                              }
                              else
                              {
                                 configName = "FIND_REPAIR";
                                 sectionConfig.name = configName;
                              }
                              findButton = new BSButtonHintData(configName,Buttons.getButtonKey(sectionConfig.hotkey),Buttons.getButtonGamepad(sectionConfig.hotkey),Buttons.getButtonGamepad(sectionConfig.hotkey),1,null);
                              buttonHintDataV.push(findButton);
                           }
                        }
                        break;
                     case LOCK_ACTION:
                        if(Boolean(config.protectionConfig) && Boolean(config.protectionConfig.itemLocking) && Boolean(config.protectionConfig.itemLocking.enabled))
                        {
                           sectionConfig = this.config.protectionConfig.itemLocking;
                           if(sectionConfig.showButton)
                           {
                              if(sectionConfig.name && sectionConfig.name != "")
                              {
                                 configName = String(sectionConfig.name);
                              }
                              else
                              {
                                 configName = "LOCK_ALL";
                                 sectionConfig.name = configName;
                              }
                              lockAllButton = new BSButtonHintData(configName,Buttons.getButtonKey(sectionConfig.hotkey),Buttons.getButtonGamepad(sectionConfig.hotkey),Buttons.getButtonGamepad(sectionConfig.hotkey),1,null);
                              buttonHintDataV.push(lockAllButton);
                           }
                        }
                        break;
                  }
                  buttonIndex++;
               }
            }
            Logger.get().info("Buttons initialized");
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error initializing buttons",e);
         }
      }
      
      private function initDurabilityValue() : void
      {
         var val:Boolean = Boolean(Parser2.parseBoolean(this.config.showDurabilityValue,true));
         Logger.get().info("initDur: " + val);
         _parent.showDurabilityValue(val);
      }
      
      private function loadConfig() : void
      {
         var loaderError:*;
         var loaderComplete:*;
         var url:URLRequest = null;
         var loader:URLLoader = null;
         try
         {
            loaderError = function(e:Event):void
            {
               ShowHUDMessage("Error loading config " + e,true);
               Logger.get().error("Error loading config " + e);
            };
            loaderComplete = function(param1:Event):void
            {
               var jsonData:Object = null;
               var e:Event = param1;
               try
               {
                  jsonData = new JSONDecoder(loader.data,true).getValue();
                  config = jsonData;
                  Logger.get().debugMode = config.debug;
                  if(config.protectionConfig != null)
                  {
                     _parent.checkItemProtectionOnSelectionChange(Parser2.parseBoolean(config.protectionConfig.checkOnSelectionChange,true));
                  }
                  _parent.List_mc.enableScrollWrap = !config.disableScrollWrap;
                  initButtonHints();
                  _itemWorker.config = config;
                  if(!config.hideLoadMessage)
                  {
                     ShowHUDMessage("Config file is loaded!",true);
                  }
                  Logger.get().info("Config file is loaded!");
               }
               catch(e:Error)
               {
                  ShowHUDMessage("Error parsing config " + e,true);
                  Logger.get().error("Error parsing config " + e);
               }
            };
            url = new URLRequest("../inventOmaticPipboyConfig.json");
            loader = new URLLoader();
            loader.load(url);
            loader.addEventListener(IOErrorEvent.IO_ERROR,loaderError);
            loader.addEventListener(Event.COMPLETE,loaderComplete);
         }
         catch(e:Error)
         {
            ShowHUDMessage(e.getStackTrace(),true);
         }
      }
      
      public function get parentClip() : MovieClip
      {
         return this._parent;
      }
      
      public function log(string:String) : void
      {
         Logger.get().info(string);
      }
      
      private function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(this.config && this.config.debugKeys)
         {
            Logger.get().info("KeyDown: " + param1.keyCode + "(" + Buttons.getButtonKey(param1.keyCode) + ")");
         }
         if(param1.keyCode == Keyboard.F9)
         {
            if(this.config.debug)
            {
               Logger.get().info("selected entry: " + toString(this.parentClip.List_mc.selectedEntry));
               Logger.get().info("itemCardMap: " + toString(this.itemCardMap[this.parentClip.List_mc.selectedEntry.ItemHandle]));
               Logger.get().info("paperDollMap: " + toString(this.paperDollMap[this.parentClip.List_mc.selectedEntry.ItemHandle]));
            }
         }
         else if(param1.keyCode == Keyboard.F10)
         {
            if(this.config.testExternal is String)
            {
               if(this.parentClip.BGSCodeObj[this.config.testExternal] == null)
               {
                  Logger.get().info("Ext doesn\'t exist: " + this.config.testExternal);
                  var externalData:String = "";
                  for(f in this.parentClip.BGSCodeObj)
                  {
                     externalData += f + ":" + getQualifiedClassName(this.parentClip.BGSCodeObj[f]) + ", ";
                  }
                  Logger.get().info("External data: " + externalData);
               }
               else
               {
                  BGSExternalInterface.call(this.parentClip.BGSCodeObj,this.config.testExternal,this.config.testExternalData1,this.config.testExternalData2);
               }
            }
         }
         else if(param1.keyCode == Keyboard.F11)
         {
            if(this.config.testEvent != null && this.config.testEventData != null)
            {
               Logger.get().info("Sending event: " + this.config.testEvent);
               for(i in this.config.testEventData)
               {
                  if(this.config.testEventData[i] == "{selectedId}")
                  {
                     this.config.testEventData[i] = this.parentClip.selectedListEntry.ItemHandle;
                  }
                  else if(i == "ItemHandle" || i == "ID")
                  {
                     this.config.testEventData[i] = uint(this.config.testEventData[i]);
                  }
               }
               Logger.get().info("Event data: " + toString(this.config.testEventData));
               BSUIDataManager.dispatchEvent(new CustomEvent(this.config.testEvent,this.config.testEventData));
            }
         }
         else if(param1.keyCode == Keyboard.F12)
         {
            if(config.testMethod != null)
            {
               var apiData:* = BSUIDataManager.GetDataFromClient(config.testMethod).data;
               var data:String = toString(apiData);
               Logger.get().info("Retrieve data for: " + config.testMethod);
               Logger.get().info(data);
            }
         }
      }
      
      private function keyUpHandler(e:KeyboardEvent) : void
      {
         var delayConfig:int;
         var delayBuildInventory:int;
         var delayUpdateEffects:int;
         var checkInactiveEffects:Boolean;
         var matchingConfigs:Array;
         var delay:int = 0;
         var delayModifier:int = 0;
         var itemCount:int = 0;
         var previousConfig:Object = null;
         if(this.config.debugKeys)
         {
            Logger.get().info("KeyUp: " + e.keyCode + "(" + Buttons.getButtonKey(e.keyCode) + ")");
         }
         if(this.config)
         {
            if(ItemWorker.isConfigEnabled(this.config,DROP_ACTION))
            {
               delayConfig = Math.max(Parser2.parsePositiveNumber(this.config.drop.delay),ItemWorker.DELAY_BETWEEN_CONFIGS);
               matchingConfigs = this.config.drop.configs.filter(function(sectionConfig:Object):Boolean
               {
                  return ItemWorker.isMatchingConfigSection(e,sectionConfig);
               });
               if(matchingConfigs.length > 0)
               {
                  Logger.get().info(matchingConfigs.length + " drop configs");
                  delayBuildInventory = int(_itemWorker.buildInventory(matchingConfigs));
                  if(delayBuildInventory != -1)
                  {
                     setTimeout(function():void
                     {
                        matchingConfigs.forEach(function(sectionConfig:Object):void
                        {
                           if(previousConfig)
                           {
                              delayModifier += delayConfig;
                              delay = Parser2.parsePositiveNumber(previousConfig.delay,ItemWorker.DELAY_BETWEEN_ITEMS);
                              if(delay > 0)
                              {
                                 delayModifier += itemCount * delay;
                              }
                           }
                           itemCount = _itemWorker.dropItemsCallback(sectionConfig,delayModifier);
                           Logger.get().info("[Drop] " + sectionConfig.name + " : @" + delayModifier + "ms, " + itemCount + " items");
                           ShowHUDMessage("[Drop] " + sectionConfig.name + " : @" + delayModifier + "ms, " + itemCount + " items",Boolean(sectionConfig.showMessage));
                           previousConfig = sectionConfig;
                           if(itemCount > 0 && int(Math.random() * 50) == 49)
                           {
                              meow();
                           }
                        });
                     },delayBuildInventory);
                  }
                  return;
               }
            }
            previousConfig = null;
            if(ItemWorker.isConfigEnabled(this.config,CONSUME_ACTION))
            {
               delayConfig = Math.max(Parser2.parsePositiveNumber(this.config.consume.delay),ItemWorker.DELAY_BETWEEN_CONFIGS);
               matchingConfigs = this.config.consume.configs.filter(function(sectionConfig:Object):Boolean
               {
                  return ItemWorker.isMatchingConfigSection(e,sectionConfig);
               });
               if(matchingConfigs.length > 0)
               {
                  checkInactiveEffects = Boolean(matchingConfigs.some(function(sectionConfig:Object):Boolean
                  {
                     return sectionConfig.onlyInactiveEffects;
                  }));
                  delayUpdateEffects = 0;
                  if(checkInactiveEffects)
                  {
                     delayUpdateEffects = int(_itemWorker.openEffectsTab());
                  }
                  if(delayUpdateEffects != -1)
                  {
                     setTimeout(function():void
                     {
                        Logger.get().info(matchingConfigs.length + " consume configs, checkEffects: " + checkInactiveEffects);
                        delayBuildInventory = int(_itemWorker.buildInventory(matchingConfigs));
                        if(delayBuildInventory != -1)
                        {
                           setTimeout(function():void
                           {
                              matchingConfigs.forEach(function(sectionConfig:Object):void
                              {
                                 if(previousConfig)
                                 {
                                    delayModifier += delayConfig;
                                    delay = Parser2.parsePositiveNumber(previousConfig.delay,0);
                                    if(delay > 0)
                                    {
                                       delayModifier += itemCount * delay;
                                    }
                                 }
                                 itemCount = _itemWorker.consumeItemsCallback(sectionConfig,delayModifier);
                                 Logger.get().info("[Consume] " + sectionConfig.name + " : " + (delayModifier > 0 ? "@" + delayModifier + "ms, " : "") + itemCount + " items");
                                 ShowHUDMessage("[Consume] " + sectionConfig.name + " : " + (delayModifier > 0 ? "@" + delayModifier + "ms, " : "") + itemCount + " items",Boolean(sectionConfig.showMessage));
                                 previousConfig = sectionConfig;
                                 if(itemCount > 0 && int(Math.random() * 50) == 49)
                                 {
                                    meow();
                                 }
                              });
                           },delayBuildInventory);
                        }
                     },delayUpdateEffects);
                  }
                  return;
               }
            }
            if(Boolean(this.config.findForRepair) && Boolean(this.config.findForRepair.enabled) && e.keyCode == this.findForRepairKeyCode)
            {
               Logger.get().info("[FindForRepair] " + this.config.findForRepair.name);
               ShowHUDMessage("[FindForRepair] " + this.config.findForRepair.name,Boolean(this.config.findForRepair.showMessage));
               delayBuildInventory = int(_itemWorker.buildInventory([this.config.findForRepair]));
               if(delayBuildInventory != -1)
               {
                  setTimeout(_itemWorker.findRepairableItemCallback,delayBuildInventory,config.findForRepair);
               }
               return;
            }
            if(ItemProtection.isValidLockConfig(this.config.protectionConfig) && e.keyCode == this.lockAllKeyCode)
            {
               delayBuildInventory = int(_itemWorker.buildInventory([this.config.protectionConfig.itemLocking]));
               if(delayBuildInventory != -1)
               {
                  setTimeout(function():void
                  {
                     itemCount = _itemWorker.lockProtectedItemsCallback(config.protectionConfig);
                     Logger.get().info("[ItemLocking] " + itemCount + " items");
                     ShowHUDMessage("[ItemLocking] " + itemCount + " items",Boolean(config.protectionConfig.itemLocking.showMessage));
                  },delayBuildInventory);
               }
               return;
            }
         }
         if(e.keyCode == this.toggleDebugKeyCode)
         {
            Logger.get().debugMode = !Logger.DEBUG_MODE;
         }
      }
      
      public function meow() : void
      {
         setTimeout(function():void
         {
            GlobalFunc.PlayMenuSound("NPCCatMeowA");
         },1000 + Math.random() * 3000);
      }
      
      public function ShowHUDMessage(text:String, forceDisplay:Boolean = false) : void
      {
         if(forceDisplay)
         {
            GlobalFunc.ShowHUDMessage("[" + MOD_NAME + " v" + Version.MOD + "] " + text);
         }
      }
   }
}

