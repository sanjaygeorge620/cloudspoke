public class  OfferEmail{
    
    public void OfferQuoteEmail(ID recid)
    {
     List < String > liEnrolId = new List < String > ();
     Integer  EnrolIdCount=0, intEmailCount=0;
     string Oid='',strEid='';
     string strOfferStatus='', strOfferType='',strEmail='';
     List < LX_Offer_Enrollment__c > liOfferEnrol;
     List < USER> liUser;
     Set < LX_Offer_Enrollment__c > setOfferEnrol;
     List < Id > liAccid = new List < Id > ();
     Oid=recid;
    /* String hostname = ApexPages.currentPage().getHeaders().get('Host'); 
        String domain = 'https://' + hostname + '/apex'; 
         
      system.debug('>>>>>>>>>>>>>>Azeer Check here>>>>>'+domain);*/
     LX_Offer__c objOfferId=[Select id,LX_Offer_Status__c,LX_Offer_Type__c from LX_Offer__c where id=: recid];  
     
    
     
        system.debug('>>>>>>>>>>>>>>Azeer Check here>>>>>');
        
        // condition to check the status= approved and type = pricelist offer
        if(objOfferId.LX_Offer_Type__c =='Pricelist Offer')   
        {
        
            
          liOfferEnrol = [Select Account_owner_ID__c from LX_offer_Enrollment__c where offer__c=:recid];
          integer intAccIDCount=liOfferEnrol.size();
          /*for(LX_Offer_Enrollment__c off1: liOfferEnrol)
          {
            setOfferEnrol.add(off1.Account_owner_ID__c); 
          }
            
             for(LX_Offer_Enrollment__c off: setOfferEnrol)
          {
              liAccid.add(off.Account_Owner_ID__c);
              system.debug('Azeer>>>>>>>>>>>>>>>>>>>>>'+liAccid);
          }*/
            
          for(LX_Offer_Enrollment__c off: liOfferEnrol)
          {
              liAccid.add(off.Account_Owner_ID__c);
          }
           
           liUser = [Select email from user where id in: liAccid];
           system.debug('Azeer>>>>>>>>>>>>>>>>>>>>>'+liUser);
            for(User objUser: liUser)
            {
           SendEmailNotification(objUser.Email);
            }
         //User objuser = [Select id,email from user where id=:objofferenroll.Account_owner_ID__c];
        
         //liOfferEnrol.
            
         //SendEmailNotification(objuser.email);
         //
         //
         //system.debug('nazeer'+objuser.email);   
         //to get account owner id in the list 
         /* if(liOfferEnrol.size()>0)   
          {
              for (LX_Offer_Enrollment__c off: liOfferEnrol)
              {                
              //accOwnerID=off.Account_Owner_ID__c;
                system.debug('>>>>>>>>>>>>>>Azeer Check here>>>>>'+accOwnerID);
                liAccOwnerId.add(off.Account_Owner_ID__c);
                      
              }
            intAccountIdCount=liAccOwnerId.size();
              
          }// closing if condition to get account owner id in the list */
          
            
           // string qryGetEmailId = 'SELECT Email from user where id=:'+liOfferEnrol;
           /* liUser1 = Database.query(qryGetEmailId);
            intEmailCount=liUser1.size();
             liUser=liUser1.addAll(elements); */  
           
           
          // for to get email id from user table and call SendEmailNotification()
         
     }// closing if condition for staus = approved and type = pricelist offer
        
    
        
        
    }

    
 public void SendEmailNotification(string eid) {
   
       
       
        id ownid;
        String reqname,reqemail;
        String[] ownemail = new String[]{};
        String[] ownrname = new String[]{};
        String emailbody;
       
      try{
         // Replace the reqemail before moving to production
            reqemail = 'salesforce@lexmark.com';
          
            reqname = userinfo.getName();
          //reqname = 'YOGI';
            
            ownemail.add('drahim@dminc.in');
            
          //emailbody = 'Test Email from Apex class created';
            emailbody= '<html><body>Hi ' + userinfo.getName() + ',<br/><br/>Test Email from Apex class created</body></html>';
         //create a mail object to send a single email.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         //set the email properties
            mail.setToAddresses(ownemail);
            mail.setSenderDisplayName(reqname);
            mail.setSubject('Offer Enrollments Approved');
            mail.setHtmlBody(emailbody);
            mail.setusesignature(false);        
         //send the email
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
            if (results.get(0).isSuccess())  {
                System.debug('The email was sent successfully');
                }
                else {
                    System.debug('An error has occured, please contact Admin');
                }
        }
        Catch(Exception ex1)
        { 
            throw ex1;
            System.debug('Exception in user method'+ex1);
        }
    }
}