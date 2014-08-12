/*
Class Name : LX_Offer_EnrollmentDetailsExtension
Description : Extension class for creating Offer Enrollment from an Offer 
Created By : Abhishek Kumat (abhishekkumar3@deloitte.com) 
Created Date : 18-Dec-2013
Modification Log:
-----------------------------a--------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Abhishek Kumar  18-Dec-2013           1000                   Initial Version
Abhishek Kumar  11-Feb-2014                                  Sprint NA 1 
Abhishek Kumar  19-Feb-2014                                  Sprint 13 
Rajesh K        15-July-2014                                 US4091 
Sandeep     	July 2014									 US4230	
*************************************************************************/

public class LX_Offer_EnrollmentDetailsExtension {
	public LX_Offer__c offer {
		get;
		set;
	}
	public ID offId {
		get;
		set;
	}
	public list < LX_Program_Offer__c > prgOfferlst {
		get;
		set;
	} // program offer linked to offer
	public list < LX_Program_Enrollment__c > prgEnrolmntlst {
		get;
		set;
	} // list of program enrollment associated to partner program
	public list < selectOption > purchasingMethodList = new list < selectOption > ();
	public list < selectOption > claimingPartyList = new list < selectOption > ();
	public list < selectOption > timingofDiscountList = new list < selectOption > ();
	public list < selectOption > shipDebitList = new list < selectOption > ();
	public list < selectOption > partyRoleList = new list < selectOption > ();
	//Account 3 tier partners search fields
	//Added on 01/16/2014
	public list < selectOption > optISSCapability = new list < selectOption > ();
	public list < selectOption > optISSSegment = new list < selectOption > ();
	public list < selectOption > optISSCoverageModel = new list < selectOption > ();
	public list < selectOption > optISSCoverageStatus = new list < selectOption > ();
	public list < selectOption > optPhysicalCountry = new list < selectOption > ();
	public list < selectOption > optPartyType = new list < selectOption > ();

	public String m_ISSCapability {
		get;
		set;
	}
	public String m_ISSSegment {
		get;
		set;
	}
	public String m_ISSCoverageModel {
		get;
		set;
	}
	public String m_ISSCoverageStatus {
		get;
		set;
	}
	public String m_PhysicalCountry {
		get;
		set;
	}
	public String m_PartyType {
		get;
		set;
	}
	public String m_AddParties {
		get;
		set;
	}
	private boolean isLastPage = false;
	private integer totalRecs = 0;
	private integer OffsetSize = 0;
	private integer LimitSize = (Integer.valueOf(Label.LX_Page_Limit) > 500 ? 500 : Integer.valueOf(Label.LX_Page_Limit));

	//Ends here 01/16/2014
	public map < Id, Id > prgOffPartProgMap = new map < Id, Id > (); // map of Program offer and Partner Program
	//public map<Id,LX_SAP_Record_Sales_Org__c> sapAccMDMMap = new map<Id,LX_SAP_Record_Sales_Org__c>();//map of account id and SAP Record
	public map < string, List < LX_SAP_Record_Sales_Org__c >> sapAccMDMMap = new map < string, List < LX_SAP_Record_Sales_Org__c >> ();
	List < Account > accList = new List < Account > (); // 
	List < Account > accListMDM = new List < Account > ();
	List < Account > acclistPartner = new List < Account > ();
	public list < OfferEnrolWrapper > offEnrollist {
		get;
		set;
	} // Wrapper class list to create offer Enrollment
	public list < OfferEnrolWrapper > tempOffEnrolLst;
	public set < String > prgEnrlAcc = new set < String > ();
	public list < Account > accMDMlst = new list < Account > ();
	public list < LX_Offer_Enrollment__c > tempOffEnrollist;
	public string purchasingMethod {
		get;
		set;
	}
	public string claimingParty {
		get;
		set;
	}
	public string timingOfDiscount {
		get;
		set;
	}
	public string shipDebit {
		get;
		set;
	}
	public string partyRole {
		get;
		set;
	}
	public boolean enblEnrolBtn {
		get;
		set;
	}
	public LX_Offer_Enrollment__c tempOfEnrl {
		get;
		set;
	}
	//public map<Id,Id> mdmPartnerAccMap = new map<Id,Id>();// map of Partner Account Id and related MDM Account Id
	public map < Id, string > mdmPartnerAccMap = new map < Id, string > ();
	public boolean chkbx {
		get;
		set;
	}
	public boolean varSoftPB {
		get;
		set;
	} //Added for US4091
	public boolean pgBlockRender {
		get;
		set;
	}
	public String accountName {
		get;
		set;
	}
	public String companyNumber {
		get;
		set;
	}
	public list < LX_SAP_Record_Sales_Org__c > sapList {
		get;
		set;
	}
	public String strProgram {
		get;
		set;
	}
	public boolean showPageBlock {
		get;
		set;
	}


	public string mpsCapabilityScore {
		get;
		set;
	}
	public String totCapabilityScore {
		get;
		set;
	}
	public string partnerISSCapScore {
		get;
		set;
	}
	public String phyCountry {
		get;
		set;
	}
	public Account objAccount {
		get;
		set;
	}
	public String soldTo {
		get;
		set;
	}

	public boolean formRender {
		get;
		set;
	}
	public boolean formRender1 {
		get;
		set;
	}
	public boolean notNonQ {
		get;
		set;
	}
	public boolean pgBlockRender1 {
		get;
		set;
	}
	public string sapdetailsmapkey;
	public string sapdetailsmapkey1;
	public boolean varPromotion {
		get;
		set;
	} //Added for US4398


	//Claiming Party shd be disable if Offer GEO = EMEA and Quote Category = PROMOTION
	//Added on 01/16/2014
	public boolean m_ShowClaimingParty {
		get;
		set;
	}
	public boolean m_ShowShipDebit {
		get;
		set;
	}
	public Static List < LX_Offer__c > lstOfferDetails;
	public String accountOwner {
		get;
		set;
	} //account owner added
	//ends here
	// contructor
	// Lines 101- 111 : Added by Venkat on 8/4/2014 for US4026
	public boolean mandateFlagByQcat {
		get {
			system.debug('-----4230----------  1');
			String quoteCatvfStr = ApexPages.currentPage().getParameters().get('Quotecat');
			system.debug('-----4230----------  2' + quoteCatvfStr);
			if (quoteCatvfStr.equalsIgnoreCase('Promotion') || quoteCatvfStr.equalsIgnoreCase('Special Bid Channel') || quoteCatvfStr.equalsIgnoreCase('Logistics') || quoteCatvfStr.equalsIgnoreCase('VIR') || quoteCatvfStr.equalsIgnoreCase('MDF') || quoteCatvfStr.equalsIgnoreCase('Price Protection')) {
				return true;
			}
			return false;
		}
		set;
	}

	public LX_Offer_EnrollmentDetailsExtension(ApexPages.StandardController controller) {
		system.debug('-----4230----------  3 ----inside LX_Offer_EnrollmentDetailsExtension');
		objAccount = new Account();
		objAccount.RecordTypeId = Label.LX_LocPartnerAccount;
		m_ShowClaimingParty = true;
		m_ShowShipDebit = true;
		varSoftPB = true; //Added for US4091
		varPromotion = true; //Added for US4398

		offer = new LX_offer__c();
		offId = ApexPages.currentPage().getParameters().get('offerId');
		system.debug('lstOfferDetails Before== ' + lstOfferDetails);
		lstOfferDetails = new List < LX_Offer__c > ();
		lstOfferDetails = [select id, salesOrg_quote__c, Name, Lx_Quote_Currency__c, RecordType.Name, promotionCategory_quote__c from LX_Offer__c where id = : offId];
		system.debug('-----4230----------  4 ----inside LX_Offer_EnrollmentDetailsExtension' + lstOfferDetails);
		if (!lstOfferDetails.isEmpty()) {
			system.debug('-----4230----------  5 ----inside LX_Offer_EnrollmentDetailsExtension');
			if (lstOfferDetails[0].RecordType.Name == 'Software Pricebook') //Added for US4091
			varSoftPB = False;

			if (lstOfferDetails[0].RecordType.Name == 'Non-Quote Offer') {
				system.debug('-----4230----------  6 ----inside LX_Offer_EnrollmentDetailsExtension');
				notNonQ = False;
				varSoftPB = False;
                this.m_PhysicalCountry = offer.salesRegion_quote__c; //Added US4396
			} else {
				notNonQ = True;
			}
	    String varSource = ApexPages.currentPage().getParameters().get('source');
        system.debug('-----source----------  source ----source source********* '+varSource);
            if(varSource=='offer')
            {
                varPromotion = False;
            }
            
			if (lstOfferDetails[0].RecordType.Name == 'Promotion')//   && lstOfferDetails[0].promotionCategory_quote__c == 'Open Promotion') 
            {
                varSoftPB = False;
                //varPromotion = False;
			}
		} else {
			notNonQ = True;
		}

		system.debug('lstOfferDetails == ' + lstOfferDetails);
		strProgram = ApexPages.currentPage().getParameters().get('program');
		//system.debug('-----4230----------  7 ----inside LX_Offer_EnrollmentDetailsExtension' +strProgram);   
		System.debug('Hello There');
		formRender1 = false;
		pgBlockRender1 = false;
		String currentUserId = UserInfo.getUserId();

		System.debug('@@@@' + currentUserId);

		Profile p = [Select id, Name from Profile where id = : UserInfo.getProfileId() limit 1];
		if (ApexPages.currentPage().getParameters().get('offerId') != Null && ApexPages.currentPage().getParameters().get('offerId') != '') offer = [select Id, Name, salesOrg_quote__c, salesRegion_quote__c, LX_Start_Date__c, Sales_Organization__c, Lx_Quote_Currency__c, salesGeo_quote__c, RecordType.DeveloperName,LX_Country__c, CreatedById from LX_Offer__c where Id = : offId limit 1];

		tempOfEnrl = new LX_Offer_Enrollment__c();
		if (p.Name == 'Sales' && currentUserId == offer.CreatedById) {
			system.debug('-----4230----------  8 ----inside LX_Offer_EnrollmentDetailsExtension');
			System.debug('@@@@1' + offer.CreatedById + ' ' + currentUserId + p.Name + ' ' + p.id);
			formRender = true;
			showClaimingParty();
			pgBlockRender = true;
			getProgramOffer();
		} else if (p.Name == 'Sales') {
			system.debug('-----4230----------  9 ----inside LX_Offer_EnrollmentDetailsExtension');
			System.debug('@@@@2' + offer.CreatedById + ' ' + currentUserId + p.Name + ' ' + p.id);
			formRender = false;
			formRender1 = true;
			pgBlockRender1 = true;
			PageReference pgRef = userNotAllowedToAdd();
		} else {
			system.debug('-----4230----------  10 ----inside LX_Offer_EnrollmentDetailsExtension');
			System.debug('@@@@3' + offer.CreatedById + ' ' + currentUserId + p.Name + ' ' + p.id);
			formRender = true;
			showClaimingParty();
			pgBlockRender = true;
			getProgramOffer();
		}
		System.debug('@@@4' + formRender);
	}




	//Method to display claiming party and ship/debit based on Offer GEO and Quote Category
	private void showClaimingParty() {
		system.debug('-----4230----------  11 ----inside showClaimingParty');
		String strGEO = ApexPages.currentPage().getParameters().get('GEO');
		String strQuoteCategory = ApexPages.currentPage().getParameters().get('Quotecat');

		/*  List<BigMachines__Quote__c> bmQuote = [Select ID,BigMachines__Status__c,Offer__c,CreatedDate  from BigMachines__Quote__c where Offer__c =:offId
                                      ORDER BY CreatedDate DESC limit 1];
        
        if(bmQuote.size()>0)
        {
            if(strGEO != 'NA'&&((bmQuote[0].BigMachines__Status__c =='Start')||(bmQuote[0].BigMachines__Status__c == 'Pending')))
                m_ShowClaimingParty = false;
            
            if(strGEO == 'EMEA'&&((bmQuote[0].BigMachines__Status__c !='Start')&&(bmQuote[0].BigMachines__Status__c != 'Pending'))&&strQuoteCategory != 'Promotion')   
                m_ShowClaimingParty = false;
           
        }*/
		//if(strGEO == 'EMEA' && strQuoteCategory != 'Promotion')
		//m_ShowClaimingParty = false;  
		// Validation to Disable ship/debit for Special Bid Channel and GEO 'EMEA' [Sprint 13]       
		if ((strGEO == 'EMEA' && (offer.RecordType.DeveloperName == 'Special_Bid_Channel' || offer.RecordType.DeveloperName == 'Promotion' || offer.RecordType.DeveloperName == 'Pricelist_Offer')) || (offer.RecordType.DeveloperName == 'VIR' || offer.RecordType.DeveloperName == 'MDF' || offer.RecordType.DeveloperName == 'Logistics' || offer.RecordType.DeveloperName == 'Price_Protection')) {
			system.debug('-----4230----------  12 ----inside showClaimingParty');
			shipDebit = '';
			m_ShowShipDebit = false;
		}
		// Validation to Disable claiming party [Sprint 13]
		if (offer.RecordType.DeveloperName == 'VIR' || offer.RecordType.DeveloperName == 'MDF' || offer.RecordType.DeveloperName == 'Logistics' || offer.RecordType.DeveloperName == 'Price_Protection') {
			system.debug('-----4230----------  13 ----inside showClaimingParty');
			m_ShowClaimingParty = false;
			claimingParty = '';
		}

	}

	//Method to disable Ship/Debit and claiming Party based on Timing of Discount and GEO
	public void showShipDebit() {
		m_ShowShipDebit = true;
		m_ShowClaimingParty = true;

		String strGEO = ApexPages.currentPage().getParameters().get('GEO');
		system.debug('-----4230----------  14 ----inside showShipDebit  strGEO' + strGEO);
		if (strGEO == 'EMEA' && timingOfDiscount == 'Upfront') {
			shipDebit = '';
			m_ShowShipDebit = false;
		}
		if (strGEO != 'NA' && offer.RecordType.DeveloperName == 'VIR' && timingOfDiscount == 'Back-end') {
			claimingParty = '';
			m_ShowClaimingParty = false;
		}
		if ((offer.RecordType.DeveloperName == 'Special_Bid_Channel' || offer.RecordType.DeveloperName == 'Promotion' || offer.RecordType.DeveloperName == 'Pricelist_Offer') && tempOfEnrl.Lx_PartyRole__c == 'Distributor') {
			shipDebit = '';
			m_ShowShipDebit = false;
		}

		if (timingOfDiscount == 'Upfront') {
			if (offer.RecordType.DeveloperName == 'Special_Bid_Channel' || offer.RecordType.DeveloperName == 'Promotion' || offer.RecordType.DeveloperName == 'Pricelist_Offer') {
				claimingParty = '';
				m_ShowClaimingParty = false;
				shipDebit = '';
				m_ShowShipDebit = false;
			} else {
				claimingParty = '';
				m_ShowClaimingParty = false;
			}
		}
		showClaimingParty();
	}

	//Method to set purchasingMethod dropdown values : US4026
	
    public list < selectOption > getpurchasingMethodList() {
		system.debug('-----4230----------  15 ----inside getpurchasingMethodList  ');
		list < selectOption > options = new list < selectOption > ();
		String strQuotecat = ApexPages.currentPage().getParameters().get('Quotecat');
		String strGeo = ApexPages.currentPage().getParameters().get('GEO');
		// options.add(new selectOption('','--None--'));
		if (strQuotecat.equalsIgnoreCase('VIR') || (strQuotecat.equalsIgnoreCase('Special Bid Channel') && !strGeo.equalsIgnoreCase('EMEA')) || strQuotecat.equalsIgnoreCase('Logistics') || strQuotecat.equalsIgnoreCase('MDF')) {
			options.add(new SelectOption('Direct', 'Direct'));
			options.add(new SelectOption('Indirect', 'Indirect'));
		} else if (strQuotecat.equalsIgnoreCase('Price Protection')) {
			options.add(new SelectOption('Direct', 'Direct'));
		} else if (strQuotecat.equalsIgnoreCase('Promotion') && tempOfEnrl.Lx_PartyRole__c == 'Reseller') {
			options.add(new SelectOption('Direct', 'Direct'));
			options.add(new SelectOption('Indirect', 'Indirect'));
		} else if ((strQuotecat.equalsIgnoreCase('Promotion') && tempOfEnrl.Lx_PartyRole__c == 'Distributor') || (strQuotecat.equalsIgnoreCase('Special Bid Channel') && strGeo.equalsIgnoreCase('EMEA') && tempOfEnrl.Lx_PartyRole__c == 'Distributor')) {
			options.add(new SelectOption('Direct', 'Direct'));
		} else if (strQuotecat.equalsIgnoreCase('Special Bid Channel') && strGeo.equalsIgnoreCase('EMEA') && tempOfEnrl.Lx_PartyRole__c == 'Reseller') {
			options.add(new SelectOption('Direct', 'Direct'));
			options.add(new SelectOption('Indirect', 'Indirect'));
		} else {
			for (Schema.PicklistEntry f: LX_Offer_Enrollment__c.LX_Purchasing_Method__c.getDescribe().getPicklistValues()) {

				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}
		}
		/* options.add(new selectOption('','--None--'));
        options.add(new selectOption('Direct','Direct'));  
        options.add(new selectOption('Indirect','Indirect'));  
        options.add(new selectOption('Ineligible','Ineligible'));   */
		return options;
	}
	//Method to set Claiming Party dropdown values: US4026 updated by Venkat on 8/4/2014

    public list < selectOption > getclaimingPartyList() {
		system.debug('-----4230----------  16 ----inside getclaimingPartyList  ');
		list < selectOption > options = new list < selectOption > ();
		String strQuotecat = ApexPages.currentPage().getParameters().get('Quotecat');
		String strGeo = ApexPages.currentPage().getParameters().get('GEO');

		if (strQuotecat.equalsIgnoreCase('Promotion')) {
			if (timingOfDiscount == 'Back-end') {
				options.add(new selectOption('Yes', 'Yes'));
			} else options.add(new selectOption('', ''));
		}
		if (strQuotecat.equalsIgnoreCase('Special Bid Channel')) {
			if (tempOfEnrl.Lx_PartyRole__c == 'Reseller' && timingOfDiscount == 'Upfront') {
				options.add(new selectOption('', ''));
			} else if (tempOfEnrl.Lx_PartyRole__c == 'Reseller' && timingOfDiscount == 'Back-end') {
				if (strGeo.equalsIgnoreCase('EMEA')) {
					options.add(new selectOption('', ''));
				} else {
					options.add(new selectOption('Yes', 'Yes'));
					options.add(new selectOption('No', 'No'));
					options.add(new selectOption('-None-', '--None--'));
				}
			} else if (tempOfEnrl.Lx_PartyRole__c == 'Distributor') {
				options.add(new selectOption('', ''));
			}
		} else if (strQuotecat.equalsIgnoreCase('VIR') || strQuotecat.equalsIgnoreCase('MDF') || strQuotecat.equalsIgnoreCase('Logistics') || strQuotecat.equalsIgnoreCase('Price Protection')) {
			options.add(new selectOption('', ''));
		}
		/* else {
                        options.add(new selectOption('','--None--'));
                        options.add(new selectOption('Yes','Yes'));  
                        options.add(new selectOption('No','No'));     
                      }*/
		return options;
	}
	// Method to set TimingofDiscount dropdown values: US4026 updated by Venkat on 8/4/2014
	
    public list < selectOption > gettimingofDiscountList() {
		system.debug('-----4230----------  17 ----inside gettimingofDiscountList  ');
		//Date BrazilDt = Date.newInstance(2013,10,27);
		Date BrazilDt = Date.newInstance(Integer.valueOf(Label.LX_Brazil_Offer_YYYY), Integer.valueOf(Label.LX_Brazil_Offer_MM), Integer.valueOf(Label.LX_Brazil_Offer_DD));
		system.debug('+++++BrazilDt ' + BrazilDt);
		list < selectOption > options = new list < selectOption > ();
		String strGeo = ApexPages.currentPage().getParameters().get('GEO');
		String strQuotecat = ApexPages.currentPage().getParameters().get('Quotecat');
		if (offer.salesRegion_quote__c == 'Brazil' && offer.LX_Start_Date__c > BrazilDt) options.add(new selectOption('Upfront', 'Upfront'));
		else if (strQuotecat.equalsIgnoreCase('VIR') || strQuotecat.equalsIgnoreCase('MDF') || strQuotecat.equalsIgnoreCase('Logistics') || strQuotecat.equalsIgnoreCase('Price Protection')) {
			options.add(new selectOption('Back-end', 'Back-end'));
		} else if ((strQuotecat.equalsIgnoreCase('Promotion') || strQuotecat.equalsIgnoreCase('Special Bid Channel')) && !(strGeo.equalsIgnoreCase('EMEA'))) {
			options.add(new selectOption('Upfront', 'Upfront'));
			options.add(new selectOption('Back-end', 'Back-end'));
		} else if (strQuotecat.equalsIgnoreCase('Special Bid Channel') && strGeo.equalsIgnoreCase('EMEA') && tempOfEnrl.Lx_PartyRole__c == 'Distributor' && purchasingMethod == 'Direct') options.add(new selectOption('Upfront', 'Upfront'));
		else {
			options.add(new selectOption('', '--None--'));
			options.add(new selectOption('Back-end', 'Back-end'));
			options.add(new selectOption('Upfront', 'Upfront'));
		}
		return options;
	}

	// Method to set Party Role dropdown values
	public list < selectOption > getpartyRoleList() {
		system.debug('-----4230----------  18 ----inside getpartyRoleList  ');
		list < selectOption > options = new list < selectOption > ();
		Schema.DescribeFieldResult fieldResult = Account.Party_Role__c.getDescribe();
		List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
		options.add(new selectOption('', '--None--'));
		for (Schema.PicklistEntry f: ple) {
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		return options;

	}

	// US4026: Setting shipdebit values
	public list < selectOption > getshipDebitList() {
		system.debug('-----4230----------  19 ----inside getshipDebitList  ');
		list < selectOption > options = new list < selectOption > ();
		String strQuotecat = ApexPages.currentPage().getParameters().get('Quotecat');
		String strGEO = ApexPages.currentPage().getParameters().get('GEO');
		if (strQuotecat.equalsIgnoreCase('VIR') || strQuotecat.equalsIgnoreCase('Promotion') || strQuotecat.equalsIgnoreCase('Logistics') || strQuotecat.equalsIgnoreCase('MDF') || strQuotecat.equalsIgnoreCase('Price Protection')) {
			options.add(new selectOption('', ''));
		} else if (strQuotecat.equalsIgnoreCase('Special Bid Channel') && tempOfEnrl.Lx_PartyRole__c == 'Reseller') {
			if (strGeo.equalsIgnoreCase('EMEA')) {
				options.add(new selectOption('', ''));
			} else if (claimingParty == 'Yes') {
				system.debug('*******claimingparty' + claimingParty);
				options.add(new selectOption('No', 'No'));
			} else if (claimingParty == 'No') {
				options.add(new selectOption('Yes', 'Yes'));
			} else options.add(new selectOption('', ''));

		} else if (strQuotecat.equalsIgnoreCase('Special Bid Channel') && tempOfEnrl.Lx_PartyRole__c == 'Distributor') {
			options.add(new selectOption('', ''));

		} else {
			options.add(new selectOption('', '--None--'));
			options.add(new selectOption('Yes', 'Yes'));
			options.add(new selectOption('No', 'No'));
		}
		return options;
	}
	//Get 3 tier partner account search fields
	//Added on 01/16/2014

	public list < selectOption > getoptISSCapability() {
		system.debug('-----4230----------  20 ----inside getoptISSCapability  ');
		list < selectOption > options = new list < selectOption > ();
		Schema.DescribeFieldResult fieldResult = Account.Partner_ISS_Capability_Segment__c.getDescribe();
		List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
		options.add(new selectOption('', '--None--'));
		for (Schema.PicklistEntry f: ple) {
			if ((f.getValue() != 'Hybrid') && (f.getValue() != 'Retail') && (f.getValue() != 'Traditional')) options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		return options;
	}

	public list < selectOption > getoptISSSegment() {
		system.debug('-----4230----------  21 ----inside getoptISSSegment  ');
		list < selectOption > options = new list < selectOption > ();
		Schema.DescribeFieldResult fieldResult = Account.Primary_ISS_Internal_Segment__c.getDescribe();
		List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
		options.add(new selectOption('', '--None--'));
		for (Schema.PicklistEntry f: ple) {
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		return options;
	}

	public list < selectOption > getoptISSCoverageModel() {
		system.debug('-----4230----------  22 ----inside getoptISSCoverageModel  ');
		list < selectOption > options = new list < selectOption > ();
		options.add(new selectOption('', '--None--'));
		for (Schema.PicklistEntry f: Account.ISS_Coverage_Method__c.getDescribe().getPicklistValues()) {
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		return options;
	}

	public list < selectOption > getoptISSCOverageStatus() {
		system.debug('-----4230----------  23 ----inside getoptISSCOverageStatus  ');
		list < selectOption > options = new list < selectOption > ();
		options.add(new selectOption('', '--None--'));
		for (Schema.PicklistEntry f: Account.Coverage_Status__c.getDescribe().getPicklistValues()) {
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		return options;
	}

	public list < selectOption > getoptPhysicalCountry() {
		system.debug('-----4230----------  24 ----inside getoptPhysicalCountry  ');
		list < selectOption > options = new list < selectOption > ();
		options.add(new selectOption('', '--None--'));
		for (Schema.PicklistEntry f: Account.Physical_Country__c.getDescribe().getPicklistValues()) {
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		return options;
	}

	public list < selectOption > getaddParties() {
		system.debug('-----4230----------  25 ----inside getaddParties  ');
		list < selectOption > options = new list < selectOption > ();
		options.add(new SelectOption('No', 'No'));
		options.add(new SelectOption('Yes', 'Yes'));
		return options;
	}

	// US4026 Updated PartyRole method by Venkat on 8/4/2014
	public list < selectOption > getoptPartyRole() {
		system.debug('-----4230----------  26 ----inside getoptPartyRole  ');
		list < selectOption > options = new list < selectOption > ();
		String strQuotecat = ApexPages.currentPage().getParameters().get('Quotecat');
		options.add(new selectOption('', '--None--'));
		if (strQuotecat.equalsIgnoreCase('VIR') || strQuotecat.equalsIgnoreCase('Promotion') || strQuotecat.equalsIgnoreCase('Special Bid Channel') || strQuotecat.equalsIgnoreCase('Logistics') || strQuotecat.equalsIgnoreCase('MDF') || strQuotecat.equalsIgnoreCase('Price Protection')) {
			options.add(new SelectOption('Reseller', 'Reseller'));
			options.add(new SelectOption('Distributor', 'Distributor'));
		} else {
			for (Schema.PicklistEntry f: LX_Offer_Enrollment__c.Lx_PartyRole__c.getDescribe().getPicklistValues()) {

				options.add(new SelectOption(f.getLabel(), f.getValue()));
			}
		}
		return options;
	}

	public list < selectOption > getoptPartyType() {
		system.debug('-----4230----------  26 ----inside getoptPartyRole  ');
		list < selectOption > options = new list < selectOption > ();
		// Map<String,List<String>> parentChildMap = GetDependentOptions('LX_Offer_Enrollment__c', 'Lx_PartyRole__c', 'Lx_PartyType__c');
		// Map <String, List<Schema.PicklistEntry>> dependentMap = LX_Offer_Enrollment__c.LX_Party_Type__c.getDescribe().getDependencies();
		options.add(new selectOption('', '--None--'));
		// system.debug('**********'+parentChildMap);
		// for( Schema.PicklistEntry f : LX_Offer_Enrollment__c.LX_Party_Type__c.getDescribe().getPicklistValues())
		for (Schema.PicklistEntry f: LX_Offer_Enrollment__c.Lx_PartyType__c.getDescribe().getPicklistValues()) {
			options.add(new SelectOption(f.getLabel(), f.getValue()));
		}
		return options;
	}
	//Ends here

	// Method calculates the program Offer details associated with the Offer
	public void getProgramOffer() {
		system.debug('-----4230----------  27 ----inside getProgramOffer  ');
		prgOfferlst = new List < LX_Program_Offer__c > ();
		prgOfferlst = [select Id, Name, LX_Partner_Program__r.Name, LX_Offer__c, LX_Offer__r.Name, LX_Offer__r.LX_Offer_Enrollment_Type__c, LX_Partner_Program__c, LX_Offer__r.salesOrg_quote__c, LX_Offer__r.Lx_Quote_Currency__c from LX_Program_Offer__c where LX_Partner_Program__r.Program_Status__c = : 'Active'
		AND LX_Offer__r.Id = : offId];
		//system.debug('******US3900********offId*'+offId);              
		if (prgOfferlst.size() > 0) {
			system.debug('-----4230----------  28 ----inside getProgramOffer  ' + prgOfferlst.size());
			system.debug('******prgOfferlst' + prgOfferlst);
			for (LX_Program_Offer__c prgof: prgOfferlst) {
				//      system.debug('******US3900*******prgof.LX_Partner_Program__c**'+prgof.LX_Partner_Program__c);      
				//     system.debug('******US3900*******prgof.Id**'+prgof.Id);
				prgOffPartProgMap.put(prgof.Id, prgof.LX_Partner_Program__c);
			}
			system.debug('******prgOffPartProgMap' + prgOffPartProgMap);
			getProgramEnrollment();
		} else {
			system.debug('-----4230----------  29 ----inside getProgramOffer  ' + prgOfferlst.size());
			system.debug('strProgram == ' + strProgram);
			if (strProgram != null && strProgram != 'No Program' && strProgram != '') {
				pgBlockRender = false;
				ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Fatal, 'No Program offer with Active Program is associated with this offer');
				ApexPages.addMessage(msg);
			} else {
				pgBlockRender = true;
				//filterBasedonAccount();
			}
		}
	}

	// Method to calculate Program Enrollment related to Partner program fetched in getProgramOffer() 
	public void getProgramEnrollment() {
		system.debug('-----4230----------  30 ----inside getProgramEnrollment  ');
		if (strProgram != null && strProgram != 'No Program') {
			prgEnrolmntlst = [select Id, Name, LX_Account__r.Name, LX_Account__c, Master_Program__r.Name, Master_Program__c, LX_Account__r.Party_Type__c, LX_Account__r.Party_Role__c, LX_Account__r.Physical_Country__c, LX_Account__r.LXK_Region__c, LX_Account__r.ISS_Coverage_Method__c,
			LX_Account__r.Partner_ISS_Solutions_Capability_Score__c, LX_Account__r.Partner_MPS_Capability_Score__c,
			LX_Account__r.Coverage_Status__c, LX_Account__r.MDM_ID__c, LX_Account__r.MDM_Account_Number__c, LX_Account__r.Partner_ISS_Capability_Segment__c,
			LX_Account__r.Primary_ISS_Internal_Segment__c, LX_Account__r.Company_Number__c, Account_Owner__c from LX_Program_Enrollment__c where Master_Program__c IN: prgOffPartProgMap.values()];
			// system.debug('******US3900*******prgEnrolmntlst.Size**'+prgEnrolmntlst.size());
			system.debug('-----4230----------  30 ----inside getProgramEnrollment  ');
			system.debug('******prgEnrolmntlst ' + prgEnrolmntlst);
			if (prgEnrolmntlst.size() > 0) {
				// system.debug('-----4230----------  31 ----inside getProgramEnrollment  '+prgEnrolmntlst.size());  	
				getOffEnrollist();
			}
		} else {
			system.debug('-----4230----------  32 ----inside getProgramEnrollment  ' + prgEnrolmntlst.size());
			pgBlockRender = true;
			//filterBasedonAccount();
		}

	}

	// This method prepares the record data to be displayed during Offer Enrollment
	public void getOffEnrollist() {
		system.debug('-----4230----------  33 ----inside getOffEnrollist  ');
		offEnrollist = new list < OfferEnrolWrapper > ();
		system.debug('-----4230----------  34 ----inside getOffEnrollist starts ');
		for (LX_Program_Enrollment__c prgEnrl: prgEnrolmntlst) {

			prgEnrlAcc.add(prgEnrl.LX_Account__r.MDM_ID__c);
		}
		system.debug('-----4230----------  35 ----inside getOffEnrollist ends  ');
		system.debug('******prgEnrlAcc' + prgEnrlAcc);

		getSAPRecord();

		system.debug('********prgEnrolmntlst1' + prgEnrolmntlst);

		Set < String > partyRolesAllowed = new Set < String > ();
		partyRolesAllowed.add('Alliance Partner/OEM');
		partyRolesAllowed.add('Distributor');
		partyRolesAllowed.add('Financial Partner');
		partyRolesAllowed.add('Influencer');
		partyRolesAllowed.add('Internal');
		partyRolesAllowed.add('Reseller');
		partyRolesAllowed.add('Retailer');
		partyRolesAllowed.add('Service Partner');
		System.debug('@@@PartyRolesAllowed' + partyRolesAllowed);

		Set < String > partyRolesSet = new Set < String > ();
		partyRolesSet.add('Reseller');
		partyRolesSet.add('Retailer');
		partyRolesSet.add('Service Partner');
		partyRolesSet.add('Financial Partner');
		partyRolesSet.add('Influencer');
		partyRolesSet.add('Alliance Partner/OEM');
		System.debug('@@@partyRolesSet' + partyRolesSet);

		Set < String > partyRolesSetWithDistributor = new Set < String > ();
		partyRolesSetWithDistributor.add('Reseller');
		partyRolesSetWithDistributor.add('Retailer');
		partyRolesSetWithDistributor.add('Service Partner');
		partyRolesSetWithDistributor.add('Financial Partner');
		partyRolesSetWithDistributor.add('Influencer');
		partyRolesSetWithDistributor.add('Alliance Partner/OEM');
		partyRolesSetWithDistributor.add('Distributor');
		System.debug('@@@partyRolesSetWithDistributor ' + partyRolesSetWithDistributor);
		system.debug('-----4230----------  36 ----inside getOffEnrollist starts  ');
		for (LX_Program_Enrollment__c prgEnrl: prgEnrolmntlst) {
			if ((mdmPartnerAccMap.get(prgEnrl.LX_Account__c) != Null)) {
				//for(LX_SAP_Record_Sales_Org__c sapRcd:sapList)
				if (sapAccMDMMap.containsKey(mdmPartnerAccMap.get(prgEnrl.LX_Account__c))) {
					//if(sapRcd.LX_Sold_To__r.LX_MDM_Act__c== prgEnrl.LX_Account__r.MDM_Account_Number__c)
					for (LX_SAP_Record_Sales_Org__c sapRcd: sapAccMDMMap.get(mdmPartnerAccMap.get(prgEnrl.LX_Account__c))) {
						Boolean bShowPartyRoles = ((partyRolesSet.contains(sapRcd.LX_Sold_To__r.LX_Party_Role__c)) && (partyRolesSet.contains(prgEnrl.LX_Account__r.Party_Role__c)) ? true : false);
						System.debug('@@@bShowPartyRoles' + bShowPartyRoles);
						Boolean bShowDistributorPartyRole = ((sapRcd.LX_Sold_To__r.LX_Party_Role__c == 'Distributor') && (prgEnrl.LX_Account__r.Party_Role__c == 'Distributor') ? true : false);
						System.debug('@@@bShowDistributorPartyRole ' + bShowDistributorPartyRole);
						Boolean bShowOtherPartyRoles = ((partyRolesAllowed.contains(sapRcd.LX_Sold_To__r.LX_Party_Role__c)) && !(partyRolesSetWithDistributor.contains(prgEnrl.LX_Account__r.Party_Role__c)) ? true : false);
						System.debug('@@@bShowOtherPartyRoles ' + bShowOtherPartyRoles);
						if (bShowPartyRoles || bShowDistributorPartyRole || bShowOtherPartyRoles) {
							OfferEnrolWrapper offWrap = new OfferEnrolWrapper();
							offWrap.offerName = prgOfferlst[0].LX_Offer__r.Name;
							offWrap.offerId = prgOfferlst[0].LX_Offer__c;
							offWrap.AccountName = prgEnrl.LX_Account__r.Name;
							offWrap.companynumber1 = prgEnrl.LX_Account__r.Company_Number__c;
							offWrap.AccountOwnername = prgEnrl.Account_Owner__c;
							offWrap.prgOfferId = prgOfferlst[0].Id;
							offWrap.AccountId = prgEnrl.LX_Account__c;
							offWrap.ProgName = prgEnrl.Master_Program__r.Name;
							offWrap.ProgId = prgEnrl.Id;
							offWrap.PartyRole = sapRcd.LX_Sold_To__r.LX_Party_Role__c;
							offWrap.PartyType = sapRcd.LX_Sold_To__r.LX_Party_Type__c;
							offWrap.Salesorgname = sapRcd.Sales_Org_Name__c;
							//prgEnrl.LX_Account__r.Party_Role__c;
							offWrap.PhysicalCntry = prgEnrl.LX_Account__r.Physical_Country__c;
							offWrap.Region = prgEnrl.LX_Account__r.LXK_Region__c;
							offWrap.MPSCapabilityScore = prgEnrl.LX_Account__r.Partner_MPS_Capability_Score__c;
							offWrap.PartnerCapabilityScore = prgEnrl.LX_Account__r.Partner_ISS_Solutions_Capability_Score__c;
							offWrap.ISSCoverageMethod = prgEnrl.LX_Account__r.ISS_Coverage_Method__c;
							offWrap.ISSIntseg = prgEnrl.LX_Account__r.Primary_ISS_Internal_Segment__c;
							offWrap.ISSCapSeg = prgEnrl.LX_Account__r.Partner_ISS_Capability_Segment__c;
							offWrap.ISSCoverageStatus = prgEnrl.LX_Account__r.Coverage_Status__c;


							//if(sapAccMDMMap.get(mdmPartnerAccMap.get(prgEnrl.LX_Account__c))!=Null)
							{
								//if(sapAccMDMMap.get(mdmPartnerAccMap.get(prgEnrl.LX_Account__c)).LX_Sold_To__r.RecordTypeId=='012i0000000MmDZ')//sold To
								//if(sapAccMDMMap.get(mdmPartnerAccMap.get(prgEnrl.LX_Account__c)).LX_Sold_To__r.RecordTypeId==Label.LX_SAP_Sold_To)
								{
									/*offWrap.soldTo = sapAccMDMMap.get(mdmPartnerAccMap.get(prgEnrl.LX_Account__c)).LX_Sold_To__r.LX_Sold_To_ID__c;
                                    offWrap.SAPRecord = sapAccMDMMap.get(mdmPartnerAccMap.get(prgEnrl.LX_Account__c)).LX_Sold_To__c;*/
									offWrap.soldTo = sapRcd.LX_Sold_To__r.LX_Sold_To_ID__c;
									offWrap.SAPRecord = sapRcd.LX_Sold_To__c;
								}

								{
									//offWrap.ZIDC = sapAccMDMMap.get(mdmPartnerAccMap.get(prgEnrl.LX_Account__c)).LX_Sold_To__r.LX_ZIDC_ID__c;
									offWrap.ZIDC = sapRcd.LX_Sold_To__r.LX_ZIDC_ID__c;
								}

								//offWrap.salesOrg = sapAccMDMMap.get(mdmPartnerAccMap.get(prgEnrl.LX_Account__c)).LX_Sales_Org1__c;
								offWrap.salesOrg = sapRcd.LX_Sales_Org1__c;
							}
							offEnrollist.add(offWrap);
							system.debug('******offEnrollist' + offEnrollist);
						}
					}
				}

			}

		}
		system.debug('-----4230----------  36 ----inside getOffEnrollist ends  ');
	}

	public void getOffEnrollistByFilter(List < Account > lstAccounts, Map < String, LX_SAP_Record_Sales_Org__c > mapSapDetails) {
		system.debug('-----4230----------  37 ----inside getOffEnrollistByFilter   ');
		offEnrollist = new list < OfferEnrolWrapper > ();
		system.debug('lstAccounts == ' + lstAccounts);
		OfferEnrolWrapper offWrap;
		String acctmapkey;
		//String mapsapmdmidsoldto;
		String mapsapmdmid;

		Set < String > partyRolesAllowed = new Set < String > ();
		partyRolesAllowed.add('Alliance Partner/OEM');
		partyRolesAllowed.add('Distributor');
		partyRolesAllowed.add('Financial Partner');
		partyRolesAllowed.add('Influencer');
		partyRolesAllowed.add('Internal');
		partyRolesAllowed.add('Reseller');
		partyRolesAllowed.add('Retailer');
		partyRolesAllowed.add('Service Partner');
		System.debug('@@@PartyRolesAllowed' + partyRolesAllowed);

		Set < String > partyRolesSet = new Set < String > ();
		partyRolesSet.add('Reseller');
		partyRolesSet.add('Retailer');
		partyRolesSet.add('Service Partner');
		partyRolesSet.add('Financial Partner');
		partyRolesSet.add('Influencer');
		partyRolesSet.add('Alliance Partner/OEM');
		System.debug('@@@partyRolesSet' + partyRolesSet);

		Set < String > partyRolesSetWithDistributor = new Set < String > ();
		partyRolesSetWithDistributor.add('Reseller');
		partyRolesSetWithDistributor.add('Retailer');
		partyRolesSetWithDistributor.add('Service Partner');
		partyRolesSetWithDistributor.add('Financial Partner');
		partyRolesSetWithDistributor.add('Influencer');
		partyRolesSetWithDistributor.add('Alliance Partner/OEM');
		partyRolesSetWithDistributor.add('Distributor');
		System.debug('@@@partyRolesSetWithDistributor ' + partyRolesSetWithDistributor);
		system.debug('-----4230----------  37 ----inside getOffEnrollistByFilter for loop  starts');
		for (Account objAccount: lstAccounts) {
			//acctmapkey = objAccount.MDM_ID__c ;
			//Set <String> mapsapkeyset =  mapSapDetails.keySet();
			//for (String mapsapkey: mapsapkeyset) 
			for (String mapsapkey: mapSapDetails.keySet()) {
				mapsapmdmid = mapsapkey.substring(0, mapsapkey.indexOf(','));
				//if(mapSapDetails.containsKey(objAccount.MDM_ID__c))
				if (mapsapmdmid == objAccount.MDM_ID__c) {
					System.debug('objAccount.MDM_ID__c' + objAccount.MDM_ID__c);
					System.debug('mapsapmdmid ' + mapsapmdmid);
					//System.debug('@@@getOffEnrollist' + mapSapDetails.get(mapsapkey));
					//System.debug('@@@partyRolesAllowed' + partyRolesAllowed);
					//if(mapSapDetails.get(objAccount.MDM_ID__c)!=null)
					if (mapSapDetails.get(mapsapkey) != null) {
						System.debug('inside mapsapdetails ' + mapSapDetails.get(mapsapkey));
						//LX_SAP_Record_Sales_Org__c sapRcdSalesOrg = mapSapDetails.get(objAccount.MDM_ID__c);
						LX_SAP_Record_Sales_Org__c sapRcdSalesOrg = mapSapDetails.get(mapsapkey);
						Boolean bShowPartyRoles = ((partyRolesSet.contains(sapRcdSalesOrg.LX_Sold_To__r.LX_Party_Role__c)) && (partyRolesSet.contains(objAccount.Party_Role__c)) ? true : false);
						System.debug('@@@bShowPartyRoles' + bShowPartyRoles);
						Boolean bShowDistributorPartyRole = ((sapRcdSalesOrg.LX_Sold_To__r.LX_Party_Role__c == 'Distributor') && (objAccount.Party_Role__c == 'Distributor') ? true : false);
						System.debug('@@@bShowDistributorPartyRole ' + bShowDistributorPartyRole);
						Boolean bShowOtherPartyRoles = ((partyRolesAllowed.contains(sapRcdSalesOrg.LX_Sold_To__r.LX_Party_Role__c)) && !(partyRolesSetWithDistributor.contains(objAccount.Party_Role__c)) ? true : false);
						System.debug('@@@bShowOtherPartyRoles ' + bShowOtherPartyRoles);
						if (bShowPartyRoles || bShowDistributorPartyRole || bShowOtherPartyRoles) {
							system.debug('objAccount == ' + objAccount);
							offWrap = new OfferEnrolWrapper();
							offWrap.offerName = offer.Name;
							offWrap.offerId = offer.ID;
							offWrap.prgOfferId = (prgOfferlst != null && prgOfferlst.size() > 0 ? prgOfferlst[0].Id : null);
							//offWrap.ProgName = prgEnrl.Master_Program__r.Name;
							//offWrap.ProgId = prgEnrl.Id;
							offWrap.AccountName = objAccount.Name;
							offWrap.AccountId = objAccount.Id;
							offwrap.AccountOwnername = objAccount.owner.name;
							offwrap.companynumber1 = objAccount.Company_Number__c;
							//offWrap.PartyRole = mapSapDetails.get(objAccount.MDM_ID__c).LX_Sold_To__r.LX_Party_Role__c;
							offWrap.PartyRole = mapSapDetails.get(mapsapkey).LX_Sold_To__r.LX_Party_Role__c;
							//offWrap.PartyType = mapSapDetails.get(objAccount.MDM_ID__c).LX_Sold_To__r.LX_Party_Type__c;
							offWrap.PartyType = mapSapDetails.get(mapsapkey).LX_Sold_To__r.LX_Party_Type__c;
							offWrap.Salesorgname = mapSapDetails.get(mapsapkey).Sales_org_name__c;
							offWrap.PhysicalCntry = objAccount.Physical_Country__c;
							offWrap.Region = objAccount.LXK_Region__c;
							offWrap.MPSCapabilityScore = objAccount.Partner_MPS_Capability_Score__c;
							offWrap.PartnerCapabilityScore = objAccount.Partner_ISS_Solutions_Capability_Score__c;
							offWrap.ISSCoverageMethod = objAccount.ISS_Coverage_Method__c;
							offWrap.ISSIntseg = objAccount.Primary_ISS_Internal_Segment__c;
							offWrap.ISSCapSeg = objAccount.Partner_ISS_Capability_Segment__c;
							offWrap.ISSCoverageStatus = objAccount.Coverage_Status__c;
							offWrap.recordTypeName = objAccount.RecordType.Name;
							system.debug('mapSapDetails == ' + mapSapDetails);
							system.debug('mapSapDetails == ' + mapSapDetails.size());
							system.debug('objAccount == ' + objAccount);
							if (mapSapDetails != null && mapSapDetails.size() > 0 && mapSapDetails.get(mapsapkey) != null) {
								//  system.debug('Slold to =='+mapSapDetails.get(objAccount.MDM_Account_Number__c).LX_Sold_To__r.LX_Sold_To_ID__c);
								//offWrap.soldTo = mapSapDetails.get(objAccount.MDM_ID__c).LX_Sold_To__r.LX_Sold_To_ID__c;
								offWrap.soldTo = mapSapDetails.get(mapsapkey).LX_Sold_To__r.LX_Sold_To_ID__c;
								//offWrap.SAPRecord = mapSapDetails.get(objAccount.MDM_ID__c).LX_Sold_To__r.Id;
								offWrap.SAPRecord = mapSapDetails.get(mapsapkey).LX_Sold_To__r.Id;
								//offWrap.ZIDC = mapSapDetails.get(objAccount.MDM_ID__c).LX_Sold_To__r.LX_ZIDC_ID__c;
								offWrap.ZIDC = mapSapDetails.get(mapsapkey).LX_Sold_To__r.LX_ZIDC_ID__c;
								//offWrap.salesOrg = lstOfferDetails[0].salesOrg_quote__c;
								//offWrap.salesOrg = mapSapDetails.get(objAccount.MDM_ID__c).LX_Sales_Org1__c;
								offWrap.salesOrg = mapSapDetails.get(mapsapkey).LX_Sales_Org1__c;
							}
							offEnrollist.add(offWrap);
							system.debug('******offEnrollist' + offEnrollist);
						}
					}
				}
			}
		}
		system.debug('-----4230----------  38 ----inside getOffEnrollistByFilter for loop  ends');
	}


	// This method is called on change of Party Role dropdown on the VF page and displays records based on Party Role selected on VF

	public void getDynamicProgramEnrollment() {
		system.debug('-----4230----------  39 ----inside getOffEnrollistByFilter ');
		if (strProgram == 'No Program' || strProgram == null) return;
		offEnrollist = new list < OfferEnrolWrapper > ();
		enblEnrolBtn = false;
		String partyTypeAccId;
		partyTypeAccId = '(';

		for (String Id: prgOffPartProgMap.values()) {
			partyTypeAccId += '\'' + Id + '\',';
		}

		partyTypeAccId = partyTypeAccId.removeEnd(',');
		partyTypeAccId += ')';



		string soql = '';
		if (tempOfEnrl.Lx_PartyRole__c != null && tempOfEnrl.Lx_PartyRole__c != '') soql += ' AND LX_Account__r.Party_Role__c = \'' + tempOfEnrl.Lx_PartyRole__c + '\'';
		/* if(partyRole != null && partyRole != '')
            soql += ' And LX_Account__r.Party_Role__c = \'' + partyRole +'\'';  */
		if (m_ISSCapability != null && m_ISSCapability != '') soql += ' AND LX_Account__r.Partner_ISS_Capability_Segment__c = \'' + m_ISSCapability + '\'';
		if (m_ISSSegment != null && m_ISSSegment != '') soql += ' AND LX_Account__r.Primary_ISS_Internal_Segment__c = \'' + m_ISSSegment + '\'';
		if (m_ISSCoverageModel != null && m_ISSCoverageModel != '') soql += ' AND LX_Account__r.ISS_Coverage_Method__c  = \'' + m_ISSCoverageModel + '\'';
		//soql += ' AND LX_Account__r.ISS_Coverage_Model__c = \'' + m_ISSCoverageModel +'\'';
		if (m_ISSCoverageStatus != null && m_ISSCoverageStatus != '') soql += ' AND LX_Account__r.Coverage_Status__c = \'' + m_ISSCoverageStatus + '\'';
		if (mpsCapabilityScore != null && mpsCapabilityScore != '') soql += ' AND LX_Account__r.Partner_MPS_Capability_Score__c >=' + decimal.valueOf(mpsCapabilityScore);
		if (totCapabilityScore != null && totCapabilityScore != '') soql += ' AND LX_Account__r.LX_Total_Capability_Score__c >=' + decimal.valueOf(totCapabilityScore);
		if (partnerISSCapScore != null && partnerISSCapScore != '') soql += ' AND LX_Account__r.Partner_ISS_Solutions_Capability_Score__c >=' + decimal.valueOf(partnerISSCapScore);
		if (m_PhysicalCountry != null && m_PhysicalCountry != '') soql += ' AND LX_Account__r.Physical_Country__c = \'' + m_PhysicalCountry + '\'';
		if (tempOfEnrl.Lx_PartyType__c != null && tempOfEnrl.Lx_PartyType__c != '') soql += ' AND LX_Account__r.Party_Type__c = \'' + tempOfEnrl.Lx_PartyType__c + '\'';
		if (accountName != null && accountName != '') soql += ' AND LX_Account__r.Name like \'%' + accountName + '%\'';
		if (companyNumber != null && companyNumber != '') soql += ' AND LX_Account__r.Company_Number__c = \'' + companyNumber + '\'';

		if (accountOwner != null && accountOwner != '') soql += ' AND LX_Account__r.Owner = \'' + accountOwner + '\'';


		/* if(m_PartyType!=null && m_PartyType!='')
            soql += ' AND LX_Account__r.Party_Type__c = \'' + m_PartyType +'\''; */


		// if((partyRole!=Null)||(m_ISSCapability != null)||(m_ISSSegment != null)||(m_ISSCoverageModel != null)||(m_ISSCoverageStatus != null)||(mpsCapabilityScore != null)||(partnerISSCapScore != null)||(totCapabilityScore != null)||(m_PhysicalCountry != null)||(m_PartyType != null))
		{
			soql = 'select Id,Name,LX_Account__r.Name,LX_Account__c,Master_Program__r.Name,Master_Program__c,LX_Account__r.Party_Type__c,LX_Account__r.Party_Role__c,LX_Account__r.Physical_Country__c,LX_Account__r.LXK_Region__c,LX_Account__r.ISS_Coverage_Method__c,' + 'LX_Account__r.Partner_ISS_Solutions_Capability_Score__c,LX_Account__r.Partner_MPS_Capability_Score__c,' + 'LX_Account__r.Coverage_Status__c,LX_Account__r.Company_Number__c,LX_Account__r.MDM_ID__c,LX_Account__r.MDM_Account_Number__c,LX_Account__r.Partner_ISS_Capability_Segment__c,' + 'LX_Account__r.Primary_ISS_Internal_Segment__c,Account_Owner__c from LX_Program_Enrollment__c where Master_Program__c IN' + partyTypeAccId + ' ' + soql;
			system.debug('-----SOQL---' + soql);
			prgEnrolmntlst = Database.query(soql);
			system.debug('-----4230----------  40 ----inside getOffEnrollistByFilter ' + prgEnrolmntlst.size());
			if (prgEnrolmntlst.size() > 0) {
				getOffEnrollist();
			}

		}
		/* 
        else              
        getProgramEnrollment();*/

		if (soldTo != null && soldTo != '') {
			tempOffEnrolLst = new List < OfferEnrolWrapper > ();
			for (OfferEnrolWrapper offEnrl: offEnrollist) {
				if (offEnrl.soldTo == soldTo) tempOffEnrolLst.add(offEnrl);
			}

			offEnrollist = tempOffEnrolLst;
		}
	}

	public void SearchLogic() {
		system.debug('-----4230----------  41 ----inside SearchLogic ');
		totalRecs = 0;
		OffsetSize = 0;
		LimitSize = Integer.valueOf(Label.LX_Page_Limit);
		system.debug('No Program  4230 **************** : ' + strProgram);
		String varPromotionCategory = ApexPages.currentPage().getParameters().get('PromotionCategory');
		String varQuoteCategory = ApexPages.currentPage().getParameters().get('Quotecat');
 		 String varSource = ApexPages.currentPage().getParameters().get('source');
        system.debug('-----source----------  source ----source source********* '+varSource);
          if (varSource == 'offer')     
          {
              if (varPromotionCategory == 'Open Promotion' && varQuoteCategory == 'Promotion')
        		{
                    filterBasedonAccountforPromotion();                            
                }
          }
          else
          { 
			if (strProgram == 'No Program' || strProgram == null) {
				system.debug('-----4230----------  42 ----inside SearchLogic strProgram is null');
				system.debug('No Program  4230 *****filterBasedonAccount*********** : ' + strProgram);
                 filterBasedonAccount();
        
			} else {
				system.debug('-----4230----------  43 ----inside SearchLogic strProgram is not null');
				system.debug('No Program  4230 *****getDynamicProgramEnrollment*********** : ' + strProgram);
				getDynamicProgramEnrollment();
			}
          }

	}

      public void filterBasedonAccountforPromotion() 
	 {

     	//Initialize Offer enrollment wrapper here
     	offEnrollist = new list < OfferEnrolWrapper > ();
     	enblEnrolBtn = false;

     	//Add filters for Account Name and company number here 
     	//accountName,companyNumber
     	system.debug('accountName == ' + accountName);
     	String strFilter = ' Where';
     	if (accountName != null && accountName != '') strFilter += ' name like \'%' + accountName + '%\'';

     	if (companyNumber != null && companyNumber != '') strFilter += ' AND Company_Number__c = \'' + companyNumber + '\'';
     	if (tempOfEnrl.Lx_PartyRole__c != null && tempOfEnrl.Lx_PartyRole__c != '') strFilter += ' AND Party_Role__c = \'' + tempOfEnrl.Lx_PartyRole__c + '\'';
     	/* if(partyRole != null && partyRole !='')
            strFilter += ' AND Party_Role__c = \'' + partyRole +'\''; */
     	system.debug('***Owner ***4230***** ' + accountOwner);
     	if (accountOwner != null && accountOwner != '') strFilter += ' AND Owner = \'' + accountOwner + '\''; // Account owner added - 06/23/2014
     	system.debug('***RecordType ***4230***** ' + LX_SetRecordIDs.L5LocationPartnerAccountRecordId);
     	//Level 5 accounts means accounts with record type Location Customer and Location Partner
     	strFilter += ' AND Physical_Country__c = \'' + Offer.LX_Country__c + '\'';
     	//strFilter += ' AND (RecordType.ID = \'' + LX_SetRecordIDs.L5LocationCustomerAccountRecordId +'\' OR  RecordType.ID = \'' + LX_SetRecordIDs.L5LocationPartnerAccountRecordId +'\')';
     	strFilter += ' AND (RecordType.ID = \'' + LX_SetRecordIDs.L5LocationPartnerAccountRecordId + '\')';

     	//List<LX_Offer__c> = [select id,salesOrg_quote__c,Name,Lx_Quote_Currency__c from LX_Offer__c where id =: offId];

     	String strSalesOrg = (offer != null ? offer.salesOrg_quote__c : null);
     	String strCurrency = (offer != null ? offer.Lx_Quote_Currency__c : null);
     	system.debug('***strSalesOrg ' + strSalesOrg);
     	if (strSalesOrg == null) return;

     	//Get the account id's from Sap Record based on offer sales org value
     	String strMDMAccountIds = '(';
     	String strStatus = 'Active';
     	String strRecordTypeName = 'LX_Sold_To';
 


     	//   strFilter += ' AND MDM_ID__c in ' + strMDMAccountIds;

     	//Added filter condition to filter accounts if users selects any 3 tier partner values 
     	//Added on 01/16/2014
     	if (m_ISSCapability != null && m_ISSCapability != '') strFilter += ' AND Partner_ISS_Capability_Segment__c =  \'' + m_ISSCapability + '\'';
     	if (m_ISSSegment != null && m_ISSSegment != '') strFilter += ' AND Primary_ISS_Internal_Segment__c =  \'' + m_ISSSegment + '\'';
     	if (m_ISSCoverageModel != null && m_ISSCoverageModel != '') strFilter += ' AND ISS_Coverage_Method__c =  \'' + m_ISSCoverageModel + '\'';
     	//strFilter += ' AND ISS_Coverage_Model__c =  \'' + m_ISSCoverageModel +'\'';
     	if (m_ISSCoverageStatus != null && m_ISSCoverageStatus != '') strFilter += ' AND Coverage_Status__c =  \'' + m_ISSCoverageStatus + '\'';
     	if (mpsCapabilityScore != null && mpsCapabilityScore != '') strFilter += ' AND Partner_MPS_Capability_Score__c >=' + decimal.valueOf(mpsCapabilityScore);
     	if (totCapabilityScore != null && totCapabilityScore != '') strFilter += ' AND LX_Total_Capability_Score__c >=' + decimal.valueOf(totCapabilityScore);
     	if (partnerISSCapScore != null && partnerISSCapScore != '') strFilter += ' AND Partner_ISS_Solutions_Capability_Score__c >=' + decimal.valueOf(partnerISSCapScore);
     	if (m_PhysicalCountry != null && m_PhysicalCountry != '') strFilter += ' AND Physical_Country__c = \'' + m_PhysicalCountry + '\'';
     	if (tempOfEnrl.Lx_PartyType__c != null && tempOfEnrl.Lx_PartyType__c != '') strFilter += ' AND Party_Type__c = \'' + tempOfEnrl.Lx_PartyType__c + '\'';
     	/* if(m_PartyType!=null && m_PartyType!='')
            strFilter += ' AND Party_Type__c = \'' + m_PartyType +'\''; */
     	if (m_AddParties == 'Yes' && (offer.salesGeo_quote__c != null || offer.salesGeo_quote__c != '')) {
     		String strGeo = (LX_Sales_Geo__c.getAll().get(offer.salesGeo_quote__c) != null ? LX_Sales_Geo__c.getAll().get(offer.salesGeo_quote__c).Lx_Geo_Full_Name__c : null);
     		if (strGeo != null) strFilter += ' AND Lx_GEO__c =\'' + strGeo + '\'';
     	}


     	//Ends here

     	strFilter = strFilter.replace('Where AND', 'Where');

     	if (totalRecs == 0) totalRecs = Database.countQuery('select count() from account' + strFilter);
     	strFilter += ' order by Name';
     	strFilter += ' LIMIT :LimitSize OFFSET :OffsetSize';

     	system.debug('strFilter == ' + strFilter);

     	system.debug('LimitSize == ' + LimitSize);
     	system.debug('OffsetSize == ' + OffsetSize);

     	//Declare and get list of accounts bases on account name and company number entered
     	List < Account > lstAccounts = Database.query('select Id,Name,Party_Type__c,Recordtype.Name,Party_Role__c,Physical_Country__c,LXK_Region__c,ISS_Coverage_Method__c,Partner_ISS_Solutions_Capability_Score__c,Partner_MPS_Capability_Score__c,Coverage_Status__c,MDM_ID__c,MDM_Account_Number__c,Partner_ISS_Capability_Segment__c,Primary_ISS_Internal_Segment__c,Owner.name,Company_Number__c from Account' + strFilter);

     	//totalRecs = Database.query('select count(id) from account');
     	//Prepare offer enrolment records
     	getOffEnrollistforPromotion(lstAccounts);


     }


     public void getOffEnrollistforPromotion(List < Account > lstAccounts) {
//     	system.debug('-----4230----------  37 ----inside getOffEnrollistByFilter   ');
     	offEnrollist = new list < OfferEnrolWrapper > ();
  //   	system.debug('lstAccounts == ' + lstAccounts);
     	OfferEnrolWrapper offWrap;
     	//String acctmapkey;
     	String mapsapmdmid;

     	Set < String > partyRolesAllowed = new Set < String > ();
     	partyRolesAllowed.add('Alliance Partner/OEM');
     	partyRolesAllowed.add('Distributor');
     	partyRolesAllowed.add('Financial Partner');
     	partyRolesAllowed.add('Influencer');
     	partyRolesAllowed.add('Internal');
     	partyRolesAllowed.add('Reseller');
     	partyRolesAllowed.add('Retailer');
     	partyRolesAllowed.add('Service Partner');
     	System.debug('@@@PartyRolesAllowed' + partyRolesAllowed);

     	Set < String > partyRolesSet = new Set < String > ();
     	partyRolesSet.add('Reseller');
     	partyRolesSet.add('Retailer');
     	partyRolesSet.add('Service Partner');
     	partyRolesSet.add('Financial Partner');
     	partyRolesSet.add('Influencer');
     	partyRolesSet.add('Alliance Partner/OEM');
     	System.debug('@@@partyRolesSet' + partyRolesSet);

     	Set < String > partyRolesSetWithDistributor = new Set < String > ();
     	partyRolesSetWithDistributor.add('Reseller');
     	partyRolesSetWithDistributor.add('Retailer');
     	partyRolesSetWithDistributor.add('Service Partner');
     	partyRolesSetWithDistributor.add('Financial Partner');
     	partyRolesSetWithDistributor.add('Influencer');
     	partyRolesSetWithDistributor.add('Alliance Partner/OEM');
     	partyRolesSetWithDistributor.add('Distributor');
     	System.debug('@@@partyRolesSetWithDistributor ' + partyRolesSetWithDistributor);
     	system.debug('-----4230----------  37 ----inside getOffEnrollistByFilter for loop  starts');
         
 		
         offWrap = new OfferEnrolWrapper();
     	for (Account objAccount: lstAccounts) {

   //  		System.debug('objAccount.MDM_ID__c' + objAccount.MDM_ID__c);
   //  		System.debug('mapsapmdmid ' + mapsapmdmid);

			
   //  		system.debug('objAccount == ' + objAccount);
     		
     		offWrap.offerName = offer.Name;
     		offWrap.offerId = offer.ID;
     		offWrap.prgOfferId = (prgOfferlst != null && prgOfferlst.size() > 0 ? prgOfferlst[0].Id : null);
     		//offWrap.ProgName = prgEnrl.Master_Program__r.Name;
     		//offWrap.ProgId = prgEnrl.Id;
     		offWrap.AccountName = objAccount.Name;
     		offWrap.AccountId = objAccount.Id;
     		offwrap.AccountOwnername = objAccount.owner.name;
     		offwrap.companynumber1 = objAccount.Company_Number__c;
     		offwrap.partyrole = objaccount.Party_Role__c;
     		offwrap.partytype = objaccount.Party_type__c;
     		offWrap.PhysicalCntry = objAccount.Physical_Country__c;
     		offWrap.Region = objAccount.LXK_Region__c;
     		offWrap.MPSCapabilityScore = objAccount.Partner_MPS_Capability_Score__c;
     		offWrap.PartnerCapabilityScore = objAccount.Partner_ISS_Solutions_Capability_Score__c;
     		offWrap.ISSCoverageMethod = objAccount.ISS_Coverage_Method__c;
     		offWrap.ISSIntseg = objAccount.Primary_ISS_Internal_Segment__c;
     		offWrap.ISSCapSeg = objAccount.Partner_ISS_Capability_Segment__c;
     		offWrap.ISSCoverageStatus = objAccount.Coverage_Status__c;
     		offWrap.recordTypeName = objAccount.RecordType.Name;

    // 		system.debug('objAccount == ' + objAccount);

     		offEnrollist.add(offWrap);
   //  		system.debug('******offEnrollist' + offEnrollist);
 
     		//}

     	}
     	system.debug('-----4230----------  38 ----inside getOffEnrollistByFilter for loop  ends');
     }

    
	public void filterBasedonAccount() {
		system.debug('-----4230----------  44 ----inside filterBasedonAccount');
		//Initialize Offer enrollment wrapper here
		offEnrollist = new list < OfferEnrolWrapper > ();
		enblEnrolBtn = false;

		//Add filters for Account Name and company number here 
		//accountName,companyNumber
		system.debug('accountName == ' + accountName);
		String strFilter = ' Where';
		if (accountName != null && accountName != '') strFilter += ' name like \'%' + accountName + '%\'';

		if (companyNumber != null && companyNumber != '') strFilter += ' AND Company_Number__c = \'' + companyNumber + '\'';
		if (tempOfEnrl.Lx_PartyRole__c != null && tempOfEnrl.Lx_PartyRole__c != '') strFilter += ' AND Party_Role__c = \'' + tempOfEnrl.Lx_PartyRole__c + '\'';
		/* if(partyRole != null && partyRole !='')
            strFilter += ' AND Party_Role__c = \'' + partyRole +'\''; */
		system.debug('***Owner ***4230***** ' + accountOwner);
		if (accountOwner != null && accountOwner != '') strFilter += ' AND Owner = \'' + accountOwner + '\''; // Account owner added - 06/23/2014
		system.debug('***RecordType ***4230***** ' + LX_SetRecordIDs.L5LocationPartnerAccountRecordId);
		//Level 5 accounts means accounts with record type Location Customer and Location Partner

		//strFilter += ' AND (RecordType.ID = \'' + LX_SetRecordIDs.L5LocationCustomerAccountRecordId +'\' OR  RecordType.ID = \'' + LX_SetRecordIDs.L5LocationPartnerAccountRecordId +'\')';
		strFilter += ' AND (RecordType.ID = \'' + LX_SetRecordIDs.L5LocationPartnerAccountRecordId + '\')';
		//List<LX_Offer__c> = [select id,salesOrg_quote__c,Name,Lx_Quote_Currency__c from LX_Offer__c where id =: offId];

		String strSalesOrg = (offer != null ? offer.salesOrg_quote__c : null);
		String strCurrency = (offer != null ? offer.Lx_Quote_Currency__c : null);
		system.debug('***strSalesOrg ' + strSalesOrg);
		if (strSalesOrg == null) return;
		Map < String, LX_SAP_Record_Sales_Org__c > mapSapDetails = new Map < String, LX_SAP_Record_Sales_Org__c > ();
		//Get the account id's from Sap Record based on offer sales org value
		String strMDMAccountIds = '(';
		String strStatus = 'Active';
		String strRecordTypeName = 'LX_Sold_To';
		String strQuery = 'select id,LX_Account_Name__c,LX_Sold_To__r.LX_MDM_Act__c,LX_Sold_To__r.LX_Party_Role__c,LX_Sold_To__r.LX_Party_Type__c,LX_Sold_To__r.LX_Account__r.MDM_ID__c,LX_Sold_To__r.LX_MDM_ID__c,LX_Sold_To__r.LX_Account__r.MDM_Account_Number__c,LX_Sold_To__r.LX_Account__c,LX_Sold_To__r.LX_Sold_To_ID__c,LX_Sold_To__r.LX_ZIDC_ID__c,LX_Sales_Org1__c,Sales_Org_Name__c from LX_SAP_Record_Sales_Org__c ';
		String strOperator = ' Where ';
		//SRINI: updated code for US3478, we should not filter records based on the sales org.
		if (m_AddParties == 'No' || m_AddParties == null) {
			strQuery += ' Where LX_Sales_Org1__c =\'' + strSalesOrg + '\'';
			strOperator = ' AND ';
			strQuery += ' AND LX_Currency__c =\'' + strCurrency + '\'';
		} else {
			multipleSalesOrgDetails();
			return;
		}


		strQuery += strOperator + 'LX_Sold_To__r.LX_Status__c =\'' + strStatus + '\'';

		strQuery += ' AND LX_Status__c =\'' + strStatus + '\'';
		strQuery += ' AND LX_Sold_To__c != null';
		strQuery += ' AND LX_Sold_To__r.Recordtype.DeveloperName =\'' + strRecordTypeName + '\'';
		if (soldTo != null && soldTo != '') strQuery += ' AND LX_Sold_To__r.LX_Sold_To_ID__c like \'%' + soldTo + '%\'';
		if (tempOfEnrl.Lx_PartyType__c != null && tempOfEnrl.Lx_PartyType__c != '') strQuery += ' AND LX_Sold_To__r.LX_Party_Type__c = \'' + tempOfEnrl.Lx_PartyType__c + '\'';
		if (tempOfEnrl.Lx_PartyRole__c != null && tempOfEnrl.Lx_PartyRole__c != '') strQuery += ' AND LX_Sold_To__r.LX_Party_Role__c = \'' + tempOfEnrl.Lx_PartyRole__c + '\'';
		//    strQuery +=' LIMIT 200';
		system.debug('StrQuery == ' + strQuery);
		system.debug('-----4230----------  45 ----inside filterBasedonAccount for loop starts');
		//for(LX_SAP_Record_Sales_Org__c objSapRecord : Database.query(strQuery))
		List < LX_SAP_Record_Sales_Org__c > lstSapSalesRecords = Database.query(strQuery);
		system.debug('-----4230----------  555 ----inside filterBasedonAccount lst' + lstSapSalesRecords.size());
		for (LX_SAP_Record_Sales_Org__c objSapRecord: lstSapSalesRecords) {
			//system.debug('objSapRecord == '+objSapRecord.LX_Sold_To__r.LX_Sold_To_ID__c);
			/* if(objSapRecord.LX_Account_Name__c != null && objSapRecord.LX_Sold_To__r.LX_Account__c != null
                            && objSapRecord.LX_Sold_To__r.LX_Account__r.MDM_Account_Number__c != null)*/
			if (objSapRecord.LX_Sold_To__r.LX_MDM_ID__c != null) {
				if (strMDMAccountIds.length() > 1) strMDMAccountIds += ',';
				//strMDMAccountIds += '\'' + objSapRecord.LX_Sold_To__r.LX_Account__r.MDM_Account_Number__c + '\'';
				strMDMAccountIds += '\'' + objSapRecord.LX_Sold_To__r.LX_MDM_ID__c + '\'';
				//mapSapDetails.put(objSapRecord.LX_Sold_To__r.LX_Account__r.MDM_Account_Number__c,objSapRecord);
				sapdetailsmapkey = objSapRecord.LX_Sold_To__r.LX_MDM_ID__c + ',' + objSapRecord.LX_Sold_To__r.LX_Sold_To_ID__c;
				mapSapDetails.put(sapdetailsmapkey, objSapRecord);
				//mapSapDetails.put(objSapRecord.LX_Sold_To__r.LX_MDM_ID__c,objSapRecord);
				System.debug('mapSapDetails Size' + mapSapDetails.size());
			}

		}
		system.debug('-----4230----------  46 ----inside filterBasedonAccount for loop ends');
		system.debug('strMDMAccountIds == ' + strMDMAccountIds);
		//strMDMAccountIds = strMDMAccountIds.replace('null,','');
		strMDMAccountIds += ')';
		//if we dont have matching accounts with offer sales org record in SAP record object then return
		if (strMDMAccountIds.length() <= 2) return;
		//if(strMDMAccountIds.length() > 2)
		strFilter += ' AND MDM_ID__c in ' + strMDMAccountIds;

		//Added filter condition to filter accounts if users selects any 3 tier partner values 
		//Added on 01/16/2014
		if (m_ISSCapability != null && m_ISSCapability != '') strFilter += ' AND Partner_ISS_Capability_Segment__c =  \'' + m_ISSCapability + '\'';
		if (m_ISSSegment != null && m_ISSSegment != '') strFilter += ' AND Primary_ISS_Internal_Segment__c =  \'' + m_ISSSegment + '\'';
		if (m_ISSCoverageModel != null && m_ISSCoverageModel != '') strFilter += ' AND ISS_Coverage_Method__c =  \'' + m_ISSCoverageModel + '\'';
		//strFilter += ' AND ISS_Coverage_Model__c =  \'' + m_ISSCoverageModel +'\'';
		if (m_ISSCoverageStatus != null && m_ISSCoverageStatus != '') strFilter += ' AND Coverage_Status__c =  \'' + m_ISSCoverageStatus + '\'';
		if (mpsCapabilityScore != null && mpsCapabilityScore != '') strFilter += ' AND Partner_MPS_Capability_Score__c >=' + decimal.valueOf(mpsCapabilityScore);
		if (totCapabilityScore != null && totCapabilityScore != '') strFilter += ' AND LX_Total_Capability_Score__c >=' + decimal.valueOf(totCapabilityScore);
		if (partnerISSCapScore != null && partnerISSCapScore != '') strFilter += ' AND Partner_ISS_Solutions_Capability_Score__c >=' + decimal.valueOf(partnerISSCapScore);
		if (m_PhysicalCountry != null && m_PhysicalCountry != '') strFilter += ' AND Physical_Country__c = \'' + m_PhysicalCountry + '\'';
		if (tempOfEnrl.Lx_PartyType__c != null && tempOfEnrl.Lx_PartyType__c != '') strFilter += ' AND Party_Type__c = \'' + tempOfEnrl.Lx_PartyType__c + '\'';
		/* if(m_PartyType!=null && m_PartyType!='')
            strFilter += ' AND Party_Type__c = \'' + m_PartyType +'\''; */
		if (m_AddParties == 'Yes' && (offer.salesGeo_quote__c != null || offer.salesGeo_quote__c != '')) {
			String strGeo = (LX_Sales_Geo__c.getAll().get(offer.salesGeo_quote__c) != null ? LX_Sales_Geo__c.getAll().get(offer.salesGeo_quote__c).Lx_Geo_Full_Name__c : null);
			if (strGeo != null) strFilter += ' AND Lx_GEO__c =\'' + strGeo + '\'';
		}


		//Ends here

		strFilter = strFilter.replace('Where AND', 'Where');
		if (totalRecs == 0) totalRecs = Database.countQuery('select count() from account' + strFilter);
		strFilter += ' order by Name';
	 	strFilter += ' LIMIT :LimitSize OFFSET :OffsetSize';

		system.debug('strFilter == ' + strFilter);

		system.debug('LimitSize == ' + LimitSize);
		system.debug('OffsetSize == ' + OffsetSize);

		//Declare and get list of accounts bases on account name and company number entered
		List < Account > lstAccounts = Database.query('select Id,Name,Party_Type__c,Recordtype.Name,Party_Role__c,Physical_Country__c,LXK_Region__c,ISS_Coverage_Method__c,Partner_ISS_Solutions_Capability_Score__c,Partner_MPS_Capability_Score__c,Coverage_Status__c,MDM_ID__c,MDM_Account_Number__c,Partner_ISS_Capability_Segment__c,Primary_ISS_Internal_Segment__c,Owner.name,Company_Number__c from Account' + strFilter);

		//totalRecs = Database.query('select count(id) from account');
		//Prepare offer enrolment records
		getOffEnrollistByFilter(lstAccounts, mapSapDetails);
		system.debug('-----4230----------  47 ----inside filterBasedonAccount end here');
	}

	/* method to query SAP Record Sales Organization object and find records based on MDM Account number captured
       in getOffEnrollist()  method and Offer Salesorg
    */
	public void getSAPRecord() {
		system.debug('-----4230----------  48 ----inside getSAPRecord ');
		system.debug('prgOfferlst == ' + prgOfferlst[0]);
		system.debug('prgEnrlAcc == ' + prgEnrlAcc);
		if (m_AddParties == 'No' || m_AddParties == null) {
			system.debug('-----4230----------  49 ----inside getSAPRecord ');
			sapList = [select Id, Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Sold_To__r.LX_ZIDC_ID__c, LX_Sold_To__r.LX_MDM_Act__c, LX_Sold_To__r.LX_MDM_ID__c, LX_Sold_To__r.RecordTypeId, LX_Sold_To__r.LX_Account__c, LX_Sales_Org1__c, LX_Sold_To__r.LX_Party_Role__c, LX_Sold_To__r.LX_Party_Type__c, Sales_Org_Name__c from LX_SAP_Record_Sales_Org__c
			where LX_Sales_Org1__c = : prgOfferlst[0].LX_Offer__r.salesOrg_quote__c AND LX_Currency__c = : prgOfferlst[0].LX_Offer__r.Lx_Quote_Currency__c AND LX_Status__c = : 'Active'
			AND
			LX_Sold_To__r.Recordtype.DeveloperName = : 'LX_Sold_To'
			AND LX_Sold_To__r.LX_Status__c = : 'Active'
			AND(LX_Sold_To__r.LX_Sold_To_ID__c != Null OR LX_Sold_To__r.LX_Sold_To_ID__c != '') AND LX_Sold_To__r.LX_MDM_ID__c IN: prgEnrlAcc];
		} else sapList = [select Id, Name, LX_Sold_To__r.LX_Sold_To_ID__c, LX_Sold_To__r.LX_ZIDC_ID__c, LX_Sold_To__r.LX_MDM_Act__c, LX_Sold_To__r.LX_MDM_ID__c, LX_Sold_To__r.RecordTypeId, LX_Sold_To__r.LX_Account__c, LX_Sales_Org1__c, LX_Sold_To__r.LX_Party_Role__c, LX_Sold_To__r.LX_Party_Type__c, Sales_Org_Name__c from LX_SAP_Record_Sales_Org__c
		where LX_Status__c = : 'Active'
		AND
		LX_Sold_To__r.Recordtype.DeveloperName = : 'LX_Sold_To'
		AND LX_Sold_To__r.LX_Status__c = : 'Active'
		AND(LX_Sold_To__r.LX_Sold_To_ID__c != Null OR LX_Sold_To__r.LX_Sold_To_ID__c != '') AND LX_Sold_To__r.LX_MDM_ID__c IN: prgEnrlAcc];


		system.debug('******sapList' + sapList);
		sapAccMDMMap.clear();
		system.debug('-----4230----------  50 ----inside getSAPRecord  for loop starts');
		for (LX_SAP_Record_Sales_Org__c st: sapList) {
			if (!sapAccMDMMap.keySet().contains(st.LX_Sold_To__r.LX_MDM_ID__c)) sapAccMDMMap.put(st.LX_Sold_To__r.LX_MDM_ID__c, new List < LX_SAP_Record_Sales_Org__c > ());
			sapAccMDMMap.get(st.LX_Sold_To__r.LX_MDM_ID__c).add(st);

			//sapAccMDMMap.put(st.LX_Sold_To__r.LX_MDM_Act__c,st);      
		}
		system.debug('-----4230----------  51 ----inside getSAPRecord  for loop ends');
		MDMPartnerAccount();
	}

	// This method queries account and fetches MDM Partner and Location Partner Account based on MDM number
	public void MDMPartnerAccount() {
		system.debug('-----4230----------  52 ----inside MDMPartnerAccount');
		//accList = [select Id,Name,RecordTypeId,MDM_Account_Number__c from Account where MDM_ID__c IN: prgEnrlAcc and (RecordTypeId=:'012i0000000MmKy' or RecordTypeId=:'012i0000000MmKx') ]; 
		//accList = [select Id,Name,RecordTypeId,MDM_Account_Number__c from Account where MDM_ID__c IN: prgEnrlAcc and (RecordTypeId=:Label.LX_MDM_Partner_Account or RecordTypeId=:Label.LX_LocPartnerAccount) ];

		accList = [select Id, Name, RecordTypeId, MDM_ID__c, MDM_Account_Number__c from Account where MDM_ID__c IN: prgEnrlAcc and RecordTypeId = : Label.LX_LocPartnerAccount];
		system.debug('******accList' + accList);
		if (m_AddParties == 'Yes' && (offer.salesGeo_quote__c != null || offer.salesGeo_quote__c != '')) {
			String strGeo = (LX_Sales_Geo__c.getAll().get(offer.salesGeo_quote__c) != null ? LX_Sales_Geo__c.getAll().get(offer.salesGeo_quote__c).Lx_Geo_Full_Name__c : null);
			if (strGeo != null) accList = [select Id, Name, RecordTypeId, MDM_ID__c, MDM_Account_Number__c from Account where MDM_ID__c IN: prgEnrlAcc and RecordTypeId = : Label.LX_LocPartnerAccount and Lx_GEO__c = : strGeo];
		} else accList = [select Id, Name, RecordTypeId, MDM_ID__c, MDM_Account_Number__c from Account where MDM_ID__c IN: prgEnrlAcc and RecordTypeId = : Label.LX_LocPartnerAccount];
		system.debug('-----4230----------  53 ----inside MDMPartnerAccount for loop starts');
		for (Account acc: accList) {
			mdmPartnerAccMap.put(acc.Id, acc.MDM_ID__c);
		}
		system.debug('-----4230----------  54 ----inside MDMPartnerAccount for loop ends');

	}
	// Wrapper class
	public class OfferEnrolWrapper {

		public LX_Program_Enrollment__c prgEnl {
			get;
			set;
		}
		public string offerName {
			get;
			set;
		}
		public Id offerId {
			get;
			set;
		}
		public Id prgOfferId {
			get;
			set;
		}
		public string AccountName {
			get;
			set;
		}
		public string AccountownerName {
			get;
			set;
		}
		public string companyNumber1 {
			get;
			set;
		}
		public Id AccountId {
			get;
			set;
		}
		public Id ProgId {
			get;
			set;
		}
		public Id SAPRecord {
			get;
			set;
		}
		public string ProgName {
			get;
			set;
		}
		public string PartyRole {
			get;
			set;
		}
		public string PartyType {
			get;
			set;
		}
		public string PhysicalCntry {
			get;
			set;
		}
		public string Region {
			get;
			set;
		}
		public Decimal MPSCapabilityScore {
			get;
			set;
		}
		public Decimal PartnerCapabilityScore {
			get;
			set;
		}
		public string ISSCoverageMethod {
			get;
			set;
		}
		public string ISSIntseg {
			get;
			set;
		}
		public string ISSCapSeg {
			get;
			set;
		}
		public string ISSCoverageStatus {
			get;
			set;
		}
		public string soldTo {
			get;
			set;
		}
		public string Salesorgname {
			get;
			set;
		}
		public string recordTypeName {
			get;
			set;
		}
		public string ZIDC {
			get;
			set;
		}
		public string salesOrg {
			get;
			set;
		}
		public boolean selected {
			get;
			set;
		}
		public Account accountRecord {
			get;
			set;
		}
		public OfferEnrolWrapper() {
			system.debug('-----4230----------  55 ----inside MDMPartnerAccount ');
			this.selected = false;
		}
		public string accountOwner {
			get;
			set;
		}

	}
	public PageReference cancelLogic() {
		system.debug('-----4230----------  56 ----inside cancelLogic');
		PageReference PageRef = new PageReference('/' + offId);

		return PageRef;
	}
	// This method is called on click of Enroll button
	public PageReference createOfferEnrollment() {
		system.debug('-----4230----------  57 ----inside createOfferEnrollment');
		tempOffEnrollist = new List < LX_Offer_Enrollment__c > ();
		system.debug('@@@@offEnrollist' + offEnrollist);
        String varPromotionCategory = ApexPages.currentPage().getParameters().get('PromotionCategory');
		String varQuoteCategory = ApexPages.currentPage().getParameters().get('Quotecat');
		 String varSource = ApexPages.currentPage().getParameters().get('source');
		if (offEnrollist != null) {
			system.debug('-----4230----------  58 ----inside createOfferEnrollment for loop starts');
			for (OfferEnrolWrapper off: offEnrollist) {
				//if(prgOfferlst[0].LX_Offer__r.LX_Offer_Enrollment_Type__c== 'Conditional')
				{
					if (off.selected == true) {
						LX_Offer_Enrollment__c offEnrol = new LX_Offer_Enrollment__c();
						offEnrol.Account__c = off.AccountId;
						offEnrol.Program_Enrollment__c = off.ProgId;
						offEnrol.Program_Offer__c = off.prgOfferId;
						offEnrol.Offer__c = off.offerId;
						offEnrol.LX_Product_Line_Items__c = tempOfEnrl.LX_Product_Line_Items__c;
						offEnrol.LX_Purchasing_Method__c = purchasingMethod;
						offEnrol.LX_Claiming_Party__c = claimingParty;
						offEnrol.LX_Timing_of_Discount__c = timingOfDiscount;
						offEnrol.LX_Ship_Debit__c = shipDebit;
						offEnrol.SAP_Record__c = off.SAPRecord; 
                        
					
 						if (varPromotionCategory == 'Open Promotion' && varQuoteCategory == 'Promotion' && varSource == 'offer')
        				{
                            system.debug('-----4230----------  ----inside createOfferEnrollment ****** Open Promotion starts');
                            offEnrol.LX_Offer_Enrollment_Status__c='Eligible';
                        }                        
						tempOffEnrollist.add(offEnrol);
					}

				}

			}
			system.debug('-----4230----------  59 ----inside createOfferEnrollment for loop ends');
		}
		if (tempOffEnrollist.size() > 0) {
			try {
				insert tempOffEnrollist;
				PageReference PageRef = new PageReference('/' + offId);
				return PageRef;
			} catch (DmlException ex) {
				ApexPages.addMessages(ex);
				return null;
			}
		} else {
			ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Fatal, 'Please select the records');
			ApexPages.addMessage(msg);
			return null;
		}
	}

	private void multipleSalesOrgDetails() {
		system.debug('-----4230----------  60 ----inside multipleSalesOrgDetails ');
		Map < String, Account > mapAccts = getAccountDetails();
		if (mapAccts.size() <= 0) return;
		//totalRecs = mapAccts.size();
		//Get Sap Record Sales org records based on account MDM numbers
		//Map<String,LX_SAP_Record_Sales_Org__c> mapSaleOrg = getSapRecordSalesOrg(mapAccts.keySet());
		Map < String, List < LX_SAP_Record_Sales_Org__c >> mapSaleOrg = getSapRecordSalesOrg(mapAccts.keySet());
		if (mapSaleOrg.size() <= 0) return;
		PrepareWrapperClass(mapAccts, mapSaleOrg);
	}


	private Map < String, Account > getAccountDetails() {
		system.debug('-----4230----------  61 ----inside getAccountDetails ');
		Map < String, Account > mapMDMAccounts = new Map < String, Account > ();
		String strFilters = prepareQueryFilters();
		System.Debug('strFilters =' + strFilters);
		//String strCountFilter = strFilters.replace(' order by Name','');
		//strCountFilter = strCountFilter.replace('LIMIT :LimitSize OFFSET :OffsetSize','');
		//strFilters = strFilters.replace(' order by Name','');
		system.debug('-----4230----------  61 ----inside getAccountDetails  for loop starts');
		//Declare and get list of accounts bases on account name and company number entered
		for (Account objAcc: Database.Query('select Id,Name,Party_Type__c,Recordtype.Name,Party_Role__c,Physical_Country__c,LXK_Region__c,ISS_Coverage_Method__c,Partner_ISS_Solutions_Capability_Score__c,Partner_MPS_Capability_Score__c,Coverage_Status__c,MDM_ID__c,MDM_Account_Number__c,Partner_ISS_Capability_Segment__c,Primary_ISS_Internal_Segment__c,owner.name,Company_number__c from Account' + strFilters)) {
			mapMDMAccounts.put(objAcc.MDM_ID__c, objAcc);
		}
		system.debug('-----4230----------  62 ----inside getAccountDetails  for loop ends');
		return mapMDMAccounts;

	}

	private Map < String, List < LX_SAP_Record_Sales_Org__c >> getSapRecordSalesOrg(Set < String > setMDMAcctNumbers) {
		system.debug('-----4230----------  62 ----inside getSapRecordSalesOrg ');
		Map < String, List < LX_SAP_Record_Sales_Org__c >> mapSapRecrDetails = new Map < String, List < LX_SAP_Record_Sales_Org__c >> ();
		String strOperator = ' Where ';
		String strStatus = 'Active';
		String saprecordmapkey;
		String strRecordTypeName = 'LX_Sold_To';
		String strQuery = '';
		strQuery += strOperator + 'LX_Sold_To__r.LX_Status__c =\'' + strStatus + '\'';
		strQuery += ' AND LX_Status__c =\'' + strStatus + '\'';
		strQuery += ' AND LX_Sold_To__c != null';
		strQuery += ' AND LX_Sold_To__r.Recordtype.DeveloperName =\'' + strRecordTypeName + '\'';
		if (soldTo != null && soldTo != '') strQuery += ' AND LX_Sold_To__r.LX_Sold_To_ID__c like \'%' + soldTo + '%\'';
		if (setMDMAcctNumbers.size() > 0) {
			strQuery += ' AND LX_Sold_To__r.LX_MDM_ID__c in (';
			System.debug('setMDMAcctNumbers = ' + setMDMAcctNumbers);
			for (String str: setMDMAcctNumbers) {
				strQuery += '\'' + str + '\',';
			}
			strQuery = strQuery.removeEnd(',');
			strQuery += ')';
		}
		system.debug('LimitSize == ' + LimitSize);
		system.debug('OffsetSize == ' + OffsetSize);
		if (totalRecs == 0) totalRecs = database.countQuery('select count() from LX_SAP_Record_Sales_Org__c' + strQuery);
		system.debug('totalrecs == ' + totalrecs);
		strQuery += ' order by Name';
		if (isLastPage) OffsetSize = totalRecs - LimitSize;
		strQuery += ' LIMIT :LimitSize OFFSET :OffsetSize';

		system.debug('strQuery == ' + strQuery);
		system.debug('-----4230----------  63 ----inside getSapRecordSalesOrg  for loop starts');
		for (LX_SAP_Record_Sales_Org__c objSapRecord: Database.query('select id,LX_Account_Name__c,LX_Sold_To__r.LX_MDM_ID__c,LX_Sold_To__r.LX_Account__r.MDM_ID__c,LX_Sold_To__r.LX_MDM_Act__c,LX_Sold_To__r.LX_Account__r.MDM_Account_Number__c,LX_Sold_To__r.LX_Account__c,LX_Sold_To__r.LX_Sold_To_ID__c,LX_Sold_To__r.LX_ZIDC_ID__c,LX_Sales_Org1__c,LX_Sold_To__r.LX_Party_Role__c,LX_Sold_To__r.LX_Party_Type__c,Sales_Org_Name__c from LX_SAP_Record_Sales_Org__c' + strQuery)) {
			saprecordmapkey = objSapRecord.LX_Sold_To__r.LX_MDM_ID__c + ',' + objSapRecord.LX_Sold_To__r.LX_Sold_To_ID__c + objSapRecord.LX_Sales_Org1__c;
			//LX_Sales_Org1__c
			//mapSapDetails.put(objSapRecord.LX_Sold_To__r.LX_MDM_Act__c,objSapRecord);
			//if(!mapSapRecrDetails.keySet().contains(saprecordmapkey))
			if (!mapSapRecrDetails.keySet().contains(objSapRecord.LX_Sold_To__r.LX_MDM_ID__c)) mapSapRecrDetails.put(objSapRecord.LX_Sold_To__r.LX_MDM_ID__c, new List < LX_SAP_Record_Sales_Org__c > ());
			mapSapRecrDetails.get(objSapRecord.LX_Sold_To__r.LX_MDM_ID__c).add(objSapRecord);
			//mapSapRecrDetails.put(saprecordmapkey,new List<LX_SAP_Record_Sales_Org__c >());
			//mapSapRecrDetails.get(saprecordmapkey).add(objSapRecord);

		}
		System.debug('mapSapRecrDetails size' + mapSapRecrDetails.size());
		system.debug('-----4230----------  64 ----inside getSapRecordSalesOrg  for loop ends');
		return mapSapRecrDetails;

	}

	private String prepareQueryFilters() {
		system.debug('-----4230----------  65 ----inside prepareQueryFilters  ');
		String strFilter = ' Where';
		if (accountName != null && accountName != '') strFilter += ' name like \'%' + accountName + '%\'';
		if (companyNumber != null && companyNumber != '') strFilter += ' AND Company_Number__c = \'' + companyNumber + '\'';

		if (accountOwner != null && accountOwner != '') strFilter += ' AND Owner = \'' + accountOwner + '\''; // Account owner added - 06/23/2014

		if (tempOfEnrl.Lx_PartyRole__c != null && tempOfEnrl.Lx_PartyRole__c != '') strFilter += ' AND Party_Role__c = \'' + tempOfEnrl.Lx_PartyRole__c + '\'';
		strFilter += ' AND (RecordType.ID = \'' + LX_SetRecordIDs.L5LocationPartnerAccountRecordId + '\')';
		//Added filter condition to filter accounts if users selects any 3 tier partner values 
		//Added on 01/16/2014
		if (m_ISSCapability != null && m_ISSCapability != '') strFilter += ' AND Partner_ISS_Capability_Segment__c =  \'' + m_ISSCapability + '\'';
		if (m_ISSSegment != null && m_ISSSegment != '') strFilter += ' AND Primary_ISS_Internal_Segment__c =  \'' + m_ISSSegment + '\'';
		if (m_ISSCoverageModel != null && m_ISSCoverageModel != '') strFilter += ' AND ISS_Coverage_Method__c =  \'' + m_ISSCoverageModel + '\'';
		//strFilter += ' AND ISS_Coverage_Model__c =  \'' + m_ISSCoverageModel +'\'';
		if (m_ISSCoverageStatus != null && m_ISSCoverageStatus != '') strFilter += ' AND Coverage_Status__c =  \'' + m_ISSCoverageStatus + '\'';
		if (mpsCapabilityScore != null && mpsCapabilityScore != '') strFilter += ' AND Partner_MPS_Capability_Score__c >=' + decimal.valueOf(mpsCapabilityScore);
		if (totCapabilityScore != null && totCapabilityScore != '') strFilter += ' AND LX_Total_Capability_Score__c >=' + decimal.valueOf(totCapabilityScore);
		if (partnerISSCapScore != null && partnerISSCapScore != '') strFilter += ' AND Partner_ISS_Solutions_Capability_Score__c >=' + decimal.valueOf(partnerISSCapScore);
		if (m_PhysicalCountry != null && m_PhysicalCountry != '') strFilter += ' AND Physical_Country__c = \'' + m_PhysicalCountry + '\'';
		if (tempOfEnrl.Lx_PartyType__c != null && tempOfEnrl.Lx_PartyType__c != '') strFilter += ' AND Party_Type__c = \'' + tempOfEnrl.Lx_PartyType__c + '\'';
		if (m_AddParties == 'Yes' && (offer.salesGeo_quote__c != null || offer.salesGeo_quote__c != '')) {
			String strGeo = (LX_Sales_Geo__c.getAll().get(offer.salesGeo_quote__c) != null ? LX_Sales_Geo__c.getAll().get(offer.salesGeo_quote__c).Lx_Geo_Full_Name__c : null);
			if (strGeo != null) strFilter += ' AND Lx_GEO__c =\'' + strGeo + '\'';
		}
		strFilter += ' AND MDM_ID__c != null';
		//strFilter += ' order by Name';
		//strFilter += ' LIMIT :LimitSize OFFSET :OffsetSize';
		strFilter = strFilter.replace('Where AND', 'Where');
		system.debug('strFilter == ' + strFilter);
		return strFilter;
	}

	//public void PrepareWrapperClass(Map<String,Account> MapAccounts,Map<String,LX_SAP_Record_Sales_Org__c> mapSapDetails,List<LX_Offer__c> lstOfferDetails)
	public void PrepareWrapperClass(Map < String, Account > MapAccounts, Map < String, List < LX_SAP_Record_Sales_Org__c >> mapSapDetails) {
		system.debug('-----4230----------  66 ----inside PrepareWrapperClass  ');
		offEnrollist = new list < OfferEnrolWrapper > ();
		System.Debug('In PrepareWrapperClass');
		system.debug('MapAccounts == ' + MapAccounts);
		system.debug('mapSapDetails == ' + mapSapDetails);
		system.debug('offer == ' + offer);
		String mapsapdetailsmdmid;
		Set < String > partyRolesAllowed = new Set < String > ();
		partyRolesAllowed.add('Alliance Partner/OEM');
		partyRolesAllowed.add('Distributor');
		partyRolesAllowed.add('Financial Partner');
		partyRolesAllowed.add('Influencer');
		partyRolesAllowed.add('Internal');
		partyRolesAllowed.add('Reseller');
		partyRolesAllowed.add('Retailer');
		partyRolesAllowed.add('Service Partner');
		System.debug('@@@PartyRolesAllowed' + partyRolesAllowed);

		Set < String > partyRolesSet = new Set < String > ();
		partyRolesSet.add('Reseller');
		partyRolesSet.add('Retailer');
		partyRolesSet.add('Service Partner');
		partyRolesSet.add('Financial Partner');
		partyRolesSet.add('Influencer');
		partyRolesSet.add('Alliance Partner/OEM');
		System.debug('@@@partyRolesSet' + partyRolesSet);

		Set < String > partyRolesSetWithDistributor = new Set < String > ();
		partyRolesSetWithDistributor.add('Reseller');
		partyRolesSetWithDistributor.add('Retailer');
		partyRolesSetWithDistributor.add('Service Partner');
		partyRolesSetWithDistributor.add('Financial Partner');
		partyRolesSetWithDistributor.add('Influencer');
		partyRolesSetWithDistributor.add('Alliance Partner/OEM');
		partyRolesSetWithDistributor.add('Distributor');
		System.debug('@@@partyRolesSetWithDistributor ' + partyRolesSetWithDistributor);
		system.debug('-----4230----------  67 ----inside PrepareWrapperClass  for loop starts');
		for (Account objAccount: MapAccounts.values()) {
			Set < string > mapsapdetailkeyset = mapSapDetails.keySet();
			//for (String mapsapdetailkey: mapsapdetailkeyset) 
			//{
			// 	mapsapdetailsmdmid = mapsapdetailkey.substring(0,mapsapdetailkey.indexOf(','));
			if (mapSapDetails.containsKey(objAccount.MDM_ID__c))
			//if(mapsapdetailsmdmid == objAccount.MDM_ID__c)
			{
				system.debug('MDM ID match');
				system.debug('objAccountmdmID == ' + objAccount.MDM_ID__c);
				//  System.debug('mapsapdetailsmdmid = ' + mapsapdetailsmdmid);
				for (LX_SAP_Record_Sales_Org__c sapRcdLst: mapSapDetails.get(objAccount.MDM_ID__c))
				//for(LX_SAP_Record_Sales_Org__c sapRcdLst : mapSapDetails.get(mapsapdetailkey))
				{
					//LX_SAP_Record_Sales_Org__c sapRcdLst : mapSapDetails.get(mapsapdetailkey)
					System.debug('Inside Lxsaprecordslaesorg forloop');
					Boolean bShowPartyRoles = ((partyRolesSet.contains(sapRcdLst.LX_Sold_To__r.LX_Party_Role__c)) && (partyRolesSet.contains(objAccount.Party_Role__c)) ? true : false);
					System.debug('@@@bShowPartyRoles' + bShowPartyRoles);
					Boolean bShowDistributorPartyRole = ((sapRcdLst.LX_Sold_To__r.LX_Party_Role__c == 'Distributor') && (objAccount.Party_Role__c == 'Distributor') ? true : false);
					System.debug('@@@bShowDistributorPartyRole ' + bShowDistributorPartyRole);
					Boolean bShowOtherPartyRoles = ((partyRolesAllowed.contains(sapRcdLst.LX_Sold_To__r.LX_Party_Role__c)) && !(partyRolesSetWithDistributor.contains(objAccount.Party_Role__c)) ? true : false);
					System.debug('@@@bShowOtherPartyRoles ' + bShowOtherPartyRoles);
					if (bShowPartyRoles || bShowDistributorPartyRole || bShowOtherPartyRoles) {
						System.Debug('objAccount.MDM_ID__c=' + objAccount.MDM_ID__c);
						OfferEnrolWrapper offWrap = new OfferEnrolWrapper();
						offWrap.offerName = offer.Name;
						offWrap.offerId = offer.ID;
						offWrap.prgOfferId = (prgOfferlst != null && prgOfferlst.size() > 0 ? prgOfferlst[0].Id : null);
						//offWrap.ProgName = prgEnrl.Master_Program__r.Name;
						//offWrap.ProgId = prgEnrl.Id;
						offWrap.AccountName = objAccount.Name;
						offWrap.AccountId = objAccount.Id;
						offwrap.AccountownerName = objAccount.owner.name;
						offwrap.companynumber1 = objAccount.Company_Number__c;
						/*    system.debug('objAccount.Party_Role__c == '+objAccount.Party_Role__c);
                                system.debug('objAccount.Party_Type__c == '+objAccount.Party_Type__c);*/
						offWrap.PartyRole = sapRcdLst.LX_Sold_To__r.LX_Party_Role__c;
						offWrap.PartyType = sapRcdLst.LX_Sold_To__r.LX_Party_Type__c;
						offWrap.PhysicalCntry = objAccount.Physical_Country__c;
						offWrap.salesorgname = sapRcdLst.Sales_Org_Name__c;
						offWrap.Region = objAccount.LXK_Region__c;
						offWrap.MPSCapabilityScore = objAccount.Partner_MPS_Capability_Score__c;
						offWrap.PartnerCapabilityScore = objAccount.Partner_ISS_Solutions_Capability_Score__c;
						offWrap.ISSCoverageMethod = objAccount.ISS_Coverage_Method__c;
						offWrap.ISSIntseg = objAccount.Primary_ISS_Internal_Segment__c;
						offWrap.ISSCapSeg = objAccount.Partner_ISS_Capability_Segment__c;
						offWrap.ISSCoverageStatus = objAccount.Coverage_Status__c;
						offWrap.recordTypeName = objAccount.RecordType.Name;
						offWrap.soldTo = sapRcdLst.LX_Sold_To__r.LX_Sold_To_ID__c;
						offWrap.SAPRecord = sapRcdLst.LX_Sold_To__r.Id;
						offWrap.ZIDC = sapRcdLst.LX_Sold_To__r.LX_ZIDC_ID__c;
						offWrap.salesOrg = sapRcdLst.LX_Sales_Org1__c;
						offEnrollist.add(offWrap);

						system.debug('******offEnrollist' + offEnrollist);
					}
				}
			}

			// }        
		}
		system.debug('-----4230----------  67 ----inside PrepareWrapperClass  for loop end');

	}


	public void FirstPage() {
		OffsetSize = 0;
		if (strProgram == 'No Program' || strProgram == null) {
			filterBasedonAccount();
		} else {
			getDynamicProgramEnrollment();
		}
	}
	public void previous() {
		OffsetSize = OffsetSize - LimitSize;
		system.debug('OffsetSize == ' + OffsetSize);
		if (strProgram == 'No Program' || strProgram == null) {
			filterBasedonAccount();
		} else {
			getDynamicProgramEnrollment();
		}
	}

	public void next() {
		OffsetSize = OffsetSize + LimitSize;
		if (strProgram == 'No Program' || strProgram == null) {
			filterBasedonAccount();
		} else {
			getDynamicProgramEnrollment();
		}
	}
	public void LastPage() {
		OffsetSize = totalrecs - LimitSize;
		//isLastPage = true;
		if (strProgram == 'No Program' || strProgram == null) {
			filterBasedonAccount();
		} else {
			getDynamicProgramEnrollment();
		}
	}
	public boolean getprev() {
		if (OffsetSize > 0) return false;
		else return true;
	}
	public boolean getnxt() {
		if (OffsetSize + LimitSize < totalRecs) return false;
		else return true;
	}

	public Integer getTotal_size() {
		return totalRecs;
	}


	public integer getTotalPages() {
		if (math.mod(totalRecs, LimitSize) > 0) {
			return totalRecs / LimitSize + 1;
		} else {
			return (totalRecs / LimitSize);
		}
	}

	public Integer getPageNumber() {
		system.debug('OffsetSize = ' + OffsetSize);
		system.debug('LimitSize = ' + LimitSize);
		system.debug('totalRecs = ' + totalRecs);
		decimal doffSetSize = OffsetSize;
		Decimal divDec = doffSetSize.divide(LimitSize, 0, System.RoundingMode.UP);
		system.debug('divDec = ' + divDec);
		return integer.valueOf(divDec + 1);
	}
	public PageReference userNotAllowedToAdd() {
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You are not allowed to add Offer Enrollments for this Offer. Click Back to go back to the offer.'));
		return null;
	}
}