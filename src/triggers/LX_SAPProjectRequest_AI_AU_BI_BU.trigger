/*
Class Name : LX_SAPProjectRequest_AI_AU_BI_BU 
Description : Trigger to populate few fields, update opportunity feild and automation case creation.
Created By : Sunil Kati (skati@deloitte.com)
Created Date : 13-12-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Sunil Kati       13-12-2013        1000                   Initial Version
Maruthi Kolla    14-12-2013        1001                 Included the logic for populating fields.
*************************************************************************/

trigger LX_SAPProjectRequest_AI_AU_BI_BU on SAP_Project_Request__c (after insert, after update,before insert,before update) {
    
    //Added ByPass Logic on 12/23/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return;  
        
    Set<ID> optyIDs = new set<ID>();
    Set<ID> projectIDs = new set<ID>();
    Set<ID> id_set = new Set<ID>();
    //Set<ID> proj_id = new Set<ID>();
   // Map<ID,ID> SAP_proj_ID = new Map<ID,ID>();
    Set<ID> s_userIDs = new Set<ID>();
    Map<ID,User> m_users = new Map<ID, User>();

    

// Logic to populate account and opportunity fields with project account and opportunity fields.
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        map<id,Opportunity> mpOppty = new map<id,Opportunity>();
        set<id> oppids = new set<id>();
        
        for(SAP_Project_Request__c sap_req : Trigger.new){
            //proj_id.add(sap_req.Project__c);
            //SAP_proj_ID.put(sap_req.id,sap_req.Project__c);
            oppids.add(sap_req.Opportunity__c);
        }
        mpOppty = new map<id,Opportunity>([SELECT Name , OwnerID,LX_Sold_To_New__r.Id,(SELECT Product_Family__c FROM OpportunityLineItems) FROM Opportunity WHERE id IN:oppids ]);//Sunil
        for(ID i : mpOppty.keySet()){
            s_userIDs.add(mpOppty.get(i).OwnerID);
        }
        m_users = new Map<ID,user>([select ID,Legacy_Company__c from user where ID = : s_userIDs]); 
        
       // Map<ID,pse__proj__C> proj_Map = new Map<ID,pse__proj__c>([Select name,pse__Account__c,pse__Opportunity__c from pse__proj__c where id in :proj_id]);
        For(SAP_Project_Request__c sap_req : Trigger.new)
        {
            if(sap_req.Opportunity__c != null){
                ID optyOwner = mpOppty.get(sap_req.Opportunity__c).ownerID;
                sap_req.Division__c = (m_users.get(optyOwner).Legacy_Company__c == 'Lexmark' ? 'ISS' : 'PSW'); 
                           
            }
            
        
          /*
            if(sap_req.Project__c!=null)
            {
                sap_req.Account_Name__c = proj_Map.get(SAP_proj_ID.get(sap_req.id)).pse__Account__c;
                sap_req.Opportunity__c = proj_Map.get(SAP_proj_ID.get(sap_req.id)).pse__Opportunity__c;
            }
            */
            
            if(sap_req.Opportunity__c != null &&  mpOppty.get(sap_req.Opportunity__c) != null && mpOppty.get(sap_req.Opportunity__c).OpportunityLineItems != null)
            {
                Boolean hasPSt = false; Boolean hasFT = false;
                Opportunity tmpOp = mpOppty.get(sap_req.Opportunity__c);
                for(OpportunityLineItem li : tmpOp.OpportunityLineItems)
                {
                    if(li.Product_Family__c == 'Prof Service - Time')
                        hasPSt = true;
                    if(li.Product_Family__c == 'Prof Service - Fixed Fee')
                        hasFT = true;     
                }
                
                if(hasPSt)
                    sap_req.Project_Class__c = 'T&M';
                if(hasFT )
                    sap_req.Project_Class__c = 'Fixed Fee';    
                
                if(hasPSt && hasFT )
                    sap_req.Project_Class__c = 'Fixed Fee & T&M';     
            } 
        }
       
    }
    
    /* // Logic to update opportunity LX_SAP_Project_Request__c field.
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
    {    
    for(SAP_Project_Request__c sap : Trigger.new){
        if(sap.Opportunity__c != null && sap.Project__c != null){
            optyIDs.add(sap.Opportunity__c);
            projectIDs.add(sap.Project__c);   
        }
    }
    
    if(optyIDs.size() >0 && projectIDs.size() >0){
        
        Set<string> billingTypes = new Set<String>();
        billingTypes.add('Time and Materials');
        billingTypes.add('T&M/Fixed');
        billingTypes.add('Fixed Price');
        Map<ID,Opportunity> optyMap = new Map<ID,Opportunity>([select ID, LX_SAP_Project_Request__c from Opportunity where ID IN :optyIDs]);
        Map<ID,pse__Proj__c> projectMap = new Map<ID,pse__Proj__c>([select ID, pse__Billing_Type__c from pse__Proj__c where ID IN :projectIDs and pse__Billing_Type__c IN :billingTypes]);
 
        List<Opportunity> optyUpdate = new List<Opportunity>();
        
       
        for(SAP_Project_Request__c sap : Trigger.new){
            if(sap.Opportunity__c != null && sap.Project__c != null && projectMap.get(sap.Project__c) != null && optyMap.get(sap.Opportunity__c) != null){
                Opportunity op = optyMap.get(sap.Opportunity__c);
                op.LX_SAP_Project_Request__c = true;                
                optyUpdate.add(op);
            }
        }
        if(optyUpdate.size()>0){
        //LX_OpportunityHelper.CreateSAPProject = true;
        System.debug('*************************'+optyUpdate);
            System.database.update(optyUpdate);               
        }
    }
    } */
 
    // Logic to create case on creating SAP project request record.
    if(Trigger.isAfter && Trigger.isInsert)
    {
    System.debug('12345677898');
    for(SAP_Project_Request__c req: Trigger.new)
    id_set.add(req.id);
    
    LX_CaseRequests.create_SAP_cases(id_set);
    }

}