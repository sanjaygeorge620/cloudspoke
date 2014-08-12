public class SearchController {

    @TestVisible public String inputCompanyName, inputWebsite, inputCountry, inputCity; // TODO take out website - not filterable?
    @TestVisible public integer inputPostalCode, inputAreaCode;
    @TestVisible private String query = 'None';
    @TestVisible private String errorMsg = 'No Error Message';
    @TestVisible private String purchaseFlowOutput = '';
    @TestVisible public Boolean isError;
    @TestVisible public Boolean showAccount;
    @TestVisible private Map<String, DCC> currentPage; // DDC id, Object
    @TestVisible private String newA; // String ID of newly created account for display
    
    @TestVisible private String currentId; // test
    
    public DatacloudCompany current; // TODO may not need

    public SearchController () {
        // This is where methods that should be run at the load of the page should be.
        System.debug('Entered Constructor');
        Map<String, DCC> currentPage = new Map<String, DCC>();
        isError = false;
        showAccount = false;
    }
    
    public void searchComp() {
        System.debug('Search Initiated - searchComp()');
        errorMsg = 'No Error Message'; // Reset error message for new search
        
        query = buildQuery();
        System.debug('Returned Query - ' + query);
        
        if (query.compareTo('stop')!=0) {
            currentPage = execQuery(query);
            System.debug('Returned set size : ' + currentPage.size());
            checkDupe();
        }
        else {
            query = 'None'; // Reset Query if not going to run
        }
    }
    
    @TestVisible private String buildQuery() {
        System.debug('Entered buildQuery()');
        String s = 'SELECT AnnualRevenue, City, CompanyId, Country, Description, DunsNumber, Fax, Industry, NaicsCode, ' + 
            'NaicsDesc, Name, NumberOfEmployees, Ownership, Phone, Sic, SicDesc, Site, State, Street, TickerSymbol, TradeStyle, Website, ' + 
            'YearStarted, Zip';
        s = s + ' FROM DatacloudCompany';
        s = s + ' WHERE'; // Separated for readability
        
        boolean firstHit = true; // Change to false on first hit to add AND to rest
        
        // Company Name
        if (inputCompanyName != null && inputCompanyName != '') {
            System.debug('Input Found - Company Name : ' + inputCompanyName);
            if (firstHit) { // Has this to match other inputs, in case something is copied and put before it
                firstHit = false;
            } else {
                s = s + ' AND';
            }
            s = s + ' Name LIKE \'%' + String.escapeSingleQuotes(inputCompanyName) + '%\''; // Method helps guard against SOQL injections
        }
        
        /*
        // Company Website - Not Filterable
        if (inputWebsite != null && inputWebsite != '') {
            System.debug('Input Found - Company Website : ' + inputWebsite);
            if (firstHit) {
                firstHit = false;
            } else {
                s = s + ' AND';
            }
            s = s + ' Website LIKE \'%' + String.escapeSingleQuotes(inputCompanyWebsite) + '%\''; // Method helps guard against SOQL injections
        }
        */
        
        // Company Country
        if (inputCountry != null && inputCountry != '') {
            System.debug('Input Found - Country : ' + inputCountry);
            if (firstHit) {
                firstHit = false;
            } else {
                s = s + ' AND';
            }
            s = s + ' Country = \'' + String.escapeSingleQuotes(inputCountry) + '\''; // Method helps guard against SOQL injections
        }
        
        // Company City
        if (inputCity != null && inputCity != '') {
            System.debug('Input Found - City : ' + inputCity);
            if (firstHit) {
                firstHit = false;
            } else {
                s = s + ' AND';
            }
            s = s + ' City = \'' + String.escapeSingleQuotes(inputCity) + '\''; // Method helps guard against SOQL injections
        }
        
        // Postal Code
        if (inputPostalCode != null && inputPostalCode != 0) {
            System.debug('Input Found - Postal Code : ' + inputPostalCode);
            if (firstHit) {
                firstHit = false;
            } else {
                s = s + ' AND';
            }
            s = s + ' Zip LIKE \'%' + String.escapeSingleQuotes(inputPostalCode+'') + '%\''; // Method helps guard against SOQL injections
        }
        
        /*
        // Area Code - Phone is not filterable (Could do manually...)
        if (inputAreaCode != null && inputAreaCode != '') {
            System.debug('Input Found - Area Code : ' + inputAreaCode);
            if (firstHit) {
                firstHit = false;
            } else {
                s = s + ' AND';
            }
            s = s + ' Name LIKE \'%' + String.escapeSingleQuotes(inputCompanyName) + '%\''; // Method helps guard against SOQL injections
        }
        */
        s = s + ' LIMIT 20'; // Keep the max to a reasonable number
        query = s;
        System.debug('Query string set as : ' + query);
        
        if (firstHit) {
            System.debug('No inputs found - firstHit = false');
            return 'stop';
        }
        return s;
        
        
    }
    
    @TestVisible private Map<String, DCC> execQuery(String q) {
        List<DatacloudCompany> results = new List<DatacloudCompany>();
        Map<String, DCC> res = new Map<String, DCC>();
        try {
            results = Database.query(q);
            System.debug('Query successful');
        }
        catch (exception e) {
            isError = true;
            System.debug('Error during execution of query caught');
        }
        for (DatacloudCompany c : results) {
            res.put(c.CompanyId, new DCC(c));
        }
        return res;
    }
    
    @TestVisible private void checkDupe() {
        ID userId = UserInfo.getUserId();
        List<Account> accts = [SELECT Jigsaw, ID FROM Account WHERE OwnerId=:userId AND
             Jigsaw IN :currentPage.keySet()];
        for(Account a : accts) {
            DCC dc = currentPage.get(a.Jigsaw);
            dc.setRenderBox('false');
            dc.setAccountId(a.ID);
            currentPage.put(dc.getId(), dc);
        }
    }
    
    @TestVisible public PageReference purchaseAccountDetails() { // Method invoked by VF to purchase details
        // 1 Insert into PurchasedEntity
        // 2 Insert id back and DDC id into isOwned
        // 3 Re-search just that id on DDC
        System.debug('Entering purchaseAccountDetails()');
        
        if (currentPage == null || currentPage.size() == 0) {
            System.debug('currentPage was null when purchase attempted');
            return null;
        }
        
        String id;
        DatacloudCompany dcTemp;
        Boolean purchaseSuccess;
        for (DCC c : currentPage.values()) {
            if (c.getSelected().compareTo('true')==0 && c.getHasLink().compareTo('true')!=0) {
                id = c.getId();
                System.debug('Found selected id: ' + id + ', name: ' + c.getName());
                if (!checkIdOwned(id)) {
                    purchaseSuccess = purchaseId(id);
                    if (purchaseSuccess) {
                        System.debug('purchaseId() returned true');
                        currentId = id;
                    } else {
                        // TODO any additional error handling should happen here
                    }
                } else {
                    // TODO implement non destructive account update here (clean)
                }
            } else {
                System.debug(c.getName() + ' was ignored with selected value: ' + c.getSelected());
            }
        }
        purchaseFlowOutput = 'Company purchase successful!';
        return null;
    }
    
    @TestVisible private Boolean checkIdOwned(String DDCid) {
        System.debug('Entered checkIdOwned()');
        List<DatacloudOwnedEntity> ownedEnt = [SELECT DataDotComKey,Id FROM DatacloudOwnedEntity 
            WHERE DataDotComKey = ':DDCid' AND UserId = :UserInfo.getUserId() LIMIT 5];
        if (ownedEnt != null && ownedEnt.size() != 0 && ownedEnt[0].DataDotComKey != null && OwnedEnt[0].DataDotComKey != '') {
            System.debug('Id found: ' + ownedEnt[0].DataDotComKey);
            return true;
        }
        System.debug('Id not found');
        return false;
    }
    
    @TestVisible public PageReference createAccount() {
        DatacloudCompany dcTemp = searchId(currentId);
        System.debug('searchId() returned, name: ' + dcTemp.Name);
        newA = fillAccountInfo(dcTemp);
        purchaseFlowOutput = 'Account successfully created!';
        return null;
    }
    
    @TestVisible public Boolean purchaseId(String DDCid) {
        System.debug('Entered purchaseId()');
        DatacloudPurchaseUsage pu = new DatacloudPurchaseUsage(DatacloudEntityType='1', 
            Description='Added via search-before-create Account Tool');
        insert pu;
        String puID = pu.ID;
        if (puID == null || puID == '') {
            System.debug('purchaseId() returning false because Purchase ID returned blank or null');
            return false;
        }
        DatacloudOwnedEntity oe = new DatacloudOwnedEntity(PurchaseUsageId=puID, DataDotComKey=DDCid, 
            DatacloudEntityType='1');
        insert oe;
        String oeID = oe.ID;
        if (oeID != null && oeID != '') {
            System.debug('purchaseId() returning true with ownedEntityID: ' + oe.ID);
            return true;
        }
        System.debug('purchaseId() returning false, owned entity may be the culprit');
        return false; // Error if it gets this far
    }
    
    @TestVisible public DatacloudCompany searchId(String DDCid) {
        System.debug('Entered searchId');
        
        try {
            DatacloudCompany dc = [SELECT AnnualRevenue, City, CompanyId, Country, Description, DunsNumber, 
                Fax, Industry, NaicsCode, NaicsDesc, Name, NumberOfEmployees, 
                Ownership, Phone, Sic, SicDesc, Site, State, Street, TickerSymbol, 
                TradeStyle, Website, YearStarted, Zip FROM DatacloudCompany WHERE 
                CompanyId = :DDCid LIMIT 1]; // Limit is included do step around a bug at the time (too many results)
            System.debug('Query successful');
            return dc;
        }
        catch (exception e) {
            isError = true;
            System.debug('Error during execution of query was caught');
        }
        
        return null; // Clearly an Error Occured
    }
    
    @TestVisible public String fillAccountInfo(DatacloudCompany dc) { // Returns string representation of ID 
        Account a = new Account(AccountSource='Data.com', AnnualRevenue=dc.AnnualRevenue, 
            BillingCity=dc.city, ShippingCity=dc.city, Jigsaw=dc.CompanyId, BillingCountry=dc.Country, 
            ShippingCountry=dc.Country, Description=dc.Description, DunsNumber=dc.DunsNumber, 
            Fax=dc.Fax, Industry=dc.Industry, NaicsCode=dc.NaicsCode, NaicsDesc=dc.NaicsDesc, 
            Name=dc.Name, NumberOfEmployees=dc.NumberOfEmployees, Ownership=dc.Ownership, 
            Phone=dc.Phone, Sic=dc.Sic, SicDesc=dc.SicDesc, Site=dc.Site, BillingState=dc.State, 
            ShippingState=dc.State, BillingStreet=dc.Street, ShippingStreet=dc.Street, 
            TickerSymbol=dc.TickerSymbol, Tradestyle=dc.TradeStyle, Website=dc.Website, 
            YearStarted=dc.YearStarted, BillingPostalCode=dc.Zip, ShippingPostalCode=dc.Zip);
        
        upsert a;
        
/* SAMPLE TRY CATCH BLOCK // TODO do I need this?
try {
    insert accts;        
    
    // Update account Acme2.
    accountToUpdate = 
        [SELECT BillingCity FROM Account 
         WHERE Name='Acme2' AND BillingCity='San Francisco'
         LIMIT 1];
    // Update the billing city.
    accountToUpdate.BillingCity = 'New York';
    // Make the update call.
    update accountToUpdate;
} catch(DmlException e) {
    System.debug('An unexpected error has occurred: ' + e.getMessage());
}
*/


        DCC dcc = new DCC(dc);
        dcc.setRenderBox('false');
        dcc.setAccountId(a.ID);
        currentPage.put(dcc.getId(), dcc);
        
        return a.ID + ''; // TODO 
    }
    
    @TestVisible public Boolean getHaveResults() {
        System.debug('Entered getHaveResults()');
        if (currentPage != null) {
            if (currentPage.size() == 0) { // Returns false if the size is 0
                System.debug('getHaveResults is returning False');
                return false;
            } else {
                System.debug('getHaveResults is returning True');
                System.debug('Size is : ' + currentPage.size());
                return true;
            }
            // return (currentPage.size() == 0) ? false : true;
        }
        System.debug('getHaveResults is returning False');
        return false; // This will only get called if currentPage is null, in which case there are no results
    }
    
    public PageReference returnToPage() {
        return null;
    }
    
    /* ---------- Getters and Setters ---------- */
    
    /* --- Below here are getters and setters for the VisualForce Page --- */
    public Map<String, DCC> getCurrentPage() {
        return currentPage;
    }
    public String getInputCompanyName() {
        return inputCompanyName;
    }
    public void setInputCompanyName(String value) {
        this.inputCompanyName = value;
    }
    public String getInputCity() {
        return inputCity;
    }
    public void setInputCity(String value) {
        this.inputCity = value;
    }
    public String getInputWebsite() {
        return inputWebsite;
    }
    public void setInputWebsite(String value) {
        this.inputWebsite = value;
    }
    public String getInputCountry() {
        return inputCountry;
    }
    public void setInputCountry(String value) {
        this.inputCountry = value;
    }
    public Integer getInputPostalCode() {
        return inputPostalCode;
    }
    public void setInputPostalCode(Integer value) {
        this.inputPostalCode = value;
    }
    public Integer getInputAreaCode() {
        return inputAreaCode;
    }
    public void setInputAreaCode(Integer value) {
        this.inputAreaCode = value;
    }
    public Boolean getShowAccount() {
        return showAccount;
    }
    public Boolean getIsError() {
        return isError;
    }
    public void setIsError(Boolean value) {
        this.isError = value;
    }
    public String getErrorMsg() {
        return errorMsg;
    }
    public String getQuery() {
        return query;
    }
    public String getPurchaseFlowOutput() {
        return purchaseFlowOutput;
    }
    public String getNewA() {
        return newA; // TODO change to real value 
    }
    
    /* ---------- Custom Class ---------- */
    
    @TestVisible public class DCC {
        private DatacloudCompany comp;
        private String selected;
        private String renderBox;
        private String accountId;
        
        public DCC(DatacloudCompany item) {
            this.comp = item;
            this.selected = 'false';
            this.renderBox = 'true';
            this.accountId = 'none';
        }
        
        public String getLink() {
            if (accountId.compareTo('none') == 0){
                return '';
            }
            return '<a href="'+ System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + accountId + '" > Account </a>';
        }
        public String getHasLink() {
            if (accountId.compareTo('none') != 0){
                return 'true';
            }
            return 'false';
        }
        public String getAccountId() {
            return accountId;
        }
        public void setAccountId(String value) {
            this.accountId = value;
        }
        public DatacloudCompany getComp() {
            return comp;
        }
        public String getSelected() {
            if (accountId.compareTo('none') != 0){
                return 'true';
            }
            return selected;
        }
        public void setSelected(String value) {
            this.selected = value;
        }
        public String getRenderBox() {
            return renderBox;
        }
        public void setRenderBox(String value) {
            this.renderBox = value;
        }
        public String getId() {
            return comp.CompanyId;
        }
        public String getTickerSymbol() {
            return comp.TickerSymbol;
        }
        public String getName() {
            return comp.Name;
        }
        public String getStreet() {
            return comp.Street;
        }
        public String getCity() {
            return comp.City;
        }
        public String getCountry() {
            return comp.Country;
        }
        public String getPhone() {
            return comp.Phone;
        }
        public String getAnnualRevenue() {
            return comp.AnnualRevenue + ''; // TODO add formatting later
        }
        public String getIndustry() {
            return comp.Industry;
        }
        public String getNaicsCode() {
            return comp.NaicsCode;
        }
        public String getSite() {
            return comp.Site;
        }
        public String getDescription() {
            return comp.Description;
        }
    }

}