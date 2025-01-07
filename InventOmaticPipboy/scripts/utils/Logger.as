package utils
{
   import com.adobe.serialization.json.JSON;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Logger
   {
      
      public static var DEBUG_MODE:Boolean = true;
      
      private static const USE_JSON:Boolean = true;
      
      private static var INSTANCE:Logger;
       
      
      private var _debugger:TextField;
      
      private var _textFormat:TextFormat;
      
      public function Logger(param1:TextField)
      {
         super();
         this._debugger = param1;
         this._debugger.visible = DEBUG_MODE;
         this._debugger.selectable = true;
         this._debugger.mouseWheelEnabled = true;
         this._debugger.mouseEnabled = true;
         this._debugger.useRichTextClipboard = true;
         this._textFormat = new TextFormat("$MAIN_Font",16,16777215);
         this._debugger.defaultTextFormat = this._textFormat;
         this._debugger.setTextFormat(this._textFormat);
      }
      
      public static function get() : Logger
      {
         return INSTANCE;
      }
      
      public static function init(param1:TextField) : void
      {
         INSTANCE = new Logger(param1);
         INSTANCE.info("###### INIT ######");
      }
      
      private static function convert(param1:Object) : String
      {
         var object:Object = param1;
         if(USE_JSON)
         {
            try
            {
               return com.adobe.serialization.json.JSON.encode(object);
            }
            catch(e:*)
            {
               if(object == null)
               {
                  return "null object";
               }
            }
         }
         return object.toString();
      }
      
      public function clear() : void
      {
         this._debugger.text = "";
      }
      
      public function set debugMode(param1:Boolean) : void
      {
         DEBUG_MODE = param1;
         this._debugger.visible = DEBUG_MODE;
      }
      
      public function debug(param1:Object) : void
      {
         if(!DEBUG_MODE)
         {
            return;
         }
         this._debugger.appendText("[DEBUG] " + convert(param1));
         this.nl();
      }
      
      public function error(param1:Object) : void
      {
         if(!DEBUG_MODE)
         {
            return;
         }
         this._debugger.appendText("[ERROR] " + convert(param1));
         this.nl();
      }
      
      public function info(param1:Object) : void
      {
         if(!DEBUG_MODE)
         {
            return;
         }
         this._debugger.appendText("[INFO] " + convert(param1));
         this.nl();
      }
      
      public function warn(param1:Object) : void
      {
         if(!DEBUG_MODE)
         {
            return;
         }
         this._debugger.appendText("[WARN] " + convert(param1));
         this.nl();
      }
      
      private function nl() : void
      {
         this._debugger.appendText("\n");
         this._debugger.appendText("-----------------");
         this._debugger.appendText("\n");
         this._debugger.scrollV = this._debugger.maxScrollV;
      }
      
      public function errorHandler(param1:String, param2:Error) : *
      {
         Logger.get().error(param1);
         try
         {
            Logger.get().error(param2);
         }
         catch(e:*)
         {
         }
         try
         {
            Logger.get().error(param2.name);
         }
         catch(e:*)
         {
         }
         try
         {
            Logger.get().error(param2.message);
         }
         catch(e:*)
         {
         }
         try
         {
            Logger.get().error(param2.getStackTrace());
         }
         catch(e:*)
         {
         }
      }
   }
}
