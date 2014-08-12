/* Class Name   : LX_contract_SAP_extension 
    * Description   : This is a controller class for the VF page LX_Contract_SAP_request . 
    * Created By   : Maruthi Kolla
    * Created Date : 26-09-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Maruthi Kolla        26-09-2013               1000                Initial Version    
    */
public class LX_contract_SAP_extension {
    //Variables declaration 
    Public pse__Proj__c proj1{get;set;}
    Public pse__Proj__c proj2{get;set;}
    Public String licSoldToVar{get;set;}  
    Public String ShipToNameVar{get;set;}  
    Public String ShipToEmailVar{get;set;}  
    Public String billConEmailVar{get;set;}   
    Public String billConPhoneVar{get;set;}  
    Public Opportunity opp1{get;set;}
    Public String specInst{get;set;}
    Public String opporNum;
    Public Date projStartDate;
    Public Date projEndDate;
    Public String projName;
    Public String projID1;
    Public String endCusName;
    Public String endCusNum;
    Public String ShipToName;
    Public String ShipToEmail;
    Public String Fax;
    Public String licSoldTo;
    Public String licCon;
    Public String licConEmail;
    Public String licConFax{get;set;}
    Public String billCon;
    Public String billConPhone;
    Public String billConEmail;
    Public String PO;
    Public String PMResp;
    Public String AM;
    Public String industry;
    Public String comCode;
    Public String division;
    Public String geovalue;
    Public String category;
    Public String projClass;
    Public String profCenter;
    Public String billConPhoneValue{get;set;}
    
    Public String BillToID;
    Public String ShipToID;
    Public String BillToCompany;
    Public String ShipToCompany;
    Public String BillToCity;
    Public String ShipToCity;
    Public String BillToState;
    Public String ShipToState;
    Public String BillToPostal;
    Public String ShipToPostal;
    Public String BillToCountry;
    Public String ShipToCountry;
    
    Public Date smsaStartDate{get;set;}
    Public Date smsaEndDate{get;set;}
    Public String billToAddress{get;set;}
    Public String shipToAddress{get;set;}
    Public LIST<AggregateResult> assigResourceHours = new LIST<AggregateResult>();
    public List<AssignWrapper> lstwrap{get; set;}
    Public String emailBody;
    Public String projid=ApexPages.currentPage().getParameters().get('id');
    public List<GroupMember> grpMem = new List<GroupMember>();
    public List<String> emailaddress = new List<String>();
    Set<ID> grpMemID = new Set<ID>();
    private final set<string> PartTypeValue = new set<string> {'Prof Service - Time','Prof Service - Fixed Fee','PROF SERVICE - EXPENSES','PROF SERVICE - FIXED FEE','PROF SERVICE - TIME'};
    private boolean ProjCategory = false;
    public Case cs{get;set;}
    public Boolean myFlag{get; set;}
    Public  Double addmonthsvalue;
    
    
    /*  Description : This is a Constructor. This populates all the values on the VF page on load.
    *  Param - no params
    *  Returns :  VOID
    */
    public LX_contract_SAP_extension() {
        lstwrap = new List<AssignWrapper>();
        myFlag=false;
        //Fetching all the variables from the project to make them available on the VF page on load
        proj1 = [select pse__Opportunity__r.Account.Company_Code__c, LX_Bill_To_Company__c,LX_Bill_To_City__c,LX_Ship_To_City__c,LX_Ship_To_State__c,LX_Ship_To_Postal__c,LX_Ship_To_Country__c, LX_Bill_To_State__c,LX_Bill_To_Postal__c,LX_Bill_To_Country__c,LX_Ship_To_Company__c, LX_Ship_To_ID__c, LX_Bill_To_ID__c, Project_Category__c,pse__Opportunity__r.LX_Sold_To_New__r.LX_SAP_Sold_To_ID__c, Accounting_Contact__r.Phone,Accounting_Contact__r.Email,Special_Handling_Instructions__c,id,pse__Opportunity__r.Opportunity_Number__c, pse__Start_Date__c,pse__End_Date__c,Name,pse__Project_ID__c,Account_Name__c,pse__Account__r.Company_Number__c,pse__Opportunity__r.LX_Sold_To_New__r.name,Ship_To_Name__c,LX_Bill_To_Address__c,LX_Bill_To_Address_2__c,LX_Ship_To_Address__c,LX_Ship_To_Address_2__c,Bill_To_Name__c,LX_Bill_To_Email_Address__c,PO_Number__c,Project_Manager_Name__c,pse__Account__r.owner.name,pse__Practice__r.name,pse__Account__r.Company_Code__c,pse__Account__r.LX_Geo__c,SMSA_start_Date__c,SMSA_End_Date__c,Contract_SAP_Project_Requested__c,pse__Opportunity__r.Ship_To__r.name,pse__Opportunity__r.Ship_To__r.Email,pse__Opportunity__r.BW_SMSA_Term__c,pse__Project_Manager__c from pse__Proj__c where id =:projid];
        billToAddress = proj1.LX_Bill_To_Address__c !=null?proj1.LX_Bill_To_Address__c +',':'' + proj1.LX_Bill_To_Address_2__c!=null?proj1.LX_Bill_To_Address_2__c +',':'' + proj1.LX_Bill_To_City__c!=null?proj1.LX_Bill_To_City__c +',':'' + proj1.LX_Bill_To_State__c!=null?proj1.LX_Bill_To_State__c +',':'' + proj1.LX_Bill_To_Postal__c!=null?proj1.LX_Bill_To_Postal__c +',':'' + proj1.LX_Bill_To_Country__c!=null?proj1.LX_Bill_To_Country__c+',':'' ;
        shipToAddress = proj1.LX_Ship_To_Address__c!=null?proj1.LX_Ship_To_Address__c+',':'' + proj1.LX_Ship_To_Address_2__c!=null?proj1.LX_Ship_To_Address_2__c+',':'' + proj1.LX_Ship_To_City__c!=null?proj1.LX_Ship_To_City__c+',':'' + proj1.LX_Ship_To_State__c!=null?proj1.LX_Bill_To_State__c +',':'' + proj1.LX_Ship_To_Postal__c!=null?proj1.LX_Ship_To_Postal__c+',':'' + proj1.LX_Ship_To_Country__c!=null?proj1.LX_Ship_To_Country__c+',':'' ;
        addmonthsvalue = proj1.pse__Opportunity__r.BW_SMSA_Term__c;
        //Fetching the opportunity products
        opp1 = [SELECT id,SAP_Status__c,SAP_Sent__c,(select Part_Number__c,Part_Description__c,Quantity,Price_Type__c,Product_Family__c,UnitPrice,TotalPrice from opportunitylineitems) from opportunity where id = :proj1.pse__Opportunity__c];
        
        for(OpportunityLineItem lineItem :opp1.OpportunityLineItems){
            system.debug('>>>>>>lineItem>>>>>>>>>'+lineItem);
            system.debug('>>>>>>lineItem>.Part_Number__c>>>>>>>>'+lineItem.Product_Family__c);
            if(PartTypeValue.contains(lineItem.Product_Family__c)){
                ProjCategory = true;
                break;
            }
        }
        system.debug('>>>>>>ProjCategory >>>>>>>>>'+ProjCategory );
        
        //Fetching the project assignment resources planned hours
        assigResourceHours =[SELECT sum(Original_Planned_Hours__c) cnt,pse__resource__r.name FROM pse__Assignment__c WHERE pse__Project__c = :proj1.id group by pse__resource__r.name];
        for(AggregateResult ar : assigResourceHours ){
            lstwrap.add(new Assignwrapper(String.valueOf(ar.get('name')), Integer.valueOf(ar.get('cnt'))));        
        }
        
        //Setting the variables to use in the emailBody
        specInst =proj1.Special_Handling_Instructions__c!=null? proj1.Special_Handling_Instructions__c:'';
        opporNum = proj1.pse__Opportunity__r.Opportunity_Number__c!=null? proj1.pse__Opportunity__r.Opportunity_Number__c:'';
        projStartDate =proj1.pse__Start_Date__c;
        projEndDate =proj1.pse__End_Date__c;
        projName =proj1.name!=null? proj1.name:'';
        projID1 =proj1.pse__Project_ID__c!=null? proj1.pse__Project_ID__c:'';
        endCusName =proj1.Account_Name__c!=null? proj1.Account_Name__c:'';
        endCusNum=proj1.pse__Account__r.Company_Number__c!=null?proj1.pse__Account__r.Company_Number__c:'';
        licCon = proj1.Ship_To_Name__c!=null? proj1.Ship_To_Name__c:'';
        licConEmail='';
        //licConFax='';
        
        
        
        PO =proj1.PO_Number__c!=null?proj1.PO_Number__c:'';
        PMResp = proj1.Project_Manager_Name__c!=null? proj1.Project_Manager_Name__c:'';
        AM=proj1.pse__Account__r.owner.name!=null?proj1.pse__Account__r.owner.name:'';
        industry=proj1.pse__Practice__r.name!=null?proj1.pse__Practice__r.name:'';
        comCode=proj1.pse__Opportunity__r.Account.Company_Code__c!=null?proj1.pse__Opportunity__r.Account.Company_Code__c:'';
        
        BillToID=proj1.LX_Bill_To_ID__c!=null?proj1.LX_Bill_To_ID__c:'';
        ShipToID=proj1.LX_Ship_To_ID__c!=null?proj1.LX_Ship_To_ID__c:'';
        BillToCompany=proj1.LX_Bill_To_Company__c!=null?proj1.LX_Bill_To_Company__c:'';
        ShipToCompany=proj1.LX_Ship_To_Company__c!=null?proj1.LX_Ship_To_Company__c:'';
        BillToCity=proj1.LX_Bill_To_City__c!=null?proj1.LX_Bill_To_City__c:'';
        ShipToCity=proj1.LX_Ship_To_City__c!=null?proj1.LX_Ship_To_City__c:'';
        BillToState=proj1.LX_Bill_To_State__c!=null?proj1.LX_Bill_To_State__c:'';
        ShipToState=proj1.LX_Ship_To_State__c!=null?proj1.LX_Ship_To_State__c:'';
        BillToPostal=proj1.LX_Bill_To_Postal__c!=null?proj1.LX_Bill_To_Postal__c:'';
        ShipToPostal=proj1.LX_Ship_To_Postal__c!=null?proj1.LX_Ship_To_Postal__c:'';
        BillToCountry=proj1.LX_Bill_To_Country__c!=null?proj1.LX_Bill_To_Country__c:'';
        ShipToCountry=proj1.LX_Ship_To_Country__c!=null?proj1.LX_Ship_To_Country__c:'';
        
        division='ISS';
        geovalue=proj1.pse__Account__r.LX_Geo__c!=null?proj1.pse__Account__r.LX_Geo__c:'';
        //category=proj1.Project_Category__c!=null? proj1.Project_Category__c:'';
        projClass='Implementation';
        profCenter='15001';
       
    }
    
    /*  Description : This is a action method on load. This updates the ProjectCategory field on project.
    *  Param - no params
    *  Returns :  void
    */ 
    
     Public void init()
    {
     if (!myFlag)
     {
     if(ProjCategory){
        system.debug('>>>>>>inside>>>>>>>>>'+ProjCategory );
       proj1.Project_Category__c = 'Professional Services';
       // proj1.Project_Category__c = 'XYZ1';
    }
        update proj1;
        proj2 = [select Project_Category__c,SMSA_Start_Date__c,SMSA_End_Date__c from pse__Proj__c where id =:projid];
        if(proj2.SMSA_Start_Date__c == null)
        proj2.SMSA_Start_Date__c =system.today();
        Date ds1 = proj2.SMSA_Start_Date__c;       
        proj2.SMSA_End_Date__c = ds1.addmonths(addmonthsvalue.intvalue()).adddays(-1);
        category=proj2.Project_Category__c!=null? proj1.Project_Category__c:'';        
        //smsaStartDate=proj2.SMSA_Start_Date__c;
       // smsaEndDate=proj2.SMSA_End_Date__c;
        }
        
    }
    
  /*  Description : This is for save function. This sends an email to the queue, updates projects and oppotunity fields, Crates a helpdesk case assigned to a queue.
    *  Param - no params
    *  Returns :  pagereference
    */ 
    Public pagereference save(){
        cs = new Case();
        cs.RecordTypeId= Case.sObjectType.getDescribe().getRecordTypeInfosByName().get(LX_PSEHelperClass.CaseSAPProjRecordType).getRecordTypeId();
        // calling the function to send an email to the queue
        sendEmail();
        
        //Calling the function to update opportunity and project fields
        updateProjOppor();
        
        // Logic for creating the case with form details and assigning it to queue.
        cs.ownerid= Label.LX_ISS_Professional_Service_Queue;
        system.debug('Testing1234567'+cs.ownerid);
        if(proj1.pse__Project_Manager__c != null)
        cs.contactid =proj1.pse__Project_Manager__c;
        else 
        cs.Contactid=Label.LX_Contact_ID;
        cs.type = 'Request';
        cs.status='New';
        cs.impact__c = 'Group';
        cs.Urgency__c = 'Medium';
        cs.Origin = 'Email';
        cs.subject ='Request for Creation of SAP Project and SAP Contract';
        cs.Request__c=emailBody;
        cs.Project__c=projid;
        insert cs;
        Pagereference ps=new Pagereference('/'+cs.id);
        return ps;
    }
    
   /*  Description : This is for sending the email to the queue with the form details in the body.
    *  Param - no params
    *  Returns :  void
    */  
    Public void sendEmail()
    {    
        // Logic for creating the list of email addresssess to store the queue members email address.
        grpMem = [SELECT GroupId,UserOrGroupId FROM GroupMember where groupid = :Label.LX_ISS_Professional_Service_Queue ];
        for(GroupMember grp:grpMem)
        grpMemID.add(grp.UserOrGroupId);
        For(User us1 :[Select email from User where id in :grpMemID])
        emailaddress.add(us1.email);
        licSoldTo=licSoldToVar!=null?licSoldToVar:''; 
        ShipToName=ShipToNameVar!=null?ShipToNameVar:'';
        ShipToEmail=ShipToEmailVar!=null?ShipToEmailVar:'';     
        Fax=licConFax!=null?licConFax:'';
        billCon=proj1.Bill_To_Name__c!=null?proj1.Bill_To_Name__c:'';
        billConEmail=proj1.LX_Bill_To_Email_Address__c!=null?proj1.LX_Bill_To_Email_Address__c:'';
        billConPhone= billConPhoneValue!=null?billConPhoneValue:'';
        // Creating the emailBody with the form details
        emailBody = '<h3 align ="center"> Contract/SAP Project Request Details </h3>';
        emailBody = emailBody + '<h4> Special Handling Instructions </h4>' + specInst ;
        emailBody = emailBody + '<h4> Project Details </h4><table border ="1"><tr><td>Opportunity Number: </td><td>'+opporNum+'</td></tr><tr><td>PO Date/Project Start Date:</td><td>'+projStartDate+'</td></tr><tr><td>Forecasted Project End Date:</td><td>'+projEndDate +'</td></tr><tr><td>Project Name:</td><td>'+projName+'</td></tr>';
        emailBody = emailBody + '<tr><td>Project #:</td><td>'+projID1+'</td></tr><tr><td>End Customer Name:</td><td>'+endCusName+'</td></tr><tr><td>End Customer Company Number: </td><td>'+endCusNum+'</td></tr>';
        emailBody = emailBody + '<tr><th> Licensing Account Information Details </th></tr><tr><td>Licensing Sold To</td><td>'+licSoldTo+'</td></tr><tr><td>Licensing Contact:</td><td>'+ShipToName+'</td></tr><tr><td>Licensing Contact Email:</td><td>'+ShipToEmail+'</td></tr><tr><td>Fax:</td><td>'+Fax+'</td></tr>';
        emailBody = emailBody + '<tr><th> Billing Account Information </th></tr><tr><td>Sold To(for information only)</td><td>'+licSoldTo+'</td></tr><tr><td>Bill To Address: </td><td>'+billToAddress+'</td></tr><tr><td>Ship To Address: </td><td>'+shipToAddress+'</td></tr>';
        emailBody = emailBody + '<tr><td>Billing Contact:</td><td>'+billCon+'</td></tr><tr><td>Billing Contact Phone:</td><td>'+billConPhone+'</td></tr><tr><td>Billing Contact Email:</td><td>'+billConEmail+'</td></tr><tr><td>PO #:</td><td>'+PO+'</td></tr>';
        emailBody = emailBody + '<tr><td>Bill To ID:</td><td>'+BillToId+'</td></tr><tr><td>Bill To Company:</td><td>'+BillToCompany+'</td></tr><tr><td>Bill To City:</td><td>'+BillToCity+'</td></tr><tr><td>Bill To State:</td><td>'+BillToState+'</td></tr><tr><td>Bill To Postal:</td><td>'+BillToPostal+'</td></tr><tr><td>Bill To Country:</td><td>'+BillToCountry+'</td></tr>';
        emailBody = emailBody + '<tr><td>Ship To ID:</td><td>'+ShipToId+'</td></tr><tr><td>Ship To Company:</td><td>'+ShipToCompany+'</td></tr><tr><td>Ship To City:</td><td>'+ShipToCity+'</td></tr><tr><td>Ship To State:</td><td>'+ShipToState+'</td></tr><tr><td>Ship To Postal:</td><td>'+ShipToPostal+'</td></tr><tr><td>Ship To Country:</td><td>'+ShipToCountry+'</td></tr>';
        emailBody = emailBody + '<tr><th> Lexmark account information </th></tr><tr><td>PM/Person Responsible:</td><td>'+PMResp+'</td></tr><tr><td>AM:</td><td>'+AM+'</td></tr><tr><td>Industry:</td><td>'+industry+'</td></tr>';
        emailBody = emailBody + '<tr><td>Company Code:</td><td>'+comCode+'</td></tr><tr><td>Division:</td><td>'+division+'</td></tr><tr><td>GEO:</td><td>'+geovalue+'</td></tr><tr><td>Project Category:</td><td>'+category+'</td></tr><tr><td>Project Class:</td><td>'+projClass+'</td></tr><tr><td>Profit Center:</td><td>'+profCenter+'</td></tr></table>';
        emailBody = emailBody + '<h4> Customer Invoice </h4>';
        emailBody = emailBody + '<table border ="1"><tr><td>SMSA Start Date </td><td>'+proj2.SMSA_Start_Date__c+'</td></tr><tr><td>SMSA End Date </td><td>'+proj2.SMSA_End_Date__c+'</td></tr><tr><td>SMSA Contract Term </td><td>'+proj1.pse__Opportunity__r.BW_SMSA_Term__c+'</td></tr></table>';
        if(opp1.opportunitylineitems.size()>0)
        {
        emailBody = emailBody + '<table border ="1"><tr><th>Part Number </th><th>Part Description</th><th>Quantity</th><th>Unit of Measure</th><th>Part Type</th><th>Unit Price</th><th>Total Price</th></tr>';
        for(opportunitylineitem opporItems: opp1.opportunitylineitems){
                emailBody = emailBody + '<tr><td>'+opporItems.Part_Number__c+'</td><td>'+opporItems.Part_Description__c+'</td><td>'+opporItems.Quantity+'</td><td>'+opporItems.Price_Type__c+'</td><td>'+opporItems.Product_Family__c+'</td><td>'+opporItems.UnitPrice+'</td><td>'+opporItems.TotalPrice+'</td></tr>';
            }
        emailBody = emailBody + '</table>';
        }
        else
        emailBody = emailBody + 'No Invoice Data Available';
        emailBody = emailBody + '<h4> Resource Summary </h4>';
        if(lstwrap.size()>0){
        emailBody = emailBody + '<table border ="1"><tr><th>Resource</th><th>Hours</th></tr>';            
            for(AssignWrapper aw: lstwrap){
                emailBody = emailBody + '<tr><td>'+aw.resourcename+'</td><td>'+aw.plannedHours+'</td></tr>';
            }
        emailBody = emailBody + '</table>';
        }
        emailBody = emailBody + '</br>Below is the link to access the project record:</br>';
        emailBody = emailBody + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+projid+'">Click Here</a>';
        
        //Logic for sending the email to queue
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailaddress);
        mail.sethtmlBody(emailBody);
        mail.setSubject('Request for Creation of SAP Project and SAP Contract');
        System.debug('Error');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
   
 /*  Description : This is for updating the project and opportunity fields on save action.
    *  Param - no params
    *  Returns :  void
    */   
    Public void updateProjOppor()
    {
    //Updating the project feilds on save
    system.debug('>>>>>>ProjCategory >>>>>>>>>'+ProjCategory );
   // if(ProjCategory){
       // system.debug('>>>>>>inside>>>>>>>>>'+ProjCategory );
      //  proj1.Project_Category__c = 'Professional Services';
   // }
    proj1.Special_Handling_Instructions__c = specInst;
    proj1.Contract_SAP_Project_Requested__c = true;
    update proj1;
     update proj2;
    
    //Updating the opportunity fields on save
    opp1.SAP_sent__c= 'Yes';
    opp1.SAP_Status__c= 'Sent via Project';
    update opp1;
    }

 /*  Description : This is a wrapper class. This processess the aggregrate result for assignment resources.
    */    
    public class AssignWrapper{
        public string resourceName{get; set;}
        public integer plannedHours{get; set;}
        public AssignWrapper(String s, integer i){
            resourceName = s;
            plannedHours = i;
        }
    }
    
    /*  Description : This is for dynamically populate the SMSA end date on the VF form.
    *  Param - no params
    *  Returns :  void
    */  
    Public void calculates()
    {
    Date ds = proj2.SMSA_Start_Date__c;
    proj2.SMSA_End_Date__c = ds.addmonths(addmonthsvalue.intvalue()).adddays(-1);
    }
  
 /*  Description : This is for cancel function. Does not do any operation. Redirects to the project page.
    *  Param - no params
    *  Returns :  pagereference
    */  
    Public pagereference cancel()
    {
     Pagereference ps1 =new Pagereference('/'+projid);
        return ps1;
    }
}