/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
public with sharing class PostingWizardController extends AbstractPostingController {
    public Posting__c posting;
    public PostingWizardController() { }
    public PostingWizardController(ApexPages.StandardController stdController) {
        this.posting = (Posting__c)stdController.getRecord();
        Schema.PicklistEntry cat = getCategory();
        if (cat != null) {
            posting.category__c = getCategory().getValue();
            posting.zip_code__c = getUserZip();
        }
    }
    
    public PageReference saveNew() {
        String id = posting.Id; 
      try {     
        upsert posting;
      } catch (Exception e) {
        return null;
      }
      PageReference page = new ApexPages.StandardController(posting).view();
      page.setRedirect(true);

        if (id != null) {
            return page;
        }

    try {
        EntitySubscription sub = new EntitySubscription();
        sub.ParentId = posting.Id;
        sub.SubscriberId = UserInfo.getUserId();
        
        insert sub;
    } catch (Exception e) {
        // Can't subscribe?  No big deal.
    }
        FeedPost post = new FeedPost();
        post.type = 'LinkPost';
        post.body = 'created a CraigsForce post';
        post.title = posting.title__c + ' (' + posting.category__c + ')';
        
        post.LinkURL = 'https://' + ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To') + page.getUrl();
        post.ParentId = UserInfo.getUserId();
        insert post;

      return page;

    }
    
    public boolean getRenderPrice() {
        return PostingCategoryMapping.hasPrice(posting.category__c);
    }
    
    static testmethod void testSaveNew() {
        List<Posting__c> q = [select id from Posting__c];
        delete q;
        
        Posting__c p = new Posting__c();
        p.zip_code__c = '94116';
        p.category__c = 'activities';
        p.title__c = 'title';
        p.description__c = '<b>hi</b>';
        
        PostingWizardController c = new PostingWizardController();
        c.posting = p;
        c.saveNew();
        
        System.assertEquals(1, [select id from EntitySubscription where parentId=:p.id].size());
        
        c.saveNew();
        System.assertEquals(1, [select id from EntitySubscription where parentId=:p.id].size());
        
        System.assertEquals(false, c.getRenderPrice());
    }
    
    static testmethod void testSaveNew2(){
    
         PostingWizardController c = new PostingWizardController(new ApexPages.standardController(new Posting__c()));
    
    }
    
}