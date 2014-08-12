trigger EloquaActivity on Task(before insert) {

if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AS 07-Aug-13] : Added Bypass code
//Commenting the below line: USI
       // EDP1.Processor.handleTrigger();
}