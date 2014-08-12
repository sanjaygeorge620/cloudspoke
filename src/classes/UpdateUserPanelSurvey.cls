public class UpdateUserPanelSurvey {  
  @future
    public static void updateSurvey(List<ID> convLeads){
      if(!convLeads.isEmpty()){
        map<ID,List<User_Panel_Survey__c>> mp_survey = new map<ID,List<User_Panel_Survey__c>>();
        List<User_Panel_Survey__c> us_list = new List<User_Panel_Survey__c>();
        List<User_Panel_Survey__c> toUpdate = new List<User_Panel_Survey__c>();
        us_list = [Select ID,Contact__c,Account_Name__c,Lead_Name__c,Survey_ID__c  from User_Panel_Survey__c where Lead_Name__c in :convLeads];
        List<Lead> ldlst = new List<Lead>();
        ldlst = [Select ID,ConvertedContactId from Lead where ID in :convLeads];
        if(!us_List.isEmpty()){
          for(User_Panel_Survey__c ua : us_list){
            if(mp_survey.containskey(ua.Lead_Name__c)){
              List<User_Panel_Survey__c> tmp_list = mp_survey.get(ua.Lead_Name__c);
              tmp_list.add(ua);
              mp_survey.put(ua.Lead_Name__c,tmp_list);
            }
            else if(!mp_survey.containskey(ua.Lead_Name__c)){
              List<User_Panel_Survey__c> tmp_list2 = new List<User_Panel_Survey__c>();
              tmp_list2.add(ua);
              mp_survey.put(ua.Lead_Name__c,tmp_list2);
            }
          }
        }
        for(Lead ld : ldlst){
          if(mp_survey.containskey(ld.ID) && mp_survey.get(ld.ID).size() > 0){      
            for(User_Panel_Survey__c uas : mp_survey.get(ld.ID)){
              uas.Contact__c = ld.ConvertedContactId;
              toUpdate.add(uas);    
            }           
          }
          if(!toUpdate.isEmpty()){
            try{
            Update toUpdate;
            }
            catch(exception ex){
              LX_CommonUtilities.createExceptionLog(ex);
            }
          }
        }

        map<ID,List<Marketing_Activities__c>> mp_marketing= new map<ID,List<Marketing_Activities__c>>();
        List<Marketing_Activities__c> mark_list = new List<Marketing_Activities__c>();
        List<Marketing_Activities__c> toMarkUpdate = new List<Marketing_Activities__c>();
        mark_list = [Select ID,Contact_ID__c,Name,Activity_Date__c,Activity_Type__c,Comments__c,Lead_ID__c,Related_Campaign__c  from Marketing_Activities__c where Lead_ID__c in :convLeads];
        List<Lead> ldlst1 = new List<Lead>();
        ldlst1 = [Select ID,ConvertedContactId from Lead where ID in :convLeads];
        if(!mark_list.isEmpty()){
          for(Marketing_Activities__c ma : mark_list){
            if(mp_marketing.containskey(ma.Lead_ID__c)){
              List<Marketing_Activities__c> tmp_lis = mp_marketing.get(ma.Lead_ID__c);
              tmp_lis.add(ma);
              mp_marketing.put(ma.Lead_ID__c,tmp_lis);
            }
            else if(!mp_marketing.containskey(ma.Lead_ID__c)){
              List<Marketing_Activities__c> tmp_lis2 = new List<Marketing_Activities__c>();
              tmp_lis2.add(ma);
              mp_marketing.put(ma.Lead_ID__c,tmp_lis2);
            }
          }
        }
        for(Lead ld : ldlst1){
          if(mp_marketing.containskey(ld.ID) && mp_marketing.get(ld.ID).size() > 0){      
            for(Marketing_Activities__c mas : mp_marketing.get(ld.ID)){
              mas.Contact_ID__c = ld.ConvertedContactId;
              toMarkUpdate.add(mas);    
            }           
          }
          if(!toMarkUpdate.isEmpty()){
            try{
            Update toMarkUpdate;
            }
            catch(exception ex){
              LX_CommonUtilities.createExceptionLog(ex);
            }
          }
        }   
      }   
    }
  }