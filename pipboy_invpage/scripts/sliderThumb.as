package
{
   import scaleform.clik.controls.Button;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol429")]
   public dynamic class sliderThumb extends Button
   {
       
      
      public function sliderThumb()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,19,this.frame20,29,this.frame30,39,this.frame40);
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         stop();
      }
      
      internal function frame40() : *
      {
         stop();
      }
   }
}
