package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol20")]
   public dynamic class StatsPage_WorldPetsTab extends MovieClip
   {
      
      public var DisabledMessage_tf:TextField;
      
      public var InformationMessage_tf:TextField;
      
      public var List_mc:WorldPetsList;
      
      public var PetInfo_mc:WorldPetsInfoPanel;
      
      public var VBHolder_mc:MovieClip;
      
      public function StatsPage_WorldPetsTab()
      {
         super();
      }
   }
}

