/*********************************************************************************

Name : OpportunityLineItemGrouping 

Created By : Bharti Mehta(Appirio Offshore)

Created Date : 21 Dec 2010

Usages : This method searches grouping of product and smsa product in an Opportunity.

         and updates lineItem's grouping field accordingly. 

         This also sets Contract_Indicator__c = 'VSE' if any grouping exists for the Opportunity 



Modified By : MFitzgerald 

Modified Date : 19 JUN 2014

Modified : removed @future and redesigned trigger to accomodate synchronous and added old signature

*********************************************************************************/

public class OpportunityLineItemGrouping{

    static boolean IsPartTypeSolutionPackage;

    public static void UpdateLineItemGroupingInfo(set<id> Oppties){

        system.debug('OpportunityLineItemGrouping: Oppties:' + Oppties);

        list<Opportunity> listofOppties = new list<opportunity>();

        for(opportunity o: [select id, sales_organization__c, Contract_Indicator__c, LX_Opportunity_Division__c from opportunity where id in: Oppties]){

            listofOppties.add(o);

        }

        system.debug('OpportunityLineItemGrouping: listofOppties:' + listofOppties);

        UpdateLineItemGroupingInfo(listofOppties);

    }

    

    public static void UpdateLineItemGroupingInfo(list<Opportunity> triggernew){

            system.debug('OpportunityLineItemGrouping: LXFO:2 ');

            //======================================================================

            // Create Oppty Set and Sales Orgs Set

            //======================================================================

              set<id> OpportunitySet = new set<id>();                                   

              set<string> SalesOrgSet = new set<string>();                                   

              map<id,list<OpportunityLineItem>> OpptyLineItemMap = new map<id,list<OpportunityLineItem>>();

              for(Opportunity o: triggernew){

                  OpportunitySet.add(o.id);

                  SalesOrgSet.add(o.sales_organization__c);

                  OpptyLineItemMap.put(o.id, new List<OpportunityLineItem>());

              }

              

              //Sales Orgs Map

                map<id,sales_organization__c> SalesOrgMap = new map<id,sales_organization__c>();

                for(sales_organization__c s : [select Id, Include_in_VSOE__c from sales_organization__c where id in :SalesOrgSet]){

                    SalesOrgMap.put(s.id, s);

                }

                system.debug('OpportunityLineItemGrouping: SalesOrgMap: ' + SalesOrgMap);

                        

                //Query Line Items directly (subqueries can only pull in 200 rows 

                for(OpportunityLineItem x: [select id, OpportunityId, fair_Market_value__c, PricebookEntry.Product2Id, PricebookEntry.Product2.SMSA_Product__c, PricebookEntry.Product2.Family,PricebookEntry.Product2.Part_Type__c, Quantity, Price_Type__c, LX_Solution_Parent_Value__c, LX_Solution_Sub_Item_Value__c FROM OpportunityLineItem where OpportunityId  in: OpptyLineItemMap.keyset() order by quantity desc]){

                    if(OpptyLineItemMap.containsKey(x.OpportunityId)) {

                        OpptyLineItemMap.get(x.OpportunityId).add(x);

                    }else {

                        OpptyLineItemMap.put(x.OpportunityId, new List<OpportunityLineItem>{x});

                    }

                }

                /*End of fix*/

                system.debug('OpportunityLineItemGrouping: OpptyLineItemMap: ' + OpptyLineItemMap);



                list<Opportunity> Opportunities = new list<Opportunity>();

                //Iterate Through Records

                for(Opportunity o : triggernew){

                    IsPartTypeSolutionPackage=false;               

                    //if findGrouping returns true

                    if(SalesOrgMap.containsKey(o.Sales_organization__c) && SalesOrgMap.get(o.Sales_organization__c).Include_in_VSOE__c == true){

                        if(findGrouping(OpptyLineItemMap.get(o.id))){

                          
                          if(o.LX_Opportunity_Division__c == 'ISS') {
                             o.Contract_Indicator__c = 'LSV';
                          }
                          else {
                             o.Contract_Indicator__c = 'VSE';
                          }

                        } else {

                          
                          if(o.LX_Opportunity_Division__c == 'ISS') {
                             o.Contract_Indicator__c = 'LSN';
                          }
                          else {
                             o.Contract_Indicator__c = 'NVE';
                          }

                        }

                        if(IsPartTypeSolutionPackage){

                        
                        if(o.LX_Opportunity_Division__c == 'ISS') {
                             o.Contract_Indicator__c = 'LSN';
                          }
                          else {
                             o.Contract_Indicator__c = 'SPK';
                          }

                        }

                    } else {  

                        UpdateFairMarketValue(OpptyLineItemMap.get(o.id));

                        
                        if(o.LX_Opportunity_Division__c == 'ISS') {
                             o.Contract_Indicator__c = 'LSN';
                          }
                          else {
                             o.Contract_Indicator__c = 'NVE';
                          }

                    }

                    system.debug('OpportunityLineItemGrouping: o.Contract_Indicator__c: ' + o.Contract_Indicator__c);  

                }      

           //Trigger Context - No DML Needed on Opportunity

    }

    

      

    private static Boolean findGrouping(list<OpportunityLineItem> oli){

        system.debug('OpportunityLineItemGrouping: findGrouping: oli: ' + oli);  



        Map<Id,OpportunityLineItem> mapLineItems = new Map<Id,OpportunityLineItem>();        

        Map<Id,set<OpportunityLineItem>> mapLineItemWithSMSAProduct = new Map<Id,set<OpportunityLineItem>>();

        Map<Id,set<OpportunityLineItem>> mapLineItemWithProduct = new Map<Id,set<OpportunityLineItem>>();

        Set<OpportunityLineItem> grp = new Set<OpportunityLineItem>();

        Set<OpportunityLineItem> hgrp = new Set<OpportunityLineItem>();

        Integer groupCount = 0;

        Integer groupCountsmsa = 0;

        Integer groupCountPartTypeSolPackage = 0;

        

        //prepare map for lineItems with product and with smsa products

        for(OpportunityLineItem lineItem : oli){

        system.debug('Lexmark Test : ' + Label.LX_Solution_Grouping_Name + ' : ' + lineItem.PricebookEntry.Product2.Family);

           //NEED TO CHANGE THIS LINE TO SUPPORT MULTIPLE LINEITEMS FOR THE SAME PRODUCT

           if(lineItem.PricebookEntry.Product2.Part_Type__c== Label.LX_Solution_Grouping_Name && IsPartTypeSolutionPackage == false)

           {

           IsPartTypeSolutionPackage = true;

           }

           if(mapLineItemWithProduct.containskey(lineItem.PricebookEntry.Product2Id)){                      

              mapLineItemWithProduct.get(lineItem.PricebookEntry.Product2Id).add(lineItem);

           } else {

            set<OpportunityLineItem> temp = new Set<OpportunityLineItem>();

            temp.add(lineItem);

            mapLineItemWithProduct.put(lineItem.PricebookEntry.Product2Id,temp);

           }

            

           if(lineItem.PricebookEntry.Product2.SMSA_Product__c != null){            

              if(mapLineItemWithSMSAProduct.containskey(lineItem.PricebookEntry.Product2.SMSA_Product__c)){                      

                mapLineItemWithSMSAProduct.get(lineItem.PricebookEntry.Product2.SMSA_Product__c).add(lineItem);

              } else {

                set<OpportunityLineItem> temp = new Set<OpportunityLineItem>();

                temp.add(lineItem);

                mapLineItemWithSMSAProduct.put(lineItem.PricebookEntry.Product2.SMSA_Product__c,temp);

              }

           }

        }

        

        if(IsPartTypeSolutionPackage)

           {

                Map<id,OpportunityLineItem> mpGroupingorder = new Map<id,OpportunityLineItem>();

                

                Map<string,set<OpportunityLineItem>> mapmatchingchilditems = new Map<string,set<OpportunityLineItem>>();                

                set<OpportunityLineItem> Tempset = new set<OpportunityLineItem>();

                string strchildvalue = '';

                

                 system.debug('Lexmark Test: Begin Loop and count' + oli.size());

                for(OpportunityLineItem i : oli){

                    system.debug('Lexmark Test: Inside Loop');

                    if(mapmatchingchilditems.containskey(i.LX_Solution_Sub_Item_Value__c)){

                        TempSet = mapmatchingchilditems.get(i.LX_Solution_Sub_Item_Value__c);

                        TempSet.add(i);

                    }

                    else{

                    system.debug('Lexmark Test: Inside Loop Else condition');

                        TempSet = new set<OpportunityLineItem>();

                        TempSet.add(i);

                    }       

                     mapmatchingchilditems.put(i.LX_Solution_Sub_Item_Value__c,TempSet);          

                }

               

                

                system.debug('Lexmark Test: Count :' + mapmatchingchilditems.size());

                integer tempint =0;

                for(OpportunityLineItem i : oli){

                        //Check for not null and not empty of parent value.

                         If(i.LX_Solution_Parent_Value__c != null && i.LX_Solution_Parent_Value__c!='')  {

                        

                           //increment the counter

                            groupCountPartTypeSolPackage++;

                            system.debug('Lexmark Parent value : ' + i.LX_Solution_Parent_Value__c + ' : ' +groupCountPartTypeSolPackage);

                            //Add it to the Final Map with Solution grouping field "H + Counter"

                            mpGroupingorder.Put(i.id,(new OpportunityLineItem(Id = i.id,LX_Solution_Grouping__c = Label.LX_Solution_Grouping_Prefix + groupCountPartTypeSolPackage)));

                           
                             if(i.LX_Solution_Parent_Value__c!=null&&mapmatchingchilditems.containskey(i.LX_Solution_Parent_Value__c))
                            for(opportunitylineitem opplineitem : mapmatchingchilditems.get(i.LX_Solution_Parent_Value__c))

                            {

                            system.debug('Lexmark Test : Parent ID'+i.id + ' Child ID: '+ opplineitem.id);

                            if(i.id != opplineitem.id){

                            system.debug('Lexmark Main :' + groupCountPartTypeSolPackage);

                             mpGroupingorder.Put(opplineitem.id,(new OpportunityLineItem(Id = opplineitem.id,LX_Solution_Grouping__c = String.valueOf(groupCountPartTypeSolPackage))));

                             }

                            }

                        }

                    }  

                

              grp.addall(mpGroupingorder.values());

              list<OpportunityLineItem> upd = new List<OpportunityLineItem>();

              upd.addall(grp);

              update upd;

              grp.clear();

            }

        



        map<ID,OpportunityLineItem> usethismap = new map<ID,OpportunityLineItem>();

        

        //If smsa product exists in Opportunity lineitems's product list

        //then grouping found set Grouping__c field for product and smsa products in related lineitem

        //else do nothing 

        for(Id smsaProductId : mapLineItemWithSMSAProduct.keySet()){

            if(mapLineItemWithProduct.containsKey(smsaProductId)){

                for(OpportunityLineItem i : mapLineItemWithProduct.get(smsaProductId)){

                    groupCount++;

                    groupCountsmsa++;

                    usethismap.Put(i.id,(new OpportunityLineItem(Id = i.id,Grouping__c = '' + groupCount)));

                    for(OpportunityLineItem j : mapLineItemWithSMSAProduct.get(smsaProductId)){

                        if(j.quantity == i.quantity && j.Price_Type__c == i.Price_Type__c){

                            if(!usethismap.containskey(j.id)){

                                usethismap.Put(j.id,(new OpportunityLineItem(Id = j.id,Grouping__c = 'H' + groupCountsmsa)));

                                break;

                            }

                        }

                    }

                }

            }

        }



        //if mapLineItems.size() > 0 it means grouping found so return true 

        if(!usethismap.isEmpty()){

            grp.addall(usethismap.values());

            list<OpportunityLineItem> upd = new List<OpportunityLineItem>();

              upd.addall(grp);

              system.debug('OpportunityLineItemGrouping: findGrouping: upd: ' + upd);  

            update upd;



            return true;

        }

        

        return false;

    } 

    

    private static void UpdateFairMarketValue(list<OpportunityLineItem> oli){

        system.debug('OpportunityLineItemGrouping: UpdateFairMarketValue: oli: ' + oli);  

        //get all Opportunity line items and add fair market value

        List<OpportunityLineItem> OppLineItemList = oli;

        if(OppLineItemList.size() > 0){

            for(OpportunityLineItem OppLineItem : OppLineItemList){

                OppLineItem.Fair_Market_Value__c = 0;   

            }

            update OppLineItemList;                                                                     

        }                        

    }    

}