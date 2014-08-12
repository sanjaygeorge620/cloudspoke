@isTest
(seeAllData=true)
private class Test_IdeaCommentDetails 
{
    static testMethod void validateIdeaCommentDetails() 
    {
        Community comm = [Select id from Community limit 1];
        idea a=new idea();
        a.title='test';
        a.communityId = comm.Id;
        insert a;
       
        IdeaComment b= new IdeaComment();
        b.ideaId = a.Id;
        b.commentBody='test';
        insert b;
        
        IdeaCommentDetails obj = new IdeaCommentDetails(a,b);
        list<idea> idea_1= new list<idea>();
        idea_1.add(a);
        IdeaCommentDetails.getIdeasWithComments(idea_1);
        map<id,ideaComment> mp= new map<id,ideaComment>();
        mp.put(b.id,b);
        IdeaCommentDetails.getIdeasWithComments(idea_1 ,mp);
        
        IdeaCommentDetails.getIdeasWithComments(idea_1, a.createdbyId);
        
        list<id> idea_id= new list<id>();
        idea_id.add(a.id);
        IdeaCommentDetails.getIdeasWithCommentsAndReadStatus(idea_1,idea_id);
                    
        
    }
}