public class lockComponentController 
{

    public String Quote_List_SelectedView { get; set; }

    public String Selected_View { get; set; }
    
    
    public void lockComponentController()
    {
    
   
    }
    public void refresh()
    {
    }
    
    public List<SelectOption> getItems() 
    {
     Selected_View = ' where Status__c = \'Locked\'';
     
    List<SelectOption> options = new List<SelectOption>();
    
    Options.add(new SelectOption(' where Status__c = \'Locked\' and isDeleted__c != True','ALL Locked'));
    Options.add(new SelectOption(' where Component_Type__c = \'Apex Class\' and isDeleted__c != True','Apex Classes'));
    Options.add(new SelectOption(' where Component_Type__c = \'Apex Trigger\' and isDeleted__c != True','Apex Triggers'));
    Options.add(new SelectOption(' where Component_Type__c = \'Visualforce Page\' and isDeleted__c != True','Visualforce Pages'));            
    Options.add(new SelectOption(' where Component_Type__c = \'Apex Component\' and isDeleted__c != True','Apex Components'));                
    Options.add(new SelectOption('All','ALL Components'));
    Options.add(new SelectOption(' where isDeleted__c = True' ,'All Deleted'));                
            return options;
        }
        
        
                public List<List<Version_Control__c>> AllComponents
                {
            get
            {      
            List<Version_Control__c> tempList = new List<Version_Control__c>();
         
                   try
                   {
                   if(String.isBlank(Selected_View))
                   {
                   Selected_View = ' where Status__c = \'Locked\'';
                   }
                   else if(Selected_View == 'All')
                   {
                   Selected_View = '';
                   }
                   String Query = 'Select Component_Type__c,Component_Link__c,Last_Worked_By__c,Locked_By__c,canWork__c,Status__c from Version_Control__c';
                   Query = Query + Selected_View;
                   system.debug('$$$$' +Query);
    
                        
                       AllComponents = new List<List<Version_Control__c>>();
                        
                            for(Version_Control__c V:Database.query(Query))
                            {
                                tempList.add(V);
                                
                                if(tempList.size() == 1000)
                                {
                                AllComponents.add(tempList);                                
                                tempList = new List<Version_Control__c>();
                                }
                            }
                            AllComponents.add(tempList);                                
                    }
                    catch(exception e)
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error: ' + e.getmessage()));
                        AllComponents = new List<List<Version_Control__c>>();
                    } 
                    return AllComponents;   
                
            }
            set;
        }

}