trigger set_SendtoSAP_Timecard on pse__Timecard_Header__c (before insert,before update) 
{
 if(LX_CommonUtilities.ByPassBusinessRule())
 {
  return;  
 }
   
 
 if(Trigger.isInsert || Trigger.isUpdate)
 {
     for(pse__Timecard_Header__c Tc : Trigger.new)
     {
         if((Trigger.isInsert && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && (Tc.SAP_Eligible__c== 'true')||(Trigger.isUpdate && (Tc.pse__Project_Methodology__c != Trigger.oldMap.get(Tc.id).pse__Project_Methodology__c || Tc.pse__Project__c != Trigger.oldMap.get(Tc.id).pse__Project__c))))
             {
                 string filterby = ''; 
                 string pref = '';
                 string prjmeth = '';
                 string prjid = '';
                 string  prjmethModified = '';
                 filterby = Tc.Company_Number__c;
                 prjID = Tc.pse__Project__c;
                 prjmeth = Tc.pse__Project_Methodology__c; 
                 prjmethModified = Tc.Modified_Project_Methodology__c;
                 List<WBS_Element__c> results = new List<WBS_Element__c>();
                 List<WBS_Element_Project__c> resultswep = new List<WBS_Element_Project__c>();
                 
                 if(Tc.Record_Type__c == 'Pre-Sales' || (prjmeth != null && (prjmeth.startsWith('PSW_INVST') || prjmeth.startsWith('LXK_'))))
                 {  
                 
                     pref = 'O';
                     
                    // String qs = 'Select ID,name,WBS_Description__c from WBS_Element__c where WBS_Type__c = \'Costing\' and Company_Code__c = \''+filterby+'\' and Active__c = \'True\' and WBS_Description__c = \''+prjmeth+'\' and Name Like \''+pref+'%\'';
                     //Changed the Query by Charan Vuyyuru on 23/01/2014
                     //String qs = 'Select ID,name,WBS_Description__c from WBS_Element__c where WBS_Type__c = \'Costing\' and Company_Code__c = \''+filterby+'\' and Active__c = true and WBS_Description__c = \''+prjmeth+'\' and Name Like \''+pref+'%\'';
                     //Kapil(1/24/2014) :Changed the query to pass the modified methodolgy
                     String qs = 'Select ID,name,WBS_Description__c from WBS_Element__c where WBS_Type__c = \'Costing\' and Company_Code__c = \''+filterby+'\' and Active__c = true and WBS_Description__c = \''+prjmethModified+'\' and Name Like \''+pref+'%\'';
                     System.debug('Query string is: '+ qs);
                     results = database.query(qs);
                     if(!results.isEmpty())
                     {
                         if(results.size() == 1)
                         {    
                            for(WBS_Element__c WBE : results)
                            {
                                if(WBE.WBS_Description__c != '')
                                {
                                //if(WBE.WBS_Description__c == Tc.Modified_Project_Methodology__c) 
                                //{
                                    Tc.WBS_Element_Id__c = WBE.Name;
                             
                                if(Trigger.isUpdate && Tc.Integration_Status__c == 'Success')
                                {
                                    Tc.Change_Type__c = 'Update';
                                }
                                else
                                {
                                    Tc.Change_Type__c = 'Insert';
                                }
                                if( Tc.pse__Status__c != null && Tc.pse__Status__c == 'Approved' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
                                {
                                    Tc.Integration_Status__c = 'Send to SAP';
                                }
                         
                         //}
                            }
                            } 
                         }
                         else if(results.size() > 1)
                          {
                              //[SG: 22/01/14] Commented to add errors to the new fields created.
                              Tc.WBS_Error_Message__c='Multiple Matching WBS Elements Found';
                              Tc.WBS_Status__c ='Error';
                              
                              //Tc.pse__Status__c = 'Multiple Matching WBS Elements Found';
                          }      
                     }
                     else 
                     {
                        system.debug('------------------No Records Found with the Given Criteria----------------');
                     }
                }else
                 {
                     if( Tc.pse__Project_Methodology__c != null && ( Tc.pse__Project_Methodology__c == 'Billable Hourly' || Tc.pse__Project_Methodology__c == 'Fixed Price Hours'))
                     {
                        pref = 'B';    
                     }                    
                     else if( Tc.pse__Project_Methodology__c != null && Tc.pse__Project_Methodology__c == 'MPS')
                     {
                        pref = 'P'; 
                     }
                     String qs = 'Select WBS_Element__c, WBS_Element__r.Id, WBS_Element__r.Name, WBS_Element__r.WBS_Description__c FROM WBS_Element_Project__c';
                     string filter ='where Project__c  = \''+prjID+'\' and WBS_Element__r.Company_Code__c = \''+filterby+'\' and WBS_Element__r.WBS_Type__c = \'Costing\' and WBS_Element__r.Active__c = True and WBS_Element__r.Name Like \''+pref+'%\'';
                     System.debug('Query string is: '+ qs);
                     resultswep = database.query(qs+' '+filter);
                     if(!resultswep.isEmpty())
                     {
                         if(resultswep.size() == 1)
                         {   
                            Boolean temp_flag = true;                        
                             for(WBS_Element_Project__c WBE : resultswep)
                             {
                                 if(WBE.WBS_Element__r.WBS_Description__c != '')
                                 { 
                                     //if(WBE.WBS_Element__r.WBS_Description__c == Tc.Modified_Project_Methodology__c)
                                        // {
                                        if(temp_flag)
                                         {
                                         String wbs_name = WBE.WBS_Element__r.Name;
                                         if(wbs_name.startswith('B')&& wbs_name.endswith(Tc.Company_Number__c))
                                         Tc.WBS_Element_Id__c = WBE.WBS_Element__r.Name;
                                         temp_flag=false;
                                         }
                                         
                                    if(( Tc.pse__Project_Methodology__c != null && Tc.pse__Project_Methodology__c == 'MPS'&&(WBE.WBS_Element__r.WBS_Description__c == Tc.Modified_Project_Methodology__c))||(Tc.pse__Project_Methodology__c == 'Billable Hourly' || Tc.pse__Project_Methodology__c == 'Fixed Price Hours'))
                                      {
                                     if(Trigger.isUpdate && Tc.Integration_Status__c == 'Success')
                                     {
                                          Tc.Change_Type__c = 'Update';
                                     }else
                                         {
                                         Tc.Change_Type__c = 'Insert';
                                         }
                                         if(Tc.pse__Status__c == 'Approved' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
                                         {
                                            Tc.Integration_Status__c = 'Send to SAP';
                                        }
                                    }
                                 }
                             }
                         } 
                          else if(resultswep.size() > 1)
                          {
                              //[SG: 22/01/14] Commented to add errors to the new fields created.
                              Tc.WBS_Error_Message__c='Multiple Matching WBS Elements Found';
                              Tc.WBS_Status__c ='Error';
                              
                              //Tc.pse__Status__c = 'Multiple Matching WBS Elements Found';
                          }  
                     }
                     else 
                     {
                        system.debug('------------------No Records Found with the Given Criteria----------------');
                     }   
                }
         }
     
     } 
 }
 
 
 if(Trigger.isUpdate)
 { 
    for(pse__Timecard_Header__c Tc : Trigger.new)
    {    
       /* if(Tc.pse__Monday_Hours__c==null||Tc.pse__Monday_Hours__c==0){
             Tc.Monday_Counter__c='';
        }
        if(Tc.pse__Tuesday_Hours__c ==0||Tc.pse__Tuesday_Hours__c==null){
             Tc.Tuesday_Counter__c='';
        }
        if(Tc.pse__Wednesday_Hours__c ==0||Tc.pse__Wednesday_Hours__c ==null){
             Tc.Wednesday_Counter__c='';
        }
        if(Tc.pse__Thursday_Hours__c ==0||Tc.pse__Thursday_Hours__c ==null){
             Tc.Thursday_Counter__c='';
        }
        if(Tc.pse__Friday_Hours__c ==0||Tc.pse__Friday_Hours__c ==null){
             Tc.Friday_Counter__c='';
        }
        if(Tc.pse__Saturday_Hours__c ==0||Tc.pse__Saturday_Hours__c ==null){
             Tc.Saturday_Counter__c='';
        }
        if(Tc.pse__Sunday_Hours__c ==0||Tc.pse__Sunday_Hours__c ==null){
             Tc.Sunday_Counter__c='';
        }*/
        
         boolean isChanged = False;
         if(Tc.pse__Monday_Hours__c != Trigger.oldMap.get(Tc.id).pse__Monday_Hours__c
         ||Tc.pse__Tuesday_Hours__c != Trigger.oldMap.get(Tc.id).pse__Tuesday_Hours__c
         ||Tc.pse__Wednesday_Hours__c != Trigger.oldMap.get(Tc.id).pse__Wednesday_Hours__c
         ||Tc.pse__Thursday_Hours__c != Trigger.oldMap.get(Tc.id).pse__Thursday_Hours__c
         ||Tc.pse__Friday_Hours__c != Trigger.oldMap.get(Tc.id).pse__Friday_Hours__c
         ||Tc.pse__Saturday_Hours__c != Trigger.oldMap.get(Tc.id).pse__Saturday_Hours__c
         ||Tc.pse__Sunday_Hours__c != Trigger.oldMap.get(Tc.id).pse__Sunday_Hours__c
         )
         {
         isChanged = True;
//         Tc.Change_Type__c = 'Update';
         }
         if(Trigger.oldMap.get(Tc.id).pse__Status__c != 'Approved' 
         && Tc.pse__Status__c == 'Approved'
         && Tc.Integration_Status__c == 'Draft'
         && (Tc.SAP_Eligible__c == 'true')
         && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
         {
            system.debug('-->Status updated');
            Tc.Change_Type__c = 'Insert';
            Tc.Integration_Status__c = 'Send to SAP';
         }
         
          if(Trigger.oldMap.get(Tc.id).WBS_Element_Id__c != Tc.WBS_Element_Id__c 
         && Tc.pse__Status__c == 'Approved'
         && Tc.Integration_Status__c == 'Draft'
         && (Tc.SAP_Eligible__c == 'true')
         && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
         {
            system.debug('-->Status updated');
            Tc.Change_Type__c = 'Insert';
            Tc.Integration_Status__c = 'Send to SAP';
         }
         
          if(Trigger.oldMap.get(Tc.id).WBS_Element_Id__c != Tc.WBS_Element_Id__c 
         && Tc.pse__Status__c == 'Approved'
         && Tc.Integration_Status__c == 'Success'
         && (Tc.SAP_Eligible__c == 'true')
         && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
         {
            system.debug('-->Status updated');
            Tc.Change_Type__c = 'Update';
            Tc.Integration_Status__c = 'Send to SAP';
         }
         
         
         
          
         
         if(Trigger.oldMap.get(Tc.id).pse__Status__c == 'Approved' 
         && Tc.pse__Status__c == 'Approved'
         && Trigger.oldMap.get(Tc.id).WBS_Element_Id__c == ''
         && Tc.WBS_Element_Id__c != ''
         && Tc.Integration_Status__c == 'Draft'
         && (Tc.SAP_Eligible__c == 'true')
         && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
         {
            system.debug('-->Status updated');
            Tc.Change_Type__c = 'Insert';
            Tc.Integration_Status__c = 'Send to SAP';
         }
         //Kapil :1/28/2014 : Changed the order of execution of #206 and #218.
        if(Trigger.oldMap.get(Tc.id).pse__Status__c != 'Un-Approved'
         && Tc.pse__Status__c == 'Un-Approved'
         && Tc.Integration_Status__c == 'Success'
         && (Tc.SAP_Eligible__c == 'true')
         && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
         {
            system.debug('-->Status updated');
            Tc.Change_Type__c = 'Delete';
            Tc.Integration_Status__c = 'Send to SAP';
         } 
         
         if(Trigger.oldMap.get(Tc.id).pse__Status__c == 'Un-Approved' 
//         && isChanged
         && Tc.pse__Status__c == 'Approved'
//         && Tc.Integration_Status__c == 'Success'
         && (Tc.SAP_Eligible__c == 'true')
         && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
         {
            system.debug('-->Status updated');
            Tc.Change_Type__c = 'Insert';
            Tc.Integration_Status__c = 'Send to SAP';
         } 
                            
       if( Trigger.oldMap.get(Tc.id).pse__Status__c != 'Un-Approved'
       && Tc.pse__Status__c != 'Un-Approved' 
         && isChanged
         && (Tc.SAP_Eligible__c == 'true')
         && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
         {
            system.debug('-->Status updated');
            Tc.Change_Type__c = 'Update';
         } 
         
         
        if(Trigger.oldMap.get(Tc.id).pse__Status__c == 'Approved'
         && Tc.pse__Status__c == 'Approved' 
         && isChanged
         && (Tc.SAP_Eligible__c == 'true')
         && Tc.Company_Number__c != '' && Tc.Employee_Number2__c != '' && Tc.WBS_Element_Id__c != null && Tc.WBS_Element_Id__c != '')
         {
            system.debug('-->Status updated');
            Tc.Change_Type__c = 'Update';
            Tc.Integration_Status__c = 'Send to SAP';
         } 
         
     }
 }//Update
 
}