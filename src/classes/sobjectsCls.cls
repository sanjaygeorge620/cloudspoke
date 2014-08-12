public with sharing class sobjectsCls {
    public class objectWrapper{
        public string objectName{get; set;}
        public string objectAPIName{get; set;}
        public objectWrapper(string name, string apiname){
            objectName = name;
            objectApiname = apiname;
        }
    }
    
    public list<objectwrapper> lstobjects{get; set;}
    
    public sobjectsCls (){
        lstobjects = new List<objectwrapper>();
        for(Schema.sObjectType s : Schema.getGlobalDescribe().values()){
            if(!string.valueOf(s).contains('__Tag')){
                Schema.describeSobjectresult res = s.getDescribe();
                lstobjects.add(new objectWrapper(res.getLabel(),res.getName()));
            }
        }
    }

}