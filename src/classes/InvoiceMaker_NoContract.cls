public with sharing class InvoiceMaker_NoContract {
/**
 * Worker class to export billing and Misc Adjustments for an Invoice Maker.
 *
 * @author appirio offshore 2010-12-28
 */
    
    private static final String BILLING = 'Billing';
    private static final String MISC_ADJUST = 'MiscAdjust';
    public static pse__Timecard__c previousTimecardRec;
    Public static string ProfRTid;
    Public static string issRTid;    
    Public static string rTName;    
    
    Public static Map<ID,pse__Miscellaneous_Adjustment__c> map_madj = new Map<ID,pse__Miscellaneous_Adjustment__c>();
    
    @Future 
    public static void excute(Set<Id> invoiceIdSet,string rT_Name)
    {
     List<pse__Billing_Event_Item__c> ALL_BEI = new List<pse__Billing_Event_Item__c>();
      List<pse__Billing_Event_Item__c> UPD_BEI = new List<pse__Billing_Event_Item__c>();
      List<pse__Billing_Event_Item__c> BEI_BILL = new List<pse__Billing_Event_Item__c>();
      List<pse__Billing_Event_Item__c> BEI_MADJ = new List<pse__Billing_Event_Item__c>();
      
      List<Invoice_Maker__c> makers = new List<Invoice_Maker__c>();
      for (Id id : invoiceIdSet) {
            Invoice_Maker__c maker = new Invoice_Maker__c(Id = id);
            makers.add(maker);
      }
      try{
        
        String dynamicBillingQuery = '';
        String dynamicMiscAdustmentBEIQuery = '';
        
        String dynamicNamingAttachmentQry = '';
        
        Map<String, Integer> namingPatternNumberMap = new Map<String,Integer>();
         //ProfRTid = ProjectRecordType__c.getValues('Professional Services').Record_Type_ID__c;
         ProfRTid = pse__proj__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Professional Services').getRecordTypeId(); 
         issRTid = pse__proj__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('ISS Implementation Project').getRecordTypeId(); 
         
        List<Invoice_Maker__c> invoiceMakers = [
                select 
                    Id,
                    Time_Period_End_Date__c,
                    Time_Period_Start_Date__c,
                //    Record_Types__c,
                    time_Billings__c,
                    time_MiscAdjustments__c 
                from 
                    Invoice_Maker__c 
                where 
                    id in :invoiceIdSet];
        System.debug('---invoice Makers---'+invoiceMakers);
        //find Invoice Maker records 
        for(Invoice_Maker__c im :invoiceMakers){
            if(im.time_Billings__c){
                //generate filter for a billing Event Item records
                dynamicBillingQuery += generateFilter(im);
                dynamicNamingAttachmentQry += generateNamingFilter(im , BILLING);
            }
            if(im.time_MiscAdjustments__c ){
                //generate filter for a Misc Adjustment's billing Event Item records
                dynamicMiscAdustmentBEIQuery += generateFilter(im);
                dynamicNamingAttachmentQry += generateNamingFilter(im , MISC_ADJUST);
            }
        }
        
        dynamicBillingQuery = dynamicBillingQuery != '' ? dynamicBillingQuery.substring(0, dynamicBillingQuery.lastIndexOf('or')) : dynamicBillingQuery;
        dynamicMiscAdustmentBEIQuery = dynamicMiscAdustmentBEIQuery != '' ? dynamicMiscAdustmentBEIQuery.substring(0,dynamicMiscAdustmentBEIQuery.lastIndexOf('or')) :  dynamicMiscAdustmentBEIQuery;
        system.debug('dynamicMiscAdustmentBEIQuery (56): '+ dynamicMiscAdustmentBEIQuery);
        dynamicNamingAttachmentQry = dynamicNamingAttachmentQry != '' ? dynamicNamingAttachmentQry.substring(0,dynamicNamingAttachmentQry.lastIndexOf('or')) : dynamicNamingAttachmentQry;
        String key  = '';
        
        // find out Billing Event Items for Billing file 
        Map<String ,Map<String,List<pse__Billing_Event_Item__c>>> extractBillingEvents = extractBillingEventItems(dynamicBillingQuery , BILLING);
        system.debug('extractBillingEvents' + extractBillingEvents);
        BEI_BILL = getList(extractBillingEvents);
        // find out Billing Event Items for Misc Adjustment file
        Map<String ,Map<String,List<pse__Billing_Event_Item__c>>> extractMiscAdjustmentBEIs = extractBillingEventItems(dynamicMiscAdustmentBEIQuery , MISC_ADJUST);
        system.debug('extractMiscAdjustmentBEIs: ' + extractMiscAdjustmentBEIs);
         BEI_MADJ = getList(extractMiscAdjustmentBEIs);
        namingPatternNumberMap = generateNamingPatternNumber(dynamicNamingAttachmentQry);
          ALL_BEI.Addall(BEI_BILL);
        ALL_BEI.Addall(BEI_MADJ);
        
           //-------------------------------------------------
        //US1990: Salesforce | PSE: Misc Adj dropdown --Praveen
        
        Set<ID> Madj = new set<ID>();
        List<pse__Miscellaneous_Adjustment__c> madjLst = new List<pse__Miscellaneous_Adjustment__c>();
     //   Map<ID,pse__Miscellaneous_Adjustment__c> map_madj = new Map<ID,pse__Miscellaneous_Adjustment__c>();
        
        if(!ALL_BEI.isEmpty())
        {       
        for(pse__Billing_Event_Item__c beii : ALL_BEI)
        {
        if((beii.pse__Category__c == 'Miscellaneous Adjustment') && (beii.pse__Object_Id__c != null))
        Madj.add(beii.pse__Object_Id__c);       
        }
        madjLst = [Select ID,Invoice_Description__c from pse__Miscellaneous_Adjustment__c where ID in: Madj];      
        
        for(pse__Miscellaneous_Adjustment__c midj : madjLst)
        {
        map_madj.put(midj.ID,midj);        
        }
        }         
        //-------------------------------------------------------
        
        List<Attachment> attachments = new List<Attachment>();
        // create attachment for invoice maker
 
        for(Invoice_Maker__c invoiceMaker : invoiceMakers){
            system.debug('within invoice maker loop - invoiceMaker: ' + invoiceMaker);
            String dateKey = invoiceMaker.Time_Period_Start_Date__c +';'+invoiceMaker.Time_Period_End_Date__c;
            
            if(invoiceMaker.time_Billings__c && extractBillingEvents.containsKey(dateKey)){
                //create attachment for Billing
                system.debug('within billings__c - extractBillingEvents' + extractBillingEvents);
                system.debug('within billings__c - extractBillingEvents.containsKey(dateKey)' + extractBillingEvents.containsKey(dateKey));
               Attachment attach = createAttachment(invoiceMaker, extractBillingEvents.get(dateKey), namingPatternNumberMap, BILLING);  
               attachments.add(attach);
            }
            if(invoiceMaker.time_MiscAdjustments__c && extractMiscAdjustmentBEIs.containsKey(dateKey)){
                //create attachment for Misc Adjustment
                system.debug('createAttachment - invoice Maker: ' + invoiceMaker);
                system.debug('createattachment - extractMiscAdjustmentBEIs.get(dateKey): ' + extractMiscAdjustmentBEIs.get(dateKey));
                system.debug('createAttachment - namingPatternNumberMap: ' + namingPatternNumberMap);
                system.debug('createAttachment - MISC_ADJUST: ' + MISC_ADJUST);
               Attachment attach = createAttachment(invoiceMaker, extractMiscAdjustmentBEIs.get(dateKey),namingPatternNumberMap , MISC_ADJUST); 
               attachments.add(attach);
            }
        }
        system.debug('attachments:');
        system.debug('attachments.size(): ' + attachments.size());
        // insert attachments
        if(attachments.size() > 0){
           insert attachments;
        }
        for (Invoice_Maker__c maker : makers) {
            maker.Status__c = 'Success';
        }
        
        if(!ALL_BEI.IsEmpty())  //Gurvinder | Oct 26 2012 | moved within try{} block | previous US1575
        {
            for(pse__Billing_Event_Item__c PBE : ALL_BEI )
            {
                if(PBE.ID != Null)
                {
                    UPD_BEI.add(new pse__Billing_Event_Item__c(ID = PBE.ID,Invoiced__c = True,Date_Invoiced__c = System.Today()));
                }
            }
            Update UPD_BEI;        
        }
        
     }catch(Exception ex){
        System.debug('Exception: '+ex);
        for (Invoice_Maker__c maker : makers) {
            maker.Status__c = 'Failure';
        }
        System.debug('--appirio offshore--'+ex.getMessage());
     }

     System.debug('---Makers----'+makers);
     if (makers.size() > 0) {
        update makers;
     }
    }
    
     Public Static List<pse__Billing_Event_Item__c> getList(Map<String ,Map<String,List<pse__Billing_Event_Item__c>>> kingmap)
    {
    List<pse__Billing_Event_Item__c> returnthis = new List<pse__Billing_Event_Item__c>();
    for(String s : Kingmap.keyset())
    {
    Map<String,List<pse__Billing_Event_Item__c>> tempmap = kingmap.get(s);
    for(String st: tempmap.keyset())
    {
    for(pse__Billing_Event_Item__c pbi : tempmap.get(st))
    {
    returnthis.add(pbi);
    }
    }
    }
    return returnthis;
    }
    
    /* This method generate filter for Billing Event Item query */
    public static String generateFilter(Invoice_Maker__c im){
        string dynamicBEIQuery = '';
        //build dynamic query for billing Event Item between the time period startDate and endDate
        DateTime startDate = DateTime.newInstance(im.Time_Period_Start_Date__c.year(),im.Time_Period_Start_Date__c.month(),im.Time_Period_Start_Date__c.day());
        DateTime endDate = DateTime.newInstance(im.Time_Period_End_Date__c.year(),im.Time_Period_End_Date__c.month(),im.Time_Period_End_Date__c.day());
        dynamicBEIQuery += ' ( ';
        dynamicBEIQuery += ' pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c >='+startDate.format('yyyy-MM-dd');
        dynamicBEIQuery += ' and ';
        dynamicBEIQuery += ' pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c < = '+endDate.format('yyyy-MM-dd');
        dynamicBEIQuery += ' ) or';
        return dynamicBEIQuery;
    }
    
    public static String generateNamingFilter(Invoice_Maker__c im, String billingType){
        String filterQuery = '';
        String fileName = generateFileName(im,billingType);
        filterQuery = ' Name like \''+fileName+'%\' or ';
        system.debug('filterQuery:' + filterQuery);
        return filterQuery;
    }
    
    /* This method prepare a map of the billing event items */
    public static Map<String ,Map<String,List<pse__Billing_Event_Item__c>>> extractBillingEventItems(String filterQuery, String billingType){
        Map<String ,Map<String,List<pse__Billing_Event_Item__c>>> extractBillingEvents = new Map<String ,Map<String,List<pse__Billing_Event_Item__c>>>();
        List<pse__Billing_Event_Item__c> billingEventItems = loadBillingEventItems(filterQuery , billingType);
        Map<String,List<pse__Billing_Event_Item__c>> tempBEIMap;
        // prepare map where Key is startDate ; endDate and value is billing event Item. 
        for(pse__Billing_Event_Item__c billingEventItem : billingEventItems ){
            //check project's opportnity contract Number is not blank
            String key = billingEventItem.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c +';'+billingEventItem.pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c;
            if(!extractBillingEvents.containsKey(key)){
                tempBEIMap = new Map<String,List<pse__Billing_Event_Item__c>>();
                extractBillingEvents.put(key,tempBEIMap);
            }
            // build map where key as project Name  : project Id and value as Billing Event Item
            tempBEIMap = buildChildBEIMap(extractBillingEvents.get(key),billingEventItem);
            extractBillingEvents.put(key,tempBEIMap);   
       }
       return extractBillingEvents;
    }
    
    /* This method load Billing Event Item query for billing file */
    public static List<pse__Billing_Event_Item__c> loadBillingEventItems(String filterQuery, String billingType){
        String billingEventQueryString = getBillingEIQuery();
        String otherFilterQuery = '';
        if(billingType.equals(BILLING)){
            otherFilterQuery = '  AND pse__Category__c != \'Miscellaneous Adjustment\' AND pse__Project__r.pse__Billing_Type__c in (\'Time and Materials\',\'T&M/Fixed\', \'INVST_S_PB\', \'INVST_S_CM\' , \'INVST_S_UK\') AND ( pse__Project__r.pse__opportunity__r.contract_number__c = null) ';
            if(rTName ==  'Professional Services')
            {
            otherFilterQuery = otherFilterQuery + ' AND (pse__project__r.recordtypeID = \''+ProfRTid+'\') ';
            }
            else if(rTName ==  'ISS Implementation Project')
            {
            otherFilterQuery = otherFilterQuery + ' AND (pse__project__r.recordtypeID = \''+issRTid+'\') ';
            }
            otherFilterQuery = otherFilterQuery + ' AND (Invoiced__c != True) ';
            otherFilterQuery = otherFilterQuery + ' AND (pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c like \'5%\' OR pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c like \'3%\' OR pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c = null)';
//            otherFilterQuery = otherFilterQuery + ' ORDER BY pse__project__r.pse__opportunity__r.Account.Sales_Organization__r.Sales_Organization__c,pse__Project__r.pse__Account__r.MDM_Sold_To_Number__c,Extract_PO_Number__c,pse__Project__r.LX_Bill_To_ID__c,pse__Project__r.pse__Project_ID__c,pse__Project__r.Name,pse__Project__r.Project_Manager_Name__c,pse__Project__r.pse__Opportunity__r.Opportunity_Number__c,Extract_Company_Number__c, Extract_Project_Name__c, Extract_Label__c';
//otherFilterQuery = otherFilterQuery + ' ORDER BY pse__Project__r.pse__Account__r.MDM_Sold_To_Number__c,Extract_PO_Number__c,pse__Project__r.LX_Bill_To_ID__c,pse__Project__r.pse__Project_ID__c,pse__Project__r.Name,pse__Project__r.Project_Manager_Name__c,pse__Project__r.pse__Opportunity__r.Opportunity_Number__c,Extract_Company_Number__c, Extract_Project_Name__c, Extract_Label__c';
            otherFilterQuery = otherFilterQuery + ' ORDER BY pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c,pse__project__r.pse__opportunity__r.LX_SoldToID__c,pse__project__r.pse__opportunity__r.Primary_Partner__r.Type,pse__project__r.pse__opportunity__r.LX_SoldToID__c,Extract_PO_Number__c,pse__Project__r.LX_Bill_To_ID__c,pse__Project__r.pse__Project_ID__c,pse__Project__r.Name,pse__Project__r.Project_Manager_Name__c,pse__Project__r.pse__Opportunity__r.Opportunity_Number__c,Extract_Company_Number__c, Extract_Project_Name__c, Extract_Label__c';
        }else if(billingType.equals(MISC_ADJUST)){
           otherFilterQuery = ' AND pse__Category__c = \'Miscellaneous Adjustment\' AND ( pse__Project__r.pse__opportunity__r.contract_number__c = null)';  // or pse__Project__r.pse__Parent_Project__r.pse__opportunity__r.contract_number__c != null)';
           if(rTName ==  'Professional Services')
           {
           otherFilterQuery = otherFilterQuery + ' AND (pse__project__r.recordtypeID = \''+ProfRTid+'\') ';
           }
           else if(rTName ==  'ISS Implementation Project')
           {
           otherFilterQuery = otherFilterQuery + ' AND (pse__project__r.recordtypeID = \''+issRTid+'\') ';
           }
            otherFilterQuery = otherFilterQuery + ' AND (Invoiced__c != True) ';
            otherFilterQuery = otherFilterQuery + ' AND (pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c like \'5%\' OR pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c like \'3%\' OR pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c = null)';            
           otherFilterQuery = otherFilterQuery + ' ORDER BY Extract_Company_Number__c, Extract_Project_Name__c, Extract_Label__c';
        }
        system.debug('otherFilterQuery(150):' + otherFilterQuery);
        List<pse__Billing_Event_Item__c> billingEventItems = new List<pse__Billing_Event_Item__c>();
        //find Billing records
        if(filterQuery.length() > 0){
           String mainQuery = '';
           //if there is more than one comparison in filter part then add it in brackets
           if(filterQuery.contains('or')){
             mainQuery = billingEventQueryString + ' where  ('+ filterQuery + ' ) ' + otherFilterQuery;
           }else{
            mainQuery = billingEventQueryString + ' where  '+ filterQuery + otherFilterQuery;
           }
           System.debug('querying XXXX: '+mainQuery);
           billingEventItems = Database.query(mainQuery);
        }
        return billingEventItems; 
    }
    
    public static String getBillingEIQuery()
    {
        String billingEventItemQuery = 'SELECT '+
                'ID, '+
                'Name, '+
                'pse__Unit_Price__c, '+
                'pse__Quantity__c, '+
                'pse__Amount__c, '+
                 'pse__Object_Id__c, '+
                'pse__Category__c, '+
                'Labor_Category_Account_Number__c, '+
                'CurrencyIsoCode, '+
                'pse__Project__r.Name, '+
                'pse__Project__r.CurrencyIsoCode, '+
                'pse__Project__r.pse__Account__r.Company_Number__c, '+
                'pse__Project__r.pse__Account__r.Sector__c, '+
                'pse__Project__r.Accounting_Contact__r.Contact_Number__c, '+
                'pse__Billing_Event__r.Name, '+
                'pse__Project__r.Id, '+
                'pse__Project__r.pse__Project_ID__c, '+
                'pse__Project__r.Accounting_Contact__c, '+
                'pse__Project__r.Product_Field__c, '+
                'Extract_PO_Number__c, '+
                'Extract_Label__c, '+
                'Extract_Opportunity_Sector__c, '+
                'Extract_Company_Number__c, '+
                'Extract_Project_Name__c, '+
                'Extract_Billing_Start_Date__c, '+
                'Extract_Billing_End_Date__c, '+
                'pse__project__r.pse__opportunity__c, '+
                'pse__Project__r.pse__Parent_Project__c, '+
                'pse__Project__r.pse__Parent_Project__r.pse__opportunity__c, '+
                'pse__Project__r.pse__Parent_Project__r.pse__opportunity__r.Contract_Number__c, '+
                'pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__Start_Date__c, '+
                'pse__Billing_Event__r.pse__Billing_Event_Batch__r.pse__Time_Period__r.pse__End_Date__c, '+
                'pse__project__r.pse__opportunity__r.Contract_Number__c, '+
  //              'pse__project__r.pse__opportunity__r.Sales_Organization__c, '+
                'pse__project__r.pse__opportunity__r.Account.Coverage_ID__r.Sales_Organization__c, '+
  //              'pse__project__r.pse__opportunity__r.Sales_Organization__r.Name, '+
                'pse__project__r.pse__opportunity__r.Account.Coverage_ID__r.Sales_Organization__r.Name, '+
  //              'pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c, '+
                'pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c, '+
                'pse__Project__r.CLIN_Information__c, '+
                'pse__Project__r.pse__Project_Manager__c, '+
                'pse__Project__r.pse__Project_Manager__r.Name, '+
                'pse__Project__r.Project_Manager_Name__c, '+
                'pse__Project__r.pse__Account__r.MDM_Sold_To_Number__c, '+
                'pse__project__r.pse__opportunity__r.LX_SoldToID__c, '+
                'pse__project__r.pse__opportunity__r.Primary_Partner__c, '+
                'pse__project__r.pse__opportunity__r.Primary_Partner__r.Type, '+
                'pse__Project__r.pse__Opportunity__r.Opportunity_Number__c, '+
                'pse__Project__r.Additional_Invoice_Information__c, '+ //Added for case#00031492 (US1169)
                'pse__Project__r.LX_Bill_To_ID__c, '+
                'pse__Project__r.LX_Ship_To_ID__c, ' +
                'pse__Billing_Event__r.pse__Summary_Amount__c, ' +
                'pse__Project__r.pse__Opportunity__r.Ship_To__r.name, ' + //Added by Lalit for story S-97012
                'pse__Date__c, '+
                '( '+
                '   select '+ 
                '       Id, '+
                '       pse__Resource__c, '+
                '       pse__Resource__r.Name, '+
                '       pse__Resource__r.pse__Resource_Role__c, '+
                '       pse__Total_Hours__c '+
                '   from pse__Timecard_Splits__r )' +
                'FROM pse__Billing_Event_Item__c';
                system.debug(billingEventItemQuery);
        return billingEventItemQuery;
    }
    
    
    public static Map<String, List<pse__Billing_Event_Item__c>> buildChildBEIMap(Map<String, List<pse__Billing_Event_Item__c>> tempBillingEIs, pse__Billing_Event_Item__c billingEventItem){
        //String contractNumber = getContractNumber(billingEventItem);
        Map<String, List<pse__Billing_Event_Item__c>> tempBEIMap = tempBillingEIs;
        if(tempBEIMap.containsKey(billingEventItem.pse__Project__r.Name + ':'+billingEventItem.pse__project__c)){
            tempBEIMap.get(billingEventItem.pse__Project__r.Name + ':'+billingEventItem.pse__project__c).add(billingEventItem);
         }else{
            List<pse__Billing_Event_Item__c> tempList = new List<pse__Billing_Event_Item__c>();
            tempList.add(billingEventItem);
            tempBEIMap.put(billingEventItem.pse__Project__r.Name + ':'+billingEventItem.pse__project__c ,tempList);
         }
         return tempBEIMap;
    }
    public static Map<String,Integer> generateNamingPatternNumber(String filterQuery){
        Map<String,Integer> namingCountMap = new Map<String,Integer>();
        String namingPatternAttachmentQry = 'Select Id , Name from Attachment';
        if(filterQuery != null && filterQuery.length() > 0){
            System.debug('Attachment Query'+namingPatternAttachmentQry + ' where '+filterQuery);
            for(Attachment attach : Database.query(namingPatternAttachmentQry + ' where '+filterQuery)){
                String attachName = attach.Name != '' ? attach.Name.subString(0,attach.Name.lastIndexOf('_')) : attach.Name;
                if(namingCountMap.containsKey(attachName)){
                    namingCountMap.put(attachName,namingCountMap.get(attachName)+ 1);
                }else{
                    namingCountMap.put(attachName,1);
                }
            }
        }
        return namingCountMap;
    }
    
    /* This method create a Attachment reference */
    public static Attachment createAttachment(Invoice_Maker__c invoiceMaker, Map<String,List<pse__Billing_Event_Item__c>> billingEventItems, Map<String, Integer> namingPatternNumberMap, String billingType){
        //String fileName = invoiceMaker.Time_Period_Start_Date__c.year()+'_'+invoiceMaker.Time_Period_Start_Date__c.Month()+invoiceMaker.Time_Period_Start_Date__c.day()+invoiceMaker.Time_Period_Start_Date__c.Month()+invoiceMaker.Time_Period_End_Date__c.day()+'_'+billingType+'__1.csv';
        String fileName = generateFileName(invoiceMaker,billingType)+ '_noContract';
        system.debug('filename: ' + filename);
        system.debug('namingPatternNumberMap:' + namingPatternNumberMap);
        if(namingPatternNumberMap.containsKey(fileName)){
            System.debug('--appirio =='+billingType+' offshore--contains--'+namingPatternNumberMap.get(fileName));
            fileName += '_'+(namingPatternNumberMap.get(fileName)+1)+'.csv';
            
        }else{
            System.debug('--not =='+billingType+' contains--');
             fileName += '_1.csv';
        }  
        system.debug('filename:' + filename); 
        Attachment attach = new Attachment();
        attach.Name = fileName;
        attach.ParentId = invoiceMaker.id;
        attach.ContentType = 'text/csv';
        String csvValue = '';
        csvValue += generateCSVFormat(billingEventItems,invoiceMaker.Time_Period_Start_Date__c, invoiceMaker.Time_Period_End_Date__c, billingType);
        system.debug('return csvValue');
        system.debug('csvValue: ' + csvValue);
        attach.Body = Blob.valueOf(csvValue);
        return attach;
    }
    
    /* This method generate CSV format */   
    public static String generateCSVFormat(Map<String,List<pse__Billing_Event_Item__c>> billingEIs, Date StartDate, Date endDate, string billingType){
        String csvValue = '';
        System.debug('--list--'+billingEIs);
        //Map<String,String> projectContractNumberMap = new Map<String,String>();
        List<String> projectNames = new List<String>();
        projectNames.addAll(billingEIs.keySet());
        projectNames.sort();
        System.debug('---project list----'+projectNames);
        Set<String> existingProjectString = new Set<String>();
        String contractNumber ='';
        for(String projectName : projectNames){
            List<pse__Billing_Event_Item__c> tempBEIs = billingEIs.get(projectName);
            System.debug('-------billing Event Item in a project --------'+tempBEIs);
            if(tempBEIs != null && tempBEIs.size() > 0){
               csvValue += generateProjectBasedCSV(tempBEIs,StartDate,endDate, billingType); 
            }
        }   
        return csvValue;
    }
    
    public static String generateProjectBasedCSV(List<pse__Billing_Event_Item__c> tempBEIs,Date StartDate,Date endDate, string billingType){
        String mainCSV = '';
        String textcsvValue = '';
        String headercsvValue = '';
        Double commulativeOrderQuantity = 0;
        Map<String,String> projectContractNumberMap = new Map<String,String>();
        String contractNumber;
        pse__Billing_Event_Item__c beiProcessRec = new pse__Billing_Event_Item__c ();
        pse__Billing_Event_Item__c beiRec = new pse__Billing_Event_Item__c ();
        pse__Timecard__c timecardSplitRec = new pse__Timecard__c ();
        previousTimecardRec = null;
        system.debug('tempBEIs:' + tempBEIs);
//sort the billing events items
        Map<String, List<pse__Billing_Event_Item__c>> BEISortedMap = new Map<String, List<pse__Billing_Event_Item__c>>();
        for(pse__Billing_Event_Item__c beiRecord : tempBEIs){
            List<pse__Billing_Event_Item__c> tempBeiList = new List<pse__Billing_Event_Item__c>();
            If(BEISortedMap.containskey(beiRecord.Extract_Label__c + beiRecord.pse__Unit_Price__c)){
                tempBeiList = BEISortedMap.get(beiRecord.Extract_Label__c + beiRecord.pse__Unit_Price__c);
            }   
                TempBeiList.add(beiRecord);
                BEISortedMap.put(beiRecord.Extract_Label__c + beiRecord.pse__Unit_Price__c, TempBeiList);
        }

        List<String>BEISorted = new List<String>();
        BEISorted.addAll(BEISortedMap.keySet());
        BEISorted.sort();
system.debug('BEISortedMap:'+BEISortedMap);     
system.debug('BEISorted:' + BEISorted);
        for(String BEISortKey : BEISorted){
 
        
            for(pse__Billing_Event_Item__c bei : BEISortedMap.get(BEISortKey)){
                system.debug('bei - billingevent - generateproject: ' + bei);
                beiRec = bei;
               // if(projectContractNumberMap.containsKey(bei.pse__Project__c)){
               //     contractNumber = projectContractNumberMap.get(bei.pse__Project__c);
               // }else{
                    contractNumber = '';//getContractNumber(bei.pse__Project__r);
               //     projectContractNumberMap.put(bei.pse__Project__c,contractNumber);
               // }
               if(bei.pse__Quantity__c > 0.00){
                    if (beiProcessRec== null){
                        beiProcessRec = bei;
                    }else {
                        If(beiProcessRec.pse__project__r.Name == null){
                            beiProcessRec = bei;
                        }
                    }       
                    system.debug(' in generateProjectBasedCSV: ' );
                    system.debug(' bei.pse__Timecard_Splits__r: ' + bei.pse__Timecard_Splits__r);
                    system.debug('after check for timecard records');
                 If(bei.pse__Timecard_Splits__r.size() > 0){
                    for(pse__Timecard__c timecardSplit : bei.pse__Timecard_Splits__r){
                    // test a multi-line CSV file
                        timecardSplitRec = timecardSplit;
                        if(previousTimecardRec == null){
                            previousTimecardRec = timecardSplit;
                        }else{
                            if (previousTimecardRec.pse__Resource__c == null){
                                previousTimecardRec = timecardSplit;
                            }else{
                                If(previousTimecardRec.pse__resource__r.Name != timecardSplitRec.pse__Resource__r.Name){
                                    textcsvValue += generateBEITimecardSplitLine(previousTimecardRec,beiProcessRec,contractNumber, StartDate,endDate, billingType); //added  billingType parameter to this function call by Lalit
                                    if(billingType!= 'MiscAdjust') //Added by Lalit
                                    {
                                    String invoiceDescription = generateInvoiceDescription(previousTimecardRec, beiProcessRec,StartDate,endDate, billingType);
                                    textcsvValue+= invoiceDescription.length() > 0 ? '\"'+escapeQuote(generateInvoiceDescription(previousTimecardRec, beiProcessRec,StartDate,endDate, billingType))+'\",': ',';
                                    }
                                    textcsvValue += '\n';
                                    beiProcessRec = bei;
                                    previousTimecardRec = timecardSplitRec;
                                }else{
                                    beiProcessRec.pse__Quantity__c = beiProcessRec.pse__Quantity__c + bei.pse__Quantity__c;
                                }
                            }
                        }
                        commulativeOrderQuantity = commulativeOrderQuantity + (bei.pse__Unit_Price__c * timecardSplit.pse__Total_Hours__c);
                    }
            
                    if (commulativeOrderQuantity == 0.0 && billingType == 'MiscAdjust'){
                        commulativeOrderQuantity = bei.pse__Amount__c;
                    }
                 }
                 else{ // US1968 : for Misc Adjustment BEI
                     beiProcessRec = bei;
                     textcsvValue += generateBEITimecardSplitLine(previousTimecardRec,beiProcessRec,contractNumber, StartDate,endDate, billingType); //added  billingType parameter to this function call by Lalit
                     if(billingType!= 'MiscAdjust') //Added by Lalit
                     {
                     String invoiceDescription = generateInvoiceDescription(previousTimecardRec, beiProcessRec,StartDate,endDate, billingType);
                     textcsvValue+= invoiceDescription.length() > 0 ? '\"'+escapeQuote(generateInvoiceDescription(previousTimecardRec, beiProcessRec,StartDate,endDate, billingType))+'\",': ',';
                     textcsvValue += addMADJDesc(beiProcessRec);
                     }
                       system.debug('ZZZZZ' +billingType);
                        /*if(billingType == 'MiscAdjust') //Commented by Lalit as i have moved this if condition to above else block
                        {
                        textcsvValue += addMADJDesc(beiProcessRec);
                        }*/
                     
                     textcsvValue += '\n';
                 }
               }
           }
        } 
       
        //process last record in loop 
      if(previousTimecardRec != null){ // US1968 (Misc Adj records are included in above For loop)
          textcsvValue += generateBEITimecardSplitLine(previousTimecardRec,beiProcessRec,contractNumber, StartDate,endDate, billingType); //added  billingType parameter to this function call by Lalit
          String invoiceDescription = generateInvoiceDescription(previousTimecardRec, beiProcessRec,StartDate,endDate, billingType);
          textcsvValue+= invoiceDescription.length() > 0 ? '\"'+escapeQuote(generateInvoiceDescription(previousTimecardRec, beiProcessRec,StartDate,endDate, billingType))+'\",': ',';
          textcsvValue += '\n';
      }     
       
      // pse__Billing_Event_Item__c billingEI = tempBEIs.get(0);
       system.debug('beiProcessRec: ' + beiProcessRec);
       headercsvValue += generateHeaderBEI(beiProcessRec,contractNumber,commulativeOrderQuantity, StartDate,endDate, billingType); //added  billingType parameter to this function call by Lalit
       headercsvValue += '\n';
       mainCSV += headercsvValue + textcsvValue;
       System.debug('--mainCSV-'+mainCSV);
       if(previousTimecardRec != null){
        previousTimecardRec.clear();
       }
       // if (beiProcessRec!=null){    //Gurvinder: fix for duplicate BEI issue
       // beiProcessRec.clear();
       // }    
       return mainCSV;
    }
    
      public static string addMADJDesc(pse__Billing_Event_Item__c bei)
    {
    string str = '';
    str += map_madj.get(bei.pse__Object_Id__c) != null ? map_madj.get(bei.pse__Object_Id__c).Invoice_Description__c +',' : '';
     return str;   
    }
    
    /* This method retrun contract number of the opportunity */
    public static String getContractNumber(pse__Proj__c project){
      String contractNumber = '';   
      if(project != null){
         //if(project.pse__Opportunity__c != null && project.pse__opportunity__r.Contract_Number__c != null){
         //   contractNumber = project.pse__opportunity__r.Contract_Number__c;
            contractNumber = '';
        // }else if(project.pse__Parent_Project__c != null && project.pse__Parent_Project__r.pse__Opportunity__c != null && project.pse__Parent_Project__r.pse__opportunity__r.Contract_Number__c != null){
        //    contractNumber = project.pse__Parent_Project__r.pse__opportunity__r.Contract_Number__c;
        // }
      }
      System.debug('-------contract Number -------in method------'+contractNumber);
      return contractNumber;
    }
    
    /* This method generate a row for Timecard Split Line */ 
    public static String generateBEITimecardSplitLine(pse__Timecard__c timecardSplit, pse__Billing_Event_Item__c bei, String contractNumber,Date StartDate,Date endDate, String billingType){  //added  billingType parameter to this function call by Lalit

        String csvValue = 'ZPOT,';
        csvValue +=  contractNumber + ',';
 //       csvValue +=  bei.pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c != null ? '\"' + escapeQuote(bei.pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c)+ '\",' : ',';
        csvValue +=  bei.pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c != null ? '\"' + escapeQuote(bei.pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c)+ '\",' : ',';
         if(bei.pse__Project__r.pse__opportunity__r.Primary_Partner__c == null)
        {
        csvValue +=  bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c!= null ?  '\"' + escapeQuote(bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c)+ '\",' : ',';
        }
        else
        {
        if(bei.pse__Project__r.pse__opportunity__r.Primary_Partner__r.type == 'Partner-Channel Level 1' || bei.pse__Project__r.pse__opportunity__r.Primary_Partner__r.type == 'Partner-Channel Level 2' || 
        bei.pse__Project__r.pse__opportunity__r.Primary_Partner__r.type == 'Partner-Channel Level 3' || bei.pse__Project__r.pse__opportunity__r.Primary_Partner__r.type == 'Partner-OEM')
        {
        csvValue +=  bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c != null ?  '\"' + escapeQuote(bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c)+ '\",' : ',';      
        }
        else
        {
        csvValue +=  bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c!= null ?  '\"' + escapeQuote(bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c)+ '\",' : ',';
        }       
        }
        csvValue +=  bei.Extract_PO_Number__c != null ?  '\"' +escapeQuote(bei.Extract_PO_Number__c)+ '\",' : 'Services' +',';
        csvValue +=  bei.pse__Project__r.LX_Bill_To_ID__c!= null ?  '\"' +escapeQuote(bei.pse__Project__r.LX_Bill_To_ID__c)+ '\",' : ',';
        //csvValue +=  bei.pse__Project__r.pse__Opportunity__r.Ship_To__r.name!= null ?  '\"' +escapeQuote(bei.pse__Project__r.pse__Opportunity__r.Ship_To__r.name)+ '\",' : ',';//Added by Lalit for story S-97012 
        //if(billingType.equals(MISC_ADJUST)){
            csvValue +=  bei.pse__Project__r.LX_Ship_To_ID__c!= null ?  '\"' +escapeQuote(bei.pse__Project__r.LX_Ship_To_ID__c)+ '\",' : ',';
        //}
        csvValue +=  DateTime.newInstance(Date.today().year(), Date.today().month(), Date.today().day()).format('yyyyMMdd')+',';
        csvValue +=  bei.pse__Project__r.pse__Project_ID__c != null ? '\"'+escapeQuote(bei.pse__Project__r.pse__Project_ID__c)+'\",' : ',';
        csvValue +=  bei.pse__Project__r.Name != null ? '\"'+escapeQuote(bei.pse__Project__r.Name)+'\",' : ',';
        csvValue +=  bei.pse__Project__r.Project_Manager_Name__c!= null ? '\"'+escapeQuote(bei.pse__Project__r.Project_Manager_Name__c) +'\",' : ',';
        csvValue +=  bei.pse__Project__r.CLIN_Information__c != null ? '\"'+escapeQuote(bei.pse__Project__r.CLIN_Information__c)+ '\",' : ',';
        //csvValue +=  'Services Incurred: '+(StartDate).format()+ ' to ' + (endDate).format() + ',';
        csvValue +=  'Services Incurred: '+(StartDate).format()+ ' to ' + (endDate).format(); //Added for case#00031492 (US1169)
        csvValue +=  bei.pse__Project__r.Additional_Invoice_Information__c!=null ? + ' - ' + escapeQuote(bei.pse__Project__r.Additional_Invoice_Information__c) + ',' : ','; //Added for case#00031492 (US1169)
    //Rahul Deloitte added null check
    if(bei.pse__Project__r != null && bei.pse__Project__r.pse__Opportunity__r != null){
      csvValue += bei.pse__Project__r.pse__Opportunity__r.get('Opportunity_Number__c') != null ? bei.pse__Project__r.pse__Opportunity__r.get('Opportunity_Number__c')+',' : ',';
    }else{
      csvValue += ',';
    }

        csvValue +=  ',';
         if(billingType.equals(MISC_ADJUST))
        {
            csvValue +=  'Description'+','; //Added by Lalit 
        }
       
        if(billingType.equals(MISC_ADJUST))
        {
            csvValue +=  bei.pse__Unit_Price__c != null ? '\"'+bei.pse__Unit_Price__c+'\",' : ','; //added by Lalit  //P column
        } else {
            csvValue +=  ',';
        }
        
        csvValue +=  timecardSplit != null ? '\"'+escapeQuote(timecardSplit.pse__Resource__r.Name)+'\",': ',';
        
        //csvValue +=  ',';
        if(billingType.equals(MISC_ADJUST))
        {
            //csvValue += ',';
        } else {
           // csvValue += ',';
        }
        if(billingType.equals(MISC_ADJUST))
        {
            if(map_madj != null && map_madj.get(bei.pse__Object_Id__c) != null)
            csvValue +=  map_madj.get(bei.pse__Object_Id__c).Invoice_Description__c  != null ? '\"'+escapeQuote(map_madj.get(bei.pse__Object_Id__c).Invoice_Description__c) +'\",' : ','; //added by Lalit  
        }
        System.debug('------csvavlueRahul'+csvValue);
        return csvValue;
    }
    
    /* This method generate header row  */
    public static String generateHeaderBEI(pse__Billing_Event_Item__c bei, String contractNumber, Double commulativeOrderValue,Date StartDate,Date endDate, String billingType){  //added  billingType parameter to this function call by Lalit

        String csvValue = 'ZPOT,';
        csvValue +=  contractNumber + ','; 
 //       csvValue +=  bei.pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c != null ? '\"'+escapeQuote(bei.pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c)+ '\",' : ',';
        csvValue +=  bei.pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c != null ? '\"'+escapeQuote(bei.pse__project__r.pse__opportunity__r.Sales_Organization__r.Sales_Organization__c)+ '\",' : ',';
         if(bei.pse__Project__r.pse__opportunity__r.Primary_Partner__c == null)
        {
        csvValue +=  bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c!= null ?  '\"' + escapeQuote(bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c)+ '\",' : ',';
        }
        else
        {
        if(bei.pse__Project__r.pse__opportunity__r.Primary_Partner__r.type == 'Partner-Channel Level 1' || bei.pse__Project__r.pse__opportunity__r.Primary_Partner__r.type == 'Partner-Channel Level 2' || 
        bei.pse__Project__r.pse__opportunity__r.Primary_Partner__r.type == 'Partner-Channel Level 3' || bei.pse__Project__r.pse__opportunity__r.Primary_Partner__r.type == 'Partner-OEM')
        {
        csvValue +=  bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c != null ?  '\"' + escapeQuote(bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c)+ '\",' : ',';      
        }
        else
        {
        csvValue +=  bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c!= null ?  '\"' + escapeQuote(bei.pse__project__r.pse__opportunity__r.LX_SoldToID__c)+ '\",' : ',';
        }       
        }
        csvValue +=  bei.Extract_PO_Number__c != null ? '\"'+escapeQuote(bei.Extract_PO_Number__c)+'\",' : 'Services' +',';
        csvValue +=  bei.pse__Project__r.LX_Bill_To_ID__c!= null ?  '\"'+escapeQuote(bei.pse__Project__r.LX_Bill_To_ID__c)+'\",' : ',';
        //csvValue +=  bei.pse__Project__r.pse__Opportunity__r.Ship_To__r.name!= null ?  '\"' +escapeQuote(bei.pse__Project__r.pse__Opportunity__r.Ship_To__r.name)+ '\",' : ',';//Added by Lalit for story S-97012 
        //if(billingType.equals(MISC_ADJUST)){
            csvValue +=  bei.pse__Project__r.LX_Ship_To_ID__c!= null ?  '\"' +escapeQuote(bei.pse__Project__r.LX_Ship_To_ID__c)+ '\",' : ',';
        //}
        csvValue +=  DateTime.newInstance(Date.today().year(), Date.today().month(), Date.today().day()).format('yyyyMMdd')+',';
        csvValue +=  bei.pse__Project__r.pse__Project_ID__c != null ? '\"'+escapeQuote(bei.pse__Project__r.pse__Project_ID__c)+'\",' : ',';
        csvValue +=  bei.pse__Project__r.Name != null ? '\"'+escapeQuote(bei.pse__Project__r.Name)+'\",' : ',';
        csvValue +=  bei.pse__Project__r.Project_Manager_Name__c!= null ?  '\"'+escapeQuote(bei.pse__Project__r.Project_Manager_Name__c) +'\",' : ',';
        csvValue +=  bei.pse__Project__r.CLIN_Information__c != null ? '\"'+escapeQuote(bei.pse__Project__r.CLIN_Information__c)+ '\",' : ',';
//        csvValue +=  'Services Incurred: '+(StartDate).format()+ ' to ' + (endDate).format() + ',';
        csvValue +=  'Services Incurred: '+(StartDate).format()+ ' to ' + (endDate).format(); //Added for case#00031492 (US1169)
        csvValue +=  bei.pse__Project__r.Additional_Invoice_Information__c!=null ? + ' - ' + escapeQuote(bei.pse__Project__r.Additional_Invoice_Information__c) + ',' : ','; //Added for case#00031492 (US1169)
    //Rahul Deloitte added null check
    if(bei.pse__Project__r.pse__Opportunity__r != null){
      csvValue += (bei.pse__Project__r != null && bei.pse__Project__r.pse__Opportunity__r != null && bei.pse__Project__r.pse__Opportunity__r.get('Opportunity_Number__c') != null) ? bei.pse__Project__r.pse__Opportunity__r.get('Opportunity_Number__c')+',' : ',';
    }else{
      csvValue += ',';
    }

       //csvValue += 'PER0468,';      //n
        String st = bei.pse__Project__r.Product_Field__c; //Added by Shravani for US1842
        if(st!=null && st!='') st = st.substringbefore('-');          //Added by Shravani for US1842  //Gurvinder: corrected US1842
        csvValue += st +',';         //n //Added by Shravani for US1842
       //csvValue += bei.pse__Project__r.Product_Field__c +',';      //n
        csvValue += ',';  
        if(billingType.equals(MISC_ADJUST))
        {
            csvValue += bei.pse__Billing_Event__r.pse__Summary_Amount__c+',';
            //csvValue +=  bei.pse__Unit_Price__c != null ? '\"'+bei.pse__Unit_Price__c+'\",' : ','; //added by Lalit  //P column
        }
        else
        {
            csvValue +=  commulativeOrderValue != null ? commulativeOrderValue +',' : ',';     //P / / 
        }
        csvValue +=  'EA,';        //Q
        //csvValue += ',';
        //Changes Made By Rahul Chitkara (Appirio Jaipur)        
        if(billingType.equals(MISC_ADJUST))
        {
            //csvValue += ',';
        } else {
            csvValue += ',';
        }
        /*
         if(billingType.notequals(MISC_ADJUST))
        {
            csvValue +=  map_madj.get(bei.pse__Object_Id__c).Invoice_Description__c  != null ? '\"'+escapeQuote(map_madj.get(bei.pse__Object_Id__c).Invoice_Description__c) +'\",' : ','; //added by Lalit  
        }*/
        // Chanhges End Rahul
        return csvValue;
    }
     
    
    public static String generateFileName(Invoice_Maker__c invoiceMaker, String billingType){
        DateTime startDate = DateTime.newInstance(invoiceMaker.Time_Period_Start_Date__c.year(),invoiceMaker.Time_Period_Start_Date__c.month(),invoiceMaker.Time_Period_Start_Date__c.day());
        DateTime endDate = DateTime.newInstance(invoiceMaker.Time_Period_End_Date__c.year(),invoiceMaker.Time_Period_End_Date__c.month(),invoiceMaker.Time_Period_End_Date__c.day());
        String fileName = invoiceMaker.Time_Period_Start_Date__c.year()+'_'+startDate.format('MMMM')+invoiceMaker.Time_Period_Start_Date__c.day()+endDate.format('MMMM')+invoiceMaker.Time_Period_End_Date__c.day()+'_'+billingType;
        return fileName;
    }
    
    /* This method generate the 'Invoice Description ' part of the text row */  
    public static String generateInvoiceDescription(pse__Timecard__c timecardSplit , pse__Billing_Event_Item__c billingEI, Date StartDate, Date endDate, String billingType){
        String invoiceDescription = '';
        
        if(billingType.equals(MISC_ADJUST)){
            
            invoiceDescription = timecardSplit != null ? timecardSplit.pse__Resource__r.pse__Resource_Role__c : '';//Added by Lalit
        invoiceDescription += ' ' + billingEI.pse__Unit_Price__c;//Added by lalit 
               
        } else {
        
            invoiceDescription = timecardSplit != null ? timecardSplit.pse__Resource__r.pse__Resource_Role__c : 'null';
            invoiceDescription += ' '+ billingEI.pse__Quantity__c + ' Hrs @ ' + billingEI.pse__Unit_Price__c; 
                
          }

        return invoiceDescription;
    }
    
    public static String escapeQuote(String value){
        if(value != null && value.contains('"')){
            value = value.replace('"','""');
        }
        return value;
    }
    
}