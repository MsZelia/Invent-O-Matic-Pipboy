package utils
{
   public class Buttons
   {
       
      
      public function Buttons()
      {
         super();
      }
      
      public static function getButtonKey(keyCode:uint) : String
      {
         switch(keyCode)
         {
            case 9:
               return "Tab";
            case 13:
               return "Enter";
            case 16:
               return "Shift";
            case 17:
               return "Ctrl";
            case 18:
               return "Alt";
            case 19:
               return "Pause";
            case 20:
               return "CapLk";
            case 27:
               return "Esc";
            case 33:
               return "PgUp";
            case 34:
               return "PgDn";
            case 35:
               return "End";
            case 36:
               return "Home";
            case 37:
               return "Left";
            case 38:
               return "Up";
            case 39:
               return "Right";
            case 40:
               return "Down";
            case 45:
               return "Ins";
            case 46:
               return "Del";
            case 93:
               return "Sel";
            case 96:
               return "N0";
            case 97:
               return "N1";
            case 98:
               return "N2";
            case 99:
               return "N3";
            case 100:
               return "N4";
            case 101:
               return "N5";
            case 102:
               return "N6";
            case 103:
               return "N7";
            case 104:
               return "N8";
            case 105:
               return "N9";
            case 106:
               return "N*";
            case 107:
               return "N+";
            case 109:
               return "N-";
            case 110:
               return "N.";
            case 111:
               return "N/";
            case 112:
               return "F1";
            case 113:
               return "F2";
            case 114:
               return "F3";
            case 115:
               return "F4";
            case 116:
               return "F5";
            case 117:
               return "F6";
            case 118:
               return "F7";
            case 119:
               return "F8";
            case 120:
               return "F9";
            case 121:
               return "F10";
            case 122:
               return "F11";
            case 123:
               return "F12";
            case 144:
               return "NumLk";
            case 145:
               return "ScrLk";
            default:
               return String.fromCharCode(keyCode);
         }
      }
      
      public static function getButtonGamepad(keyCode:uint) : String
      {
         switch(keyCode)
         {
            case 37:
               return "_DPad_Left";
            case 38:
               return "_DPad_Up";
            case 39:
               return "_DPad_Right";
            case 40:
               return "_DPad_Down";
            default:
               return "_Question";
         }
      }
   }
}
