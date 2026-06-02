package
{
   import Shared.AS3.BCGridList;
   import Shared.AS3.Data.BSUIDataManager;
   import Shared.AS3.Events.CustomEvent;
   import Shared.GlobalFunc;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol224")]
   public class StatsPage_TitlesTab extends IPipBoyTab
   {
      
      private static const RECHECK_DELAY:Number = 1000;
      
      private static var ActiveList:uint = 0;
      
      private static var SelectedPrefix:uint = 0;
      
      private static var SelectedSuffix:uint = 0;
      
      public var List_mc:BCGridList;
      
      public var Name_tf:TextField;
      
      private var m_Data:Object;
      
      private var m_BaseName:String = "";
      
      private var m_PrefixString:String = "";
      
      private var m_SuffixString:String = "";
      
      private var m_IsPrefix:Boolean = true;
      
      private var m_Bounced:Boolean = false;
      
      private var m_NewLoad:Boolean = true;
      
      private var m_LastCheckTime:Number = 0;
      
      private const PREFIX_FLAG:uint = 1 << 0;
      
      private const SUFFIX_FLAG:uint = 1 << 1;
      
      public function StatsPage_TitlesTab()
      {
         super();
         this.List_mc.listItemClassName = "TitlesEntry";
         this.List_mc.maxCols = 2;
         this.List_mc.maxRows = 10;
         this.List_mc.selectedIndex = 0;
         this.List_mc.addEventListener(BCGridList.ITEM_PRESS,this.onItemPress);
         addEventListener(BCGridList.SELECTION_EDGE_BOUNCE,this.onEdgeBounce);
         addEventListener(BCGridList.SELECTION_CHANGE,this.onHighlightChange);
      }
      
      public static function get SelectedForm() : uint
      {
         return ActiveList == NewPipBoyShared.STATS_TAB_PREFIX ? SelectedPrefix : SelectedSuffix;
      }
      
      override public function processProvider(aData:Object) : void
      {
         StatsPage_TitlesTab.ActiveList = aData.TabIndex;
         StatsPage_TitlesTab.SelectedPrefix = aData.PrefixFormID;
         StatsPage_TitlesTab.SelectedSuffix = aData.SuffixFormID;
         this.m_IsPrefix = aData.TabIndex == NewPipBoyShared.STATS_TAB_PREFIX;
         this.m_BaseName = aData.BaseName;
         this.m_Data = aData;
         this.setDisplay();
         this.setName();
      }
      
      override public function OnEntry() : void
      {
         stage.focus = this.List_mc;
         this.List_mc.visible = false;
      }
      
      override public function OnExit() : void
      {
         this.List_mc.selectedIndex = -1;
      }
      
      private function setName() : void
      {
         this.Name_tf.text = this.m_BaseName;
         if(this.m_PrefixString != "" || this.m_SuffixString != "")
         {
            this.Name_tf.appendText(GlobalFunc.CUSTOM_TITLE_DIVIDER);
            if(this.m_PrefixString != "")
            {
               this.Name_tf.appendText(" " + this.m_PrefixString);
            }
            if(this.m_SuffixString != "")
            {
               this.Name_tf.appendText(" " + this.m_SuffixString);
            }
         }
         GlobalFunc.TruncateSingleLineText(this.Name_tf);
      }
      
      private function setDisplay() : void
      {
         var filterAndUpdateTitlesFunc:Function;
         this.m_PrefixString = "";
         this.m_SuffixString = "";
         filterAndUpdateTitlesFunc = function(title:Object, index:int, arr:Array):Boolean
         {
            var flag:uint = m_IsPrefix ? PREFIX_FLAG : SUFFIX_FLAG;
            if(title.formID == StatsPage_TitlesTab.SelectedPrefix)
            {
               m_PrefixString = title.title;
            }
            if(title.formID == StatsPage_TitlesTab.SelectedSuffix)
            {
               m_SuffixString = title.title;
            }
            return (title.flags & flag) != 0;
         };
         this.List_mc.entryData = (this.m_Data.Titles as Array).filter(filterAndUpdateTitlesFunc).sortOn(["title"]);
         this.List_mc.selectedIndex = 0;
         this.List_mc.visible = true;
      }
      
      private function onItemPress(e:Event) : *
      {
         var selected:Object = this.List_mc.selectedEntry;
         var selectedForm:uint = uint(selected.formID);
         var isDeselecting:Boolean = this.m_IsPrefix ? StatsPage_TitlesTab.SelectedPrefix == selectedForm : StatsPage_TitlesTab.SelectedSuffix == selectedForm;
         if(isDeselecting)
         {
            selectedForm = 0;
         }
         if(this.m_IsPrefix)
         {
            StatsPage_TitlesTab.SelectedPrefix = selectedForm;
            this.m_PrefixString = isDeselecting ? "" : selected.title;
         }
         else
         {
            StatsPage_TitlesTab.SelectedSuffix = selectedForm;
            this.m_SuffixString = isDeselecting ? "" : selected.title;
         }
         this.setName();
         BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.STAT_NEW_TITLE,{"formID":selectedForm}));
         this.List_mc.invalidateData();
      }
      
      private function onHighlightChange(aEvent:Event) : void
      {
         this.m_LastCheckTime = 0;
         this.m_Bounced = false;
         GlobalFunc.PlayMenuSound("UIGeneralFocus");
      }
      
      override public function ProcessRightThumbstickInput(auiDirection:uint) : Boolean
      {
         switch(auiDirection)
         {
            case NewPipBoyShared.DIRECTION_UP:
               if(this.List_mc.selectedIndex > 0)
               {
                  --this.List_mc.selectedIndex;
               }
               break;
            case NewPipBoyShared.DIRECTION_DOWN:
               if(this.List_mc.selectedIndex < this.List_mc.entryCount - 1)
               {
                  this.List_mc.selectedIndex += 1;
               }
         }
         return true;
      }
      
      override public function CanSwitchTabs(aEventName:String) : Boolean
      {
         var didBounce:Boolean = this.m_Bounced;
         this.m_Bounced = false;
         var skipBounceCheck:Boolean = aEventName == "CLICK" || aEventName.indexOf("Strafe") != -1;
         var stickCheck:* = aEventName.indexOf("Stick") != -1;
         if(!didBounce && (skipBounceCheck || stickCheck))
         {
            this.m_LastCheckTime = new Date().getTime();
         }
         return didBounce || skipBounceCheck;
      }
      
      private function onEdgeBounce(aEvent:Event) : void
      {
         var diff:Number = NaN;
         if(stage.focus == this.List_mc)
         {
            this.m_Bounced = true;
            diff = new Date().getTime() - this.m_LastCheckTime;
            if(diff < RECHECK_DELAY)
            {
               switch(this.List_mc.lastNavDirection)
               {
                  case Keyboard.LEFT:
                     BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.TAB_CYCLE,{"direction":-1}));
                     break;
                  case Keyboard.RIGHT:
                     BSUIDataManager.dispatchEvent(new CustomEvent(NewPipBoyShared.TAB_CYCLE,{"direction":1}));
               }
            }
         }
      }
   }
}

