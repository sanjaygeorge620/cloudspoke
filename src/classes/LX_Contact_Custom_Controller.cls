/* Class Name : LX_Contact_Custom_Controller
 * Description : This is a custom controller for visualforce page LX_Contact_Multiselect.
 * Created By : Anita Koshi(Deloitte)
 * Created Date : 6-11-2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Anita Koshi          6-11-2013                        Initial Version
 * Kapil Reddy Sama     8-14-2013                        Migrated to QA
 */
public class LX_Contact_Custom_Controller {
  
    //Collection of the class/wrapper objects cContact 
    public List<cContact> contactList {get; set;}

/*Description: This method written to use a SOQL query to return a List of Contacts.
*Param:None
*Returns:contactList(Contact List)
*/ 

    public List<cContact> getContacts() {
        if(contactList == null) {
            contactList = new List<cContact>();
                for(Contact c: [select Id, Name, Email, Phone from Contact limit 10]) {
            
                    // As each contact is processed, a new cContact object is created and added to the contactList
                    contactList.add(new cContact(c));
                }
            }
        return contactList;
    }
    
/*Description: This is a pageReference method to create new list of contacts and to add contacts to the selectedContacts list.
*Param:None
*Returns: ref(PageReference)
*/ 

    public PageReference processSelected() {

        //A new list of Contacts is created that will be populated only with Contacts if selected.
        List<Contact> selectedContacts = new List<Contact>();

        //The code will cycle through the list of cContacts and will check if the selected property is set to true, if yes then contact is added to the selectedContacts list
        for(cContact cCon: getContacts()) {
            if(cCon.selected == true) {
                selectedContacts.add(cCon.con);
            }
        }

        for(Contact con: selectedContacts) {
            system.debug(con);
        }
       
        contactList=null; 
        // This is performed to get fresh Contacts list
        //return null;
        pageReference ref = new PageReference('https://mail.google.com/mail/?view=cm&ui=2&tf=0&to=test@email.com&fs=1&body=testbody&subject=testS');
        //ref.setRedirect(true);
        return ref;
    }

/*Description: This is wrapper/container class.
*Param:None
*Returns:Void
*/
    
    public class cContact {
        public Contact con {get; set;}
        public Boolean selected {get; set;}
      
/*Description: This is the contructor method. When a new cContact object is created, a Contact is passed that is set to the con property. Also, selected value is set to false.
*Param:None
*Returns:Void
*/
      
        public cContact(Contact c) {
            con = c;
            selected = false;
        }
    }
}