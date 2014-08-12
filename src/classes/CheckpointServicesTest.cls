@isTest
Global class CheckpointServicesTest {
    
    static testmethod void test_method_one() {
        // Implement test code
        createEnvironmentVariable('Checkpoint.UserName','Username.Test');    
        createEnvironmentVariable('Checkpoint.Password','Password.Test'); 
        createEnvironmentVariable('Checkpoint.Max_Results','50');  
        createEnvironmentVariable('Checkpoint.Endpoint','Endpoint.Test');   

         //Run Test
            system.assert(null!=CheckpointServices.doReturnServiceMetadata());
            system.assert(null!=CheckpointServices.doReturnServers(0));
    }
    
    static testmethod void test_method_two() {
        // Implement test code
        
        //NO user info. Return Error
        
         //Run Test
            try{
                CheckpointServices.doReturnServiceMetadata();
            }catch(exception e){
                system.assert(e.getmessage().contains('Username is required'), e.getmessage());
            }
            
            try{
                CheckpointServices.doReturnServers(0);
            }catch(exception e){
                system.assert(e.getmessage().contains('Username is required'), e.getmessage());
            }
            

    }
    
    private static Environment_Variable__c createEnvironmentVariable(string settingName, string settingValue){
                // TO DO: Create Settings
                Environment_Variable__c Setting = new Environment_Variable__c();
                        Setting.Name = settingName;
                        Setting.Value__c = settingValue;
             insert Setting;
             
             system.assert(Setting.Name == settingName,'Error: Utility_TestData.createEnvironmentVariable');
       return Setting;
    }

 
}