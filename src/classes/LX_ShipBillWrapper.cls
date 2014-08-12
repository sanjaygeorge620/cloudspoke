/* Class Name   : LX_ShipBillWrapper  
    * Description : This is a wrapper class to hold the Bill To/ Ship To information that would be displayed on the page.
    * Created By   : Sumedha K./ Rahul Raghunathan
    * Created Date : 07-22-2013
    * Modification Log:  
    * --------------------------------------------------------------------------------------------------------------------------------------
    * Developer                Date                 Modification ID        Description 
    * ---------------------------------------------------------------------------------------------------------------------------------------
    * Sumedha K.            07-22-2013               1000                Initial Version    
    */
public class LX_ShipBillWrapper implements Comparable{
 
  // Variable to show if the record has been selected by the user or not.
  public Boolean Selected{get;set;}
  // Variable to store the Bill To / Ship To Name.
  public String billShipName{get;set;}
  // Variable to store the Bill To / Ship To ID.
  public String BillShipID{get;set;}
  // Variable to store the Bill To / Ship To Address Line 1.
  public String Address1{get;set;}
  // Variable to store the Bill To / Ship To Address Line 2.
  public String Address2{get;set;}
  // Variable to store the Bill To / Ship To Address company.
  public String Company{get;set;}
  // Variable to store the Bill To / Ship To Address city.
  public String City{get;set;}
  // Variable to store the Bill To / Ship To Address State.
  public String State{get;set;}
  // Variable to store the Bill To / Ship To Address postal Code.
  public String PostalCode{get;set;}
  // Variable to store the Bill To / Ship To Address postal Country.
  public String Country{get;set;}
  // Variable to store the Bill To Email ID
  public String billEmail{get;set;}
  // Variable to store the Bill To SMSA Default .
  public Boolean isDefault{get;set;}
  // Variable to store the sort by information.
  public static String sortBy;
  private String LX_billShipName_Var='billShipName';
  public final String LX_ASC = 'ASC';
  public final String LX_DESC='DESC';
  public String LX_billShipID_Var='BillShipID';
  public String LX_address1_Var='Address1';
  public String LX_address2_Var='Address2';
  public String LX_company_Var='Company';
  public String LX_city_Var='City';
  public String LX_state_Var='State';
  public String LX_country_Var='Country';
  public String LX_postalcode_Var='PostalCode';
  public String LX_Bill_Email_Var = 'billEmail';
    /*
     * 
     * Description : Constructor method for the LX_ShipBillWrapper class.
     * Param - : selected: If selected the true else false.
     * Param - : LX_ShiptoBillto_Stub.ShipToDetails recirved from the interface.
     * Returns : null
    */
    public LX_shipbillWrapper(Boolean isSelected, LX_ShiptoBillto_Stub.ShipToDetails stubShip){
         this.selected      = isSelected;
         this.billShipName  = stubShip.shipToName;
         this.Company       = stubShip.shipToCompany;
         this.Address1      = stubShip.shipToAddress;
         this.Address2      = stubShip.shipToAddress2;
         this.City          = stubShip.shipToCity;
         this.State         = stubShip.shipToStateOrProvince;
         this.PostalCode    = stubShip.shipToPostalCode;
         this.Country       = stubShip.shipToCountry;
         this.BillShipID    = stubShip.shipToID;
    }

    /*
     * 
     * Description : Constructor method for the LX_ShipBillWrapper class.
     * Param - : selected: If selected the true else false.
     * Param - : LX_ShiptoBillto_Stub.BillToDetails recirved from the interface.
     * Returns : null
    */
    public LX_shipbillWrapper(Boolean isSelected, LX_ShiptoBillto_Stub.BillToDetails stubbill){
         this.selected   = isSelected;
         this.billShipName = stubbill.billToName;
         this.Company    = stubbill.billToCompany;
         this.Address1   = stubbill.billToAddress;
         this.Address2   = stubbill.billToAddress2;
         this.City       = stubbill.billToCity;
         this.State      = stubbill.billToStateOrProvince;
         this.PostalCode = stubbill.billToPostalCode;
         this.Country    = stubbill.billToCountry;
         this.BillShipID = stubbill.billToID;
         this.billEmail  = stubbill.billToEmailID;
         if((stubbill.SMSARenewalBillTo != null)&&((stubbill.SMSARenewalBillTo.toLowerCase().trim()=='true'))){
            this.isDefault = true;
         }else{
            this.isDefault = false;
         }
    }
    /*
     * 
     * Description : Constructor method for the LX_ShipBillWrapper class which defaults everything to blank.
     * Param - : selected: If selected the true else false.
     * Param - : LX_ShiptoBillto_Stub.BillToDetails recirved from the interface.
     * Returns : null
    */
    public LX_ShipBillWrapper(){
         this.selected   = false;
         this.billShipName = '';
         this.Company    = '';
         this.Address1   = '';
         this.Address2   = '';
         this.City       = '';
         this.State      = '';
         this.PostalCode = '';
         this.Country    = '';
         this.BillShipID = '';
         this.isDefault  = false;   
         this.billEmail  = '';
    }
 
    /*
    * 
    * Description : Impletmentation of the compareTo method of the comparable interface. 
    * Based on the SortBy we get the corresponding values/
    * Param - : instance of the wrapper class.
    * Returns : +1 if it is greater. -1 if it is less and 0 if they are the same.
    */
    public Integer compareTo(Object compareTo) {
        
        if (sortBy.equals(LX_billShipName_Var+LX_ASC)){
           return billShipName.compareTo(((LX_shipbillWrapper)compareTo).billShipName);
         } else if (sortBy.equals(LX_billShipName_Var+LX_DESC)) {
            return billShipName.compareTo(((LX_shipbillWrapper)compareTo).billShipName) * (-1);       
        }
        if (sortBy.equals(LX_billShipID_Var+LX_ASC)){
           return BillShipID.compareTo(((LX_shipbillWrapper)compareTo).BillShipID);
         } else if (sortBy.equals(LX_billShipID_Var+LX_DESC)) {
            return BillShipID.compareTo(((LX_shipbillWrapper)compareTo).BillShipID) * (-1);       
        }
        if (sortBy.equals(LX_address1_Var+LX_ASC)){
           return Address1.compareTo(((LX_shipbillWrapper)compareTo).Address1);
         } else if (sortBy.equals(LX_address1_Var+LX_DESC)) {
            return Address1.compareTo(((LX_shipbillWrapper)compareTo).Address1) * (-1);       
        }
        if (sortBy.equals(LX_address2_Var+LX_ASC)){
           return Address2.compareTo(((LX_shipbillWrapper)compareTo).Address2);
         } else if (sortBy.equals(LX_address2_Var+LX_DESC)) {
            return Address2.compareTo(((LX_shipbillWrapper)compareTo).Address2) * (-1);       
        }
        if (sortBy.equals(LX_company_Var+LX_ASC)){
           return Company.compareTo(((LX_shipbillWrapper)compareTo).Company);
         } else if (sortBy.equals(LX_company_Var+LX_DESC)) {
            return Company.compareTo(((LX_shipbillWrapper)compareTo).Company) * (-1);       
        }
        if (sortBy.equals(LX_city_Var+LX_ASC)){
           return City.compareTo(((LX_shipbillWrapper)compareTo).City);
         } else if (sortBy.equals(LX_city_Var+LX_DESC)) {
            return City.compareTo(((LX_shipbillWrapper)compareTo).City) * (-1);       
        }
        if (sortBy.equals(LX_state_Var+LX_ASC)){
           return State.compareTo(((LX_shipbillWrapper)compareTo).State);
         } else if (sortBy.equals(LX_state_Var+LX_DESC)) {
            return State.compareTo(((LX_shipbillWrapper)compareTo).State) * (-1);       
        }
        if (sortBy.equals(LX_postalcode_Var+LX_ASC)){
           return PostalCode.compareTo(((LX_shipbillWrapper)compareTo).PostalCode);
         } else if (sortBy.equals(LX_postalcode_Var+LX_DESC)) {
            return PostalCode.compareTo(((LX_shipbillWrapper)compareTo).PostalCode) * (-1);       
        }
        if (sortBy.equals(LX_Bill_Email_Var+LX_ASC)){
           return billEmail.compareTo(((LX_shipbillWrapper)compareTo).billEmail);
         } else if (sortBy.equals(LX_Bill_Email_Var+LX_DESC)) {
            return billEmail.compareTo(((LX_shipbillWrapper)compareTo).billEmail) * (-1);       
        }
        if (sortBy.equals(LX_country_Var+LX_ASC)){
           return Country.compareTo(((LX_shipbillWrapper)compareTo).Country);
         } else if (sortBy.equals(LX_country_Var+LX_DESC)) {
            return Country.compareTo(((LX_shipbillWrapper)compareTo).Country) * (-1);       
        }        
       return -1;
   }
}