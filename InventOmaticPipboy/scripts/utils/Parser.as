package utils
{
   public class Parser
   {
      
      public function Parser()
      {
         super();
      }
      
      public static function parsePositiveNumber(obj:Object, defaultValue:Object = 0) : *
      {
         if(obj != null)
         {
            var value:* = Number(obj);
            if(!isNaN(value) && value > 0)
            {
               return value;
            }
         }
         return defaultValue;
      }
      
      public static function parseNumber(obj:Object, defaultValue:Object = 0) : *
      {
         if(obj != null)
         {
            var value:* = Number(obj);
            if(!isNaN(value))
            {
               return value;
            }
         }
         return defaultValue;
      }
      
      public static function parseHotkey(config:Object, defaultValue:Object) : *
      {
         var oHotkey:Object = config;
         if(oHotkey != null)
         {
            if(oHotkey.hasOwnProperty("hotkey"))
            {
               oHotkey = oHotkey.hotkey;
            }
            if(oHotkey is String)
            {
               return Buttons.getButtonValue(oHotkey) || defaultValue;
            }
            return parsePositiveNumber(oHotkey,defaultValue);
         }
         return defaultValue;
      }
      
      public static function parseBoolean(obj:Object, defaultValue:Object = false) : *
      {
         if(obj != null)
         {
            return Boolean(obj);
         }
         return defaultValue;
      }
   }
}

