public class FlexeraEntitlements_CreateCase {
/*  
* Class Name   : FlexeraEntitlements_CreateCase 
* Description   : Code to handle US1158 from trigger populateFlexeraEntitlementItem such that the cases get initiated for asset item if the related flexera entitlement is not found
* Created By   : Manoj Kolli
* Created Date : 4/23/2012
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                Date                 Modification ID        Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Kapil Reddy Sama        4/30/2013                1000                 Modified Hard Coding
* Sanjay George          03-26-2013                1001                 Modified Hard Coding

*/

    public static void FlexeraEntitlements_CreateCase(Asset_Item__c assetItemRec, string errorMsg, List<Case> CasesToInsert){
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id recordTypeId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId();  
        
       // String baseUrl = URL_Parameter__c.getall().get('Org Host').URL_Value__c; //Commented by Charan for getting the Base URL
           String baseUrl = Url.getSalesforceBaseUrl().toExternalForm();   
           Case newCase = new Case();
           newCase.RecordTypeId = recordTypeId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = LX_SetRecordIDs.AutomationAdminContactId; 
           newCase.Status = 'New';
           newCase.Impact__c = 'Enterprise';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'Medium';
           newCase.Origin = 'Automation';
           newCase.Type = 'Request';
           newCase.Subject = 'Flexera Entitlement Items Creation';
           newCase.Description = 'Error Message: ' + errorMsg + '- within population of FlexeraEntitlementItem.' + '\n'
                                + 'Link: ' + baseUrl + '/' + assetItemRec.id + '\n';
                               // + 'Server Link: ' + baseUrl + '/' + ServerRecID;
                
           CasesToInsert.add(newCase);
    }
    
    //-----------------------------------------------------------------------------------------------
    //--US1201
    //-----------------------------------------------------------------------------------------------
    
    public static void createHelpdeskcase(List<Flexera_Entitlement__c> flexent)
    {    
       /* Commented by Sanjay George on 13/1/2014
       Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id rTId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId(); 
        */
        Id rTId =Lx_SetRecordIDs.CaseHelpDeskRecordTypeId;
        list<Case> caselst = new list<Case>();
        for(Flexera_Entitlement__c flex : flexent)
        {
        String recURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + flex.Id; 
        system.debug('RECORD URL '+recURL);
        Case newCase = new Case();
           newCase.RecordTypeId = rTId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'Enterprise';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'High';
           newCase.Origin = 'Automation';
           newCase.Type = 'Problem';
           newCase.Subject = 'FLEXERA Data not received for Flexera Entitlement '+flex.Name+'';
           string s1 = ' Error Message:  Did not receive Entitlement data in Flexera for Flexera Entitlement Item '+flex.Name+''+ '\n'
                                   + 'Link: ';  
           String s2 = flex.Flexera_Error_Description__c;                                   
           newCase.Description = s1+recURL+'\n'+'\n'+'Flexera Error Description :'+s2;  
              
           caselst.add(newCase);
           }
    if(!caselst.isEmpty())
    {
    try
    {
    insert caselst;
    }
    catch(System.DmlException e)
    {
    for (Integer i = 0; i < e.getNumDml(); i++) 
    {
    System.debug(e.getDmlMessage(i)); 
    }
    }    
    }
}
 public static void createHelpdeskcase_item(List<Flexera_Entitlement_Items__c> flexent)
    {    
       /* Commented by Sanjay George on 13/1/2014
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id rTId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId(); 
        */
         Id rTId = Lx_SetRecordIDs.CaseHelpDeskRecordTypeId;
        list<Case> caselst = new list<Case>();
        for(Flexera_Entitlement_Items__c flex : flexent)
        {
        String recURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + flex.Id; 
        
        Case newCase = new Case();
           newCase.RecordTypeId = rTId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'Enterprise';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'High';
           newCase.Origin = 'Automation';
           newCase.Type = 'Problem';
           newCase.Subject = 'FLEXERA Data not received for Flexera Entitlement Item '+flex.Name+'';
           string s1 = ' Error Message:  Did not receive Entitlement data in Flexera for Flexera Entitlement Item '+flex.Name+''+ '\n'
                                   + 'Link: ';  
           String s2 = flex.Flexera_Error_Description__c;                                   
           newCase.Description = s1+recURL+'\n'+'\n'+'Flexera Error Description :'+s2;  
           caselst.add(newCase);
           }
    if(!caselst.isEmpty())
    {
    try
    {
    insert caselst;
    }
    catch(System.DmlException e)
    {
    for (Integer i = 0; i < e.getNumDml(); i++) 
    {
    System.debug(e.getDmlMessage(i)); 
    }
    }    
    }
}
//------------------------------------------------------------
public static void createHelpdeskcase_Account(List<Flexera_Account__c> flexent)
    {    
        /*Commented by Sanjay George on 13/1/2014
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id rTId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId(); 
        */
        Id rTId = Lx_SetRecordIDs.CaseHelpDeskRecordTypeId;
        list<Case> caselst = new list<Case>();
        for(Flexera_Account__c flex : flexent)
        {
        String recURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + flex.Id; 
        
        Case newCase = new Case();
           newCase.RecordTypeId = rTId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'User';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'Critical';
           newCase.Origin = 'Cases';
           newCase.Type = 'Problem';
           newCase.Customer_Facing_Issue__c = true;
           newCase.Subject = 'FLEXERA Data not received for Flexera Account '+flex.Name+'';
           string s1 = ' Error Message:  Did not receive flexera data in Flexera for Flexera Account '+flex.Name+''+ '\n'            
                                   + 'Link: ';  
           String s2 = flex.Flexera_Error_Description__c;                                   
           newCase.Description = s1+recURL+'\n'+'\n'+'Flexera Error Description :'+s2;  
           caselst.add(newCase);
           }
    if(!caselst.isEmpty())
    {
    try
    {
    insert caselst;
    }
    catch(System.DmlException e)
    {
    for (Integer i = 0; i < e.getNumDml(); i++) 
    {
    System.debug(e.getDmlMessage(i)); 
    }
    }    
    }
}

//----------------------------MEMBER

public static void createHelpdeskcase_Member(List<Flexera_Member__c> flexent)
    {    
         /*Commented by Sanjay George on 13/1/2014
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id rTId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId(); 
        */
        Id rTId = Lx_SetRecordIDs.CaseHelpDeskRecordTypeId;
        list<Case> caselst = new list<Case>();
        for(Flexera_Member__c flex : flexent)
        {
        String recURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + flex.Id; 
        
        Case newCase = new Case();
           newCase.RecordTypeId = rTId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'User';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'Critical';
           newCase.Origin = 'Cases';
           newCase.Type = 'Problem';
           newCase.Customer_Facing_Issue__c = true;
           newCase.Subject = 'FLEXERA Data not received for Flexera Member  '+flex.Name+'';
           string s1 = ' Error Message:  Did not receive flexera data in Flexera for Flexera Member '+flex.Name+''+ '\n'            
                                   + 'Link: ';  
           String s2 = flex.Flexera_Error_Description__c;                                   
           newCase.Description = s1+recURL+'\n'+'\n'+'Flexera Error Description :'+s2;  
           caselst.add(newCase);
           }
    if(!caselst.isEmpty())
    {
    try
    {
    insert caselst;
    }
    catch(System.DmlException e)
    {
    for (Integer i = 0; i < e.getNumDml(); i++) 
    {
    System.debug(e.getDmlMessage(i)); 
    }
    }    
    }
}

//----------------------------Catalog

public static void createHelpdeskcase_Catalog(List<Flexera_Catalog__c> flexent)
    {    
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id rTId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId(); 
        list<Case> caselst = new list<Case>();
        for(Flexera_Catalog__c flex : flexent)
        {
        String recURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + flex.Id; 
        
        Case newCase = new Case();
           newCase.RecordTypeId = rTId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'User';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'Critical';
           newCase.Origin = 'Cases';
           newCase.Type = 'Problem';
           newCase.Customer_Facing_Issue__c = true;
           newCase.Subject = 'FLEXERA Data not received for Flexera Catalog  '+flex.Name+'';
           string s1 = ' Error Message:  Did not receive flexera data in Flexera for Flexera Catalog '+flex.Name+''+ '\n'            
                                   + 'Link: ';  
           String s2 = flex.Flexera_Error_Description__c;                                   
           newCase.Description = s1+recURL+'\n'+'\n'+'Flexera Error Description :'+s2;  
           caselst.add(newCase);
           }
    if(!caselst.isEmpty())
    {
    try
    {
    insert caselst;
    }
    catch(System.DmlException e)
    {
    for (Integer i = 0; i < e.getNumDml(); i++) 
    {
    System.debug(e.getDmlMessage(i)); 
    }
    }    
    }
}

//----------------------------File

public static void createHelpdeskcase_File(List<Flexera_File__c> flexent)
    {    
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id rTId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId(); 
        list<Case> caselst = new list<Case>();
        for(Flexera_File__c flex : flexent)
        {
        String recURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + flex.Id; 
        
        Case newCase = new Case();
           newCase.RecordTypeId = rTId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'User';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'Critical';
           newCase.Origin = 'Cases';
           newCase.Type = 'Problem';
           newCase.Customer_Facing_Issue__c = true;
           newCase.Subject = 'FLEXERA Data not received for Flexera File '+flex.Name+'';
           string s1 = ' Error Message:  Did not receive flexera data in Flexera for Flexera File '+flex.Name+''+ '\n'            
                                   + 'Link: ';  
           String s2 = flex.Flexera_Error_Description__c;                                   
           newCase.Description = s1+recURL+'\n'+'\n'+'Flexera Error Description :'+s2;  
           caselst.add(newCase);
           }
    if(!caselst.isEmpty())
    {
    try
    {
    insert caselst;
    }
    catch(System.DmlException e)
    {
    for (Integer i = 0; i < e.getNumDml(); i++) 
    {
    System.debug(e.getDmlMessage(i)); 
    }
    }    
    }
}

//----------------------------Product

public static void createHelpdeskcase_Product(List<Flexera_Product__c> flexent)
    {    
       /* Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id rTId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId(); 
        */
        Id rTId = LX_SetRecordIDs.CaseHelpDeskRecordTypeId;
        list<Case> caselst = new list<Case>();
        for(Flexera_Product__c flex : flexent)
        {
        String recURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + flex.Id; 
        
        Case newCase = new Case();
           newCase.RecordTypeId = rTId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = LX_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'User';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'Critical';
           newCase.Origin = 'Cases';
           newCase.Type = 'Problem';
           newCase.Customer_Facing_Issue__c = true;
           newCase.Subject = 'FLEXERA Data not received for Flexera Product '+flex.Name+'';
           string s1 = ' Error Message:  Did not receive flexera data in Flexera for Flexera Product '+flex.Name+''+ '\n'            
                                   + 'Link: ';  
           String s2 = flex.Flexera_Error_Description__c;                                   
           newCase.Description = s1+recURL+'\n'+'\n'+'Flexera Error Description :'+s2;  
           caselst.add(newCase);
           }
    if(!caselst.isEmpty())
    {
    try
    {
    insert caselst;
    }
    catch(System.DmlException e)
    {
    for (Integer i = 0; i < e.getNumDml(); i++) 
    {
    System.debug(e.getDmlMessage(i)); 
    }
    }    
    }
}

//---------------------------------SAP_SalesOrder ADDED for US1762

public static void createHelpdeskcase_SAP_SalesOrder(List<SAP_Sales_Order__c> SAP_SO)
    {    
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        /* Commented by Sanjay George to apply best practices
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id rTId = rtMapByName.get(Lx_SetRecordIDs__c.getInstance('CaseHelpDeskRecordName').Value__c).getRecordTypeId(); 
        
        */
        Id rTId =LX_SetRecordIDs.CaseHelpDeskRecordTypeId;
        list<Case> caselst = new list<Case>();
        for(SAP_Sales_Order__c sao : SAP_SO)
        {
        String recURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + sao.Id; 
        
        Case newCase = new Case();
           newCase.RecordTypeId = rTId;
           // Modified By Kapil Reddy Sama on 4/30/2013, Replaced hardcoded Ids with 'LX_SetRecordIDs.AutomationAdminContactId'.
           //newCase.ContactId = '0037000000t4gzv';
           newCase.ContactId = Lx_SetRecordIDs.AutomationAdminContactId;
           newCase.Status = 'New';
           newCase.Impact__c = 'User';
           newCase.Category__c = 'Enterprise Application';
           newCase.Level_1__c = 'Salesforce.com';
           newCase.Urgency__c = 'Critical';
           newCase.Origin = 'Cases';
           newCase.Type = 'Problem';
           newCase.Customer_Facing_Issue__c = true;
           newCase.Subject = 'Error on SAP Sales Order '+sao.Name+'';
           string s1 = ' Error Message:  Error on SAP Sales Order '+sao.Name+''+ '\n'            
                                   + 'Link: ';  
           String s2 = sao.Error_Description__c;                                   
           newCase.Description = s1+recURL+'\n'+'\n'+'SAP Error Description :'+s2;  
           caselst.add(newCase);
           }
    if(!caselst.isEmpty())
    {
    try
    {
    insert caselst;
    }
    catch(System.DmlException e)
    {
    for (Integer i = 0; i < e.getNumDml(); i++) 
    {
    System.debug(e.getDmlMessage(i)); 
    }
    }    
    }
}






}