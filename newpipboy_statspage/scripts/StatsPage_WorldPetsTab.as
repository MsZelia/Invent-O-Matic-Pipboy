package
{
   import Shared.AS3.BSCollapsingList;
   import Shared.AS3.BSCollapsingListNode;
   import Shared.AS3.BSScrollingList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol20")]
   public class StatsPage_WorldPetsTab extends IPipBoyTab
   {
      
      public static var SelectedFormID:uint = 0;
      
      public static var ActiveCampPets:Array = new Array();
      
      public static const PROVIDER_DATA:* = 0;
      
      public static const PROVIDER_UPDATE_DATA:* = 1;
      
      public var List_mc:BSCollapsingList;
      
      public var VBHolder_mc:MovieClip;
      
      public var PetInfo_mc:WorldPetsInfoPanel;
      
      public var DisabledMessage_tf:TextField;
      
      public var InformationMessage_tf:TextField;
      
      private var m_CurrentData:Object;
      
      private var m_IsInitialized:Boolean = false;
      
      public function StatsPage_WorldPetsTab()
      {
         super();
         this.List_mc.listEntryClass_Inspectable = "WorldPetsListEntry";
         this.List_mc.numListItems_Inspectable = 9;
         this.List_mc.restoreListIndex_Inspectable = false;
         this.List_mc.selectedIndex = 0;
         this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
         this.List_mc.addEventListener(BSCollapsingListNode.INTERACT_EVENT,this.onItemPressed);
         this.List_mc.allowMultipleExpandedCategories = false;
         this.PetInfo_mc.visible = false;
      }
      
      override public function processProvider(aData:Object, aType:uint) : void
      {
         switch(aType)
         {
            case PROVIDER_DATA:
               this.processBaseData(aData);
               break;
            case PROVIDER_UPDATE_DATA:
               if(aData.Level > 0)
               {
                  this.processUpdate(aData);
               }
         }
      }
      
      public function processBaseData(aData:Object) : void
      {
         var showDisabledText:Boolean;
         SelectedFormID = aData.SelectedFormID;
         ActiveCampPets = aData.ActiveCampPets;
         this.m_CurrentData = aData;
         showDisabledText = Boolean(aData.DisabledReason);
         this.List_mc.visible = !showDisabledText;
         this.DisabledMessage_tf.visible = showDisabledText;
         this.InformationMessage_tf.visible = !showDisabledText;
         if(showDisabledText)
         {
            this.DisabledMessage_tf.text = aData.DisabledReason;
            this.PetInfo_mc.visible = false;
         }
         else
         {
            this.UpdateEntries();
            this.InformationMessage_tf.text = aData.InformationMessage;
            if(!this.m_IsInitialized)
            {
               this.List_mc.goToNode(function(node:BSCollapsingListNode):Boolean
               {
                  return node.isLeaf() && node.data != null && SelectedFormID == node.data.FormID;
               });
               this.m_IsInitialized = true;
            }
         }
      }
      
      public function processUpdate(aData:Object) : void
      {
         var selectedEntry:BSCollapsingListNode;
         var parentNode:* = undefined;
         var data:* = undefined;
         var parentData:* = undefined;
         var node:* = this.List_mc.findNode(function(node:BSCollapsingListNode):Boolean
         {
            return node.isLeaf() && SelectedFormID == node.data.FormID;
         });
         if(node != null)
         {
            node.data.HealthPercentage = aData.HealthPercentage;
            parentNode = node.parentNode;
            if(parentNode != null)
            {
               parentNode.data.Level = aData.Level;
               parentNode.data.ExperiencePercentage = aData.ExperiencePercentage;
            }
         }
         selectedEntry = this.List_mc.selectedEntry as BSCollapsingListNode;
         if(selectedEntry != null && selectedEntry.isLeaf() && selectedEntry.hasParent())
         {
            data = selectedEntry.data;
            parentData = selectedEntry.parentNode.data;
            this.PetInfo_mc.updateHealth(data.HealthPercentage);
            this.PetInfo_mc.updateLevel(parentData.Level,parentData.ExperiencePercentage,parentData.MaxLevel);
         }
      }
      
      private function UpdateEntries() : void
      {
         var species:* = undefined;
         var speciesNode:BSCollapsingListNode = null;
         var skin:* = undefined;
         var leaf:* = undefined;
         var state:* = this.List_mc.saveState(true);
         for each(species in this.m_CurrentData.Species)
         {
            speciesNode = new BSCollapsingListNode(species.Name.toUpperCase());
            speciesNode.data = species;
            this.List_mc.rootNode.append(speciesNode,false);
            for each(skin in species.Skins)
            {
               leaf = new BSCollapsingListNode(skin.Name);
               leaf.data = skin;
               speciesNode.append(leaf,false);
            }
         }
         this.List_mc.loadState(state,true);
      }
      
      override public function SetPlatform(auiPlatform:uint, abPS3Switch:Boolean, auiController:uint, auiKeyboard:uint) : void
      {
         this.List_mc.SetPlatform(auiPlatform,abPS3Switch,auiController,auiKeyboard);
      }
      
      override public function OnEntry() : void
      {
         stage.focus = this.List_mc;
      }
      
      public function onListSelectionChange(event:Event) : *
      {
         var currentNode:* = this.List_mc.selectedEntry as BSCollapsingListNode;
         if(Boolean(currentNode.isLeaf()) && Boolean(currentNode.hasParent()) && currentNode.data.FormID > 0)
         {
            this.displaySkinInfo(currentNode.data,currentNode.parentNode.data);
         }
         else
         {
            this.hideSkinInfo();
         }
      }
      
      private function displaySkinInfo(skin:Object, species:Object) : *
      {
         this.PetInfo_mc.updateHealth(skin.HealthPercentage);
         this.PetInfo_mc.updateLevel(species.Level,species.ExperiencePercentage,species.MaxLevel);
         this.PetInfo_mc.updateName(skin.DisplayName);
         this.PetInfo_mc.visible = true;
      }
      
      private function hideSkinInfo() : *
      {
         this.PetInfo_mc.visible = false;
      }
      
      public function onItemPressed(aEvent:Event) : *
      {
         var selectedEntry:* = this.List_mc.selectedEntry;
         if(selectedEntry != null)
         {
            if(selectedEntry.data.FormID != SelectedFormID)
            {
               if(selectedEntry.data.FormID > 0)
               {
               }
            }
            this.List_mc.UpdateList();
         }
      }
      
      override public function ProcessUserEvent(strEventName:String) : Boolean
      {
         var bhandled:Boolean = false;
         if(stage.focus == this.List_mc)
         {
            switch(strEventName)
            {
               case "Drop":
                  BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.STAT_OPEN_ATOMIC_SHOP,{}));
                  bhandled = true;
                  break;
               case "MoveCamp":
                  this.List_mc.goToPreviousCategory();
                  bhandled = true;
                  break;
               case "ShowOnMap":
                  this.List_mc.goToNextCategory();
                  bhandled = true;
            }
            if(!bhandled)
            {
               bhandled = this.List_mc.processUserEvent(strEventName,false);
            }
         }
         return bhandled;
      }
   }
}

