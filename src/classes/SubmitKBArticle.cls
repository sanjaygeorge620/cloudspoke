/*
Submit an Article to the KB
Created by Michael Fitzgerald
Adds the ability to allow for anyone that has the create permission to create an article
*/

Public without sharing class SubmitKBArticle{  
    //Error Message - Asserted in test so I didn't want to store it in multiple spots
    private string Insufficient_Msg ='Insufficient Privileges (Support_Articles__kav)';
    
    public class kbException extends exception{}
    public Support_Articles__kav kav{get{
        if(kav==null){
            kav = new Support_Articles__kav(URLNAME=string.valueof(datetime.now()).replace(' ','-').replace('/','').replace(':',''));
        }
        return kav;   
    }set;}

    public void saveArticle(){
        try {
            
            //check for creatability
            if(!Schema.sObjectType.Support_Articles__kav.isCreateable())
                throw new kbException(Insufficient_Msg);
            
            //else create
            insert kav;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Successfully Submitted'));
            //Reset
            kav = null;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    
    
    //Test Code Coverage 
    static testMethod void SubmitKBArticle_Positive() {
       user u =[Select id 
               From User 
               where UserPermissionsKnowledgeUser = true AND Profile.Name = 'System Administrator' AND isactive=true limit 1];
            
       system.runas(u){
        test.starttest();
            //Simply create an article and verify it gets reset to null
            SubmitKBArticle ctl = new SubmitKBArticle();
            ctl.kav.title = 'test';
            ctl.saveArticle();
            system.assert(ctl.kav.id==null, ctl.kav); //Verify it was reset    
        test.stoptest();
       } 
    }
    
   /*
    //Test Code Coverage 
    static testMethod void SubmitKBArticle_Negative() {
      user u =[Select id 
               From User 
               where UserPermissionsKnowledgeUser = false AND isactive=true limit 1];
               
      system.runas(u){
        test.starttest();
            //Simply create an article and verify it gets reset to null
            SubmitKBArticle ctl = new SubmitKBArticle();
            ctl.kav.title = 'test';
        
            ctl.saveArticle();
            System.assert(ApexPages.getMessages().get(0).getDetail() == ctl.Insufficient_Msg); //Verify error was thrown 
        test.stoptest();
      }
    }
    */

}