/* Trigger Name   : PSE_PreSalesToImplementation
    * Description   : This is a trigger written to copy the assignment. notes and attachments from pre-sales project to implementation project. 
    * Created By   : Akanksha Gupta
    * Created Date : 17-09-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Maruthi Kolla        17-09-2013               1000                Added cloning logic   
    */

trigger PSE_PreSalesToImplementation on pse__Proj__c (after insert) {
 if(LX_CommonUtilities.ByPassBusinessRule()) return;
//Variables Declaration
List <ID> preList= new List <ID>();
List<pse__Proj__c> listOfImpProj = new List<pse__Proj__c>();
Map<ID,ID> mapOfImpAndPresales = new map<ID,ID>();
Map<ID,ID> mapOfPresalesAndImp = new map<ID,ID>();


/* Commenting the below to remove cloning of assignments on implementation project as per Defect 1495
Set<ID> schSetID = new Set<ID>();
List<pse__Schedule__c> schList = new List<pse__Schedule__c>() ;
List<pse__Schedule__c> tempSchList = new List<pse__Schedule__c>();
List<pse__Schedule__c> schImpList = new List<pse__Schedule__c>();
List <pse__Assignment__c> assPreList = new List <pse__Assignment__c>();
Map<ID,List<pse__Assignment__c>> mapOfProjAssig = new Map<ID,List<pse__Assignment__c>> ();
List <pse__Assignment__c> assPretoImpList = new List <pse__Assignment__c>();
List <pse__Assignment__c> assImpList = new List <pse__Assignment__c>();
List <pse__Assignment__c> assTempList = new List <pse__Assignment__c>();
*/

List <Note> notePreList = new List <Note>();
Map<ID,List<Note>> mapOfProjNote = new Map<ID,List<Note>> ();
List <Note> notePretoImpList = new List <Note>();
List <Note> noteTempList = new List <Note>();
List <Note> noteImpList = new List <Note>();

List <Attachment> attPreList = new List <Attachment>();
Map<ID,List<attachment>> mapOfProjAtt = new Map<ID,List<attachment>> ();
List <Attachment> attPretoImpList = new List <Attachment>();
List <Attachment> attTempList = new List <Attachment>();
List <Attachment> attImpList = new List <Attachment>();

/* Commenting the below to remove cloning of assignments on implementation project as per Defect 1495
Map <String,ID> mapOfSch =new Map <String,ID>();
List<pse__Schedule__c> listSch = new List<pse__Schedule__c>();

Set<ID> assResourceSet = new Set<ID>();
Set<ID> assProjectSet = new Set<ID>();

ID userid1=userInfo.getUserId();
List<pse__Schedule_Exception__c> schExcpList = new List<pse__Schedule_Exception__c>();
List<pse__Schedule_Exception__c> schExpImpList = new List<pse__Schedule_Exception__c>();
List<pse__Schedule_Exception__c> schExpTempList = new List<pse__Schedule_Exception__c>();
*/

//Logic for collecting Pre-sales project list and maps
for(pse__Proj__c pro:Trigger.New)
    {
       if(pro.Record_Type_Names__c  =='ISS Implementation Project')
       { 
            if(pro.Pre_Sales_Project_Name__c!= null )
            {
               System.debug('Imp Project loop');
               preList.add(pro.Pre_Sales_Project_Name__c);
               mapOfImpAndPresales.put(pro.id,pro.Pre_Sales_Project_Name__c);
               mapOfPresalesAndImp.put(pro.Pre_Sales_Project_Name__c,pro.id);
            }
       }
    }
  
// Logic for collecting the Pre-sales project assignments, notes and attachments   
if ( preList.size()>0)
{
    //asspreList=[SELECT Account_Name__c,CurrencyIsoCode,Id,id_legacy__c,IsDeleted,Labor_Category__c,LastActivityDate,LX_DataLoadId__c,LX_SFDC_ID_c__c,LX_Siebel_ID__c,Name,Original_Planned_Hours__c,Project_Implementation_Resource__c,Project_Technical_Review_Resource__c,pse__Action_Refresh_EVA_Hours_From_Timecards__c,pse__Action_Refresh_Hours_From_Schedule__c,pse__Assignment_Daily_Notes_Last_Updated__c,pse__Assignment_Daily_Notes__c,pse__Assignment_Number__c,pse__Average_Cost_Rate_Currency_Code__c,pse__Average_Cost_Rate_Number__c,pse__Average_Cost_Rate__c,pse__Batch_Sequence_Number__c,pse__Batch_Sequence__c,pse__Billable_Amount_In_Financials__c,pse__Billable_Amount_Submitted__c,pse__Billable_Days_In_Financials__c,pse__Billable_Days_Submitted__c,pse__Billable_Expenses_In_Financials__c,pse__Billable_Expenses_Submitted__c,pse__Billable_Hours_In_Financials__c,pse__Billable_Hours_Submitted__c,pse__Bill_Rate__c,pse__Closed_for_Expense_Entry__c,pse__Closed_for_Time_Entry__c,pse__Cost_Rate_Amount__c,pse__Cost_Rate_Currency_Code__c,pse__Cost_Rate__c,pse__Daily_Bill_Rate__c,pse__Daily_Cost_Rate__c,pse__Daily_Timecard_Notes_Required__c,pse__Description__c,pse__End_Date__c,pse__Estimated_Time_To_Completion__c,pse__Exclude_from_Billing__c,pse__Exclude_from_Planners__c,pse__Hours_to_Days_Rule__c,pse__Is_Billable__c,pse__Location__c,pse__Milestone__c,pse__Nick_Name__c,pse__Non_Billable_Days_In_Financials__c,pse__Non_Billable_Days_Submitted__c,pse__Non_Billable_Expenses_In_Financials__c,pse__Non_Billable_Expenses_Submitted__c,pse__Non_Billable_Hours_In_Financials__c,pse__Non_Billable_Hours_Submitted__c,pse__Override_Expense_Group__c,pse__Override_Expense_Practice__c,pse__Override_Expense_Region__c,pse__Override_RPG_Audit_Notes__c,pse__Override_RPG_Enabled__c,pse__Override_Timecard_Cost_Group__c,pse__Override_Timecard_Cost_Practice__c,pse__Override_Timecard_Cost_Region__c,pse__Override_Timecard_Revenue_Group__c,pse__Override_Timecard_Revenue_Practice__c,pse__Override_Timecard_Revenue_Region__c,pse__Percent_Allocated__c,pse__Planned_Bill_Rate__c,pse__Planned_Hours__c,pse__Planned_Revenue__c,pse__Projected_Revenue__c,pse__Project__c,pse__Rate_Card__c,pse__Resource_Cost_Rate_Date__c,pse__Resource_Request__c,pse__Resource__c,pse__Role__c,pse__Scheduled_Days__c,pse__Scheduled_Hours__c,pse__Schedule_Updated__c,pse__Schedule__c,pse__Start_Date__c,pse__Status__c,pse__Suggested_Bill_Rate_Currency_Code__c,pse__Suggested_Bill_Rate_Number__c,pse__Suggested_Bill_Rate__c,pse__Timecard_External_Costs_In_Financials__c,pse__Timecard_External_Costs_Submitted__c,pse__Timecard_Internal_Costs_In_Financials__c,pse__Timecard_Internal_Costs_Submitted__c,pse__Time_Credited__c,pse__Time_Excluded__c,pse__Use_Project_Currency_For_Resource_Cost__c,pse__Use_Resource_Currency_For_Resource_Cost__c,pse__Use_Resource_Default_Cost_Rate_as_Daily__c,pse__Use_Resource_Default_Cost_Rate__c FROM pse__Assignment__c WHERE pse__Project__c IN:preList];
    notePreList =[Select Id,parentid,title,IsPrivate,body from note WHERE parentid IN:preList];
    attPreList = [Select Id,parentid,name,body,IsPrivate,description from attachment WHERE parentid IN:preList];
}

/* Commenting the below to remove cloning of assignments on implementation project as per Defect 1495
// Logic for collecting the schedule ids for attachments, resources on assignments  
if(asspreList.size()>0)
{
for(pse__Assignment__c assList1 : asspreList)
{
    schSetID.add(assList1.pse__Schedule__c);
    assResourceSet.add(assList1.pse__Resource__c);
    assProjectSet.add(mapOfPresalesAndImp.get(assList1.pse__Project__c));
}
}

// Collecting schedule records for the Pre-sales projects assignments 
schList = [SELECT Clone_ID__c,CurrencyIsoCode,IsDeleted,LX_DataLoadId__c,LX_SFDC_ID__c,LX_Siebel_ID__c,Name,OwnerId,pse__Action_Force_Schedule_Refresh__c,pse__End_Date__c,pse__Friday_Hours__c,pse__Monday_Hours__c,pse__Saturday_Hours__c,pse__Scheduled_Days__c,pse__Scheduled_Hours__c,pse__Start_Date__c,pse__Sunday_Hours__c,pse__Thursday_Hours__c,pse__Tuesday_Hours__c,pse__Wednesday_Hours__c,pse__Week_Total_Hours__c FROM pse__Schedule__c where ID in :schSetID];

//Populating the Clone_ID field with Id of the schedules
For(pse__Schedule__c sch1: schList)
sch1.Clone_ID__c=sch1.id;

// Deepcloning schedules
tempSchList =schList.deepclone();
System.debug(tempSchList);

//Inserting cloned schedules
insert tempSchList;

//Collecting the inserted schedules
if(schList.size()>0)
listSch = [Select id,Clone_ID__c from pse__Schedule__c where Clone_ID__c =:schSetID ];

//Populating a map of Pre-sales project assignment schedules and new schedules that are added
for(pse__Schedule__c sch: listSch)
mapOfSch.put(sch.Clone_ID__c,sch.id);

//collecting Scheduleexception records for the assignment schedules
schExcpList = [SELECT CurrencyIsoCode,Id,IsDeleted,LX_DataLoadId__c,LX_SFDC_ID__c,LX_Siebel_ID__c,Name,pse__Date__c,pse__End_Date__c,pse__Exception_Hours__c,pse__Friday_Hours__c,pse__Monday_Hours__c,pse__Saturday_Hours__c,pse__Schedule__c,pse__Sunday_Hours__c,pse__Thursday_Hours__c,pse__Tuesday_Hours__c,pse__Wednesday_Hours__c FROM pse__Schedule_Exception__c where pse__Schedule__c in :schSetID];
list<string> fieldList = 'CurrencyIsoCode,LX_DataLoadId__c,LX_SFDC_ID__c,LX_Siebel_ID__c,pse__Date__c,pse__End_Date__c,pse__Exception_Hours__c,pse__Friday_Hours__c,pse__Monday_Hours__c,pse__Saturday_Hours__c,pse__Sunday_Hours__c,pse__Thursday_Hours__c,pse__Tuesday_Hours__c,pse__Wednesday_Hours__c'.split(',');

//Logic to deepclone and insert new scheduleExceptions for new schedules created.
if(schExcpList.size()>0)
{
for(pse__Schedule_Exception__c schExp: schExcpList)
{
    pse__Schedule_Exception__c sampException = new pse__Schedule_Exception__c();
    for(string field :fieldList){
        sampException.put(field,schExp.get(field));     
    }
    sampException.pse__Schedule__c = mapOfSch.get(schExp.pse__Schedule__c);
    schExpImpList.add(sampException);
}
insert schExpImpList;
}

//Logic to deepclone and insert new scheduleExceptions for new schedules created
if( asspreList.size()>0)
{
   for(pse__Assignment__c assign :asspreList)
  {
    System.debug('Presales Map loop');
       if (mapOfProjAssig.containskey(assign.pse__Project__c))
       mapOfProjAssig.get(assign.pse__Project__c).add(assign);
       else
       mapOfProjAssig.put(assign.pse__Project__c,new List<pse__Assignment__c>{assign});
    }
   system.debug(mapOfProjAssig);
}
*/


//Logic for populating a map of pre-sales project id and list of attachments
if( attPreList.size()>0)
{
    for(Attachment att :attPreList)
    {
        if (mapOfProjAtt.containskey(att.parentid))
        mapOfProjAtt.get(att.parentid).add(att);
        else
        mapOfProjAtt.put(att.parentid,new List<Attachment>{att});
    }
    system.debug(mapOfProjAtt);
}

//Logic for populating a map of pre-sales project id and list of notes
if( notePreList.size()>0)
{
    for(Note notes1 :notePreList)
    {
        if (mapOfProjNote.containskey(notes1.parentid))
        mapOfProjNote.get(notes1.parentid).add(notes1);
        else
        mapOfProjNote.put(notes1.parentid,new List<Note>{notes1});
    }
    system.debug(mapOfProjNote);
}

//Logic for updating the implementation project id on list of assignments,notes,attachments and deepcloning the lists.
for(pse__Proj__c pro:Trigger.New)
{
    if(pro.Record_Type_Names__c =='ISS Implementation Project')
    {
    if(pro.Pre_Sales_Project_Name__c!= null)
    {
    //if(mapOfProjAssig.keyset().size()>0)
    //assPretoImpList = mapOfProjAssig.get(mapOfImpAndPresales.get(pro.id));
    
    if(mapOfProjNote.keyset().size()>0)
    notePretoImpList = mapOfProjNote.get(mapOfImpAndPresales.get(pro.id));
      if(mapOfProjAtt.keyset().size()>0)
    attPretoImpList = mapOfProjAtt.get(mapOfImpAndPresales.get(pro.id));
    
    /*  Commenting the below to remove cloning of assignments on implementation project as per Defect 1495
    if(assPretoImpList.size()>0)
    {
    assTempList = assPretoImpList.deepclone();
    for(pse__Assignment__c impAssign :assTempList)
    {
     System.debug('Implemantation assginemnt loop');
        impAssign.pse__Project__c = pro.id;
        impAssign.pse__Schedule__c = mapOfSch.get(impAssign.pse__Schedule__c);
        System.debug(impAssign.pse__Schedule__c);
        assImpList.add(impAssign);
    }
    }
    */
   
   if(notePretoImpList.size()>0)
    {
    noteTempList = notePretoImpList.deepclone();
    for(Note impNote :noteTempList)
    {
       impNote.parentid = pro.id;
       noteImpList.add(impNote);
    }
    }
    
     if(attPretoImpList.size()>0)
    {
    attTempList = attPretoImpList.deepclone();
    for(Attachment impAtt :attTempList)
    {
       impAtt.parentid = pro.id;
       attImpList.add(impAtt);
    }
    }
   }
    }
}

/* Commenting the below to remove cloning of assignments on implementation project as per Defect 1495
//Creating permission control for the implementation project and assignment resources
LX_CommonUtilities.createPermissionCont(assResourceSet,assProjectSet,userid1);

//Inserting assignments for implementation project
if(assImpList.size()>0)
insert assImpList;
*/

//Inserting notes for implementation project
if(noteImpList.size()>0)
insert noteImpList;

//Inserting attachments for implementation project
if(attImpList.size()>0)
insert attImpList;

}