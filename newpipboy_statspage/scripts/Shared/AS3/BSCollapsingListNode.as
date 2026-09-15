package Shared.AS3
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class BSCollapsingListNode extends EventDispatcher
   {
      
      public static const SELECT_EVENT:String = "BSCollapsingList::Select";
      
      public static const INTERACT_EVENT:String = "BSCollapsingList::Interact";
      
      public static const COLLAPSE_EVENT:String = "BSCollapsingList::Collapse";
      
      public static const EXPAND_EVENT:String = "BSCollapsingList::Expand";
      
      public static const HIERARCHY_UPDATE_EVENT:String = "BSCollapsingList::HierarchyUpdate";
      
      public static const UPDATE_EVENT:String = "BSCollapsingList::Update";
      
      public static const VISIBLE_FILTER_FLAG:int = 1 << 1;
      
      public var filterFlag:int = 0;
      
      private var m_Parent:BSCollapsingListNode = null;
      
      private var m_NodeName:String;
      
      private var m_Visible:Boolean = true;
      
      private var m_ItemIndex:uint = 0;
      
      private var m_Data:Object;
      
      private var m_Children:Array = new Array();
      
      private var m_Level:uint = 0;
      
      private var m_Expanded:Boolean = false;
      
      private var m_AllowMultipleExpandedCategories:Boolean = true;
      
      private var m_CollapseSubWhenCollapsing:Boolean = true;
      
      private var m_ValidBackTarget:Boolean = true;
      
      public function BSCollapsingListNode(nodeName:String)
      {
         super();
         this.m_NodeName = nodeName;
      }
      
      public function get parentNode() : BSCollapsingListNode
      {
         return this.m_Parent;
      }
      
      public function set parentNode(newValue:BSCollapsingListNode) : *
      {
         this.m_Parent = newValue;
      }
      
      public function get data() : Object
      {
         return this.m_Data;
      }
      
      public function set data(newValue:Object) : *
      {
         this.m_Data = newValue;
      }
      
      public function get nodeName() : String
      {
         return this.m_NodeName;
      }
      
      public function set nodeName(newValue:String) : *
      {
         this.m_NodeName = newValue;
      }
      
      public function get itemIndex() : uint
      {
         return this.m_ItemIndex;
      }
      
      public function set itemIndex(newValue:uint) : *
      {
         this.m_ItemIndex = newValue;
      }
      
      public function get level() : uint
      {
         return this.m_Level;
      }
      
      public function set level(newValue:uint) : *
      {
         this.m_Level = newValue;
      }
      
      public function get expanded() : Boolean
      {
         return this.m_Expanded;
      }
      
      public function set expanded(newValue:Boolean) : *
      {
         this.m_Expanded = newValue;
      }
      
      public function get visible() : Boolean
      {
         return this.m_Visible;
      }
      
      public function set visible(newValue:Boolean) : *
      {
         this.m_Visible = newValue;
         this.updateVisibility();
      }
      
      public function get allowMultipleExpandedCategories() : Boolean
      {
         return this.m_AllowMultipleExpandedCategories;
      }
      
      public function set allowMultipleExpandedCategories(newValue:Boolean) : *
      {
         this.m_AllowMultipleExpandedCategories = newValue;
      }
      
      public function get collapseSubWhenCollapsing() : Boolean
      {
         return this.m_CollapseSubWhenCollapsing;
      }
      
      public function set collapseSubWhenCollapsing(newValue:Boolean) : *
      {
         this.m_CollapseSubWhenCollapsing = newValue;
      }
      
      public function get validBackTarget() : Boolean
      {
         return this.m_ValidBackTarget;
      }
      
      public function set validBackTarget(newValue:Boolean) : *
      {
         this.m_ValidBackTarget = newValue;
      }
      
      public function get children() : Array
      {
         return this.m_Children;
      }
      
      public function isLeaf() : Boolean
      {
         return this.m_Children.length == 0;
      }
      
      public function isCategory() : Boolean
      {
         return this.m_Children.length > 0;
      }
      
      public function hasParent() : Boolean
      {
         return this.m_Parent != null;
      }
      
      public function isRoot() : Boolean
      {
         return this.m_Parent == null;
      }
      
      public function append(child:BSCollapsingListNode, abTriggerUpdate:Boolean = true) : *
      {
         if(child.parentNode == null)
         {
            this.m_Children.push(child);
            child.parentNode = this;
            child.level = this.level + 1;
            if(this.expanded)
            {
               child.updateVisibility();
            }
            if(abTriggerUpdate)
            {
               this.triggerHierarchyUpdateEvent();
            }
         }
         else
         {
            trace("BSCollapsingListNode::append -- Cannot add a child that alreade have a parent.");
         }
      }
      
      public function clear(abTriggerUpdate:Boolean = true) : *
      {
         var child:* = undefined;
         for each(child in this.m_Children)
         {
            if(child is BSCollapsingListNode)
            {
               child.parentNode = null;
            }
            else
            {
               trace("BSCollapsingListNode::clear -- Removing a child that is not of the correct type.");
            }
         }
         this.m_Children = new Array();
         if(abTriggerUpdate)
         {
            this.triggerUpdateEvent();
         }
      }
      
      public function triggerHierarchyUpdateEvent() : *
      {
         dispatchEvent(new Event(BSCollapsingListNode.HIERARCHY_UPDATE_EVENT,true,true));
         if(this.m_Parent != null)
         {
            this.m_Parent.triggerHierarchyUpdateEvent();
         }
      }
      
      public function triggerUpdateEvent(abForce:Boolean = false) : *
      {
         if(abForce || this.isVisible())
         {
            dispatchEvent(new Event(BSCollapsingListNode.UPDATE_EVENT,true,true));
            if(this.m_Parent != null)
            {
               this.m_Parent.triggerUpdateEvent(abForce);
            }
         }
      }
      
      public function isVisible() : Boolean
      {
         return this.m_Visible && (this.m_Parent == null || this.m_Parent.expanded && this.m_Parent.isVisible());
      }
      
      public function updateVisibility() : *
      {
         if(this.isVisible())
         {
            this.filterFlag |= BSCollapsingListNode.VISIBLE_FILTER_FLAG;
         }
         else
         {
            this.filterFlag &= ~BSCollapsingListNode.VISIBLE_FILTER_FLAG;
         }
      }
      
      public function expand(abTriggerUpdate:Boolean = true) : Boolean
      {
         var child:* = undefined;
         var hasExpanded:* = false;
         if(!this.m_Expanded)
         {
            if(this.m_Parent != null)
            {
               if(!this.m_Parent.expanded)
               {
                  this.m_Parent.expand(false);
               }
               if(!this.m_Parent.allowMultipleExpandedCategories)
               {
                  this.m_Parent.collapseAll();
               }
            }
            this.m_Expanded = true;
            hasExpanded = true;
            for each(child in this.m_Children)
            {
               child.updateVisibility();
            }
            if(abTriggerUpdate)
            {
               this.triggerUpdateEvent();
            }
            dispatchEvent(new Event(BSCollapsingListNode.EXPAND_EVENT,true,true));
         }
         return hasExpanded;
      }
      
      public function collapse(abTriggerUpdate:Boolean = true) : Boolean
      {
         var child:* = undefined;
         var entry:* = undefined;
         var subCategory:* = undefined;
         var hasCollapsed:* = false;
         if(this.m_Expanded)
         {
            if(this.m_CollapseSubWhenCollapsing)
            {
               for each(entry in this.m_Children)
               {
                  subCategory = entry as BSCollapsingListNode;
                  if(subCategory != null)
                  {
                     subCategory.collapse();
                  }
               }
            }
            this.m_Expanded = false;
            hasCollapsed = true;
            for each(child in this.m_Children)
            {
               child.updateVisibility();
            }
            if(abTriggerUpdate)
            {
               this.triggerUpdateEvent();
            }
            dispatchEvent(new Event(BSCollapsingListNode.COLLAPSE_EVENT,true,true));
         }
         return hasCollapsed;
      }
      
      protected function collapseAll(abTriggerUpdate:Boolean = true) : *
      {
         var child:* = undefined;
         var node:* = undefined;
         for each(child in this.children)
         {
            node = child as BSCollapsingListNode;
            if(node != null)
            {
               node.collapse(false);
            }
         }
         if(abTriggerUpdate)
         {
            this.triggerUpdateEvent();
         }
      }
      
      public function toggle(abTriggerUpdate:Boolean = true) : *
      {
         if(this.m_Expanded)
         {
            this.collapse(abTriggerUpdate);
         }
         else
         {
            this.expand(abTriggerUpdate);
         }
      }
      
      public function saveState(selectedIndex:int) : Object
      {
         var child:* = undefined;
         var id:String = null;
         var state:Object = new Object();
         state["Expanded"] = this.m_Expanded;
         for each(child in this.m_Children)
         {
            if(child is BSCollapsingListNode)
            {
               state["_" + child.id] = child.saveState(selectedIndex);
            }
            if(child.itemIndex == selectedIndex)
            {
               id = child.id;
               if(id != null)
               {
                  state["Selected"] = id;
               }
            }
         }
         return state;
      }
      
      public function loadState(aState:Object) : *
      {
         var child:* = undefined;
         if(Boolean(aState.hasOwnProperty("Expanded")) && aState["Expanded"] as Boolean)
         {
            this.expand(false);
         }
         else
         {
            this.collapse(false);
         }
         var selectedId:String = aState.hasOwnProperty("Selected") ? aState["Selected"] as String : null;
         for each(child in this.m_Children)
         {
            if(child is BSCollapsingListNode)
            {
               if(aState.hasOwnProperty("_" + child.id))
               {
                  child.loadState(aState["_" + child.id]);
               }
            }
         }
      }
      
      public function loadSelected(aState:Object, aList:BSCollapsingList) : *
      {
         var child:* = undefined;
         if(aState.hasOwnProperty("Selected"))
         {
            this.applySelected(aState["Selected"] as String,aList);
         }
         else
         {
            for each(child in this.m_Children)
            {
               if(child is BSCollapsingListNode)
               {
                  if(aState.hasOwnProperty("_" + child.id))
                  {
                     child.loadSelected(aState["_" + child.id],aList);
                  }
               }
            }
         }
      }
      
      private function applySelected(aSelectedId:String, aList:BSCollapsingList) : *
      {
         var child:* = undefined;
         var id:String = null;
         for each(child in this.m_Children)
         {
            id = child.id;
            if(id != null && id == aSelectedId)
            {
               aList.selectedIndex = child.itemIndex;
               break;
            }
         }
      }
      
      public function get id() : String
      {
         return this.m_NodeName;
      }
   }
}

