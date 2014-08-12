/*Test class to test ContentController*/

@isTest
private class Test_ContentController{
   
    static testMethod void testContentController(){
        
        
        ContentController content = new ContentController();
        content.searchbox= 'soneri';
        
        String nickName = content.getSiteNickName();
        System.assertNotEquals(null, nickName);
        
        list<SelectOption> options;
        options = content.getWorkspace();
        System.assertNotEquals(null, options);
        
        options = content.getPlatformOptions();
        System.assertNotEquals(null, options);
        
        options = content.getDatabaseOptions();
        System.assertNotEquals(null, options);
    
        options = content.getReleaseOptions();
        System.assertNotEquals(null, options); 
        
        options = content.getTypeOptions();
        System.assertNotEquals(null, options);
        
        options=content.getmyProducts();
        content.runQuery();
                
        //PageReference pgref= content.reset();
        
               
        
        
       }
       
       
       
 }