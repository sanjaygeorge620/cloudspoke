/******************************************************
 * Description      : Apex Controller for ABSI_Mass_Task_Action page
 * @author          : Malaka Silva
 * @since           : May 07, 2010  
 * Copyright 2010 ABSI. All rights reserved. 
 ******************************************************/
public with sharing class ABSI_MassTaskController {

    //Capture the values for the standard Task
    public Task task{set;get;}
    //Capture the value for the reminder date/time
    public Contact contact{set;get;}
    public String reminderTime{set;get;}
    //Other Form fields
    public Boolean sendNotificationEmailCheckBox{set;get;}
    public Map <Id,String> displayNames{set;get;}
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
    Public Set<ID> contactIds = new Set<ID>();
    Public Set<ID> accountIds = new Set<ID>();
    List<AccountContactRole> accContRoles = new List<AccountContactRole>();
    Public Map<ID,Contact> contAccountName;
    Public Map<ID,ID> accContactID = new Map<ID,ID>();
    
    
    /**
    * Constructor
    * Initalize the values & generate the object list(Names)
    */
    public ABSI_MassTaskController(){
        //Initalize the variables
        showPage = false;
        task = new Task();
        Task.Subject='Prospect List:'+date.today().format();
       // Task.Status='In Progress';
       Task.Status='Not Started';//Added by arun thakur Emai:FW: Default Status In prospect Screen
        Task.Priority='Normal';
        Task.activityDate=date.today();
        contact = new Contact();
        displayNames = new Map<Id,String>();
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
                    
                    //Handle field that doesn't have a name field
                    if(objName == 'Case'){
                        strFieldName = 'CaseNumber';
                    }
                    
                    String strQuery = 'select id,OwnerId,' + strFieldName + ' from ' + objName + ' ';
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
                    try{
                        SObject [] sfdcObjects = Database.query(strQuery);
                        //Generate the name list
                        for(SObject sfdcObject:sfdcObjects){
                            displayNames.put((Id)sfdcObject.get('id'),(String)sfdcObject.get(strFieldName));
                            ownerIds.put((Id)sfdcObject.get('id'), (Id)sfdcObject.get('OwnerId'));
                        }
                    }catch(Exception e){
                        strQuery = strQuery.replace(',' + strFieldName, ' ');
                        SObject [] sfdcObjects = Database.query(strQuery);
                        //Generate the Id list instead of name list
                        for(SObject sfdcObject:sfdcObjects){
                            displayNames.put((Id)sfdcObject.get('id'),(Id)sfdcObject.get('id'));
                        }
                    }
                }
                  //Added by USI Team : Collecting the accountnames for the contacts 
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
                    accContRoles =[SELECT AccountId,ContactId,IsPrimary FROM AccountContactRole WHERE AccountId in :accountIds and IsPrimary = true];
                    
                    For(AccountContactRole accContRole:accContRoles)
                    {
                        if(accContactID.get(accContRole.AccountId) == '' || accContactID.get(accContRole.AccountId) == null)
                        accContactID.put(accContRole.AccountId,accContRole.ContactId);
                    }
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
                    //If the selected objests are not Contacts/Leads
                    taskNew.WhatId = strObjId;
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
                if(assignToOwner){
                    taskNew.OwnerId = ownerIds.get(strObjId);   
                }else{
                    taskNew.OwnerId = task.OwnerId;
                }
                taskNew.status = task.status;
                taskNew.subject = task.subject;
                taskNew.activityDate = task.activityDate;
                taskNew.priority = task.priority;
                taskNew.description = task.description;
                //If the reminder is set
                if(task.IsReminderSet){
                    taskNew.IsReminderSet = true;
                    String [] arrReminderTimes = reminderTime.split(':');
                    Time tmpTime = Time.newInstance(Integer.valueOf(arrReminderTimes[0]), Integer.valueOf(arrReminderTimes[1]), 0, 0);
                    Datetime reminderDateTime = Datetime.newInstance(contact.Birthdate, tmpTime);
                    taskNew.ReminderDateTime = reminderDateTime;
                }
                lTask.add(taskNew);
            }
            //Insert the new tasks to the SFDC Org
            insert lTask;
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, e.getMessage()));
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
                strText += ' (<a href=\'http://na1.salesforce.com/' + taskId  + '\'>';
                strText += 'http://na1.salesforce.com/' + taskId  + '</a>)';
                strText += '<br/>';
                
                strPlainText += '-' + displayName;
                strPlainText += ' (http://na1.salesforce.com/' + taskId  + ')';
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
        
        for(String displayName:displayNames.values()){
            rtnList.add('-' + displayName);
        }
        return rtnList;
    }    
    
}