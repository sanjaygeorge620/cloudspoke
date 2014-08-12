/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
public with sharing class PostingListController extends AbstractPostingController {
    
    private List<Posting__c> postings;
    
    public String getParam() {
        String kw = ApexPages.currentPage().getParameters().get('kw');
        if (kw != null) {
            return 'kw=' + EncodingUtil.urlEncode(kw,'utf-8');
        }        
        return 'cat=' + getCategory().getValue();
    }
    
    public String getNoPostMsg() {
        String kw = ApexPages.currentPage().getParameters().get('kw');
        if (kw != null) {
            return 'No results found';
        }
        return 'There are no posts yet.';
    }
    
    public boolean getShowCat() {
        String kw = ApexPages.currentPage().getParameters().get('kw');
        return (kw != null);
    }
    
    private void initPostings() {
        if (postings==null) {
            Schema.PicklistEntry c = getCategory();
            List<Posting__c> all;
            if (c==null) {
                String kw = ApexPages.currentPage().getParameters().get('kw');
                if (kw==null) {
                        postings = new List<Posting__c>();
                        return;
                }
                kw = EncodingUtil.urlDecode(kw, 'utf-8');
                all = (List<Posting__c>)[FIND :kw IN ALL FIELDS RETURNING Posting__c (id, title__c, createddate, zip_code__c, category__c, price__c order by createddate desc)].get(0);
            } else {
                String cat = c.getValue();
                all = [select id, title__c, createddate, zip_code__c, category__c, price__c from Posting__c where category__c= :cat order by createddate desc];
            }
            String zip = getZipParam();
            if (zip==null || zip.length()==0) {
                postings=all;
            } else {
                if (!validateZipCode(zip, true)) {
                    postings = new List<Posting__c>();
                    return;
                }
            
                postings = new List<Posting__c>();
                for (Posting__c post : all) {
                    if (isClose(zip, post.Zip_code__c)) {
                        postings.add(post);
                    }
                }
            }
        }
    }
    
    public PostingHelper[] getPostings() {
        initPostings();
        return postingsToHelpers(postings);
    }
    
    public PostingHelper[] getMyPostings() {
        initMyPostings();
        return postingsToHelpers(postings);
    }
    
    private void initMyPostings() {
        if (postings==null) {
            String userid = UserInfo.getUserId();
            postings = [select id, title__c, createddate, zip_code__c, category__c, price__c from Posting__c where createdby.id= :userid order by createddate desc];
        }
    }
    
    public boolean getAreTherePostings() {
        initPostings();
        return postings.size() != 0;
    }

    public boolean getAreThereMyPostings() {
        initMyPostings();
        return postings.size() != 0;
    }

    private static User createTestUser() {
        User u = new User(alias = 'newUser', email='newuser@lexmark.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = UserInfo.getProfileId(),Legacy_Company__c='Lexmark', 
            timezonesidkey='America/Los_Angeles', username='RandomUser' + math.rint(math.random() * 1000000) + '@craigsforce.com',LX_region__c='NE');
        
            insert u;
         
        return u;
    }
    static testmethod void testMyPostings() {
        List<Posting__c> old = [select id from Posting__c];
        delete(old);
        PostingListController c = new PostingListController();
        System.assert(c.postings==null);
        Posting__c p = AbstractPostingController.createTestPost();
        System.assert(p.id != null);
        c.initMyPostings();
        System.assert(c.postings.size()==1);
        System.assertEquals(1,c.getMyPostings().size());
        System.assertEquals('title', c.getMyPostings()[0].posting.title__c);
        
        User u1 = createTestUser();
        System.runAs(u1) {
            PostingListController c1 = new PostingListController();
            System.assertEquals(0, c1.getMyPostings().size());
            c1.getShowCat();
            c1.getAreTherePostings();
            c1.getAreThereMyPostings();
        }
    }
    
    static testmethod void testAllPostings() {
        List<Posting__c> old = [select id from Posting__c];
        delete(old);
        PostingListController c = new PostingListController();
        Posting__c p = AbstractPostingController.createTestPost();
        ApexPages.currentPage().getParameters().put('cat','Free');
        System.assertEquals('title', c.getPostings()[0].posting.title__c);
        System.assertEquals(1, c.getPostings().size());
        
        User u1 = createTestUser();
        System.runAs(u1) {
            System.assertEquals(1, c.getPostings().size());
        }
    }
    
    static testmethod void testFarAwayPostings() {
        List<Posting__c> old = [select id from Posting__c];
        delete(old);
        PostingListController c = new PostingListController();
        Posting__c p = AbstractPostingController.createTestPost();
        ApexPages.currentPage().getParameters().put('cat','Free');
        ApexPages.currentPage().getParameters().put('zip','00000');
        System.assertEquals(0, c.getPostings().size());
        
        User u1 = createTestUser();
        System.runAs(u1) {
            System.assertEquals(0, c.getPostings().size());
        }
    }
    
    static testmethod void testNearByPostings() {
        List<Posting__c> old = [select id from Posting__c];
        delete(old);
        PostingListController c = new PostingListController();
        Posting__c p = AbstractPostingController.createTestPost();
        ApexPages.currentPage().getParameters().put('cat','Free');
        ApexPages.currentPage().getParameters().put('zip','94105');
        System.assertEquals(1, c.getPostings().size());
        System.assertEquals('There are no posts yet.', c.getNoPostMsg());
        System.assertEquals('cat=Free', c.getParam());
    }
    
    
    static testmethod void testSearchNegativeKeyWord() {
        List<Posting__c> old = [select id from Posting__c];
        delete(old);
        PostingListController c = new PostingListController();
        Posting__c p = AbstractPostingController.createTestPost();
        ApexPages.currentPage().getParameters().put('kw','zzz');
        ApexPages.currentPage().getParameters().put('zip','94105');
        System.assertEquals(0, c.getPostings().size());
        
    }
    
    static testmethod void testSearchNegativeLocation() {
        List<Posting__c> old = [select id from Posting__c];
        delete(old);
        PostingListController c = new PostingListController();
        Posting__c p = AbstractPostingController.createTestPost();
        ApexPages.currentPage().getParameters().put('kw','title');
        ApexPages.currentPage().getParameters().put('zip','34105');
        System.assertEquals(0, c.getPostings().size());
        System.assertEquals('No results found', c.getNoPostMsg());
        System.assertEquals('kw=title', c.getParam());
    }
}