/*
 * ©Lexmark Front Office 2013, all rights reserved
 * Created Date : 08/05/2013
 * Author : Arun thakur(arunsingh6@deloitte.com)
 * Description : Submit Account records for MDM updates.
 *Flow:
 * 1.Select account records where MDM_Status='Awaiting MDM' and Account_Submitted =false.
 * 2.Create  WSDL For MDM Webservice. 
 */
//MDM Fields 
/*
***Required MDM Fields :
Business Name (English)
Street Line 1(English)
Street Line 2(English)
City(English)
Country(English)
Region/State/Province(English)
Postal Code(English)
Party Group
Party Type
Party Role
*****Optional MDM Fields
Business Name (Local Language)
Street Line 1(Local Language)
Street Line 2(Local Language)
City(Local Language)
Country(Local Language)
Region/State/Province(Local Language)
Postal Code(Local Language)
APO??
District
Telephone Number:Phone
Fax Number:Fax
Sales Representative??
Enter VAT Number(s)     
Enter Tax Numbers(s)    
****Default values for MDM
ISS Coverage Model  :Not needed on Lead Default to SMB
ISS Coverage Method:    Not needed on Lead Default to Web
Coverage Status:    Not needed on Lead Default to Active
Sales Representative:   Primary Rep Only, downstream business process to add account/opp team members.
SFDC Customer No:   System Generated
MPS Qualified   :Update on lead, Default to No
Primary ISS Internal Segment    Default to Pending
Local Priority: Default to Pending
Additional Comments :rep manually entered
SFDC ID System Generated
*/
public class LX_CreateAndSubmitMDMRequest
{


    public void DoMDMWebHttpRequest()
    {

        String Lx_MDMWebService='';
        for(Account ObjectAccount:[select Id,Name,
        Physical_Province_Other__c,Physical_Country__c,BillingState,BillingCountry,BillingPostalCode,BillingStreet,
        Local_Lang_Street_Address__c,Local_Lang_Street_Address_2__c,Local_Lang_City__c,Local_Lang_Province_Other__c,
        Local_Language_Physical_Country__c,Local_Lang_Postal_Code__c,Fax,Phone, 
        Party_Group__c,Party_Type__c,Party_Role__c,VAT_Number__c,Country_Type_Tax_Number__c
        from account where MDM_Status__c='Awaiting MDM' and Account_Submitted__c=false])
        {
            //To:do MDM Body Webservice
            Lx_MDMWebService+='<Body>';
        }

        HttpRequest req = new HttpRequest(); 
        req.setMethod('PUT');
        //req.setEndpoint( this.serviceEndPoint + this.bucket +'/' + this.key);
        //Set the HTTPRequest body  
        //req.setBody(body);    

      Http http = new Http();
        try {
             
                    //Execute web service call here    
                    if(!Test.isRunningTest())
                    { 
                    HTTPResponse res = http.send(req);  
                    //Helpful debug messages
                    System.debug(res.toString());
                    System.debug('STATUS:'+res.getStatus());
                    System.debug('STATUS_CODE:'+res.getStatusCode());
                    }
                    
            } catch(System.CalloutException e) 
            {
                //Exception handling goes here....
            }
    }
    

}