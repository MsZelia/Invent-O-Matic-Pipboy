package Shared.AS3.Styles
{
   import Shared.AS3.BSScrollingList;
   
   public class Pipboy_InvPage_ComponentOwnedListStyle
   {
      
      public static var listEntryClass_Inspectable:String = "ComponentOwnersListEntry";
      
      public static var numListItems_Inspectable:uint = 10;
      
      public static var textOption_Inspectable:String = BSScrollingList.TEXT_OPTION_SHRINK_TO_FIT;
      
      public static var restoreListIndex_Inspectable:Boolean = false;
       
      
      public function Pipboy_InvPage_ComponentOwnedListStyle()
      {
         super();
      }
   }
}
