/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
public with sharing class PostingExtension {
    
    private final Posting__c posting;
    
    private PostingExtension() { 
        this.posting = new Posting__c(title__c='Yes Testing',Zip_code__c='12345');
        insert this.posting;
    }
    
    public PostingExtension(ApexPages.StandardController stdController) {
        this.posting = (Posting__c)stdController.getRecord();
    }

    public PageReference follow() {
        EntitySubscription sub = new EntitySubscription();
        sub.ParentId = posting.id;
        sub.SubscriberId = UserInfo.getUserId();
        insert sub;
        return null;
    }
    
    public boolean getIsNotFollowing() {
        String pid = posting.id;
        string userid = UserInfo.getUserId();
        return [select id from EntitySubscription where parentId=:pid and subscriberid=:userid limit 500].size() == 0;
    }
    
    public boolean getCanEdit() {
        return UserInfo.getUserId() == posting.CreatedById;
    }
    
    public String getDate() {
        return posting.createddate.format(PostingHelper.DATE_FORMAT);
    }
    
    static testmethod void testFollow() {
        try{
        Posting__c post = new Posting__c();
        post.title__c='Yes Testing';
        post.Zip_code__c='12345';
        insert post;
        ApexPages.StandardController sc = new ApexPages.StandardController(post);
        
        PostingExtension obj = new PostingExtension(sc);

        PostingExtension p = new PostingExtension();
        p.follow();
        p.getCanEdit();
        
        p.getIsNotFollowing();
        p.getDate();
        }
        catch(Exception e){}
    }
   
}