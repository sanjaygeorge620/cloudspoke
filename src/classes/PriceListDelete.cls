Public class PriceListDelete 
{
	public list<SelectOption> Config_options {get;set;}
    public list<SelectOption> page_size {get;set;}   
    public string sQuery {get; set;}
    public string sQuery_static {get; set;}    
    public integer pag_Size {get; set;}
    public String Selected_Config {get; set;}
    public String selectedItem{get;set;}
    public string Opp_id {get;set;}
    public List<LX_Opportunity_Pricelist_Product__c> Pricelist_prodList {get;set;}
    public boolean noData {get;set;}    
    List<LX_Opportunity_Pricelist_Product__c> LPPS {get; set;} 
    public list<wRecord> records {get;set;}
    public Set<Id> selectedIds {get;set;}    
    public set<String> configset {get;set;}
    

    public PriceListDelete(ApexPages.StandardController controller) 
    {
		configset = new set<String>();
		Config_options = new list<SelectOption>();     
		system.debug('CLEARING Selected ID Set');
		this.selectedIds = new Set<ID>();     
		Pricelist_prodList = new List<LX_Opportunity_Pricelist_Product__c>();
		LPPS = new List<LX_Opportunity_Pricelist_Product__c>();
		Selected_Config = '[All]';    
		page_size = new list<SelectOption>();    
		pag_Size = 10;
		records = new list<wRecord>();
		
		Opp_id = Apexpages.currentPage().getParameters().get('OppId');
		
		if(!String.isBlank(Opp_id))    
		{
		  sQuery = 'Select Parent_ID__c,CurrencyIsoCode,LX_Opportunity__c,LX_Part_Number__c,Quantity__c,Part_Type__c,LX_Product__c,LX_Product__r.name,Product_Line__c,LX_Sales_Price__c from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c = \''+Opp_id+'\'';      
		  sQuery_static = sQuery;   
		  initialize();                
		}
	}
  
    public void initialize()
    {    
		sQuery = '';
		sQuery = sQuery_static;    
		LPPS.clear();
		configset.clear();
		records.clear();
		Pricelist_prodList.clear();
		Config_options.clear();
		
		Pricelist_prodList = [Select Parent_ID__c,LX_Opportunity__c,LX_Part_Number__c,Quantity__c,Part_Type__c,LX_Product__c,Product_Line__c,LX_Sales_Price__c,LX_Product__r.Name 
								from LX_Opportunity_Pricelist_Product__c where LX_Opportunity__c =: Opp_id and Parent_ID__c != '' order by Parent_ID__c, LX_Product__r.Name asc];
		   
		Set<String> configPrinterIdSet = new Set<String>();
		Set<String> configOtherIdSet = new Set<String>();
		for(LX_Opportunity_Pricelist_Product__c Lp : Pricelist_prodList)
		{
			if(null!=Lp.Product_Line__c && Lp.Product_Line__c!='Printers')
				configOtherIdSet.add(Lp.Parent_ID__c);
			if(null!=Lp.Product_Line__c && Lp.Product_Line__c=='Printers'){
				configPrinterIdSet.add(Lp.Parent_ID__c);
				configPrinterIdSet.add(Lp.Parent_ID__c + (null!=Lp.LX_Product__r.Name && Lp.Product_Line__c=='Printers'?' - ' +(Lp.LX_Product__r.Name).substring(0,(Lp.LX_Product__r.Name).indexOf(' ')):''));
			}
		}

		for(String config: configOtherIdSet){
			if(configPrinterIdSet.contains(config)){
				configPrinterIdSet.remove(config);
				system.debug('******************** contains - IF: '+ config + '\t');
			} else {
				configPrinterIdSet.add(config);
				system.debug('******************** contains - ELSE: '+ config + '\t');
			}
		}
		
        List<String> configList = new List<String>();
        configList.Addall(configPrinterIdSet); //configSet
        configList.sort();
        
        /*for(LX_Opportunity_Pricelist_Product__c Lp : Pricelist_prodList)                      
    	{
			configset.add(Lp.Parent_ID__c + (null!=Lp.LX_Product__r.Name && Lp.Product_Line__c=='Printers'?' - ' +(Lp.LX_Product__r.Name).substring(0,(Lp.LX_Product__r.Name).indexOf(' ')) + ' :' + Lp.LX_Product__c:''));  // US4175
		} 
		
        List<String> configList = new List<String>();
        configList.Addall(configSet);
        configList.sort();
        */  
		if(!configList.isEmpty()) // US4175
		{
			for(String s : configList)
            {
                string value = '';
                string label = '';
				if(null!=s && ''!=s && s.indexof(' -')!=-1){
                    value = s.substring(0,s.indexof(' -'));// + s.substring(s.indexof(' :'), s.length());
                    label = 'Configuration - '+  (s.indexOf(' :')!=-1?s.substring(0,s.indexOf(' :')):s);
				}else{ 
					value = s;
                    label = 'Configuration - '+ s;
                }
                value = '\''+value+'\'';
                Config_options.add(new SelectOption(value,label));
				//Config_options.sort();
            }
		} 
		
		string filter = '';
		Selected_Config = Selected_Config.substring(1,Selected_Config.length()-1);
		if(Selected_Config == 'ALL' || Selected_Config == '')
        {
			filter = '';        
        } else { // US4175
      		String Selected_ConfigId = '';
            //String Selected_ProductId = '';
            //String filterFlag = '';
            if(null!=Selected_Config && ''!=Selected_Config && Selected_Config.indexOf(',')!=-1){
                for(String sel : Selected_Config.split(',')){
                    if(sel.indexOf(' :')!=-1){
                        sel = sel.replaceAll('\'', '').trim();
                        Selected_ConfigId+=',\''+sel.substring(0,sel.indexof(':'))+'\'';
                        // Selected_ProductId+= ',\''+sel.substring(sel.indexOf(' :')+2, sel.length())+'\'';
                       /* if(filterFlag=='')
                            filterFlag = ' AND '; */
                    }else{
                        sel = sel.replaceAll('\'', '').trim();
                        Selected_ConfigId+= ',\''+sel+'\'';
                       // filterFlag = ' OR ';
                    }
                }
                Selected_ConfigId = Selected_ConfigId.replaceFirst(',', '');
				// Selected_ProductId = Selected_ProductId.replaceFirst(',', '');
            } else if(Selected_Config.indexOf(' :')!=-1 && Selected_Config.length()>0) {
                String sel = Selected_Config.replaceAll('\'', '').trim();
                Selected_ConfigId+= '\''+sel.substring(0,sel.indexof(' :'))+'\'';
                //Selected_ProductId+= '\''+sel.substring(sel.indexOf(' :')+2, sel.length())+'\'';
                //filterFlag = ' AND ';
            } else {
                Selected_ConfigId = Selected_Config;
            }
			
			filter = ' and Parent_ID__c in (' + Selected_ConfigId + ')' ;
     		/*if(''!=Selected_ProductId && Selected_ProductId.length()>0){
         		if(Selected_ConfigId!='')
            		filter = ' AND LX_Product__c IN (' + Selected_ProductId + ')';
        		else {
          			if(filterFlag.length()>0 && filterFlag == ' OR ')
            			filter = ' and (Parent_ID__c in (' + Selected_ConfigId + ') AND Product_Line__c!=\'Printers\' ) OR LX_Product__c IN (' + Selected_ProductId + '))'; 
          			else
            			filter = ' and (Parent_ID__c in (' + Selected_ConfigId + ') AND Product_Line__c!=\'Printers\' ) AND LX_Product__c IN (' + Selected_ProductId + '))'; 
        		}
      		}else 
            	filter = ' and Parent_ID__c in (' + Selected_ConfigId + ')' ; //and Product_Line__c!=\'Printers\'';
			*/
    	} 
        // filter = ' and Parent_ID__c in (' + Selected_ConfigId + ')' ; //and Product_Line__c!=\'Printers\'';
        sQuery = sQuery_static + filter;
        system.debug('********- single value selected' + sQuery);
		
		LPPS = Database.Query(sQuery);
		integer i = 1;    
		for(LX_Opportunity_Pricelist_Product__c x : LPPS)
		{
			//records.add(new wRecord(x.Parent_ID__c,  x.LX_Opportunity__c, x.LX_Part_Number__c, x.Part_Type__c, x.LX_Product__c, x.LX_Product__r.name, x.Product_Line__c, x.LX_Sales_Price__c ));
			records.add(new wRecord(x,i));
			i = i + 1;
		}
	}
  
  Public void doSelectItemR()
  {
    this.selectedIds.add(ID.Valueof(this.selectedItem));
    this.selectedItem = '';
  }
  
  public pagereference backMethod()
  {
    Pagereference pg =  new Pagereference('/'+Opp_id); 
    pg.setRedirect(true);
    return pg;
  }
  
  Public void preSelect()
  {
    for(wRecord wr : records)
    {
      system.debug('---------------------ADD-----------------');
      if(wr.selected && wr.isCurrentPage)
      {
        selectedIds.add(wr.lpp.id); 
      }else{
        if(wr.isCurrentPage)
        {
          selectedIds.remove(wr.lpp.id);
        }
      }
    } 
  }
  
  Public void doDeselectItemR()
  {
    system.debug('---------------------REMOVE-----------------' +this.selectedIds);
    this.selectedIds.remove(ID.Valueof(this.selectedItem));
    this.selectedItem = '';
  }
  
  public void delsel()
  {
    if(Selected_Config != '[]')
    {
      List<LX_Opportunity_Pricelist_Product__c> temp = new List<LX_Opportunity_Pricelist_Product__c>();
      List<String> selList = new List<String>();
      string str = Selected_Config.replace('\'','');
      str = str.replace('[','');
      str = str.replace(']','');
      str= str.replaceAll( '\\s+', '');
      system.debug('$$$$$$$$$$$$$$$$$' +str);
      list<String> strlst = str.split(',');
      set<String> strSet = new set<String>();
      strSet.addall(strlst);
      system.debug('$$$$$$$$$$$$$$$$$' +strSet);     
      for(wRecord wr : records)
      {
        if(strSet.contains(wr.LPP.Parent_ID__c))
        {
          system.debug('Adding to Delete-----------' +wr.LPP.Parent_ID__c);
          temp.add(wr.LPP);  
        }
      }
      if(!temp.isEMpty())
      {
        try
        {
          Delete temp;     
        }catch(DMLException ex){
          ApexPages.addMessages(ex);
        }
      }
    }else{
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Select a valid Configuration to Delete'));
    }
    Selected_Config = '[All]';    
    initialize();   
  }
  
  public void del()
    {
    for(wRecord wr : records)
    {
      system.debug('XXXXXXXXXXXXX' +wr);
      if(wr.selected && wr.isCurrentPage)
      {
        selectedIds.add(wr.lpp.id); 
      }else{
        if(wr.isCurrentPage)
        {
          selectedIds.remove(wr.lpp.id);
        }
      }
    }
    
    List<LX_Opportunity_Pricelist_Product__c> temp = new List<LX_Opportunity_Pricelist_Product__c>();
    if(!selectedIds.isEMpty())
    {
      for(ID wr: selectedIds)
      {
        temp.add(new LX_Opportunity_Pricelist_Product__c(id = wr));    
      }
      if(!temp.isEMpty())
      {
        try
        {
          Delete temp; 
          selectedIds.clear();
        }catch(DMLException ex){
          ApexPages.addMessages(ex);    
        }
      }
    }
    
    initialize();
    
    /* PageReference pageRef = new PageReference('/apex/Pricelist_Product_MassDelete?OppID=' + Opp_id);
    pageRef.setRedirect(true);
    return pageRef;  */ 
  }
    
  public class wRecord
    {
        public integer rownumber{get;set;}
        public boolean selected{get;set;}
        public boolean isCurrentPage{get;set;}
        public LX_Opportunity_Pricelist_Product__c LPP {get;set;}
       
        
        public wRecord(LX_Opportunity_Pricelist_Product__c lpp, integer rownumber)
    {   
      this.rownumber = rownumber;
      this.selected = false;
      this.isCurrentPage = false;
      this.LPP = lpp;
    }        
    }
}