/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 */
public with sharing class PostingFeedController {
    
public PostingFeedController() {}
    public String pid {get; set;}
    

    public List<PostingFeedHelper> getMyFeed()  {
         List<Posting__Feed> myfeed = [SELECT Id, Type, 
                                CreatedById, CreatedBy.FirstName, CreatedBy.LastName, CreatedBy.Name, CreatedDate,
                                ParentId, Parent.Name, 
                                    FeedPostId, FeedPost.Body, FeedPost.Title, FeedPost.CreatedById,
                                (SELECT Id, FieldName, OldValue, NewValue 
                                          FROM FeedTrackedChanges ORDER BY Id DESC), 
                                (SELECT Id, CommentBody, CreatedDate,
                                        CreatedById, CreatedBy.Name
                                        FROM FeedComments ORDER BY CreatedDate DESC, ID DESC LIMIT 20)
                                 FROM Posting__Feed
                                 WHERE ParentId = :pid
                                 ORDER BY CreatedDate DESC, ID DESC
                                 LIMIT 20];
                             
       List<PostingFeedHelper> mylist = new List<PostingFeedHelper>();    
       for (Posting__Feed f : myfeed) {
        PostingFeedHelper w = new PostingFeedHelper(f, datetime.valueOf(f.createddate));
        mylist.add(w);
       }                          
       return mylist;
    }

// Wall post
    public string wallpost   { get; set; }

    public PageReference addAFeedPost()  {
        if (wallpost==null || wallpost.length() < 1) {
            return null;
        }
        FeedPost fpost = new FeedPost();
        fpost.ParentId = pid; 
        fpost.Body = wallpost;
        insert fpost;
        wallpost='';
        
        EntitySubscription sub = new EntitySubscription();
        sub.ParentId = pid;
        sub.SubscriberId = UserInfo.getUserId();
        try {
            insert sub;
        } catch (DMLException e) {
            // Most likely user is already subscribed 
        }
        return null;
    }


// Comment
    public string fpid   { get; set; }
    public string commentbody   { get; set; }

    public PageReference postComment()  {
        FeedComment fcomment = new FeedComment();
        fcomment.FeedItemId = fpid;
        fcomment.CommentBody = commentbody;
        insert fcomment;
        
        commentbody = '';
        return null;
        
    }
    
    static testMethod void testFeed() {
        Posting__c p = AbstractPostingController.createTestPost();
        PostingFeedController c = new PostingFeedController();
        c.pid = p.id;
        final String body = 'hey 123';
        c.wallpost = body;
        c.addAFeedPost();
        List<PostingFeedHelper> l = c.getMyFeed();
        System.assertEquals(1, l.size());
        PostingFeedHelper h = l.get(0);
        h.getHasComments();
        h.getCommentClass();
        System.assertEquals(body, h.feed.feedpost.body);
        System.assertEquals(0, h.feed.feedcomments.size());
        c.fpid = h.feed.id;
        final String commentB = 'ppqq';
        c.commentbody = commentB;
        
        c.postComment();
        l = c.getMyFeed();
        System.assertEquals(1, l.size());
        h = l.get(0);
        System.assertEquals(body, h.feed.feedpost.body);
        
        System.assertEquals(1, h.feed.feedcomments.size());
        System.assertEquals(commentB, h.getComments().get(0).comment.commentbody);
    }
    
}