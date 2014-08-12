/*
Class Name : LX_Offer_Recordtype_Selection_Extension
Description : Extension class for selecting offer Record Types and creating Offer 
Created By : Kapil Sama Reddy (ksama@deloitte.com)
Created Date : 18-Dec-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Kapil Sama Reddy  01-Dec-2013           1000                   Initial Version
Abhishek Kumar    14-Feb-2014                                  Quote Category on VF[populateQuoteCat,Sprint 12]
Abhishek Kumar    24-Feb-2014                                  US3482[Sprint 13] 
*************************************************************************/

public class LX_Offer_Recordtype_Selection_Extension {
        public list<selectOption> targetList = new list<selectOption>();
        public list<selectOption> Questions = new list<selectOption>();    
        public list<selectOption> incentivizersList = new list<selectOption>(); 
        public List<SelectOption> lstOptions{get; set;} // list to capture picklist values for Offer Type
        public boolean showIncentives{get;set;}
        public boolean showOfferDates{get;set;}
        public boolean showTarget{get;set;}
        public boolean showMDF{get;set;}        
        public boolean showlogi{get;set;}    
        public boolean showPriceP{get;set;}
        public boolean showLogs{get;set;} //varible to display Logistics Record Type fields
        public boolean showPrice{get;set;} // varible to display Pricelist Record Type fields
        public boolean showOfferType{get;set;}    
        public boolean showdiscapplied{get;set;}  
        public boolean showMkt{get;set;} // varible to display fields when Marketing Development Fund is selected on VF page
        public boolean showPro{get;set;}  // varible to display Promotion Record Type fields
        public boolean showVir{get;set;} // varible to display VIR Record Type fields
        public boolean showSbc{get;set;} //varible to display Special Bid Channel Record Type fields
        public string offerType{get;set;}
        public string incentivizer {get;set;}
        public string target{get;set;}
        public string isquestion{get;set;}
        public string isquestion2{get;set;}
        public string lX_mDFBudgetAmount,lX_annualPayout;
        public Date dtStartDate{get;set;}
        public Date dtEndDate{get;set;} 
        public LX_Offer__c TempOffer {get;set;}   
        public LX_Offer__c Offer {get;set;} 
          
        /*public String m_salesOrg {get;set;}
        public String m_salesOffice {get;set;}
        public String m_salesGroup {get;set;}
        public String m_salesGEO {get;set;}*/
        public String m_SessionCurrency {get;set;}
        
        /*public List<SelectOption> salesOrgValues {get;set;}
        public List<SelectOption> salesOfficeValues {get;set;}
        public List<SelectOption> salesGroupValues {get;set;}
        public List<SelectOption> salesGEOValues {get;set;}*/
        public List<SelectOption> SessionCurrencyValues {get;set;}
        
        public string m_salesOrgId{get;set;}
        public string m_salesOrgName{get;set;}
        public string m_QueryString{get;set;}
        private final static Set<String> setUSCountries = new Set<String>{'US','United States','USA'};
        
        // contructor
        
        public LX_Offer_Recordtype_Selection_Extension(ApexPages.StandardController controller) {    
            Offer = (LX_Offer__c)controller.getRecord();
            Offer.LX_Offer_Type__c = '';
            Offer.Quote_Type__c = 'Standard';
            lstOptions = new List<Selectoption>();
            TempOffer = new LX_Offer__c();
            Schema.describeFieldResult fr = Schema.LX_Offer__c.LX_Offer_Type__c.getDescribe();
            lstOptions.add(new SelectOption('','--None--'));
            for(Schema.picklistEntry p : fr.getpicklistvalues()){
                if(p.getValue()!='Offer without Dealdesk Quote')
                lstOptions.add(new SelectOption(p.getValue(),p.getLabel())); // stores offer Type picklist values
            }  
            showOfferType = false;   
            showdiscapplied = false;   
            Offer.Product_Line_Series_discount_applied__c = 'No';
        }
        // This method sets attributes based on the values selected in offer Type which is then used to display related fields on VF page
        public void onChangeOfferType()
        {   
            populateQuoteCat();
            showIncentives = false;
            showOfferDates = false;
            showTarget = false;
            showLogs = false;
            showPrice = false;
            showMkt = false;
            showPro = false ;
            showVir = false;
           
            System.debug('-->'+Offer.LX_Offer_Type__c);
            if(Offer.LX_Offer_Type__c == 'Sales Incentives'){
                showIncentives = true;
                target = 'Yes';
                showSbc = false;
                onChangeIncentives();
                
            }
            else if(Offer.LX_Offer_Type__c == 'special Price for a Partner for an un-specified end user'){
                //Amit changed this to False - Shubhashish changed it to false again.
                showOfferDates = false;
                onDateInput();
            }
            else if(Offer.LX_Offer_Type__c == 'Logistics Rebate'){
                showLogs = true;
            }
            else if(Offer.LX_Offer_Type__c == 'Price Protection'){
                showPrice = true;
            }
            else if(Offer.LX_Offer_Type__c == 'Marketing Development Fund'){
                showMkt = true;
            }        
           
            
        }
        
        public void onChangeQuestion(){
        
            if(isquestion == 'No'){
                showOfferType = false; 
                showIncentives = false;
                showTarget = false;
                showOfferDates = false;
                showPrice = false;
                showLogs = false;       
            }
            else 
                showOfferType = true;
        }
        // This method is called on change of "Does this Offer require a quote in Dealdesk?"
          public void onChangeQuestion2(){
            
            if(isquestion2 == 'No'){
                showOfferType = false; 
                showIncentives = false;
                showTarget = false;
                showOfferDates = false;
                showPrice = false;
                showLogs = false;       
            }
            else 
                showOfferType = true;
                populateQuoteCat(); 
        }
        // This method is called on changing Lexmark Incentivizer picklist values
        public void onChangeIncentives()
        {
            showPro   = false;
            showVir   = false;
            incentivizer = 'Company'; 
            if(incentivizer == 'Company')
            {
              showTarget   = true;
               showVir   = true;
            }
            else
                showTarget = false;
                populateQuoteCat();
            
        }
        /* This method is called on change of "Is there a Target defined with a Sales Incentive ?"     
            picklist values to display additional fields 
        */
        public void onChangeTarget()
        {
            
            system.debug('@@@@@Target'+target);    
            if(target== 'Yes')
            {
              showPro   = false;
              showVir   = true;
            }
            else
            {
                showVir = false;
                showPro = true;
            }
            populateQuoteCat();
        }
        
        public void onDateInput()
        {
            if(offer.LX_Start_Date__c != null && offer.LX_End_Date__c != null && offer.LX_Start_Date__c.daysBetween(offer.LX_End_Date__c) > 92)
            {
                showSbc = true;
                showPro = false;
            }
            else if(offer.LX_Start_Date__c != null && offer.LX_End_Date__c != null && offer.LX_Start_Date__c.daysBetween(offer.LX_End_Date__c) <= 92)
            {
                showPro = true;
                showSbc = false;
                
            }
        }
        
       // method to set picklist values for "Is this quote for a specific end user customer?"
        public list<selectOption> getQuestions(){
            list<selectOption> options = new list<selectOption>();
            //options.add(new selectOption('Yes','Yes'));  
            options.add(new selectOption('No','No'));     
            return options;
        }
        
        // method to set picklist values for "Does this Offer require a quote in Dealdesk?"
         public list<selectOption> getQuestions2(){
            list<selectOption> options = new list<selectOption>();
            options.add(new selectOption('No','No'));
            options.add(new selectOption('Yes','Yes'));
            if(isquestion2 == '' || isquestion2 == Null) 
            {        
                isquestion2 = 'No'; 
                populateQuoteCat();
            }    
               
            return options;
            
        }
        // method to set picklist values for "Who is Lexmark Incentivizing ?"
        public list<selectOption> getincentivizersList(){
            list<selectOption> options = new list<selectOption>();
            //options.add(new selectOption('Sales Rep','Sales Rep'));
            options.add(new selectOption('Company','Company'));        
            return options;
        }
        
        public list<selectOption> getTargetList(){
            list<selectOption> options = new list<selectOption>();
            options.add(new selectOption('Yes','Yes'));
            options.add(new selectOption('No','No')); 
            if(target=='' || target==Null)
            { 
                target= 'Yes';
            }
            populateQuoteCat();      
            return options;    
        }
        
        // Method called on click of Continue button.It passes value captured in the VF page to correponding fields on Offer Object
        public pageReference selectRecordType(){
           String strRecordType = '';
           PageReference PageRef = new PageReference ('/a8t/e');
           Map<String,Id> mapRecordType = new Map<String,Id>();
           system.debug('Offer == '+Offer);
           for(Recordtype obj : [select id,name,developername,sobjecttype from recordtype where sobjectType = 'LX_Offer__c'])
           {
                mapRecordType.put(obj.name,obj.Id);
           }
           if(Offer.LX_Quote_Category__c != null && offer.LX_Start_Date__c != null && offer.LX_End_Date__c != null)
           {
            if(Offer.LX_Quote_Category__c == 'Promotion' && offer.LX_Start_Date__c.daysBetween(offer.LX_End_Date__c) > 92)
            {
               pagereference p = apexpages.Currentpage();
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Offer duration should be less than 92 days when the quote category is Promotion');
                ApexPages.addMessage(msg);
               return p; 
                
            }
            }
            
            
            if((Offer.LX_Quote_Category__c == 'Logistics')&&(String.isBlank(Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c) || String.isBlank(Offer.LX_payoutSchedule_quote__c) || String.isBlank(Offer.Is_this_LR_with_target__c)))
            {
            pagereference p = apexpages.Currentpage();
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Additional accelerators Loyalty Etc,Payout Schedule,Is this LR with Target fields should be filled when Quote Category is Logistics');
                ApexPages.addMessage(msg);
               return p; 
            }
                
            if((Offer.LX_Quote_Category__c == 'MDF')&&((String.isBlank(Offer.Product_Line_Series_discount_applied__c)) || (Offer.LX_mDFBudgetAmount_quote__c == null) || String.isBlank(Offer.LX_payoutSchedule_quote__c) || (Offer.LX_annualPayout_quote__c == null)))
            {
            pagereference p = apexpages.Currentpage();
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'MDF Budget Amount for this Payout,Annual Payout Budget,Payout Schedule,Product Line Series Discount Applied? should be filled when Quote Category is MDF');
                ApexPages.addMessage(msg);
               return p; 
            }
            
                        
            if((Offer.LX_Quote_Category__c == 'Promotion' || Offer.LX_Quote_Category__c == 'Special Bid Channel' || Offer.LX_Quote_Category__c == 'Price Protection') && String.isBlank(Offer.Product_Line_Series_discount_applied__c))
            {            
             pagereference p = apexpages.Currentpage();
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Mandatory Field: Product Line, Series discount applied?');
                ApexPages.addMessage(msg);
                 return p; 
            }            

            
           if(isquestion2 == 'Yes' && (Offer.LX_Offer_Type__c == '' || Offer.LX_Offer_Type__c == null))
           {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Select one of the following that best describes what the offer is for');
                ApexPages.addMessage(msg);
                return null;
           }
           else if(isquestion2 == 'No')
           {
                strRecordType = mapRecordType.get('Non-Quote Offer');
                if(Offer.LX_Start_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                }
                if(Offer.LX_End_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                }
           }    
          /* else if(Offer.LX_Offer_Type__c == 'Sales Incentives' && incentivizer == 'Sales Rep')
           {
                strRecordType = mapRecordType.get('Spiff');
                if(Offer.LX_Start_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                }
                if(Offer.LX_End_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                }
           }*/
            else if(Offer.LX_Offer_Type__c == 'Sales Incentives' && incentivizer == 'Company' && target == 'Yes')
            {
                strRecordType = mapRecordType.get('VIR');
                if(Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c == null || Offer.maxPayoutForVIR_Quote__c == null || Offer.revenueBaseForCalculation_quote__c == null || Offer.LX_payoutSchedule_quote__c == null || Offer.targetBasedOn_quote__c == null || Offer.Product_Line_Series_discount_applied__c == null)
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please fill all the values');
                    ApexPages.addMessage(msg);
                    return null;
                }
                else
                {       
                    if(Offer.LX_Start_Date__c != Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                    }
                    if(Offer.LX_End_Date__c != Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                    }
                    PageRef.getParameters().put(System.Label.LX_Additional_accelerators_Loyalty_Etc,Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c);
                    PageRef.getParameters().put(System.Label.LX_Max_Payout_For_VIR,Offer.maxPayoutForVIR_Quote__c);
                  //PageRef.getParameters().put(String.valueOf((Id)(System.Label.LX_Payout_Schedule)),Offer.LX_payoutSchedule_quote__c);                  
                  //PageRef.getParameters().put(System.Label.LX_Payout_Schedule,Offer.LX_payoutSchedule_quote__c);   //Kapil:2/10/2014 to fix the field Id issue               
                    PageRef.getParameters().put(System.Label.LX_Target_Based_On,Offer.targetBasedOn_quote__c);
                    PageRef.getParameters().put(System.Label.LX_Product_Line_Discount_Applied,Offer.Product_Line_Series_discount_applied__c);
                    PageRef.getParameters().put(System.Label.LX_Revenue_Base_for_Calculation,Offer.revenueBaseForCalculation_quote__c);
                    
                    system.debug('-------------------------');
                }
            }
            else if(Offer.LX_Offer_Type__c == 'Sales Incentives' && incentivizer == 'Company' && target == 'No')
            {
                strRecordType = mapRecordType.get('Promotion');
                
                if(Offer.sellInOut_quote__c == null || Offer.daysClaimDueIn_quote__c == null || Offer.promotionDescription_quote__c == null || Offer.promotionsGroups_quote__c == null || Offer.promotionCategory_quote__c == null || Offer.thresh_hold_quote__c == null || Offer.Product_Line_Series_discount_applied__c == null){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please fill all the values');
                    ApexPages.addMessage(msg);
                    return null;
                }
                else{
                    if(Offer.LX_Start_Date__c != Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                    }
                    if(Offer.LX_End_Date__c != Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                    }
                    PageRef.getParameters().put(System.Label.LX_ValidateSerialNos,Offer.ValidateSerialNos_quote__c);
                    PageRef.getParameters().put(System.Label.LX_sellInOut_quote,Offer.sellInOut_quote__c);
                    PageRef.getParameters().put(System.Label.LX_Days_Claim_Due_In,Offer.daysClaimDueIn_quote__c);
                    PageRef.getParameters().put(System.Label.LX_promotionDescription_quote,Offer.promotionDescription_quote__c);
                    PageRef.getParameters().put(System.Label.LX_promotionsGroups_quote,Offer.promotionsGroups_quote__c);
                    PageRef.getParameters().put(System.Label.LX_promotionCategory_quote,Offer.promotionCategory_quote__c);
                    PageRef.getParameters().put(System.Label.LX_thresh_hold_quote,Offer.thresh_hold_quote__c);
                    PageRef.getParameters().put(System.Label.LX_Hardware_Threshold,Offer.Hardware_Threshold__c.format());
                    PageRef.getParameters().put(System.Label.LX_Supplies_Threshold,Offer.Supplies_Threshold__c.format());
                    PageRef.getParameters().put(System.Label.LX_Product_Line_Discount_Applied,Offer.Product_Line_Series_discount_applied__c);
                    
                    system.debug('-------------------------');
                
                }
            }
            

            else if(Offer.LX_Offer_Type__c == 'special Price for a Partner for an un-specified end user' && (offer.LX_Start_Date__c == null && offer.LX_End_Date__c == null))
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please fill Start and End dates.');
                ApexPages.addMessage(msg);
                return null;
            }
               
            
            else if(Offer.LX_Offer_Type__c == 'special Price for a Partner for an un-specified end user' && (offer.LX_Start_Date__c!= null && offer.LX_End_Date__c != null && offer.LX_Start_Date__c.daysBetween(offer.LX_End_Date__c) > 92))
            {
                strRecordType = mapRecordType.get('Special Bid Channel');
                if(offer.LX_Start_Date__c >= offer.LX_End_Date__c){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'End Date should be greater than Start Date');
                    ApexPages.addMessage(msg);
                    return null;
                }
                else{
                    PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,offer.LX_Start_Date__c.format());
                    PageRef.getParameters().put(System.Label.LX_Offer_End_Date,offer.LX_End_Date__c.format());
                    PageRef.getParameters().put(System.Label.LX_ValidateSerialNos,offer.ValidateSerialNos_quote__c);
                    PageRef.getParameters().put(System.Label.LX_sellInOut_quote,Offer.sellInOut_quote__c);
                    PageRef.getParameters().put(System.Label.LX_DoesThisQuoteRequireAnSPR_quote,Offer.doesThisQuoteRequireAnSPR_quote__c);
                    PageRef.getParameters().put(System.Label.LX_Days_Claim_Due_In,Offer.daysClaimDueIn_quote__c);
                    PageRef.getParameters().put(System.Label.LX_thresh_hold_quote,Offer.thresh_hold_quote__c);
                  //PageRef.getParameters().put(System.Label.LX_Offer_Status,TempOffer.LX_Offer_Status__c.format());
                  
                  system.debug('-------------------------');
                    
                }
            }
            else if(Offer.LX_Offer_Type__c == 'special Price for a Partner for an un-specified end user' && (offer.LX_Start_Date__c != null && offer.LX_End_Date__c != null && offer.LX_Start_Date__c.daysBetween(offer.LX_End_Date__c) <= 92))
            {
                strRecordType = mapRecordType.get('Promotion');
                if(Offer.LX_Start_Date__c >= offer.LX_End_Date__c){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'End Date should be greater than Start Date');
                    ApexPages.addMessage(msg);
                    return null;
                }
                else{
                    PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,offer.LX_Start_Date__c.format());
                    PageRef.getParameters().put(System.Label.LX_Offer_End_Date,offer.LX_End_Date__c.format());
                    PageRef.getParameters().put(System.Label.LX_ValidateSerialNos,Offer.ValidateSerialNos_quote__c);
                    PageRef.getParameters().put(System.Label.LX_sellInOut_quote,Offer.sellInOut_quote__c);
                    PageRef.getParameters().put(System.Label.LX_Days_Claim_Due_In,Offer.daysClaimDueIn_quote__c);
                    PageRef.getParameters().put(System.Label.LX_promotionDescription_quote,Offer.promotionDescription_quote__c);
                    PageRef.getParameters().put(System.Label.LX_promotionsGroups_quote,Offer.promotionsGroups_quote__c);
                    PageRef.getParameters().put(System.Label.LX_promotionCategory_quote,Offer.promotionCategory_quote__c);
                    PageRef.getParameters().put(System.Label.LX_thresh_hold_quote,Offer.thresh_hold_quote__c);
                    PageRef.getParameters().put(System.Label.LX_Product_Line_Discount_Applied,Offer.Product_Line_Series_discount_applied__c);
                    
                    system.debug('-------------------------');
                }
                
            }
            else if(Offer.LX_Offer_Type__c == 'Logistics Rebate')
            {
                strRecordType = mapRecordType.get('Logistics');
                if(Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c == null || Offer.lRPurpose__c == null || Offer.maxPayoutForVIR_Quote__c == null || Offer.revenueBaseForCalculation_quote__c == null || Offer.targetBasedOn_quote__c ==null || Offer.Product_Line_Series_discount_applied__c == null){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please fill all the values');
                    ApexPages.addMessage(msg);
                    return null;
                }
                else{
                    if(Offer.LX_Start_Date__c!=Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                    }
                    if(Offer.LX_End_Date__c!=Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                    }
                    PageRef.getParameters().put(System.Label.LX_Additional_accelerators_Loyalty_Etc,Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c);
                    PageRef.getParameters().put(System.Label.LX_LR_Purpose,Offer.lRPurpose__c);
                    PageRef.getParameters().put(System.Label.LX_Max_Payout_For_VIR,Offer.maxPayoutForVIR_Quote__c);
                    PageRef.getParameters().put(System.Label.LX_Revenue_Base_for_Calculation,Offer.revenueBaseForCalculation_quote__c);
                    PageRef.getParameters().put(System.Label.LX_Target_Based_On,Offer.targetBasedOn_quote__c);
                    PageRef.getParameters().put(System.Label.LX_Product_Line_Discount_Applied,Offer.Product_Line_Series_discount_applied__c);
                    PageRef.getParameters().put(System.Label.Is_this_LR_with_target,Offer.Is_this_LR_with_target__c);                    
                    
                    system.debug('-------------------------');
                
                }
            }
            
            else if(Offer.LX_Offer_Type__c == 'Price Protection')
            {
                strRecordType = mapRecordType.get('Price Protection');
                if(Offer.daysClaimDueIn_quote__c == null){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please fill all the values');
                    ApexPages.addMessage(msg);
                    return null;
                }else{
                    PageRef.getParameters().put(System.Label.LX_Days_Claim_Due_In,Offer.daysClaimDueIn_quote__c);
                    if(Offer.LX_Start_Date__c!=Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                    }
                    if(Offer.LX_End_Date__c!=Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                    }
                }
            }
            else if(Offer.LX_Offer_Type__c == 'Marketing Development Fund')
            {
            
                strRecordType = mapRecordType.get('MDF');
                if(Offer.LX_mDFBudgetAmount_quote__c == null || Offer.LX_annualPayout_quote__c==null || offer.LX_payoutSchedule_quote__c==null){
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please fill all the values');
                    ApexPages.addMessage(msg);
                    return null;
                }else{
                    if(Offer.LX_mDFBudgetAmount_quote__c!=null)
                    {
                        lX_mDFBudgetAmount=String.valueOf(Offer.LX_mDFBudgetAmount_quote__c); 
                        PageRef.getParameters().put(System.Label.LX_MDF_Budget_Amount_for_this_Payout,lX_mDFBudgetAmount);                  
                    }
                    if(Offer.LX_annualPayout_quote__c!=null)
                    {
                        lX_annualPayout = String.valueOf(Offer.LX_annualPayout_quote__c);
                        PageRef.getParameters().put(System.Label.LX_Annual_Payout_Budget,lX_annualPayout);
                    }  
                    
                    //PageRef.getParameters().put(String.valueOf((Id)(Label.LX_Payout_Schedule)),Offer.LX_payoutSchedule_quote__c); 
                    //PageRef.getParameters().put(System.Label.LX_Payout_Schedule,Offer.LX_payoutSchedule_quote__c);//Kapil:2/10/2014 to fix the field Id issue
                    if(Offer.LX_Start_Date__c!=Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                    }
                    if(Offer.LX_End_Date__c!=Null)
                    {
                        PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                    }
                }
            } 
            else if(Offer.LX_Offer_Type__c == 'Offer without Dealdesk Quote')
            {
                strRecordType = mapRecordType.get('Non-Quote Offer');
                if(Offer.LX_Start_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                }
                if(Offer.LX_End_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                }
            }
            else if(Offer.LX_Offer_Type__c == 'Pricelist Offer')
            {
                strRecordType = mapRecordType.get('Pricelist Offer');
                if(Offer.LX_Start_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                }
                if(Offer.LX_End_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                }
            }
            //US4089
             else if(Offer.LX_Offer_Type__c == 'Software Pricebook')
            {
                strRecordType = mapRecordType.get('Software Pricebook');
                if(Offer.LX_Start_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_Start_Date,Offer.LX_Start_Date__c.format());
                }
                if(Offer.LX_End_Date__c!=Null)
                {
                    PageRef.getParameters().put(System.Label.LX_Offer_End_Date,Offer.LX_End_Date__c.format());
                }
            }
            //US4089
            system.debug('Offer.salesRegion_quote__c == '+offer.salesRegion_quote__c);
            if(offer.salesRegion_quote__c != null)
            {
                system.debug('In Loop 1== '+System.Label.Lx_Offer_Sales_Org_ID);
                system.debug('In Loop 2== '+m_salesOrgId);
                PageRef.getParameters().put(System.Label.Lx_Offer_Sales_Org_ID, m_salesOrgId); 
                PageRef.getParameters().put(System.Label.Lx_Offer_Sales_Org_Name, m_salesOrgName);
            }
            system.debug('Page Ref == '+PageRef);
            if(m_SessionCurrency != null)
            {
                
                    PageRef.getParameters().put(System.Label.Lx_Offer_Sales_Org_Currency, m_SessionCurrency); 
            }
            if(offer.salesRegion_quote__c==null)
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Fatal,'Please select Sales Region');
                    ApexPages.addMessage(msg);
                    return null;
            }           
            PageRef.getParameters().put('RecordType',strRecordType);
            PageRef.getParameters().put(System.label.LX_Offer_Type_Id,Offer.LX_Offer_Type__c);
            PageRef.getParameters().put('retURL','a8t/o');
            PageRef.getParameters().put('nooverride', '1'); 
            if(Offer.Name != null){
                PageRef.getParameters().put('Name',Offer.Name);
            }
            if(Offer.Quote_Type__c != null){
                PageRef.getParameters().put(System.Label.LX_Quote_Type,Offer.Quote_Type__c);
            }
            PageRef.getParameters().put(System.Label.LX_Offer_Status,Offer.LX_Offer_Status__c);
            if(Offer.LX_Description__c != null){
                PageRef.getParameters().put(System.Label.LX_Offer_Description,Offer.LX_Description__c);  
            }           
            //PageRef.getParameters().put(System.Label.LX_salesRegion_quote,offer.salesRegion_quote__c);
            //PageRef.getParameters().put(String.valueOf((Id)(System.Label.LX_salesRegion_quote)),offer.salesRegion_quote__c);                         
            /*PageRef.getParameters().put(System.Label.LX_salesOrg_quote,offer.salesOrg_quote__c);
            PageRef.getParameters().put(System.Label.LX_salesOffice_quote,offer.salesOffice_quote__c);
            PageRef.getParameters().put(System.Label.LX_salesGroup_quote,offer.salesGroup_quote__c);
            PageRef.getParameters().put(System.Label.LX_salesGeo_quote,offer.salesGeo_quote__c);
            PageRef.getParameters().put(System.Label.LX_sessionCurrency_quote,offer.sessionCurrency_quote__c);
            
            PageRef.getParameters().put(System.Label.LX_salesOrg_quote,m_salesOrg);
            PageRef.getParameters().put(System.Label.LX_salesOffice_quote,m_salesOffice);
            PageRef.getParameters().put(System.Label.LX_salesGroup_quote,m_salesGroup);
            PageRef.getParameters().put(System.Label.LX_salesGeo_quote,m_salesGEO);
            PageRef.getParameters().put(System.Label.LX_sessionCurrency_quote,m_SessionCurrency);*/
            PageRef.getParameters().put(System.label.LX_Offer_Type_Field_ID,Offer.LX_Offer_Type__c);
            
            system.debug('pageRef-->'+pageRef);
            prepareQueryString(pageRef);
            return null;
            //return PageRef;
            
        }
        
        public void prepareQueryString(PageReference objPagRef)
        {
            String strReturnUrl = '';
            string strEditMode = 'e?';
            String strDelimiter = '/';
            /* String strBaseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            strBaseUrl = strBaseUrl.replace('visual.force','my.salesforce').replace('--c','');
            */
            //Kapil(2/12/2014) : Fixed server url issue on VF page
            string strBaseUrl = System.label.LX_Domain_name;
            Schema.DescribeSObjectResult r = Lx_Offer__c.sObjectType.getDescribe();
            String strKeyPrefix = r.getKeyPrefix();
            strReturnUrl = strBaseUrl + strDelimiter +strKeyPrefix + strDelimiter + strEditMode;
            String strParam = null;
            for(String str : objPagRef.getParameters().keySet())
            {
                strParam = objPagRef.getParameters().get(str);
                strReturnUrl += str+'='+(strParam != null ? EncodingUtil.urlEncode(strParam, 'ASCII'): strParam);
                strReturnUrl += '&';
            }
            strReturnUrl += System.Label.LX_salesRegion_quote+'='+offer.salesRegion_quote__c +'&';
            if(offer.LX_payoutSchedule_quote__c != null){
                strReturnUrl += System.Label.LX_Payout_Schedule+'='+offer.LX_payoutSchedule_quote__c;
            }
            //strReturnUrl +='00Ni000000CPDRF=Payout&00Ni000000CPDRf=SalesRegion';
            system.debug('Ret Url= '+strReturnUrl); 
            m_QueryString = strReturnUrl;
            //return strReturnUrl;
            
        }
        /* This method is called on selection of Sales Region values on Offer RecordType Selection VF page and populates Quote 
          Currency from sales Organisation object based on Sales Region selected  */
        public pageReference getSalesOrgSelectOptions()
        {
            /*salesOrgValues = new List<SelectOption>();
            salesOfficeValues = new List<SelectOption>();
            salesGroupValues = new List<SelectOption>();
            salesGEOValues = new List<SelectOption>();*/
            SessionCurrencyValues = new List<SelectOption>();
            
            system.debug('Offer.salesRegion_quote__c == '+offer.salesRegion_quote__c);
            List<Sales_Organization__c> lstSalesOrg = null;
            //If selected country is "US" then we have to select sales org record which has Sales Org value as "5050"
            if(setUSCountries.contains(Offer.salesRegion_quote__c))
            {
                lstSalesOrg = [select id,LX_IsDefault__c,Name from Sales_Organization__c
                                                where Name =: Offer.salesRegion_quote__c and LX_IsDefault__c =: true and Sales_Organization__c =: Label.lx_Sales_Org];
            }
            else
            {
                lstSalesOrg = [select id,LX_IsDefault__c,Name from Sales_Organization__c
                                                where Name =: Offer.salesRegion_quote__c and LX_IsDefault__c =: true];
            }
            
             
              //system.debug('LX_IsDefault__c== '+LX_IsDefault__c);                                                
                system.debug('lstSalesOrg=='+ lstSalesOrg);
                
                Sales_Organization__c objSalesOrg = ((lstSalesOrg == null || lstSalesOrg.size() <= 0) ? null : lstSalesOrg[0]);
                system.debug('objSalesOrg == '+objSalesOrg);                        
                if(objSalesOrg != null)
                {
                    m_salesOrgId = objSalesOrg.id; 
                    m_salesOrgName = objSalesOrg.Name;
                   
                    for(Sales_Org_Currency__c obj : [select id,name,Currency_Name__r.Name from Sales_Org_Currency__c where Sales_Organization__c =: objSalesOrg.Id])
                    {
                         system.debug('obj == '+obj);
                        if(m_SessionCurrency == null) m_SessionCurrency = obj.Currency_Name__r.Name;
                        SessionCurrencyValues.add(new Selectoption(obj.Currency_Name__r.Name,obj.Currency_Name__r.Name));
                    }
                     system.debug('SessionCurrencyValues == '+SessionCurrencyValues);
                }
                
                //else {
                //Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Unexpected error has occured. Please try again later.'));
                //}
            
                
                
                
            return null;
        
        }
        
        // function to populate Quote Category on VF page [Sprint 12]
        public void populateQuoteCat()
        {
            
            Offer.LX_Quote_Category__c = '';
            
           
            system.debug('Offer == '+Offer);
             system.debug('++++isquestion2== '+isquestion2);
           
            if(isquestion2 != 'Yes')
            {
                Offer.LX_Quote_Category__c = 'Non-Quote Offer';  
                showdiscapplied = False; 
                showlogi = False;
                showPriceP = False;   
            }
            else if(Offer.LX_Offer_Type__c == 'Price Protection')   
            {
                Offer.LX_Quote_Category__c = 'Price Protection';  
                Offer.daysClaimDueIn_quote__c = '180';
                if(Offer.Product_Line_Series_discount_applied__c == '')
                {
                Offer.Product_Line_Series_discount_applied__c = 'No';
                }
                showdiscapplied = False; 
                showPriceP = True;
                showlogi = False;
            }  
            else if(Offer.LX_Offer_Type__c == 'Logistics Rebate')   
            {
               showlogi = True;
                Offer.LX_Quote_Category__c = 'Logistics';  
                if(String.isBlank(Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c))
                    {
                    Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c = 'No';
                    }  
                    if(String.isBlank(Offer.maxPayoutForVIR_Quote__c))
                    {
                Offer.maxPayoutForVIR_Quote__c = '';
                    }
                if(String.isBlank(Offer.revenueBaseForCalculation_quote__c))
                    {
                Offer.revenueBaseForCalculation_quote__c = '';    
                    }
                    if(String.isBlank(Offer.LX_payoutSchedule_quote__c))
                    {
                Offer.LX_payoutSchedule_quote__c = '';
                }
                if(String.isBlank(Offer.Is_this_LR_with_target__c))
                {
                Offer.Is_this_LR_with_target__c = 'No';
                }
                
                showdiscapplied = False; 
                showPriceP = False;
            } 
            else if(Offer.LX_Offer_Type__c == 'Marketing Development Fund')   
            {
                Offer.LX_Quote_Category__c = 'MDF'; 
                if(Offer.Product_Line_Series_discount_applied__c == '')
                {
                Offer.Product_Line_Series_discount_applied__c = 'No';
                }         
                Offer.LX_mDFBudgetAmount_quote__c = null;
                if(String.isBlank(Offer.LX_payoutSchedule_quote__c))
                    {
                Offer.LX_payoutSchedule_quote__c = '';
                    }
                Offer.LX_annualPayout_quote__c = null;
                showMDF = True;           
                showdiscapplied = False; 
                showlogi = False;
                showPriceP = False;  
                              
            }
            else if(Offer.LX_Offer_Type__c == 'Sales Incentives')   
            {

                if(target == 'Yes')
                {
                    Offer.LX_Quote_Category__c = 'VIR';
                    if(String.isBlank(Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c))
                    {
                    Offer.AdditionalAcceleratorsLoyaltyEtc_Quote__c = 'No';
                    }
                    if(String.isBlank(Offer.revenueBaseForCalculation_quote__c))
                    {
                    Offer.revenueBaseForCalculation_quote__c = '';
                    }
                    showdiscapplied = False; 
                    showlogi = False;
                showPriceP = False;                    
                }
                else if(target == 'No')
                {
                    Offer.LX_Quote_Category__c = 'Promotion';    
                    if(Offer.Product_Line_Series_discount_applied__c == '')
                    {
                    Offer.Product_Line_Series_discount_applied__c = 'No';
                    }
                    if(String.isBlank(offer.ValidateSerialNos_quote__c))
                    {
                    offer.ValidateSerialNos_quote__c = 'No';
                    }
                    showdiscapplied = True;     
                    Offer.thresh_hold_quote__c = '10';
                    Offer.Supplies_Threshold__c = 10;
                    Offer.Hardware_Threshold__c = 25; 
                    Offer.daysClaimDueIn_quote__c = '180';              
                    showlogi = False;
                    showPriceP = False;  
                    showMDF = False;                  
                }

            }
            else if((Offer.LX_Offer_Type__c == 'special Price for a Partner for an un-specified end user')&&(offer.LX_Start_Date__c!= null && offer.LX_End_Date__c != null))   
            {
                if(offer.LX_Start_Date__c.daysBetween(offer.LX_End_Date__c) > 92)
                {
                    Offer.LX_Quote_Category__c = 'Special Bid Channel';
                    showSbc = true;
                    showPro = false;
                    showdiscapplied = True;
                    showlogi = False;
                    showPriceP = False;                    
                    if(String.isBlank(offer.ValidateSerialNos_quote__c))
                    {
                    offer.ValidateSerialNos_quote__c = 'No';
                    }
                    if(String.isBlank(Offer.Product_Line_Series_discount_applied__c))
                    {
                    Offer.Product_Line_Series_discount_applied__c = 'No';
                    }
                    if(String.isBlank(Offer.sellInOut_quote__c))
                    {
                    offer.sellInOut_quote__c = '';
                    }
                    Offer.daysClaimDueIn_quote__c = '180';
                    Offer.thresh_hold_quote__c = '10';
                    Offer.Supplies_Threshold__c = 10;
                    Offer.Hardware_Threshold__c = 25; 
                    if(String.isBlank(Offer.doesThisQuoteRequireAnSPR_quote__c))
                    {
                    Offer.doesThisQuoteRequireAnSPR_quote__c = 'No';
                    }
                }
                else
                {
                    Offer.LX_Quote_Category__c = 'Promotion';
                    showSbc = false;
                    showPro = true;
                    showlogi = False;
                    showPriceP = False;     
                    showMDF = False;               
                    if(String.isBlank(offer.ValidateSerialNos_quote__c))
                    {
                    offer.ValidateSerialNos_quote__c = 'No';
                    }
                    if(Offer.sellInOut_quote__c == '')
                    {
                    offer.sellInOut_quote__c = '';
                    }
                    Offer.daysClaimDueIn_quote__c = '180';
                    Offer.thresh_hold_quote__c = '10';
                    Offer.Product_Line_Series_discount_applied__c = 'No';
                    showdiscapplied = True;                     
                    Offer.Supplies_Threshold__c = 10;
                    Offer.Hardware_Threshold__c = 25; 
                   
                }
                
            }
             else if(Offer.LX_Offer_Type__c == 'Pricelist Offer')   
            {
                Offer.LX_Quote_Category__c = 'Pricelist Offer'; 
                showdiscapplied = False;
                showlogi = False;
                showPriceP = False;                
            }
              else if(Offer.LX_Offer_Type__c == 'Software Pricebook')   
            {
                Offer.LX_Quote_Category__c = 'Non-Quote Offer'; 
                showdiscapplied = False;
                showlogi = False;
                showPriceP = False;                
            }
            
        }
        
    }