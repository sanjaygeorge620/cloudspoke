public abstract class AbstractPostingController {
    public List<Pair> getCategoryValues() {
        List<Pair> labels = new List<Pair>();
        
        Schema.DescribeFieldResult f = Posting__c.category__c.getDescribe();
        for (Schema.PicklistEntry e : f.getPicklistValues()) {
            labels.add(new Pair(e.getLabel(), EncodingUtil.urlEncode(e.getValue(), 'utf-8')));
        }
        return labels;
    }
    

    public Schema.PicklistEntry getCategory() {
        String cat = ApexPages.currentPage().getParameters().get('cat');
        if (cat==null) return null;
        String val = EncodingUtil.urlDecode(cat, 'utf-8');
        Schema.DescribeFieldResult f = Posting__c.category__c.getDescribe();
        for (Schema.PicklistEntry e : f.getPicklistValues()) {
            if (e.getValue().equals(val)) {
                return e;
            }
        }
        ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid category');
        ApexPages.addMessage(m);
        return null;
    }
    
    protected String getZipParam() {
        String z = ApexPages.currentPage().getParameters().get('zip');
        if (z==null) return null;
        return EncodingUtil.urlDecode(z, 'utf-8');
    }
    
    protected String getUserZip() {
        String userid = UserInfo.getUserId();
        return [select PostalCode from User where id = :userid].get(0).PostalCode;
    }
    
    public Boolean isClose(String z1, String z2) {
        return Math.abs(Integer.valueOf(z1) - Integer.valueOf(z2)) < 150;
    }
    
    public static boolean validateZipCode(String z, boolean allowBlank) {
    	if (allowBlank && (z==null || z.length()==0)) {
    		return true;
    	}
        ApexPages.Message m = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid 5 digit zip code or leave the field blank');
        if (z==null || z.length() != 5) {
            ApexPages.addMessage(m);
            return false;
        }
        try {
            Integer.valueOf(z);
        } catch (Exception e) {
            ApexPages.addMessage(m);
            return false;
        }
        return true;
    }
    
    public static PostingHelper[] postingsToHelpers(List<Posting__c> plist) {
        PostingHelper[] helpers = new List<PostingHelper>();
        for (Posting__c p : plist) {
            helpers.add(new PostingHelper(p, p.CreatedDate));
        }
        return helpers;
    }
    
    public static Posting__c createTestPost() {
        List<Posting__c> q = [select id from Posting__c];
        delete q;
        
        Posting__c p = new Posting__c();
        p.zip_code__c = '94116';
        p.category__c = 'Free';
        p.title__c = 'title';
        p.description__c = '<b>hi</b>';
        p.price__c=0;
        insert p;
        return p;
    }
    
    
    static testmethod void testValidateZipCode() {
        System.assert(AbstractPostingController.validateZipCode('10450',false));
        System.assert(!AbstractPostingController.validateZipCode('1j450',false));
        System.assert(!AbstractPostingController.validateZipCode('104500',false));
        System.assert(AbstractPostingController.validateZipCode(null,true));
    }
    
}