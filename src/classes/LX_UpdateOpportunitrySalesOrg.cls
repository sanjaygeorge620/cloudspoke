public without sharing class LX_UpdateOpportunitrySalesOrg {
        
        //collect the user Ids who are the owner in the opp
        static list<id> userIds                 = new list<id>();
        //collect the Account Ids who are the owner in the opp
        static list<id> AccountIds              = new list<id>();
        //map for the user Ids and their legacy company id
        static map<id,User>userMap              = new map<id,User>();
        //map for the Account Ids and their country code
        static map<id,Account>AccountMap        = new map<id,Account>();
        //List for the opportunity to be updated.
        static list<Opportunity> oppToUpdate    = new list<Opportunity>();

        //list of the custom setting for the sales org defaulting.
        static map<string,LX_Opportunity_Sales_Org__c> oppSalesOrg = LX_Opportunity_Sales_Org__c.getAll();
        
        //mapp for sales org
        static map<id,Sales_Organization__c>  salesOrgMap = new map<id,Sales_Organization__c>([SELECT id,Sales_Organization__c                                                                                      ,Name,LX_Country_Code__c
                                                                                                FROM Sales_Organization__c
                                                                                                where Lx_Default__c =: true or 
                                                                                                LX_Country_Code__c = 'US']);
        
        //map for string and sales org.
        static map<string,Sales_Organization__c> salesOrgIdMap = new map<string,Sales_Organization__c>();
         private static final string CountryUS                      ='US';
         private static final string LegacayComp                      ='Lexmark';

        public static void updateOpportunity(list<Opportunity> updateOpp){



            
            for (Opportunity opp:updateOpp){
                //Populate all the owner Ids
                userIds.add(opp.ownerId);
                //Populate all the account Ids
                AccountIds.add(opp.AccountID);
            }
            
            //update the map
            for(Sales_Organization__c sales :salesOrgMap.values()){
                salesOrgIdMap.put(sales.Sales_Organization__c + sales.LX_Country_Code__c,sales);
            }
            system.debug('$$$$$$'+salesOrgIdMap);
            
            //Populate the user Map
            userMap     = new map<id,User>([Select id,legacy_company__c from User where id =:userIds]);
            //Populate the Account Map
            AccountMap  = new map<id,Account>([select id,name,LX_Country_Code__c from Account where id= :AccountIds]);
            
            
            //Loop through the Opportunity to update the sales org.
            for (Opportunity opp:updateOpp){
                //variables to hold the Account's countrycode and the Owener's legacy CompanyCode.
                string countryCode,legacyCompanyCode ;
                
                //Populate the country code only if Account is present.
                if(AccountMap.get(opp.AccountID)!= null){
                    countryCode         = AccountMap.get(opp.AccountID).LX_Country_Code__c;
                }

                //Populate the legacy company code only if owner is present.
                if(userMap.get(opp.ownerId) != null){
                    legacyCompanyCode   = userMap.get(opp.ownerId).legacy_company__c;
                }else{
                    legacyCompanyCode   = null;
                }
                system.debug('>>>>>>'+countryCode+'>>>>>>>'+legacyCompanyCode);
                //If either the account or ownerid is missing dont update the Opportunity
                if((AccountMap.get(opp.AccountID)!= null) ){
                    
                    //iterate through the Custom Seeting to get the correct value.
                     for(LX_Opportunity_Sales_Org__c SalesRec :oppSalesOrg.values()){
                            system.debug('########'+SalesRec.LX_CountryCode__c +'########'+SalesRec.LX_Legacy_Company__c);
                            //if we are to match the values then update the oppToUpdate list
                             if(legacyCompanyCode==LegacayComp && countryCode==CountryUS){
                                 if((countryCode == SalesRec.LX_CountryCode__c )&&(legacyCompanyCode ==SalesRec.LX_Legacy_Company__c)){ 
                                    system.debug('>>>>>>'+'inside loop');
                                    system.debug('>>>>>>SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c'+SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c);
                                    string salesID;
                                    if(salesOrgIdMap.get(SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c)!= null){
                                        system.debug('>>>>>>SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c'+SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c); 
                                        oppToUpdate.add(new Opportunity(id = opp.id, Sales_Organization__c = salesOrgIdMap.get(SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c).id));
                                        break;
                                    }
                                }
                            }else{
                            if(countryCode == SalesRec.LX_CountryCode__c ){ 
                                    system.debug('>>>>>>'+'inside loop');
                                    system.debug('>>>>>>SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c'+SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c);
                                    string salesID;
                                    if(salesOrgIdMap.get(SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c)!= null){
                                        system.debug('>>>>>>SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c'+SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c); 
                                        oppToUpdate.add(new Opportunity(id = opp.id, Sales_Organization__c = salesOrgIdMap.get(SalesRec.LX_DefaultSalesOrg__c+SalesRec.LX_CountryCode__c).id));
                                        break;
                                    }
                                }
                            
                            }   
                    }
                }
            }
            
            
            //Update the opportunity only if the list has more than 0 values.
            if(oppToUpdate.size() > 0){
                try{
                    update oppToUpdate;
                }catch(exception ex){
                    LX_CommonUtilities.createExceptionLog(ex);
                }
            }
    }
  
}