package
{
   import Shared.AS3.BSScrollingListEntry;
   import Shared.GlobalFunc;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol41")]
   public class WorldPetsListEntry extends BSScrollingListEntry
   {
      
      public static const ENTRY_INDENT:Number = 30;
      
      public var Name_tf:TextField;
      
      private var m_BaseX:Number;
      
      public function WorldPetsListEntry()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,4,this.frame5,5,this.frame6,6,this.frame7,7,this.frame8,8,this.frame9,9,this.frame10,10,this.frame11,11,this.frame12);
         this.m_BaseX = x;
      }
      
      override public function SetEntryText(aEntryObject:Object, astrTextOption:String) : *
      {
         var state:* = null;
         x = this.m_BaseX + aEntryObject.level * ENTRY_INDENT;
         if(aEntryObject.isCategory())
         {
            state = aEntryObject.expanded ? "expanded" : "collapsed";
         }
         else if(aEntryObject.data.FormID == 0)
         {
            state = "none";
         }
         else if(aEntryObject.data.FormID == StatsPage_WorldPetsTab.SelectedFormID)
         {
            state = "enabled";
         }
         else if(StatsPage_WorldPetsTab.SelectedFormID == 0 && StatsPage_WorldPetsTab.ActiveCampPets.indexOf(aEntryObject.data.FormID) >= 0)
         {
            state = "camp";
         }
         else
         {
            state = "disabled";
         }
         if(selected)
         {
            state += "_selected";
         }
         gotoAndStop(state);
         TextFieldEx.setTextAutoSize(this.Name_tf,"shrink");
         if(aEntryObject.nodeName != undefined)
         {
            GlobalFunc.SetText(this.Name_tf,aEntryObject.nodeName,true);
         }
         else
         {
            GlobalFunc.SetText(this.Name_tf,"Unknown?",true);
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         stop();
      }
      
      internal function frame7() : *
      {
         stop();
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      internal function frame11() : *
      {
         stop();
      }
      
      internal function frame12() : *
      {
         stop();
      }
   }
}

