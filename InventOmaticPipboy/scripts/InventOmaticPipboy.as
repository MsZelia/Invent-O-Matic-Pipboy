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
       
      
      public var debugLogger:TextField;
      
      public var _parent:*;
      
      public var _itemWorker:ItemWorker;
      
      public var _activeEffects:Array;
      
      public var _lastPipboyChangeEventData:*;
      
      public var pipboyMenu:*;
      
      public var config:Object;
      
      public var consumeButtons:Vector.<BSButtonHintData>;
      
      public var dropButtons:Vector.<BSButtonHintData>;
      
      public var findButton:BSButtonHintData;
      
      public var toggleDebugKeyCode:uint = 76;
      
      public var findForRepairKeyCode:uint = 75;
      
      public function InventOmaticPipboy()
      {
         super();
         Logger.DEBUG_MODE = false;
         Logger.init(this.debugLogger);
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      private static function toString(param1:Object) : String
      {
         return new JSONEncoder(param1).getString();
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         var movieRoot:* = stage.getChildAt(0);
         this.pipboyMenu = "Menu_mc" in movieRoot ? movieRoot.Menu_mc : null;
         if(Boolean(this.pipboyMenu) && getQualifiedClassName(this.pipboyMenu) == "PipboyMenu")
         {
            if(getQualifiedClassName(this.pipboyMenu.CurrentPage) == "Pipboy_InvPage")
            {
               this._parent = this.pipboyMenu.CurrentPage;
               this._itemWorker = new ItemWorker(this._parent);
               this.loadConfig();
               this.init();
            }
            else
            {
               Logger.DEBUG_MODE = true;
               Logger.get().error("Pipboy_InvPage not found");
            }
         }
         else
         {
            Logger.DEBUG_MODE = true;
            Logger.get().error("Not injected into PipboyMenu");
         }
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
            if(ItemProtection.isProtected(item,this.config.protectionConfig.dropProtection))
            {
               if(this.config.protectionConfig.debug)
               {
                  Logger.get().info(item.text + " is Drop protected: " + ItemProtection.ProtectionReason + " (" + (getTimer() - t1) + "ms)");
               }
               return true;
            }
            if(this.config.protectionConfig.debug)
            {
               Logger.get().info(item.text + " is not Drop protected (" + (getTimer() - t1) + "ms)");
            }
            return false;
         }
         catch(e:Error)
         {
            Logger.get().error("Error checking Item Protection " + e);
            ShowHUDMessage("Error checking Item Protection " + e,true);
         }
         return false;
      }
      
      private function init() : void
      {
         try
         {
            stage.getChildAt(0)["InventOmaticPipboy"] = this;
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
            stage.addEventListener(PipboyChangeEvent.PIPBOY_CHANGE_EVENT,this.pipboyChangeEvent,false,1);
            Logger.get().info("Mod initialized");
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error adding key listener",e);
         }
      }
      
      private function pipboyChangeEvent(param1:PipboyChangeEvent) : void
      {
         _activeEffects = param1.DataObj.ActiveEffects;
         _lastPipboyChangeEventData = param1.DataObj;
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
            consumeButtons = new Vector.<BSButtonHintData>();
            dropButtons = new Vector.<BSButtonHintData>();
            findButton = null;
            if(this.config)
            {
               this.toggleDebugKeyCode = Parser.parsePositiveNumber(config.toggleDebugHotkey,this.toggleDebugKeyCode);
               this.findForRepairKeyCode = Parser.parseHotkey(config.findForRepair,this.findForRepairKeyCode);
               if(config.orderButtons == null || !(config.orderButtons is Array))
               {
                  config.orderButtons = [DROP_ACTION,CONSUME_ACTION,FIND_ACTION];
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
                                 parentClip.buttonHintDataV.push(button);
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
                                 parentClip.buttonHintDataV.push(button);
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
                              parentClip.buttonHintDataV.push(findButton);
                           }
                        }
                        break;
                  }
                  buttonIndex++;
               }
            }
            Logger.get().info("Buttons initialized");
            this.pipboyMenu.ButtonHintBar_mc.SetButtonHintData(_parent.buttonHintDataV);
            Logger.get().info("Buttons Reset");
         }
         catch(e:Error)
         {
            Logger.get().errorHandler("Error initializing buttons",e);
         }
      }
      
      private function initDurabilityValue() : void
      {
         var val:Boolean = Parser.parseBoolean(this.config.showDurabilityValue,true);
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
                  pipboyMenu.CurrentPage.CampPlaceProtectionCount = Parser.parsePositiveNumber(config.campPlaceProtectionCount,1);
                  if(config.protectionConfig != null)
                  {
                     pipboyMenu.CurrentPage.checkItemProtectionOnSelectionChange(Parser.parseBoolean(config.protectionConfig.checkOnSelectionChange,true));
                  }
                  initButtonHints();
                  if(!config.hideLoadMessage)
                  {
                     ShowHUDMessage("Config file is loaded!",true);
                  }
                  Logger.get().info("Config file is loaded!");
               }
               catch(e:Error)
               {
                  ShowHUDMessage("Error loading config " + e,true);
                  Logger.get().error("Error loading config " + e);
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
            }
         }
         else if(param1.keyCode == Keyboard.F10)
         {
            if(this.config.testExternal is String)
            {
               if(this.parentClip.BGSCodeObj[this.config.testExternal] == null)
               {
                  Logger.get().info("Ext doesn\'t exist: " + this.config.testExternal);
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
                     this.config.testEventData[i] = this.parentClip.selectedListEntry.serverHandleId;
                  }
                  else if(i == "serverHandleId")
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
               var data:String = new JSONEncoder(apiData).getString();
               Logger.get().info("Retrieve data for: " + config.testMethod);
               Logger.get().info(data);
            }
         }
      }
      
      private function keyUpHandler(param1:KeyboardEvent) : void
      {
         var e:KeyboardEvent = param1;
         var delayModifier:int = 0;
         var delay:int = 0;
         var delayConfig:int = 0;
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
               delayConfig = Parser.parsePositiveNumber(this.config.drop.delay,ItemWorker.DELAY_BETWEEN_CONFIGS);
               this.config.drop.configs.forEach(function(sectionConfig:Object):void
               {
                  if(ItemWorker.isMatchingConfigSection(e,sectionConfig))
                  {
                     if(previousConfig)
                     {
                        delayModifier += delayConfig;
                        delay = Parser.parsePositiveNumber(previousConfig.delay,ItemWorker.DELAY_BETWEEN_ITEMS);
                        if(delay > 0)
                        {
                           delayModifier += itemCount * delay;
                        }
                     }
                     itemCount = _itemWorker.dropItemsCallback(sectionConfig,delayModifier);
                     Logger.get().info("[Drop] " + sectionConfig.name + " : " + (delayModifier > 0 ? "@" + delayModifier + "ms, " : "") + itemCount + " items");
                     ShowHUDMessage("[Drop] " + sectionConfig.name + " : " + (delayModifier > 0 ? "@" + delayModifier + "ms, " : "") + itemCount + " items",Boolean(sectionConfig.showMessage));
                     previousConfig = sectionConfig;
                     if(itemCount > 0 && int(Math.random() * 100) == 99)
                     {
                        meow();
                     }
                  }
               });
            }
            previousConfig = null;
            if(ItemWorker.isConfigEnabled(this.config,CONSUME_ACTION))
            {
               delayConfig = Parser.parsePositiveNumber(this.config.consume.delay,ItemWorker.DELAY_BETWEEN_CONFIGS);
               this.config.consume.configs.forEach(function(sectionConfig:Object):void
               {
                  if(ItemWorker.isMatchingConfigSection(e,sectionConfig))
                  {
                     if(Boolean(this._activeEffects) && this._activeEffects.length > 0)
                     {
                        _itemWorker.activeEffects = this._activeEffects;
                        if(Boolean(sectionConfig.onlyInactiveEffects))
                        {
                           Logger.get().info("Active effects: " + _itemWorker.activeEffects.map(function(ef2:*):*
                           {
                              return ef2.text;
                           }).join(", "));
                        }
                     }
                     else
                     {
                        Logger.get().error("Active effects not found: " + this._activeEffects);
                     }
                     if(previousConfig)
                     {
                        delayModifier += delayConfig;
                        delay = Parser.parsePositiveNumber(previousConfig.delay,0);
                        if(delay > 0)
                        {
                           delayModifier += itemCount * delay;
                        }
                     }
                     itemCount = _itemWorker.consumeItemsCallback(sectionConfig,delayModifier);
                     Logger.get().info("[Consume] " + sectionConfig.name + " : " + (delayModifier > 0 ? "@" + delayModifier + "ms, " : "") + itemCount + " items");
                     ShowHUDMessage("[Consume] " + sectionConfig.name + " : " + (delayModifier > 0 ? "@" + delayModifier + "ms, " : "") + itemCount + " items",Boolean(sectionConfig.showMessage));
                     previousConfig = sectionConfig;
                     if(itemCount > 0 && int(Math.random() * 100) == 99)
                     {
                        meow();
                     }
                  }
               });
            }
            if(Boolean(this.config.findForRepair) && Boolean(this.config.findForRepair.enabled) && e.keyCode == this.findForRepairKeyCode)
            {
               Logger.get().info("[FindForRepair] " + this.config.findForRepair.name);
               ShowHUDMessage("[FindForRepair] " + this.config.findForRepair.name,Boolean(this.config.findForRepair.showMessage));
               _itemWorker.findRepairableItemCallback(this.config.findForRepair);
            }
         }
         if(param1.keyCode == this.toggleDebugKeyCode)
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
