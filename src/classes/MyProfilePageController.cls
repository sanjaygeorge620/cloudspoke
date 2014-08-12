/**
 * An apex class that keeps updates of a portal user in sync with its corresponding contact.
   Guest users are never able to access this page.
 */
global class MyProfilePageController Extends SitesController{

    private User user;
    private boolean isEdit = false;
    
    
   
    public list<ProductFamilywrapper> PFlst{get;set;}
    public list<ProductFamilywrapper> PFlst1{get;set;}
    public List<personalization__c> personRec {get;set;}
  //  public boolean withRecDisplay{get;set;}
 //   public boolean withOutRecDisplay{get;set;}    
    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
       // withRecDisplay = False;
      //  withOutRecDisplay = False;
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,From__c,To__c,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email,LX_Region__c,LX_Geo__c,LX_Country__c
                FROM User
                WHERE id = :UserInfo.getUserId()];
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
      getDetails();    
    }
    public pagereference   getDetails()
    {
        personRec = [select Id,Name,User__c,Product_Family_Name__c  from personalization__c where User__c =: UserInfo.getUserId() limit 1];
        system.debug('****personRec ******'+personRec.size());
        if(personRec.size() >0)
        {
        //   withRecDisplay = True;
           Map<String,ProductFamilywrapper> PFMap = New Map<String,ProductFamilywrapper>();
           
             PFlst = new list<ProductFamilywrapper>();
            
            list<SelectOption> options = new list<SelectOption>();
            // Get the object type of the SObject.
            Schema.sObjectType objType = personRec[0].Id.getSObjectType();
            system.debug('****objType******'+objType);
            // Describe the SObject using its object type.
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();      
            system.debug('****objDescribe ******'+objDescribe );
            // Get a map of fields for the SObject
            map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            // Get the list of picklist values for this field.
            
            system.debug('****personRec[0].Id******'+personRec[0].Id);
            
            
            
            list<Schema.PicklistEntry> values = fieldMap.get('Product_Family_Name__c').getDescribe().getPickListValues();
            system.debug('****values ******'+values );
            
            
             Map<String,DescribeDataCategoryGroupStructureResult> DCL = New  Map<String,DescribeDataCategoryGroupStructureResult>();
                 for(DescribeDataCategoryGroupStructureResult x: KnowledgeDataCategoryHelper.getDescribeDataCategoryGroupStructureResults()){
                        DCL.put(x.getname(), x);
                }
               DescribeDataCategoryGroupStructureResult x = DCL.get('Product');
                 for(DataCategory y : x.getTopCategories()){
                    system.debug('y.getName: '+y.getName());    
                    for(DataCategory z : y.getChildCategories()){
                        system.debug('z.getLabel: '+z.getLabel());    
                        options.add(new SelectOption(z.getLabel(), z.getLabel()));
                        ProductFamilywrapper PFWorkFlowRule = new ProductFamilywrapper();
                        if(personRec[0].Product_Family_Name__c <> Null)
                        {
                            if(personRec[0].Product_Family_Name__c.Contains(z.getLabel()))
                            {
                                PFWorkFlowRule.isChecked = True ;
                            }else{
                                PFWorkFlowRule.isChecked = False;
                            }   
                        }    
                        PFWorkFlowRule.PfamilyName = z.getLabel(); 
                        PFMap.put(z.getLabel(),PFWorkFlowRule);
                   }    
                }
                for(ProductFamilywrapper WrapIterate : PFMap.Values()){
                    PFlst.add(WrapIterate);
                }  
                PFlst.sort();
           }else{
               // withOutRecDisplay = True;
                Map<String,ProductFamilywrapper> PFMap = New Map<String,ProductFamilywrapper>();
                
                PFlst1 = new list<ProductFamilywrapper>();
                list<selectOption> Options = new list<selectOption>();
                
                 Map<String,DescribeDataCategoryGroupStructureResult> DCL = New  Map<String,DescribeDataCategoryGroupStructureResult>();
                 for(DescribeDataCategoryGroupStructureResult x: KnowledgeDataCategoryHelper.getDescribeDataCategoryGroupStructureResults()){
                        DCL.put(x.getname(), x);
                }
               DescribeDataCategoryGroupStructureResult x = DCL.get('Product');
                 for(DataCategory y : x.getTopCategories()){
                    system.debug('y.getName: '+y.getName());    
                    for(DataCategory z : y.getChildCategories()){
                        system.debug('z.getLabel: '+z.getLabel());    
                        options.add(new SelectOption(z.getLabel(), z.getLabel()));
                        ProductFamilywrapper PFWorkFlowRule = new ProductFamilywrapper();
                           
                        PFWorkFlowRule.PfamilyName = z.getLabel(); 
                        PFMap.put(z.getLabel(),PFWorkFlowRule);
                   }    
                }
                for(ProductFamilywrapper WrapIterate : PFMap.Values()){
                    PFlst1.add(WrapIterate);
                }
               PFlst1.sort();   
           } 
           return null;
    }
    
    global class ProductFamilywrapper implements Comparable
    {
        public boolean isChecked{get;set;}
        public String PfamilyName{get;set;}
        Public List<String> PfamilyPName{get;set;}
        global  ProductFamilywrapper()
        {
            isChecked = False;
            PfamilyPName = new List<String>();
        }
        
        global Integer compareTo(Object compareTo) {
        
            // Cast argument to AccountHistoryWrapper
            ProductFamilywrapper wrpcls = (ProductFamilywrapper)compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (PfamilyName> wrpcls.PfamilyName) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (PfamilyName < wrpcls.PfamilyName) {
                // Set return value to a negative value.
                returnValue = -1;
            }
            
            return returnValue;     
        }
    }
    
    
    public Boolean getIsEdit() {
        return isEdit;
    }
    
    public void edit() {
        isEdit=true;
    }    
    
    public void save() {
     if (user.contact != null) {              
            setContactFields(user.contact);
        }
        
        try {
        system.debug('*************************i am in****'+user.localesidkey);
            user.LX_Region__c = 'AP' ;
            user.LX_Geo__c = 'AP' ;
            user.LX_Country__c = 'India';
            update user;
             system.debug('************************after***'+user.localesidkey);
            if (user.contact != null) { 
                update user.contact;
            }
            isEdit=false;
        } catch(DmlException e) {
             system.debug('*************************error***'+e);
            ApexPages.addMessages(e);
        }
    String PfamilyVal ='';
  //   personRec = [select Id,Name,User__c,Product_Family_Name__c  from personalization__c where User__c =: UserInfo.getUserId() limit 1];
    if(personRec.size() >0)
    {
        for(ProductFamilywrapper WrapIterate : PFlst){
            if(WrapIterate.isChecked == True)
            {
                PfamilyVal  = PfamilyVal + WrapIterate.PfamilyName+';';
            }
            personRec[0].Product_Family_Name__c = PfamilyVal;
        }
        update personRec[0];
     }else{
        personalization__c popWin = new personalization__c();
        popWin.User__c =  UserInfo.getUserId();
        popWin.filtertype__c = 'release';
        for(ProductFamilywrapper pfIterate : PFlst1)
        {
            if(pfIterate.isChecked == True)
            {
                PfamilyVal  = PfamilyVal + pfIterate.PfamilyName+';';
            }
        }
        System.debug('PfamilyVal-----'+PfamilyVal);
        if(PfamilyVal <> '')
        {
            popWin.Product_Family_Name__c = PfamilyVal   ;
            upsert popWin;   
        }    
         
     } 
     PFlst = new List<ProductFamilywrapper>();
     PFlst.Clear(); 
     PFlst1 = new List<ProductFamilywrapper>();
     PFlst1.Clear(); 
     getDetails();
       
    }
     
    
    
       
    public static String displayGldbr{get;set;}    
    public static personalization__c SITE_PERSONALIZATION{
         get{
             
             if(SITE_PERSONALIZATION==null){
                 list<Personalization__c> p = [select Name, Product_Family_Name__c  from personalization__c where User__c =: UserInfo.getUserId()];
                 if(p.size()>0){
                    SITE_PERSONALIZATION = p[0];
                    if(p[0].Product_Family_Name__c <> NULL )
                    {
                        displayGldbr = 'Block';
                    }else{
                         displayGldbr = 'none';
                    }    
                 }else{ 
                    SITE_PERSONALIZATION = new personalization__c(user__c = UserInfo.getUserId());
                    displayGldbr = 'none';
                 }   
             }
             return SITE_PERSONALIZATION;
         }
         set{}
      }
         
         
    public static map<string, list<DataCategory>> getProductCategories(){
        return getCategories('Product');
    }
    public static map<string, list<DataCategory>> getReleaseCategories(){
        return getCategories('Release');
    }
    
    public static map<string, list<DataCategory>> getCategories(string CategoryName){        
        set<string> ProductFamilies = new set<string>();
        //Check Personalization Families
        if(SITE_PERSONALIZATION.Product_Family_Name__c!=null){
            list<string> p = new list<string>();
            if(SITE_PERSONALIZATION.Product_Family_Name__c.contains(';')){
                p = SITE_PERSONALIZATION.Product_Family_Name__c.split(';');
            }else{
                p.add(SITE_PERSONALIZATION.Product_Family_Name__c);
            }
            ProductFamilies.addall(p);
        }
        
        map<string, list<DataCategory>> Cats = new map<string, list<DataCategory>>();
        DescribeDataCategoryGroupStructureResult x = KnowledgeDataCategoryHelper.MapDataCategory.get(CategoryName);
                for(DataCategory y : x.getTopCategories()){
                for(DataCategory z : y.getChildCategories()){
                    if(ProductFamilies.size()==0 || ProductFamilies.Contains(z.getLabel()))
                        Cats.put(z.getName(), z.getChildCategories()); 
                }    
            }

    return Cats;
    }
     
    
    public PageReference changePassword() {
        
      //  PageReference pr = new PageReference('https://lexmark--c.na15.visual.force.com/apex/ChangePassword?returnUrl=/apex/MyProfilePage');
      //  return pr;
       return Page.ChangePassword;
    }
    
    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,From__c,To__c,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
    }
    
    private void setContactFields(Contact c) {
        c.title = user.title;
        c.firstname = user.firstname;
        c.lastname = user.lastname;
        c.email = user.email;
        c.phone = user.phone;
        c.mobilephone = user.mobilephone;
        c.fax = user.fax;
        c.mailingstreet = user.street;
        c.mailingcity = user.city;
        c.mailingstate = user.state;
        c.mailingpostalcode = user.postalcode;
        c.mailingcountry = user.country;
    }
    
    public void callSetContactFields(Contact c){
        setContactFields(c);
    }


}