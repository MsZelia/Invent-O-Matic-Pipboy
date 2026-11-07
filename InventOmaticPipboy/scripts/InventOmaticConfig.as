package
{
   import Shared.GlobalFunc;
   import utils.*;
   
   public class InventOmaticConfig
   {
      
      private static var _config:Object;
      
      public static const MIN_DELAY:uint = 20;
      
      public static const DELAY_BETWEEN_ITEMS:uint = 20;
      
      public static const DELAY_BETWEEN_CONFIGS:uint = 100;
      
      public static const DELAY_BETWEEN_TABS:uint = 250;
      
      public static const DELAY_CLOSE_MENU:uint = 500;
      
      public function InventOmaticConfig()
      {
         super();
      }
      
      public static function get() : Object
      {
         return _config;
      }
      
      public static function init(jsonObject:*) : Object
      {
         var config:* = jsonObject;
         config.delayCloseMenu = Math.max(Parser2.parsePositiveNumber(config.delayCloseMenu,DELAY_CLOSE_MENU),DELAY_CLOSE_MENU);
         config.delayTabSwitching = Math.max(Parser2.parsePositiveNumber(config.delayTabSwitching,DELAY_BETWEEN_TABS),DELAY_BETWEEN_TABS);
         var itemGroups:Object = config.itemNamesGroupConfig || {};
         config.protectionConfig = config.protectionConfig || {};
         config.protectionConfig.checkOnSelectionChange = Parser2.parseBoolean(config.protectionConfig.checkOnSelectionChange,true);
         config.protectionConfig.itemLocking = config.protectionConfig.itemLocking || {};
         config.protectionConfig.itemLocking.delay = Math.max(Parser2.parsePositiveNumber(config.protectionConfig.itemLocking.delay,DELAY_BETWEEN_ITEMS),MIN_DELAY);
         config.protectionConfig.dropProtection = config.protectionConfig.dropProtection || {};
         var dropProtect:Object = config.protectionConfig.dropProtection;
         dropProtect.itemNames = expandItemGroups(itemGroups,dropProtect.itemNames || []);
         config.findForRepair = config.findForRepair || {};
         config.findForRepair.repeatAfter = Parser2.parsePositiveNumber(config.findForRepair.repeatAfter,0);
         config.consume = config.consume || {};
         config.consume.delay = Math.max(Parser2.parsePositiveNumber(config.consume.delay,DELAY_BETWEEN_CONFIGS),DELAY_BETWEEN_CONFIGS);
         config.consume.configs = expandSubconfigs(config.consume.configs || [],"Consume");
         for each(var c in config.consume.configs)
         {
            c.itemNames = expandItemGroups(itemGroups,c.itemNames);
            c.itemNames = expandItemAlternatives(c);
            c.delay = Math.max(Parser2.parsePositiveNumber(c.delay,DELAY_BETWEEN_ITEMS),MIN_DELAY);
            c.matchModeEffects = c.matchModeEffects != null ? c.matchModeEffects : MatchMode.CONTAINS;
            if(c.matchMode != MatchMode.EXACT && c.matchModeEffects == MatchMode.EXACT)
            {
               c.matchModeEffects = MatchMode.CONTAINS;
            }
         }
         config.drop = config.drop || {};
         config.drop.delay = Math.max(Parser2.parsePositiveNumber(config.drop.delay,DELAY_BETWEEN_CONFIGS),DELAY_BETWEEN_CONFIGS);
         config.drop.configs = expandSubconfigs(config.drop.configs || [],"Drop");
         for each(c in config.drop.configs)
         {
            c.itemNames = expandItemGroups(itemGroups,c.itemNames);
            c.ignoreItemNames = expandItemGroups(itemGroups,c.ignoreItemNames);
            c.delay = Math.max(Parser2.parsePositiveNumber(c.delay,DELAY_BETWEEN_ITEMS),MIN_DELAY);
            convertTTP(itemGroups,c);
            c.ignoreItemNames = filterIgnoreItemNames(c.ignoreItemNames);
         }
         config.testRunOverride = loadTestRunOverrideConfig(config.testRunOverride);
         config.cancelCloseMenuHotkey = Parser2.parseHotkey(config.cancelCloseMenuHotkey,0);
         _config = config;
         return _config;
      }
      
      public static function convertTTP(itemGroups:Object, config:Object) : void
      {
         var ttp:Object = config.teenoodleTragedyProtection;
         if(ttp)
         {
            if(ttp.excluded != null)
            {
               ttp.excluded = expandItemGroups(itemGroups,ttp.excluded);
               config.ignoreItemNames = config.ignoreItemNames.concat(ttp.excluded);
            }
            if(ttp.ignoreLegendaries != null)
            {
               config.dropLegendaries = config.dropLegendaries != null ? !ttp.ignoreLegendaries && config.dropLegendaries : !ttp.ignoreLegendaries;
            }
            if(ttp.ignoreUniques != null)
            {
               config.dropUniques = config.dropUniques != null ? !ttp.ignoreUniques && config.dropUniques : !ttp.ignoreUniques;
            }
            if(ttp.ignoreNonTradable != null)
            {
               config.dropNonTradable = config.dropNonTradable != null ? !ttp.ignoreNonTradable && config.dropNonTradable : !ttp.ignoreNonTradable;
            }
         }
      }
      
      public static function filterIgnoreItemNames(itemNames:Array) : Array
      {
         return itemNames.filter(function(name:*):Boolean
         {
            return name is String && Boolean(name.length);
         }).map(function(name:*):String
         {
            return name.toLowerCase();
         });
      }
      
      public static function expandItemAlternatives(config:Object) : Array
      {
         var i:int = 0;
         var itemNames:Array = new Array(config.itemNames.length);
         while(i < config.itemNames.length)
         {
            itemNames[i] = new Array();
            if(config.itemNames[i] is Array)
            {
               for each(var item in config.itemNames[i])
               {
                  itemNames[i].push(item);
               }
            }
            else if(config.itemNames[i] is String)
            {
               itemNames[i].push(config.itemNames[i]);
            }
            if(config.altItemNames && config.altItemNames.length > i)
            {
               if(config.altItemNames[i] is Array)
               {
                  for each(item in config.altItemNames[i])
                  {
                     itemNames[i].push(item);
                  }
               }
               else if(config.altItemNames[i] is String)
               {
                  itemNames[i].push(config.altItemNames[i]);
               }
            }
            i++;
         }
         return itemNames;
      }
      
      private static function expandItemGroups(itemGroups:Object, originalNames:Array) : Array
      {
         var itemNames:Array = [];
         for each(var nameOrNames in originalNames)
         {
            if(nameOrNames is Array)
            {
               var resolvedChoices:Array = [];
               for each(var n in nameOrNames)
               {
                  resolvedChoices = resolvedChoices.concat(itemGroups[n] || [n]);
               }
               itemNames.push(resolvedChoices);
            }
            else
            {
               itemNames = itemNames.concat(itemGroups[nameOrNames] || [nameOrNames]);
            }
         }
         return itemNames;
      }
      
      private static function expandSubconfigs(configs:Array, namePrefix:String) : Array
      {
         var allConfigs:Array = [];
         var i:int = 0;
         for each(var c in configs)
         {
            i += 1;
            c.name = c.name || namePrefix + " config " + i;
            if(c.subconfigs != null && c.itemNames != null)
            {
               Logger.get().error(namePrefix + " config " + c.name + ": Only one of itemNames or subconfig allowed.");
            }
            else if(c.subconfigs == null && c.itemNames != null)
            {
               c.wasSubconfig = false;
               allConfigs.push(c);
            }
            else if(c.subconfigs != null && c.itemNames == null)
            {
               var j:int = 0;
               for each(var sc in c.subconfigs)
               {
                  j += 1;
                  sc.name = c.name + "/" + (sc.name || "subconfig " + j);
                  var expanded:Object = GlobalFunc.CloneObject(c);
                  if(j == 1)
                  {
                     expanded.showButton = c.showButton;
                     expanded.showMessage = c.subconfigs.length == 1 ? c.showMessage : false;
                     expanded.closeMenu = c.subconfigs.length == 1 ? c.closeMenu : false;
                  }
                  else
                  {
                     expanded.showButton = false;
                     expanded.showMessage = c.showMessage && j == c.subconfigs.length;
                     expanded.closeMenu = c.closeMenu && j == c.subconfigs.length;
                  }
                  expanded.enabled = sc.enabled != null ? sc.enabled : c.enabled;
                  expanded.testRun = sc.testRun != null ? sc.testRun : c.testRun;
                  expanded.delay = sc.delay != null ? sc.delay : c.delay;
                  expanded.amount = sc.amount;
                  expanded.types = sc.types;
                  expanded.matchMode = sc.matchMode;
                  expanded.matchModeEffects = sc.matchModeEffects;
                  expanded.dropFavorite = sc.dropFavorite != null ? sc.dropFavorite : c.dropFavorite;
                  expanded.dropEquipped = sc.dropEquipped != null ? sc.dropEquipped : c.dropEquipped;
                  expanded.dropUniques = sc.dropUniques != null ? sc.dropUniques : c.dropUniques;
                  expanded.dropLegendaries = sc.dropLegendaries != null ? sc.dropLegendaries : c.dropLegendaries;
                  expanded.dropNonTradable = sc.dropNonTradable != null ? sc.dropNonTradable : c.dropNonTradable;
                  expanded.dropTaggedForSearch = sc.dropTaggedForSearch != null ? sc.dropTaggedForSearch : c.dropTaggedForSearch;
                  expanded.onlyInactiveEffects = sc.onlyInactiveEffects != null ? sc.onlyInactiveEffects : c.onlyInactiveEffects;
                  expanded.onlyIfNotEquipped = sc.onlyIfNotEquipped != null ? sc.onlyIfNotEquipped : c.onlyIfNotEquipped;
                  expanded.onlyIfEquipped = sc.onlyIfEquipped != null ? sc.onlyIfEquipped : c.onlyIfEquipped;
                  expanded.checkAccountName = sc.checkAccountName != null ? sc.checkAccountName : c.checkAccountName;
                  expanded.accountName = sc.accountName != null ? sc.accountName : c.accountName;
                  expanded.checkCharacterName = sc.checkCharacterName != null ? sc.checkCharacterName : c.checkCharacterName;
                  expanded.characterName = sc.characterName != null ? sc.characterName : c.characterName;
                  expanded.itemNames = sc.itemNames;
                  expanded.ignoreItemNames = sc.ignoreItemNames;
                  expanded.teenoodleTragedyProtection = GlobalFunc.CloneObject(sc.teenoodleTragedyProtection);
                  expanded.wasSubconfig = true;
                  allConfigs.push(expanded);
               }
            }
         }
         return allConfigs;
      }
      
      private static function loadTestRunOverrideConfig(config:*) : *
      {
         if(config == null)
         {
            config = {};
         }
         config.enabled = Parser2.parseBoolean(config.enabled,false);
         config.overrideMode = config.overrideMode != null ? config.overrideMode.toUpperCase() : TestrunOverrideMode.FORCE_ON;
         config.hotkey = Parser2.parseHotkey(config,17);
         config.showText = Parser2.parseBoolean(config.showText,true);
         config.x = Parser2.parseNumber(config.x,0);
         config.y = Parser2.parseNumber(config.y,0);
         config.textSize = Parser2.parsePositiveNumber(config.textSize,18);
         config.textFont = config.textFont != null ? config.textFont : "$MAIN_Font_Bold";
         config.textAlign = config.textAlign != null ? config.textAlign.toLowerCase() : "left";
         config.textDisabled = config.textDisabled != null ? config.textDisabled : "Hold {hotkey}) TestRun";
         config.textEnabled = config.textEnabled != null ? config.textEnabled : "TestRun Override ON";
         config.colorDisabled = Parser2.parsePositiveNumber(config.colorDisabled,GlobalFunc.COLOR_TEXT_BODY);
         config.colorEnabled = Parser2.parsePositiveNumber(config.colorEnabled,GlobalFunc.COLOR_TEXT_HEADER);
         return config;
      }
   }
}

