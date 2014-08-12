public class ControllerTrainingItem {

	public List<Training_Info_Item__c> infoItems1;
	public List<Training_Info_Item__c> infoItems2;
	public List<Training_Info_Item__c> infoItems3;
	public List<Training_Info_Item__c> infoItems4;

	public boolean showItems1;
	public boolean showItems2;
	public boolean showItems3;
	public boolean showItems4;

	public List<Training_Info_Item__c> childInfoItems;
    ApexPages.StandardController standardController;
	Training_Info_Item__c infoItem = null;
	

    public ControllerTrainingItem(){
        infoItems1 = 
        	[select id, name, description__c, order__c, long_Description__c, Parent_Title_URL__c  from Training_Info_Item__c 
        		where Parent_Training_Info_Item__c = null and Page_Section_Number__c = 1
        		order by order__c];
        	
        infoItems2 = 
        	[select id, name, description__c, order__c, long_Description__c, Parent_Title_URL__c  from Training_Info_Item__c 
        		where Parent_Training_Info_Item__c = null and Page_Section_Number__c = 2
        		order by order__c];
        infoItems3 = 
        	[select id, name, description__c, order__c, long_Description__c, Parent_Title_URL__c  from Training_Info_Item__c 
        		where Parent_Training_Info_Item__c = null and Page_Section_Number__c = 3
        		order by order__c];
        infoItems4 = 
        	[select id, name, description__c, order__c, long_Description__c, Parent_Title_URL__c  from Training_Info_Item__c 
        		where Parent_Training_Info_Item__c = null and Page_Section_Number__c = 4
        		order by order__c];
        
         
        
    }
    
	public ControllerTrainingItem(ApexPages.StandardController pcfController){
        standardController = pcfController;
        this.infoItem = (Training_Info_Item__c)pcfController.getRecord();
		
		childInfoItems = [select id, name, description__c, order__c, Title_URL__c, TitleHasURL__c  
							from Training_Info_Item__c 
							where Parent_Training_Info_Item__c =:infoItem.Id
							order by order__c]; 
     	
    }
    
    public List<Training_Info_Item__c> getChildInfoItems(){
    	return childInfoItems;	
    }

	public List<Training_Info_Item__c> getInfoItems1(){
		return infoItems1;	
	}
	
	public List<Training_Info_Item__c> getInfoItems2(){
		return infoItems2;	
	}
	public List<Training_Info_Item__c> getInfoItems3(){
		return infoItems3;	
	}
	public List<Training_Info_Item__c> getInfoItems4(){
		return infoItems4;	
	}
	
	public boolean getShowItems1(){
		return (infoItems1!=null && infoItems1.size()>0);	
	}
	public boolean getShowItems2(){
		return (infoItems2!=null && infoItems2.size()>0);	
	}
	public boolean getShowItems3(){
		return (infoItems3!=null && infoItems3.size()>0);	
	}
	public boolean getShowItems4(){
		return (infoItems4!=null && infoItems4.size()>0);	
	}
	
	public string getSiteNickName(){
   		return SiteUtilController.getSiteNickName();
   	}
	
}