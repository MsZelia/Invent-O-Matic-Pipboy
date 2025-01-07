package Pipboy_InvPage_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol470")]
   public dynamic class Arm_Left_Anim_11 extends MovieClip
   {
       
      
      public function Arm_Left_Anim_11()
      {
         super();
         addFrameScript(0,this.frame1,24,this.frame25);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame25() : *
      {
         gotoAndPlay("Animate");
      }
   }
}
