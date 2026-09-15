package
{
   import Shared.GlobalFunc;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol17")]
   public class WorldPetsInfoPanel extends MovieClip
   {
      
      public static const MIN_LEVEL_BAR_WIDTH:Number = 5;
      
      public static const LEVEL_BAR_TEXT_MARGIN:Number = 10;
      
      public var HealthBar_mc:MovieClip;
      
      public var LevelBar_mc:MovieClip;
      
      public var LevelBarBack_mc:MovieClip;
      
      public var LevelLeft_tf:TextField;
      
      public var LevelRight_tf:TextField;
      
      public var Name_tf:TextField;
      
      private var m_HealthBarMaxWidth:Number;
      
      public function WorldPetsInfoPanel()
      {
         super();
         this.m_HealthBarMaxWidth = this.HealthBar_mc.width;
      }
      
      public function updateLevel(aLevel:uint, aPercentage:Number, aMaxLevel:uint) : *
      {
         var nextLevel:uint = 0;
         var barPercent:* = 0;
         if(aLevel >= aMaxLevel)
         {
            barPercent = 1;
            this.LevelLeft_tf.text = aMaxLevel.toString();
            this.LevelRight_tf.text = aMaxLevel.toString();
         }
         else
         {
            nextLevel = uint(aLevel + 1);
            barPercent = Math.max(Math.min(aPercentage,1),0);
            this.LevelLeft_tf.text = aLevel.toString();
            this.LevelRight_tf.text = nextLevel.toString();
         }
         var totalWidth:* = this.LevelRight_tf.x + this.LevelRight_tf.width - this.LevelLeft_tf.x;
         var availableWidth:* = Math.max(MIN_LEVEL_BAR_WIDTH,totalWidth - this.LevelRight_tf.textWidth - this.LevelLeft_tf.textWidth - LEVEL_BAR_TEXT_MARGIN * 2);
         this.LevelBarBack_mc.x = this.LevelLeft_tf.x + this.LevelLeft_tf.textWidth + LEVEL_BAR_TEXT_MARGIN;
         this.LevelBar_mc.x = this.LevelBarBack_mc.x;
         this.LevelBarBack_mc.width = availableWidth;
         this.LevelBar_mc.width = availableWidth * barPercent;
      }
      
      public function updateHealth(aPercentage:Number) : *
      {
         this.HealthBar_mc.width = Math.max(Math.min(aPercentage,1),0) * this.m_HealthBarMaxWidth;
      }
      
      public function updateName(aName:String) : *
      {
         this.Name_tf.text = aName;
         GlobalFunc.TruncateSingleLineText(this.Name_tf);
      }
   }
}

