package
{
   import Shared.GlobalFunc;
   import utils.*;
   
   public class InventOmaticConfig
   {
      
      private static var _config:Object;
      
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
         var itemGroups:Object = config.itemNamesGroupConfig || {};
         config.protectionConfig = config.protectionConfig || {};
         config.protectionConfig.dropProtection = config.protectionConfig.dropProtection || {};
         var dropProtect:Object = config.protectionConfig.dropProtection;
         dropProtect.itemNames = expandItemGroups(itemGroups,dropProtect.itemNames || []);
         config.consume = config.consume || {};
         config.consume.configs = expandSubconfigs(config.consume.configs || [],"Consume");
         for each(var c in config.consume.configs)
         {
            c.itemNames = expandItemGroups(itemGroups,c.itemNames);
         }
         config.drop = config.drop || {};
         config.drop.configs = expandSubconfigs(config.drop.configs || [],"Drop");
         for each(c in config.drop.configs)
         {
            c.itemNames = expandItemGroups(itemGroups,c.itemNames);
            c.teenoodleTragedyProtection = c.teenoodleTragedyProtection || {};
            var ttp:Object = c.teenoodleTragedyProtection;
            if(ttp && ttp.excluded)
            {
               ttp.excluded = expandItemGroups(itemGroups,ttp.excluded);
            }
         }
         _config = config;
         return _config;
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
                     expanded.showMessage = c.showMessage;
                     expanded.closeMenu = c.subconfigs.length == 1 ? c.closeMenu : false;
                  }
                  else
                  {
                     expanded.showButton = false;
                     expanded.showMessage = false;
                     expanded.closeMenu = c.closeMenu && j == c.subconfigs.length;
                  }
                  expanded.enabled = sc.enabled != null ? sc.enabled : c.enabled;
                  expanded.testRun = sc.testRun != null ? sc.testRun : c.testRun;
                  expanded.delay = c.delay != null ? c.delay : sc.delay;
                  expanded.amount = sc.amount;
                  expanded.types = sc.types;
                  expanded.matchMode = sc.matchMode;
                  expanded.dropFavorite = sc.dropFavorite;
                  expanded.dropEquipped = sc.dropEquipped;
                  expanded.onlyInactiveEffects = sc.onlyInactiveEffects;
                  expanded.onlyIfNotEquipped = sc.onlyIfNotEquipped;
                  expanded.onlyIfEquipped = sc.onlyIfEquipped;
                  expanded.checkAccountName = sc.checkAccountName;
                  expanded.accountName = sc.accountName;
                  expanded.checkCharacterName = sc.checkCharacterName;
                  expanded.characterName = sc.characterName;
                  expanded.itemNames = sc.itemNames;
                  expanded.teenoodleTragedyProtection = GlobalFunc.CloneObject(sc.teenoodleTragedyProtection);
                  expanded.wasSubconfig = true;
                  allConfigs.push(expanded);
               }
            }
         }
         return allConfigs;
      }
   }
}

