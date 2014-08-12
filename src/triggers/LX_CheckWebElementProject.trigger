/**
**Author : Sumedha
**Date : 09/01/2014
**Objective: To create WBS requests based on resource and Company code.
** Modification Log: 
** --------------------------------------------------------------------------------------------------------------------------------------
** Developer       Date           Modification ID      Description 
** ---------------------------------------------------------------------------------------------------------------------------------------
** Kapil           01-22-2014     1001                 Updated the logic for creating WBS Requests 
**  Sanjay         02/20/2014                          Updated the query such that WBS request is only created for Billable Projects. 
**/

trigger LX_CheckWebElementProject on pse__Assignment__c(after insert,after update){
  Map<string,Company_Code__c> companyCodeMap = new Map<string,Company_Code__c>();
  Map<Id,List<pse__Assignment__c>>  mapProjAsg = new   Map<Id,List<pse__Assignment__c>>();
  Map<Id,List<pse__Assignment__c>> mapResrcAsg = new   Map<Id,List<pse__Assignment__c>>();
  Map<Id,pse__Assignment__c> mapAsg = new Map<Id,pse__Assignment__c>();
  Map<Id,Id> mapAsgProject = new Map<Id,Id>();
  Map<Id,Id> mapAsgResource = new Map<Id,Id>();
  List<String> projRecTypeIds = new List<String>{LX_SetRecordIDs.ProjectProfServicesRecordTypeId ,LX_SetRecordIDs.ProjectISSImplRecordTypeId};
  System.debug('>>>>>>>proj record types>>>>>>>>'+projRecTypeIds);
  
  for(Company_Code__c companyCode :[Select id,Company_Code_Description__c,Company_Code_Value__c from Company_Code__c]){
        companyCodeMap.put(companyCode.Company_Code_Value__c,companyCode);
  }
  
  for(pse__Assignment__c assign : trigger.new){
    if((trigger.isInsert && assign.pse__Project__c != null && assign.pse__Resource__c != null)|| 
    (trigger.isUpdate && assign.pse__Project__c != null && assign.pse__Resource__c != null
    && Trigger.oldmap.get(assign.id).pse__Resource__c != assign.pse__Resource__c && Trigger.oldmap.get(assign.id).pse__Project__c != assign.pse__Project__c))
    {
      mapAsg.put(assign.id,assign);
      mapAsgProject.put(assign.id,assign.pse__Project__c);
      mapAsgResource.put(assign.id,assign.pse__Resource__c);
      if(mapProjAsg.containsKey(assign.pse__Project__c)){
          mapProjAsg.get(assign.pse__Project__c).add(assign);
      }
      else{
         mapProjAsg.put(assign.pse__Project__c,new List<pse__Assignment__c>{assign});
      }
      if(mapResrcAsg.containsKey(assign.pse__Resource__c)){
          mapResrcAsg.get(assign.pse__Resource__c).add(assign);
      }
      else{
         mapResrcAsg.put(assign.pse__Resource__c,new List<pse__Assignment__c>{assign});
      }
    }
  }
    Map<Id,pse__Proj__c> mapProj = new Map<Id,pse__Proj__c>([SELECT id,pse__Opportunity__c,(select id,LX_Company_code__r.Company_Code_Value__c from WBS_Request__r),(select id,WBS_Element__r.Company_Code__c from WBS_Element_Project__r where Active__c=true) 
                                                                from pse__Proj__c 
                                                                where id in:mapProjAsg.keyset() AND recordtypeid in :projRecTypeIds AND pse__Billing_Type__c in ('Fixed Price', 'T&M/Fixed', 'Time and Materials')]);// ('012i0000000LsYc','012i0000000PCqf')]);
    Map<Id,Contact> mapRsc = new Map<Id,Contact>([SELECT ID,Company_Number__c FROM Contact WHERE Id in:mapResrcAsg.keyset()]);
    
    List<WBS_Request__c> wbsreqInsertList = new List<WBS_Request__c>();
    for(ID asgId : mapAsg.keyset()){//iterate through all the assignments.
      if(mapAsgProject.containsKey(asgId) && mapProj.containsKey(mapAsgProject.get(asgId))){  
         
          if(mapProj.get(mapAsgProject.get(asgId)).WBS_Element_Project__r.size()<=0){// If no WBS element projects on Project then insert requests.
           system.debug('-->No corresponding WBS Elements');
           boolean insertReqs = true ;
           // Check if there are any WBS requests   
           if(mapProj.get(mapAsgProject.get(asgId)).WBS_Request__r.size() > 0){ 
               system.debug('-->WBS Requests are present.');
               for(WBS_Request__c req: mapProj.get(mapAsgProject.get(asgId)).WBS_Request__r){                   
                    if(req.LX_Company_code__r.Company_Code_Value__c == mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c){
                        system.debug('-->Matching WBS Requests are present.');
                        insertReqs = false;
                        break;  
                    }else{
                        system.debug('-->No matching WBS Requests.');
                        insertReqs = true;           
                    }   
               }//for loop
           }//if 
           if(insertReqs == true){           
            WBS_Request__c request = new WBS_Request__c(LX_Opportunity__c = mapAsg.get(asgId).pse__Project__r.pse__Opportunity__c,LX_Project__c = mapAsg.get(asgId).pse__Project__c);
            if(mapAsgResource.get(asgId) != null && mapRsc.get(mapAsgResource.get(asgId)) != null && companyCodeMap.get(mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c) != null){
                request.LX_Company_code__c = companyCodeMap.get(mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c).id;
            }
            wbsreqInsertList.add(request);
           }
          }//if
          else{//check if there are any WBS Elements with matching Company Code.
            
            boolean insertCheck1 = false;            
            for(WBS_Element_Project__c wbsele : mapProj.get(mapAsgProject.get(asgId)).WBS_Element_Project__r){ // If matching WBS elements are present return                     
               if(mapAsgResource.containsKey(asgId) && mapRsc.containsKey(mapAsgResource.get(asgId)) && wbsele.WBS_Element__r.Company_Code__c == mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c){  
                system.debug('-->Matching WBS elements.');
                insertCheck1 = false;
                break;
               }
               else {
                system.debug('-->No Matching WBS elements.');
                insertCheck1 = true;
               }
            }//for loop
            //If no WBS requests are present then insert.
            if(insertCheck1 == true && (mapProj.get(mapAsgProject.get(asgId)).WBS_Request__r.size()<=0 )){ // If no matching WBS elements projects then check for existing WBS requests                
                WBS_Request__c request = new WBS_Request__c(LX_Opportunity__c = mapAsg.get(asgId).pse__Project__r.pse__Opportunity__c,LX_Project__c = mapAsg.get(asgId).pse__Project__c);
                if(mapAsgResource.get(asgId) != null && mapRsc.get(mapAsgResource.get(asgId)) != null && companyCodeMap.get(mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c) != null){
                    request.LX_Company_code__c = companyCodeMap.get(mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c).id;
                }
                wbsreqInsertList.add(request);
            }else if( insertCheck1 == true &&  mapProj.get(mapAsgProject.get(asgId)).WBS_Request__r.size() > 0 ){// If WBS requests are present check if they have matching company code                
                boolean insertCheck2 = false;
                for(WBS_Request__c req: mapProj.get(mapAsgProject.get(asgId)).WBS_Request__r){                    
                    if(req.LX_Company_code__r.Company_Code_Value__c == mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c){    
                        system.debug('-->Matching WBS requests on project.');
                        insertCheck2 = false;
                        break;  
                    }else{
                        insertCheck2 = true;           
                    }   
                }//for loop
                if(insertCheck2 == true){                    
                    WBS_Request__c request = new WBS_Request__c(LX_Opportunity__c = mapAsg.get(asgId).pse__Project__r.pse__Opportunity__c,LX_Project__c = mapAsg.get(asgId).pse__Project__c);
                    if(mapAsgResource.get(asgId) != null && mapRsc.get(mapAsgResource.get(asgId)) != null && companyCodeMap.get(mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c) != null){
                        request.LX_Company_code__c = companyCodeMap.get(mapRsc.get(mapAsgResource.get(asgId)).Company_Number__c).id;
                    }
                    wbsreqInsertList.add(request);
                }
            }
         }//else
      }//if
    }//for    
    try{
        if(wbsreqInsertList.size()>0){
          insert wbsreqInsertList;
        }
    }catch(Exception e){
        LX_CommonUtilities.createExceptionLog(e);
    } 
}