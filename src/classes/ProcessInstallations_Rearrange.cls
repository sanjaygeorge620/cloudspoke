public with sharing class ProcessInstallations_Rearrange 
{
    public static void Rearrange_Asset_Items_PG(Map<String,list<String>> PGSoln,opportunity opp)
    {
       List<Asset_Item__c> extAstLst = new List<Asset_Item__c> ();
        
        extAstLst = [Select ID,Asset__c,Opportunity__c,Hide_on_Portal__c,Environment__c,End_Date__c,Parent_Asset_Item__c,
                   Part_Number__c,Process_later__c,Product__c,Quantity__c,Server__c from Asset_Item__c where Asset__r.AccountID =: opp.AccountID and Opportunity__c =: opp.id];
        
        
    }
    
    public static void Rearrange_Asset_Items(Map<OpportunityLineItem, List<Product2>> sub_Map,opportunity opp)
    {
        map<string,List<Asset_Item__c>> astitm_mp = new map<string,List<Asset_Item__c>>(); 
        map<id,List<Asset_Item__c>> astitm_mp2 = new map<id,List<Asset_Item__c>>();
        List<Asset_Item__c> aitlst = new List<Asset_Item__c>();
        List<Asset_Item__c> aitlst2 = new List<Asset_Item__c>();
        Map<ID,Asset_Item__c> atmupdate = new Map<ID,Asset_Item__c>();
        List<Asset_Item__c> atmupdate2 = new List<Asset_Item__c>();
        List<Asset> Assetupd = new List<Asset>();
        Set<Asset> Asset_upd = new Set<Asset>();
        set<string> subitemParts = new set<string>(); 
        
        List<Perceptive_Config_Value__c> pcv = new List<Perceptive_Config_Value__c>();
        map<String,Perceptive_Config_Value__c> key_desc = new map<String,Perceptive_Config_Value__c>();    
        pcv = [Select ID,Name,Custom_Attribute_1__c,Custom_Attribute_2__c,Description__c,Perceptive_Config_Option__c,sort__c,value__c
               from Perceptive_Config_Value__c where Perceptive_Config_Option__r.Name = 'Unit of Measure' order by name];    
        if(!pcv.isEmpty())
        {
            for(Perceptive_Config_Value__c pc : pcv)
            {
                if(pc.name != null || pc.name != '')
                {
                    key_desc.put(pc.Name,pc);
                }
            }   
        }
        
        
        aitlst2 = [Select ID,Asset__c,Opportunity__c,Hide_on_Portal__c,Environment__c,End_Date__c,Parent_Asset_Item__c,
                   Part_Number__c,Process_later__c,Product__c,Quantity__c,Server__c from Asset_Item__c where Asset__r.AccountID =: opp.AccountID and Opportunity__c =: opp.id];
        
        if(!aitlst2.isEmpty())
        {
            for(Asset_Item__c atm : aitlst2)
            {
                if(atm.Opportunity__c == opp.id)
                {
                    aitlst.add(atm);    
                }   
            }   
            
            for(Asset_Item__c atm : aitlst2)
            {
                if(astitm_mp2.containskey(atm.Asset__c))
                {
                    astitm_mp2.get(atm.Asset__c).add(atm);
                }
                else
                {
                    List<Asset_Item__c> temp = new List<Asset_Item__c>();
                    temp.add(atm);
                    astitm_mp2.put(atm.Asset__c,temp);
                }   
            }
        }
        if(!aitlst.isEmpty())
        {
            for(Asset_Item__c atm : aitlst)
            {
                if(astitm_mp.containskey(atm.Part_Number__c))
                {
                    astitm_mp.get(atm.Part_Number__c).add(atm);
                    subitemParts.add(atm.Part_Number__c);
                }
                else
                {
                    List<Asset_Item__c> temp = new List<Asset_Item__c>();
                    temp.add(atm);
                    astitm_mp.put(atm.Part_Number__c,temp);
                    subitemParts.add(atm.Part_Number__c);
                }   
            }
            for(OpportunityLineItem op : sub_Map.keyset())
            {
                if(op.PricebookEntry.Product2.Product_Bundled__c)
                {
                    for(product2 sbprod : sub_Map.get(op))
                    {
                        if(astitm_mp.containskey(sbprod.Part_Number__c) && astitm_mp.containskey(op.PricebookEntry.Product2.Part_Number__c))
                        {
                            for(Asset_Item__c subatm : astitm_mp.get(sbprod.Part_Number__c))
                            {            
                                for(Asset_Item__c parentatm : astitm_mp.get(op.PricebookEntry.Product2.Part_Number__c))
                                {
                                    //  if(parentatm.Asset__c == subatm.Asset__c && parentatm.Server__c == subatm.Server__c)
                                    if(parentatm.Server__c == subatm.Server__c && parentatm.Part_Number__c != subatm.Part_Number__c)
                                    {
                                        if(sbprod.Sub_Product_Ratio__c != null  && sbprod.Sub_Product_Ratio__c > 0)
                                        {   
                                            system.debug('$$$$$$$$$$$$$$$$' +sbprod.Sub_Product_Ratio__c);
                                            //  us_name=us_name.substring(0,us_name.length()<254?us_name.length():254); 
                                            // 
                                            
                                            Decimal finalQT =(1/sbprod.Sub_Product_Ratio__c)*op.quantity>1?Math.floor(1/sbprod.Sub_Product_Ratio__c)*op.quantity:1;
                                            integer finalint =  finalQT.intvalue();                                            
                                            
                                            atmupdate.put(subatm.id,(new Asset_Item__c(id = subatm.id,Parent_Asset_Item__c = parentatm.id,quantity__c = finalint,Hide_on_Portal__c = True)));
                                            subatm.Hide_on_Portal__c = True;    
                                        }
                                        else
                                        {   
                                            atmupdate.put(subatm.id,(new Asset_Item__c(id = subatm.id,Parent_Asset_Item__c = parentatm.id,quantity__c = sbprod.SubProduct_Quantity__c,Hide_on_Portal__c = True)));
                                            subatm.Hide_on_Portal__c = True;
                                        }
                                        
                                        integer finalQt = integer.valueof(atmupdate.get(subatm.id).quantity__c);
                                        String UOM = '';
                                        String UOM_desc = '';
                                        integer nrnbr = 0;
                                        
                                        List<String> appluom = new List<String>(); 
                                        if(String.isNotBlank(sbprod.Price_Unit__c))  
                                        {
                                            string validuom = sbprod.Price_Unit__c.replaceAll('[^a-zA-Z0-9;]','');      
                                            if(validuom.contains(';'))
                                            {
                                            appluom = validuom.split(';');
                                            }
                                            else 
                                            {
                                                appluom.add(validuom);
                                            }

                                        }
                                        if(!appluom.isEmpty() && appluom.size() > 1)
                                        {
                                            UOM = '';
                                            UOM_desc = '';
                                            nrnbr = 0;
                                            for(String st : appluom)
                                            {
                                                if(String.isNotBlank(st))
                                                {
                                                    st = st.replaceAll('[^a-zA-Z0-9;]','');                                                    
                                                    if(!st.contains('ZU') && key_desc.containsKey(st))
                                                    {
                                                        string val = key_desc.get(st).Value__c;
                                                        integer nu = 0;                                                        
                                                        nu = val.contains('-')?integer.valueof(val.substring(val.indexOf('-')).tolowercase().ReplaceAll('[^0-9]','')):integer.valueof(val.tolowercase().ReplaceAll('[^0-9]', ''));
                                                        
                                                        if(finalQt < nu)
                                                        {
                                                            if(nrnbr == 0)
                                                            {                                                             
                                                                nrnbr = nu - finalQt;
                                                                uom = st;
                                                                UOM_desc = key_desc.get(st).Description__c;  
                                                            }
                                                            else if((nu - finalQt) < nrnbr)
                                                            { 
                                                                nrnbr = nu - finalQt;
                                                                uom = st;
                                                                UOM_desc = key_desc.get(st).Description__c;  
                                                            }                                                         
                                                        }                                                        
                                                    }
                                                }
                                            }
                                        }
                                        else if(appluom.size() == 1)
                                        {                                           
                                          uom = appluom[0];
                                            if(key_desc.containskey(appluom[0]))
                                            {
                                            UOM_desc = key_desc.get(appluom[0]).Description__c;  
                                            }
                                        }
                                            
                                        
                                        
                                        
                                        
                                        if(astitm_mp2.containskey(subatm.Asset__c))
                                        {
                                            if(astitm_mp2.get(subatm.Asset__c).size() == getHiddenItemCount(astitm_mp2.GET(subatm.Asset__c),subitemParts))
                                            {       
                                                Asset_upd.add(new Asset (ID = subatm.Asset__c,Hide_on_Portal__c = True));
                                            }
                                        }
                                    }
                                    if(parentatm.Server__c == subatm.Server__c && parentatm.Part_Number__c == subatm.Part_Number__c)
                                    {
                                        if(sbprod.Sub_Product_Ratio__c != null  && sbprod.Sub_Product_Ratio__c > 0)
                                        {   
                                            system.debug('$$$$$$$$$$$$$$$$' +sbprod.Sub_Product_Ratio__c);
                                            //  us_name=us_name.substring(0,us_name.length()<254?us_name.length():254);   
                                            
                                            Decimal finalQT =(1/sbprod.Sub_Product_Ratio__c)*op.quantity>1?Math.floor((1/sbprod.Sub_Product_Ratio__c)*op.quantity):1;
                                            integer finalint =  finalQT.intvalue();
                                            atmupdate.put(subatm.id,(new Asset_Item__c(id = subatm.id,quantity__c = finalint)));
                                            subatm.Hide_on_Portal__c = True;    
                                        }
                                        else
                                        {   
                                            atmupdate.put(subatm.id,(new Asset_Item__c(id = subatm.id,quantity__c = sbprod.SubProduct_Quantity__c)));
                                            subatm.Hide_on_Portal__c = True;
                                        }    
                                    }
                                }   
                            }
                        }
                    }   
                }           
            }       
        }
        if(!atmupdate.isEmpty())
        {
            system.debug('xxxxxxxxxxxxxxxxxxxxx' +atmupdate.Values());
            atmupdate2.addAll(atmupdate.Values());
            Update atmupdate2;
        }   
        if(!Asset_upd.isEmpty())
        {
            Assetupd.addall(Asset_upd); 
            Update Assetupd;
        }
    }
    
    public static integer getHiddenItemCount(List<Asset_Item__c> atLIST,set<string> partset)
    {   
        integer hiddencount = 0;
        for(Asset_Item__c atm : atLIST)
        {
            if(partset.contains(atm.Part_Number__c))
            {
                hiddencount++;
            }
        }
        RETURN hiddencount;
    }   
}