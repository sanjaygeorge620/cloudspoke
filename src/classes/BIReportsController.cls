public class BIReportsController {    
    Map<String, BI_Report_Links__c> reportLinkMap = new Map<String, BI_Report_Links__c>();    
    public String selectedDashboard {get;set;}    
    public String reportLink {get;set;}            
    public String loginUser_Name {get;set;}
    List<User> login_User_Rec = new List<User>();
    public boolean hasAccess{get;set;}
    public String issReportLink {get;set;}
    public String issSelectedDashboard {get;set;}        
    
    public BIReportsController()
    {       
       
        loginUser_Name = UserInfo.getName();
        reportLinkMap = BI_Report_Links__c.getAll();
        login_User_Rec = [Select id, employeeNumber from user where id=: UserInfo.getUserId() ];
        if(BI_Report_Martin_Canning_Reportees__c.getAll() != null &&
        BI_Report_Martin_Canning_Reportees__c.getAll().get(loginUser_Name) != null){       
            reportLink =  reportLinkMap.get('Monday Morning').Report_Link__c +
                    BI_Report_Martin_Canning_Reportees__c.getAll().get(loginUser_Name).Reportees__c;    
        }
        else
        {
               reportLink =  reportLinkMap.get('Monday Morning').Report_Link__c+login_User_Rec.get(0).employeeNumber ;
        }
        
        System.debug('$$ URL in con: '+reportLink );   
                //Praveen for US3962    
        issReportLink = '';
        issSelectedDashboard = 'ISS Sales Productivity';
        // DJY US4141 Get current User custom setting.
        BI_Report_Permissions__c LXUser = BI_Report_Permissions__c.getValues(UserInfo.getUserId());        
        // Allow the trigger to skip the User/Profile/Org based on the custom setting values
        if(LXUser != null)
        {
        	hasAccess = LXUser.ISS_Sales_Productivity__c;      
      	 	issReportLink =  reportLinkMap.get('ISS Sales Productivity').Report_Link__c;
        }
        else
        {
        hasAccess = False;
        }        
         
       }       

    public void displayReport(){
    
    System.debug('$$Check BI_Report_Martin_Canning_Reportees__c.getAll() '+BI_Report_Martin_Canning_Reportees__c.getAll());
    System.debug('$$Check BI_Report_Martin_Canning_Reportees__c.getAll().get(loginUser_Name) '+BI_Report_Martin_Canning_Reportees__c.getAll().get(loginUser_Name));
    System.debug('$$Check reportLinkMap.get(selectedDashboard).Report_Link__c '+reportLinkMap.get(selectedDashboard).Report_Link__c);
    
            
        if(  BI_Report_Martin_Canning_Reportees__c.getAll() != null &&
        BI_Report_Martin_Canning_Reportees__c.getAll().get(loginUser_Name) != null &&
        reportLinkMap.get(selectedDashboard).IsParamRequired__c == 'Yes'){
            
            System.debug('$$URL for Martin :' + reportLinkMap.get(selectedDashboard).Report_Link__c+
                    BI_Report_Martin_Canning_Reportees__c.getAll().get(loginUser_Name).Reportees__c);
            
            reportLink  = reportLinkMap.get(selectedDashboard).Report_Link__c+
                    BI_Report_Martin_Canning_Reportees__c.getAll().get(loginUser_Name).Reportees__c;
            
        }
        else if(reportLinkMap.get(selectedDashboard).IsParamRequired__c == 'Yes'){
            
            if( login_User_Rec != null && login_User_Rec.size() > 0){
            
            
              reportLink  = reportLinkMap.get(selectedDashboard).Report_Link__c+
                                  login_User_Rec.get(0).employeeNumber ; 
              
              System.debug('$$ URL in rep with param: '+reportLink );                    
                                  
                                  
            }
            
        }
        else{
            reportLink  = reportLinkMap.get(selectedDashboard).Report_Link__c;            
        }
        
        System.debug('$$ URL in method: '+reportLink );    
    }

}