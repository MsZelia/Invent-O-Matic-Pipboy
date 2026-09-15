package Shared.AS3
{
   import flash.events.Event;
   
   public class BSCollapsingList extends BSScrollingList
   {
      
      private var m_RootNode:BSCollapsingListNode = new BSCollapsingListNode("Root");
      
      private var m_OverrideAllowMultipleExpandedCategories:Object = null;
      
      private var m_OverrideCollapseChildrenWhenCollapsingNode:Object = null;
      
      private var m_OverrideSupportBackAsGoToParent:Object = null;
      
      public function BSCollapsingList()
      {
         super();
         this.m_RootNode.expanded = true;
         this.m_RootNode.validBackTarget = false;
         this.m_RootNode.addEventListener(BSCollapsingListNode.HIERARCHY_UPDATE_EVENT,this.onHierarchyUpdate);
         this.m_RootNode.addEventListener(BSCollapsingListNode.UPDATE_EVENT,this.onUpdate);
         addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectionChange);
         addEventListener(BSScrollingList.ITEM_PRESS,this.onItemPressed);
         filterer.itemFilter = BSCollapsingListNode.VISIBLE_FILTER_FLAG;
      }
      
      public function get rootNode() : BSCollapsingListNode
      {
         return this.m_RootNode;
      }
      
      public function set allowMultipleExpandedCategories(newValue:Boolean) : *
      {
         this.m_OverrideAllowMultipleExpandedCategories = newValue;
      }
      
      public function set collapseChildrenWhenCollapsingNode(newValue:Boolean) : *
      {
         this.m_OverrideCollapseChildrenWhenCollapsingNode = newValue;
      }
      
      public function set supportBackAsGoToParent(newValue:Boolean) : *
      {
         this.m_OverrideSupportBackAsGoToParent = newValue;
      }
      
      public function buildEntries() : *
      {
         entryList = new Array();
         this.buildEntriesRecursive(this.m_RootNode);
         this.processOverrides(this.m_RootNode);
         InvalidateData();
      }
      
      private function buildEntriesRecursive(aNode:BSCollapsingListNode) : *
      {
         var child:BSCollapsingListNode = null;
         for each(child in aNode.children)
         {
            this.processOverrides(child);
            child.itemIndex = entryList.length;
            entryList.push(child);
            if(child.isCategory())
            {
               this.buildEntriesRecursive(child);
            }
         }
      }
      
      private function processOverrides(aNode:BSCollapsingListNode) : *
      {
         if(this.m_OverrideAllowMultipleExpandedCategories != null)
         {
            aNode.allowMultipleExpandedCategories = this.m_OverrideAllowMultipleExpandedCategories;
         }
         if(this.m_OverrideCollapseChildrenWhenCollapsingNode != null)
         {
            aNode.collapseSubWhenCollapsing = this.m_OverrideCollapseChildrenWhenCollapsingNode;
         }
         if(this.m_OverrideSupportBackAsGoToParent != null)
         {
            aNode.validBackTarget = this.m_OverrideSupportBackAsGoToParent;
         }
      }
      
      public function goToNode(aFilterFunction:Function) : *
      {
         var newIndex:* = this.goToNodeRecursive(this.m_RootNode,aFilterFunction);
         if(newIndex >= 0)
         {
            selectedIndex = newIndex;
         }
      }
      
      private function goToNodeRecursive(aNode:BSCollapsingListNode, aFilterFunction:Function) : int
      {
         var child:BSCollapsingListNode = null;
         var index:int = -1;
         if(aFilterFunction(aNode))
         {
            index = int(aNode.itemIndex);
         }
         else
         {
            for each(child in aNode.children)
            {
               if(child.isCategory())
               {
                  index = this.goToNodeRecursive(child,aFilterFunction);
                  if(index >= 0)
                  {
                     child.expand();
                     break;
                  }
               }
               else if(aFilterFunction(child))
               {
                  index = int(child.itemIndex);
                  break;
               }
            }
         }
         return index;
      }
      
      public function findNode(aFilterFunction:Function) : BSCollapsingListNode
      {
         return this.findNodeRecursive(this.m_RootNode,aFilterFunction);
      }
      
      private function findNodeRecursive(aNode:BSCollapsingListNode, aFilterFunction:Function) : BSCollapsingListNode
      {
         var child:BSCollapsingListNode = null;
         var node:BSCollapsingListNode = null;
         if(aFilterFunction(aNode))
         {
            node = aNode;
         }
         else
         {
            for each(child in aNode.children)
            {
               if(child.isCategory())
               {
                  node = this.findNodeRecursive(child,aFilterFunction);
                  if(node != null)
                  {
                     break;
                  }
               }
               else if(aFilterFunction(child))
               {
                  node = child;
                  break;
               }
            }
         }
         return node;
      }
      
      public function saveState(abReset:Boolean = false) : Object
      {
         var state:* = this.m_RootNode.saveState(selectedIndex);
         state["ScrollPosition"] = scrollPosition;
         if(abReset)
         {
            this.m_RootNode.clear(false);
         }
         return state;
      }
      
      public function loadState(aState:Object, abHasModifiedData:Boolean = true) : *
      {
         if(abHasModifiedData)
         {
            this.buildEntries();
         }
         this.m_RootNode.loadState(aState);
         if(abHasModifiedData)
         {
            InvalidateData();
            scrollPosition = aState["ScrollPosition"] as uint;
            this.m_RootNode.loadSelected(aState,this);
         }
      }
      
      private function onHierarchyUpdate(event:Event) : *
      {
         this.buildEntries();
      }
      
      private function onUpdate(event:Event) : *
      {
         InvalidateData();
      }
      
      private function onItemPressed(event:Event) : *
      {
         var node:* = selectedEntry;
         if(node != null)
         {
            if(node.isCategory())
            {
               node.toggle();
            }
            else
            {
               event = new Event(BSCollapsingListNode.INTERACT_EVENT,true,true);
               node.dispatchEvent(event);
               dispatchEvent(event);
            }
         }
      }
      
      private function onSelectionChange(event:Event) : *
      {
         var node:* = selectedEntry;
         if(node != null)
         {
            node.dispatchEvent(new Event(BSCollapsingListNode.SELECT_EVENT,true,true));
         }
      }
      
      public function goToPreviousCategory() : *
      {
         var index:* = undefined;
         var comparedNode:* = undefined;
         var bhandled:* = false;
         var node:* = selectedEntry as BSCollapsingListNode;
         if(node != null && node.parentNode != null)
         {
            if(node.isCategory())
            {
               index = node.itemIndex - 1;
               while(index >= node.parentNode.itemIndex && index >= 0)
               {
                  comparedNode = entryList[index] as BSCollapsingListNode;
                  if(comparedNode != null && comparedNode.isCategory() && comparedNode.level >= node.level)
                  {
                     selectedIndex = index;
                     bhandled = true;
                     break;
                  }
                  index--;
               }
            }
            else
            {
               this.goToParent();
            }
         }
         return bhandled;
      }
      
      public function goToNextCategory() : Boolean
      {
         var index:* = undefined;
         var comparedNode:* = undefined;
         var bhandled:* = false;
         var node:* = selectedEntry as BSCollapsingListNode;
         if(node != null)
         {
            for(index = node.itemIndex + 1; index < entryList.length; index++)
            {
               comparedNode = entryList[index] as BSCollapsingListNode;
               if(comparedNode != null && comparedNode.isCategory() && comparedNode.level >= node.level)
               {
                  selectedIndex = index;
                  bhandled = true;
                  break;
               }
            }
         }
         return bhandled;
      }
      
      public function goToParent() : Boolean
      {
         var bhandled:* = false;
         var entry:* = selectedEntry;
         if(entry.parentNode != null && entry.parentNode.validBackTarget && !entry.parentNode.isRoot())
         {
            selectedIndex = entry.parentNode.itemIndex;
            bhandled = true;
         }
         return bhandled;
      }
      
      public function processUserEvent(strEventName:String, abPressed:Boolean) : Boolean
      {
         var bhandled:Boolean = false;
         if(!abPressed && stage.focus == this && selectedIndex > -1)
         {
            switch(strEventName)
            {
               case "Left":
               case "Cancel":
                  bhandled = this.goToParent();
                  break;
               case "LShoulder":
               case "PrevCategory":
                  bhandled = this.goToPreviousCategory();
                  break;
               case "RShoulder":
               case "NextCategory":
                  bhandled = this.goToNextCategory();
            }
         }
         return bhandled;
      }
   }
}

