trigger Request_UpdateFields on Case (before insert, after insert, before update) {

    //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()) return; 
    
    try{
         /**************************************
         *
         Description: Adding the code for Mobile Request Record type on Case
         *
         *
         Date Revision: 11/15/2011
         *
         By: Manoj Kolli
         *
         *****************************************/ 
         
 
        Schema.DescribeSObjectResult des = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> rtMap = des.getRecordTypeInfosByName();
        
        Set<ID> idManagerLevel1 = new Set<ID>();
        //Map<Id,User> tmpUserMap = new Map<Id,User>();
        ID tmpmanagerID;
        String Mgr1,Mgr2; 
        //End of Mobile Request Record type code
        
        Set<ID> idcontactSet = new Set<ID>();
        Set<ID> idSalesforceUserSet = new Set<ID>();
        Set<ID> idInventoryItemSet= new Set<ID>();
        Id MRrtId = rtMap.get(Lx_SetRecordIDs__c.getAll().get('Case_MobileRequest').Value__c).getRecordTypeId();
        Id BusCardRecTypeID = rtMap.get(Lx_SetRecordIDs__c.getAll().get('Case_BusinessCardRequest').Value__c).getRecordTypeId();
        Id PurchaseRecTypeID = rtMap.get(Lx_SetRecordIDs__c.getAll().get('Case_PurchaseRequest').Value__c).getRecordTypeId();
        Set<ID> idUserSet = new Set<ID>();
        Map<ID, Contact> idToContactMap = new Map<ID, Contact>();
        List<Contact> idToContactList = new List<Contact>();
        Map<ID, Inventory_Catalog__c> idToInventoryMap = new Map<ID, Inventory_Catalog__c>();
        List<Inventory_Catalog__c> idToInventoryList = new List<Inventory_Catalog__c>();
    //    List<RecordType> RecordTypeID_List = [select Id, name from RecordType where (name = 'Business Card Request' or name = 'Purchase Request') and sobjectType = 'Case'];
       List<ID> RecordTypeID_List = new List<ID>();
       RecordTypeID_List.add(PurchaseRecTypeID);    //purchaseRequest
       RecordTypeID_List.add(BusCardRecTypeID);    //business card
       RecordTypeID_List.add(MRrtId);                 //Mobile Request 
       
      
             
        //load in all incoming cases by contact id only if record type for case is business card request
        for (Case caseRec : Trigger.new){
        system.debug('caseRec.RecordTypeID: ' + caseRec.RecordTypeID);
    //    system.debug('recordtypeList' + RecordTypeID_List);
        system.debug('CaseRec.Contactid: ' + CaseRec.Contactid);
    
    //            for (RecordType rt : RecordtypeID_List){
    //                if (rt.name == 'Business Card Request'){
         //                   BusCardRecTypeID = '01270000000Lxo5';//rt.id;           
    //                }  
    //                if (rt.name == 'Purchase Request'){
           //                 PurchaseRecTypeID = '01270000000Lxo0';//rt.id;           
    //                }                  
                    if (caseRec.RecordTypeID == BusCardRecTypeID || caseRec.RecordTypeID == PurchaseRecTypeID || caseRec.RecordTypeID == MRrtId) {
                        
                        idcontactSet.add(CaseRec.Contactid);
                        
                        system.debug('add idcontactSet: ' + idcontactSet);
                        idSalesforceUserSet.add(CaseRec.Contact.pse__Salesforce_User__c);
                        idInventoryItemSet.Add(caseRec.Inventory_Item__c);
                    }
    //            }
      
        }
        
                
        //get list of salesforce user ID based on contact name provided
        if (idcontactset.size() > 0){
            idToContactList = [Select c.id, c.Manager_Level__c, c.pse__Salesforce_User__c, c.firstName, 
                                                                            c.LastName, c.Email, c.Phone, c.MobilePhone, c.Fax, c.title, c.pse__Salesforce_User__r.ManagerId, c.pse__Salesforce_User__r.Manager_Level__c 
                                                                            from Contact c where id in :idContactSet];
            for(contact contactRec : idToContactList){
                idToContactMap.put(contactrec.id, contactRec);
            }                                                                
            system.debug('idToContactMap : ' + idToContactMap );
            
            for (Contact cRec : idToContactMap.values()){
                idcontactSet.add(cRec.pse__Salesforce_User__c);
                system.debug('idcontactSet: ' + idcontactSet);
            }
        }
         //get inventory data related to the inventory item provided on the case
        if (idInventoryItemSet.size() > 0){
            idToInventoryList = [select id, Type__c, Name, cost__c from Inventory_Catalog__c where id in :idInventoryItemSet];
            system.debug('idToUser Map: ' + idToInventoryMap );
            
            for(Inventory_Catalog__c InvRec : idToInventoryList){
                idToInventoryMap.put(InvRec.id, InvRec);
            }
        }
        
        //get user data related to the contact provided on the case
    //    Map<ID, User> idToUserMap = new Map<ID, User>([select id, ManagerID from User where id in :idContactSet]);
    //    system.debug('idToUser Map: ' + idToUserMap);
        
        
        //code for manager hierachy in approval process for Mobile request RT
        for(Case caseRec : trigger.new){  
            for(ID recType : RecordtypeID_List){
                if (caseRec.RecordTypeID == MRrtId){ 
                    Contact tmpcontactObject = idToContactMap.get(caseRec.ContactId);   
                    tmpmanagerID = tmpcontactObject.pse__Salesforce_User__r.ManagerId;
                    idManagerLevel1.add(tmpmanagerID); // added for manager hierarchy
                  }
               }
          }
         Map<Id,User> tmpUserMap = new Map<Id,User>([Select Id,Name,ManagerId,Manager_Level__c from User where Id in :idManagerLevel1]);  
                        
     
            
        //go through trigger to process    
        for(Case caseRec : trigger.new){  
            for(ID recType : RecordtypeID_List){
                if (caseRec.RecordTypeID == BusCardRecTypeID || caseRec.RecordTypeID == PurchaseRecTypeID || caseRec.RecordTypeID == MRrtId){ //caseRec.RecordTypeID == recType.id ) {
             //       system.debug('recTypeID : ' + recType.id);
                    system.debug('Business Card Record Type ID : ' + BusCardRecTypeID);
                    system.debug('case.recordTypeID: ' + caseRec.RecordTypeID);
                    Contact contactObject = idToContactMap.get(caseRec.ContactId);   //get information from map and put into contact format
                    system.debug('contactOBject - contactID:' + contactObject.firstname);
                    Inventory_Catalog__c InventoryObject = idToInventoryMap .get(caseRec.Inventory_Item__c); //get information from map and put into Inventory format
                    system.debug('did I retrieve anything:' + InventoryObject);
                    ID managerID = contactObject.pse__Salesforce_User__r.ManagerId;
                    Mgr1 = contactObject.Manager_Level__c; //added for manager level1
                    System.debug('************Level1 Manager***********'+Mgr1); 
                    idManagerLevel1.add(managerID); // added for manager hierarchy
                    //tmpUserMap.put(managerID,) 
                    system.debug('did I retrieve anything:' + managerID);
                    If(Trigger.isBefore){
                        if(caseRec.RecordTypeID == MRrtId){
                          caseRec.Level1_Manager__c = Mgr1;
                          System.debug('************caseRec.Level1 Manager***********'+caseRec.Level1_Manager__c);
                          }
                         if (managerID != Null && CaseRec.Resource_Manager__c != managerID){
                          caseRec.Resource_Manager__c = managerID;
                         }
                         if(caseRec.RecordTypeID == MRrtId && caseRec.Resource_Manager__c != Null){
                             caseRec.Approver__c = tmpUserMap.get(caseRec.Resource_Manager__c).ManagerId;                             
                             //caseRec.Level2_Manager__c = tmpUserMap.get(caseRec.Resource_Manager__c).Manager_Level__c;
                         }
                        if (caseRec.Status == 'New'&& caseRec.RecordTypeID == BusCardRecTypeID ) {           //only update for Business card requests
                            system.debug('contact full name: ' + contactObject.FirstName + ' ' + contactObject.LastName);
                            caseRec.Business_Card__c = 'Name: ' + contactObject.FirstName + ' ' + contactObject.LastName;
                            caseRec.Business_Card__c = caseRec.Business_Card__c + '\n'+ 'Title: '+ contactObject.Title ;
                            caseRec.Business_Card__c = caseRec.Business_Card__c + '\n'+ 'Email: '+ contactObject.Email ;  
                            caseRec.Business_Card__c = caseRec.Business_Card__c + '\n'+ 'Phone: '+ contactObject.Phone ;
                            caseRec.Business_Card__c = caseRec.Business_Card__c + '\n'+ 'Mobile: '+ contactObject.MobilePhone;
                            caseRec.Business_Card__c = caseRec.Business_Card__c + '\n'+ 'Fax: '+ contactObject.Fax;  
                            
                            caseRec.Subject = 'Business Card Request'; 
                                requestApproval.requestApproval(caseRec);  
                        }
                        if (caseRec.Status == 'New'&& caseRec.RecordTypeID == PurchaseRecTypeID ) {          
                            system.debug('inventory item name ' + caseRec.Inventory_Item__r.Name);
                            system.debug('inventory item ' + caseRec.Inventory_Item__r);
                            system.debug('Inv - inventory item ' + InventoryObject.Name);
                            If (InventoryObject.Name != 'Other'){
                            caseRec.Inventory_Cost__c = InventoryObject.Cost__c;
                            }
                            system.debug('Inventory Type: ' + InventoryObject.Type__c);
                            caseRec.Inventory_Type__c = InventoryObject.Type__c;
                            
                                   
                        }
                    }    
                    else if (Trigger.isAfter){
                         if (caseRec.Status == 'New'&& caseRec.RecordTypeID == MRrtId ) { 
                            if (caseRec.Status == 'New' && caseRec.Resource_Manager__c != Null )  {
                                requestApproval.requestApproval(caseRec); 
                            }  
                         }  
                         if (caseRec.Status == 'New'&& caseRec.RecordTypeID == BusCardRecTypeID ) { 
                            if (caseRec.Status == 'New' && caseRec.Resource_Manager__c != Null )  {
                                requestApproval.requestApproval(caseRec); 
                            }  
                         }  
                         if (caseRec.Status == 'New'&& caseRec.RecordTypeID == PurchaseRecTypeID ) { 
                            if (caseRec.Status == 'New' && caseRec.Resource_Manager__c != Null )  {
                                    system.debug('caseRec.Inventory_Item__c: ' + caseRec.Inventory_Item__c);
                                    system.debug('caseRec.Inventory_Type__c: ' + caseRec.Inventory_Type__c);
                                    system.debug('caseRec.Inventory_Type__c: ' + caseRec.Inventory_Type__c);
                                     if ((caseRec.Inventory_Type__c != 'Server' && caseRec.Inventory_Type__c != null)) {
                                          requestApproval.requestApproval(caseRec);
                                     }     
                               }  
                         } 
                        
                    }    
                }
            }
        }
        }

        catch(Exception e){ 

            //Continue Processing
            } 
           
}