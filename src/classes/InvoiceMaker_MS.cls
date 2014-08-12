public class InvoiceMaker_MS
 {
 
 @Future 
    public static void excute(Set<Id> invoiceIdSet)
      {
      List<Invoice_Maker__c> makers = new List<Invoice_Maker__c>();
      for (Id id : invoiceIdSet) 
      {
            Invoice_Maker__c maker = new Invoice_Maker__c(Id = id);
            makers.add(maker);
      }
      system.debug('Makers List'+makers);
      try
      {        
        String dynamicQuery = '';
        String dynamicNamingAttachmentQry = '';
        
        Map<String, Integer> namingPatternNumberMap = new Map<String,Integer>();
        
     
        system.debug('Invoice Maker Set '+invoiceIdSet );
        
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
        for(Invoice_Maker__c im :invoiceMakers)
        {
                //generate filter for a billing Event Item records
                dynamicQuery += generateFilter(im);
                system.debug('dynamicQuery:' + dynamicQuery);
                dynamicNamingAttachmentQry += generateNamingFilter(im);
            
        }
        dynamicQuery = dynamicQuery != '' ? dynamicQuery.substring(0, dynamicQuery.lastIndexOf('or')) : dynamicQuery;
        dynamicNamingAttachmentQry = dynamicNamingAttachmentQry != '' ? dynamicNamingAttachmentQry.substring(0,dynamicNamingAttachmentQry.lastIndexOf('or')) : dynamicNamingAttachmentQry;
        String key  = '';
        
        string finalquery = generatemainqry();
        
        finalquery = finalquery + dynamicQuery;
        
        system.debug('Querying xxxxxx---'+finalquery);
        
        List<OpportunityLineItem> opprlst = database.query(finalquery);
        
        map<String,List<OpportunityLineItem>> main_map = splitfiles(invoiceMakers,opprlst);
        namingPatternNumberMap = generateNamingPatternNumber(dynamicNamingAttachmentQry);
        //--------------------------------------------------------------------------
        List<Attachment> attachments = new List<Attachment>();
        for (Invoice_Maker__c maker : invoiceMakers) 
        {
        String dateKey = Maker.Time_Period_Start_Date__c +';'+Maker.Time_Period_End_Date__c;
        system.debug('-------DateKey---------'+datekey);
        system.debug('-------main map keyset---------'+main_map.keyset());
        
        if(main_map.containskey(datekey))
        {
        System.debug('------Before attachment------');
        Attachment attach = createAttachment(Maker,namingPatternNumberMap,main_map.get(dateKey));  
        attachments.add(attach);
        }       
        }
        
        if(!attachments.isEmpty())
        {        
        insert attachments;
        }
        for (Invoice_Maker__c maker : makers) {
            maker.Status__c = 'Success';
        }
        
        //----------------------------------------------------------------
        
        }
        catch(Exception ex)
     {
        System.debug('Exception: '+ex);
        for (Invoice_Maker__c maker : makers) {
            maker.Status__c = 'Failure';
        }
        System.debug('--appirio offshore--'+ex.getMessage());
     }
     System.debug('---Makers----'+makers);
     if (makers.size() > 0) 
     {
        update makers;
     }
        }
        
      //--------------------------------------------------------------------------------
      
      public static Attachment createAttachment(Invoice_Maker__c invoiceMaker,Map<String, Integer> namingPatternNumberMap,List<OpportunityLineItem> opplt)
      {
        //String fileName = invoiceMaker.Time_Period_Start_Date__c.year()+'_'+invoiceMaker.Time_Period_Start_Date__c.Month()+invoiceMaker.Time_Period_Start_Date__c.day()+invoiceMaker.Time_Period_Start_Date__c.Month()+invoiceMaker.Time_Period_End_Date__c.day()+'_'+billingType+'__1.csv';
        String fileName = generateFileName(invoiceMaker);
        
        if(namingPatternNumberMap.containsKey(fileName))
        {
            System.debug('Naming Pattern working----'+namingPatternNumberMap.get(fileName));
            fileName += '_'+(namingPatternNumberMap.get(fileName)+1)+'.csv';
        }
        else
        {
            System.debug('Naming patter else Loop');
            fileName += '_1.csv';
        }   
        Attachment attach = new Attachment();
        attach.Name = fileName;
        attach.ParentId = invoiceMaker.id;
        attach.ContentType = 'text/csv';
        String csvValue = '';
        csvValue += generateCSVFormat(invoiceMaker.Time_Period_Start_Date__c, invoiceMaker.Time_Period_End_Date__c,opplt);
        attach.Body = Blob.valueOf(csvValue);
        return attach;
    }  
      //----------------------------------------------------------------------------  
      
      public static String generateCSVFormat(Date StartDate, Date endDate,List<OpportunityLineItem> olm)
      {
       
      //  String headercsvValue = 'Opportunity COntract Number,'+'Account Name,'+'Part Number,'+'Bill To,'+'Ship To,'+'Total Price SAP,'
        //+'Environment,'+'opportunity SAP Status,'+'New Server Type,'+'Opportunity Account Name,'+'Project Phase,'+'Opportunity SAP Amount,'+'Project Manager,';
     //  String csvValue = headercsvValue +'\n'+ '';
     String csvValue='';
        System.debug('--Start Date--'+StartDate);
        System.debug('--End Date--'+endDate); 
        System.debug('--list--'+olm);
        
        for(OpportunityLineItem oppitem : olm)
        {  
           csvValue += generateLineItemBasedCSV(StartDate,endDate,oppitem);            
        }   
        return csvValue;
    }
    //----------------------------------------------------------------------------------------------
    
     public static String generateLineItemBasedCSV(Date StartDate,Date endDate,OpportunityLineItem oppitem)
    {
        String mainCSV = '';        
        String textcsvValue = '';

      textcsvValue += generateLine(StartDate,endDate,oppitem);      
     // headercsvValue += generateHeaderBEI(beiProcessRec,contractNumber,commulativeOrderQuantity, StartDate,endDate);
      
       mainCSV +=  textcsvValue+'\n';
       System.debug('--mainCSV-'+mainCSV);     
       return mainCSV;
    }
    
    /* This method generate a row for OpportunityLineItem */ 
    
    public static String generateLine(Date StartDate,Date endDate,OpportunityLineItem ol)
    {
        
        String csvValue = '';
       
        csvValue +=  ol.project__r.pse__Opportunity__r.Contract_Number__c + ',';
 
      //  csvValue +=  ol.project__r.pse__Account__r.name + ',' ;
      
         csvValue +=  ol.project__r.pse__Opportunity__r.Account.Name+ ',';      //US1710
        
        csvValue +=  ol.Part_Number__c + ',' ;
        
        csvValue +=  ol.project__r.pse__Opportunity__r.Bill_To_Name__c + ',';
        
        csvValue +=  ol.project__r.pse__Opportunity__r.Ship_To_Name__c + ',';
        
       // csvValue +=  ol.Total_Price_SAP__c + ',' ;
        
       // csvValue +=  'PROD ,' ;
        
     //   csvValue +=  ol.project__r.pse__Opportunity__r.SAP_Status__c + ',';
        
       // csvValue +=  ol.project__r.pse__Opportunity__r.SAP_Amount__c + ',';   //US1710
              
        csvValue +=  ol.UnitPrice + ',';   //US1836
                           
        csvValue +=  ol.project__r.New_Server_Type__c + ',';      //US1710
                
        csvValue +=  ol.project__r.pse__Project_Phase__c+ ',';      //US1710
        
        csvValue +=  ol.project__r.pse__Project_Manager__r.name;   
        
       
        return csvValue;
    }
    
   
     
    
    public static String generateFileName(Invoice_Maker__c invoiceMaker, String billingType)
    {
        DateTime startDate = DateTime.newInstance(invoiceMaker.Time_Period_Start_Date__c.year(),invoiceMaker.Time_Period_Start_Date__c.month(),invoiceMaker.Time_Period_Start_Date__c.day());
        DateTime endDate = DateTime.newInstance(invoiceMaker.Time_Period_End_Date__c.year(),invoiceMaker.Time_Period_End_Date__c.month(),invoiceMaker.Time_Period_End_Date__c.day());
        String fileName = invoiceMaker.Time_Period_Start_Date__c.year()+'_'+startDate.format('MMMM')+invoiceMaker.Time_Period_Start_Date__c.day()+endDate.format('MMMM')+invoiceMaker.Time_Period_End_Date__c.day()+'_'+billingType;
        return fileName;
    }
    
    /* This method generate the 'Invoice Description ' part of the text row */  
  
    
    public static String escapeQuote(String value)
    {
        if(value != null && value.contains('"')){
            value = value.replace('"','""');
        }
        return value;
    } 
      //------------------------------------------------------------------------------------------
      
      public static map<String,List<OpportunityLineItem>> splitfiles(List<Invoice_Maker__c> makers,List<OpportunityLineItem> loppr)
      {
      map<String,List<OpportunityLineItem>> ret_map = new map<String,List<OpportunityLineItem>>();
      
      for (Invoice_Maker__c maker : makers) 
      {
      for(OpportunityLineItem oli : loppr)
      {
      
 if((oli.Start_Date__c >= maker.Time_Period_Start_Date__c) && (oli.End_Date__c <= maker.Time_Period_End_Date__c))
      {
 String dateKey = Maker.Time_Period_Start_Date__c +';'+Maker.Time_Period_End_Date__c;
 if(ret_map.containskey(datekey))
 {
 List<OpportunityLineItem> tmp_lst = ret_map.get(dateKey);
 tmp_lst.add(oli);
 ret_map.put(dateKey,tmp_lst);
 }
 else
 {
 List<OpportunityLineItem> tmp_lst = new List<OpportunityLineItem>();
 tmp_lst.add(oli);
 ret_map.put(dateKey,tmp_lst); 
 }
     
      }
      }
      }
       
      return ret_map;
      }
     
      
  //---------------------------------------------------------------------------------

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

//==========================================================================
        
      public static String generateFilter(Invoice_Maker__c im)
      {
        string dynamicBEIQuery = '';
        //build dynamic query for billing Event Item between the time period startDate and endDate
        DateTime startDate = DateTime.newInstance(im.Time_Period_Start_Date__c.year(),im.Time_Period_Start_Date__c.month(),im.Time_Period_Start_Date__c.day());
        DateTime endDate = DateTime.newInstance(im.Time_Period_End_Date__c.year(),im.Time_Period_End_Date__c.month(),im.Time_Period_End_Date__c.day());
        dynamicBEIQuery += ' ( ';
        dynamicBEIQuery += ' Start_Date__c >='+startDate.format('yyyy-MM-dd');
        dynamicBEIQuery += ' and ';
        dynamicBEIQuery += ' End_Date__c < = '+endDate.format('yyyy-MM-dd');
        dynamicBEIQuery += ' ) or';
        system.debug('DYNAMIC BEI QUERY' +dynamicBEIQuery);
        
        return dynamicBEIQuery;
    }
    
    public static string generatemainqry()
    {
          // Rahul Commeneted  
        //id dsRTid = ProjectRecordType__c.getValues('MS Upgrades').Record_Type_ID__c;
            id dsRTid = pse__proj__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('MS Upgrades').getRecordTypeId(); 
    
    string mainqry = 'SELECT Start_Date__c, End_Date__c, Part_Number__c,Unitprice, Total_Price_SAP__c, '+
                     'Project__c ,project__r.pse__Project_Manager__r.name, '+
                     'project__r.pse__Opportunity__c ,project__r.pse__Opportunity__r.Bill_To_Name__c, '+
                     'project__r.pse__Opportunity__r.Ship_To_Name__c , '+
                     'project__r.pse__Opportunity__r.Contract_Number__c, '+
                     'project__r.pse__Account__r.name,project__r.pse__Opportunity__r.SAP_Status__c ,'+
                     'project__r.pse__Opportunity__r.Account.name,'
                     +'project__r.pse__Opportunity__r.SAP_Amount__c,'+
                     'project__r.New_Server_Type__c,'+
                     'project__r.pse__Project_Phase__c '+
                     'FROM OpportunityLineItem  '+
                     'where project__r.recordtypeID = \''+dsRTid+'\' and ';
    
    return mainqry;    
    }
    
 
       //----------------------------------------------------------------------------
    
    public static String generateNamingFilter(Invoice_Maker__c im)
    {
        String filterQuery = '';
        String fileName = generateFileName(im);
        filterQuery = ' Name like \''+fileName+'%\' or ';
        system.debug('filterQuery:' + filterQuery);
        return filterQuery;
    }
    
          //----------------------------------------------------------------------------
    
    public static String generateFileName(Invoice_Maker__c invoiceMaker)
    {
        DateTime startDate = DateTime.newInstance(invoiceMaker.Time_Period_Start_Date__c.year(),invoiceMaker.Time_Period_Start_Date__c.month(),invoiceMaker.Time_Period_Start_Date__c.day());
        DateTime endDate = DateTime.newInstance(invoiceMaker.Time_Period_End_Date__c.year(),invoiceMaker.Time_Period_End_Date__c.month(),invoiceMaker.Time_Period_End_Date__c.day());
        String fileName = invoiceMaker.Time_Period_Start_Date__c.year()+'_'+startDate.format('MMMM')+invoiceMaker.Time_Period_Start_Date__c.day()+endDate.format('MMMM')+invoiceMaker.Time_Period_End_Date__c.day()+'_MS';
        return fileName;
    }
 
 }