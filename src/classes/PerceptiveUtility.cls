/*
Utility to Help with Common Tasks
1. Custom Exceptions
2. Metadata Calls
2. Requesting Perceptive Config Values
3. MetaData Calls
4. Adding Values to Multipicklists
*/        

Public Class PerceptiveUtility{

    /*Reusable Procedures*/
        /* 1. Customer Exception*/
        public class CustomException extends Exception{} /*CustomException*/   
        
        /* 2. Dynamic Picklist*/
        public static List<SelectOption> getPicklistValues(Schema.DescribeFieldResult sObjectField, boolean Add_None_Value){
                List<SelectOption> PicklistOptions = new List<SelectOption>();
                if (Add_None_Value==true){PicklistOptions.add(new SelectOption('','-- None --'));}
                //Schema.DescribeFieldResult sObjectField= Schema.sObjectType.Account.fields.Sector__c;
                for (Schema.PickListEntry RelPickVal : sObjectField.getPicklistValues()){
                    PicklistOptions.add(new SelectOption(RelPickVal.getValue(),RelPickVal.getLabel()));}
            return PicklistOptions;
            }
    
    
        /*3. Adding MultiPicklist Values*/    
        public static String AddToMultiselect(string MultiselectValue, string AddedValue) {  

            if( MultiselectValue == null ) {MultiselectValue='';}
            if( AddedValue == null ) {AddedValue='';}
            
            list<String> MultiSelectArray = MultiSelectValue.split(';');
            list<string> AddedValueArray = AddedValue.split(';');
            Set<string> NewMultiselectValues = new Set<string>();
            string NewMultiselectString = ''; 
            
            for(string oldValue : MultiSelectArray ) {
                NewMultiselectValues.add(oldValue);
            }
    
            for(string newValue : AddedValueArray) {
                NewMultiselectValues.add(newValue);         
            }
            
            for(string newListValue : NewMultiselectValues) {
                NewMultiselectString += newListValue + ';';
            }
        
        return NewMultiselectString;
        } 
        
        
    /*Perceptive Config Values*/        
       /* 1. Single Value*/     
       Public static string getSingleConfigValue(string groupkey, string optionname, string valuename){
                string SelectedValue;
                List<Perceptive_Config_Value__c> MyValues = [Select 
                                                        p.value__C 
                                                        From Perceptive_Config_Value__c p
                                                        where
                                                            p.name =:valuename and 
                                                            p.Perceptive_Config_Option__r.Perceptive_Config_group__r.key__c=:groupkey and 
                                                            p.Perceptive_Config_Option__r.name=:optionname
                                                        ];
                    if (MyValues.size()!=1)
                        {return null;}
                    else {
                            //Iterating through List to get the One Value
                            for (Perceptive_Config_Value__c PV : MyValues) 
                             {Return PV.value__C;}
                         }
                            
                Return SelectedValue;
            }
             
        /* 2. Get List of Values*/
        Public static List<Perceptive_Config_Value__c> getListofConfigValues(string groupkey, string optionname){
                List<Perceptive_Config_Value__c> MyValues = [Select 
                                                        p.value__C 
                                                        From Perceptive_Config_Value__c p
                                                        where
                                                            p.Perceptive_Config_Option__r.Perceptive_Config_group__r.key__c=:groupkey and 
                                                            p.Perceptive_Config_Option__r.name=:optionname
                                                        order by p.Sort__c
                                                        ];
                    
                Return MyValues ;
            }
            
            
 /*Test Methods*/
 static testMethod void PerceptiveUtility() {
            //Add Config Group
                Perceptive_Config_Group__c PG = new Perceptive_Config_Group__c();
                PG.Name = 'Account Settings';
                PG.Key__c = 'test__Account_Settings';
                PG.Description__c='test';
                insert PG;
            
            //Add Config Option
                Perceptive_Config_Option__c PO = new Perceptive_Config_Option__c();
                PO.Name = 'CSA';
                PO.Perceptive_Config_Group__c = PG.ID;
                PO.Description__c='test';
                insert PO;  
            
            //Add Config Value
                Perceptive_Config_Value__c PV = new Perceptive_Config_Value__c();
                PV.Name = 'State/Local';
                PV.Perceptive_Config_Option__c = PO.ID;
                PV.Value__c = 'NEW CSA NAME';
                PV.Description__c='test';
                insert PV;
                

            list<Perceptive_Config_Value__c> mytestlist =getListofConfigValues('test__Account_Settings','CSA');
            string MyTestValue = getSingleConfigValue('test__Account_Settings','CSA','State/Local');
            System.assertEquals(mytestlist.size(),1);
            System.assertEquals(MyTestValue,'NEW CSA NAME');
            
            Schema.DescribeFieldResult Picklist= Schema.sObjectType.Account.fields.Rating;
            getPicklistValues(Picklist, True);
            
            //Add Value to picklist
            string MyPickList =AddToMultiselect('1;2;', '3');
            System.assertEquals(MyPickList.replace(';',''),'321');
            
        }
}