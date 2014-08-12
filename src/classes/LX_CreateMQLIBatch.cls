/*
Class Name : LX_CreateMQLIBatch
Description : Batch class to delete the MQLI
Created By : Veenu Trehan (vtrehan@deloitte.com)
Created Date : 28-4-2014
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Veenu Trehan      28-4-2014         1000                   Initial Version
Shubashish Rai    28-04-2014                              Modified

*************************************************************************/


global class LX_CreateMQLIBatch implements Database.Batchable<sObject>,Database.Stateful{
    global final map<id,Opportunity> oppMap = new map<id,Opportunity>();
    global final map<id,Opportunity> childOppMap = new map<id,Opportunity>();
    global final map<id,OpportunityLineItem> lineItems = new Map<id, OpportunityLineItem>();
    global final map<id, List<OpportunityLineItem>> lineItemsMap = new Map<id, List<OpportunityLineItem>>();
    global final map<id,Id> childOppMapWithParent = new map<id,Id>();  
   // global final Long batchIdentifierVal ;
    global set<id> UpsertErrorSet=new set<id>();
   
    //(oppMap,childOppMap,lineItems,lineItemsMap,childOppMapWithParent,batchIdentifier);
    
  //  global LX_CreateMQLIBatch(map<id,Opportunity> ParentOpps, map<id,Opportunity> ChildOpps, map<id,OpportunityLineItem> lineItemsVar, Map<Id,List<OpportunityLineItem>> LineItemMapVar, Map<id,Id> OppParentMap, Long batchIdentifier){
      global LX_CreateMQLIBatch(){  
        
    }  
    
    global List<LX_Master_Quote_Line_Item__c> start(Database.BatchableContext BC){
        return mqliUpdate1(oppMap,childOppMap,lineItems,lineItemsMap,childOppMapWithParent);
    }
    
    global void execute(Database.BatchableContext BC, List<LX_Master_Quote_Line_Item__c> scope){
          Schema.sObjectField childLineField = LX_Master_Quote_Line_Item__c.LX_ChildOpp_LineID__c.getdescribe().getSObjectField();
        try{ 
           Database.UpsertResult[] srList=database.upsert(Scope,childLineField,false);
            for(Database.UpsertResult UpsertRec :srList ){
            if(!UpsertRec.isSuccess()){
                UpsertErrorSet.add(UpsertRec.getId() );
                }
            }
         }catch(Exception ex){
            System.debug('Could not perform upsert operation'+ex.getMessage());
            LX_CommonUtilities.createExceptionLog(ex);
          }
        System.debug('@@@@-Last line of exectute method');
    }
    
    global void finish(Database.BatchableContext BC){ 
        List<Opportunity> updateOpp = new List<Opportunity>();  //list to store Opportunity Records to update Notify Owner field  
        //updating the notify owner field to send out the email alerts
        list<LX_Master_Quote_Line_Item__c> UpsertErrorList =new list<LX_Master_Quote_Line_Item__c>(); 
        set<id> SetOppid = new set<id>();
        set<Id> MasterOppSet=new set<id>();
        set<id> ChildOppSet=new set<id>();
        System.debug('UpsertErrorSet.size() @@@1' + UpsertErrorSet.size());
        if(UpsertErrorSet.size()>0){
            UpsertErrorList=[select id,LX_Opportunity__c,LX_Opportunity__r.Master_Opportunity__c from LX_Master_Quote_Line_Item__c where id IN :UpsertErrorSet LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
            if(UpsertErrorList.size()>0){
            
                for(LX_Master_Quote_Line_Item__c MQrec :UpsertErrorList){
                    MasterOppSet.add(MQrec.LX_Opportunity__r.Master_Opportunity__c);
                    ChildOppSet.add(MQrec.LX_Opportunity__c);
                    }
                if(MasterOppSet.size()>0){
                list<opportunity> MastOppList=new list<opportunity>();
                    MastOppList=[Select id,LX_MQLI_error__c,LX_MQLI_Update_Tracker__c,LX_Opportunity_Amount_Prior_Value__c,Amount,LX_Number_of_Products__c,LX_Number_of_Products_Prior_Value__c from opportunity where id IN :MasterOppSet LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
                    for(opportunity MastOppRec:MastOppList){
                    MastOppRec.LX_MQLI_Update_Tracker__c=false;
                    MastOppRec.LX_MQLI_error__c=true;
                    MastOppRec.LX_Number_of_Products_Prior_Value__c=MastOppRec.LX_Number_of_Products__c;
                    MastOppRec.LX_Opportunity_Amount_Prior_Value__c=MastOppRec.Amount;
                    }
                    if(MastOppList.size()>0){
                        try{
                            update MastOppList;
                        } catch(Exception ex){
                            LX_CommonUtilities.createExceptionLog(ex);
                            }
                        }
                }
                }
            }
        System.debug('childOppMap.size() @@@2' + childOppMap.size() + childOppMap.values());    
        for (Opportunity  oppRec : childOppMap.values())
         {
            if(SetOppid.contains(oppRec.Id))
            {
                 oppRec.LX_Notify_Owner__c = false;
            }
            else
            {    
                if(!ChildOppSet.contains(oppRec.id)){
                     oppRec.LX_Notify_Owner__c = true;
                     System.debug('@@@3' + oppRec);
                     SetOppid.add(oppRec.Id);
                     }
            }
            system.debug('SetOppid == '+SetOppid);
            system.debug('SetOppid.size() @@@4' + SetOppId.size());
            //oppRec.LX_Notify_Owner__c = true;
            updateOpp.add(oppRec);
          //  System.debug('Im in the second for loop' + '-------------------->');
         }
             //to make LX_MQLI_Update_Tracker__c of the parent to false
            opportunity oppRec ;
            List<opportunity> UpdateParentOppList = new List<opportunity>();
            system.debug('oppMap-->'+oppMap);
            for(id oppid : oppMap.keyset()){
                if(!MasterOppSet.contains(oppid)){
                    oppRec = new opportunity(id=oppid);
                    oppRec.LX_MQLI_Update_Tracker__c=false;
                    //oppRec.LX_Products_Amount__c = string.valueOf(Integer.valueOf(oppMap.get(oppid).Amount))+string.valueOf(Integer.valueOf(oppMap.get(oppid).LX_Number_of_Products__c));
                       oppRec.Lx_Old_Amount__c=oppMap.get(oppid).Amount;
                       oppRec.LX_Number_of_Products_Prior_Value__c=oppMap.get(oppid).LX_Number_of_Products__c;
                    UpdateParentOppList.add(oppRec);
                    }
            }
         
            try{
            List<Opportunity> lstToUpdate = new List<Opportunity>();
             if(!(updateOpp.isEmpty())){//updating opportunities for which new Master Quote Line Item being added/updated
                LX_OpportunityLineItemHelper.isMQLIUpdated = false;
                //update updateOpp;
                lstToUpdate.addAll(updateOpp);
                //System.debug('Im in the try block' + '((((((((((((((((((()))))))))))))))))))');
                //System.debug('UpdateOpp size' + updateOpp.size() + '------------------------------>');
              }
               if(!(UpdateParentOppList.isEmpty())){//updating opportunities for which new Master Quote Line Item being added/updated
                //update UpdateParentOppList;
                lstToUpdate.addAll(UpdateParentOppList);
               if(lstToUpdate.size() > 0) update lstToUpdate;
               
              }
             }
            catch(Exception ex){
                LX_CommonUtilities.createExceptionLog(ex);
            } 
    }
    public static list<LX_Master_Quote_Line_Item__c> mqliUpdate1(map<id,Opportunity> ParentOpps, map<id,Opportunity> ChildOpps, map<id,OpportunityLineItem> lineItems1,Map<Id,List<OpportunityLineItem>> LineItemMap,Map<id,Id> OppParentMap){
        
        //set to store return values for the masterLine Quotes
        list<LX_Master_Quote_Line_Item__c> returnMasterLineQuotes = new list<LX_Master_Quote_Line_Item__c>();
        //set to store the parent countries
        set<string> parentCountryList = new set<string>();
        //set to store the part numbers
        set<string> parentPartNumbers = new set<string>();
        //map to store the parent part number and country combination.
        map<string,LX_Part_Number_Translation__c> translateParentPartNumMap =new  map<string,LX_Part_Number_Translation__c>();
        
        
        //set to store the child countries
        set<string> childCountryList = new set<string>();
        //set to store the child part numbers
        set<string> childIds = new set<string>();

        /*//set to store the child countries
        set<string> childCountryList = new set<string>();*/

        //map to store the parent part number and country combination.
        map<string,LX_Part_Number_Translation__c> translateChildPartNumMap      = new  map<string,LX_Part_Number_Translation__c>();

        //map to store the parent part number and country combination.
        map<string,LX_Part_Number_Translation__c> translateCountryPartNumMap    = new  map<string,LX_Part_Number_Translation__c>();

        
        
        //If the Parent Opportunity is not null then populate the country set.
        if(ParentOpps != null){
            for(Opportunity opp:ParentOpps.values()){
                //Check the country code is not blank or null
                if((opp.Sales_Organization__c != null)&&(opp.Sales_Organization__r.LX_Country_Code__c != null)&&(opp.Sales_Organization__r.LX_Country_Code__c.trim() != '')){
                    parentCountryList.add(opp.Sales_Organization__r.LX_Country_Code__c);
                }
            }
        }
        
        //If the child Opportunity is not null then populate the country set
        if(ChildOpps != null){
            for(Opportunity opp:ChildOpps.values()){
                if((opp.LX_Country_Code__c != null)&&(opp.LX_Country_Code__c.trim() != '')){
                    childCountryList.add(opp.LX_Country_Code__c);
                }
            }
        }
        
        
        //If the Opportunity Line Items is not null then populate the part Number set.
        if(lineItems1 != null){
            for(OpportunityLineItem line:lineItems1.values()){
                //Check the Part Number is not blank or null
                if((line.Part_Number__c != null)&&(line.Part_Number__c.trim() != '')){
                    parentPartNumbers.add(line.Part_Number__c);
                }
            }
        }
        
        if(parentPartNumbers.size()>0 && parentCountryList.size()>0){
            //Populate the translation variable
            for(LX_Part_Number_Translation__c trans:[select id,LX_Country_Code__c,LX_ID__c,LX_Part_Number__c 
                                                    FROM LX_Part_Number_Translation__c
                                                    WHERE LX_Country_Code__c=:parentCountryList AND LX_Part_Number__c IN :parentPartNumbers]){
                //Populate the map for getting child translation Ids                            
                translateChildPartNumMap.put(trans.LX_Country_Code__c+trans.LX_Part_Number__c ,trans);
                //system.debug('translateChildPartNumMap##'+trans.LX_Country_Code__c+trans.LX_Part_Number__c);    
                //Populate the translation set
                childIds.add(trans.LX_ID__c);          
           }
        }
           
           if(childIds.size()>0 && childCountryList.size()>0) {
            //Populate the translation variable
            for(LX_Part_Number_Translation__c trans:[select id,LX_Country_Code__c,LX_ID__c,LX_Part_Number__c 
                                                    FROM LX_Part_Number_Translation__c
                                                    WHERE LX_ID__c  =:childIds AND LX_Country_Code__c IN :childCountryList]){
                //Populate the map for getting translation record based on the country code and IDs                             
                translateCountryPartNumMap.put(trans.LX_Country_Code__c+trans.LX_ID__c ,trans);
           }
         }
       //Iterate of the Opportunity LineItems1
       
      // System.debug('@@@@' + OppParentMap.keyset() + OppParentMap.values() + '@@@@' + OppParentMap.size());
            //Iterate over the child Opportunity
            for(Id oppId : OppParentMap.keyset()){
                //System.debug('@@@@2' + ChildOpps);
               Opportunity opp =  ChildOpps.get(oppId);
               // System.debug('@@@@' + LineItemMap.keyset() + '@@@@' + LineItemMap.values() + '@@@@' + LineItemMap.size());
                //System.debug('@@@@1' + opp);
               for(OpportunityLineItem line: LineItemMap.get(opp.master_opportunity__c)){
                   LX_Master_Quote_Line_Item__c newLineItem    =   new LX_Master_Quote_Line_Item__c();
                        
                       //update the LX_ChildOpp_LineID__c to generate the unique records.
                       newLineItem.LX_ChildOpp_LineID__c   = string.valueof(opp.id)+'-' + string.valueof(line.id);
                       newLineItem.LX_Original_Part_Number__c=line.Part_Number__c;
                       //VT added 1/20 LX_Extra_Parts_Info__c of mqli should be the same as that of opp product opp product 
                       newLineItem.LX_Extra_Parts_Info__c=line.LX_Extra_Parts_Info__c;
                       newLineItem.LX_Original_Currency__c=line.CurrencyIsoCode ;
                       newLineItem.CurrencyIsoCode=opp.CurrencyIsoCode;
                       newLineItem.LX_Original_Sales_Price__c=line.UnitPrice;
                       newLineItem.LX_ParentID__c=line.Parent_ID__c;
                       newLineItem.LX_Product_Description__c=line.Description;
        
                       /*2/26 VT:Commented 
                       newLineItem.LX_Quantity__c=line.Quantity;*/
                       newLineItem.LX_Quantity__c=1; 
                       newLineItem.LX_Product__c=line.PricebookEntry.Product2.id;
                       newLineItem.LX_Opp_Prod_Opp_Id__c=line.Id+'-'+opp.Master_Opportunity__c;
                       //Update the MLQI with opp
                       newLineItem.LX_Opportunity__c = opp.id;               
        
                       //Update the original Part Number
                       newLineItem.LX_Original_Part_Number__c = line.Part_Number__c;
                        
                        //Populate the conversion    
                       if(line.Part_Number__c!=null || line.Part_Number__c!=''){
                        //system.debug('###opp.LX_Country_Code__c +line.Part_Number__c'+ParentOpps.get(opp.Master_Opportunity__c).Sales_Organization__r.LX_Country_Code__c+line.Part_Number__c);
                        if(ParentOpps.containsKey(opp.Master_Opportunity__c) && ParentOpps.get(opp.Master_Opportunity__c).Sales_Organization__r.LX_Country_Code__c!=null &&
                        translateChildPartNumMap.containsKey(ParentOpps.get(opp.Master_Opportunity__c).Sales_Organization__r.LX_Country_Code__c+line.Part_Number__c)){
                        
                            string childLXID = translateChildPartNumMap.get(ParentOpps.get(opp.Master_Opportunity__c).Sales_Organization__r.LX_Country_Code__c+line.Part_Number__c).LX_ID__c; 
                               //system.debug('childLXID-->'+childLXID);
                               //system.debug('translateCountryPartNumMap.get(opp.LX_Country_Code__c + childLXID)'+translateCountryPartNumMap.get(opp.LX_Country_Code__c + childLXID));
                               //system.debug('translateCountryPartNumMap.get(opp.LX_Country_Code__c + childLXID).LX_Part_Number__c');
                                if(translateCountryPartNumMap.COntainsKey(opp.LX_Country_Code__c + childLXID) && translateCountryPartNumMap.get(opp.LX_Country_Code__c + childLXID).LX_Part_Number__c!=null){ 
                                    newLineItem.LX_Converted_Part_Number__c  = translateCountryPartNumMap.get(opp.LX_Country_Code__c + childLXID).LX_Part_Number__c ; 
                                    system.debug('1st-->'+newLineItem.LX_Converted_Part_Number__c);
                                }
                                 else{
                                    newLineItem.LX_Converted_Part_Number__c=line.Part_Number__c;
                                    system.debug('2nd-->'+newLineItem.LX_Converted_Part_Number__c);
                                }   
                            }
                            else{
                                    newLineItem.LX_Converted_Part_Number__c=line.Part_Number__c;
                                    system.debug('2nd-->'+newLineItem.LX_Converted_Part_Number__c);
                                }   
                        }
                       /* if(newLineItem.LX_Converted_Part_Number__c!=line.Part_Number__c){
                        newLineItem.LX_Is_Part_Converted__c=true;}*/
                       
                        returnMasterLineQuotes.add(newLineItem);
                        
               }
                
            }       
       return returnMasterLineQuotes;
    }
}