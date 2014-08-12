public with sharing class createOpportunityOrderShell 
{
    public static Order__c createOpportunityOrderShell(ID OppID)
    {
    /*    Opportunity OppRec = [Select Opportunity_Number__c
                                    , Owner.Name
                                    , Owner.Email
                                    , ISR__r.Name
                                    , ISR__r.Email
                                    , CloseDate
                                    , Bill_To_Name__c
                                    , Ship_To_Name__c
                                    , Project_Contact__r.Name
                                    , Amount
                                    , AccountID
                                    , Purchase_Order__c
                                    from Opportunity
                                    where ID = :oppID]; */
                                    
                                            
                                    
            Opportunity OppRec = (Opportunity)(database.query('Select Opportunity_Number__c, Owner.Name, Owner.Email, ISR__r.Name, ISR__r.Email, CloseDate, Bill_To_Name__c, Ship_To_Name__c, Project_Contact__r.Name, Amount, AccountID, Purchase_Order__c,Ship_To__c,Ship_To__r.name from Opportunity where ID = :oppID'));              
                                    
        List<Order__c> ExistingOrderShells = new List<Order__c> ([Select Status__c from Order__c where Opportunity__c = :oppID and Status__c = true]);
        If(ExistingOrderShells.size()>0)
        {
            For(Order__c OrderShellRec : ExistingOrderShells)
            {
                OrderShellRec.Status__c = false;
            }
            update ExistingOrderShells;
        }                           
        //Added code to remove "ATTN:" from Bill To Name while saving record in ORDER object.
        String strBillToName = (OppRec.Bill_To_Name__c != null ? OppRec.Bill_To_Name__c.replace('ATTN:','') : '');
        String strShipToName = (OppRec.Ship_To__c != null ? OppRec.Ship_To__r.Name: '');
        Order__c OrderRec = new Order__c(Name = (OppRec!= NULL?OppRec.get('Opportunity_Number__c')+'':'')
                                        , AEX__c = OppRec.Owner.Name
                                        , AEX_Email__c =  OppRec.Owner.Email
                                        , ISR__c = OppRec.ISR__r.Name
                                        , ISR_Email__c = OppRec.ISR__r.Email
                                        , Close_Date__c = OppRec.CloseDate
                                        , Amount__c = OppRec.Amount
                                        , Bill_To__c = strBillToName
                                        , Ship_To__c = strShipToName
                                        , Project_Contact__c = OppRec.Project_Contact__r.Name
                                        , status__c = true
                                        , Account__c = OppRec.AccountID
                                        , PO_Number__c = OppRec.Purchase_Order__c
                                        , Opportunity__c = OppRec.ID);
        
        insert OrderRec;                                
                                        
        //create Order Detail Shell
        List<OpportunityLineItem> OppLineItemList = new List<OpportunityLineItem>([Select ID
                                         , PricebookEntry.Product2.Name_Abbrev__c
                                         , Quantity
                                         FROM opportunityLineItem WHERE opportunityID = :oppID]);
                                         
        List<Order_Detail__c> OrderDetailList = new List<Order_Detail__c>();
        for(OpportunityLineItem OppLineItems : OppLineItemList)
        {
            Order_Detail__c OrderDetailRec = new Order_Detail__c(Name = OppLineItems.PricebookEntry.Product2.Name_Abbrev__c
                                                                ,Order__c = OrderRec.ID
                                                                ,Quantity__c = OppLineItems.Quantity);
            OrderDetailList.add(OrderDetailRec);
        }                               
        insert OrderDetailList;
        
         system.debug('Check Order ordershell' +OrderRec);
            
        return OrderRec;
        

    }
    public static map<ID,Order__c> createOpportunityOrderShellmap(Set<ID> oppset,List<Opportunity> opplist,Map<ID,list<OpportunityLineItem>> linemap)
    {
        //Code added for portal change on 21/06/2013
        Set<Id> SetOppsToShare = shareOppRecordsToPortalUsers(opplist);
        //Check the size of opps and create clone records in order object
        //if(lstOppsToShare == null || lstOppsToShare.size() <= 0) return null; 
        FirstRun_Check.FirstRun_OrderShellCreation = False;
        map<ID,Order__c> returnthis = new map<ID,Order__c>();     
        Set<ID> orderset = new Set<ID>();
        List<Order_Detail__c> OrderDetailListtoDel = new List<Order_Detail__c>(); 
        List<Order_Detail__c> OrderDetailList = new List<Order_Detail__c>(); 
        Map<ID,ID> oppordmap = new Map<ID,ID>();
        List<Order__c> Orderstoupsert= new List<Order__c>();                      
        List<Order__c> ExistingOrderShells = new List<Order__c> ([Select ID,opportunity__c from Order__c where Opportunity__c in: oppset and Status__c = true]);  
        system.debug('*******ExistingOrderShells***********'+ ExistingOrderShells );                               
        /*opplist = [Select ID,Opportunity_Number__c,Owner.Name,Owner.Email,ISR__r.Name,ISR__r.Email,CloseDate,Amount,Bill_To_Name__c,Ship_To_Name__c,Project_Contact__r.Name,AccountID,Purchase_Order__c from Opportunity where id IN: oppset];*/
        
        opplist = (List<Opportunity>)(database.query('Select ID,Opportunity_Number__c,Owner.Name,Owner.Email,ISR__r.Name,Ship_To__r.Name,ISR__r.Email,CloseDate,Amount,Bill_To_Name__c,Ship_To_Name__c,Project_Contact__r.Name,AccountID,Purchase_Order__c,Ship_To__c from Opportunity where id IN: oppset'));
        
        for(Order__c ord : ExistingOrderShells)
        {
            orderset.add(ord.id);
            oppordmap.put(ord.Opportunity__c,ord.id);    
        }
        
        OrderDetailListtoDel = [Select ID from Order_Detail__c where Order__c in: orderset];
        
        if(!OrderDetailListtoDel.isEmpty())
        {
            Delete OrderDetailListtoDel;
        }
        boolean bShowForPortalUser;
        for(opportunity oppRec : oppList)
        {
            bShowForPortalUser = false;
            system.debug('SetOppsToShare == '+SetOppsToShare);
            system.debug('oppRec == '+oppRec);
            if(SetOppsToShare != null && SetOppsToShare.contains(oppRec.Id))
            {
                bShowForPortalUser = true;
            }
            //Added code to remove "ATTN:" from Bill To Name while saving record in ORDER object.
            String strBillToName = (OppRec.Bill_To_Name__c != null ? OppRec.Bill_To_Name__c.replace('ATTN:','') : '');
            String strShipToName = (OppRec.Ship_To__c != null ? OppRec.Ship_To__r.Name: '');
            if(oppordmap.containskey(oppRec.id))
            {
                 Order__c OrderRec = new Order__c(  Id = oppordmap.get(oppRec.id)
                                                    , Name = (OppRec!=NULL? OppRec.get('Opportunity_Number__c')+'':'')
                                                    , AEX__c = OppRec.Owner.Name
                                                    , AEX_Email__c =  OppRec.Owner.Email
                                                    , ISR__c = OppRec.ISR__r.Name
                                                    , ISR_Email__c = OppRec.ISR__r.Email
                                                    , Close_Date__c = OppRec.CloseDate
                                                    , Amount__c = OppRec.Amount
                                                    , Bill_To__c = strBillToName
                                                    , Ship_To__c = strShipToName
                                                    , Project_Contact__c = OppRec.Project_Contact__r.Name
                                                    , status__c = true
                                                    , Account__c = OppRec.AccountID
                                                    , PO_Number__c = OppRec.Purchase_Order__c
                                                    , Opportunity__c = OppRec.ID
                                                    , LX_Show_For_Portal_Users__c = true);
                                                    
                  Orderstoupsert.add(OrderRec);     
            }
            else
            {
                Order__c OrderRec = new Order__c(Name = (OppRec!= NULL?OppRec.get('Opportunity_Number__c')+'':'')
                                                    , AEX__c = OppRec.Owner.Name
                                                    , AEX_Email__c =  OppRec.Owner.Email
                                                    , ISR__c = OppRec.ISR__r.Name
                                                    , ISR_Email__c = OppRec.ISR__r.Email
                                                    , Close_Date__c = OppRec.CloseDate
                                                    , Amount__c = OppRec.Amount
                                                    , Bill_To__c = strBillToName
                                                    , Ship_To__c = strShipToName
                                                    , Project_Contact__c = OppRec.Project_Contact__r.Name
                                                    , status__c = true
                                                    , Account__c = OppRec.AccountID
                                                    , PO_Number__c = OppRec.Purchase_Order__c
                                                    , Opportunity__c = OppRec.ID
                                                    , LX_Show_For_Portal_Users__c = true);
                                                    
                  Orderstoupsert.add(OrderRec);  
            
            }
        }
        
       if(!Orderstoupsert.isEmpty())
       {
            upsert Orderstoupsert;
       }
       
       for(Order__c ord : Orderstoupsert)
       {
           if(linemap.containskey(ord.Opportunity__c))
           {
               if(!linemap.get(ord.Opportunity__c).isEmpty())
               {
                    for(OpportunityLineItem OppLineItems : linemap.get(ord.Opportunity__c))
                    {
                        Order_Detail__c OrderDetailRec = new Order_Detail__c(Name = OppLineItems.PricebookEntry.Product2.Name
                                                                            ,Order__c = Ord.ID
                                                                            ,Quantity__c = OppLineItems.Quantity);
                        OrderDetailList.add(OrderDetailRec);
                    }      
               }
           }
           
           if(!returnthis.containskey(ord.Opportunity__c))
           {
            returnthis.put(ord.Opportunity__c,ord);
           }   
       }
       
       if(!OrderDetailList.isEmpty())
       {
            insert OrderDetailList;    
       }    
        return returnthis;
    }
    //Added below method for portal changes on 21/06/22013
    private static Set<Id> shareOppRecordsToPortalUsers(List<Opportunity> opplist)
    {
        system.debug('opplist == '+opplist);
        List<Opportunity> lstOppsToShare = new List<Opportunity>();
        Set<Id> setOppIds = new Set<Id>();
        Set<Id> setProgramEnrollMents = new Set<ID>();
        Map<Id, Id> mapOppEnrollmentIds = new Map<Id,Id>();
        //Check whether all opportunitty records has 
        for(Opportunity obj : oppList)
        {
           if(obj.LX_Program_Enrollment__c != null)
            mapOppEnrollmentIds.put(obj.LX_Program_Enrollment__c,obj.Id);
        }
        
        if(mapOppEnrollmentIds.size() <= 0) return null;
        //Query Progran Enrollment object
        for(LX_Program_Enrollment__c objProgramEnrollment : [select id,LX_Provides_PSW_Portal_Access__c 
                                                             from LX_Program_Enrollment__c 
                                                             where id in : mapOppEnrollmentIds.keySet()])
        {
                system.debug('objProgramEnrollment == '+objProgramEnrollment);
                system.debug('mapOppEnrollmentIds == '+mapOppEnrollmentIds);
                //Check if program enrollment has portal access or not if not then we simply skip this opp reecord from creating clone record
                if(objProgramEnrollment.LX_Provides_PSW_Portal_Access__c != null && objProgramEnrollment.LX_Provides_PSW_Portal_Access__c.toLowerCase() == 'yes')//lstOppsToShare.add(mapOppEnrollmentIds.get(objProgramEnrollment.Id));
                    setOppIds.add(mapOppEnrollmentIds.get(objProgramEnrollment.Id));
            
        }
        system.debug('setOppIds == '+setOppIds);
        //return list of opps records to share
        return setOppIds;
        
        
        /*List<Opportunity> lstOppsToShare = new List<Opportunity>();
        for(Opportunity obj : oppList)
        {
           if(obj.LX_Has_Portal_Access__c == 'Yes')
            lstOppsToShare.add(obj);
        }
        //return opp list
        return lstOppsToShare;*/
        
    }
}