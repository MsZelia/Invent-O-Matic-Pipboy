package
{
   import scaleform.clik.controls.Button;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol444")]
   public dynamic class plusCLIK extends Button
   {
       
      
      public function plusCLIK()
      {
         super();
         addFrameScript(9,this.frame10,19,this.frame20,29,this.frame30,39,this.frame40);
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
