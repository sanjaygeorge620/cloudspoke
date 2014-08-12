public class LX_Program_offers_contr 
{
    private String retURL;
    public List < LX_Partner_Program__c > PartnerProgram {get;set;}
    public List < WrapperOffer > OfferWrapperList {get;set;}
    public boolean ActiveProgram {get;set;}
    public string strFilter1 {get;set;}    
    public string strFilter {get;set;}
    public string strFilterPage {get;set;}
    public boolean noOfferRenderFlag {get;set;}     
    public boolean prev {get;set;}
    public boolean nxt {get;set;}
    public List < LX_Offer__c > OfferList;

    private boolean isLastPage = false;
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize = (Integer.valueOf(Label.LX_Page_Limit) > 500 ? 500 : Integer.valueOf(Label.LX_Page_Limit));

       // US3598 *****Changes Starts here - 06/26/2014
    public String offerNameSearchString {get;set;}
    public String quoteNumberSearchString {get;set;}
    public String selectedOfferStatus {get;set;}
    public String selectedQuoteCategory {get;set;}
    private final integer listLimit = 999;
       // US3598 *****Changes Starts here - 06/26/2014

    public LX_Program_offers_contr() 
    {
           
           OfferList = new List <LX_Offer__c>();
            updateOfferList3();  //created new function for the code inside this for US3598
    }
    
   
    public void updateOfferList3()
    {        
        list < string > recordTypeIds = new list < string > ();
        recordTypeIds.add('\'' + LX_SetRecordIDs.logisticsOfferId + '\'');
        recordTypeIds.add('\'' + LX_SetRecordIDs.promotionOfferId + '\'');
        recordTypeIds.add('\'' + LX_SetRecordIDs.sbcOfferId + '\'');
        recordTypeIds.add('\'' + LX_SetRecordIDs.priceProtectionOfferId + '\'');
        recordTypeIds.add('\'' + LX_SetRecordIDs.nonQuoteOfferId + '\'');
        recordTypeIds.add('\'' + LX_SetRecordIDs.pricelistOfferId + '\'');
        recordTypeIds.add('\'' + LX_SetRecordIDs.VIRRecordtypeID + '\'');
        recordTypeIds.add('\'' + LX_SetRecordIDs.SpiffRecordtypeID + '\'');
        recordTypeIds.add('\'' + LX_SetRecordIDs.MDFrecordtypeId + '\'');
        strFilter1 = ' Where';
        ActiveProgram = false;
        strFilterPage = ' ';       
        noOfferRenderFlag = false;
        retURL = ApexPages.currentPage().getParameters().get('returl');
        prev = true;
        nxt = true;        
        totalRecs = 0;
        OffsetSize = 0;
        
        String PPid = ApexPages.currentPage().getParameters().get('ProgramID');
        if (PPid != '' && PPid != null) 
        {
            set < id > offersToIgnore = new set < id > ();
            list < LX_Program_offer__c > programOffersList = new list < LX_program_offer__c > ([Select id, LX_Offer__c, LX_Partner_Program__c from LX_program_offer__c where LX_Partner_Program__c != null and recordtype.Name = 'Program Offers']);
            for (LX_Program_offer__c prgOffer: programOffersList) {
                offersToIgnore.add(prgOffer.LX_Offer__c);
            }

            system.debug('offersToIgnore-->' + offersToIgnore);
            PartnerProgram = [select id, Program_Status__c, LX_Start_Date__c, Program_End_Date__c, LX_Country__c, LX_Region__c from LX_Partner_Program__c where id = : PPid limit 1];
            system.debug('------Partner Program' + PartnerProgram);
            //Amit changed the ActiveProgram to false to allow users to add offers to active programs
            if (PartnerProgram[0].Program_Status__c == 'Active') {
                ActiveProgram = false;
            }
            String strCountry = null;
            if (PartnerProgram[0].LX_Country__c != null) {
                //Get Transformed country Name from custom settings     
                strCountry = (LX_Country_Mappings__c.getAll().get(PartnerProgram[0].LX_Country__c) != null ? LX_Country_Mappings__c.getAll().get(PartnerProgram[0].LX_Country__c).LX_Mapped_Country__c : PartnerProgram[0].LX_Country__c);
            }
            if (strCountry != null && strCountry != '') {
                strFilter1 += ' AND salesRegion_quote__c = \'' + strCountry + '\'';
            }

            /*if(PartnerProgram[0].LX_Start_Date__c != null &&  PartnerProgram[0].Program_End_Date__c != null){ 
                datetime tempdate = partnerProgram[0].LX_Start_Date__c;              
                strFilter1 += ' AND LX_Start_date__c >='+tempdate.format('yyyy-MM-dd');   
                tempdate = partnerProgram[0].program_end_date__c;               
                strFilter1 += ' AND LX_END_Date__c <='+tempdate.format('yyyy-MM-dd');
            }*/
            //Kapil(2/6/2014): fixed the date issue in SOQL.
            if (PartnerProgram[0].LX_Start_Date__c != null && PartnerProgram[0].Program_End_Date__c != null) {
                strFilter1 += ' AND LX_Start_date__c >=' + DateTime.newInstance(PartnerProgram[0].LX_Start_Date__c, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd');
                strFilter1 += ' AND LX_END_Date__c <=' + DateTime.newInstance(PartnerProgram[0].program_end_date__c, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd');
            }

            //strFilter1 += ' AND LX_No_Of_Program_Offers__c = 0';  //Its commented for US3900
            strFilter1 += ' AND recordtypeId in ' + recordTypeIds;
            strFilter1 = strFilter1.replace('Where AND', 'Where');
            
            totalRecs = Database.countQuery('select count() from LX_Offer__c ' + strFilter1);

            System.debug('strFilter1 @@@0' + strFilter1);
            if (totalRecs == 0) 
            {
                noOfferRenderFlag = true;
            }
      /*      if (totalRecs <= Integer.valueOf(Label.LX_Page_Limit)) 
            {
                prev = true;
                nxt = true;
            }   */
            if (totalRecs > 0) 
            {
                getDynamicOfferList();
            }
        }
    }
        
        
      // US3598 *****Changes Starts here - 06/26/2014
    public List < SelectOption > getQuoteCategoryOptions() {
        List < SelectOption > quoteCategoryOptions = new List < SelectOption > ();
        quoteCategoryOptions.add(new SelectOption('', '-None-'));
        
        quoteCategoryOptions.add(new SelectOption('Logistics', 'Logistics'));
        quoteCategoryOptions.add(new SelectOption('MDF', 'MDF'));
        quoteCategoryOptions.add(new SelectOption('Non-Quote Offer', 'Non-Quote Offer'));        
        quoteCategoryOptions.add(new SelectOption('Price Protection', 'Price Protection'));
        quoteCategoryOptions.add(new SelectOption('Pricelist Offer', 'Pricelist Offer'));
        quoteCategoryOptions.add(new SelectOption('Promotion', 'Promotion'));     
        quoteCategoryOptions.add(new SelectOption('Software Pricebook', 'Software Pricebook')); // us4237 - new dropdown added
        quoteCategoryOptions.add(new SelectOption('Special Bid Channel', 'Special Bid Channel'));
//      quoteCategoryOptions.add(new SelectOption('Spiff', 'Spiff'));
        quoteCategoryOptions.add(new SelectOption('VIR', 'VIR'));
        
        return quoteCategoryOptions;
    }

        public List < SelectOption > getOfferStatusOptions() {
        List < SelectOption > offerStatusOptions = new List < SelectOption > ();
        offerStatusOptions.add(new SelectOption('', '-None-'));
        offerStatusOptions.add(new SelectOption('Active', 'Active'));
        offerStatusOptions.add(new SelectOption('Draft', 'Draft'));

            
        return offerStatusOptions;
    }

    // US3598 *****Changes Ends here - 06/26/2014
    public void getDynamicOfferList() 
    {
        strFilter = '';
        strFilterPage = '';
        System.debug('@@@1 In DynamicMethod' + LimitSize);
        System.debug('@@@2 In DynamicMethod' + OffsetSize);
        
        if (isLastPage) 
        {
            OffsetSize = totalRecs - LimitSize;
        }
        
        strFilterPage += ' order by Name';
        strFilterPage += ' LIMIT :LimitSize OFFSET :OffsetSize';

        
        // US3598 *****Changes Starts here - 06/26/2014
        list < string > offerStatusList = new list < string > ();
        offerStatusList.add('\'' + 'Draft' + '\'');
        offerStatusList.add('\'' + 'Active' + '\'');
        

                //OfferList = Database.query(Query); 
        if (string.isNotBlank(offerNameSearchString)) 
        {
            System.debug('Query >>>>>>>>>>>>inside offer name>>>>>>>>>>>>>-->' + offerNameSearchString);
            strFilter += 'and (name like \'%' + offerNameSearchString + '%\') ';
        }

        if (string.isNotBlank(quoteNumberSearchString)) 
        {
            System.debug('Query >>>>>>>>>>>>inside quoteNumber >>>>>>>>>>>>>-->' + quoteNumberSearchString);
            strFilter += 'and (LX_Quote_ID__c like \'%' + quoteNumberSearchString + '%\') ';
        }
        if (string.isNotBlank(selectedOfferStatus)) 
        {
            System.debug('Query >>>>>>>>>>>>inside offerStatus >>>>>>>>>>>>>-->' + selectedOfferStatus);
            strFilter += 'and (LX_Offer_Status__c like \'%' + selectedOfferStatus + '%\')';
        }
        else if (string.isBlank(selectedOfferStatus))
        {
        strFilter += 'and LX_Offer_Status__c in ' + offerStatusList;
        }
        if (string.isNotBlank(selectedQuoteCategory)) 
        {
            System.debug('Query >>>>>>>>>>>>inside selectedQuoteCategory >>>>>>>>>>>>>-->' + selectedQuoteCategory);
            strFilter += 'and (LX_Quote_Category__c like \'%' + selectedQuoteCategory + '%\')';
        }
        
        string strfinal = strFilter1 + strFilter;
        
        strfinal = strfinal.replace('Where AND', 'Where');
        // US3598 *****Changes ends here - 06/26/2014
        
        string query = 'Select id,LX_country__c,LX_Description__c,LX_End_date__c,LX_Geo__c,LX_Offer_id__c,LX_Offer_Level__c,LX_Offer_Status__c,lX_Parent_offer__C,LX_Quote_id__c,LX_Region__c,LX_Start_date__c,name,RecordtypeId,LX_Quote_Category__c,Lx_Program__c From LX_Offer__c  ' + strfinal + strFilterPage;        
        totalRecs = Database.countQuery('select count() from LX_Offer__c ' + strfinal);       
        if (totalRecs > Integer.valueOf(Label.LX_Page_Limit)) 
            {
                prev = false;
                nxt = false;
            }
        System.debug('Query --> @@@3' + Query);
        OfferList = new List <LX_Offer__c>();
        OfferList = Database.query(Query);        
        System.debug('OfferList###############size --> @@@3' + OfferList.size()); 
        
        //Changes added for US3900
        Map<id,LX_Program_offer__c> offersToIgnoreMap = new Map<id,LX_Program_offer__c>();
        list < LX_Program_offer__c > lstProgOffers = new list < LX_program_offer__c > ([Select id, LX_Offer__c, LX_Partner_Program__c from LX_program_offer__c where LX_Partner_Program__c =: ApexPages.currentPage().getParameters().get('ProgramID') and recordtype.Name = 'Program Offers']);
        for (LX_Program_offer__c prgOffer: lstProgOffers) {
                offersToIgnoreMap.put(prgOffer.LX_Offer__c,prgOffer);
        }       
        //Changes ended for US3900
        
        
        OfferWrapperList = new List <WrapperOffer>();  
        if (OfferList.size() > 0) 
        {
        integer rowcount = OffsetSize+1;          
            for (LX_Offer__c off: OfferList) 
            {     
                if(offersToIgnoreMap.containskey(off.id)) //This condition added for US3900  
                {}
                else
                { 
                    OfferWrapperList.add(new WrapperOffer(rowcount,off, false));
                    rowcount++;
                }   
            }
        }
    }

    public PageReference cancel() {
        PageReference pg = new PageReference('/' + retURL);
        return pg;
    }

    public PageReference Save() 
    {
    ApexPages.getMessages().clear();
        try {
            List < LX_Program_Offer__c > SaveList = new List < LX_Program_Offer__c > ();
            for (WrapperOffer wo: OfferWrapperList) {
                if (wo.chk == true) SaveList.add(new LX_Program_Offer__c(LX_Offer__c = wo.Offer.id, LX_Partner_Program__c = retURL, Recordtypeid = LX_setRecordIDs.ProgramOffersid));
            }
            insert SaveList;
        } catch (Exception ex) 
        {
            LX_CommonUtilities.createExceptionLog(ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '' + ex));           
        }        
          
        PageReference pg = new PageReference('/' + retURL);
        return ApexPages.hasMessages() ? null : pg;
        
    }

    public class WrapperOffer 
    {
    public integer rowCount {get;set;}
    
        public LX_Offer__c Offer {
            set;
            get;
        }
        public boolean chk {
            set;
            get;
        }
        public WrapperOffer(integer rc,LX_Offer__c Offer, boolean chk) {
            this.Offer = Offer;
            this.chk = chk;
            this.rowCount = rc;
        }
    }
    public void FirstPage() {
        OffsetSize = 0;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        System.debug('@@@1' + OffSetSize);
        OfferWrapperList.clear();
        getDynamicOfferList();
    }
    public void previous() 
    {
    if(OffsetSize > LimitSize)
    {
        OffsetSize = OffsetSize - LimitSize;
    }
    else
    {
     OffsetSize = OffsetSize;
    }
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        system.debug('OffsetSize == ' + OffsetSize);
        OfferWrapperList.clear();
        getDynamicOfferList();
    }

    public void next() {
        OffsetSize = OffsetSize + LimitSize;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        OfferWrapperList.clear();
        getDynamicOfferList();
    }
    public void LastPage() {
        Integer totalPageNumber = getTotalPages();
        OffsetSize = (totalPageNumber - 1) * LimitSize;
        prev = ((OffsetSize > 0) ? false : true);
        nxt = ((OffsetSize + LimitSize < totalRecs) ? false : true);
        System.debug('@@@1' + OffSetSize);
        System.debug('@@@2' + totalrecs);
        System.debug('@@@3' + LimitSize);
        //isLastPage = true;
        OfferWrapperList.clear();
        getDynamicOfferList();
    }

    public Integer getTotal_size() {
        return totalRecs;
    }


    public integer getTotalPages() {
        if (math.mod(totalRecs, LimitSize) > 0) 
        {
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
}