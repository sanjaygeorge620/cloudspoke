/******************************************************
 * Description      : Apex Controller to create an Enrollment List on Offer Enrollment
 * @author          : Amit Sinha
 * @since           : Dec 19, 2010   
 ******************************************************/
public with sharing class ABSI_MassTaskController1 {

    //Capture the values for the standard Task
    public Task task{set;get;}
    //Capture the value for the reminder date/time
    public Contact contact{set;get;}
    public String reminderTime{set;get;}
    //Other Form fields
    public Boolean sendNotificationEmailCheckBox{set;get;}
    public Map <Id,String> displayNames{set;get;}
    public Map <Id,String> displayAccountNames{set;get;}
    //Added for saving account info in related to field.
    public Map <Id,String> displayAccountIds{set;get;}
    private Map <Id,Id> ownerIds;
    public Boolean showWhoId{set;get;}
    public Boolean showPage{set;get;}
    public Boolean assignToOwner{set;get;}
    //Page processing parameters
    private List <Selectoption> selReminderOptions;
    private String [] arrObjIds;
    private String objName = null;
    private Boolean saveStatus;
    private String objPrefix = null;
    public Boolean isContact{set;get;}
    public Boolean isAccount{set;get;}
    public Boolean isOfferEnrollment{set;get;}
    Public Set<ID> contactIds = new Set<ID>();
    Public Set<ID> accountIds = new Set<ID>();
    Public Set<ID> OfferEnrollmentIds = new Set<ID>();
    
    List<AccountContactRole> accContRoles = new List<AccountContactRole>();
    Public Map<ID,Contact> contAccountName;
    Public Map<ID,LX_Offer_Enrollment__c> OEAccountName;
    Public Map<ID,ID> accContactID = new Map<ID,ID>();
    
    
    /**
    * Constructor
    * Initialize the values & generate the object list(Names)
    */
    public ABSI_MassTaskController1(){
        //Initialize the variables
        showPage = false;
        task = new Task();
        Task.Subject='Prospect List:'+date.today().format();
       // Task.Status='In Progress';
        Task.Status='Not Started';//Added by arun thakur Emai:FW: Default Status In prospect Screen
        Task.Priority='Normal';
        Task.activityDate=date.today();
        contact = new Contact();
        displayNames = new Map<Id,String>();
        //New Map to display account name
        displayAccountNames = new Map<Id,String>();
        displayAccountIds = new Map<Id,String>();
        ownerIds = new Map<Id,Id>();
        showWhoId = false;
        sendNotificationEmailCheckBox = false;
        saveStatus = false;
        assignToOwner = true;
        
        try{
            //Get the object ids passed as parameter
            Map<String, String> params = ApexPages.currentPage().getParameters();
            String strObjIds = params.get('objIds');
            arrObjIds = strObjIds.split(',');
            
            //Identify the object name/type and get the names
            if(arrObjIds != null && !arrObjIds.isEmpty()){
                //Find the object name
                Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
                Set<String> keyPrefixSet = gd.keySet();
                String tPrefix = arrObjIds[0].subString(0,3);
                
                for(String sObj : keyPrefixSet){
                    Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
                    if(tPrefix.equals(r.getKeyPrefix())){
                        objName = r.getName();
                        objPrefix = tPrefix;
                        break;
                    }
                }
                //Query the name for all the objects
                if(objName != null){
                    String strFieldName = 'name';
                    //Check if the object is a Contact or Lead
                    if(objName != 'Contact' && objName != 'Lead'){
                        showWhoId = true;
                    }
                    
                // Added by USI Team : Check if the object is a contact
                if(objName == 'Contact')
                    isContact = true;
                    
                if(objName == 'Account')
                    isAccount = true;
                    
                if(objName == 'LX_Offer_Enrollment__c')
                    isOfferEnrollment = true;     
                    
                    //Handle field that doesn't have a name field
                    if(objName == 'Case'){
                        strFieldName = 'CaseNumber';
                    }
                    
                    system.Debug('$$Amit1');
                    String strQuery = 'select id,Name,Account_Name__c,Account_Owner_ID__c,Account__r.' + strFieldName + ' from ' + objName + ' ';
                    Boolean bFirst = true;
                    for(String strObjId:arrObjIds){
                        if(bFirst){
                            strQuery += ' where Id in (\'';
                            bFirst = false;
                        }else{
                            strQuery += ',\'';
                        }
                        strQuery += String.escapeSingleQuotes(strObjId) + '\'';
                        
                    }
                    strQuery += ')';
                    
                    system.Debug('strQuery=' + strQuery);
                    try{
                        
                        SObject [] sfdcObjects = Database.query(strQuery);
                        system.debug('sfdcobjects='+ sfdcobjects);
                        //updated name to point to Account Name
                        strFieldName = 'Account_Name__c';
                        String strAccountId = 'Account__c';
                        //Generate the name list
                        for(SObject sfdcObject:sfdcObjects){
                            displayNames.put((Id)sfdcObject.get('id'),(String)sfdcObject.get(strFieldName));
                            system.Debug('displayNames='+displayNames);
                            ownerIds.put((Id)sfdcObject.get('id'), (Id)sfdcObject.get('Account_Owner_ID__c'));
                            //Amit - adding the Map to get Account Names
                            displayAccountNames.put((Id)sfdcObject.get('id'),(String)sfdcObject.get(strFieldName));
                            displayAccountIds.put((Id)sfdcObject.get('id'),(String)sfdcObject.get(strAccountId));
                        }
                        
                    }catch(Exception e){
                        strQuery = strQuery.replace(',' + strFieldName, ' ');
                        SObject [] sfdcObjects = Database.query(strQuery);
                        //Generate the Id list instead of name list
                        for(SObject sfdcObject:sfdcObjects){
                          //Amit - updated map to add Account Name
                          displayNames.put((Id)sfdcObject.get('id'),(Id)sfdcObject.get('id'));
                          //displayAccountNames.put((Id)sfdcObject.get('id'),(String)sfdcObject.get(strFieldName));
                        }
                    }
                    system.Debug('$$Amit2');
                    system.Debug('displaynames=' + displayNames);
                }
                  //Added by USI Team : Collecting the account names for the contacts 
                    if(isContact == true)
                    {
                    for(ID ids :arrObjIds)
                    contactIds.add(ids);
                    }
                    contAccountName = new Map<ID,Contact>([select id,accountid from contact where id in :contactIds]);
                
                //Added by USI Team : Collecting Primary contacts for the accounts
                    if(isAccount == true)
                    {
                    for(ID ids :arrObjIds)
                    accountIds.add(ids);
                    }
                    //accContRoles =[SELECT AccountId,ContactId,IsPrimary FROM AccountContactRole WHERE AccountId in :accountIds and IsPrimary = true];
                    
                    //Changing the loop to SOQL Query For loop 
                    For(AccountContactRole accContRole: [SELECT AccountId,ContactId,IsPrimary FROM AccountContactRole WHERE AccountId in :accountIds and IsPrimary = true])//accContRoles
                    {
                        if(accContactID.get(accContRole.AccountId) == '' || accContactID.get(accContRole.AccountId) == null)
                        accContactID.put(accContRole.AccountId,accContRole.ContactId);
                    }
                    
                    if(isOfferEnrollment == true)
                    {
                    for(ID ids :arrObjIds)
                    OfferEnrollmentIds.add(ids);
                    }
                    OEAccountName = new Map<ID,LX_Offer_Enrollment__c>([select id,name,account__c,Account_Owner_ID__c, account__r.Name from LX_Offer_Enrollment__c where id in :OfferEnrollmentIds]);                  
                    system.debug('OEAccountName-->'+OEAccountName);
                    
            }
            showPage = true;
        }catch(Exception e){
            //Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, e.getMessage()));
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Unexpected error has occured. Please try again later.'));
            showPage = false;
        }
        
    }
    public void assignToOwnerClick(){
        if(assignToOwner){
            assignToOwner = false;
        }else{
            assignToOwner = true;
        }
        system.debug('assignToOwner-->'+assignToOwner);
    }
    /**
    * Save the new task and keep the existing page
    */
    public void saveNew(){
        //Create the new task list
        List <Task> lTask = new List<Task>();
        //Capture the status for save()
        saveStatus = false;
        try{
            for(String strObjId:arrObjIds){
                Task taskNew = new Task();
                
                if(showWhoId){
                    //If the selected objects are not Contacts/Leads
                    //Commented this line to assign what id to account id
                    taskNew.WhatId = displayAccountIds.get(strObjId);
                    //taskNew.WhatId = strObjId;
                }else{
                    //If only Contacts/Leads
                    taskNew.WhoId = strObjId;
                }
                //Added by USI Team: Populating the whatid on tasks
                if(isContact!=null && isContact==true)
                if(contAccountName!=null)
                taskNew.whatid = contAccountName.get(strObjId).accountid;
                
                //Added by USI Team: Populating the whoid on tasks
                if(isAccount!=null && isAccount==true)
                if(accContactID!=null)
                taskNew.whoid = accContactID.get(strObjId) !=null?accContactID.get(strObjId):null;                
                //Assign to the record owner based on selected options
                if(!assignToOwner){
                    if( task.OwnerId == null){//Kapil:Check if the Owner not selected.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Please select owner.' ));
                        return;
                    }
                    taskNew.OwnerId = task.OwnerId;
                    System.Debug('@@Owner ID Assignment1 - Assign to owner unchecked');  
                }else{
                if(assignToOwner && OEAccountName != null && OEAccountName.get(strObjId) != null &&  OEAccountName.get(strObjId).account__r != null && OEAccountName.get(strObjId).Account_Owner_ID__c != null){
                    taskNew.OwnerId = OEAccountName.get(strObjId).Account_Owner_ID__c; 
                    System.Debug('@@Owner ID Assignment2 - Assign to owner checked');  
                }else{
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Unexpected error has occured. Please contact your system administrator.' ));
                    return;
                }
                }
                
                
                taskNew.status = task.status;
                taskNew.subject = task.subject;
                taskNew.activityDate = task.activityDate;
                taskNew.priority = task.priority;
                taskNew.description = task.description;
                //If the reminder is set
                if(task.IsReminderSet){
                    taskNew.IsReminderSet = true;
                    //Kapil:Check if the reminder time is not set.
                    if(reminderTime == null){
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Select the reminder time.' ));
                        return;
                    }
                    String [] arrReminderTimes = reminderTime.split(':');
                    Time tmpTime = Time.newInstance(Integer.valueOf(arrReminderTimes[0]), Integer.valueOf(arrReminderTimes[1]), 0, 0);
                    if(contact.Birthdate == null){
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Select the reminder date.' ));
                        return;
                    }
                    Datetime reminderDateTime = Datetime.newInstance(contact.Birthdate, tmpTime);
                    taskNew.ReminderDateTime = reminderDateTime;
                }
                lTask.add(taskNew);
            }
            //Insert the new tasks to the SFDC Org  
            if(lTask.size() > 0) //Check the list size before a DML operation
                insert lTask;
                
        }catch(Exception e){
            //Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, e.getMessage()));
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, 'Task(s) was not created.'));
            return;
        }
        
        saveStatus = true;
        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.CONFIRM, 'Task(s) successfully created.'));
        //Send email
        if(sendNotificationEmailCheckBox){
            sendMail(lTask);
        }
    }
    /**
    * Save the new task and to back to the previous page 
    * (If no errors)
    */
    public Pagereference save(){
        saveNew();
        if(saveStatus){
        //PageReference pageRef = new PageReference('https://cs15.salesforce.com/ui/desktop/DesktopPage');
        //Kapil: Return to Offer Enrollments tab after the records are created.
        //Amit - updated the page reference to redirect the user back to Home Page
        //PageReference pageRef = new PageReference('/a9z/o');
        PageReference pageRef = new PageReference('/home/home.jsp');
        pageref.setRedirect(true);
        return pageref;

        }
        return null;
    }   
    /**
    * Send email to the assigned engineer
    */
    private void sendMail(List <Task> lTask){
        try{
            //Set mail parameters
            //Query the assigned user
            User assignedUser = [Select u.Name, u.Email From User u where u.Id =: task.OwnerId];
            //Prepare the mail message
            Messaging.Singleemailmessage singleMail = new Messaging.Singleemailmessage();
            singleMail.setToAddresses(new String[]{ assignedUser.Email });
            singleMail.setSubject(task.subject);
            //Generate the HTML body and the plain text body
            String strText = 'To: ' + assignedUser.Name + '<br/><br/>';
            strText += System.Userinfo.getName() + ' has assigned you the following task(s):<br/><br/>';
            strText += 'Subject: ' + task.subject + '<br/><br/>';
            strText += objName + ':<br/>';
            
            String strPlainText = 'To: ' + assignedUser.Name + '/n/n';
            strPlainText += System.Userinfo.getName() + ' has assigned you the following task(s):/n/n';
            strPlainText += 'Subject: ' + task.subject + '/n/n';
            strPlainText += objName + ':/n';
            
            //Put the tasks with objects ids
            Map <Id,Id> mObjectTask = new Map<Id,Id>();
            for(Task newTasks:lTask){
                if(showWhoId){
                    mObjectTask.put(newTasks.WhatId, newTasks.Id);
                }else{
                    mObjectTask.put(newTasks.WhoId, newTasks.Id);
                }
            }
            for(Id displayKey:displayNames.keySet()){
                String displayName = displayNames.get(displayKey);
                Id taskId = mObjectTask.get(displayKey);
                strText += '-' + displayName;
                strText += ' (<a href=\'http://' + URL.getSalesforceBaseUrl().getHost() + '/' + taskId  + '\'>';
                strText += 'http://' + URL.getSalesforceBaseUrl().getHost() + '/' + taskId  + '</a>)';
                strText += '<br/>';
                
                strPlainText += '-' + displayName;
                strPlainText += ' (http://' + URL.getSalesforceBaseUrl().getHost() + '/' + taskId  + ')';
                strPlainText += '/n';
            }
            strText += '<br/>Priority: ' + task.Priority + '<br/><br/>';
            
            strPlainText += '/nPriority: ' + task.Priority + '/n/n';
            
            //Set the test message to the mail
            singleMail.setHtmlBody(strText);
            singleMail.setPlainTextBody(strPlainText);
            //Send the mail
            Messaging.sendEmail(new Messaging.Singleemailmessage [] { singleMail });
        }catch(Exception e){
            //Capture if unexpected error occurs - such as Salesforce mail limit
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Task(s) added. Mail not sent.'));
        }  
        
        System.debug('Host: ' + URL.getSalesforceBaseUrl().getHost()); 
    }
    
    /**
    * Insert in the ReminderDate List the Time : Hours:Min
    */ 
    public List<SelectOption> getselReminderOptions(){
        selReminderOptions = new List<SelectOption>();
        String val = '' ; 
        for (Integer i = 0 ; i < 24 ; i++){
            // Draw the options to add to the reminder picklist 
            val = i+':'+'00';           
            selReminderOptions.add(new SelectOption(val,val));
            val = i+':'+'30';
            selReminderOptions.add(new SelectOption(val,val));
        }
        return selReminderOptions;    
    } 
    /**
    * Go to the previous page
    */
    public Pagereference back(){
        Pagereference pageRef = new Pagereference('/' + objPrefix);
        pageRef.setRedirect(true);
        return pageRef;
    }
    /**
    * Display the selected object names in front end
    */
    public List <String> getTableDisplayNames(){
        List <String> rtnList = new List<String>();

    /*        
        for(String displayName:displayNames.values()){
            rtnList.add('-' + displayName);
        }
    */
        
        for(Id displayKey:displayAccountNames.keySet()){
        //for(LX_Offer_Enrollment__c obj:OEAccountName.values()){
            //rtnlist.add('-'+ obj.Name);
               rtnlist.add('-'+ displayAccountNames.get(displayKey));
        }
        
        return rtnList;
    }    
    
   
}