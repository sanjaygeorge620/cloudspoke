public with sharing class CTLPagination {
   
    Public list<wRecord> wAccounts{
    get{
        if(wAccounts==null){
            wAccounts = new list<wRecord>();
            for(Account x : [Select ID, 
                                    Name
                             from Account 
                             order by Name 
                             limit 20
                             ]){
            wAccounts.add(new wRecord(x.ID,  x.Name, false));
            }
        }
        return wAccounts;
       }
       set; 
        
    }
    
    public class wRecord{
        public boolean selected{get;set;}
        public string RecordID{get;set;}
        public string Name{get;set;}
        public wRecord(string rid, string rname, boolean s){
            this.RecordID = rid;
            this.Name = rname;
            this.selected = s;
            
        }
    }
}