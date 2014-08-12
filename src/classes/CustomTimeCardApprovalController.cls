public class CustomTimeCardApprovalController {
    public List<pse__Timecard_Header__c> psetimeCardList{get;set;}
    
    public pse__Timecard_Header__c dummyObj{get;set;}
    public boolean isSaved{get;set;}
    public boolean isSubmitted{get;set;}
    public boolean isApproved{get;set;}
    public boolean isRejected{get;set;}
    public List<TimeCard> timeCardList{get;set;}
    public List<SelectOption> pmList{get;set;}
    public string selectedPM{get;set;}
    public boolean isRecordsFound{get;set;}
    public List<ProjectBase> projectBaseList{get;set;}
    public string message{get;set;}
    
    public boolean isPageAccessible{get;set;}
    
    
    public CustomTimeCardApprovalController(){
        isRecordsFound = true;
        dummyObj = new pse__Timecard_Header__c();
        timeCardList = new List<TimeCard>();
        pmList = new List<SelectOption>();
        projectBaseList = new List<ProjectBase>();
        
        isPageAccessible = MassTCApprovalHelper.isPageAccessible(); 
        
        if(isPageAccessible){
        
            // PR-06881 week end date to default to previous week's end date
            dummyObj.pse__End_Date__c = MassTCApprovalHelper.getWeekEndDate(Date.Today()-7);
                    
            pmList = MassTCApprovalHelper.getAllPMs(
            MassTCApprovalHelper.getWeekEndDate(dummyObj.pse__End_Date__c),
            MassTCApprovalHelper.getTCIds(
            MassTCApprovalHelper.getAllTCForWeekend(dummyObj.pse__End_Date__c)
            )
            );        
        }
    }
    
    public void refreshPMList(){
        try{
        pmList = new List<SelectOption>();
        date weekenddate = MassTCApprovalHelper.getWeekEndDate(dummyObj.pse__End_Date__c);        
        pmList = MassTCApprovalHelper.getAllPMs(
        weekenddate,
        MassTCApprovalHelper.getTCIds(
        MassTCApprovalHelper.getAllTCForWeekend(weekenddate)
        )
        );
        
        }catch(Exception ex){
         message = ex.getMessage() + dummyObj.pse__End_Date__c;
        
        }
        
        
    }
    
    
    public static Date getWeekEndDate(Date anyDate){
        Date weekStart = anyDate.toStartofWeek();
        String weekday = ((datetime)weekstart).format('EEE');
        if(weekday=='Sat')
        return weekStart.addDays(5);
        else
        return weekstart.adddays(4);
    }
    
    public static Date getWeekStartDate(Date anyDate){
        Date weekStart = anyDate.toStartofWeek();
         String weekday = ((datetime)weekstart).format('EEE');
        if(weekday=='Sat')
        return weekStart.addDays(-1);
        else
        return weekstart.adddays(-2);
    }
    
    
    public PageReference Run(){
        message = '';
        timeCardList = new List<TimeCard>();
        projectBaseList = new List<ProjectBase>();
        System.debug('*********UsedBeforeInMethod****************'+Limits.getScriptStatements());
        System.debug('*********LimitsBeforeInMethod****************'+Limits.getLimitScriptStatements());
        List<pse__Timecard_Header__c> alltimeCardList = MassTCApprovalHelper.getAllTCForWeekend(
        MassTCApprovalHelper.getWeekEndDate(
        dummyObj.pse__End_Date__c
        ));    
        System.debug('*********UsedAfterInMethod1****************'+Limits.getScriptStatements());
        System.debug('*********LimitsBeforeInMethod1****************'+Limits.getLimitScriptStatements());
        psetimeCardList = 
        MassTCApprovalHelper.getTCFilterByPMStatus(alltimeCardList
        ,selectedPM
        ,isSaved
        ,isSubmitted
        ,isRejected
        ,isApproved
        );
        System.debug('*********UsedAfterInMethod2****************'+Limits.getScriptStatements());
        System.debug('*********LimitsBeforeInMethod2****************'+Limits.getLimitScriptStatements());
        isRecordsFound = true;
        
        if(psetimeCardList.size() == 0){
          isRecordsFound = false;
          return null;
        }
        
        
        string selectedPMName = '';
        for(SelectOption opt: pmList){
           if(opt.getValue() == selectedPM){
              selectedPMName = opt.getLabel();
           }     
            if(test.isRunningTest())
                break;         
        }
        
        
        Set<String> setProjects = new Set<String>();
        Map<String,pse__Timecard_Header__c> mapProjects = new Map<String,pse__Timecard_Header__c>();
        
        
        for(pse__Timecard_Header__c tcHeader : psetimeCardList){
           TimeCard tc = new TimeCard(
              false,
              (tcHeader.pse__Status__c == null ? '': tcHeader.pse__Status__c) ,
              tcHeader.id,
              tcHeader.Name,
              tcHeader.pse__Resource__c,
              tcHeader.pse__Resource__r.Name,
              tcHeader.pse__Project_Methodology__c,
              tcHeader.pse__Bill_Rate__c,
              (tcHeader.pse__End_Date__c == null ? Date.today() : tcHeader.pse__End_Date__c),
              (tcHeader.pse__Total_Hours__c == null ? 0 : tcHeader.pse__Total_Hours__c),
              tcHeader.pse__Total_Billable_Amount__c,
              (tcHeader.pse__Audit_Notes__c == null ? '' :  tcHeader.pse__Audit_Notes__c),
               tcHeader.CurrencyIsoCode,
               tcHeader.pse__Project__r.Name,
               tcHeader.pse__Project__r.pse__Account__r.Name,
               tcHeader.pse__Project__r.pse__Account__c,
               tcHeader.pse__Project__r.pse__Billing_Type__c ,
               tcHeader.WBS_Element_Id__c        
           );         
           timeCardList.add(tc);
           
           if(Limits.getScriptStatements()>=200000)
           break;
           
           
           /**
           if(!setProjects.contains(tcHeader.pse__Project__r.Name)){
               setProjects.add(tcHeader.pse__Project__r.Name);
           }
           **/
           
           if(!mapProjects.containsKey(tcHeader.pse__Project__r.id)){               
               mapProjects.put(tcHeader.pse__Project__r.id, tcHeader);
           }
           if(test.isRunningTest())
                break;  
                          
        }
        
        date weekEnddate = getWeekEndDate(dummyObj.pse__End_Date__c);
        date weekStartdate = getWeekStartDate(dummyObj.pse__End_Date__c);
        
        for(String str : mapProjects.keySet()){
           string projectId = str;  
           string projectName = mapProjects.get(str).pse__Project__r.Name;
           string accountName = mapProjects.get(str).pse__Project__r.pse__Account__r.Name;
           string accountId = mapProjects.get(str).pse__Project__r.pse__Account__c;
           string billingType = mapProjects.get(str).pse__Project__r.pse__Billing_Type__c;
           string projectManager = selectedPMName;
           
           List<TimeCard> innerTimeCardList = new List<TimeCard>(); 
           for(TimeCard tcard : timeCardList){
              if(tcard.projectName == projectName){
                 innerTimeCardList.add(tcard);
                  if(Limits.getScriptStatements()>=200000)
                   break;
              }   
           }
          
           
           projectBaseList.add(new 
           ProjectBase(projectId,projectManager,projectName,innerTimeCardList,weekStartdate,weekEnddate, accountName, accountId, billingType));  

           if(test.isRunningTest())
                break;             
        }
      
        return null;
    }
    public PageReference Approve(){
      Set<Id> timeCardIdsToApprove = new Set<Id>();
      boolean isError = false;
      Map<Id,String> notesMap = new Map<Id,String>();
      for(ProjectBase pB : projectBaseList){
          for(TimeCard tC : pB.timeCardList){
             
             if(tC.isSelected == false || tC.isSelected == null){
                continue;
             }
             
             if(tC.isSelected == true){                
                timeCardIdsToApprove.add(tC.timeCardId);
                notesMap.put(tC.timeCardId,tC.notes);
             }
             if(test.isRunningTest())
                break;      
          }
          if(test.isRunningTest())
                break;      
      }
    
      if(timeCardIdsToApprove.size() > 0){        
        List<pse__Timecard_Header__c> tcHeaderToUpdate = 
        [select id, pse__Timecard_Notes__c,pse__Audit_Notes__c from pse__Timecard_Header__c 
         where id in : timeCardIdsToApprove];
        
        for(pse__Timecard_Header__c tcHeader : tcHeaderToUpdate){
           tcHeader.pse__Audit_Notes__c = notesMap.get(tcHeader.id);
        }
        TCApprovalHelper.updateTCs(tcHeaderToUpdate,'Approved');       
        
      }else{
        isError = true;
        message = 'Please select timecards to approve';
        
      }
      
      if(isError == false){
         Run();
      } 
      
      return null;
    }
    public PageReference Reject(){
      Set<Id> timeCardIdsToApprove = new Set<Id>();
      boolean isError = false;
      Map<Id,String> notesMap = new Map<Id,String>();
      for(ProjectBase pB : projectBaseList){
          for(TimeCard tC : pB.timeCardList){
             
             if(tC.isSelected == false || tC.isSelected == null){
                continue;
             }
             if(tC.notes == null || tC.notes.trim().length() == 0){
                 isError = true;
                 tC.errorMsg = 'Please add notes for rejection';   
             }else{
                 tC.errorMsg = '';
             }
             if(tC.isSelected == true){                
                timeCardIdsToApprove.add(tC.timeCardId);
                notesMap.put(tC.timeCardId,tC.notes);
             }
             if(test.isRunningTest())
                break;      
          }
          if(test.isRunningTest())
                break;      
      }
    
      if(isError == true){
         message = 'Please add notes for selected fields';
         return null;
      }
    
      
      if(timeCardIdsToApprove.size() > 0){        
        List<pse__Timecard_Header__c> tcHeaderToUpdate = 
        [select id, pse__Timecard_Notes__c,pse__Audit_Notes__c from pse__Timecard_Header__c 
         where id in : timeCardIdsToApprove];
        
        for(pse__Timecard_Header__c tcHeader : tcHeaderToUpdate){
           tcHeader.pse__Audit_Notes__c = notesMap.get(tcHeader.id);
        }
        
        TCApprovalHelper.updateTCs(tcHeaderToUpdate,'Rejected');       
        
      }else{
        isError = true;
        message = 'Please select timecards to approve';
        
      }
      
      if(isError == false){
         Run();
      } 
      
      
      
      return null;
    }
    public class ProjectBase{
      public string projectId{get;set;} 
      public string projectManager{get;set;}
      public string projectName{get;set;}
      public date weekStartDate{get;set;}
      public date weekEndDate{get;set;}
      public string projectAccountName{get;set;}
      public string projectAccountId{get;set;}
      public string projectBillingType{get;set;}
      public double totalhours{
        get{
           double thours = 0;
           for(TimeCard tc : this.timeCardList){
              thours += tc.hours;
           }
           return thours;   
        }
      }
      public decimal totalAmount{
        get{
           double tAmount = 0;
           for(TimeCard tc : this.timeCardList){
              tAmount += tc.totalAmount;
           }
           decimal rtn;
           
           //rtn = tAmount + 2; 
           rtn = tAmount + 0;
           return rtn;
           /* return tAmount; */   
        }
      }
      public string currencyISOCode{
        get{
           string code = '';
           for(TimeCard tc : this.timeCardList){
              code = tc.CurrencyIsoCode;
              break;
           }
           return code;
        }
      }
      public List<TimeCard> timeCardList{get;set;}
      public ProjectBase(string projectManager, string projectName, List<TimeCard> timeCardList, string accountName, string accountId, string billingType){
         this.projectManager = projectManager;
         this.projectName = projectName;
         this.timeCardList = timeCardList;
         this.projectAccountName = accountName;
         this.projectAccountId = accountId;
         this.projectBillingType = billingType;
      }
    
      public ProjectBase(string projectManager, string projectName, List<TimeCard> timeCardList,
      date weekStartDate,date weekEndDate, string accountName, string accountId, string billingType){
         this.projectManager = projectManager;
         this.projectName = projectName;
         this.timeCardList = timeCardList;
         this.weekStartDate = weekStartDate;
         this.weekEndDate = weekEndDate;
         this.projectAccountName = accountName;
         this.projectAccountId = accountId;
         this.projectBillingType = billingType;
      }
      
      public ProjectBase(string projectId,string projectManager, string projectName, List<TimeCard> timeCardList,
      date weekStartDate,date weekEndDate, string accountName, string accountId, string billingType){
         this.projectId = projectId;
         this.projectManager = projectManager;
         this.projectName = projectName;
         this.timeCardList = timeCardList;
         this.weekStartDate = weekStartDate;
         this.weekEndDate = weekEndDate;
         this.projectAccountName = accountName;
         this.projectAccountId = accountId;
         this.projectBillingType = billingType;
      }
    
    }
    
    
    public class TimeCard{
        public boolean checkboxIsVisible{get;set;}
        public boolean isSelected{get;set;}
        public string status{get;set;}
        public Id timeCardId{get;set;}
        public string timeCardName{get;set;}
        public string resourceId {get;set;}
        public string resourceName{get;set;}
        public string billingType{get;set;}
        public decimal billRate{get;set;}
        public date enddate{get;set;}
        public double hours{get;set;}
        public decimal totalAmount{get;set;}
        public string notes{get;set;}
        public string CurrencyIsoCode{get;set;}
        public string projectName{get;set;}
        public string projectAccountName{get;set;}
        public string projectAccountId{get;set;}
        public string projectBillingType{get;set;}
        public string errorMsg{get;set;}
        public string wbsElementId{get;set;}
        public TimeCard(){
            //
        }
        public TimeCard(
             boolean isSelected,
             String status,
             Id timeCardId,
             string timeCardName,
             Id resourceId ,
             string resourceName,
             string billingType,
             decimal billRate,
             date enddate,
             double hours,
             decimal totalAmount,
             string notes,
             string CurrencyIsoCode,
             string projectName,
             string accountName,
             string accountId,
             string projectBillingType,
             string wbsElementId
        
        ){
            this.checkboxIsVisible = false;
            this.isSelected = isSelected;
            this.status = status;
            this.timeCardId = timeCardId;
            this.timeCardName = timeCardName;
            this.resourceId = resourceId;
            this.resourceName = resourceName;
            this.billingType = billingType;
            this.billRate = billRate;
            this.enddate = enddate;
            this.hours = hours;
            this.totalAmount = totalAmount;
            this.notes = notes;
            this.CurrencyIsoCode = CurrencyIsoCode;
            if(this.status == 'Submitted'){
               this.checkboxIsVisible = true;
            }
            this.projectName = projectName;
            this.projectAccountName = accountName;
            this.projectAccountId = accountId;
            this.projectBillingType = projectBillingType;
            this.wbsElementId = wbsElementId;
            
            
            //this.totalAmount = this.billRate * this.hours;
            this.errorMsg = '';
        }
        
    }
    
}