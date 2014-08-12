/*
Class Name : LX_OfferEmail
Description : This class sends emails to all the account owners enrolled into an offer when the quote on the offer changes from Pending to Approved
Created By : DMI 
Created Date : 07 2014

*************************************************************************/

public with sharing class LX_OfferEmail{
    
	private static OrgWideEmailAddress OWD = [SELECT id,Address,DisplayName FROM OrgWideEmailAddress where displayName='Salesforce Help' limit 1];
     public static void OfferQuoteEmail(ID offerid)
     {
        map<ID,LX_offer_Enrollment__c> mapOwnerIdOfferEnr = new map<ID,LX_offer_Enrollment__c>();
		
        
     	List<LX_Offer__c> objOfferId=[Select id from LX_Offer__c where id=: offerid and LX_Offer_Type__c=:'Pricelist Offer'];  
        if(objOfferId.size()>0)
        {
            For(LX_offer_Enrollment__c offEnr : [Select id,Account_Name__c,Account_owner_ID__c,Offer__r.Name from LX_offer_Enrollment__c where offer__c=:offerid])
            {
                 mapOwnerIdOfferEnr.put(offEnr.Account_owner_ID__c, offEnr);
            }
            
            for(User usr : [Select ID,Name,email from user where id in: mapOwnerIdOfferEnr.keySet()])
            {
                 SendEmailNotification(Offerid,usr.name,usr.email,mapOwnerIdOfferEnr.get(usr.id).Offer__r.Name);                 
            }
        }
    }

    
 	public static void SendEmailNotification(Id Offerid,String UName,String email,String offername) 
 	{
       
        id ownid;
        String[] ownemail = new String[]{};
        String emailbody,reqemail,subject;
               
        ownemail.add(email);
        emailbody= '<html><body>Dear ' +UName + '<p>' +
                	'There is a new approved quote for Pricelist - ' +offername+
                	'<br>' +
                	'<br>' +
                	'Please review any open opportunities with quotes using this pricelist. ' +
                	'<br>' +
                	'<br>' +
					'Click this link to access the Pricelist Offer: '+ 
                	'<a href="'+URL.getSalesforceBaseUrl().toExternalForm() +'/'+offerid +'">'+ offername +'</a> <br>'+
                	'<br>' +
                	'Thank you,' +
                	'<br>' +
                	'Salesforce Support <br>' +
                	'<br>' +
                	'</body></html>';
		Subject = 'Pricelist Approval Notification'  ; 				
       //create a mail object to send a single email.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      //set the email properties
       	mail.setReplyTo(OWD.Address);
        mail.setToAddresses(ownemail);
        //mail.setSenderDisplayName('Lexmark Support');
        mail.setorgWideEmailAddressId(OWD.id);
        //mail.setSenderDisplayName(OWD.DisplayName);
        mail.setSubject(Subject);
        mail.setHtmlBody(emailbody);
        mail.setusesignature(false); 
        
        //send the email
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                    
        //check email results    
        System.debug('Email result ' + results[0].IsSuccess());
    }  
    
}