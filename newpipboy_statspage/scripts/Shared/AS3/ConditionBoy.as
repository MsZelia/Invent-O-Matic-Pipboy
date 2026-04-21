package Shared.AS3
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.setTimeout;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol206")]
   public dynamic class ConditionBoy extends BSUIComponent
   {
      
      private static const CONDITION_DISPLAY_TIME:uint = 5000;
      
      private static const CLIP_BODY_TEMPLATE_PATH:String = "Components/ConditionClips/Condition_Body_";
      
      private static const CLIP_BODY_HUNGER_ID:int = 16;
      
      private static const CLIP_BODY_DISEASE_ID:int = 17;
      
      private static const CLIP_BODY_THIRST_ID:int = 18;
      
      private static const CLIP_BODY_MUTATION_ID:int = 19;
      
      private static const CLIP_BODY_FERAL_ID:int = 20;
      
      private static const NUM_BODY_CLIPS:int = 20;
      
      private static const HEAD_HUNGER_FRAME:String = "Drugged";
      
      private static const HEAD_THIRST_FRAME:String = "Drugged";
      
      private static const HEAD_FERAL_FRAME:String = "Feral";
      
      private var BodyClip:MovieClip = null;
      
      private var HeadClip:MovieClip = null;
      
      private var HeadLoader:Loader;
      
      private var BodyLoader:Loader;
      
      private var ColorFileText:String = new String();
      
      private var PrimaryCondition:Object = {};
      
      private var SecondaryConditions:Vector.<Object> = new Vector.<Object>();
      
      private var CurrentlyShownCondition:Object = {};
      
      private var PreloadedBodyClips:Vector.<Loader>;
      
      private var ShouldUpdate:Boolean = false;
      
      private var PrimaryConditionChanged:Boolean = false;
      
      private var IsReadyForNextCondition:Boolean = true;
      
      private var IsMutated:Boolean = false;
      
      private var IsDiseased:Boolean = false;
      
      private var IsThirstStateNegative:Boolean = false;
      
      private var IsHungerStateNegative:Boolean = false;
      
      private var IsFeralStateNegative:Boolean = false;
      
      private var m_IsGhoul:Boolean = false;
      
      private var IsMenuInstance:Boolean = false;
      
      public function ConditionBoy()
      {
         super();
         this.LoadHead();
      }
      
      public function set isMenuInstance(aIsMenuInstance:Boolean) : *
      {
         this.IsMenuInstance = aIsMenuInstance;
      }
      
      public function PreloadConditions() : *
      {
         var id:* = undefined;
         var cachedBodyLoader:Loader = null;
         var bodyLoadRequest:URLRequest = null;
         if(!this.PreloadedBodyClips)
         {
            this.PreloadedBodyClips = new Vector.<Loader>(NUM_BODY_CLIPS,true);
            for(id in this.PreloadedBodyClips)
            {
               cachedBodyLoader = new Loader();
               this.PreloadedBodyClips[id] = cachedBodyLoader;
               bodyLoadRequest = new URLRequest(this.GetPathForCondition(id));
               cachedBodyLoader.load(bodyLoadRequest);
            }
         }
      }
      
      private function GetPathForCondition(aBodyId:int) : *
      {
         return CLIP_BODY_TEMPLATE_PATH + this.ColorFileText + aBodyId + ".swf";
      }
      
      public function SetData(data:Object) : *
      {
         this.m_IsGhoul = data.isGhoul;
         this.UpdatePrimaryCondition(data);
         if(!this.IsMenuInstance)
         {
            this.UpdateSecondaryConditions(data);
         }
         if(this.IsReadyForNextCondition)
         {
            this.ShowNextCondition();
         }
      }
      
      private function UpdatePrimaryCondition(data:Object) : *
      {
         var isHeadDamaged:Boolean = Boolean(data.isHeadDamaged);
         var headFrame:String = "Normal";
         if(this.m_IsGhoul)
         {
            headFrame = isHeadDamaged ? "GhoulDamaged" : "Ghoul";
         }
         else if(data.isIrradiated)
         {
            headFrame = isHeadDamaged ? "IrradiatedDamaged" : "Irradiated";
         }
         else if(data.isDrugged)
         {
            headFrame = isHeadDamaged ? "DruggedDamaged" : "Drugged";
         }
         else if(data.isAddicted || isHeadDamaged || data.bodyFlags != 0)
         {
            headFrame = isHeadDamaged ? "NegativeDamaged" : "Negative";
         }
         this.PrimaryCondition.isPersistent = isHeadDamaged || data.bodyFlags != 0;
         if(this.PrimaryCondition.headFrame != headFrame || this.PrimaryCondition.bodyId != data.bodyFlags)
         {
            this.PrimaryCondition.headFrame = headFrame;
            this.PrimaryCondition.bodyId = data.bodyFlags;
            this.PrimaryConditionChanged = true;
         }
      }
      
      private function UpdateSecondaryConditions(data:Object) : *
      {
         var isHeadDamaged:Boolean = Boolean(data.isHeadDamaged);
         if(!this.IsMutated && Boolean(data.isMutated))
         {
            this.SecondaryConditions.push({
               "headFrame":(this.m_IsGhoul ? "Ghoul" : ("" + isHeadDamaged ? "MutatedDamaged" : "Mutated")),
               "bodyId":CLIP_BODY_MUTATION_ID
            });
         }
         this.IsMutated = data.isMutated;
         if(!this.IsDiseased && Boolean(data.isDiseased))
         {
            this.SecondaryConditions.push({
               "headFrame":(isHeadDamaged ? "DiseasedDamaged" : "Diseased"),
               "bodyId":CLIP_BODY_DISEASE_ID
            });
         }
         this.IsDiseased = data.isDiseased;
         if(Boolean(data.isThirstStateNegative) && !this.IsThirstStateNegative)
         {
            this.SecondaryConditions.push({
               "headFrame":HEAD_THIRST_FRAME,
               "bodyId":CLIP_BODY_THIRST_ID
            });
         }
         this.IsThirstStateNegative = data.isThirstStateNegative;
         if(Boolean(data.isHungerStateNegative) && !this.IsHungerStateNegative)
         {
            this.SecondaryConditions.push({
               "headFrame":HEAD_HUNGER_FRAME,
               "bodyId":CLIP_BODY_HUNGER_ID
            });
         }
         this.IsHungerStateNegative = data.isHungerStateNegative;
         if(Boolean(data.isFeralStateNegative) && !this.IsFeralStateNegative)
         {
            this.SecondaryConditions.push({
               "headFrame":HEAD_FERAL_FRAME,
               "bodyId":CLIP_BODY_FERAL_ID
            });
         }
         this.IsFeralStateNegative = data.isFeralStateNegative;
      }
      
      private function ShowNextCondition() : *
      {
         var showingPersistentCondition:Boolean = false;
         var bodyLoadRequest:URLRequest = null;
         var conditionData:Object = null;
         if(this.SecondaryConditions.length > 0)
         {
            conditionData = this.SecondaryConditions.pop();
         }
         else if(this.PrimaryConditionChanged || Boolean(this.PrimaryCondition.isPersistent))
         {
            conditionData = this.PrimaryCondition;
            this.PrimaryConditionChanged = false;
         }
         if(conditionData)
         {
            showingPersistentCondition = this.IsShowingCondition(conditionData) && Boolean(conditionData.isPersistent);
            if(!showingPersistentCondition)
            {
               this.UnloadBody();
               this.LoadHead();
               this.CurrentlyShownCondition.headFrame = conditionData.headFrame;
               this.CurrentlyShownCondition.bodyId = conditionData.bodyId;
               if(this.PreloadedBodyClips != null)
               {
                  this.onConditionBodyLoadComplete(null);
               }
               else
               {
                  this.BodyLoader = new Loader();
                  this.BodyLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onConditionBodyLoadComplete);
                  this.BodyLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onConditionBodyLoadFailed);
                  bodyLoadRequest = new URLRequest(this.GetPathForCondition(conditionData.bodyId));
                  this.BodyLoader.load(bodyLoadRequest);
               }
            }
         }
         else if(!this.IsMenuInstance)
         {
            visible = false;
            this.UnloadBody();
         }
      }
      
      private function IsShowingCondition(conditionData:Object) : *
      {
         return conditionData && this.CurrentlyShownCondition && conditionData.headFrame == this.CurrentlyShownCondition.headFrame && conditionData.bodyId == this.CurrentlyShownCondition.bodyId;
      }
      
      private function LoadHead() : *
      {
         if(this.HeadLoader)
         {
            this.HeadLoader.unloadAndStop();
         }
         this.HeadLoader = new Loader();
         var loadRequest:URLRequest = new URLRequest("Components/ConditionClips/Condition_Head.swf");
         this.HeadLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onConditionHeadLoadComplete);
         this.HeadLoader.load(loadRequest);
      }
      
      private function UnloadBody() : *
      {
         if(this.BodyLoader)
         {
            try
            {
               this.BodyLoader.close();
            }
            catch(e:Error)
            {
            }
         }
         if(this.BodyClip)
         {
            removeChild(this.BodyClip);
            this.BodyClip.stop();
            this.BodyClip = null;
         }
         if(this.BodyLoader)
         {
            this.BodyLoader.unload();
            this.BodyLoader = null;
         }
         this.CurrentlyShownCondition = {};
      }
      
      override public function redrawUIComponent() : void
      {
         super.redrawUIComponent();
         if(Boolean(this.BodyClip) && Boolean(this.HeadClip) && this.ShouldUpdate)
         {
            visible = true;
            this.ShouldUpdate = false;
            this.BodyClip.Head_mc.addChild(this.HeadClip);
            this.BodyClip.scaleX = 1.2;
            this.BodyClip.scaleY = this.BodyClip.scaleX;
            addChild(this.BodyClip);
            this.BodyClip.gotoAndPlay(this.m_IsGhoul ? "Ghoul" : "Human");
            this.HeadClip.gotoAndStop(this.CurrentlyShownCondition.headFrame);
            if(!this.IsMenuInstance)
            {
               this.IsReadyForNextCondition = false;
               setTimeout(function():void
               {
                  IsReadyForNextCondition = true;
                  ShowNextCondition();
               },CONDITION_DISPLAY_TIME);
            }
         }
      }
      
      private function onConditionBodyLoadComplete(loadCompleteEvent:Event) : *
      {
         if(this.BodyLoader)
         {
            loadCompleteEvent.target.removeEventListener(Event.COMPLETE,this.onConditionBodyLoadComplete);
            loadCompleteEvent.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onConditionBodyLoadFailed);
            this.BodyClip = this.BodyLoader.contentLoaderInfo.content as MovieClip;
         }
         else
         {
            if(!this.PreloadedBodyClips)
            {
               throw new Error("onConditionBodyLoadComplete called but there is no loader nor preloaded clip to get info from");
            }
            this.BodyClip = this.PreloadedBodyClips[this.CurrentlyShownCondition.bodyId].contentLoaderInfo.content as MovieClip;
         }
         this.ShouldUpdate = true;
         SetIsDirty();
      }
      
      private function onConditionBodyLoadFailed(event:IOErrorEvent) : *
      {
         event.target.removeEventListener(Event.COMPLETE,this.onConditionBodyLoadComplete);
         event.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onConditionBodyLoadFailed);
         trace("failed to load body: " + this.GetPathForCondition(this.CurrentlyShownCondition.bodyId));
         this.UnloadBody();
      }
      
      private function onConditionHeadLoadComplete(loadCompleteEvent:Event) : *
      {
         if(this.HeadLoader)
         {
            loadCompleteEvent.target.removeEventListener(Event.COMPLETE,this.onConditionHeadLoadComplete);
            this.HeadClip = this.HeadLoader.contentLoaderInfo.content as MovieClip;
            this.HeadLoader = null;
         }
      }
   }
}

