//**************************************************************
//Class used to Perform Search operation and Find Product button functionality.
//Created By : Reena Acharya
//Creation Date: 12th May 2009
//*****************************************************************
public class ControllerSearch {

//Properties 

public Server__c server{get;set;}
public List<Product_Configuration__c> lstPrdConfig{get;set;}
public List<Product_Platform__c> lstPrdplatform{get;set;}
public List<Product_Database__c> lstPrdDataBase{get;set;}
public List<SelectOption> prdConfigToShow;
public List<SelectOption> prdplatformToShow;
public List<SelectOption> prdDataBaseToShow;
public string selectedPrdConfig{get;set;}
public string selectedPrdPlatForm{get;set;}
public string selectedPrdDataBase{get;set;}
public boolean showResult{get;set;}

//Results exists or not
public boolean prdConfigExists{get;set;}
public boolean prdplatformExists{get;set;}
public boolean prdDataBaseExists{get;set;}



//Constructor
public  ControllerSearch(){
        string serverID = '';
    serverID = ApexPages.currentPage().getParameters().get('id');
    server = new Server__c (id=serverID);
    
    
    //server = new Server__c ();  
    server.Search_Brand__c = ApexPages.currentPage().getParameters().get('Brand');
    server.Search_Release__c = ApexPages.currentPage().getParameters().get('Release');
    server.Search_Product_Name__c = ApexPages.currentPage().getParameters().get('Product');
    showResult = false;
    prdConfigExists =false;
    prdplatformExists=false;
    prdDataBaseExists =false;   
    lstPrdConfig = new List<Product_Configuration__c>();
    lstPrdplatform = new List<Product_Platform__c>();
    lstPrdDataBase = new List<Product_Database__c>();   
}

//Perform Searching Operation

public PageReference doSearch(){
    lstPrdConfig = new List<Product_Configuration__c>();
    lstPrdplatform = new List<Product_Platform__c>();
    lstPrdDataBase = new List<Product_Database__c>();
    showResult = true;
    GetRecordsToShow(); 
    return null;
}


//Perform Save Operation

public PageReference Save(){
    string serverID = '';
    serverID = ApexPages.currentPage().getParameters().get('id');
    string sbrnd = server.Search_Brand__c;
    string srel  = server.Search_Release__c;
    string sProd = server.Search_Product_Name__c;
    server = new Server__c (id=serverID);
    server.Search_Brand__c = sbrnd;
    server.Search_Release__c = srel;
    server.Search_Product_Name__c = sProd;
    
    if(selectedPrdConfig!=null && selectedPrdConfig.trim()!=''){
        server.Product__c = selectedPrdConfig;
        updateServerForConfig();            
    }
   if(selectedPrdPlatForm!=null && selectedPrdPlatForm.trim()!=''){
        server.Product_Platform__c = selectedPrdPlatForm;
        updateServerForPlatForm();  
   }
   if(selectedPrdDataBase!=null && selectedPrdDataBase.trim()!=''){
        server.Product_Database__c = selectedPrdDataBase;
        updateServerForDataBase();
   }    
    update server;  
    return null;
}

//Update Server for production configuration .
public void updateServerForConfig(){
    try{
        Product_Configuration__c pc = new Product_Configuration__c();
        pc = [Select id,Product_Name__c , Brand__c, Release_Value__c from Product_Configuration__c where id=:selectedPrdConfig];
        server.Brand_Text__c = pc.Brand__c;
        server.Release_Text__c = pc.Release_Value__c;
        //Mike Fitz Modified for SAP 11/19/2010
        //server.Product_Text__c = pc.Product_Name__c;        
        server.Product_Text__c = pc.Name;
        //End of Modifications
    }
    catch(Exception ex){}

} 

//Update Server for production platForm .
public void updateServerForPlatForm(){
    try{
        Product_Platform__c pf = new Product_Platform__c();
        pf = [Select id, Platform_Version__c , Platform__c from Product_Platform__c where id=:selectedPrdPlatForm];
        server.Platform_Text__c = pf.Platform__c;
        server.Platform_Version_Text__c = pf.Platform_Version__c;
    }
    catch(Exception ex){}

} 

//Update Server for production DateBase .
public void updateServerForDataBase(){
    try{
        Product_Database__c pDB = new Product_Database__c();
        pDB = [Select id, DataBase_Version__c , DataBase__c from Product_Database__c where id=:selectedPrdDataBase];
        server.Database_Text__c = pDB.DataBase__c;
        server.Database_Version_Text__c = pDB.DataBase_Version__c;
    }
    catch(Exception ex){}

} 

//Perform Save Operation and Redirect to server Page.

public PageReference BackToPage(){
    Save();
    string serverID = '';
    serverID = ApexPages.currentPage().getParameters().get('id');
    PageReference pg = new PageReference('/'+serverID);
    pg.setRedirect(true);
    return pg;
}

//Returns back to Server Page
public PageReference Cancel(){
    string serverID = '';
    serverID = ApexPages.currentPage().getParameters().get('id');
    PageReference pg = new PageReference('/'+serverID);
    pg.setRedirect(true);
    return pg;      
}

//Creates option lists for product configurations to show on UI with Radio buttons.

public List<SelectOption> getPrdConfigToShow(){
     PrdConfigToShow = new List<SelectOption>();     
     for(Product_Configuration__c prdCf : lstPrdConfig ){
       //Mike Fitz Modified for SAP 11/19/2010
       //PrdConfigToShow.add(new SelectOption(prdCf.Id,prdCf.Product_Name__c));
       PrdConfigToShow.add(new SelectOption(prdCf.Id,prdCf.Name));
       //End of Modifications
     }
     return PrdConfigToShow ;         
}
   
//Creates option lists for productin plateform to show on UI with Radio buttons.

public List<SelectOption> getPrdplatformToShow(){
     prdplatformToShow = new List<SelectOption>();
     for(Product_Platform__c prdPtform : lstPrdplatform ){
       prdplatformToShow.add(new SelectOption(prdPtform.Id,prdPtform.platform__c + ' ' + prdPtform.platform_version__c));
     }
     return prdplatformToShow ;
}

//Creates option lists for Product database to show on UI with Radio buttons.
public List<SelectOption> getPrdDataBaseToShow(){
     PrdDataBaseToShow = new List<SelectOption>();
     for(Product_Database__c prdDB : lstPrdDataBase ){
       PrdDataBaseToShow.add(new SelectOption(prdDB.Id, prdDB.database__c + ' ' + prdDB.database_version__c));
     }
     return PrdDataBaseToShow ;
}

//Fetches data on the basis of search criteria.

public void GetRecordsToShow(){
    try{
        String queryForConfig = ' Select id,Name,Product_Name__c from Product_Configuration__c where '+ GetWhereClause('Config');
        String whereForRest =  GetWhereClause('Rest');
        String queryForPlatForm = ' Select id,Name, platform__c, platform_version__c from Product_Platform__c where '+ whereForRest;
        String queryForDataBase = ' Select id,Name, database__c, database_version__c from Product_Database__c where '+ whereForRest;
        lstPrdConfig    = Database.query(queryForConfig);
        lstPrdplatform  = Database.query(queryForPlatForm);
        lstPrdDataBase  = Database.query(queryForDataBase);
        dataExists();
     }
    catch(exception ex){
        lstPrdConfig = new List<Product_Configuration__c>();
    }

}

//Data Exists or not
public void dataExists(){
    if(lstPrdConfig.size()>0)
        prdConfigExists = true;
    else 
        prdConfigExists = false;
    if(lstPrdplatform.size()>0)
        prdplatformExists = true;
    else
        prdplatformExists = false;
    if(lstPrdDataBase.size()>0)
        prdDataBaseExists = true;
    else    
        prdDataBaseExists = false;  
}  

//Fetches column name for product as it is different for Production_configuration__c and Product_platform__c .

public string productColName(string typeFor){
    if(typeFor == 'Config')
        //Mike Fitz Modified for SAP 11/19/2010
        //return ' Product_Name__c';
        return ' Name';
        //End of Modifications
    else
        return ' Product__c';
}

//Fetches column name for Release as it is different for Production_configuration__c and Product_platform__c .

public string releaseColName(string typeFor){
    if(typeFor == 'Config')
        return ' Release_Value__c';
    else
        return ' Release__c';
}

//Create where clause for query on the basis of search criteria.

public string GetWhereClause(string typeFor){   
    string whereclause = '';
    if(server.Search_Brand__c!=null && server.Search_Brand__c.trim()!='')
       whereclause = whereclause+' Brand__c = \''+ server.Search_Brand__c.trim()+'\'' ;
    
    if(server.Search_Product_Name__c!=null && server.Search_Product_Name__c.trim()!=''){
      if(whereclause !='')
        whereclause =whereclause+' And ';
       
        whereclause = whereclause + productColName(typeFor)+' = \''+server.Search_Product_Name__c.trim()+'\'';
    }
    if(server.Search_Release__c!=null && server.Search_Release__c.trim()!=''){
      if(whereclause !='')
        whereclause =whereclause+' And ';
        
        whereclause = whereclause+  releaseColName(typeFor)+' = \''+ server.Search_Release__c.trim()+'\'';
    }
    return whereclause;
}

public List<SelectOption> getBrandsList(){ 
  try{
    List<SelectOption> optionBrands = new List<SelectOption>();
    optionBrands.add(new SelectOption('','- None -'));
    
    for(Brand__c br: [select Name from Brand__c order by Name]) {
      optionBrands.add(new SelectOption(br.Name, br.Name));
    }
    return optionBrands;
  }
  catch(Exception e) {
    system.debug('Exception occured: '+e.getMessage());
  }
  return null;
}

public List<SelectOption> getReleaseList(){ 
  try{
    List<SelectOption> optionReleases = new List<SelectOption>();
    optionReleases.add(new SelectOption('','- None -'));
    String selectedBrand = server.Search_Brand__c;

    for(ProductRelease__c r: [select Release__c from ProductRelease__c where Brand__r.Name =: selectedBrand order by Release__c ]) {
      optionReleases.add(new SelectOption(r.Release__c, r.Release__c));
    }
    
    return optionReleases;
  }
  catch(Exception e) {
    system.debug('Exception occured: '+e.getMessage());
  }
  return null;
}

public List<SelectOption> getProductNameList(){ 
  try{
    List<SelectOption> optionProdNames = new List<SelectOption>();
    optionProdNames.add(new SelectOption('','- None -'));
    
    String selectedRelease = server.Search_Release__c;
    system.debug('selectedBrand: '+selectedRelease );
    //Mike Fitz Modified for SAP 11/19/2010
    //for(Product_Configuration__c pc: [select Product_Name__c from Product_Configuration__c where ProductRelease__r.Release__c =:selectedRelease order by Product_Name__c ]) {
    //  optionProdNames.add(new SelectOption(pc.Product_Name__c, pc.Product_Name__c));
    //}
    for(Product_Configuration__c pc: [select Name from Product_Configuration__c where ProductRelease__r.Release__c =:selectedRelease order by Name ]) {
      optionProdNames.add(new SelectOption(pc.Name, pc.Name));
    }
    //End of Modifications
    system.debug('optionProdNames:'+optionProdNames);
    return optionProdNames;
  }
  catch(Exception e) {
    system.debug('Exception occured: '+e.getMessage());
  }
  return null;
}

}