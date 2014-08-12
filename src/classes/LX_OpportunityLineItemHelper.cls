/*
Class Name : LX_OpportunityLineItemHelper
Description : Helper class to consolidate  methods used in the for creation of MQLI from lineitem trigger or creation vf page
Created By : Veenu Trehan(vtrehan@deloitte.com)
Created Date : 12/13/201
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Veenu Trehan     12/13/2013        1000                   Initial Version
Veenu Trehan     1/3/2013                                 Modified to add logic to populate LX_Contract_Type__c” on Opp prod 
Bhanu Prakash    5/26/2014                                Converted OpportunityLineItem from LIst to Set.
*************************************************************************/
public with sharing class LX_OpportunityLineItemHelper {
    public static integer trgCount = 0;
    public static final string ContractType1='SAP CRM Contract';
    public static final string ContractType2='SAP Software Contract';
    public static final string ContractType3='SAP Upfront Discount';
    public static final string ContractType4='Vistex Backend Rebate Supplies';
    public static final string ContractType5='Vistex Backend Rebate Hardware';
    public static final string PurchasingMethod1='Direct';
    public static final string PurchasingMethod2='Indirect';
    public static final string TimingOfDiscount1='Upfront';
    public static final string TimingOfDiscount2='Back-End';
    public static boolean isUpdated=true;
    public static boolean isMQLIUpdated = true;

    /*
     * 
     * Description : Methods to upsert MQLI, which is called from the lineitem trigger or child opp creation vf page as a future method
     * Param - : opportunity, lineitems
     * Returns : null
    */
    @future
    public static void mqliUpdate1WithLinesFuture(string masterOppId, list<id> childOpportunityIds){
        LX_Opportunity_SoldTo_Case.IsFutureCalled = true;
        map<id,Opportunity>oppMap =  new map<id,Opportunity>([SELECT Id, LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,
                                                              MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,
                                                              (Select LX_Country_Code__c, id, CurrencyIsoCode, Master_Opportunity__c From ChildOpportunities__r 
                                                                where id =:childOpportunityIds) 
                                                              FROM Opportunity 
                                                              WHERE Id = :masterOppId limit 1]);
                                                              
       map<id,OpportunityLineItem> lineItems= new map <id,OpportunityLineItem>([Select id,OpportunityId,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,Part_Number__c,Parent_ID__c,Description,Quantity, PricebookEntry.Product2.id,LX_Extra_Parts_Info__c 
                                                                                from OpportunityLineItem
                                                                                where OpportunityId=:oppMap.keyset()]); 
        map<id,Opportunity> childOppMap = new map<id,Opportunity>();                                                      
        for(Opportunity opp:oppMap.values()){
            for(Opportunity child:opp.ChildOpportunities__r){
                childOppMap.put(child.id,child);
            }
        }
       
   map<id,List<OpportunityLineItem>> lineItemsMap = new Map<id, List<OpportunityLineItem>>();
    for(OpportunityLineItem oppLineItem: lineItems.values()){        
             lineItems.put(oppLineItem.id,oppLineItem);
             if(lineItemsMap.get(oppLineItem.Opportunity.Id) == null)
             lineItemsMap.put(oppLineItem.OpportunityId, new List<OpportunityLineItem >{oppLineItem});
             else
             lineItemsMap.get(oppLineItem.OpportunityId).add(oppLineItem);
         }
         
        map<id,Id> childOppMapWithParent = new map<id,Id>();                                                      
            for(Opportunity opp:oppMap.values()){
                for(Opportunity child:opp.ChildOpportunities__r){
                    childOppMap.put(child.id,child);
                    childOppMapWithParent.put(child.Id,opp.Id);
                }
                
            }
          LX_OpportunityLineItemHelper.mqliUpdate1(oppMap,childOppMap,lineItems,lineItemsMap,childOppMapWithParent);
       // mqliUpdate1(oppMap,childOppMap,lineItems);
    }


    /*
     * 
     * Description : Methods to upsert MQLI, which is called from the lineitem trigger or child opp creation vf page as a future method
     * Param - : opportunity, lineitems
     * Returns : null
    */
    @future
    public static void mqliUpdate1Future(string masterOppId){
        LX_Opportunity_SoldTo_Case.IsFutureCalled = true;
        map<id,Opportunity>oppMap =  new map<id,Opportunity>([SELECT Id, LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,
                                                              MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,
                                                              (Select LX_Country_Code__c, id, CurrencyIsoCode, Master_Opportunity__c From ChildOpportunities__r) 
                                                              FROM Opportunity 
                                                              WHERE Id = :masterOppId limit 1]);
                                                              
       map<id,OpportunityLineItem> lineItems= new map <id,OpportunityLineItem>([Select id,OpportunityId,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,Part_Number__c,Parent_ID__c,Description,Quantity, PricebookEntry.Product2.id,LX_Extra_Parts_Info__c 
                                                                                from OpportunityLineItem
                                                                                where OpportunityId=:oppMap.keyset()]); 
        map<id,Opportunity> childOppMap = new map<id,Opportunity>();                                                      
        for(Opportunity opp:oppMap.values()){
            for(Opportunity child:opp.ChildOpportunities__r){
                childOppMap.put(child.id,child);
            }
        }
        
      //  mqliUpdate1(oppMap,childOppMap,lineItems);
    }


    /*
     * 
     * Description : Methods to upsert MQLI, which is called from the lineitem trigger or child opp creation vf page as a future method
     * Param - : opportunity, lineitems
     * Returns : null
    */
    @future
    public static void mqliUpdateMultiFuture(set<id> masterOppId){
        LX_Opportunity_SoldTo_Case.IsFutureCalled = true;
        map<id,Opportunity>oppMap =  new map<id,Opportunity>([SELECT Id, LX_Countries_In_Scope_Hidden__c, OwnerID, owner.Legacy_Company__c, Name,
                                                              MPS_Country__c,Hidden_MPS_Country__c,Sales_Organization__r.LX_Country_Code__c,
                                                              (Select LX_Country_Code__c, id, CurrencyIsoCode, Master_Opportunity__c From ChildOpportunities__r) 
                                                              FROM Opportunity 
                                                              WHERE Id = :masterOppId]);
                                                              
       map<id,OpportunityLineItem> lineItems= new map <id,OpportunityLineItem>([Select id,OpportunityId,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,Part_Number__c,Parent_ID__c,Description,Quantity, PricebookEntry.Product2.id,LX_Extra_Parts_Info__c 
                                                                                from OpportunityLineItem
                                                                                where OpportunityId=:oppMap.keyset()]); 
        map<id,Opportunity> childOppMap = new map<id,Opportunity>();                                                      
        for(Opportunity opp:oppMap.values()){
            for(Opportunity child:opp.ChildOpportunities__r){
                childOppMap.put(child.id,child);
            }
        }
        
       // mqliUpdate1(oppMap,childOppMap,lineItems);
    }


    /*
     * 
     * Description : Methods to upsert MQLI, which is called from the lineitem trigger or child opp creation vf page
     * Param - : opportunity, lineitems
     * Returns : null
    */
    public static list<LX_Master_Quote_Line_Item__c> mqliUpdate1(map<id,Opportunity> ParentOpps, map<id,Opportunity> ChildOpps, map<id,OpportunityLineItem> lineItems,Map<Id,List<OpportunityLineItem>> LineItemMap,Map<id,Id> OppParentMap){
        
        //sobject field     
        Schema.sObjectField childLineField = LX_Master_Quote_Line_Item__c.LX_ChildOpp_LineID__c.getdescribe().getSObjectField();
        
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
        if(lineItems != null){
            for(OpportunityLineItem line:lineItems.values()){
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
                system.debug('translateChildPartNumMap##'+trans.LX_Country_Code__c+trans.LX_Part_Number__c);    
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
       //Iterate of the Opportunity LineItems
       
            //Iterate over the child Opportunity
            for(Id oppId : OppParentMap.keyset()){
               Opportunity opp =  ChildOpps.get(oppId);
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
                        system.debug('###opp.LX_Country_Code__c +line.Part_Number__c'+ParentOpps.get(opp.Master_Opportunity__c).Sales_Organization__r.LX_Country_Code__c+line.Part_Number__c);
                        if(ParentOpps.containsKey(opp.Master_Opportunity__c) && ParentOpps.get(opp.Master_Opportunity__c).Sales_Organization__r.LX_Country_Code__c!=null &&
                        translateChildPartNumMap.containsKey(ParentOpps.get(opp.Master_Opportunity__c).Sales_Organization__r.LX_Country_Code__c+line.Part_Number__c)){
                        
                            string childLXID = translateChildPartNumMap.get(ParentOpps.get(opp.Master_Opportunity__c).Sales_Organization__r.LX_Country_Code__c+line.Part_Number__c).LX_ID__c; 
                               system.debug('childLXID-->'+childLXID);
                               system.debug('translateCountryPartNumMap.get(opp.LX_Country_Code__c + childLXID)'+translateCountryPartNumMap.get(opp.LX_Country_Code__c + childLXID));
                               system.debug('translateCountryPartNumMap.get(opp.LX_Country_Code__c + childLXID).LX_Part_Number__c');
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
        try{ 
           database.upsert(returnMasterLineQuotes,childLineField);
         }catch(Exception ex){
            System.debug('Could not perform upsert operation'+ex.getMessage());
            LX_CommonUtilities.createExceptionLog(ex);
          }        
       
       return returnMasterLineQuotes;
    }
    /*
     * 
     * Description : Methods to to delete MQLI corresponding to the deleted opportunity line items
     * Param - : Trigger.New
     * Returns : null
    */
    
public static void MqliDelete(set<string>OppLineOppIdSet){  
    Delete[select id, name ,LX_Opp_Prod_Opp_Id__c
            from LX_Master_Quote_Line_Item__c
            where LX_Opp_Prod_Opp_Id__c in:OppLineOppIdSet];
}

/*
     * 
     * Description : Future method to updat the contract type of opportunity line item based on the value in quote party record
     * Param - : Trigger.New
     * Returns : null
    */
    
//@future(callout=false)
public static void PopulateLX_Contract_Type(set<Id> OppLinSet){
    set<OpportunityLineItem> ProdListToUpdate=new set<OpportunityLineItem>();//list of opp line item to update
    Map<id,id> LineIdOppIdMap=new map<id,id>();//map of line item id, opp id
    Map<Id, Id> oppQuoteMap = new  Map<Id, Id>();//map of opp id and quote rec id
    Map<id,id> RemainingLineIdOppIdMap=new Map<id,id>();//map of remaining line item id, opp id
    //quering all opp line items
    map<id,OpportunityLineItem> OppLinItemMap=new map<id,OpportunityLineItem>([SELECT id,LX_Contract_Type__c,Line__c ,Product_Family__c,OpportunityID  
                                                         from OpportunityLineItem 
                                                         where id IN:OppLinSet ]);
    system.debug('OppLinItemMap-->'+OppLinItemMap);                                                  
    for(Id LineId:OppLinItemMap.keyset()){
        //if product family contains the string metered then contract type is 'SAP CRM Contract'
        system.debug('OppLinItemMap.get(LineId).Product_Family__c'+OppLinItemMap.get(LineId).Product_Family__c);
        system.debug('Label.LX_ProductyFamilyMetered'+Label.LX_ProductyFamilyMetered);
        if(OppLinItemMap.get(LineId)!=null&&OppLinItemMap.get(LineId).Product_Family__c!=null && OppLinItemMap.get(LineId).Product_Family__c.containsIgnoreCase(Label.LX_ProductyFamilyMetered)) {
            OppLinItemMap.get(LineId).LX_Contract_Type__c  =ContractType1;
            //adding the opp line item to the list to be updated
            if(!ProdListToUpdate.contains(OppLinItemMap.get(LineId)))
                ProdListToUpdate.add(OppLinItemMap.get(LineId));
            system.debug('ProdListToUpdate1-->'+ProdListToUpdate);  
        }
        // if Line__c is Solutions_Software or services then contract type is SAP Software Contract';
        else if(OppLinItemMap.get(LineId).Line__c ==label.LX_Line_Solutions_Software ||OppLinItemMap.get(LineId).Line__c ==label.LX_Line_services){
            OppLinItemMap.get(LineId).LX_Contract_Type__c  =ContractType2;
            //adding the opp line item to the list to be updated
            if(!ProdListToUpdate.contains(OppLinItemMap.get(LineId)))
                ProdListToUpdate.add(OppLinItemMap.get(LineId));
            system.debug('ProdListToUpdate2-->'+ProdListToUpdate);
        }
        //if opp line__c is service parts or supplies then add those records to a map
        else if(OppLinItemMap.get(LineId).Line__c ==label.LX_LineService_Parts||OppLinItemMap.get(LineId).Line__c ==label.LX_LineSupplies){
            LineIdOppIdMap.put(LineId,OppLinItemMap.get(LineId).OpportunityID);
            system.debug('LineIdOppIdMap-->'+LineIdOppIdMap);
        }
        //adding all the remaining line items to a map
        else{
        RemainingLineIdOppIdMap.put(LineId,OppLinItemMap.get(LineId).OpportunityID);
        system.debug('RemainingLineIdOppIdMap-->'+RemainingLineIdOppIdMap);
        }
    }
    if(!LineIdOppIdMap.isEmpty()){  
        //to add the primary quote rec id and opp id to a map corresponding to the opplineitem 
        for(BigMachines__Quote__c quoteRec : [Select id ,BigMachines__Opportunity__c,BigMachines__Is_Primary__c
                                              from BigMachines__Quote__c 
                                              where BigMachines__Opportunity__c in: LineIdOppIdMap.values() and BigMachines__Is_Primary__c = true]){
            oppQuoteMap.put(quoteRec.BigMachines__Opportunity__c, quoteRec.Id);
            system.debug('oppQuoteMap-->'+oppQuoteMap);
        }
        //string values to add to the query
        String PartyProductLinestr1 = '%' + label.LX_LineService_Parts + '%';
        String PartyProductLinestr2 = '%' + label.LX_LineSupplies + '%';
        map<Id,LX_Quote_Party__c> QuotePartyMap = new Map<Id,LX_Quote_Party__c>();
        //query for quote party record which contain Service_Parts or Supplies in Party product line field and add the quote id, quote product id to a map
        for(LX_Quote_Party__c qp : [Select id,LX_Timing_of_discount__c ,LX_partyProductLine__c,LX_Quote__c
                             from LX_Quote_Party__c 
                             where LX_Quote__c IN :oppQuotemap.values() 
                             and (LX_partyProductLine__c like :PartyProductLinestr1 OR LX_partyProductLine__c like :PartyProductLinestr2)]){
            
            QuotePartyMap.put(qp.LX_Quote__c,qp);
            system.debug('QuotePartyMap-->'+QuotePartyMap);
        }
        //to update the contract type field of the opp prodd and add them to the update list
        for(id lineId:LineIdOppIdMap.keyset()){
        //if loop to check if the quote map contains any corresponding record to the opp line item record
            if(LineIdOppIdMap.containskey(lineId)&& oppQuoteMap.containskey(LineIdOppIdMap.get(lineId)) && QuotePartyMap.containskey(oppQuoteMap.get(LineIdOppIdMap.get(lineId)))){
                //if loop to see if timing of discount is upfront
                if(QuotePartyMap.containskey(oppQuoteMap.get(LineIdOppIdMap.get(lineId))) && QuotePartyMap.get(oppQuoteMap.get(LineIdOppIdMap.get(lineId))).LX_Timing_of_discount__c ==TimingOfDiscount1){
                    OppLinItemMap.get(LineId).LX_Contract_Type__c  =ContractType3;  
                    //adding the opp line item to the list to be updated
                    if(!ProdListToUpdate.contains(OppLinItemMap.get(LineId)))
                        ProdListToUpdate.add(OppLinItemMap.get(LineId));
                    system.debug('ProdListToUpdate4-->'+ProdListToUpdate);
                }
                //if loop to see if timing of discount is Back-End
                if(QuotePartyMap.containskey(oppQuoteMap.get(LineIdOppIdMap.get(lineId))) && QuotePartyMap.get(oppQuoteMap.get(LineIdOppIdMap.get(lineId))).LX_Timing_of_discount__c ==TimingOfDiscount2){
                    OppLinItemMap.get(LineId).LX_Contract_Type__c  =ContractType4;  
                    //adding the opp line item to the list to be updated
                    if(!ProdListToUpdate.contains(OppLinItemMap.get(LineId)))
                        ProdListToUpdate.add(OppLinItemMap.get(LineId));
                    system.debug('ProdListToUpdate5-->'+ProdListToUpdate);
                }
            }
        
        }
    }
    if(!RemainingLineIdOppIdMap.Isempty()){
    Map<Id, Id> oppQuoteMap1 = new  Map<Id, Id>();//map of opp id and quote rec id
    map<Id,list<LX_Quote_Party__c>> QuotePartyMap1 = new Map<Id,list<LX_Quote_Party__c>>();
    list<LX_Quote_Party__c> tempQPlist;
    //to add the primary quote rec id and opp id to a map corresponding to the opplineitem 
        for(BigMachines__Quote__c quoteRec : [Select id ,BigMachines__Opportunity__c,BigMachines__Is_Primary__c
                                              from BigMachines__Quote__c 
                                              where BigMachines__Opportunity__c in: RemainingLineIdOppIdMap.values() and BigMachines__Is_Primary__c = true]){
            oppQuoteMap1.put(quoteRec.BigMachines__Opportunity__c, quoteRec.Id);
            system.debug('oppQuoteMap1-->'+oppQuoteMap1);
        }
        //for loop to add quote party records to QuotePartyMap1 
    for(LX_Quote_Party__c qp : [Select id,LX_Timing_of_discount__c,LX_partyProductLine__c,LX_Quote__c
                                 from LX_Quote_Party__c 
                                 where LX_Quote__c IN :oppQuotemap1.values()]){
            if(!QuotePartyMap1.containsKey(qp.LX_Quote__c)) {
                tempQPlist=new list<LX_Quote_Party__c>();
                tempQPlist.add(qp);
                QuotePartyMap1.put(qp.LX_Quote__c,tempQPlist);
            }else{
                tempQPlist=new list<LX_Quote_Party__c>();
                tempQPlist.addAll(QuotePartyMap1.get(qp.LX_Quote__c));
                tempQPlist.add(qp);
                QuotePartyMap1.put(qp.LX_Quote__c,tempQPlist);
            }
            system.debug('QuotePartyMap1-->'+QuotePartyMap1);
        }
        for(id lineId:RemainingLineIdOppIdMap.keyset()){
            if(RemainingLineIdOppIdMap.containskey(lineId)&& oppQuoteMap1.containskey(RemainingLineIdOppIdMap.get(lineId)) && QuotePartyMap1.containskey(oppQuoteMap1.get(RemainingLineIdOppIdMap.get(lineId)))){
                if(QuotePartyMap1.containskey(oppQuoteMap1.get(RemainingLineIdOppIdMap.get(lineId)))){
                    for(LX_Quote_Party__c qrec:QuotePartyMap1.get(oppQuoteMap1.get(RemainingLineIdOppIdMap.get(lineId)))){
                        
                        system.debug('OppLinItemMap.get(LineId).line__c'+OppLinItemMap.get(LineId).line__c);
                           system.debug('qrec.LX_partyProductLine__c'+qrec.LX_partyProductLine__c);
                           //system.debug('qrec.LX_Purchasing_Method_from_Lexmark__c'+qrec.LX_Purchasing_Method_from_Lexmark__c);
                        //if loop to see if timing of discount is upfront
                        if(OppLinItemMap.containskey(LineId)&&OppLinItemMap.get(LineId).line__c!=null && qrec.LX_partyProductLine__c != null && qrec.LX_partyProductLine__c.containsIgnoreCase(OppLinItemMap.get(LineId).line__c) && qrec.LX_Timing_of_discount__c==TimingOfDiscount1){
                            OppLinItemMap.get(LineId).LX_Contract_Type__c  =ContractType3;  
                            //adding the opp line item to the list to be updated
                            if(!ProdListToUpdate.contains(OppLinItemMap.get(LineId)))
                                ProdListToUpdate.add(OppLinItemMap.get(LineId));
                            system.debug('ProdListToUpdate5-->'+ProdListToUpdate);
                        }   
                        //if loop to see if timing of discount is Back-End
                         if(OppLinItemMap.get(LineId).line__c!=null && qrec.LX_partyProductLine__c != null && qrec.LX_partyProductLine__c.containsIgnoreCase(OppLinItemMap.get(LineId).line__c) && qrec.LX_Timing_of_discount__c == TimingOfDiscount2){
                            OppLinItemMap.get(LineId).LX_Contract_Type__c  =ContractType5;  
                            //adding the opp line item to the list to be updated
                            if(!ProdListToUpdate.contains(OppLinItemMap.get(LineId)))
                                ProdListToUpdate.add(OppLinItemMap.get(LineId));
                            system.debug('ProdListToUpdate6-->'+ProdListToUpdate);
                        }   
                    }
                }
            }
        }
        
    }
    //update the opp line items
    try{
        //isUpdated=false;
        system.debug('ProdListToUpdate#####'+ProdListToUpdate);
        List<OpportunityLineItem> UpdateProdList = new List<OpportunityLineItem>();
        UpdateProdList.addAll(ProdListToUpdate);
        if(UpdateProdList.size() > 0)
            update UpdateProdList;
     }catch (exception ex){
      LX_CommonUtilities.createExceptionLog(ex);
      }
        
    }
}