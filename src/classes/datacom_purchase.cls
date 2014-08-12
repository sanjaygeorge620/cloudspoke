public with sharing class datacom_purchase {
    public string datakey{get;set;}
    public string datatype{get;set;}
    public lead l{get;set;}
    public datacom_purchase(){
        //Data.com KEY
        datakey = nn(ApexPages.currentPage().getParameters().get('rid'));
        //Data.com Type 1 = Account 0 = Contact
        datatype = nn(ApexPages.currentPage().getParameters().get('type'));
        //Lead Recordtype
        string recordtype = ApexPages.currentPage().getParameters().get('RecordType');
        l = new lead();
        
        //Preselect recordtype based on url parameters 
        
        if(!string.isblank(recordtype)) l.RecordTypeid=RecordType;
    }
    
    public map<string,string> recordMap{get;set;}
    public pagereference init(){
        //Should already be purchased before it gets to this point.
        if(DataDotComServices.isOwned(datakey)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.confirm, 'Data.com record has been found.'));
            return executeRedirect();
        }
        return null;
    }    
   
    //Attempt to redirect to the edit page with prepopulated field (See Data.com Mapping Custom Setting)       
    public pagereference executeRedirect(){
        set<Datacom_Mapping__c> setDatacloudCompany = new set<Datacom_Mapping__c>();
        set<Datacom_Mapping__c> setDatacloudContact = new set<Datacom_Mapping__c>();
        set<Datacom_Mapping__c> setDatacloudDandBCompany = new set<Datacom_Mapping__c>();
        set<Datacom_Mapping__c> setCustomStaticParameters = new set<Datacom_Mapping__c>();
        
        for(Datacom_Mapping__c x: Datacom_Mapping__c.getall().values()){
            if(x.Data_com_Object__c.equalsignorecase('DataCloudCompany')){
                setDatacloudCompany.add(x);
            }else if(x.Data_com_Object__c.equalsignorecase('DataCloudContact')){
                setDatacloudContact.add(x);
            }else if(x.Data_com_Object__c.equalsignorecase('DatacloudDandBCompany')){
                setDatacloudDandBCompany.add(x);
            }else if(x.Data_com_Object__c.equalsignorecase('STATIC')){
                setCustomStaticParameters.add(x);
            }
        }
        
        PageReference Pg = new PageReference('/' + Lead.sObjectType.getDescribe().getKeyPrefix() + '/e');
        Pg.getParameters().put('ent', 'Lead');
        Pg.getParameters().put('RecordType', l.recordtypeid);
        Pg.getParameters().put('nooverride', '1');
        Pg.getParameters().put('retURL', '/' + Lead.sObjectType.getDescribe().getKeyPrefix() + '/o');
        for(Datacom_Mapping__c X: setCustomStaticParameters){
             Pg.getParameters().put(x.Layout_ID__c, x.Data_com_Field__c);
         }
        Pg.setRedirect(true);
        
        recordMap = new map<string,string>();
        /* ACCOUNTS */
        if(datatype=='1'){
                
                boolean containsSICCODE = false; //need for SIC QUERY 
                //DataCloudCompany
                 string SOQL = ' select id ';
                 for(Datacom_Mapping__c X: setDatacloudCompany){
                     if(!x.Data_com_Field__c.equalsignorecase('id'))
                         SOQL += ', ' + x.Data_com_Field__c;
                     
                     //Conditional Logic to Query the SIC code from SIC_to_Lexmark_Verticals__c table
                     if(x.Data_com_Field__c.equalsignorecase('Sic')){
                        containsSICCODE = true;
                     }
                 }
                 
                 if(!containsSICCODE) //Try to find the LEXMARK VERTICAL
                     SOQL += ', Sic';
                 
                 SOQL += ' from DatacloudCompany where CompanyId = :datakey limit 1';
                 system.debug('SOQL: ' + SOQL);
                 DatacloudCompany dcc = Database.query(SOQL);
                 
                 for(Datacom_Mapping__c X: setDatacloudCompany){
                     recordMap.put(x.Data_com_Field__c, nn(string.valueof(dcc.get(x.Data_com_Field__c)))); 
                     if(x.Data_com_Field__c!=null && x.Data_com_Field__c.containsignorecase('country')){
                         Pg.getParameters().put(x.Layout_ID__c, convertDataDotComCountrytoMDMCountry(nn(string.valueof(dcc.get(x.Data_com_Field__c)))));
                     }else{
                         Pg.getParameters().put(x.Layout_ID__c, nn(string.valueof(dcc.get(x.Data_com_Field__c))));
                     }
                 }
                 
                //DataCloudDandBCompany
                 SOQL = ' select id ';
                 for(Datacom_Mapping__c X: setDatacloudDandBCompany){
                      if(!x.Data_com_Field__c.equalsignorecase('id'))
                          SOQL += ', ' + x.Data_com_Field__c;
                 }
                 SOQL += ' from DatacloudDandBCompany where CompanyId = :datakey limit 1';
                 system.debug('SOQL: ' + SOQL);
                 DatacloudDandBCompany dcdb = Database.query(SOQL);
                 
                 for(Datacom_Mapping__c X: setDatacloudDandBCompany){
                     recordMap.put(x.Data_com_Field__c, nn(string.valueof(dcdb.get(x.Data_com_Field__c)))); 
                     if(x.Data_com_Field__c!=null && x.Data_com_Field__c.containsignorecase('country')){
                         Pg.getParameters().put(x.Layout_ID__c, convertDataDotComCountrytoMDMCountry(nn(string.valueof(dcdb.get(x.Data_com_Field__c)))));
                     }else{
                         Pg.getParameters().put(x.Layout_ID__c, nn(string.valueof(dcdb.get(x.Data_com_Field__c))));
                     }
                 }
                 
                  //Query for SIC Code
                 for(SIC_to_Lexmark_Verticals__c x: [select id, Lexmark_Vertical__c, Lexmark_Sub_Vertical__c from SIC_to_Lexmark_Verticals__c where SIC_4__c=:dcc.Sic limit 1]){
                     Pg.getParameters().put('00Ni0000001uvHE', nn(x.Lexmark_Vertical__c));
                     Pg.getParameters().put('00Ni0000004whhi', nn(x.Lexmark_Sub_Vertical__c));
                 }
             return Pg;    

        /* CONTACTS */
        } else if(datatype=='0'){
             
                 //DataCloudContact
                 boolean containsCompanyid = false; //need for DNB Call
                 string SOQL = ' select id ';
                 for(Datacom_Mapping__c X: setDatacloudContact){
                      if(!x.Data_com_Field__c.equalsignorecase('id'))
                          SOQL += ', ' + x.Data_com_Field__c;
                          
                     if(x.Data_com_Field__c.equalsignorecase('Companyid')){
                        containsCompanyid = true;
                     }
                 }
                 
                 if(!containsCompanyid)
                     SOQL += ', companyid';
                     
                 SOQL += ' from DatacloudContact where ContactId = :datakey limit 1';
                 system.debug('SOQL: ' + SOQL);
                 DatacloudContact dcc = Database.query(SOQL);
                 
                 for(Datacom_Mapping__c X: setDatacloudContact){
                     recordMap.put(x.Data_com_Field__c, nn(string.valueof(dcc.get(x.Data_com_Field__c)))); 
                     if(x.Data_com_Field__c!=null && x.Data_com_Field__c.containsignorecase('country')){
                         Pg.getParameters().put(x.Layout_ID__c, convertDataDotComCountrytoMDMCountry(nn(string.valueof(dcc.get(x.Data_com_Field__c)))));
                     }else{
                         Pg.getParameters().put(x.Layout_ID__c, nn(string.valueof(dcc.get(x.Data_com_Field__c))));
                     }
                 }
                 
                boolean containsSICCODE = false; //need for SIC QUERY 
                //DataCloudDandBCompany
                 SOQL = ' select id ';
                 for(Datacom_Mapping__c X: setDatacloudDandBCompany){
                      if(!x.Data_com_Field__c.equalsignorecase('id'))
                         SOQL += ', ' + x.Data_com_Field__c;
                     
                     //Conditional Logic to Query the SIC code from SIC_to_Lexmark_Verticals__c table
                     if(x.Data_com_Field__c.equalsignorecase('PrimarySic')){
                        containsSICCODE = true;
                     }
                 }
                 
                 if(!containsSICCODE)
                     SOQL += ', PrimarySic';
                     
                 SOQL += ' from DatacloudDandBCompany where CompanyId = \'' + dcc.Companyid + '\' limit 1';
                 system.debug('SOQL: ' + SOQL);
                 DatacloudDandBCompany dcdb = Database.query(SOQL);
                 
                 for(Datacom_Mapping__c X: setDatacloudDandBCompany){
                     recordMap.put(x.Data_com_Field__c, nn(string.valueof(dcdb.get(x.Data_com_Field__c)))); 
                     if(x.Data_com_Field__c!=null && x.Data_com_Field__c.containsignorecase('country')){
                         Pg.getParameters().put(x.Layout_ID__c, convertDataDotComCountrytoMDMCountry(nn(string.valueof(dcdb.get(x.Data_com_Field__c)))));
                     }else{
                         Pg.getParameters().put(x.Layout_ID__c, nn(string.valueof(dcdb.get(x.Data_com_Field__c))));
                     }
                     
                 }
                 
                 //Query for SIC Code
                 for(SIC_to_Lexmark_Verticals__c x: [select id, Lexmark_Vertical__c, Lexmark_Sub_Vertical__c from SIC_to_Lexmark_Verticals__c where SIC_4__c=:dcdb.PrimarySic limit 1]){
                     Pg.getParameters().put('00Ni0000001uvHE', nn(x.Lexmark_Vertical__c));
                     Pg.getParameters().put('00Ni0000004whhi', nn(x.Lexmark_Sub_Vertical__c));
                 }
                 
             return Pg; 
    
        }
        return null;       
    }
    
   //===============================================================================================
   // Check values for NULL
   //===============================================================================================
        public string nn(string v){ //non null
            if(v==null)
                return '';
            return (v);
        }
        public string nn(integer v){ //non null
            if(v==null)
                return '';
            return string.valueof(v);
        }
        public string nn(decimal v){ //non null
            if(v==null)
                return '';
            return string.valueof(v);
        }
        
   //===============================================================================================
   // Country Mapping
   //===============================================================================================

    public string convertDataDotComCountrytoMDMCountry(string datadotcomcountry){
        
        if(Data_com_MDM__c.getValues(datadotcomcountry)!=null){
            return Data_com_MDM__c.getValues(datadotcomcountry).MDM_Country__c;
        }else{
            return datadotcomcountry;
        }
    }
   
}