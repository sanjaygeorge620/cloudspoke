/*
Class Name : LX_GetWBSController   
Description : Controller for the LX_GetWBS Visualforce page. 
Created By : Shubhashish Rai (shrai@deloitte.com)
Created Date :23/01/2014
Modification Log:
-------------------------------------------------------------------------
Developer                Date            Modification ID        Description
-------------------------------------------------------------------------
Shubhashish Rai        23 January 2014                            
*************************************************************************/
public class LX_GetWBSController{
    List<WBS_Element__c> elementList ;
    public List<SelectOption> selectOptionElements {get;set;}
    List<pse__Timecard_Header__c> timeCardList;
    List<WBC_Contact_Junction__c> conJunctionList = new List<WBC_Contact_Junction__c>();
    
    public map<String,String> mpSoldTo = new Map<String,String>();
    public map<String, String> mpElementID = new Map<String, String>();
    
    public string Values{set;get;}
    set<id> ConSet = new set<id>();
    String timeCardId;
    public boolean error{get; set;}
    public string baseUrl {get; set;}
    public boolean exceptionMsg {get; set;}
    
    public LX_GetWBSController(){
     baseUrl  = System.URL.getSalesforceBaseUrl().getHost();
        timeCardId = ApexPages.currentPage().getParameters().get('id');
        timeCardList = [Select pse__Assignment__r.pse__Resource__c from pse__Timecard_Header__c where id= :timeCardId];
        for(pse__Timecard_Header__c t:timeCardList){
            ConSet.add(t.pse__Assignment__r.pse__Resource__c);
        }
        conJunctionList = [Select WBS_Element__c, WBS_Description__c, Sold_to__c, WBS_Element__r.Name, WBS_Element__r.ID from WBC_Contact_Junction__c where Contact__c in :ConSet];
        for(WBC_Contact_Junction__c conJunction : conJunctionList){
            mpSoldTo.put(conJunction.WBS_Description__c, conJunction.Sold_to__c);
            mpElementID.put(conJunction.WBS_Description__c, conJunction.WBS_Element__r.Name);
        }
        System.debug(mpSoldTo);
        System.debug(mpElementID);
        
        //elementList = [SELECT id, Name from WBS_Element__c, where id in (Select WBS_Element__c from WBC_Contact_Junction__c where Contact__c in :ConSet)];
        selectOptionElements = new List<Selectoption>();
        selectOptionElements.add(new SelectOption('','--None--'));
        error = false;
        exceptionMsg = false;
        try{
            for(WBC_Contact_Junction__c conJunction: conJunctionList){
                selectOptionElements.add(new SelectOption(conJunction.WBS_Description__c,conJunction.WBS_Description__c));
            }
        }
        
        catch(Exception e){
              System.debug('Cannot retrieve Description values');
              ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.Warning, 'Cannot retrieve Description value(s)');
              ApexPages.addMessage(msg1);
              exceptionMsg = true;
              error = true;
              //return null;
          }
        
      /*  for(WBS_Element__c ele: elementList){
            selectOptionElements.add(new SelectOption(ele.id,ele.Name));
        }*/
    }
    public void save(){
    System.debug('>>>>>>>>>>>>>>>>>>'+values);
    if(Values != null && Values != ''){
          pse__Timecard_Header__c timecard = new pse__Timecard_Header__c (id=timeCardId, WBS_Element_Id__c = mpElementID.get(Values), LX_Sold_To_Contact_Junction__c= mpSoldTo.get(Values) ); 
          try{
              update timecard ;
              error = false;
              //PageReference pg = new PageReference('/'+timecard.id);
              //return pg;
          }
          catch(Exception e){
              System.debug('Update Failed');
              ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,String.valueOf(e));
              ApexPages.addMessages(e);
              exceptionMsg = true;
              error = true;
              //return null;
          } 
     }
      else{
          error=true;
      }
    }
   /* public void cancel(){
        pse__Timecard_Header__c timecard = new pse__Timecard_Header__c (id=timeCardId); 
        try{
            //PageReference pg = new PageReference('/'+timecard.id);
          //  return pg;
        }
        catch(Exception e){
            timecard.addError('Please try again');
          //  return null;
        }
    } */  
}