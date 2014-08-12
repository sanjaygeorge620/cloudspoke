public with sharing class BM_Quote_View_Controller 
{
	Public User CurrentUser{get;set;}
	Public Set<String> user_KeySet {get;set;}
	public list<SelectOption> View_Options {get;set;}
	public String Selected_View {get; set;}
	public List<BigMachines__Quote__c> Quote_List_ALL {get;set;}
	public List<BigMachines__Quote__c> Quote_List_SelectedView {get;set;}
	public Map<ID,Set<String>> quote_ApproverMap {get;set;}
	public Map<String,List<BigMachines__Quote__c>> view_List {get;set;}
	public List<BM_Group__c> Group_List {get;set;}  
	public Map<String,String> BM_Map {get;set;}  
	public Map<String,String> BM_Map_inv {get;set;} 
	public Set<String> keySet = new Set<String>(); 
	public BM_Quote_View_Controller()
	{
		user_KeySet = new Set<String>();
		View_Options = new list<SelectOption>();
		Quote_List_ALL = new List<BigMachines__Quote__c>();
		Quote_List_SelectedView = new List<BigMachines__Quote__c>();
		quote_ApproverMap = new Map<ID,Set<String>>();
		view_List = new Map<String,List<BigMachines__Quote__c>>();
		BM_Map = new Map<String,String>();
		BM_Map_inv = new Map<String,String>();
		keySet = new Set<String>();

		Group_List = BM_Group__c.getAll().Values();

		if(!Group_List.isEmpty())
		{
			for(BM_Group__c BM : Group_List)
			{
				BM_Map.put(BM.DD_Variable_Name__c,BM.name);
				BM_Map_inv.put(BM.name,BM.DD_Variable_Name__c);
			}
		}

		View_Options.add(new SelectOption('All','All Quotes'));  

		currentUser = [Select ID,BigMachines__Login__c,BigMachines__User_Groups__c from user where id =: Userinfo.getUserid()][0];

		if(currentUser.BigMachines__Login__c != '')
		{
			Selected_View = 'All';
			user_KeySet.add(currentUser.BigMachines__Login__c);
			View_Options.add(new SelectOption(currentUser.BigMachines__Login__c,'User - ' +currentUser.BigMachines__Login__c));       
		}
		if(currentUser.BigMachines__User_Groups__c != '' || currentUser.BigMachines__User_Groups__c != null)
		{
			if(null!=currentUser.BigMachines__User_Groups__c && currentUser.BigMachines__User_Groups__c.contains(';'))
			{
				string str = currentUser.BigMachines__User_Groups__c;
				str= str.replaceAll( '\\s+', '');
				list<String> grpLst = str.split(';');
				Set<String> grpSet = new Set<String>();
				grpSet.addAll(grpLst);
				grpLst.clear();
				grpLst.addall(grpSet);
				
				if(!grpLst.isEMpty())
				{
					user_KeySet.addAll(grpLst);
				}
			} else {
				user_KeySet.add(currentUser.BigMachines__User_Groups__c);
			}
		}
		if(!user_KeySet.isEmpty())
		{
			for(String S : user_KeySet)
			{
				if(BM_Map.containskey(S))
				{
					View_Options.add(new SelectOption(s,'Group - ' +BM_Map.get(s)));       
				}
			}
		}
        system.debug(logginglevel.error, '*****************-1:');
		
        
        Quote_List_ALL = [select id,ownerid,owner.Name,BigMachines__Status__c,Current_Approvers__c,BigMachines__Opportunity__c,Quote_Category__c,BigMachines__Opportunity__r.name,Assigned_To__c,Name,Quote_Name__c,BigMachines__Description__c,Quote_Type__c,Quote_Deal_Type__c,Quote_Control_Number__c,Sales_Region__c,Sales_GEO__c,BigMachines__Total_Amount__c,Enduser_Name__c,Sales_Rep_Name__c,Submitted_Date__c,Copy_Reason__c,BigMachines__Is_Primary__c,LX_Ready_for_Finalization__c from BigMachines__Quote__c where BigMachines__Status__c = 'Pending Approval'];

		if(!Quote_List_ALL.isEmpty())
		{
			for(BigMachines__Quote__c Bq : Quote_List_ALL)
			{
				if(Bq.Current_Approvers__c != '' && Bq.Current_Approvers__c != null)
				{
					if(Bq.Current_Approvers__c.contains('$$'))
					{
						//system.debug('$$$$$$$$' +Bq.Current_Approvers__c);
						List<String> keymap = new List<String>();
						List<String> tempUmap = new List<String>();

						String strM = Bq.Current_Approvers__c;
						strM = strM.replaceAll( 'U:', '');
						strM = strM.replaceAll( 'G:', '');
						strM= strM.replaceAll( '\\s+', '');
						keymap = strM.Split('\\$\\$');
						system.debug('$$$$$$$$$$$$$$' +keymap);
						FOR(String STR : keymap)
						{   
							List<String> tempGmap = new List<String>();
							tempGmap = STR.Split('\\@');
							tempUmap.addall(tempGmap);
						}
						keyset.addall(tempUmap);

						system.debug('$$$$$$$$$$$$$$' +keyset);
					} else {
						//system.debug('$$$$$$$$' +Bq.Current_Approvers__c);
						List<String> keymap = new List<String>();
						String strM = Bq.Current_Approvers__c;
						keymap = strM.Split(' ');
						keySet = new Set<String>(keymap);
					}
					for(String str : keySet)
					{
						if(str == 'OR' || str.contains(']')|| str.contains('['))
						{
						   keySet.Remove(str); 
						}
						string nospace = str.Trim();
						if(user_KeySet.contains(nospace))
						{
							if(view_List.containskey(nospace))
							{
								if(view_List.get(nospace) != null)
								{
									view_List.get(nospace).add(Bq);
								}
							}else{
								List<BigMachines__Quote__c> tempList = new List<BigMachines__Quote__c>();
								tempList.add(Bq);
								view_List.put(nospace,tempList);    
							}
						}
					}
				}
				keySet.clear();
			}
		}
		Quote_List_ALL.clear();
		refreshQuotes();
	}
	
	public void refreshQuotes()
	{
		Quote_List_SelectedView.clear();
		if(Selected_View != 'ALL')
		{
			if(view_List.containskey(Selected_View))
			{
				if(view_List.get(Selected_View) != null)
				{
					Quote_List_SelectedView.addall(view_List.get(Selected_View));
				}
			}
		} else if(Selected_View == 'ALL'){
			IF(!view_List.keyset().isEmpty())
			{
				for(String s : view_List.Keyset())
				{
					if(view_List.get(s) != null)
					{
						Quote_List_SelectedView.addall(view_List.get(s));
					}
				}
			}
		}
		//system.debug('--------------------' +Selected_View);
		//system.debug('--------------------' +Quote_List_SelectedView.SIZE());
		//system.debug('--------------------' +view_List.Keyset());
		//system.debug('--------------------' +view_List.values());
	}
	
	public set<String> buildApproverSet(String StrM)
	{
		List<String> keymap = new List<String>();
		//system.debug('-----------' +strM);
		keymap = strM.Split(' ');
		Set<String> keySet = new Set<String>(keymap);
		for(String str : keySet)
		{
			if(str == 'OR' || str.contains(']')|| str.contains('['))
			{
			   keySet.Remove(str); 
			}
		}

		return keySet;
	}
}