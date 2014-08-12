/*
* This class updates the goal record's actual values based on the Opportunity records.
* It gets executed on-click of 'Refresh' button on the Goal record.*/

public class UpdateGoalData{

    public String theId = '';
    public List<Goal__c> goalDataList {get; set;}
    public List<Goal__c> expGoalDataList {get; set;}
    public List<Goal__c> averageDealSizeList {get; set;}
    public Map<String, Map<String, String>> goalMap {get; set;}
    public transient List<ReportData> reportDataListMql {get; set;} 
    public transient List<ReportData> reportDataListSqo {get; set;}
    public transient List<ReportData> reportDataListNAAds {get; set;}
    public transient List<ReportData> reportDataListNAExp {get; set;}
    
    //List to hold chart data
    public transient List<ReportData> reportDataListAds {get; set;} 
    
    public transient List<ReportData> reportDataListSectorMql {get; set;} 
    public transient List<ReportData> reportDataListSectorSqo {get; set;} 
    public transient List<ReportData> reportDataListSectorAds {get; set;} 
    public transient List<ReportData> reportDataListSectorExp {get; set;}
    
    //List to hold chart data
    
    public transient List<ReportData> chartDataListNAMql {get; set;}
    public transient List<ReportData> chartDataListNASqo {get; set;}
    public transient List<ReportData> chartDataListNAAds {get; set;}
    
    public transient List<ReportData> chartDataListSectorMql {get; set;}
    public transient List<ReportData> chartDataListSectorSqo {get; set;}
    public transient List<ReportData> chartDataListSectorAds {get; set;} 
    
    public transient List<ReportData> chartDataListLAMql {get; set;}
    public transient List<ReportData> chartDataListLASqo {get; set;}
    public transient List<ReportData> chartDataListLAAds {get; set;}
    
    public transient List<ReportData> reportDataListLAMql {get; set;}
    public transient List<ReportData> reportDataListLASqo {get; set;}
    
    public transient List<ReportData> reportDataListLAAds {get; set;}
    public transient List<ReportData> reportDataListLAExp {get; set;}
    
    public transient String col1Header {get; set;} 
    public transient String col2Header {get; set;} 
    public transient String col3Header {get; set;} 
    
    public UpdateGoalData(ApexPages.StandardController stdController) {
        //theId = stdController.getId();
        //goalDataList = returnGoalDataList();
    }
    public String soql {get; set;}
    
    public String getQuarter(Date startDate, Date endDate){
       
       String qtr = ''; 
       if(startDate.month() >= 1 && endDate.month() <= 3 )
           qtr = 'Q1';
       else
       if(startDate.month() >= 4 && endDate.month() <= 6 )
           qtr = 'Q2';  
       else
       if(startDate.month() >= 7 && endDate.month() <= 9 )
           qtr = 'Q3';
       else
       if(startDate.month() >= 10 && endDate.month() <= 12 )
           qtr = 'Q4';  
    
       return qtr; 
    }
    
    public pageReference updateGoals(){
    
    List<Goal_Metrics__c> goalSettingsList = new List<Goal_Metrics__c>();
    Integer thisYear = Date.today().year(); 
    Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Goal__c.fields.getMap();
    goalSettingsList = Goal_Metrics__c.getAll().values();
    Goal_Metrics__c goal;
    Integer actualVal = 0;
    Double cur = 0.0;
    String soql = '';
    String filter = '';
    date startDate, endDate;
    List<AggregateResult> aggList;
    List<Goal__c> goalList;
    Goal__c goalObj = new Goal__c();
    Schema.SobjectField fieldName; //Field in the goal object to be updated.
    String globalFilter = Label.Global_filter_for_goals; // Get the global filter from custom label
    //String globalFilterforExp = globalFilter + ' and recordtypeid in (Select Id From RecordType where sobjecttype = \'Opportunity\' and name = \'Expansion-Add On\')'; //same as global filter for goals but type is Expansion New Solution 
    String globalFilterforExp = + ' AND recordtypeid in (Select Id From RecordType where sobjecttype = \'Opportunity\' and name = \'Expansion-Add On\')'; //same as global filter for goals but type is Expansion New Solution 
    
    
    System.debug('##### global filters ' +globalFilter);
    System.debug('***** goalSettingsList '+goalSettingsList);
    
    System.debug('OOOO In updateGoals');
    theId = Apexpages.CurrentPage().getParameters().get('id');
    try{
        goalList = [SELECT CreatedDate, End_Date__c, Start_Date__c FROM Goal__c where id =:theId]; //createdDate = THIS_QUARTER
        
        /*Content_Process_SQO_NA_Actual__c, Content_Process_SQO_NA_Goal__c, Content_Process_SQO_NA_Goal_TD__c,
                Search_SQO_NA_Actual__c, Search_SQO_NA_Goal__c, Search_SQO_NA_Goal_TD__c, Total_SQO_NA_Actual__c, 
                Total_SQO_NA_Goal__c, Total_SQO_NA_Goal_TD__c, Capture_SQO_NA_Actual__c, Capture_SQO_NA_Goal__c,
                Capture_SQO_NA_Goal_TD__c,*/
                
        startDate = goalList[0].Start_Date__c;
        endDate = goalList[0].End_Date__c;
        goalObj = goalList[0];
    }
    catch(Exception ex){
        System.debug('Exception: '+ex.getMessage()+' at line number: '+ex.getLineNumber());
    }
     
   try{          
        for(Integer i = 0; i < goalSettingsList.size(); i++){ //Goal_Metrics__c goalMetric : goalSettingsList
        
        //Reset the filter
        filter = '';
        System.debug('!!! start date and end date '+ startDate +' '+ endDate);
        
            if(startDate!=null && endDate!=null){
                 Datetime sdate = datetime.newInstance(startDate.year(), startDate.month(),startDate.day());
                 Datetime edate = datetime.newInstance(endDate.year(), endDate.month(),endDate.day()); 
                 
                 // Adding code for EXP
                   if(goalSettingsList[i].Name.contains('EXP')) 
                     {
                         
                         if(String.isNotBlank(goalSettingsList[i].SQL_Query_Part__c))
                             filter +=  ' '+goalSettingsList[i].SQL_Query_Part__c + ' ' ;
                         else
                             filter += ' ';  // adding an empty space to to make sure the query is formed completely along with filter and global filter.
                         filter += ' AND '+ +goalSettingsList[i].DateToCompare__c+' >= '+String.valueOf(startDate)+' and '+ goalSettingsList[i].DateToCompare__c+' <= '+ String.valueOf(endDate) + ' ' +globalFilterforExp ;
                         system.debug('&&**&& goalSettingsList[i].Name '+goalSettingsList[i].Name + ' filter '+ filter +' goalSettingsList[i].SQL_Query_Part__c '+goalSettingsList[i].SQL_Query_Part__c);
                     }  
                 else
                     { 
                     //Created date is DateTime and the query requires a different format for Date and DateTime
                     if(goalSettingsList[i].DateToCompare__c.equals('CreatedDate')) {
                         filter +=  ' '+goalSettingsList[i].DateToCompare__c+' >= '+sdate.format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'')+' and '+ goalSettingsList[i].DateToCompare__c+' <= '+ edate.format('yyyy-MM-dd\'T\'hh:mm:ss\'z\'');
                         //system.debug('&&**&& if goalSettingsList[i].Name '+goalSettingsList[i].Name + ' filter '+ filter);
                         
                     }                 
                     else
                     {
                         if(goalSettingsList[i].Name.contains('ADS')) 
                         {
                             //If the field is ADS (Average Deal Size) -- it is to be calculated for yearly basis not quarterly
                             filter +=  ' CALENDAR_YEAR(' + goalSettingsList[i].DateToCompare__c + ') = ' + thisYear;
                             //system.debug('&&**&& goalSettingsList[i].Name '+goalSettingsList[i].Name + ' filter '+ filter);
                         }
                             
                         else
                             filter +=  ' '+goalSettingsList[i].DateToCompare__c+' >= '+String.valueOf(startDate)+' and '+ goalSettingsList[i].DateToCompare__c+' <= '+ String.valueOf(endDate);
                     }  
                     
                   }     
            } 
               
            soql = goalSettingsList[i].sql__c;
             
            System.debug('&&&& soql '+soql);
            System.debug('&&&& filter '+filter);
            
            
            
            //Execute the query only if the filter is valid and not empty
            if(filter != '' && globalFilter != ''){
                
                if(goalSettingsList[i].Name.contains('EXP')) //the filter criteria are different for expansion goals
                    soql = soql + ' ' + filter;
                else
                    soql = soql + ' ' + filter + ' ' + globalFilter;
                //soql = soql + ' Amount != 0 ';
                System.debug('FFFFF soql '+soql);
                
                
                aggList = Database.query(soql);
                
                cur = (double)aggList[0].get('total');
                //System.debug('$$%% soql '+soql+' agglist '+aggList + 'Cur '+cur);
                //Update custom settings actual value
                goalSettingsList[i].Actual__c = String.valueOf(aggList[0].get('total'));
            }
            
            //Update Goal Record
            
            //Get the fieldName using Dynamic Apex
            fieldName = schemaFieldMap.get(goalSettingsList[i].Name);
            
            //System.debug('GGGGG '+schemaFieldMap.get(goalSettingsList[i].Name));
            //System.debug('@$@$@$@ schemaFieldMap '+schemaFieldMap);
            //System.debug('$$%% soql '+soql+' agglist '+actualVal);
            
            //The field exists in the goal object
            if(fieldName != null){
                //Check if the aggregate query returns null then set the value to 0
                /*if( actualVal == null){
                    goalObj.put(fieldName, 100);
                }*/
                decimal tot = (Decimal)aggList[0].get('total');
                //System.debug('DDDD fieldName '+fieldName +' (Integer)aggList[0].get(total) '+aggList[0].get('total'));
                System.debug('SSSSSSSSSSSSSSSSS value:' + tot +' After: '+tot.round(System.RoundingMode.DOWN));
                goalObj.put(fieldName, tot.setScale(0));
                //goalObj.put(fieldName, tot.round(System.RoundingMode.DOWN));
            
            }
           
        }
        
        //goalObj.Actuals_Last_Refreshed__c = System.now();
        
        fieldName = schemaFieldMap.get('Actuals_Last_Refreshed__c');
        goalObj.put(fieldName, System.Now());
        
        //System.debug('&*&* goalSettingsList '+goalSettingsList);
        
        System.debug('***&&& goalObj '+goalObj);
        //Update goal object
        update goalObj;
        
        //Update Goal Metrics Custom Settings
        update goalSettingsList;
         
    }catch(Exception ex){
        System.debug('Exception: '+ex.getMessage()+' at line number: '+ex.getLineNumber());
        }
    PageReference pageRef = new PageReference('/' + theId);
    pageRef.setRedirect(true);
    return pageRef;
    
   }
   
   public List<Goal__c> returnGoalDataList(){
       
       theId = Apexpages.CurrentPage().getParameters().get('id');
       List<Goal__c> goalDataList = [SELECT Actuals_Last_Refreshed__c, Asia_Pacific_ADS_CP_EA_Actual__c, Asia_Pacific_ADS_CP_EA_Goal__c, Asia_Pacific_ADS_CP_EA_Goal_TD__c, Asia_Pacific_ADS_C_P_EA_Var__c, Asia_Pacific_ADS_CP_EA_Var__c, Asia_Pacific_ADS_CP_EA_Var_P__c, Asia_Pacific_ADS_C_P_EA_Var_P__c, Asia_Pacific_MQL_CP_EA_Actual__c, Asia_Pacific_MQL_CP_EA_Goal__c, Asia_Pacific_MQL_CP_EA_Goal_TD__c, Asia_Pacific_MQL_CP_EA_Var__c, Asia_Pacific_MQL_CP_EA_Var_P__c, Asia_Pacific_SQO_CP_EA_Actual__c, Asia_Pacific_SQO_CP_EA_Goal__c, Asia_Pacific_SQO_CP_EA_Goal_TD__c, Asia_Pacific_SQO_CP_EA_Var__c, Asia_Pacific_SQO_CP_EA_Var_P__c, Banking_ADS_CP_NA_Actual__c, Banking_ADS_CP_NA_Goal__c, Banking_ADS_CP_NA_Goal_TD__c, Banking_ADS_CP_NA_Var__c, Banking_ADS_CP_NA_Var_P__c, Banking_MQL_CP_NA_Actual__c, Banking_MQL_CP_NA_Goal__c, Banking_MQL_CP_NA_Goal_TD__c, Banking_MQL_CP_NA_Var__c, Banking_MQL_CP_NA_Var_P__c, Banking_SQO_CP_NA_Actual__c, Banking_SQO_CP_NA_Goal__c, Banking_SQO_CP_NA_Goal_TD__c, Banking_SQO_CP_NA_Var__c, Banking_SQO_CP_NA_Var_P__c, Capture_ADS_EA_Actual__c, Capture_ADS_EA_Goal__c, Capture_ADS_EA_Goal_TD__c, Capture_ADS_EA_Var__c, Capture_ADS_EA_Var_P__c, Capture_ADS_NA_Actual__c, Capture_ADS_NA_Goal__c, Capture_ADS_NA_Goal_TD__c, Capture_ADS_NA_Var__c, Capture_ADS_NA_Var_P__c, Capture_MQL_EA_Actual__c, Capture_MQL_EA_Goal__c, Capture_MQL_EA_Goal_TD__c, Capture_MQL_EA_Var__c, Capture_MQL_EA_Var_P__c, Capture_MQL_NA_Actual__c, Capture_MQL_NA_Goal__c, Capture_MQL_NA_Goal_TD__c, Capture_MQL_NA_Var__c, Capture_MQL_NA_Var_P__c, Capture_SQO_EA_Actual__c, Capture_SQO_EA_Goal__c, Capture_SQO_EA_Goal_TD__c, Capture_SQO_EA_Var__c, Capture_SQO_EA_Var_P__c, Capture_SQO_NA_Actual__c, Capture_SQO_NA_Goal__c, Capture_SQO_NA_Goal_TD__c, Capture_SQO_NA_Var__c, Capture_SQO_NA_Var_P__c, Content_Process_ADS_EA_Actual__c, Content_Process_ADS_EA_Goal__c, Content_Process_ADS_EA_Goal_TD__c, Content_Process_ADS_EA_Var__c, Content_Process_ADS_EA_Var_P__c, Content_Process_ADS_NA_Actual__c, Content_Process_ADS_NA_Goal__c, Content_Process_ADS_NA_Goal_TD__c, Content_Process_ADS_NA_Var__c, Content_Process_ADS_NA_Var_P__c, Content_Process_MQL_EA_Actual__c, Content_Process_MQL_EA_Goal__c, Content_Process_MQL_EA_Goal_TD__c, Content_Process_MQL_EA_Var__c, Content_Process_MQL_EA_Var_P__c, Content_Process_MQL_NA_Actual__c, Content_Process_MQL_NA_Goal__c, Content_Process_MQL_NA_Goal_TD__c, Content_Process_MQL_NA_Var__c, Content_Process_MQL_NA_Var_P__c, Content_Process_SQO_EA_Actual__c, Content_Process_SQO_EA_Goal__c, Content_Process_SQO_EA_Goal_TD__c, Content_Process_SQO_EA_Var__c, Content_Process_SQO_EA_Var_P__c, Content_Process_SQO_NA_Goal__c, Content_Process_SQO_NA_Goal_TD__c, Content_Process_SQO_NA_Var__c, Content_Process_SQO_NA_Var_P__c, Content_Process_SQO_NA_Actual__c, CreatedById, CreatedDate, CurrencyIsoCode, DACHEE_ADS_CP_EA_Goal__c, DACHEE_ADS_CP_EA_Goal_TD__c, DACHEE_ADS_CP_EA_Var__c, DACHEE_ADS_CP_EA_Var_P__c, DACHEE_MQL_CP_EA_Actual__c, DACHEE_MQL_CP_EA_Goal__c, DACHEE_MQL_CP_EA_Goal_TD__c, DACHEE_MQL_CP_EA_Var__c, DACHEE_MQL_CP_EA_Var_P__c, DACHEE_SQO_CP_EA_Actual__c, DACHEE_SQO_CP_EA_Goal__c, DACHEE_SQO_CP_EA_Goal_TD__c, DACHEE_SQO_CP_EA_Var__c, DACHEE_SQO_CP_EA_Var_P__c, IsDeleted, Education_ADS_CP_NA_Actual__c, Education_ADS_CP_NA_Goal__c, Education_ADS_CP_NA_Goal_TD__c, Education_ADS_CP_NA_Var__c, Education_ADS_CP_NA_Var_P__c, Education_MQL_CP_NA_Actual__c, Education_MQL_CP_NA_Goal__c, Education_MQL_CP_NA_Goal_TD__c, Education_MQL_CP_NA_Var__c, Education_MQL_CP_NA_Var_P__c, Education_SQO_CP_NA_Actual__c, Education_SQO_CP_NA_Goal__c, Education_SQO_CP_NA_Goal_TD__c, Education_SQO_CP_NA_Var__c, Education_SQO_CP_NA_Var_P__c, End_Date__c, FRA_ITA_ADS_CP_EA_Actual__c, FRA_ITA_ADS_CP_EA_Goal__c, FRA_ITA_ADS_CP_EA_Goal_TD__c, FRA_ITA_ADS_CP_EA_Var__c, FRA_ITA_ADS_CP_EA_Var_P__c, FRA_ITA_MQL_CP_EA_Actual__c, FRA_ITA_MQL_CP_EA_Goal__c, FRA_ITA_MQL_CP_EA_Goal_TD__c, FRA_ITA_MQL_CP_EA_Var__c, FRA_ITA_MQL_CP_EA_Var_P__c, FRA_ITA_SQO_CP_EA_Actual__c, FRA_ITA_SQO_CP_EA_Goal__c, FRA_ITA_SQO_CP_EA_Goal_TD__c, FRA_ITA_SQO_CP_EA_Var__c, FRA_ITA_SQO_CP_EA_Var_P__c, Name, Healthcare_ADS_CP_NA_Actual__c, Healthcare_ADS_CP_NA_Goal__c, Healthcare_ADS_CP_NA_Goal_TD__c, Healthcare_ADS_CP_NA_Var__c, Healthcare_ADS_CP_NA_Var_P__c, Healthcare_MQL_CP_NA_Actual__c, Healthcare_MQL_CP_NA_Goal__c, Healthcare_MQL_CP_NA_Goal_TD__c, Healthcare_MQL_CP_NA_Var__c, Healthcare_MQL_CP_NA_Var_P__c, Healthcare_SQO_CP_NA_Actual__c, Healthcare_SQO_CP_NA_Goal__c, Healthcare_SQO_CP_NA_Goal_TD__c, Healthcare_SQO_CP_NA_Var__c, Healthcare_SQO_CP_NA_Var_P__c, Insurance_ADS_C_P_NA_Actual__c, Insurance_ADS_C_P_NA_Goal__c, Insurance_ADS_C_P_NA_Goal_TD__c, Insurance_ADS_C_P_NA_Var__c, Insurance_ADS_C_P_NA_Var_P__c, Insurance_MQL_CP_NA_Actual__c, Insurance_MQL_CP_NA_Goal__c, Insurance_MQL_CP_NA_Goal_TD__c, Insurance_MQL_CP_NA_Var__c, Insurance_MQL_CP_NA_Var_P__c, Insurance_SQO_CP_NA_Actual__c, Insurance_SQO_CP_NA_Goal__c, Insurance_SQO_CP_NA_Goal_TD__c, Insurance_SQO_CP_NA_Var__c, Insurance_SQO_CP_NA_Var_P__c, LastActivityDate, LastModifiedById, LastModifiedDate, Latin_America_ADS_CP_LA_Actual__c, Latin_America_ADS_CP_LA_Goal__c, Latin_America_ADS_CP_LA_Goal_TD__c, Latin_America_ADS_CP_LA_Var__c, Latin_America_ADS_CP_LA_Var_P__c, Latin_America_MQL_CP_LA_Actual__c, Latin_America_MQL_CP_LA_Goal__c, Latin_America_MQL_CP_LA_Goal_TD__c, Latin_America_MQL_CP_LA_Var__c, Latin_America_MQL_CP_LA_Var_P__c, Latin_America_SQO_CP_LA_Actual__c, Latin_America_SQO_CP_LA_Goal__c, Latin_America_SQO_CP_LA_Goal_TD__c, Latin_America_SQO_CP_LA_Var__c, Latin_America_SQO_CP_LA_Var_P__c, Manufacturing_ADS_CP_NA_Actual__c, Manufacturing_ADS_CP_NA_Goal__c, Manufacturing_ADS_CP_NA_Goal_TD__c, Manufacturing_ADS_CP_NA_Var__c, Manufacturing_ADS_CP_NA_Var_P__c, Manufacturing_MQL_CP_NA_Actual__c, Manufacturing_MQL_CP_NA_Goal__c, Manufacturing_MQL_CP_NA_Goal_TD__c, Manufacturing_MQL_CP_NA_Var__c, Manufacturing_MQL_CP_NA_Var_P__c, Manufacturing_SQO_CP_NA_Actual__c, Manufacturing_SQO_CP_NA_Goal__c, Manufacturing_SQO_CP_NA_Goal_TD__c, Manufacturing_SQO_CP_NA_Var__c, Manufacturing_SQO_CP_NA_Var_P__c, Month__c, NEMEA_ADS_CP_EA_Actual__c, NEMEA_ADS_CP_EA_Goal__c, NEMEA_ADS_CP_EA_Goal_TD__c, NEMEA_ADS_CP_EA_Var__c, NEMEA_ADS_CP_EA_Var_P__c, NEMEA_MQL_CP_EA_Actual__c, NEMEA_MQL_CP_EA_Goal__c, NEMEA_MQL_CP_EA_Goal_TD__c, NEMEA_MQL_CP_EA_Var__c, NEMEA_MQL_CP_EA_Var_P__c, NEMEA_SQO_CP_EA_Actual__c, NEMEA_SQO_CP_EA_Goal__c, NEMEA_SQO_CP_EA_Goal_TD__c, NEMEA_SQO_CP_EA_Var__c, NEMEA_SQO_CP_EA_Var_P__c, National_Govt_ADS_CP_NA_Actual__c, National_Govt_ADS_CP_NA_Goal__c, National_Govt_ADS_CP_NA_Goal_TD__c, National_Govt_ADS_CP_NA_Var__c, National_Govt_ADS_CP_NA_Var_P__c, National_Govt_MQL_CP_NA_Actual__c, National_Govt_MQL_CP_NA_Goal__c, National_Govt_MQL_CP_NA_Goal_TD__c, National_Govt_MQL_CP_NA_Var__c, National_Govt_MQL_CP_NA_Var_P__c, National_Govt_SQO_CP_NA_Actual__c, National_Govt_SQO_CP_NA_Goal__c, National_Govt_SQO_CP_NA_Goal_TD__c, National_Govt_SQO_CP_NA_Var__c, National_Govt_SQO_CP_NA_Var_P__c, OwnerId, Quarter__c, Id, Retail_ADS_CP_NA_Actual__c, Retail_ADS_CP_NA_Goal__c, Retail_ADS_CP_NA_Goal_TD__c, Retail_ADS_CP_NA_Var__c, Retail_ADS_CP_NA_Var_P__c, Retail_MQL_CP_NA_Actual__c, Retail_MQL_CP_NA_Goal__c, Retail_MQL_CP_NA_Goal_TD__c, Retail_MQL_CP_NA_Var__c, Retail_MQL_CP_NA_Var_P__c, Retail_SQO_CP_NA_Actual__c, Retail_SQO_CP_NA_Goal__c, Retail_SQO_CP_NA_Goal_TD__c, Retail_SQO_CP_NA_Var__c, Retail_SQO_CP_NA_Var_P__c, Search_ADS_EA_Actual__c, Search_ADS_EA_Goal__c, Search_ADS_EA_Goal_TD__c, Search_ADS_EA_Var__c, Search_ADS_EA_Var_P__c, Search_ADS_NA_Actual__c, Search_ADS_NA_Goal__c, Search_ADS_NA_Goal_TD__c, Search_ADS_NA_Var__c, Search_ADS_NA_Var_P__c, Search_MQL_EA_Actual__c, Search_MQL_EA_Goal__c, Search_MQL_EA_Goal_TD__c, Search_MQL_EA_Var__c, Search_MQL_EA_Var_P__c, Search_MQL_NA_Actual__c, Search_MQL_NA_Goal__c, Search_MQL_NA_Goal_TD__c, Search_MQL_NA_Var__c, Search_MQL_NA_Var_P__c, Search_SQO_EA_Actual__c, Search_SQO_EA_Goal__c, Search_SQO_EA_Goal_TD__c, Search_SQO_EA_Var__c, Search_SQO_EA_Var_P__c, Search_SQO_NA_Actual__c, Search_SQO_NA_Goal__c, Search_SQO_NA_Goal_TD__c, Search_SQO_NA_Var__c, Search_SQO_NA_Var_P__c, Start_Date__c, State_Local_ADS_CP_NA_Actual__c, State_Local_ADS_CP_NA_Goal__c, State_Local_ADS_CP_NA_Goal_TD__c, State_Local_ADS_CP_NA_Var__c, State_Local_ADS_CP_NA_Var_P__c, State_Local_MQL_CP_NA_Actual__c, State_Local_MQL_CP_NA_Goal__c, State_Local_MQL_CP_NA_Goal_TD__c, State_Local_MQL_CP_NA_Var__c, State_Local_MQL_CP_NA_Var_P__c, State_Local_SQO_CP_NA_Actual__c, State_Local_SQO_CP_NA_Goal__c, State_Local_SQO_CP_NA_Goal_TD__c, State_Local_SQO_CP_NA_Var__c, State_Local_SQO_CP_NA_Var_P__c, SystemModstamp, Total_ADS_EA_Actual__c, Total_ADS_EA_Goal__c, Total_ADS_EA_Goal_TD__c, Total_ADS_EA_Var__c, Total_ADS_EA_Var_P__c, Total_ADS_NA_Actual__c, Total_ADS_NA_Goal__c, Total_ADS_NA_Goal_TD__c, Total_ADS_NA_Var__c, Total_ADS_NA_Var_P__c, Total_ADS_CP_EA_Actual__c, Total_ADS_CP_EA_Goal__c, Total_ADS_CP_EA_Goal_TD__c, Total_ADS_CP_EA_Var__c, Total_ADS_CP_EA_Var_P__c, Total_ADS_CP_LA_Actual__c, Total_ADS_CP_LA_Goal__c, Total_ADS_CP_LA_Goal_TD__c, Total_ADS_CP_LA_Var__c, Total_ADS_CP_LA_Var_P__c, Total_ADS_CP_NA_Actual__c, Total_ADS_CP_NA_Goal__c, Total_ADS_CP_NA_Goal_TD__c, Total_ADS_CP_NA_Var__c, Total_ADS_CP_NA_Var_P__c, Total_MQL_EA_Actual__c, Total_MQL_EA_Goal__c, Total_MQL_EA_Goal_TD__c, Total_MQL_EA_Var__c, Total_MQL_EA_Var_P__c, Total_MQL_NA_Actual__c, Total_MQL_NA_Goal__c, Total_MQL_NA_Goal_TD__c, Total_MQL_NA_Var__c, Total_MQL_NA_Var_P__c, Total_MQL_CP_EA_Actual__c, Total_MQL_CP_EA_Goal__c, Total_MQL_CP_EA_Goal_TD__c, Total_MQL_CP_EA_Var__c, Total_MQL_CP_EA_Var_P__c, Total_MQL_CP_LA_Actual__c, Total_MQL_CP_LA_Goal__c, Total_MQL_CP_LA_Goal_TD__c, Total_MQL_CP_LA_Var__c, Total_MQL_CP_LA_Var_P__c, Total_MQL_CP_NA_Actual__c, Total_MQL_CP_NA_Goal__c, Total_MQL_CP_NA_Goal_TD__c, Total_MQL_CP_NA_Var__c, Total_MQL_CP_NA_Var_P__c, Total_SQO_EA_Actual__c, Total_SQO_EA_Goal__c, Total_SQO_EA_Goal_TD__c, Total_SQO_EA_Var__c, Total_SQO_EA_Var_P__c, Total_SQO_NA_Actual__c, Total_SQO_NA_Goal__c, Total_SQO_NA_Goal_TD__c, Total_SQO_NA_Var__c, Total_SQO_NA_Var_P__c, Total_SQO_CP_EA_Actual__c, Total_SQO_CP_EA_Goal__c, Total_SQO_CP_EA_Goal_TD__c, Total_SQO_CP_EA_Var__c, Total_SQO_CP_EA_Var_P__c, Total_SQO_CP_LA_Actual__c, Total_SQO_CP_LA_Goal__c, Total_SQO_CP_LA_Goal_TD__c, Total_SQO_CP_LA_Var__c, Total_SQO_CP_LA_Var_P__c, Total_SQO_CP_NA_Actual__c, Total_SQO_CP_NA_Goal__c, Total_SQO_CP_NA_Goal_TD__c, Total_SQO_CP_NA_Var__c, Total_SQO_CP_NA_Var_P__c, UKI_ADS_CP_EA_Actual__c, UKI_ADS_CP_EA_Goal__c, UKI_ADS_CP_EA_Goal_TD__c, UKI_ADS_CP_EA_Var__c, UKI_ADS_CP_EA_Var_P__c, UKI_MQL_CP_EA_Actual__c, UKI_MQL_CP_EA_Goal__c, UKI_MQL_CP_EA_Goal_TD__c, UKI_MQL_CP_EA_Var__c, UKI_MQL_CP_EA_Var_P__c, UKI_SQO_CP_EA_Actual__c, UKI_SQO_CP_EA_Goal__c, UKI_SQO_CP_EA_Goal_TD__c, UKI_SQO_CP_EA_Var__c, UKI_SQO_CP_EA_Var_P__c, View_MQL_NA_Actuals__c, View_MQL_CP_NA_Actuals__c, View_SQO_NA_Actuals__c, View_SQO_CP_NA_Actuals__c, Year__c FROM Goal__c where id =: theId];    
       return goalDataList;
   }
   
   public List<Goal__c> returnAverageDealSizeList(){
       
       theId = Apexpages.CurrentPage().getParameters().get('id');
       List<Goal__c> goalDataList = [SELECT Actuals_Last_Refreshed__c, Asia_Pacific_ADS_CP_EA_Actual__c, Asia_Pacific_ADS_CP_EA_Goal__c, Asia_Pacific_ADS_CP_EA_Goal_TD__c, Asia_Pacific_ADS_C_P_EA_Var__c, Asia_Pacific_ADS_CP_EA_Var__c, Asia_Pacific_ADS_CP_EA_Var_P__c, Asia_Pacific_ADS_C_P_EA_Var_P__c, Asia_Pacific_MQL_CP_EA_Actual__c, Asia_Pacific_MQL_CP_EA_Goal__c, Asia_Pacific_MQL_CP_EA_Goal_TD__c, Asia_Pacific_MQL_CP_EA_Var__c, Asia_Pacific_MQL_CP_EA_Var_P__c, Asia_Pacific_SQO_CP_EA_Actual__c, Asia_Pacific_SQO_CP_EA_Goal__c, Asia_Pacific_SQO_CP_EA_Goal_TD__c, Asia_Pacific_SQO_CP_EA_Var__c, Asia_Pacific_SQO_CP_EA_Var_P__c, Banking_ADS_CP_NA_Actual__c, Banking_ADS_CP_NA_Goal__c, Banking_ADS_CP_NA_Goal_TD__c, Banking_ADS_CP_NA_Var__c, Banking_ADS_CP_NA_Var_P__c, Banking_MQL_CP_NA_Actual__c, Banking_MQL_CP_NA_Goal__c, Banking_MQL_CP_NA_Goal_TD__c, Banking_MQL_CP_NA_Var__c, Banking_MQL_CP_NA_Var_P__c, Banking_SQO_CP_NA_Actual__c, Banking_SQO_CP_NA_Goal__c, Banking_SQO_CP_NA_Goal_TD__c, Banking_SQO_CP_NA_Var__c, Banking_SQO_CP_NA_Var_P__c, Capture_ADS_EA_Actual__c, Capture_ADS_EA_Goal__c, Capture_ADS_EA_Goal_TD__c, Capture_ADS_EA_Var__c, Capture_ADS_EA_Var_P__c, Capture_ADS_NA_Actual__c, Capture_ADS_NA_Goal__c, Capture_ADS_NA_Goal_TD__c, Capture_ADS_NA_Var__c, Capture_ADS_NA_Var_P__c, Capture_MQL_EA_Actual__c, Capture_MQL_EA_Goal__c, Capture_MQL_EA_Goal_TD__c, Capture_MQL_EA_Var__c, Capture_MQL_EA_Var_P__c, Capture_MQL_NA_Actual__c, Capture_MQL_NA_Goal__c, Capture_MQL_NA_Goal_TD__c, Capture_MQL_NA_Var__c, Capture_MQL_NA_Var_P__c, Capture_SQO_EA_Actual__c, Capture_SQO_EA_Goal__c, Capture_SQO_EA_Goal_TD__c, Capture_SQO_EA_Var__c, Capture_SQO_EA_Var_P__c, Capture_SQO_NA_Actual__c, Capture_SQO_NA_Goal__c, Capture_SQO_NA_Goal_TD__c, Capture_SQO_NA_Var__c, Capture_SQO_NA_Var_P__c, Content_Process_ADS_EA_Actual__c, Content_Process_ADS_EA_Goal__c, Content_Process_ADS_EA_Goal_TD__c, Content_Process_ADS_EA_Var__c, Content_Process_ADS_EA_Var_P__c, Content_Process_ADS_NA_Actual__c, Content_Process_ADS_NA_Goal__c, Content_Process_ADS_NA_Goal_TD__c, Content_Process_ADS_NA_Var__c, Content_Process_ADS_NA_Var_P__c, Content_Process_MQL_EA_Actual__c, Content_Process_MQL_EA_Goal__c, Content_Process_MQL_EA_Goal_TD__c, Content_Process_MQL_EA_Var__c, Content_Process_MQL_EA_Var_P__c, Content_Process_MQL_NA_Actual__c, Content_Process_MQL_NA_Goal__c, Content_Process_MQL_NA_Goal_TD__c, Content_Process_MQL_NA_Var__c, Content_Process_MQL_NA_Var_P__c, Content_Process_SQO_EA_Actual__c, Content_Process_SQO_EA_Goal__c, Content_Process_SQO_EA_Goal_TD__c, Content_Process_SQO_EA_Var__c, Content_Process_SQO_EA_Var_P__c, Content_Process_SQO_NA_Goal__c, Content_Process_SQO_NA_Goal_TD__c, Content_Process_SQO_NA_Var__c, Content_Process_SQO_NA_Var_P__c, Content_Process_SQO_NA_Actual__c, CreatedById, CreatedDate, CurrencyIsoCode, DACHEE_ADS_CP_EA_Goal__c, DACHEE_ADS_CP_EA_Goal_TD__c, DACHEE_ADS_CP_EA_Var__c, DACHEE_ADS_CP_EA_Var_P__c, DACHEE_MQL_CP_EA_Actual__c, DACHEE_MQL_CP_EA_Goal__c, DACHEE_MQL_CP_EA_Goal_TD__c, DACHEE_MQL_CP_EA_Var__c, DACHEE_MQL_CP_EA_Var_P__c, DACHEE_SQO_CP_EA_Actual__c, DACHEE_SQO_CP_EA_Goal__c, DACHEE_SQO_CP_EA_Goal_TD__c, DACHEE_SQO_CP_EA_Var__c, DACHEE_SQO_CP_EA_Var_P__c, IsDeleted, Education_ADS_CP_NA_Actual__c, Education_ADS_CP_NA_Goal__c, Education_ADS_CP_NA_Goal_TD__c, Education_ADS_CP_NA_Var__c, Education_ADS_CP_NA_Var_P__c, Education_MQL_CP_NA_Actual__c, Education_MQL_CP_NA_Goal__c, Education_MQL_CP_NA_Goal_TD__c, Education_MQL_CP_NA_Var__c, Education_MQL_CP_NA_Var_P__c, Education_SQO_CP_NA_Actual__c, Education_SQO_CP_NA_Goal__c, Education_SQO_CP_NA_Goal_TD__c, Education_SQO_CP_NA_Var__c, Education_SQO_CP_NA_Var_P__c, End_Date__c, FRA_ITA_ADS_CP_EA_Actual__c, FRA_ITA_ADS_CP_EA_Goal__c, FRA_ITA_ADS_CP_EA_Goal_TD__c, FRA_ITA_ADS_CP_EA_Var__c, FRA_ITA_ADS_CP_EA_Var_P__c, FRA_ITA_MQL_CP_EA_Actual__c, FRA_ITA_MQL_CP_EA_Goal__c, FRA_ITA_MQL_CP_EA_Goal_TD__c, FRA_ITA_MQL_CP_EA_Var__c, FRA_ITA_MQL_CP_EA_Var_P__c, FRA_ITA_SQO_CP_EA_Actual__c, FRA_ITA_SQO_CP_EA_Goal__c, FRA_ITA_SQO_CP_EA_Goal_TD__c, FRA_ITA_SQO_CP_EA_Var__c, FRA_ITA_SQO_CP_EA_Var_P__c, Name, Healthcare_ADS_CP_NA_Actual__c, Healthcare_ADS_CP_NA_Goal__c, Healthcare_ADS_CP_NA_Goal_TD__c, Healthcare_ADS_CP_NA_Var__c, Healthcare_ADS_CP_NA_Var_P__c, Healthcare_MQL_CP_NA_Actual__c, Healthcare_MQL_CP_NA_Goal__c, Healthcare_MQL_CP_NA_Goal_TD__c, Healthcare_MQL_CP_NA_Var__c, Healthcare_MQL_CP_NA_Var_P__c, Healthcare_SQO_CP_NA_Actual__c, Healthcare_SQO_CP_NA_Goal__c, Healthcare_SQO_CP_NA_Goal_TD__c, Healthcare_SQO_CP_NA_Var__c, Healthcare_SQO_CP_NA_Var_P__c, Insurance_ADS_C_P_NA_Actual__c, Insurance_ADS_C_P_NA_Goal__c, Insurance_ADS_C_P_NA_Goal_TD__c, Insurance_ADS_C_P_NA_Var__c, Insurance_ADS_C_P_NA_Var_P__c, Insurance_MQL_CP_NA_Actual__c, Insurance_MQL_CP_NA_Goal__c, Insurance_MQL_CP_NA_Goal_TD__c, Insurance_MQL_CP_NA_Var__c, Insurance_MQL_CP_NA_Var_P__c, Insurance_SQO_CP_NA_Actual__c, Insurance_SQO_CP_NA_Goal__c, Insurance_SQO_CP_NA_Goal_TD__c, Insurance_SQO_CP_NA_Var__c, Insurance_SQO_CP_NA_Var_P__c, LastActivityDate, LastModifiedById, LastModifiedDate, Latin_America_ADS_CP_LA_Actual__c, Latin_America_ADS_CP_LA_Goal__c, Latin_America_ADS_CP_LA_Goal_TD__c, Latin_America_ADS_CP_LA_Var__c, Latin_America_ADS_CP_LA_Var_P__c, Latin_America_MQL_CP_LA_Actual__c, Latin_America_MQL_CP_LA_Goal__c, Latin_America_MQL_CP_LA_Goal_TD__c, Latin_America_MQL_CP_LA_Var__c, Latin_America_MQL_CP_LA_Var_P__c, Latin_America_SQO_CP_LA_Actual__c, Latin_America_SQO_CP_LA_Goal__c, Latin_America_SQO_CP_LA_Goal_TD__c, Latin_America_SQO_CP_LA_Var__c, Latin_America_SQO_CP_LA_Var_P__c, Manufacturing_ADS_CP_NA_Actual__c, Manufacturing_ADS_CP_NA_Goal__c, Manufacturing_ADS_CP_NA_Goal_TD__c, Manufacturing_ADS_CP_NA_Var__c, Manufacturing_ADS_CP_NA_Var_P__c, Manufacturing_MQL_CP_NA_Actual__c, Manufacturing_MQL_CP_NA_Goal__c, Manufacturing_MQL_CP_NA_Goal_TD__c, Manufacturing_MQL_CP_NA_Var__c, Manufacturing_MQL_CP_NA_Var_P__c, Manufacturing_SQO_CP_NA_Actual__c, Manufacturing_SQO_CP_NA_Goal__c, Manufacturing_SQO_CP_NA_Goal_TD__c, Manufacturing_SQO_CP_NA_Var__c, Manufacturing_SQO_CP_NA_Var_P__c, Month__c, NEMEA_ADS_CP_EA_Actual__c, NEMEA_ADS_CP_EA_Goal__c, NEMEA_ADS_CP_EA_Goal_TD__c, NEMEA_ADS_CP_EA_Var__c, NEMEA_ADS_CP_EA_Var_P__c, NEMEA_MQL_CP_EA_Actual__c, NEMEA_MQL_CP_EA_Goal__c, NEMEA_MQL_CP_EA_Goal_TD__c, NEMEA_MQL_CP_EA_Var__c, NEMEA_MQL_CP_EA_Var_P__c, NEMEA_SQO_CP_EA_Actual__c, NEMEA_SQO_CP_EA_Goal__c, NEMEA_SQO_CP_EA_Goal_TD__c, NEMEA_SQO_CP_EA_Var__c, NEMEA_SQO_CP_EA_Var_P__c, National_Govt_ADS_CP_NA_Actual__c, National_Govt_ADS_CP_NA_Goal__c, National_Govt_ADS_CP_NA_Goal_TD__c, National_Govt_ADS_CP_NA_Var__c, National_Govt_ADS_CP_NA_Var_P__c, National_Govt_MQL_CP_NA_Actual__c, National_Govt_MQL_CP_NA_Goal__c, National_Govt_MQL_CP_NA_Goal_TD__c, National_Govt_MQL_CP_NA_Var__c, National_Govt_MQL_CP_NA_Var_P__c, National_Govt_SQO_CP_NA_Actual__c, National_Govt_SQO_CP_NA_Goal__c, National_Govt_SQO_CP_NA_Goal_TD__c, National_Govt_SQO_CP_NA_Var__c, National_Govt_SQO_CP_NA_Var_P__c, OwnerId, Quarter__c, Id, Retail_ADS_CP_NA_Actual__c, Retail_ADS_CP_NA_Goal__c, Retail_ADS_CP_NA_Goal_TD__c, Retail_ADS_CP_NA_Var__c, Retail_ADS_CP_NA_Var_P__c, Retail_MQL_CP_NA_Actual__c, Retail_MQL_CP_NA_Goal__c, Retail_MQL_CP_NA_Goal_TD__c, Retail_MQL_CP_NA_Var__c, Retail_MQL_CP_NA_Var_P__c, Retail_SQO_CP_NA_Actual__c, Retail_SQO_CP_NA_Goal__c, Retail_SQO_CP_NA_Goal_TD__c, Retail_SQO_CP_NA_Var__c, Retail_SQO_CP_NA_Var_P__c, Search_ADS_EA_Actual__c, Search_ADS_EA_Goal__c, Search_ADS_EA_Goal_TD__c, Search_ADS_EA_Var__c, Search_ADS_EA_Var_P__c, Search_ADS_NA_Actual__c, Search_ADS_NA_Goal__c, Search_ADS_NA_Goal_TD__c, Search_ADS_NA_Var__c, Search_ADS_NA_Var_P__c, Search_MQL_EA_Actual__c, Search_MQL_EA_Goal__c, Search_MQL_EA_Goal_TD__c, Search_MQL_EA_Var__c, Search_MQL_EA_Var_P__c, Search_MQL_NA_Actual__c, Search_MQL_NA_Goal__c, Search_MQL_NA_Goal_TD__c, Search_MQL_NA_Var__c, Search_MQL_NA_Var_P__c, Search_SQO_EA_Actual__c, Search_SQO_EA_Goal__c, Search_SQO_EA_Goal_TD__c, Search_SQO_EA_Var__c, Search_SQO_EA_Var_P__c, Search_SQO_NA_Actual__c, Search_SQO_NA_Goal__c, Search_SQO_NA_Goal_TD__c, Search_SQO_NA_Var__c, Search_SQO_NA_Var_P__c, Start_Date__c, State_Local_ADS_CP_NA_Actual__c, State_Local_ADS_CP_NA_Goal__c, State_Local_ADS_CP_NA_Goal_TD__c, State_Local_ADS_CP_NA_Var__c, State_Local_ADS_CP_NA_Var_P__c, State_Local_MQL_CP_NA_Actual__c, State_Local_MQL_CP_NA_Goal__c, State_Local_MQL_CP_NA_Goal_TD__c, State_Local_MQL_CP_NA_Var__c, State_Local_MQL_CP_NA_Var_P__c, State_Local_SQO_CP_NA_Actual__c, State_Local_SQO_CP_NA_Goal__c, State_Local_SQO_CP_NA_Goal_TD__c, State_Local_SQO_CP_NA_Var__c, State_Local_SQO_CP_NA_Var_P__c, SystemModstamp, Total_ADS_EA_Actual__c, Total_ADS_EA_Goal__c, Total_ADS_EA_Goal_TD__c, Total_ADS_EA_Var__c, Total_ADS_EA_Var_P__c, Total_ADS_NA_Actual__c, Total_ADS_NA_Goal__c, Total_ADS_NA_Goal_TD__c, Total_ADS_NA_Var__c, Total_ADS_NA_Var_P__c, Total_ADS_CP_EA_Actual__c, Total_ADS_CP_EA_Goal__c, Total_ADS_CP_EA_Goal_TD__c, Total_ADS_CP_EA_Var__c, Total_ADS_CP_EA_Var_P__c, Total_ADS_CP_LA_Actual__c, Total_ADS_CP_LA_Goal__c, Total_ADS_CP_LA_Goal_TD__c, Total_ADS_CP_LA_Var__c, Total_ADS_CP_LA_Var_P__c, Total_ADS_CP_NA_Actual__c, Total_ADS_CP_NA_Goal__c, Total_ADS_CP_NA_Goal_TD__c, Total_ADS_CP_NA_Var__c, Total_ADS_CP_NA_Var_P__c, Total_MQL_EA_Actual__c, Total_MQL_EA_Goal__c, Total_MQL_EA_Goal_TD__c, Total_MQL_EA_Var__c, Total_MQL_EA_Var_P__c, Total_MQL_NA_Actual__c, Total_MQL_NA_Goal__c, Total_MQL_NA_Goal_TD__c, Total_MQL_NA_Var__c, Total_MQL_NA_Var_P__c, Total_MQL_CP_EA_Actual__c, Total_MQL_CP_EA_Goal__c, Total_MQL_CP_EA_Goal_TD__c, Total_MQL_CP_EA_Var__c, Total_MQL_CP_EA_Var_P__c, Total_MQL_CP_LA_Actual__c, Total_MQL_CP_LA_Goal__c, Total_MQL_CP_LA_Goal_TD__c, Total_MQL_CP_LA_Var__c, Total_MQL_CP_LA_Var_P__c, Total_MQL_CP_NA_Actual__c, Total_MQL_CP_NA_Goal__c, Total_MQL_CP_NA_Goal_TD__c, Total_MQL_CP_NA_Var__c, Total_MQL_CP_NA_Var_P__c, Total_SQO_EA_Actual__c, Total_SQO_EA_Goal__c, Total_SQO_EA_Goal_TD__c, Total_SQO_EA_Var__c, Total_SQO_EA_Var_P__c, Total_SQO_NA_Actual__c, Total_SQO_NA_Goal__c, Total_SQO_NA_Goal_TD__c, Total_SQO_NA_Var__c, Total_SQO_NA_Var_P__c, Total_SQO_CP_EA_Actual__c, Total_SQO_CP_EA_Goal__c, Total_SQO_CP_EA_Goal_TD__c, Total_SQO_CP_EA_Var__c, Total_SQO_CP_EA_Var_P__c, Total_SQO_CP_LA_Actual__c, Total_SQO_CP_LA_Goal__c, Total_SQO_CP_LA_Goal_TD__c, Total_SQO_CP_LA_Var__c, Total_SQO_CP_LA_Var_P__c, Total_SQO_CP_NA_Actual__c, Total_SQO_CP_NA_Goal__c, Total_SQO_CP_NA_Goal_TD__c, Total_SQO_CP_NA_Var__c, Total_SQO_CP_NA_Var_P__c, UKI_ADS_CP_EA_Actual__c, UKI_ADS_CP_EA_Goal__c, UKI_ADS_CP_EA_Goal_TD__c, UKI_ADS_CP_EA_Var__c, UKI_ADS_CP_EA_Var_P__c, UKI_MQL_CP_EA_Actual__c, UKI_MQL_CP_EA_Goal__c, UKI_MQL_CP_EA_Goal_TD__c, UKI_MQL_CP_EA_Var__c, UKI_MQL_CP_EA_Var_P__c, UKI_SQO_CP_EA_Actual__c, UKI_SQO_CP_EA_Goal__c, UKI_SQO_CP_EA_Goal_TD__c, UKI_SQO_CP_EA_Var__c, UKI_SQO_CP_EA_Var_P__c, View_MQL_NA_Actuals__c, View_MQL_CP_NA_Actuals__c, View_SQO_NA_Actuals__c, View_SQO_CP_NA_Actuals__c, Year__c FROM Goal__c where id =: theId];    
       return goalDataList;
   }
   
   public List<Goal__c> returnExpGoalDataList(){
       
       theId = Apexpages.CurrentPage().getParameters().get('id');
       List<Goal__c> expGoalDataList = [SELECT Banking_EXP_CP_NA_Actual__c, Search_EXP_NA_Var__c, Search_EXP_NA_Var_P__c, Search_EXP_NA_Goal__c, Search_EXP_NA_Actual__c, Search_EXP_NA_Goal_TD__c, Banking_EXP_CP_NA_Goal__c, Banking_EXP_CP_NA_Goal_TD__c, Banking_EXP_CP_NA_Var__c, Banking_EXP_CP_NA_Var_P__c, Capture_EXP_NA_Goal_TD__c, Capture_EXP_NA_Goal__c, Capture_EXP_NA_Actual__c, Capture_EXP_NA_Var__c, Capture_EXP_NA_Var_P__c, Content_Process_EXP_EA_Actual__c, Content_Process_EXP_EA_Goal__c, Content_Process_EXP_EA_Goal_TD__c, Content_Process_EXP_EA_Var__c, Content_Process_EXP_EA_Var_P__c, Content_Process_EXP_NA_Actual__c, Content_Process_EXP_NA_Goal__c, Content_Process_EXP_NA_Goal_TD__c, Content_Process_EXP_NA_Var__c, Content_Process_EXP_NA_Var_P__c, Education_EXP_CP_NA_Actual__c, Education_EXP_CP_NA_Goal__c, Education_EXP_CP_NA_Goal_TD__c, Education_EXP_CP_NA_Var__c, Education_EXP_CP_NA_Var_P__c, Healthcare_EXP_CP_NA_Actual__c, Healthcare_EXP_CP_NA_Goal__c, Healthcare_EXP_CP_NA_Goal_TD__c, Healthcare_EXP_CP_NA_Var__c, Healthcare_EXP_CP_NA_Var_P__c, Insurance_EXP_CP_NA_Actual__c, Insurance_EXP_CP_NA_Goal__c, Insurance_EXP_CP_NA_Goal_TD__c, Insurance_EXP_CP_NA_Var__c, Insurance_EXP_CP_NA_Var_P__c, National_Govt_EXP_CP_NA_Actual__c, National_Govt_EXP_CP_NA_Goal__c, National_Govt_EXP_CP_NA_Goal_TD__c, National_Govt_EXP_CP_NA_Var__c, National_Govt_EXP_CP_NA_Var_P__c, Retail_EXP_CP_NA_Actual__c, Retail_EXP_CP_NA_Goal__c, Retail_EXP_CP_NA_Goal_TD__c, Retail_EXP_CP_NA_Var__c, Retail_EXP_CP_NA_Var_P__c, Search_EXP_EA_Actual__c, Search_EXP_EA_Goal__c, Search_EXP_EA_Goal_TD__c, Search_EXP_EA_Var__c, Search_EXP_EA_Var_P__c, State_Local_EXP_CP_NA_Actual__c, State_Local_EXP_CP_NA_Goal__c, State_Local_EXP_CP_NA_Goal_TD__c, State_Local_EXP_CP_NA_Var__c, State_Local_EXP_CP_NA_Var_P__c, Total_EXP_EA_Actual__c, Total_EXP_EA_Goal__c, Total_EXP_EA_Goal_TD__c, Total_EXP_EA_Var__c, Total_EXP_EA_Var_P__c, Total_EXP_NA_Actual__c, Total_EXP_NA_Goal__c, Total_EXP_NA_Goal_TD__c, Total_EXP_NA_Var__c, Total_EXP_NA_Var_P__c, Total_EXP_CP_EA_Actual__c, Total_EXP_CP_EA_Goal__c, Total_EXP_CP_EA_Goal_TD__c, Total_EXP_CP_EA_Var__c, Total_EXP_CP_EA_Var_P__c, Total_EXP_CP_LA_Actual__c, Total_EXP_CP_LA_Goal__c, Total_EXP_CP_LA_Goal_TD__c, Total_EXP_CP_LA_Var__c, Total_EXP_CP_LA_Var_P__c, Latin_America_EXP_CP_LA_Actual__c, Latin_America_EXP_CP_LA_Goal__c, Latin_America_EXP_CP_LA_Goal_TD__c, Latin_America_EXP_CP_LA_Var__c, Latin_America_EXP_CP_LA_Var_P__c FROM Goal__c where id =: theId];    
       return expGoalDataList;
   }
   public pageReference displayReportData(){
       
        
       
       //goalDataList = [SELECT Actuals_Last_Refreshed__c, Asia_Pacific_ADS_CP_EA_Actual__c, Asia_Pacific_ADS_CP_EA_Goal__c, Asia_Pacific_ADS_CP_EA_Goal_TD__c, Asia_Pacific_ADS_CP_EA_Var__c, Asia_Pacific_ADS_C_P_EA_Var__c, Asia_Pacific_ADS_CP_EA_Var_P__c, Asia_Pacific_ADS_C_P_EA_Var_P__c, Asia_Pacific_MQL_CP_EA_Actual__c, Asia_Pacific_MQL_CP_EA_Goal__c, Asia_Pacific_MQL_CP_EA_Goal_TD__c, Asia_Pacific_MQL_CP_EA_Var__c, Asia_Pacific_MQL_CP_EA_Var_P__c, Asia_Pacific_SQO_CP_EA_Actual__c, Asia_Pacific_SQO_CP_EA_Goal__c, Asia_Pacific_SQO_CP_EA_Goal_TD__c, Asia_Pacific_SQO_CP_EA_Var__c, Asia_Pacific_SQO_CP_EA_Var_P__c, Banking_ADS_CP_NA_Actual__c, Banking_ADS_CP_NA_Goal__c, Banking_ADS_CP_NA_Goal_TD__c, Banking_ADS_CP_NA_Var__c, Banking_ADS_CP_NA_Var_P__c, Banking_MQL_CP_NA_Actual__c, Banking_MQL_CP_NA_Goal__c, Banking_MQL_CP_NA_Goal_TD__c, Banking_MQL_CP_NA_Var__c, Banking_MQL_CP_NA_Var_P__c, Banking_SQO_CP_NA_Actual__c, Banking_SQO_CP_NA_Goal__c, Banking_SQO_CP_NA_Goal_TD__c, Banking_SQO_CP_NA_Var__c, Banking_SQO_CP_NA_Var_P__c, Capture_ADS_EA_Actual__c, Capture_ADS_EA_Goal__c, Capture_ADS_EA_Goal_TD__c, Capture_ADS_EA_Var__c, Capture_ADS_EA_Var_P__c, Capture_MQL_EA_Actual__c, Capture_MQL_EA_Goal__c, Capture_MQL_EA_Goal_TD__c, Capture_MQL_EA_Var__c, Capture_MQL_EA_Var_P__c, Capture_MQL_NA_Actual__c, Capture_MQL_NA_Goal__c, Capture_MQL_NA_Goal_TD__c, Capture_MQL_NA_Var__c, Capture_MQL_NA_Var_P__c, Capture_SQO_EA_Actual__c, Capture_SQO_EA_Goal__c, Capture_SQO_EA_Goal_TD__c, Capture_SQO_EA_Var__c, Capture_SQO_EA_Var_P__c, Capture_SQO_NA_Actual__c, Capture_SQO_NA_Goal__c, Capture_SQO_NA_Goal_TD__c, Capture_SQO_NA_Var__c, Capture_SQO_NA_Var_P__c, Content_Process_ADS_EA_Actual__c, Content_Process_ADS_EA_Goal__c, Content_Process_ADS_EA_Goal_TD__c, Content_Process_ADS_EA_Var__c, Content_Process_ADS_EA_Var_P__c, Content_Process_ADS_NA_Actual__c, Content_Process_MQL_EA_Actual__c, Content_Process_MQL_EA_Goal__c, Content_Process_MQL_EA_Goal_TD__c, Content_Process_MQL_EA_Var__c, Content_Process_MQL_EA_Var_P__c, Content_Process_MQL_NA_Actual__c, Content_Process_MQL_NA_Goal__c, Content_Process_MQL_NA_Goal_TD__c, Content_Process_MQL_NA_Var__c, Content_Process_MQL_NA_Var_P__c, Content_Process_SQO_EA_Actual__c, Content_Process_SQO_EA_Goal__c, Content_Process_SQO_EA_Goal_TD__c, Content_Process_SQO_EA_Var__c, Content_Process_SQO_EA_Var_P__c, Content_Process_SQO_NA_Goal__c, Content_Process_SQO_NA_Goal_TD__c, Content_Process_SQO_NA_Var__c, Content_Process_SQO_NA_Var_P__c, Content_Process_SQO_NA_Actual__c, CreatedById, CreatedDate, CurrencyIsoCode, DACHEE_ADS_CP_EA_Goal__c, DACHEE_ADS_CP_EA_Goal_TD__c, DACHEE_ADS_CP_EA_Var__c, DACHEE_ADS_CP_EA_Var_P__c, DACHEE_MQL_CP_EA_Actual__c, DACHEE_MQL_CP_EA_Goal__c, DACHEE_MQL_CP_EA_Goal_TD__c, DACHEE_MQL_CP_EA_Var__c, DACHEE_MQL_CP_EA_Var_P__c, DACHEE_SQO_CP_EA_Actual__c, DACHEE_SQO_CP_EA_Goal__c, DACHEE_SQO_CP_EA_Goal_TD__c, DACHEE_SQO_CP_EA_Var__c, DACHEE_SQO_CP_EA_Var_P__c, IsDeleted, Education_ADS_CP_NA_Actual__c, Education_ADS_CP_NA_Goal__c, Education_ADS_CP_NA_Goal_TD__c, Education_ADS_CP_NA_Var__c, Education_ADS_CP_NA_Var_P__c, Education_MQL_CP_NA_Actual__c, Education_MQL_CP_NA_Goal__c, Education_MQL_CP_NA_Goal_TD__c, Education_MQL_CP_NA_Var__c, Education_MQL_CP_NA_Var_P__c, Education_SQO_CP_NA_Actual__c, Education_SQO_CP_NA_Goal__c, Education_SQO_CP_NA_Goal_TD__c, Education_SQO_CP_NA_Var__c, Education_SQO_CP_NA_Var_P__c, End_Date__c, FRA_ITA_ADS_CP_EA_Actual__c, FRA_ITA_ADS_CP_EA_Goal__c, FRA_ITA_ADS_CP_EA_Goal_TD__c, FRA_ITA_ADS_CP_EA_Var__c, FRA_ITA_ADS_CP_EA_Var_P__c, FRA_ITA_MQL_CP_EA_Actual__c, FRA_ITA_MQL_CP_EA_Goal__c, FRA_ITA_MQL_CP_EA_Goal_TD__c, FRA_ITA_MQL_CP_EA_Var__c, FRA_ITA_MQL_CP_EA_Var_P__c, FRA_ITA_SQO_CP_EA_Actual__c, FRA_ITA_SQO_CP_EA_Goal__c, FRA_ITA_SQO_CP_EA_Goal_TD__c, FRA_ITA_SQO_CP_EA_Var__c, FRA_ITA_SQO_CP_EA_Var_P__c, Name, Healthcare_ADS_CP_NA_Actual__c, Healthcare_ADS_CP_NA_Goal__c, Healthcare_ADS_CP_NA_Goal_TD__c, Healthcare_ADS_CP_NA_Var__c, Healthcare_ADS_CP_NA_Var_P__c, Healthcare_MQL_CP_NA_Actual__c, Healthcare_MQL_CP_NA_Goal__c, Healthcare_MQL_CP_NA_Goal_TD__c, Healthcare_MQL_CP_NA_Var__c, Healthcare_MQL_CP_NA_Var_P__c, Healthcare_SQO_CP_NA_Actual__c, Healthcare_SQO_CP_NA_Goal__c, Healthcare_SQO_CP_NA_Goal_TD__c, Healthcare_SQO_CP_NA_Var__c, Healthcare_SQO_CP_NA_Var_P__c, Insurance_ADS_C_P_NA_Actual__c, Insurance_ADS_C_P_NA_Goal__c, Insurance_ADS_C_P_NA_Goal_TD__c, Insurance_ADS_C_P_NA_Var__c, Insurance_ADS_C_P_NA_Var_P__c, Insurance_MQL_CP_NA_Actual__c, Insurance_MQL_CP_NA_Goal__c, Insurance_MQL_CP_NA_Goal_TD__c, Insurance_MQL_CP_NA_Var__c, Insurance_MQL_CP_NA_Var_P__c, Insurance_SQO_CP_NA_Actual__c, Insurance_SQO_CP_NA_Goal__c, Insurance_SQO_CP_NA_Goal_TD__c, Insurance_SQO_CP_NA_Var__c, Insurance_SQO_CP_NA_Var_P__c, LastActivityDate, LastModifiedById, LastModifiedDate, Latin_America_ADS_CP_LA_Actual__c, Latin_America_ADS_CP_LA_Goal__c, Latin_America_ADS_CP_LA_Goal_TD__c, Latin_America_ADS_CP_LA_Var__c, Latin_America_ADS_CP_LA_Var_P__c, Latin_America_MQL_CP_LA_Actual__c, Latin_America_MQL_CP_LA_Goal__c, Latin_America_MQL_CP_LA_Goal_TD__c, Latin_America_MQL_CP_LA_Var__c, Latin_America_MQL_CP_LA_Var_P__c, Latin_America_SQO_CP_LA_Actual__c, Latin_America_SQO_CP_LA_Goal__c, Latin_America_SQO_CP_LA_Goal_TD__c, Latin_America_SQO_CP_LA_Var__c, Latin_America_SQO_CP_LA_Var_P__c, Manufacturing_ADS_CP_NA_Actual__c, Manufacturing_ADS_CP_NA_Goal__c, Manufacturing_ADS_CP_NA_Goal_TD__c, Manufacturing_ADS_CP_NA_Var__c, Manufacturing_ADS_CP_NA_Var_P__c, Manufacturing_MQL_CP_NA_Actual__c, Manufacturing_MQL_CP_NA_Goal__c, Manufacturing_MQL_CP_NA_Goal_TD__c, Manufacturing_MQL_CP_NA_Var__c, Manufacturing_MQL_CP_NA_Var_P__c, Manufacturing_SQO_CP_NA_Actual__c, Manufacturing_SQO_CP_NA_Goal__c, Manufacturing_SQO_CP_NA_Goal_TD__c, Manufacturing_SQO_CP_NA_Var__c, Manufacturing_SQO_CP_NA_Var_P__c, Month__c, NEMEA_ADS_CP_EA_Actual__c, NEMEA_ADS_CP_EA_Goal__c, NEMEA_ADS_CP_EA_Goal_TD__c, NEMEA_ADS_CP_EA_Var__c, NEMEA_ADS_CP_EA_Var_P__c, NEMEA_MQL_CP_EA_Actual__c, NEMEA_MQL_CP_EA_Goal__c, NEMEA_MQL_CP_EA_Goal_TD__c, NEMEA_MQL_CP_EA_Var__c, NEMEA_MQL_CP_EA_Var_P__c, NEMEA_SQO_CP_EA_Actual__c, NEMEA_SQO_CP_EA_Goal__c, NEMEA_SQO_CP_EA_Goal_TD__c, NEMEA_SQO_CP_EA_Var__c, NEMEA_SQO_CP_EA_Var_P__c, National_Govt_ADS_CP_NA_Actual__c, National_Govt_ADS_CP_NA_Goal__c, National_Govt_ADS_CP_NA_Goal_TD__c, National_Govt_ADS_CP_NA_Var__c, National_Govt_ADS_CP_NA_Var_P__c, National_Govt_MQL_CP_NA_Actual__c, National_Govt_MQL_CP_NA_Goal__c, National_Govt_MQL_CP_NA_Goal_TD__c, National_Govt_MQL_CP_NA_Var__c, National_Govt_MQL_CP_NA_Var_P__c, National_Govt_SQO_CP_NA_Actual__c, National_Govt_SQO_CP_NA_Goal__c, National_Govt_SQO_CP_NA_Goal_TD__c, National_Govt_SQO_CP_NA_Var__c, National_Govt_SQO_CP_NA_Var_P__c, OwnerId, Quarter__c, Id, Retail_ADS_CP_NA_Actual__c, Retail_ADS_CP_NA_Goal__c, Retail_ADS_CP_NA_Goal_TD__c, Retail_ADS_CP_NA_Var__c, Retail_ADS_CP_NA_Var_P__c, Retail_MQL_CP_NA_Actual__c, Retail_MQL_CP_NA_Goal__c, Retail_MQL_CP_NA_Goal_TD__c, Retail_MQL_CP_NA_Var__c, Retail_MQL_CP_NA_Var_P__c, Retail_SQO_CP_NA_Actual__c, Retail_SQO_CP_NA_Goal__c, Retail_SQO_CP_NA_Goal_TD__c, Retail_SQO_CP_NA_Var__c, Retail_SQO_CP_NA_Var_P__c, Search_ADS_EA_Actual__c, Search_ADS_EA_Goal__c, Search_ADS_EA_Goal_TD__c, Search_ADS_EA_Var__c, Search_ADS_EA_Var_P__c, Search_MQL_EA_Actual__c, Search_MQL_EA_Goal__c, Search_MQL_EA_Goal_TD__c, Search_MQL_EA_Var__c, Search_MQL_EA_Var_P__c, Search_MQL_NA_Actual__c, Search_MQL_NA_Goal__c, Search_MQL_NA_Goal_TD__c, Search_MQL_NA_Var__c, Search_MQL_NA_Var_P__c, Search_SQO_EA_Actual__c, Search_SQO_EA_Goal__c, Search_SQO_EA_Goal_TD__c, Search_SQO_EA_Var__c, Search_SQO_EA_Var_P__c, Search_SQO_NA_Actual__c, Search_SQO_NA_Goal__c, Search_SQO_NA_Goal_TD__c, Search_SQO_NA_Var__c, Search_SQO_NA_Var_P__c, Start_Date__c, State_Local_ADS_CP_NA_Actual__c, State_Local_ADS_CP_NA_Goal__c, State_Local_ADS_CP_NA_Goal_TD__c, State_Local_ADS_CP_NA_Var__c, State_Local_ADS_CP_NA_Var_P__c, State_Local_MQL_CP_NA_Actual__c, State_Local_MQL_CP_NA_Goal__c, State_Local_MQL_CP_NA_Goal_TD__c, State_Local_MQL_CP_NA_Var__c, State_Local_MQL_CP_NA_Var_P__c, State_Local_SQO_CP_NA_Actual__c, State_Local_SQO_CP_NA_Goal__c, State_Local_SQO_CP_NA_Goal_TD__c, State_Local_SQO_CP_NA_Var__c, State_Local_SQO_CP_NA_Var_P__c, SystemModstamp, Total_ADS_EA_Actual__c, Total_ADS_EA_Goal__c, Total_ADS_EA_Goal_TD__c, Total_ADS_EA_Var__c, Total_ADS_EA_Var_P__c, Total_ADS_NA_Actual__c, Total_ADS_NA_Goal__c, Total_ADS_NA_Goal_TD__c, Total_ADS_NA_Var__c, Total_ADS_NA_Var_P__c, Total_ADS_CP_EA_Actual__c, Total_ADS_CP_EA_Goal__c, Total_ADS_CP_EA_Goal_TD__c, Total_ADS_CP_EA_Var__c, Total_ADS_CP_EA_Var_P__c, Total_ADS_CP_LA_Actual__c, Total_ADS_CP_LA_Goal__c, Total_ADS_CP_LA_Goal_TD__c, Total_ADS_CP_LA_Var__c, Total_ADS_CP_LA_Var_P__c, Total_ADS_CP_NA_Actual__c, Total_ADS_CP_NA_Goal__c, Total_ADS_CP_NA_Goal_TD__c, Total_ADS_CP_NA_Var__c, Total_ADS_CP_NA_Var_P__c, Total_MQL_EA_Actual__c, Total_MQL_EA_Goal__c, Total_MQL_EA_Goal_TD__c, Total_MQL_EA_Var__c, Total_MQL_EA_Var_P__c, Total_MQL_NA_Actual__c, Total_MQL_NA_Goal__c, Total_MQL_NA_Goal_TD__c, Total_MQL_NA_Var__c, Total_MQL_NA_Var_P__c, Total_MQL_CP_EA_Actual__c, Total_MQL_CP_EA_Goal__c, Total_MQL_CP_EA_Goal_TD__c, Total_MQL_CP_EA_Var__c, Total_MQL_CP_EA_Var_P__c, Total_MQL_CP_LA_Actual__c, Total_MQL_CP_LA_Goal__c, Total_MQL_CP_LA_Goal_TD__c, Total_MQL_CP_LA_Var__c, Total_MQL_CP_LA_Var_P__c, Total_MQL_CP_NA_Actual__c, Total_MQL_CP_NA_Goal__c, Total_MQL_CP_NA_Goal_TD__c, Total_MQL_CP_NA_Var__c, Total_MQL_CP_NA_Var_P__c, Total_SQO_EA_Actual__c, Total_SQO_EA_Goal__c, Total_SQO_EA_Goal_TD__c, Total_SQO_EA_Var__c, Total_SQO_EA_Var_P__c, Total_SQO_NA_Actual__c, Total_SQO_NA_Goal__c, Total_SQO_NA_Goal_TD__c, Total_SQO_NA_Var__c, Total_SQO_NA_Var_P__c, Total_SQO_CP_EA_Actual__c, Total_SQO_CP_EA_Goal__c, Total_SQO_CP_EA_Goal_TD__c, Total_SQO_CP_EA_Var__c, Total_SQO_CP_EA_Var_P__c, Total_SQO_CP_LA_Actual__c, Total_SQO_CP_LA_Goal__c, Total_SQO_CP_LA_Goal_TD__c, Total_SQO_CP_LA_Var__c, Total_SQO_CP_LA_Var_P__c, Total_SQO_CP_NA_Actual__c, Total_SQO_CP_NA_Goal__c, Total_SQO_CP_NA_Goal_TD__c, Total_SQO_CP_NA_Var__c, Total_SQO_CP_NA_Var_P__c, UKI_ADS_CP_EA_Actual__c, UKI_ADS_CP_EA_Goal__c, UKI_ADS_CP_EA_Goal_TD__c, UKI_ADS_CP_EA_Var__c, UKI_ADS_CP_EA_Var_P__c, UKI_MQL_CP_EA_Actual__c, UKI_MQL_CP_EA_Goal__c, UKI_MQL_CP_EA_Goal_TD__c, UKI_MQL_CP_EA_Var__c, UKI_MQL_CP_EA_Var_P__c, UKI_SQO_CP_EA_Actual__c, UKI_SQO_CP_EA_Goal__c, UKI_SQO_CP_EA_Goal_TD__c, UKI_SQO_CP_EA_Var__c, UKI_SQO_CP_EA_Var_P__c, View_MQL_NA_Actuals__c, View_MQL_CP_NA_Actuals__c, View_SQO_NA_Actuals__c, View_SQO_CP_NA_Actuals__c, Year__c FROM Goal__c where id =: theId];
       //goalDataList = [SELECT Actuals_Last_Refreshed__c, Asia_Pacific_ADS_CP_EA_Actual__c, Asia_Pacific_ADS_CP_EA_Goal__c, Asia_Pacific_ADS_CP_EA_Goal_TD__c, Asia_Pacific_ADS_C_P_EA_Var__c, Asia_Pacific_ADS_CP_EA_Var__c, Asia_Pacific_ADS_CP_EA_Var_P__c, Asia_Pacific_ADS_C_P_EA_Var_P__c, Asia_Pacific_MQL_CP_EA_Actual__c, Asia_Pacific_MQL_CP_EA_Goal__c, Asia_Pacific_MQL_CP_EA_Goal_TD__c, Asia_Pacific_MQL_CP_EA_Var__c, Asia_Pacific_MQL_CP_EA_Var_P__c, Asia_Pacific_SQO_CP_EA_Actual__c, Asia_Pacific_SQO_CP_EA_Goal__c, Asia_Pacific_SQO_CP_EA_Goal_TD__c, Asia_Pacific_SQO_CP_EA_Var__c, Asia_Pacific_SQO_CP_EA_Var_P__c, Banking_ADS_CP_NA_Actual__c, Banking_ADS_CP_NA_Goal__c, Banking_ADS_CP_NA_Goal_TD__c, Banking_ADS_CP_NA_Var__c, Banking_ADS_CP_NA_Var_P__c, Banking_MQL_CP_NA_Actual__c, Banking_MQL_CP_NA_Goal__c, Banking_MQL_CP_NA_Goal_TD__c, Banking_MQL_CP_NA_Var__c, Banking_MQL_CP_NA_Var_P__c, Banking_SQO_CP_NA_Actual__c, Banking_SQO_CP_NA_Goal__c, Banking_SQO_CP_NA_Goal_TD__c, Banking_SQO_CP_NA_Var__c, Banking_SQO_CP_NA_Var_P__c, Capture_ADS_EA_Actual__c, Capture_ADS_EA_Goal__c, Capture_ADS_EA_Goal_TD__c, Capture_ADS_EA_Var__c, Capture_ADS_EA_Var_P__c, Capture_ADS_NA_Actual__c, Capture_ADS_NA_Goal__c, Capture_ADS_NA_Goal_TD__c, Capture_ADS_NA_Var__c, Capture_ADS_NA_Var_P__c, Capture_MQL_EA_Actual__c, Capture_MQL_EA_Goal__c, Capture_MQL_EA_Goal_TD__c, Capture_MQL_EA_Var__c, Capture_MQL_EA_Var_P__c, Capture_MQL_NA_Actual__c, Capture_MQL_NA_Goal__c, Capture_MQL_NA_Goal_TD__c, Capture_MQL_NA_Var__c, Capture_MQL_NA_Var_P__c, Capture_SQO_EA_Actual__c, Capture_SQO_EA_Goal__c, Capture_SQO_EA_Goal_TD__c, Capture_SQO_EA_Var__c, Capture_SQO_EA_Var_P__c, Capture_SQO_NA_Actual__c, Capture_SQO_NA_Goal__c, Capture_SQO_NA_Goal_TD__c, Capture_SQO_NA_Var__c, Capture_SQO_NA_Var_P__c, Content_Process_ADS_EA_Actual__c, Content_Process_ADS_EA_Goal__c, Content_Process_ADS_EA_Goal_TD__c, Content_Process_ADS_EA_Var__c, Content_Process_ADS_EA_Var_P__c, Content_Process_ADS_NA_Actual__c, Content_Process_ADS_NA_Goal__c, Content_Process_ADS_NA_Goal_TD__c, Content_Process_ADS_NA_Var__c, Content_Process_ADS_NA_Var_P__c, Content_Process_MQL_EA_Actual__c, Content_Process_MQL_EA_Goal__c, Content_Process_MQL_EA_Goal_TD__c, Content_Process_MQL_EA_Var__c, Content_Process_MQL_EA_Var_P__c, Content_Process_MQL_NA_Actual__c, Content_Process_MQL_NA_Goal__c, Content_Process_MQL_NA_Goal_TD__c, Content_Process_MQL_NA_Var__c, Content_Process_MQL_NA_Var_P__c, Content_Process_SQO_EA_Actual__c, Content_Process_SQO_EA_Goal__c, Content_Process_SQO_EA_Goal_TD__c, Content_Process_SQO_EA_Var__c, Content_Process_SQO_EA_Var_P__c, Content_Process_SQO_NA_Goal__c, Content_Process_SQO_NA_Goal_TD__c, Content_Process_SQO_NA_Var__c, Content_Process_SQO_NA_Var_P__c, Content_Process_SQO_NA_Actual__c, CreatedById, CreatedDate, CurrencyIsoCode, DACHEE_ADS_CP_EA_Goal__c, DACHEE_ADS_CP_EA_Goal_TD__c, DACHEE_ADS_CP_EA_Var__c, DACHEE_ADS_CP_EA_Var_P__c, DACHEE_MQL_CP_EA_Actual__c, DACHEE_MQL_CP_EA_Goal__c, DACHEE_MQL_CP_EA_Goal_TD__c, DACHEE_MQL_CP_EA_Var__c, DACHEE_MQL_CP_EA_Var_P__c, DACHEE_SQO_CP_EA_Actual__c, DACHEE_SQO_CP_EA_Goal__c, DACHEE_SQO_CP_EA_Goal_TD__c, DACHEE_SQO_CP_EA_Var__c, DACHEE_SQO_CP_EA_Var_P__c, IsDeleted, Education_ADS_CP_NA_Actual__c, Education_ADS_CP_NA_Goal__c, Education_ADS_CP_NA_Goal_TD__c, Education_ADS_CP_NA_Var__c, Education_ADS_CP_NA_Var_P__c, Education_MQL_CP_NA_Actual__c, Education_MQL_CP_NA_Goal__c, Education_MQL_CP_NA_Goal_TD__c, Education_MQL_CP_NA_Var__c, Education_MQL_CP_NA_Var_P__c, Education_SQO_CP_NA_Actual__c, Education_SQO_CP_NA_Goal__c, Education_SQO_CP_NA_Goal_TD__c, Education_SQO_CP_NA_Var__c, Education_SQO_CP_NA_Var_P__c, End_Date__c, FRA_ITA_ADS_CP_EA_Actual__c, FRA_ITA_ADS_CP_EA_Goal__c, FRA_ITA_ADS_CP_EA_Goal_TD__c, FRA_ITA_ADS_CP_EA_Var__c, FRA_ITA_ADS_CP_EA_Var_P__c, FRA_ITA_MQL_CP_EA_Actual__c, FRA_ITA_MQL_CP_EA_Goal__c, FRA_ITA_MQL_CP_EA_Goal_TD__c, FRA_ITA_MQL_CP_EA_Var__c, FRA_ITA_MQL_CP_EA_Var_P__c, FRA_ITA_SQO_CP_EA_Actual__c, FRA_ITA_SQO_CP_EA_Goal__c, FRA_ITA_SQO_CP_EA_Goal_TD__c, FRA_ITA_SQO_CP_EA_Var__c, FRA_ITA_SQO_CP_EA_Var_P__c, Name, Healthcare_ADS_CP_NA_Actual__c, Healthcare_ADS_CP_NA_Goal__c, Healthcare_ADS_CP_NA_Goal_TD__c, Healthcare_ADS_CP_NA_Var__c, Healthcare_ADS_CP_NA_Var_P__c, Healthcare_MQL_CP_NA_Actual__c, Healthcare_MQL_CP_NA_Goal__c, Healthcare_MQL_CP_NA_Goal_TD__c, Healthcare_MQL_CP_NA_Var__c, Healthcare_MQL_CP_NA_Var_P__c, Healthcare_SQO_CP_NA_Actual__c, Healthcare_SQO_CP_NA_Goal__c, Healthcare_SQO_CP_NA_Goal_TD__c, Healthcare_SQO_CP_NA_Var__c, Healthcare_SQO_CP_NA_Var_P__c, Insurance_ADS_C_P_NA_Actual__c, Insurance_ADS_C_P_NA_Goal__c, Insurance_ADS_C_P_NA_Goal_TD__c, Insurance_ADS_C_P_NA_Var__c, Insurance_ADS_C_P_NA_Var_P__c, Insurance_MQL_CP_NA_Actual__c, Insurance_MQL_CP_NA_Goal__c, Insurance_MQL_CP_NA_Goal_TD__c, Insurance_MQL_CP_NA_Var__c, Insurance_MQL_CP_NA_Var_P__c, Insurance_SQO_CP_NA_Actual__c, Insurance_SQO_CP_NA_Goal__c, Insurance_SQO_CP_NA_Goal_TD__c, Insurance_SQO_CP_NA_Var__c, Insurance_SQO_CP_NA_Var_P__c, LastActivityDate, LastModifiedById, LastModifiedDate, Latin_America_ADS_CP_LA_Actual__c, Latin_America_ADS_CP_LA_Goal__c, Latin_America_ADS_CP_LA_Goal_TD__c, Latin_America_ADS_CP_LA_Var__c, Latin_America_ADS_CP_LA_Var_P__c, Latin_America_MQL_CP_LA_Actual__c, Latin_America_MQL_CP_LA_Goal__c, Latin_America_MQL_CP_LA_Goal_TD__c, Latin_America_MQL_CP_LA_Var__c, Latin_America_MQL_CP_LA_Var_P__c, Latin_America_SQO_CP_LA_Actual__c, Latin_America_SQO_CP_LA_Goal__c, Latin_America_SQO_CP_LA_Goal_TD__c, Latin_America_SQO_CP_LA_Var__c, Latin_America_SQO_CP_LA_Var_P__c, Manufacturing_ADS_CP_NA_Actual__c, Manufacturing_ADS_CP_NA_Goal__c, Manufacturing_ADS_CP_NA_Goal_TD__c, Manufacturing_ADS_CP_NA_Var__c, Manufacturing_ADS_CP_NA_Var_P__c, Manufacturing_MQL_CP_NA_Actual__c, Manufacturing_MQL_CP_NA_Goal__c, Manufacturing_MQL_CP_NA_Goal_TD__c, Manufacturing_MQL_CP_NA_Var__c, Manufacturing_MQL_CP_NA_Var_P__c, Manufacturing_SQO_CP_NA_Actual__c, Manufacturing_SQO_CP_NA_Goal__c, Manufacturing_SQO_CP_NA_Goal_TD__c, Manufacturing_SQO_CP_NA_Var__c, Manufacturing_SQO_CP_NA_Var_P__c, Month__c, NEMEA_ADS_CP_EA_Actual__c, NEMEA_ADS_CP_EA_Goal__c, NEMEA_ADS_CP_EA_Goal_TD__c, NEMEA_ADS_CP_EA_Var__c, NEMEA_ADS_CP_EA_Var_P__c, NEMEA_MQL_CP_EA_Actual__c, NEMEA_MQL_CP_EA_Goal__c, NEMEA_MQL_CP_EA_Goal_TD__c, NEMEA_MQL_CP_EA_Var__c, NEMEA_MQL_CP_EA_Var_P__c, NEMEA_SQO_CP_EA_Actual__c, NEMEA_SQO_CP_EA_Goal__c, NEMEA_SQO_CP_EA_Goal_TD__c, NEMEA_SQO_CP_EA_Var__c, NEMEA_SQO_CP_EA_Var_P__c, National_Govt_ADS_CP_NA_Actual__c, National_Govt_ADS_CP_NA_Goal__c, National_Govt_ADS_CP_NA_Goal_TD__c, National_Govt_ADS_CP_NA_Var__c, National_Govt_ADS_CP_NA_Var_P__c, National_Govt_MQL_CP_NA_Actual__c, National_Govt_MQL_CP_NA_Goal__c, National_Govt_MQL_CP_NA_Goal_TD__c, National_Govt_MQL_CP_NA_Var__c, National_Govt_MQL_CP_NA_Var_P__c, National_Govt_SQO_CP_NA_Actual__c, National_Govt_SQO_CP_NA_Goal__c, National_Govt_SQO_CP_NA_Goal_TD__c, National_Govt_SQO_CP_NA_Var__c, National_Govt_SQO_CP_NA_Var_P__c, OwnerId, Quarter__c, Id, Retail_ADS_CP_NA_Actual__c, Retail_ADS_CP_NA_Goal__c, Retail_ADS_CP_NA_Goal_TD__c, Retail_ADS_CP_NA_Var__c, Retail_ADS_CP_NA_Var_P__c, Retail_MQL_CP_NA_Actual__c, Retail_MQL_CP_NA_Goal__c, Retail_MQL_CP_NA_Goal_TD__c, Retail_MQL_CP_NA_Var__c, Retail_MQL_CP_NA_Var_P__c, Retail_SQO_CP_NA_Actual__c, Retail_SQO_CP_NA_Goal__c, Retail_SQO_CP_NA_Goal_TD__c, Retail_SQO_CP_NA_Var__c, Retail_SQO_CP_NA_Var_P__c, Search_ADS_EA_Actual__c, Search_ADS_EA_Goal__c, Search_ADS_EA_Goal_TD__c, Search_ADS_EA_Var__c, Search_ADS_EA_Var_P__c, Search_ADS_NA_Actual__c, Search_ADS_NA_Goal__c, Search_ADS_NA_Goal_TD__c, Search_ADS_NA_Var__c, Search_ADS_NA_Var_P__c, Search_MQL_EA_Actual__c, Search_MQL_EA_Goal__c, Search_MQL_EA_Goal_TD__c, Search_MQL_EA_Var__c, Search_MQL_EA_Var_P__c, Search_MQL_NA_Actual__c, Search_MQL_NA_Goal__c, Search_MQL_NA_Goal_TD__c, Search_MQL_NA_Var__c, Search_MQL_NA_Var_P__c, Search_SQO_EA_Actual__c, Search_SQO_EA_Goal__c, Search_SQO_EA_Goal_TD__c, Search_SQO_EA_Var__c, Search_SQO_EA_Var_P__c, Search_SQO_NA_Actual__c, Search_SQO_NA_Goal__c, Search_SQO_NA_Goal_TD__c, Search_SQO_NA_Var__c, Search_SQO_NA_Var_P__c, Start_Date__c, State_Local_ADS_CP_NA_Actual__c, State_Local_ADS_CP_NA_Goal__c, State_Local_ADS_CP_NA_Goal_TD__c, State_Local_ADS_CP_NA_Var__c, State_Local_ADS_CP_NA_Var_P__c, State_Local_MQL_CP_NA_Actual__c, State_Local_MQL_CP_NA_Goal__c, State_Local_MQL_CP_NA_Goal_TD__c, State_Local_MQL_CP_NA_Var__c, State_Local_MQL_CP_NA_Var_P__c, State_Local_SQO_CP_NA_Actual__c, State_Local_SQO_CP_NA_Goal__c, State_Local_SQO_CP_NA_Goal_TD__c, State_Local_SQO_CP_NA_Var__c, State_Local_SQO_CP_NA_Var_P__c, SystemModstamp, Total_ADS_EA_Actual__c, Total_ADS_EA_Goal__c, Total_ADS_EA_Goal_TD__c, Total_ADS_EA_Var__c, Total_ADS_EA_Var_P__c, Total_ADS_NA_Actual__c, Total_ADS_NA_Goal__c, Total_ADS_NA_Goal_TD__c, Total_ADS_NA_Var__c, Total_ADS_NA_Var_P__c, Total_ADS_CP_EA_Actual__c, Total_ADS_CP_EA_Goal__c, Total_ADS_CP_EA_Goal_TD__c, Total_ADS_CP_EA_Var__c, Total_ADS_CP_EA_Var_P__c, Total_ADS_CP_LA_Actual__c, Total_ADS_CP_LA_Goal__c, Total_ADS_CP_LA_Goal_TD__c, Total_ADS_CP_LA_Var__c, Total_ADS_CP_LA_Var_P__c, Total_ADS_CP_NA_Actual__c, Total_ADS_CP_NA_Goal__c, Total_ADS_CP_NA_Goal_TD__c, Total_ADS_CP_NA_Var__c, Total_ADS_CP_NA_Var_P__c, Total_MQL_EA_Actual__c, Total_MQL_EA_Goal__c, Total_MQL_EA_Goal_TD__c, Total_MQL_EA_Var__c, Total_MQL_EA_Var_P__c, Total_MQL_NA_Actual__c, Total_MQL_NA_Goal__c, Total_MQL_NA_Goal_TD__c, Total_MQL_NA_Var__c, Total_MQL_NA_Var_P__c, Total_MQL_CP_EA_Actual__c, Total_MQL_CP_EA_Goal__c, Total_MQL_CP_EA_Goal_TD__c, Total_MQL_CP_EA_Var__c, Total_MQL_CP_EA_Var_P__c, Total_MQL_CP_LA_Actual__c, Total_MQL_CP_LA_Goal__c, Total_MQL_CP_LA_Goal_TD__c, Total_MQL_CP_LA_Var__c, Total_MQL_CP_LA_Var_P__c, Total_MQL_CP_NA_Actual__c, Total_MQL_CP_NA_Goal__c, Total_MQL_CP_NA_Goal_TD__c, Total_MQL_CP_NA_Var__c, Total_MQL_CP_NA_Var_P__c, Total_SQO_EA_Actual__c, Total_SQO_EA_Goal__c, Total_SQO_EA_Goal_TD__c, Total_SQO_EA_Var__c, Total_SQO_EA_Var_P__c, Total_SQO_NA_Actual__c, Total_SQO_NA_Goal__c, Total_SQO_NA_Goal_TD__c, Total_SQO_NA_Var__c, Total_SQO_NA_Var_P__c, Total_SQO_CP_EA_Actual__c, Total_SQO_CP_EA_Goal__c, Total_SQO_CP_EA_Goal_TD__c, Total_SQO_CP_EA_Var__c, Total_SQO_CP_EA_Var_P__c, Total_SQO_CP_LA_Actual__c, Total_SQO_CP_LA_Goal__c, Total_SQO_CP_LA_Goal_TD__c, Total_SQO_CP_LA_Var__c, Total_SQO_CP_LA_Var_P__c, Total_SQO_CP_NA_Actual__c, Total_SQO_CP_NA_Goal__c, Total_SQO_CP_NA_Goal_TD__c, Total_SQO_CP_NA_Var__c, Total_SQO_CP_NA_Var_P__c, UKI_ADS_CP_EA_Actual__c, UKI_ADS_CP_EA_Goal__c, UKI_ADS_CP_EA_Goal_TD__c, UKI_ADS_CP_EA_Var__c, UKI_ADS_CP_EA_Var_P__c, UKI_MQL_CP_EA_Actual__c, UKI_MQL_CP_EA_Goal__c, UKI_MQL_CP_EA_Goal_TD__c, UKI_MQL_CP_EA_Var__c, UKI_MQL_CP_EA_Var_P__c, UKI_SQO_CP_EA_Actual__c, UKI_SQO_CP_EA_Goal__c, UKI_SQO_CP_EA_Goal_TD__c, UKI_SQO_CP_EA_Var__c, UKI_SQO_CP_EA_Var_P__c, View_MQL_NA_Actuals__c, View_MQL_CP_NA_Actuals__c, View_SQO_NA_Actuals__c, View_SQO_CP_NA_Actuals__c, Year__c FROM Goal__c where id =: theId];
       goalDataList = returnGoalDataList();
       expGoalDataList = returnExpGoalDataList();
       //averageDealSizeList = returnAverageDealSizeList();
       List<String> goalValuesList = new List<String>();
       
       reportDataListSqo = new List<ReportData>();
       reportDataListMql = new List<ReportData>();
       reportDataListSectorMql = new List<ReportData>();
       reportDataListSectorSqo = new List<ReportData>();
       chartDataListSectorAds = new List<ReportData>();
       reportDataListLAMql = new List<ReportData>();
       reportDataListLASqo = new List<ReportData>();
       reportDataListLAAds = new List<ReportData>();
       reportDataListNAAds = new List<ReportData>();
       reportDataListSectorAds = new List<ReportData>();
       reportDataListNAExp = new List<ReportData>();
       reportDataListSectorExp = new List<ReportData>();
       reportDataListLAExp = new List<ReportData>();

       
       Map<String, ReportData> goalValuesMap = new Map<String, ReportData>();
       
       
       
       //String aoi;
       List<String> aoiList = new List<String>();
       aoiList.add('Content/Process');
       aoiList.add('Capture');
       aoiList.add('Search');
       ReportData repoData;
       goalMap = new Map<String, Map<String,String>>();
       
       try{
        // Construct the list to diaply report data
           if(!goalDataList.isEmpty()){
               //for(String aoi : aoiList){
                   for(Goal__c goal : goalDataList){
                       
                       //Get the quarter for the goal record
                       String qtr = getQuarter(goal.start_Date__c, goal.end_Date__c);
                       
                       //Create dynamic column headers
                       col1Header = qtr + ' ' + String.valueOf(goal.start_Date__c.year()).right(2);
                       col2Header = qtr + ' ' +String.valueOf(goal.start_Date__c.year()).right(2);
                       col3Header = qtr + ' ' +String.valueOf(goal.start_Date__c.year()).right(2);
                       /*goalValuesMap.put('Actual',String.valueOf(goal.Content_Process_MQL_NA_Actual__c));
                       goalValuesMap.put('Goal', String.valueOf(goal.Content_Process_MQL_NA_Goal__c));
                       goalValuesMap.put('Goal TD', String.valueOf(goal.Content_Process_MQL_NA_Goal_TD__c));*/
                       
                       //Collect the data for all areasOfInterest (MQLs) and North America region
                       repoData = new ReportData('Content/Process', goal.Content_Process_MQL_NA_Goal__c, goal.Content_Process_MQL_NA_Actual__c, goal.Content_Process_MQL_NA_Goal_TD__c, goal.Content_Process_MQL_NA_Var__c, goal.Content_Process_MQL_NA_Var_P__c);
                       
                       //Add to the required list directly
                       reportDataListMql.add(repoData);
                       //goalValuesMap.put('Content/Process', repoData);
                       
                       repoData = new ReportData('Capture', goal.Capture_MQL_NA_Goal__c, goal.Capture_MQL_NA_Actual__c ,goal.Capture_MQL_NA_Goal_TD__c, goal.Capture_MQL_NA_Var__c, goal.Capture_MQL_NA_Var_P__c);
                       reportDataListMql.add(repoData);
                       //goalValuesMap.put('Capture', repoData);
                       
                       repoData = new ReportData('Search', goal.Search_MQL_NA_Goal__c, goal.Search_MQL_NA_Actual__c,goal.Search_MQL_NA_Goal_TD__c, goal.Search_MQL_NA_Var__c, goal.Search_MQL_NA_Var_P__c);
                        reportDataListMql.add(repoData);
                       //goalValuesMap.put('Search', repoData);
                       
                       repoData = new ReportData('Total North America', goal.Total_MQL_NA_Goal__c, goal.Total_MQL_NA_Actual__c,goal.Total_MQL_NA_Goal_TD__c, goal.Total_MQL_NA_Var__c, goal.Total_MQL_NA_Var_P__c);
                       reportDataListMql.add(repoData);
                       //goalValuesMap.put('Total North America', repoData);
                       
                       //Collect the data for all areasOfInterest (SQLs) and North America region
                       repoData = new ReportData('Content/Process', goal.Content_Process_SQO_NA_Goal__c, goal.Content_Process_SQO_NA_Actual__c, goal.Content_Process_SQO_NA_Goal_TD__c, goal.Content_Process_SQO_NA_Var__c, goal.Content_Process_SQO_NA_Var_P__c);
                       reportDataListSqo.add(repoData);
                       //goalValuesMap.put('Content/Process', repoData);
                       
                       repoData = new ReportData('Capture', goal.Capture_SQO_NA_Goal__c, goal.Capture_SQO_NA_Actual__c ,goal.Capture_SQO_NA_Goal_TD__c, goal.Capture_SQO_NA_Var__c, goal.Capture_SQO_NA_Var_P__c);
                       reportDataListSqo.add(repoData);
                       
                       //goalValuesMap.put('Capture', repoData);
                       
                       repoData = new ReportData('Search', goal.Search_SQO_NA_Goal__c, goal.Search_SQO_NA_Actual__c,goal.Search_SQO_NA_Goal_TD__c, goal.Search_SQO_NA_Var__c, goal.Search_SQO_NA_Var_P__c);
                       reportDataListSqo.add(repoData);
                       
                       //goalValuesMap.put('Search', repoData);
                       
                       repoData = new ReportData('Total North America', goal.Total_SQO_NA_Goal__c, goal.Total_SQO_NA_Actual__c,goal.Total_SQO_NA_Goal_TD__c, goal.Total_SQO_NA_Var__c, goal.Total_SQO_NA_Var_P__c);
                       reportDataListSqo.add(repoData);
                       
                       //goalValuesMap.put('Search', repoData);
                       
                       //Collect the data for all areasOfInterest (MQLs) and North America region
                       repoData = new ReportData('Banking', goal.Banking_MQL_CP_NA_Goal__c, goal.Banking_MQL_CP_NA_Actual__c, goal.Banking_MQL_CP_NA_Goal_TD__c, goal.Banking_MQL_CP_NA_Var__c, goal.Banking_MQL_CP_NA_Var_P__c);
                       reportDataListSectorMql.add(repoData);
                       //goalValuesMap.put('Banking', repoData);
                       
                       repoData = new ReportData('Insurance', goal.Insurance_MQL_CP_NA_Goal__c, goal.Insurance_MQL_CP_NA_Actual__c, goal.Insurance_MQL_CP_NA_Goal_TD__c, goal.Insurance_MQL_CP_NA_Var__c, goal.Insurance_MQL_CP_NA_Var_P__c);
                       reportDataListSectorMql.add(repoData);
                       //goalValuesMap.put('Insurance', repoData);
                       
                       repoData = new ReportData('Retail', goal.Retail_MQL_CP_NA_Goal__c, goal.Retail_MQL_CP_NA_Actual__c, goal.Retail_MQL_CP_NA_Goal_TD__c, goal.Retail_MQL_CP_NA_Var__c, goal.Retail_MQL_CP_NA_Var_P__c);
                       reportDataListSectorMql.add(repoData);
                       //goalValuesMap.put('Retail', repoData);
                       
                       repoData = new ReportData('State/Local Government', goal.State_Local_MQL_CP_NA_Goal__c, goal.State_Local_MQL_CP_NA_Actual__c, goal.State_Local_MQL_CP_NA_Goal_TD__c, goal.State_Local_MQL_CP_NA_Var__c, goal.State_Local_MQL_CP_NA_Var_P__c);
                       reportDataListSectorMql.add(repoData);
                       //goalValuesMap.put('State/Local Government', repoData);
                       
                       repoData = new ReportData('National Government', goal.National_Govt_MQL_CP_NA_Goal__c, goal.National_Govt_MQL_CP_NA_Actual__c, goal.National_Govt_MQL_CP_NA_Goal_TD__c, goal.National_Govt_MQL_CP_NA_Var__c, goal.National_Govt_MQL_CP_NA_Var_P__c);
                       reportDataListSectorMql.add(repoData);
                       //goalValuesMap.put('National Government', repoData);
                       
                       repoData = new ReportData('Education', goal.Education_MQL_CP_NA_Goal__c, goal.Education_MQL_CP_NA_Actual__c, goal.Education_MQL_CP_NA_Goal_TD__c, goal.Education_MQL_CP_NA_Var__c, goal.Education_MQL_CP_NA_Var_P__c);
                       reportDataListSectorMql.add(repoData);
                       //goalValuesMap.put('Education', repoData);
                       
                       repoData = new ReportData('Healthcare', goal.Healthcare_MQL_CP_NA_Goal__c, goal.Healthcare_MQL_CP_NA_Actual__c, goal.Healthcare_MQL_CP_NA_Goal_TD__c, goal.Healthcare_MQL_CP_NA_Var__c, goal.Healthcare_MQL_CP_NA_Var_P__c);
                       reportDataListSectorMql.add(repoData);
                       //goalValuesMap.put('Healthcare', repoData);
                       
                       repoData = new ReportData('Total NA Content/Process', goal.Total_MQL_NA_Goal__c, goal.Total_MQL_NA_Actual__c, goal.Total_MQL_NA_Goal_TD__c, goal.Total_MQL_NA_Var__c, goal.Total_MQL_NA_Var_P__c);
                       reportDataListSectorMql.add(repoData);
                       
                        //Collect the data for all areasOfInterest (ADSs) and North America region
                       repoData = new ReportData('Banking', goal.Banking_SQO_CP_NA_Goal__c, goal.Banking_SQO_CP_NA_Actual__c, goal.Banking_SQO_CP_NA_Goal_TD__c, goal.Banking_SQO_CP_NA_Var__c, goal.Banking_SQO_CP_NA_Var_P__c);
                       
                       //goalValuesMap.put('Banking', repoData);
                       reportDataListSectorSqo.add(repoData);
                       
                       repoData = new ReportData('Insurance', goal.Insurance_SQO_CP_NA_Goal__c, goal.Insurance_SQO_CP_NA_Actual__c, goal.Insurance_SQO_CP_NA_Goal_TD__c, goal.Insurance_SQO_CP_NA_Var__c, goal.Insurance_SQO_CP_NA_Var_P__c);
                       reportDataListSectorSqo.add(repoData);
                       //goalValuesMap.put('Insurance', repoData);
                       
                       repoData = new ReportData('Retail', goal.Retail_SQO_CP_NA_Goal__c, goal.Retail_SQO_CP_NA_Actual__c, goal.Retail_SQO_CP_NA_Goal_TD__c, goal.Retail_SQO_CP_NA_Var__c, goal.Retail_SQO_CP_NA_Var_P__c);
                       reportDataListSectorSqo.add(repoData);
                       //goalValuesMap.put('Retail', repoData);
                       
                       repoData = new ReportData('State/Local Government', goal.State_Local_SQO_CP_NA_Goal__c, goal.State_Local_SQO_CP_NA_Actual__c, goal.State_Local_SQO_CP_NA_Goal_TD__c, goal.State_Local_SQO_CP_NA_Var__c, goal.State_Local_SQO_CP_NA_Var_P__c);
                       reportDataListSectorSqo.add(repoData);
                       //goalValuesMap.put('State/Local Government', repoData);
                       
                       repoData = new ReportData('National Government', goal.National_Govt_SQO_CP_NA_Goal__c, goal.National_Govt_SQO_CP_NA_Actual__c, goal.National_Govt_SQO_CP_NA_Goal_TD__c, goal.National_Govt_SQO_CP_NA_Var__c, goal.National_Govt_SQO_CP_NA_Var_P__c);
                       reportDataListSectorSqo.add(repoData);
                       //goalValuesMap.put('National Government', repoData);
                       
                       repoData = new ReportData('Education', goal.Education_SQO_CP_NA_Goal__c, goal.Education_SQO_CP_NA_Actual__c, goal.Education_SQO_CP_NA_Goal_TD__c, goal.Education_SQO_CP_NA_Var__c, goal.Education_SQO_CP_NA_Var_P__c);
                       reportDataListSectorSqo.add(repoData);
                       //goalValuesMap.put('Education', repoData);
                       
                       repoData = new ReportData('Healthcare', goal.Healthcare_SQO_CP_NA_Goal__c, goal.Healthcare_SQO_CP_NA_Actual__c, goal.Healthcare_SQO_CP_NA_Goal_TD__c, goal.Healthcare_SQO_CP_NA_Var__c, goal.Healthcare_SQO_CP_NA_Var_P__c);
                       reportDataListSectorSqo.add(repoData);
                       
                       repoData = new ReportData('Total NA Content/Process', goal.Total_SQO_NA_Goal__c, goal.Total_SQO_NA_Actual__c, goal.Total_SQO_NA_Goal_TD__c, goal.Total_SQO_NA_Var__c, goal.Total_SQO_NA_Var_P__c);
                       reportDataListSectorSqo.add(repoData);
                       //goalValuesMap.put('Healthcare', repoData);
                       
                       //Collect the data for all areasOfInterest (SQLs) and Latin America region
                       repoData = new ReportData('Latin America', goal.Latin_America_Mql_CP_LA_Goal__c, goal.Latin_America_Mql_CP_LA_Actual__c, goal.Latin_America_Mql_CP_LA_Goal_TD__c, goal.Latin_America_Mql_CP_LA_Var__c, goal.Latin_America_Mql_CP_LA_Var_P__c);
                       reportDataListLAMql.add(repoData);
                       
                       repoData = new ReportData('Total Latin America', goal.Total_MQL_CP_LA_Goal__c, goal.Total_MQL_CP_LA_Actual__c, goal.Total_MQL_CP_LA_Goal_TD__c, goal.Total_MQL_CP_LA_Var__c, goal.Total_MQL_CP_LA_Var_P__c);
                       reportDataListLAMql.add(repoData);
                       
                       repoData = new ReportData('Latin America', goal.Latin_America_SQO_CP_LA_Goal__c, goal.Latin_America_SQO_CP_LA_Actual__c, goal.Latin_America_SQO_CP_LA_Goal_TD__c, goal.Latin_America_SQO_CP_LA_Var__c, goal.Latin_America_SQO_CP_LA_Var_P__c);
                       reportDataListLASqo.add(repoData);
                       
                       repoData = new ReportData('Total Latin America', goal.Total_SQO_CP_LA_Goal__c, goal.Total_SQO_CP_LA_Actual__c, goal.Total_SQO_CP_LA_Goal_TD__c, goal.Total_SQO_CP_LA_Var__c, goal.Total_SQO_CP_LA_Var_P__c);
                       reportDataListLASqo.add(repoData);
                       
                       //Add ADS data to the list to display in the table
                       
                       repoData = new ReportData('Content/Process', goal.Content_Process_ADS_NA_Goal__c, goal.Content_Process_ADS_NA_Actual__c, goal.Content_Process_ADS_NA_Goal_TD__c, goal.Content_Process_ADS_NA_Var__c, goal.Content_Process_ADS_NA_Var_P__c);
                       
                       //Add to the required list directly
                       reportDataListNAAds.add(repoData);
                       //goalValuesMap.put('Content/Process', repoData);
                       
                       repoData = new ReportData('Capture', goal.Capture_ADS_NA_Goal__c, goal.Capture_ADS_NA_Actual__c ,goal.Capture_ADS_NA_Goal_TD__c, goal.Capture_ADS_NA_Var__c, goal.Capture_ADS_NA_Var_P__c);
                       reportDataListNAAds.add(repoData);
                       //goalValuesMap.put('Capture', repoData);
                       
                       repoData = new ReportData('Search', goal.Search_ADS_NA_Goal__c, goal.Search_ADS_NA_Actual__c,goal.Search_ADS_NA_Goal_TD__c, goal.Search_ADS_NA_Var__c, goal.Search_ADS_NA_Var_P__c);
                        reportDataListNAAds.add(repoData);
                       //goalValuesMap.put('Search', repoData);
                       
                       repoData = new ReportData('Total North America', goal.Total_ADS_NA_Goal__c, goal.Total_ADS_NA_Actual__c,goal.Total_ADS_NA_Goal_TD__c, goal.Total_ADS_NA_Var__c, goal.Total_ADS_NA_Var_P__c);
                       reportDataListNAAds.add(repoData);
                       
                        //Collect the data for all areasOfInterest (ADSs) and North America region
                       repoData = new ReportData('Banking', goal.Banking_ADS_CP_NA_Goal__c, goal.Banking_ADS_CP_NA_Actual__c, goal.Banking_ADS_CP_NA_Goal_TD__c, goal.Banking_ADS_CP_NA_Var__c, goal.Banking_ADS_CP_NA_Var_P__c);
                       reportDataListSectorAds.add(repoData);
                       //goalValuesMap.put('Banking', repoData);
                       
                       repoData = new ReportData('Insurance', goal.Insurance_ADS_C_P_NA_Goal__c, goal.Insurance_ADS_C_P_NA_Actual__c, goal.Insurance_ADS_C_P_NA_Goal_TD__c, goal.Insurance_ADS_C_P_NA_Var__c, goal.Insurance_ADS_C_P_NA_Var_P__c);
                       reportDataListSectorAds.add(repoData);
                       //goalValuesMap.put('Insurance', repoData);
                       
                       repoData = new ReportData('Retail', goal.Retail_ADS_CP_NA_Goal__c, goal.Retail_ADS_CP_NA_Actual__c, goal.Retail_ADS_CP_NA_Goal_TD__c, goal.Retail_ADS_CP_NA_Var__c, goal.Retail_ADS_CP_NA_Var_P__c);
                       reportDataListSectorAds.add(repoData);
                       //goalValuesMap.put('Retail', repoData);
                       
                       repoData = new ReportData('State/Local Government', goal.State_Local_ADS_CP_NA_Goal__c, goal.State_Local_ADS_CP_NA_Actual__c, goal.State_Local_ADS_CP_NA_Goal_TD__c, goal.State_Local_ADS_CP_NA_Var__c, goal.State_Local_ADS_CP_NA_Var_P__c);
                       reportDataListSectorAds.add(repoData);
                       //goalValuesMap.put('State/Local Government', repoData);
                       
                       repoData = new ReportData('National Government', goal.National_Govt_ADS_CP_NA_Goal__c, goal.National_Govt_ADS_CP_NA_Actual__c, goal.National_Govt_ADS_CP_NA_Goal_TD__c, goal.National_Govt_ADS_CP_NA_Var__c, goal.National_Govt_ADS_CP_NA_Var_P__c);
                       reportDataListSectorAds.add(repoData);
                       //goalValuesMap.put('National Government', repoData);
                       
                       repoData = new ReportData('Education', goal.Education_ADS_CP_NA_Goal__c, goal.Education_ADS_CP_NA_Actual__c, goal.Education_ADS_CP_NA_Goal_TD__c, goal.Education_ADS_CP_NA_Var__c, goal.Education_ADS_CP_NA_Var_P__c);
                       reportDataListSectorAds.add(repoData);
                       //goalValuesMap.put('Education', repoData);
                       
                       repoData = new ReportData('Healthcare', goal.Healthcare_ADS_CP_NA_Goal__c, goal.Healthcare_ADS_CP_NA_Actual__c, goal.Healthcare_ADS_CP_NA_Goal_TD__c, goal.Healthcare_ADS_CP_NA_Var__c, goal.Healthcare_ADS_CP_NA_Var_P__c);
                       reportDataListSectorAds.add(repoData);
                       //goalValuesMap.put('Healthcare', repoData);
                       
                       repoData = new ReportData('Total NA Content/Process', goal.Total_ADS_NA_Goal__c, goal.Total_ADS_NA_Actual__c, goal.Total_ADS_NA_Goal_TD__c, goal.Total_ADS_NA_Var__c, goal.Total_ADS_NA_Var_P__c);
                       reportDataListSectorAds.add(repoData);
                       
                       
                       repoData = new ReportData('Latin America', goal.Latin_America_ADS_CP_LA_Goal__c, goal.Latin_America_ADS_CP_LA_Actual__c, goal.Latin_America_ADS_CP_LA_Goal_TD__c, goal.Latin_America_ADS_CP_LA_Var__c, goal.Latin_America_ADS_CP_LA_Var_P__c);
                       reportDataListLAAds.add(repoData);
                       
                       repoData = new ReportData('Total Latin America', goal.Total_ADS_CP_LA_Goal__c, goal.Total_ADS_CP_LA_Actual__c, goal.Total_ADS_CP_LA_Goal_TD__c, goal.Total_ADS_CP_LA_Var__c, goal.Total_ADS_CP_LA_Var_P__c);
                       reportDataListLAAds.add(repoData);
                       
                       System.debug('&&*&*& theId '+theId);
                       
                       
                       
                   } //for ends here
               //}
           }//If ends here
           
           if(expGoalDataList != null){
           
               for(Goal__c goal : expGoalDataList){
                   
                   //EXP Fields - NA sector
                       
                       repoData = new ReportData('Banking', goal.Banking_EXP_CP_NA_Goal__c, goal.Banking_EXP_CP_NA_Actual__c, goal.Banking_EXP_CP_NA_Goal_TD__c, goal.Banking_EXP_CP_NA_Var__c, goal.Banking_EXP_CP_NA_Var_P__c);
                       reportDataListSectorExp.add(repoData);
                       //goalValuesMap.put('Banking', repoData);
                       
                       repoData = new ReportData('Insurance', goal.Insurance_EXP_CP_NA_Goal__c, goal.Insurance_EXP_CP_NA_Actual__c, goal.Insurance_EXP_CP_NA_Goal_TD__c, goal.Insurance_EXP_CP_NA_Var__c, goal.Insurance_EXP_CP_NA_Var_P__c);
                       reportDataListSectorExp.add(repoData);
                       //goalValuesMap.put('Insurance', repoData);
                       
                       repoData = new ReportData('Retail', goal.Retail_EXP_CP_NA_Goal__c, goal.Retail_EXP_CP_NA_Actual__c, goal.Retail_EXP_CP_NA_Goal_TD__c, goal.Retail_EXP_CP_NA_Var__c, goal.Retail_EXP_CP_NA_Var_P__c);
                       reportDataListSectorExp.add(repoData);
                       //goalValuesMap.put('Retail', repoData);
                       
                       repoData = new ReportData('State/Local Government', goal.State_Local_EXP_CP_NA_Goal__c, goal.State_Local_EXP_CP_NA_Actual__c, goal.State_Local_EXP_CP_NA_Goal_TD__c, goal.State_Local_EXP_CP_NA_Var__c, goal.State_Local_EXP_CP_NA_Var_P__c);
                       reportDataListSectorExp.add(repoData);
                       //goalValuesMap.put('State/Local Government', repoData);
                       
                       repoData = new ReportData('National Government', goal.National_Govt_EXP_CP_NA_Goal__c, goal.National_Govt_EXP_CP_NA_Actual__c, goal.National_Govt_EXP_CP_NA_Goal_TD__c, goal.National_Govt_EXP_CP_NA_Var__c, goal.National_Govt_EXP_CP_NA_Var_P__c);
                       reportDataListSectorExp.add(repoData);
                       //goalValuesMap.put('National Government', repoData);
                       
                       repoData = new ReportData('Education', goal.Education_EXP_CP_NA_Goal__c, goal.Education_EXP_CP_NA_Actual__c, goal.Education_EXP_CP_NA_Goal_TD__c, goal.Education_EXP_CP_NA_Var__c, goal.Education_EXP_CP_NA_Var_P__c);
                       reportDataListSectorExp.add(repoData);
                       //goalValuesMap.put('Education', repoData);
                       
                       repoData = new ReportData('Healthcare', goal.Healthcare_EXP_CP_NA_Goal__c, goal.Healthcare_EXP_CP_NA_Actual__c, goal.Healthcare_EXP_CP_NA_Goal_TD__c, goal.Healthcare_EXP_CP_NA_Var__c, goal.Healthcare_EXP_CP_NA_Var_P__c);
                       reportDataListSectorExp.add(repoData);
                       //goalValuesMap.put('Healthcare', repoData);
                       
                       repoData = new ReportData('Total NA Content/Process', goal.Total_EXP_NA_Goal__c, goal.Total_EXP_NA_Actual__c, goal.Total_EXP_NA_Goal_TD__c, goal.Total_EXP_NA_Var__c, goal.Total_EXP_NA_Var_P__c);
                       reportDataListSectorExp.add(repoData);
                       
                       
                       // EXP Fields - LA 
                       
                       repoData = new ReportData('Latin America', goal.Latin_America_EXP_CP_LA_Goal__c, goal.Latin_America_EXP_CP_LA_Actual__c, goal.Latin_America_EXP_CP_LA_Goal_TD__c, goal.Latin_America_EXP_CP_LA_Var__c, goal.Latin_America_EXP_CP_LA_Var_P__c);
                       reportDataListLAExp.add(repoData);
                       
                       repoData = new ReportData('Total Latin America', goal.Total_EXP_CP_LA_Goal__c, goal.Total_EXP_CP_LA_Actual__c, goal.Total_EXP_CP_LA_Goal_TD__c, goal.Total_EXP_CP_LA_Var__c, goal.Total_EXP_CP_LA_Var_P__c);
                       reportDataListLAExp.add(repoData);
                       
                       //EXP Fields - NA Area of Interest
                       
                       repoData = new ReportData('Content/Process', goal.Content_Process_EXP_NA_Goal__c, goal.Content_Process_EXP_NA_Actual__c, goal.Content_Process_EXP_NA_Goal_TD__c, goal.Content_Process_EXP_NA_Var__c, goal.Content_Process_EXP_NA_Var_P__c);
                       
                       //Add to the required list directly
                       reportDataListNAExp.add(repoData);
                       //goalValuesMap.put('Content/Process', repoData);
                       
                       repoData = new ReportData('Capture', goal.Capture_EXP_NA_Goal__c, goal.Capture_EXP_NA_Actual__c ,goal.Capture_EXP_NA_Goal_TD__c, goal.Capture_EXP_NA_Var__c, goal.Capture_EXP_NA_Var_P__c);
                       reportDataListNAExp.add(repoData);
                       //goalValuesMap.put('Capture', repoData);
                       
                       repoData = new ReportData('Search', goal.Search_EXP_NA_Goal__c, goal.Search_EXP_NA_Actual__c,goal.Search_EXP_NA_Goal_TD__c, goal.Search_EXP_NA_Var__c, goal.Search_EXP_NA_Var_P__c);
                        reportDataListNAExp.add(repoData);
                       //goalValuesMap.put('Search', repoData);
                       
                       repoData = new ReportData('Total North America', goal.Total_EXP_NA_Goal__c, goal.Total_EXP_NA_Actual__c,goal.Total_EXP_NA_Goal_TD__c, goal.Total_EXP_NA_Var__c, goal.Total_EXP_NA_Var_P__c);
                       reportDataListNAExp.add(repoData);
                       
                       System.debug('FFFFF reportDataListNAExp '+reportDataListNAExp);
                       System.debug('GGGGG reportDataListLAExp '+reportDataListLAExp);
                       System.debug('HHHHH reportDataListSectorExp '+reportDataListSectorExp);
               
               }
           
           }
    }catch(Exception ex){
        System.debug('Exception: '+ex.getMessage()+' at line number: '+ex.getLineNumber());
    }
       
       return null;
   
   }  

public pageReference displayChart(){
        
    System.debug('---- In displaychart');
    
    ReportData repoData;
    goalDataList = returnGoalDataList();
    reportDataListLAAds = new List<ReportData>();
    reportDataListNAAds = new List<ReportData>();
    reportDataListSectorAds = new List<ReportData>();
    
    chartDataListNAMql = new List<ReportData>();
    chartDataListNASqo = new List<ReportData>();
    chartDataListNAAds = new List<ReportData>();
    
    chartDataListSectorMql = new List<ReportData>();
    chartDataListSectorSqo = new List<ReportData>();
    chartDataListSectorAds = new List<ReportData>();
    
    chartDataListLAMql = new List<ReportData>();
    chartDataListLASqo = new List<ReportData>();
    chartDataListLAAds = new List<ReportData>();
       
    try{
    // Construct the list to display report data
       if(!goalDataList.isEmpty()){
           //for(String aoi : aoiList){
               for(Goal__c goal : goalDataList){
                   
                   //Get the quarter for the goal record
                   String qtr = getQuarter(goal.start_Date__c, goal.end_Date__c);
                   
                   //Create dynamic column headers
                   col1Header = qtr + ' ' + String.valueOf(goal.start_Date__c.year());
                   col2Header = qtr + ' ' +String.valueOf(goal.start_Date__c.year()) + ' QTD';
                   col3Header = qtr + ' ' +String.valueOf(goal.start_Date__c.year()) + ' QTD Actuals';
                   //Display data in a chart
                   //Collect the data for all areasOfInterest (ADSs) and North America region
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_MQL_NA_Goal__c));
                   chartDataListNAMql.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_MQL_NA_Goal_TD__c));
                   chartDataListNAMql.add(repoData);
                   //goalValuesMap.put('Capture', repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_MQL_NA_Actual__c));
                   chartDataListNAMql.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_MQL_NA_Var__c));
                   chartDataListNAMql.add(repoData);
                   
                   repoData = new ReportData('Var%', isNull(goal.Total_MQL_NA_Var_P__c));
                   chartDataListNAMql.add(repoData);
                   
                   System.debug('---- chartDataListNAMql '+chartDataListNAMql);
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_SQO_NA_Goal__c));
                   chartDataListNASqo.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_SQO_NA_Goal_TD__c));
                   chartDataListNASqo.add(repoData);
                   //goalValuesMap.put('Capture', repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_SQO_NA_Actual__c));
                   chartDataListNASqo.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_SQO_NA_Var__c));
                   chartDataListNASqo.add(repoData);
                   
                   repoData = new ReportData('Var%', isNull(goal.Total_SQO_NA_Var_P__c));
                   chartDataListNASqo.add(repoData);
                   
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_ADS_NA_Goal__c));
                   chartDataListNAAds.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_ADS_NA_Goal_TD__c));
                   chartDataListNAAds.add(repoData);
                   //goalValuesMap.put('Capture', repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_ADS_NA_Actual__c));
                   chartDataListNAAds.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_ADS_NA_Var__c));
                   chartDataListNAAds.add(repoData);
                   
                   repoData = new ReportData('Var%', isNull(goal.Total_ADS_NA_Var_P__c));
                   chartDataListNAAds.add(repoData);
                   
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_ADS_CP_NA_Goal__c));
                   chartDataListSectorMql.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_ADS_CP_NA_Actual__c));
                   chartDataListSectorMql.add(repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_ADS_CP_NA_Goal_TD__c));
                   chartDataListSectorMql.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_ADS_CP_NA_Var__c));
                   chartDataListSectorMql.add(repoData);
                   
                   repoData = new ReportData('Var %', isNull(goal.Total_ADS_CP_NA_Var_P__c));
                   chartDataListSectorMql.add(repoData);
                   
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_ADS_CP_NA_Goal__c));
                   chartDataListSectorSqo.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_ADS_CP_NA_Actual__c));
                   chartDataListSectorSqo.add(repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_ADS_CP_NA_Goal_TD__c));
                   chartDataListSectorSqo.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_ADS_CP_NA_Var__c));
                   chartDataListSectorSqo.add(repoData);
                   
                   repoData = new ReportData('Var %', isNull(goal.Total_ADS_CP_NA_Var_P__c));
                   chartDataListSectorSqo.add(repoData);
                   
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_ADS_CP_NA_Goal__c));
                   chartDataListSectorAds.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_ADS_CP_NA_Actual__c));
                   chartDataListSectorAds.add(repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_ADS_CP_NA_Goal_TD__c));
                   chartDataListSectorAds.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_ADS_CP_NA_Var__c));
                   chartDataListSectorAds.add(repoData);
                   
                   repoData = new ReportData('Var %', isNull(goal.Total_ADS_CP_NA_Var_P__c));
                   chartDataListSectorAds.add(repoData);
                   
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_MQL_CP_LA_Goal__c));
                   chartDataListLAMql.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_MQL_CP_LA_Actual__c));
                   chartDataListLAMql.add(repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_MQL_CP_LA_Goal_TD__c));
                   chartDataListLAMql.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_MQL_CP_LA_Var__c));
                   chartDataListLAMql.add(repoData);
                   
                   repoData = new ReportData('Var %', isNull(goal.Total_MQL_CP_LA_Var_P__c));
                   chartDataListLAMql.add(repoData);
                   
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_SQO_CP_LA_Goal__c));
                   chartDataListLASqo.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_SQO_CP_LA_Actual__c));
                   chartDataListLASqo.add(repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_SQO_CP_LA_Goal_TD__c));
                   chartDataListLASqo.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_SQO_CP_LA_Var__c));
                   chartDataListLASqo.add(repoData);
                   
                   repoData = new ReportData('Var %', isNull(goal.Total_SQO_CP_LA_Var_P__c));
                   chartDataListLASqo.add(repoData);
                   
                   
                   repoData = new ReportData(col1Header, isNull(goal.Total_ADS_CP_LA_Goal__c));
                   chartDataListLAAds.add(repoData);
                   
                   repoData = new ReportData(col2Header, isNull(goal.Total_ADS_CP_LA_Actual__c));
                   chartDataListLAAds.add(repoData);
                   
                   repoData = new ReportData(col3Header, isNull(goal.Total_ADS_CP_LA_Goal_TD__c));
                   chartDataListLAAds.add(repoData);
                   
                   repoData = new ReportData('Var', isNull(goal.Total_ADS_CP_LA_Var__c));
                   chartDataListLAAds.add(repoData);
                   
                   repoData = new ReportData('Var %', isNull(goal.Total_ADS_CP_LA_Var_P__c));
                   chartDataListLAAds.add(repoData);
               }
           }
       }catch(Exception ex){
           System.debug('Exception: '+ex.getMessage()+' at line number: '+ex.getLineNumber());
       }
                   
       return null;

}

private Decimal isNull(Decimal var){
    if(var != null)
        return var;
    else
        return 0.0;
}

public List<ReportData> getChartData(){
        return reportDataListAds;
    }
    
public List<ReportData> getSectorWiseChartData(){
        return reportDataListSectorAds;
    }

public List<ReportData> getLAChartData(){
        return reportDataListLAAds;
    }
    
//Return Charts for North America for displaying on VF page  
public List<ReportData> getNAMqlChartData(){
        System.debug('**&& chartDataListNAMql '+chartDataListNAMql);
        return chartDataListNAMql;
    }
public List<ReportData> getNASqoChartData(){
        return chartDataListNASqo;
    }
    
public List<ReportData> getNAAdsChartData(){
        return chartDataListNAAds;
    }

//Return Charts for North America Sector data to display on VF page  
public List<ReportData> getNASectorMqlChartData(){
        return chartDataListSectorMql;
    }
public List<ReportData> getNASectorSqoChartData(){
        return chartDataListSectorSqo;
    }
    
public List<ReportData> getNASectorAdsChartData(){
        return chartDataListSectorAds;
    }

//Return Charts for Latin America for displaying on VF page  
public List<ReportData> getLAMqlChartData(){
        return chartDataListLAMql;
    }
public List<ReportData> getLASqoChartData(){
        return chartDataListLASqo;
    }
    
public List<ReportData> getLAAdsChartData(){
        return chartDataListLAAds;
    } 

//Render the page as pdf - on the button click
public String getRenderPdf() {
    if (ApexPages.currentPage().getParameters().get('print') != null)
        return 'pdf';
    else
        return null;
}

//Inner class to hold report data to be displayed   
public class ReportData{
    public String areaOfInterest {get;set;}
    public Decimal goal {get;set;}
    public Decimal actual {get;set;}
    public Decimal goalTd {get;set;}
    public Decimal var {get;set;}
    public Decimal varPer {get;set;}
    
    public ReportData(String areaOfInterest, Decimal goal, Decimal actual, Decimal goalTd, Decimal var, Decimal varPer){
        this.areaOfInterest = areaOfInterest;
        this.goal = goal;
        this.actual = actual;
        this.goalTd = goalTd;
        this.var = var;
        this.varPer = varPer;
    
    }
    public ReportData(String areaOfInterest, Decimal goal){
        this.areaOfInterest = areaOfInterest;
        this.goal = goal;
    }

}
// Method not required. To be removed later.
public pageReference dispalyChart(){
    return null;
}
}