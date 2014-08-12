@isTest(SeeAllData=true)
public class LX_OfferEmail_TestClass{
    
     static testMethod void validateEmail(){

      Test.startTest();
       	 system.debug('Offer test class begin');
         //insert Offer
         LX_Offer__c ObjOffer =new LX_Offer__c();
                  
         ObjOffer.LX_Offer_Type__c='Pricelist Offer';
         ObjOffer.Name='Madagascar BSD Level 1';
            
         Insert ObjOffer;
         system.debug('Offer Insert');
         system.debug(objoffer);
         
         //insert quote
        BigMachines__Quote__c ObjQuote = new BigMachines__Quote__c();
                 
        ObjQuote.BigMachines__Status__c='Pending';
        Objquote.Offer__c = objoffer.id;
        Insert ObjQuote;
        system.debug('Insert quote');
        system.debug(objquote);    
             
         //Account
        Account A = new Account(name='Account4TestMethod');       
 		A.Sector__c = 'State/Local';
        A.Type = 'Customer';  
        A.Party_Role__c = 'Perpetual';
        A.Party_Type__c =  'Commercial';
     //   A.Coverage_ID__c = gc.id;
        A.MDM_Sold_To_Number__c = '56A47657';
 	    A.Primary_Sector_Focus__c = 'Manufacturing'; 
        A.Legacy_Company_Originator__c = 'Acuo';
        A.LX_Sales_Team_Assigned__c='Manufacturing';
        A.Physical_Country__c = 'USA';
        A.BillingCountry  = 'USA';
        A.RecordTypeId=LX_SetRecordIDs.L5LocationPartnerAccountRecordId;
		Insert A;
        system.debug('Insert account');
        system.debug(a);
        
        //Offer Enrollment
        List<LX_Offer_Enrollment__c> offerEnrollmentsList = new List<LX_Offer_Enrollment__c> ();
        LX_Offer_Enrollment__c offerEnrollment;
        
            offerEnrollment = new LX_Offer_Enrollment__c (); 
            offerEnrollment.Account__c = A.id;
            offerEnrollment.LX_Product_Line_Items__c ='Printers';
            offerEnrollment.LX_Timing_of_Discount__c ='Back-end';
            offerEnrollment.Offer__c = ObjOffer.id;
            offerEnrollmentsList.add(offerEnrollment);
        Insert offerEnrollmentsList;
        system.debug(' Offer enrollment insert');
        system.debug(offerEnrollmentsList); 
         
        //update quote
        list<BigMachines__Quote__c> bmQuotes = [Select id,Offer__c from BigMachines__Quote__c where Offer__c = :objoffer.Id];
        for(BigMachines__Quote__c quote : bmquotes)
        {
        quote.BigMachines__Status__c = 'Approved';    
        }       
        system.debug(bmquotes);
        Update bmQuotes;
        system.debug('Update quote');
        system.debug(bmQuotes);
        LX_OfferEmail.OfferQuoteEmail(objoffer.id);
   }
}