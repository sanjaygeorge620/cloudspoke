/**
 * ©Lexmark Front Office 2013, all rights reserved
 * 
 * Created Date : 05-08-2013
 *
 * Author : Kapil Reddy Sama  
 * 
 * Description : If user enters Lost To competitor on Opportunity, automatically check the Winner checkbox for that competitor on the Competitor Information record.

**/

trigger LX_Opportunity_AI_AU on Opportunity(after insert,after update ) {
 
	//Rahul set of string to store the information related type of opportunity using which we would be creating a Sold ToLX_OppSoldToTypes
	static set < string > SoldToCaseOpportunityTypes = new set < string > (Label.LX_OppSoldToTypes.split(','));

	system.debug('>>>>>>>>>>>>>AI_AU>>' + trigger.new);
	system.debug('>>>>>>>>>>>>>AI_AU>>' + trigger.old);

	if (trigger.isUpdate) {
      
		for (Opportunity opp: trigger.new) {
			Opportunity oldOpp = trigger.oldMap.get(opp.id);
			if ((opp.Begin_Date__c != oldOpp.Begin_Date__c) || (opp.End_Date__c != oldOpp.End_Date__c) || (opp.Contract_End_Date__c != oldOpp.Contract_End_Date__c) || (opp.LX_Opportunity_Finalized__c) || oldOpp.QAStatus__c != 'Complete' || opp.QALevel2Approved__c == true) {
				LX_OpportunityHelper.LX_Opportunity_AI_AU = false;
			}
		}

                 // Pricebook selected change - nirmal - 7/30/2014  starts
  /*          
          List<Opportunity> oppListToUpdate = new List<Opportunity>(); // Pricebook selected change -  7/30/2014  added

       		List < Opportunity > oppList = [SELECT Id, LX_Pricebook_Offer__c, LX_Pricebook_Selected__c FROM Opportunity WHERE Id IN: Trigger.newMap.keySet()];

		for (Opportunity opp: oppList)
        {
        if(null!=opp.LX_Pricebook_Offer__c || ''!= opp.LX_Pricebook_Offer__c)
            {
				String offerEnrollmentId = opp.LX_Pricebook_Offer__c;
                System.debug('****************offerEnrollmentId*************'+offerEnrollmentId );
                LX_Offer_Enrollment__c offerEnrollment = [SELECT Id,Name,Offer__c FROM LX_Offer_Enrollment__c where id = :offerEnrollmentId ];
                if(null!=offerEnrollment)
                {
                String offerId = offerEnrollment.Offer__c;
                System.debug('****************offerId*************'+offerId );
                LX_Offer__c offer = [SELECT Id,Name FROM LX_Offer__c where id = :offerId ];
                opp.LX_Pricebook_Selected__c = offer.Name;
                System.debug('****************oldOpp.LX_Pricebook_Selected__c*************'+opp.LX_Pricebook_Selected__c );
                  oppListToUpdate.add(opp);
                }
            } 
        }
        update oppListToUpdate;  // Pricebook selected change -  7/30/2014  ends
*/
        
        
		//Added for US3663 by Praveen       
		Set < ID > oppSet = new Set < ID > ();

		for (Opportunity oppy: Trigger.new) {
			if (oppy.Stagename == 'Closed Won' && oppy.Quote_Status__c == 'Finalized' && !String.isBlank(oppy.Contract_Number__c) && String.isBlank(Trigger.oldmap.get(oppy.id).Contract_Number__c) && (oppy.Contract_Number__c != Trigger.oldmap.get(oppy.id).Contract_Number__c)) {
				oppSet.add(oppy.id);
			}
		}
		if (!oppSet.isEmpty()) {
			LX_OpportunityHelper.updateAccountFLags(oppSet);
			system.debug('------------updateAccountFLags Future Methods Called------------------');
		}
	}
	system.debug('>>>LX_OpportunityHelper.LX_Opportunity_AI_AU>>>>' + LX_OpportunityHelper.LX_Opportunity_AI_AU);

	if (!LX_OpportunityHelper.LX_Opportunity_AI_AU) {

		//Added ByPass Logic on 07/25/2013
		if (LX_CommonUtilities.ByPassBusinessRule()) return; //  Added Bypass code        

		system.debug('>>>LX_OpportunityHelper.LX_Opportunity_AI_AU>>>>' + LX_OpportunityHelper.LX_Opportunity_AI_AU);

		if (LX_OpportunityHelper.LX_Opportunity_AI_AU) {
			LX_OpportunityHelper.LX_Opportunity_AI_AU = false;
			return;
		}


		//Set the variable as true to prevent recursion;
		LX_OpportunityHelper.LX_Opportunity_AI_AU = true;


		//Variable to store the Commpetitore influence and Partner variable.
		List < LX_Competitor_Influencer_and_Partner__c > listCIP = new List < LX_Competitor_Influencer_and_Partner__c > ();


		map < Opportunity, Account > OppACCMap = new map < Opportunity, Account > ();
		//vt 1/14
		set < ID > soldtoPayZCWO = new set < ID > ();
		list < opportunity > oppSoldtoList = new list < opportunity > ();
		//  set<opportunity> MqLiParentOppset= new set<opportunity>();//vt 1/17 adding for mqli update
		//*******
		set < id > AccSet = new set < id > ();
		set < id > OppVerSet = new set < id > ();

		//Rahul Added set for merging of updateOpportunityLineItemsDate 
		set < id > opportunityProdID = new set < id > ();

		//Variable to store the Opportunity SoldTo and Sales Org Combination
		map < string, LX_SAP_Record_Sales_Org__c > oppSoldtoSalesorg = new map < string, LX_SAP_Record_Sales_Org__c > ();
		set < id > soldIds = new set < id > ();

		//Rahul check if there is a need to query on the Opportunity Competitor is required.
		Boolean competitorUpdateRequired = false;
		map < id, account > AccVerMap = new map < id, account > ();


		//Rahul Added a new set of IDs to update the opportunity Invoice logo for converted leads.
		set < id > oppIdToBeUpdated = new set < id > ();
		set < id > closedOppIds = new set < Id > ();

		if (LX_OpportunityHelper.UpdateOpportunity_AI_AU == false) {
			//added by Veenu 6/11
			if (trigger.isAfter) {
				string QuoteStatuSApp = 'Approved';
				//Check if a query required or not.
				competitorUpdateRequired = false;
				for (Opportunity opp: Trigger.New) {
					//***********VT 1/14 added logic for bill to/ship to from bi bu trigger
					if (trigger.isUpdate && opp.LX_Sold_To_New__c != null && opp.LX_Sold_To_New__c != trigger.oldmap.get(opp.id).LX_Sold_To_New__c && opp.LX_Sold_To_Payment_Terms__c == 'ZCWO') {
						soldtoPayZCWO.add(opp.LX_Sold_To_New__c);
						oppSoldtoList.add(opp);

						system.debug('oppSoldtoList--->' + oppSoldtoList);
					}
					//************   
					//Vt 1/17 adding for mqli update
					/*  if(trigger.isInsert && opp.Quote_Status__c==QuoteStatuSApp && opp.LX_Master_Opportunity__c==true &&(opp.Master_Opportunity__c==''||opp.Master_Opportunity__c==null)){
                        MqLiParentOppSet.add(opp);
                    }
                    
                      if(trigger.IsUpdate && opp.Quote_Status__c!=trigger.oldMap.get(opp.id).Quote_Status__c && opp.Quote_Status__c==QuoteStatuSApp && opp.LX_Master_Opportunity__c==true &&(opp.Master_Opportunity__c==''||opp.Master_Opportunity__c==null)){
                        MqLiParentOppSet.add(opp);
                    }   */

					//Check if the Opportunity is closed won and there is a primary competitor
					if ((trigger.isInsert && opp.Primary_Partner__c != null && opp.StageName == 'Closed Won') || ((trigger.isUpdate && opp.Primary_Partner__c != null && opp.StageName == 'Closed Won' && ((opp.StageName != trigger.oldMap.get(opp.id).StageName) || (opp.Primary_Partner__c != trigger.oldMap.get(opp.id).Primary_Partner__c))))) {
						LX_Competitor_Influencer_and_Partner__c oCIP = new LX_Competitor_Influencer_and_Partner__c(LX_Influencer_Account__c = opp.Primary_Partner__c,
						LX_Customer_Account__c = opp.AccountId, LX_Type__c = 'Partner', RecordTypeID = LX_SetRecordIDs.CompetitorPartnerInfluencerPartnerId);
						listCIP.add(oCIP);
					}

					if (((trigger.isUpdate) && (opp.LX_Competitor_Lost_To__c != Trigger.OldMap.get(opp.id).LX_Competitor_Lost_To__c)) || (
					(trigger.isInsert) && (opp.LX_Competitor_Lost_To__c != null))) {
						competitorUpdateRequired = true;
					}

					if ((trigger.isInsert) && (trigger.isAfter) && ((opp.LX_Converted_Lead_ID_Hidden__c != null) || (opp.Invoice_Logo__c == null) || (opp.LX_Territory_Member__c == null))) {
						//  System.debug('>>>>>>>>Initials>>>>>>>>>>>>>>>'+LX_OppAIAUClass.OppIdsUpdated.size());

						oppIdToBeUpdated.add(opp.id);

					}


					//Check if the Opportunity LineItems have been changed or not  
					set < id > OppEndDates = new set < id > ();
					if ((trigger.isupdate && ((trigger.oldMap.get(opp.id).End_Date__c != opp.End_Date__c) || (trigger.oldMap.get(opp.id).Begin_Date__c != opp.Begin_Date__c) || trigger.oldMap.get(opp.id).Contract_End_Date__c != Opp.Contract_End_Date__c))) {
						OppEndDates.add(opp.id);
					}

					if (OppEndDates.size() > 0) {
						LX_OpportunityHelper.updateOppLineItemsDates(OppEndDates);
					}



					if (trigger.isUpdate && (opp.StageName == 'Closed Won' && opp.StageName != trigger.oldMap.get(opp.id).StageName)) {
						closedOppIds.add(opp.Id);
					}
				}
				//***********VT 1/14 added logic for bill to/ship to from bi bu trigger
				if (soldtoPayZCWO.size() > 0) {
					LX_Opportunity_SoldTo_Case helperCase = new LX_Opportunity_SoldTo_Case();
					system.debug('calling helper');
					helperCase.CreateOpportunitiesSoldToCaseRequesttoCEBU(oppSoldtoList);
				}
				//********  
				if (closedOppIds.size() > 0) {
					List < pse__Proj__c > prjLst = new List < pse__Proj__c > ();
					for (pse__Proj__c prj: [Select ID, Email_Sent_on_Opp_Closing__c, pse__Opportunity__c from pse__Proj__c where pse__Opportunity__c in : closedOppIds and Record_Type_Names__c = 'Pre-Sales'
					and Email_Sent_on_Opp_Closing__c != True]) {
						prj.Email_Sent_on_Opp_Closing__c = True;
						prjLst.add(prj);
					}
					if (prjlst.size() > 0) {
						update prjlst;
					}

				}

				//List of Opportunity Competitors to update.
				List < LX_Opportunity_Competitor__c > oppCompetitorsToUpsert = new List < LX_Opportunity_Competitor__c > ();
				//Map of Opportunity and competitors
				Map < id, LX_Opportunity_Competitor__c > competitorOppMap = new Map < id, LX_Opportunity_Competitor__c > ();

				map < id, id > OppSoldToMap = new map < id, id > ();
				list < LX_SAP_Record_Sales_Org__c > SAPRecList = new list < LX_SAP_Record_Sales_Org__c > ();
				list < opportunity > OppBillToList = new list < opportunity > ();
				list < opportunity > OppToUpdateList = new list < opportunity > ();
				map < id, LX_SAP_Record_Sales_Org__c > SAPRecMap = new map < id, LX_SAP_Record_Sales_Org__c > ();
				//Execute after insert or after update 
				if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
					if (competitorUpdateRequired) {
						for (LX_Opportunity_Competitor__c Competitor: [Select id, LX_Winner__c, LX_Opportunity__c, LX_Opportunity__r.LX_Competitor_Lost_To__c, LX_Competitor_Account__c
						from LX_Opportunity_Competitor__c
						where LX_Opportunity__c in : Trigger.newMap.keySet()]) { //Create a map of Opportunity and competitor

							if ((trigger.newMap.containsKey(Competitor.LX_Opportunity__c)) && (trigger.newMap.get(Competitor.LX_Opportunity__c).LX_Competitor_Lost_To__c == competitor.LX_Competitor_Account__c)) { //Check for the competitor record
								competitorOppMap.put(Competitor.LX_Opportunity__c, Competitor);
							}

						}
					}

					for (Opportunity opp: Trigger.New) {

						if (trigger.isAfter && trigger.isUpdate && opp.LX_Opportunity_Finalized__c && opp.Amount != null) {
							system.debug('calling approval process' + opp.id);
							LX_SubmitRecordToApproval.approvalID(opp.id);

						}


						if ((trigger.isUpdate) && (trigger.oldMap.get(opp.id).LX_Competitor_Lost_To__c != opp.LX_Competitor_Lost_To__c) || (trigger.isInsert)) {
							if (opp.LX_Competitor_Lost_To__c != null) {
								if (competitorOppMap.get(opp.id) != null) { //If competitor is already existing mark it as winner.  
									oppCompetitorsToUpsert.add(new LX_Opportunity_Competitor__c(id = competitorOppMap.get(opp.id).id, LX_Winner__c = true));
								} else { //If the competitor is not present ,create it.                      
									oppCompetitorsToUpsert.add(new LX_Opportunity_Competitor__c( //RecordTypeId=defaultOppoCompRecordTypeID,
									LX_Winner__c = true,
									LX_Opportunity__c = opp.id,
									LX_Competitor_Account__c = opp.LX_Competitor_Lost_To__c));
								}
							}
						}
						if (trigger.isUpdate) {
							///bmi update added 12/11

							Map < Id, Opportunity > oppMasterMap = new Map < Id, Opportunity > ();
							For(Opportunity ObjOpportunity: Trigger.New) {
								system.debug('####for loop');
								if (ObjOpportunity.Master_Opportunity__c == null) {
									if (ObjOpportunity.LX_Agreement_Type__c != trigger.oldmap.get(ObjOpportunity.id).LX_Agreement_Type__c || ObjOpportunity.LX_Primary_Quote_Number__c != trigger.oldmap.get(ObjOpportunity.id).LX_Primary_Quote_Number__c || ObjOpportunity.LX_Quote_Name__c != trigger.oldmap.get(ObjOpportunity.id).LX_Quote_Name__c || ObjOpportunity.LX_Quote_Control_Number__c != trigger.oldmap.get(ObjOpportunity.id).LX_Quote_Control_Number__c) {
										// if(ObjOpportunity.LX_Agreement_Type__c!=trigger.oldmap.get(ObjOpportunity.id).LX_Agreement_Type__c|| ObjOpportunity.LX_Primary_Quote_Number__c!=trigger.oldmap.get(ObjOpportunity.id).LX_Primary_Quote_Number__c|| ObjOpportunity.LX_Quote_Name__c!=trigger.oldmap.get(ObjOpportunity.id).LX_Quote_Name__c|| ObjOpportunity.LX_Quote_Control_Number__c!=trigger.oldmap.get(ObjOpportunity.id).LX_Quote_Control_Number__c || (trigger.oldmap.get(ObjOpportunity.id).Quote_Status__c!='Approved' && ObjOpportunity.Quote_Status__c=='Approved')|| ObjOpportunity.LX_Quote_Start_Date__c!=trigger.oldmap.get(ObjOpportunity.id).LX_Quote_Start_Date__c|| ObjOpportunity.LX_Quote_End_Date__c!=trigger.oldmap.get(ObjOpportunity.id).LX_Quote_End_Date__c){
										oppMasterMap.put(ObjOpportunity.id, ObjOpportunity);
									}
								}
							}
							system.debug('####oppMasterMap' + oppMasterMap);
							// LX_OpportunityHelper.BmiUpdate(oppMasterMap);
							LX_OpportunityHelper.BmiUpdate(oppMasterMap, trigger.Oldmap);
						}
					}
					if (OppToUpdateList.size() > 0) {
						try {
							LX_OpportunityHelper.UpdateOpportunity_AI_AU = true; //added by Veenu 6/11
							update OppToUpdateList;

						} catch (exception ex) {
							LX_CommonUtilities.createExceptionLog(ex); //Exception log ,Kapil Reddy Sama 6/6/13       
						}
					}
				}
				if (oppCompetitorsToUpsert.size() > 0) { //Upsert the related competitors
					try {
						upsert oppCompetitorsToUpsert;
					} catch (exception ex) {
						LX_CommonUtilities.createExceptionLog(ex); //Exception log ,Kapil Reddy Sama 6/6/13      
					}
				}

				if (listCIP.size() > 0) { //insert the partner and influencer record
					try {
						insert listCIP;
					} catch (exception ex) {
						LX_CommonUtilities.createExceptionLog(ex); //Exception log ,Kapil Reddy Sama 6/6/13      
					}
				}

				// Code for Create Sap Project Request Records: START
				LX_OpportunityHelper.CreateSAPProjectRequest(trigger.new, trigger.oldMap);
				// Code for Create Sap Project Request Records: END
			}

			//Rahul Commented out the part as this is being handled as a formula field as against trigger. Refer US 2988 for details.       

			if ((oppIdToBeUpdated.size() > 0) || (opportunityProdID.size() > 0)) {
				System.debug('>>>>>>>Boolean>>>>>>>>' + LX_Opportunity_SoldTo_Case.IsFutureCalled);
				if (LX_Opportunity_SoldTo_Case.IsFutureCalled == false) {
					LX_Opportunity_SoldTo_Case.IsFutureCalled = true;
					LX_OpportunityHelper.updateInvoiceLogo(oppIdToBeUpdated, opportunityProdID);
				}
			}
			/*   if(MqLiParentOppSet.size()>0){
                system.debug('calling mqli');
                //query the parent opportunites to pass them to the mqli update method
                map<id,Opportunity> ParentOpps=new map<id,Opportunity>([select id, name,Sales_Organization__r.LX_Country_Code__c
                                                from Opportunity
                                                Where id IN:MqLiParentOppSet]);
                 //query the child opportunities to pass them to the mqli update method                                      
                map<id,Opportunity> ChildOpps=new map<id,Opportunity>([Select id, name,LX_Country_Code__c,CurrencyIsoCode,Master_Opportunity__c
                                                                    from Opportunity
                                                                    Where Master_Opportunity__c IN :MqLiParentOppSet ]);    
                                                                        
                 //query the line items as we need the pricebook.product2 field to pass to the mqli update method                                                            
                map<id,OpportunityLineItem> LineMap=new map<id,OpportunityLineItem>([Select id,OpportunityId,Opportunity.LX_Country_Code__c,CurrencyIsoCode,UnitPrice,Part_Number__c,Parent_ID__c,Description,LX_Extra_Parts_Info__c,Quantity, PricebookEntry.Product2.id 
                                                                                        from OpportunityLineItem
                                                                                        where OpportunityId IN :MqLiParentOppSet]);                                                         
                Map<Id,List<OpportunityLineItem>> Olimp = new Map<Id,List<OpportunityLineItem>>();
               for(OpportunityLineItem oli : LineMap.values()){
               
                   if(Olimp.get(oli.OpportunityId) == null)
                     Olimp.put(oli.OpportunityId, new List<OpportunityLineItem >{oli});
                     else
                     Olimp.get(oli.OpportunityId).add(oli);
                   
               }
               
               
                map<id,Id> childIdsMap = new map<id,Id>();                                                 
                for(Opportunity child:ChildOpps.values()){
                    childIdsMap.put(child.id,child.master_opportunity__c);
                }
                                                               
                 //system.debug('#####first value-->'+ParentOpps.values[0].Sales_Organization__r.LX_Country_Code__c);    
                 if(!ParentOpps.IsEmpty()&&!ChildOpps.IsEmpty()&&!LineMap.IsEmpty()) {                                                              
                     system.debug('##ParentOpps---->'+ParentOpps);
                     system.debug('##ChildOpps---->'+ChildOpps);
                     system.debug('##OppLineMap---->'+LineMap);
                     //calling the mqli update method to create/update the mqli records                                                         
                    // LX_OpportunityLineItemHelper.mqliUpdate1(ParentOpps, ChildOpps, LineMap,Olimp,childIdsMap);   
                 }                               
        }  */

		}

		//*******************************************************************************************************************************************************
		// code written for Soldto Case creation: Start
		if (FirstRun_Check.FirstRun_OpportunityBeforeTrigger == true) if (Trigger.isInsert || Trigger.isUpdate) {
			FirstRun_Check.FirstRun_OpportunityBeforeTrigger = false;
			//When opportunity stage = demonstrating
			Map < Id, List < Opportunity >> AccountOpportunities = new Map < Id, List < Opportunity >> ();
			///bmi update added 12/11

			Map < Id, Opportunity > oppMasterMap = new Map < Id, Opportunity > ();

			For(Opportunity ObjOpportunity: Trigger.New) {
				//  if(trigger.isUpdate){
				//  Opportunity ObjOldOpportunity=Trigger.OldMap.get(ObjOpportunity.Id);
				//  }
				if ((ObjOpportunity.Software_Solutions__c) && (Trigger.isUpdate && Trigger.OldMap.get(ObjOpportunity.Id).LX_Stage_Number_New__c < 3) && (ObjOpportunity.LX_Stage_Number_New__c >= 3) && (ObjOpportunity.StageName != 'Closed Won') && ((ObjOpportunity.LX_Opportunity_Division__c == 'PSW') || (ObjOpportunity.LX_Opportunity_Division__c == 'ISS' && (ObjOpportunity.type != null) && (SoldToCaseOpportunityTypes != null) && (!((SoldToCaseOpportunityTypes.contains(ObjOpportunity.type))))))) {
					List < Opportunity > ListOpp;
					if (ObjOpportunity.Primary_Partner__c == null) {
						if (AccountOpportunities.containsKey(ObjOpportunity.AccountId)) {
							ListOpp = AccountOpportunities.get(ObjOpportunity.AccountId);
						} else {
							ListOpp = new List < Opportunity > ();

						}
						ListOpp.Add(ObjOpportunity);
						AccountOpportunities.Put(ObjOpportunity.AccountId, ListOpp);
					} else {
						if (AccountOpportunities.containsKey(ObjOpportunity.Primary_Partner__c)) {
							ListOpp = AccountOpportunities.get(ObjOpportunity.Primary_Partner__c);
						} else {
							ListOpp = new List < Opportunity > ();

						}
						ListOpp.Add(ObjOpportunity);
						AccountOpportunities.Put(ObjOpportunity.Primary_Partner__c, ListOpp);
					}
				}
			}
			//  LX_OpportunityHelper.BmiUpdate(oppMasterMap);

			if (!AccountOpportunities.isEmpty()) {
				System.debug('====================AccountOpportunities=' + AccountOpportunities);
				//check for if sold to exists for that account. (SAP Record) – same MDM Act #
				Map < String, Id > MDMAccount = new map < String, Id > ();

				//get account MDM IDs
				for (account acc: [Select id, MDM_Account_Number__c, Parentid from account where id in : AccountOpportunities.KeySet()]) {
					if (acc.MDM_Account_Number__c != null) MDMAccount.Put(acc.MDM_Account_Number__c, acc.Id);
				}
				System.debug('====================MDMAccount=' + MDMAccount);
				//get SAP MDM accounts 
				Map < String, List < LX_SAP_Record_Sales_Org__c >> MapSAPMDMAccounts = new Map < String, List < LX_SAP_Record_Sales_Org__c >> ();
				for (LX_SAP_Record_Sales_Org__c ObjSapSalesOrg: [select Id, LX_Sales_Org1__c, LX_Currency__c, LX_MDM_Act__c from LX_SAP_Record_Sales_Org__c where LX_MDM_Act__c in : MDMAccount.Keyset()]) {
					if (MapSAPMDMAccounts.containsKey(ObjSapSalesOrg.LX_MDM_Act__c)) {
						List < LX_SAP_Record_Sales_Org__c > ListSapSalesOrg = MapSAPMDMAccounts.get(ObjSapSalesOrg.LX_MDM_Act__c);
						ListSapSalesOrg.Add(ObjSapSalesOrg);
						MapSAPMDMAccounts.Put(ObjSapSalesOrg.LX_MDM_Act__c, ListSapSalesOrg);

					} else {
						List < LX_SAP_Record_Sales_Org__c > ListSapSalesOrg = new List < LX_SAP_Record_Sales_Org__c > ();
						ListSapSalesOrg.Add(ObjSapSalesOrg);
						MapSAPMDMAccounts.Put(ObjSapSalesOrg.LX_MDM_Act__c, ListSapSalesOrg);

					}
				}
				System.debug('====================MapSAPMDMAccounts=' + MapSAPMDMAccounts);
				/*
        If yes check if one exists for that currency/sales org (Sap sales org related object)
                    If Yes – Do Nothing
                    If No – Create case indicating that sold to needs to be extended for the currency/sales org on the opportunity
            If no
            Create case for sold to to be created for that account with the currency and sales org of the opportunity.
        
        */
				List < Opportunity > NewRequests = new List < Opportunity > ();
				List < Opportunity > ExtendedRequests = new List < Opportunity > ();

				for (string TempMDMAccount: MDMAccount.Keyset()) {
					List < LX_SAP_Record_Sales_Org__c > ListSAPSales = MapSAPMDMAccounts.get(TempMDMAccount);
					Id TempAccountId = MDMAccount.get(TempMDMAccount);
					List < Opportunity > ListOpportunity = AccountOpportunities.get(TempAccountId);
					//  If yes check if one exists for that currency/sales org (Sap sales org related object)
					//          If Yes – Do Nothing
					//     If No – Create case indicating that sold to needs to be extended for the currency/sales org on the opportunity
					if (ListSAPSales != null) {

						for (Opportunity TempOpportunity: ListOpportunity) {
							boolean Isexists = false;
							for (LX_SAP_Record_Sales_Org__c TempSapSalesOrg: ListSAPSales) {
								System.debug('====================TempSapSalesOrg LX_Sales_Org1__c=' + TempSapSalesOrg.LX_Sales_Org1__c);
								System.debug('====================TempSapSalesOrg =' + TempSapSalesOrg.LX_Currency__c);
								System.debug('====================TempOpportunity =' + TempOpportunity.Sales_Organization_value__c);
								System.debug('====================TempOpportunity =' + TempOpportunity.CurrencyIsoCode);




								if (TempOpportunity.CurrencyIsoCode == TempSapSalesOrg.LX_Currency__c && TempOpportunity.Sales_Organization_value__c == TempSapSalesOrg.LX_Sales_Org1__c) {
									Isexists = true;
								}
							}
							// If No – Create case indicating that sold to needs to be extended for the currency/sales org on the opportunity
							if (Isexists == false) ExtendedRequests.Add(TempOpportunity);

						}


					} else {

						System.debug('====================ListOpportunity=' + ListOpportunity);

						//Create case for sold to to be created for that account with the currency and sales org of the opportunity.
						NewRequests.addAll(ListOpportunity);

					}


				}

				System.debug('====================NewRequests=' + NewRequests);
				System.debug('====================ExtendedRequests=' + ExtendedRequests);
				LX_Opportunity_SoldTo_Case LX_OpportunitySoldToCase = new LX_Opportunity_SoldTo_Case();
				if (!ExtendedRequests.IsEmpty()) {
					LX_OpportunitySoldToCase.CreateOpportunitiesSoldToCaseExtendedRequest(ExtendedRequests);
				}
				if (!NewRequests.IsEmpty()) {
					LX_OpportunitySoldToCase.CreateOpportunitiesSoldToCaseNewRequest(NewRequests);
				}

			} //end if 
		}
		// code written for Soldto Case creation: End
		//********************************************************************************************************************************************************
		//Set the Recursion varibale back to false;
		LX_OpportunityHelper.LX_Opportunity_AI_AU = false;
	}

    


}