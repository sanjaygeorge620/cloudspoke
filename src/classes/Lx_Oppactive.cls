/*
Class Name : Lx_Oppactive
Description : This class is used to create SMSA opportunity from the inputs from LX_SerialNumberOrder class
Created By : Bhanu Prakash
Created Date : 12-07-20114
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Bhanu Prakash     12-07-20114        1000                   Initial Version
*************************************************************************/

public class Lx_Oppactive{

public enum ActivateEnum {NoSerialItems, Exceptions, Success}
public static Lx_Oppactive.ActivateEnum  Utility(List<Serial_Number__c> ListActivateS,LX_Serial_Number_Sales_Order__c lxObj){ 
      
        string strOppName = (lxObj.LX_Customer_Account__r.Name + '-' + lxObj.Name);
        if(strOppName.length() >28){
         strOppName = strOppName.substring(0,27);
        }
 
        
        Opportunity Opp = new Opportunity( RecordTypeId = [SELECT Id 
                                             FROM RecordType 
                                             WHERE SobjectType = 'Opportunity' 
                                                 AND DeveloperName = 'Expansion_Add_On'
                                             Limit 1].Id,
                                             Name =   strOppName, //included to add the substring if the Name exceeds 28 characters 
                                             AccountId = lxObj.LX_Customer_Account__c ,                                                                                 
                                             CloseDate = System.Today(), 
                                             OwnerId = lxObj.LX_Customer_Account__r.OwnerId,
                                             Software_Solutions__c = LX_OpportunityHelper.OppcactiveT,
                                             LX_Sales_Type__c = LX_OpportunityHelper.Sales_Type_c, 
                                             LX_Purchasing_Method__c = LX_OpportunityHelper.Purchasing_Method_c,
                                             Type = LX_OpportunityHelper.Typeopp,
                                             LX_Change_Request__c = LX_OpportunityHelper.Change_Request_c,
                                             Sector__c = lxObj.LX_Customer_Account__r.LX_Sales_Team_Assigned__c, 
                                            Amount = 0,
                                            StageName = LX_OpportunityHelper.StageNameopp, 
                                            ForecastCategoryName = LX_OpportunityHelper.ForecastCategoryNameopp, 
                                            Contract_Indicator__c = LX_OpportunityHelper.Contract_Indicator_copp,
                                            LX_Opportunity_Division__c = LX_OpportunityHelper.Opportunity_Division_c, 
                                            Next_Steps__c = LX_OpportunityHelper.Next_Steps,  
                                            Quote_Status__c = LX_OpportunityHelper.Quote_Status,
                                            Legacy_Company_Originator__c = LX_OpportunityHelper.Legacy_Company_Originator, 
                                            QALevel2Approved__c = LX_OpportunityHelper.OppcactiveT,  
                                            LX_Ready_for_Finalization__c = LX_OpportunityHelper.OppcactiveT,
                              //              LX_CheckOpp_craeted__c = LX_OpportunityHelper.OppcactiveT,
                                            Contract_End_Date__c = System.Today() + 364,
                                            Begin_Date__c = System.Today(),
                                            End_Date__c = System.Today() + 364  ,
                                            CurrencyIsocode = lxObj.CurrencyIsocode,
                                            Serial_Number_Sales_Order__c = lxObj.Id );
                                             
            List<OpportunityLineItem> OppList = new List<OpportunityLineItem>();   
            Map<id,id> MapProductPricebook = new  Map<id,id>();
            Set<id> SetProduct2 = new Set<id>();
            OpportunityLineItem oppline = null;
              for(Serial_Number__c ser : ListActivateS){
               SetProduct2.add(ser.Part_Name__r.SMSA_Product__c);
             }                    
             try{
             if(ListActivateS!=null&&ListActivateS.size()>0) {
             insert Opp;
             }
             else{            
              return Lx_Oppactive.ActivateEnum.NoSerialItems;
             }
            }catch(Exception ex){
            system.debug(ex.getmessage());
            LX_CommonUtilities.createExceptionLog(ex);
            return Lx_Oppactive.ActivateEnum.Exceptions;          
                     }
             Opportunity opp2 = [select CurrencyIsoCode, pricebook2id from Opportunity where id=:opp.id limit 1 ];        
             List<PricebookEntry> pbeList = [Select id ,Product2Id,pricebook2id, currencyisocode,isActive from PRiceBookEntry where Product2Id in:SetProduct2 AND CurrencyIsoCode=:opp2.CurrencyIsoCode and pricebook2id in(select id from pricebook2 where isstandard=true) ];
                         for(PricebookEntry pb: pbeList){
                MapProductPricebook.put(pb.Product2Id ,pb.id);
            }          
            for(Serial_Number__c ser : ListActivateS){
                oppline = new OpportunityLineItem(OpportunityId = Opp.Id);
                oppline.Part_Name__c = ser.Part_Name__r.SMSA_Product__r.name;
                oppline.Quantity = 1;
                oppline.Part_Number__c = ser.Part_Name__r.SMSA_Product__r.Part_Number__c; 
                oppline.Price_Type__c = 'EA';
                oppline.Fair_Market_Value__c = 0;
                oppline.Base_Price__c = 0;
                oppline.UnitPrice = 0;
                oppline.pricebookentryid=MapProductPricebook.get(ser.Part_Name__r.SMSA_Product__c);
                oppline.Sales_Price_SAP__c = 0;
              OppList.add(oppline);               
            }             
             try {
                   insert OppList;
                  } 
                  catch(DmlException ex){
            system.debug(ex.getmessage());
            LX_CommonUtilities.createExceptionLog(ex);
                return Lx_Oppactive.ActivateEnum.Exceptions;                                
               }    
       return Lx_Oppactive.ActivateEnum.Success;       
     }
}