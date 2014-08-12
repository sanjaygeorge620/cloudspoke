/*
Class Name : LX_UtilChildOpp
Description : Utility class returning dynamic Soql Querry 
Created By : Abhishek Kumat (abhishekkumar3@deloitte.com)
Created Date : 24-9-2013
Modification Log:
-------------------------------------------------------------------------
Developer        Date            Modification ID        Description
-------------------------------------------------------------------------
Abhishek Kumar  24-9-2013           1000                   Initial Version
*************************************************************************/
public with sharing class LX_UtilChildOpp{
 
 	public static map<String, Schema.SObjectField> fMap = new map<String, Schema.SObjectField>();
 	public  static list<string> selectFields= new list<string>();
 	public static list<Schema.SObjectField> FieldOfCertainType=new list<Schema.SObjectField>();
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
         
        String selects = '';
         
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                //if (fd.isCreateable()) // field is creatable
                { 
                    selectFields.add(fd.getName());
                    
                    system.debug('********Field Name:'+fd.getName());
                }
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
        
        system.debug('********SOQL'); 
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
         
    }	
 	public static list<Schema.SObjectField> getFieldsOfType(string fieldtype){
 	
	 	for(String fieldName : fMap.keyset()){
	 	Schema.SObjectField field1 = fMap.get(fieldName);
	 	Schema.DisplayType FldType = field1.getDescribe().getType();
		 	if((String.valueOf(FldType)).equals(fieldtype)){ 
		 		if(fMap.get(fieldName).getDescribe().isUpdateable()&& !fMap.get(fieldName).getDescribe().ISunique()){
		 			FieldOfCertainType.add(fMap.get(fieldName));
		 		}
		 	}
	 	}
	 	if(FieldOfCertainType != null && FieldOfCertainType.size()>0){
	 		return FieldOfCertainType;
	 	}
 		else{
 			return null;
 		}
 	}
}