public class Sample_Chen {

	public void OfferQuoteEmail(ID recid) {
		List < String > liEnrolId = new List < String > ();
		Integer EnrolIdCount = 0, intEmailCount = 0;
		string Oid = '', strEid = '';
		string strOfferStatus = '', strOfferType = '', strEmail = '';
		List < LX_Offer_Enrollment__c > liOfferEnrol;
		List < USER > liUser1;
		List < String > liUser = new List < String > ();
		Oid = recid;

		LX_Offer__c objOfferId = [Select id, LX_Offer_Status__c, LX_Offer_Type__c from LX_Offer__c where id = : recid];

		// condition to check the status= approved and type = pricelist offer
		if (objOfferId.LX_Offer_Type__c == 'Pricelist Offer') {

			liOfferEnrol = [Select Account_owner_ID__c from LX_offer_Enrollment__c where offer__c = : recid];
              system.debug('*************************liOfferEnrol OUT**********************'+liOfferEnrol);
			for (integer i = 0; i < intEmailCount; intEmailCount++) {
                system.debug('*************************liOfferEnrol IN**********************'+liOfferEnrol);

			}
		}

	}

	public void SendEmailNotification(string eid) {

		id ownid;
		String reqname, reqemail;
		String[] ownemail = new String[] {};
		String[] ownrname = new String[] {};
		String emailbody;

		try {
			// Replace the reqemail before moving to production
			//reqemail = userinfo.getUserEmail();
			reqemail = 'drahim@dminc.com';
			reqname = userinfo.getName();
			reqname = 'YOGI';
			ownemail.add('ydharmalingam@dminc.in');
			emailbody = 'Test Email from Apex class created';

			//create a mail object to send a single email.
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			//set the email properties
			mail.setToAddresses(ownemail);
			mail.setSenderDisplayName(reqname);
			mail.setSubject('Subject of the mail');
			mail.setHtmlBody(emailbody);
			mail.setusesignature(false);
			//send the email
			List < Messaging.SendEmailResult > results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
				mail
			});
			if (results.get(0).isSuccess()) {
				System.debug('The email was sent successfully');
			} else {
				System.debug('An error has occured, please contact Admin');
			}
		} Catch(Exception ex1) {
			throw ex1;
			System.debug('Exception in user method' + ex1);
		}
	}
}