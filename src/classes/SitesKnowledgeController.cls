/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
Description: Business requirement to have all filters within url query parameters (for google analytics) required hard coding the filters.
             This controller passes variables back and forth to the page to build query parameters when reloading the page.
*/


//-------------------------------------------------------------------------------
// Knowledge Variables
//-------------------------------------------------------------------------------
Public with sharing class SitesKnowledgeController  extends SitesController {
    //Static and transient variables do not get stored within page state 
    
    
    //Default Values   
    public static string KB_SORTBY {get {return 'mostViewed';} set; } 
    public static string KB_PAGE_SIZE {get {return '200';} set; }
    public static string KB_CURRENT_PAGE_NUMBER {get {return '1';} set; }
    
    //Variables: Search 
    static final string DEFAULT_SEARCH = label.KB_Default_Search_Text;
    public string KB_KEYWORD {get; set;}
    public string KEYWORDS {get; set;}
   
    //Variables: DataCategories
    public string RELEASE {get; set;}
    public string RELEASE_TITLE {get; set;}
    public string PRODUCT {get; set;}
    public string PRODUCT_TITLE {get; set;}
    public string KB_CATEGORIES {get; set;} 
    
    //Variables: Article Types
    public string KB_ARTICLETYPES {get; set; }
    public string PRODUCT_HELP {get; set;} 
    public string SUPPORT_ARTICLES {get; set;} 
    public string TECHNICAL_OVERVIEWS{get; set;}     
    
//-------------------------------------------------------------------------------
// Knowledge Constructor
//-------------------------------------------------------------------------------
    
    public SitesKnowledgeController(){
        FilterSearch();
        FilterDataCategories();
        FilterArticleTypes();
       
     }

//-------------------------------------------------------------------------------
// Page Filtering
//-------------------------------------------------------------------------------     

    public void FilterSearch(){
        string qkeyword = ApexPages.currentPage().getParameters().get('s');
        if (qkeyword!=null && qkeyword!=''){ //query parameters
            //prevent hackers
            KEYWORDS=String.escapeSingleQuotes(qkeyword);
            KB_KEYWORD = KEYWORDS;
        } else{ //Return to default
            KEYWORDS=DEFAULT_SEARCH;
            KB_KEYWORD = '';//setting kb search to blank
            }
    }
    
    public void FilterDataCategories(){
     //Filters
       //Product
        string qProduct = ApexPages.currentPage().getParameters().get('prod'); //actual filter
        
        string qProducttitle = ApexPages.currentPage().getParameters().get('prodtitle'); //for displaying the filter name
        
        //prevent hackers
        if (qProduct!=null){
            PRODUCT=String.escapeSingleQuotes(qProduct);}
            System.debug('PRODUCT------------'+PRODUCT);
        if (qProducttitle!=null){
            PRODUCT_TITLE=String.escapeSingleQuotes(qProducttitle);}
        System.debug('PRODUCT_title------------'+PRODUCT_TITLE);
        
        //Release
        string qRelease = ApexPages.currentPage().getParameters().get('rel'); //actual filter
        string qReleasetitle = ApexPages.currentPage().getParameters().get('reltitle');  //for displaying the filter name      
        
        //prevent hackers    
        if (qRelease!=null){
            RELEASE=String.escapeSingleQuotes(qRelease);}
        if (qReleasetitle!=null){
            RELEASE_TITLE=String.escapeSingleQuotes(qReleasetitle);}        
        
        
        //Category filter
        boolean bRelease =(RELEASE!='' && RELEASE!=null);//simple condition statement
        boolean bProduct =(PRODUCT!='' && PRODUCT!=null);//simple condition statement
        if (bProduct && bRelease){ //concatenate both
            KB_CATEGORIES='Release:'+RELEASE+',Product:'+PRODUCT;}
        else if (bProduct){ //just product
            KB_CATEGORIES='Product:'+PRODUCT;} 
        else if (bRelease){ //just release
            KB_CATEGORIES='Release:'+RELEASE;}
        else{
            KB_CATEGORIES='';}   //none 
   
    }
    
    public void FilterArticleTypes(){
        //KB_ARTICLETYPES
        //Article Types
        PRODUCT_HELP = ApexPages.currentPage().getParameters().get('producthelp');
        SUPPORT_ARTICLES = ApexPages.currentPage().getParameters().get('supportarticle');
        TECHNICAL_OVERVIEWS = ApexPages.currentPage().getParameters().get('technicaloverview');
        
        //If all checkboxes get unchecked... recheck them
        if ((PRODUCT_HELP==null || PRODUCT_HELP=='') && 
            (SUPPORT_ARTICLES ==null || SUPPORT_ARTICLES =='') && 
            (TECHNICAL_OVERVIEWS==null || TECHNICAL_OVERVIEWS=='')
           ){
            PRODUCT_HELP='true';
            SUPPORT_ARTICLES='true';
            TECHNICAL_OVERVIEWS='true';
            KB_ARTICLETYPES='';//set to all
        }
        else
        {
            //Check each filter one by one 
            KB_ARTICLETYPES ='';
            if (PRODUCT_HELP!=null && PRODUCT_HELP!=''){
                KB_ARTICLETYPES=concatenateType(KB_ARTICLETYPES,'ProductHelp__kav');
                }
            if (SUPPORT_ARTICLES !=null && SUPPORT_ARTICLES!=''){
                KB_ARTICLETYPES=concatenateType(KB_ARTICLETYPES,'Support_Articles__kav');
                }
            if (TECHNICAL_OVERVIEWS!=null && TECHNICAL_OVERVIEWS!=''){
                KB_ARTICLETYPES=concatenateType(KB_ARTICLETYPES,'Technical_Overview__kav');
                }    
        
        }
    }

     
     //adding comma in between Article Types
     private string concatenateType(string oldVal, string newVal){
         string articletype;
         if (oldVal!=null && oldVal!=''){
              articletype =oldVal+', '+newVal;
            }
         else{
             //just add the new one
             articletype=newVal;
         }        
         return articletype;
     }     
    
    public list<Perceptive_Site_Content__c> getWidgetKnowledgeSpotlight(){
        return getWidget('KnowledgeSpotlight');}

//-------------------------------------------------------------------------------
// Action Filtering
//-------------------------------------------------------------------------------     
    public pagereference doSearch(){
        System.debug('SEARCH: '+KEYWORDS);
        KB_KEYWORD=KEYWORDS;
     return reloadPage();   
    }
    public void runFilter(){
        System.debug('FILTER');
        string filter = Apexpages.currentPage().getParameters().get('filter');
        System.debug('filter---------------'+ filter);
        string filtertype = Apexpages.currentPage().getParameters().get('filtertype');
        System.debug('filtertype--------------'+filtertype);
        string filtertitle = Apexpages.currentPage().getParameters().get('filtertitle');
        System.debug('filtertitle------'+filtertitle);
        if (filtertype=='product'){
            PRODUCT=filter;
            PRODUCT_TITLE=filtertitle;
        }else if (filtertype=='release'){
            RELEASE=filter;
            RELEASE_TITLE =filtertitle;
        }
        
     
    }
    public pagereference doFilter(){
        System.debug('FILTER');
        string filter = Apexpages.currentPage().getParameters().get('filter');
        System.debug('filter---------------'+ filter);
        string filtertype = Apexpages.currentPage().getParameters().get('filtertype');
        System.debug('filtertype--------------'+filtertype);
        string filtertitle = Apexpages.currentPage().getParameters().get('filtertitle');
        System.debug('filtertitle------'+filtertitle);
        if (filtertype=='product'){
            PRODUCT=filter;
            PRODUCT_TITLE=filtertitle;
        }else if (filtertype=='release'){
            RELEASE=filter;
            RELEASE_TITLE =filtertitle;
        }
        
     return reloadPage();  
    }
    
    public pagereference doUnFilter(){
        System.debug('UNFILTER');
        string filtertype = Apexpages.currentPage().getParameters().get('unfiltertype');
        
        if (filtertype=='product'){
            PRODUCT='';
            PRODUCT_TITLE='';
        }else if (filtertype=='release'){
            RELEASE='';
            RELEASE_TITLE ='';
        }else if (filtertype=='PRODUCT_HELP'){
            PRODUCT_HELP = toggleValue(PRODUCT_HELP);
        }else if (filtertype=='SUPPORT_ARTICLES'){
            SUPPORT_ARTICLES= toggleValue(SUPPORT_ARTICLES);
        }else if (filtertype=='TECHNICAL_OVERVIEWS'){
            TECHNICAL_OVERVIEWS= toggleValue(TECHNICAL_OVERVIEWS);    
        } 
        
     return reloadPage();  
    }
    
   
   private  string toggleValue(string currentValue){
       if(currentValue=='true'){
           return '';
       } else{
           return 'true';
       }
   } 
   
   //universal page reload
   private pagereference reloadPage(){
       PageReference Pg;
       if(SITE_NAME == 'ChannelPortalSite'){
           Pg = page.knowledge_Partner;
       }else {
           Pg = page.knowledge;
       }
       Pg.getParameters().put('s', KB_KEYWORD); //search
       Pg.getParameters().put('rel', RELEASE); //release title
       Pg.getParameters().put('reltitle', RELEASE_TITLE); //release
       Pg.getParameters().put('prod', PRODUCT); //product
       Pg.getParameters().put('prodtitle', PRODUCT_TITLE); //product Title
        
       Pg.getParameters().put('producthelp', PRODUCT_HELP); //Type
       Pg.getParameters().put('supportarticle', SUPPORT_ARTICLES); //Type
       Pg.getParameters().put('technicaloverview', TECHNICAL_OVERVIEWS); //Type
        
       Pg.setRedirect(true);
     return Pg;   
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
     
    
    
}