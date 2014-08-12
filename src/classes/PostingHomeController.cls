/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
public with sharing class PostingHomeController extends AbstractPostingController {
    public String category {get; set;}
    public String searchTerm {get; set;}
    
    private String zip = getUserZip();
    
    public void setZip(String z) {zip=z;}
    public String getZip() {return zip;}
    
    public PageReference doSearch() {
        if (!validateZipCode(zip, true)) {
            return null;
        }
        
        String url='/apex/postList?kw=' + EncodingUtil.urlEncode(searchTerm,'utf-8') + '&zip=' + zip;
        return new PageReference(url);
    }
    
    public PostingHelper[] getNewestPostings() {
        List<Posting__c> plist = [select id, title__c, createddate, zip_code__c, category__c, price__c from Posting__c order by createddate desc limit 40];
        return postingsToHelpers(plist);
    }
    
    
    public PageReference choose() {
        if (!validateZipCode(zip, true)) {
            return null;
        }
        String url='/apex/postList?cat=' + category + '&zip=' + zip;
        return new PageReference(url);
    }
    
    static testmethod void testChoose() {
        PostingHomeController c = new PostingHomeController();
        c.setZip('94404');
        c.category = 'activities';
        PageReference p = c.choose();
        c.searchterm='test';
        c.doSearch();
        System.assertEquals('/apex/postList?cat=activities&zip=94404', p.getUrl());
    }
    
    static testmethod void testIsClose() {
        PostingHomeController c = new PostingHomeController();
        
        c.setZip('94116');
        System.assert(c.isClose(c.getZip(), '94086'));
        System.assert(c.isClose('94086', '94116'));
        System.assert(!c.isClose('14086', '94116'));
        System.assert(!c.isClose('94086', '14116'));
    }
    
    
    static testmethod void testGetCategory() {
        ApexPages.currentPage().getParameters().put('cat','Free');
        PostingHomeController c = new PostingHomeController();
        Schema.Picklistentry p = c.getCategory();
        System.assertEquals('Free',p.getValue());
        
        ApexPages.currentPage().getParameters().put('cat','barfing');
        p = c.getCategory();
        System.assertEquals(null, p);
        c.getNewestPostings();
    }
}