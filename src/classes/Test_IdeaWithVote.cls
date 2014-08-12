/* 
* ©Lexmark Front Office 2013, all rights reserved
* 
* Created Date : 08/6/2013
*
* Author : Maruthi Kolla.
* 
* Description : Test Class for 'IdeaWithVote' Class.

*/

@istest
Public class Test_IdeaWithVote  
{
    Static testmethod void ideasWithVotes(){
        Idea idea1 = new Idea();
        Vote vote1 = new Vote();
        List<Idea> ideas1 = new List<Idea>();
        List<Vote> votes1 = new List<Vote>();
        List<ID> ids1 = new List<ID>();
        
        IdeaWithVote ideaWith1 = new IdeaWithVote(idea1,vote1);
        IdeaWithVote ideaWith2 = new IdeaWithVote(idea1,vote1,true);
        List<Profile>  pfd = [select id,name from profile where name ='System Administrator'];
        For(Profile pf1 :Pfd)
        ids1.add(pf1.id);
        List<User> us1 = Data_User.createUser(1,ids1);
        
        for(integer i=0;i<4; i++)
        {
        ideas1.add(new idea());
        votes1.add(new vote());
        }
        
        IdeaWithVote[] ideasWithVotes = IdeaWithVote.getIdeasWithVotes(ideas1);
        List<ID> ideasids = IdeaWithVote.getIdeaIds(ideas1);
         //Map<Id, Vote> voteIDs = IdeaWithVote.getIdeaIdToVoteMap(ideasids,us1[0].id);
        IdeaWithVote[] ideaWithVotes2 = IdeaWithVote.getIdeasWithVotes(ideas1, us1[0].id);
        IdeaWithVote[] ideaWithVotes3 = IdeaWithVote.getIdeasWithVotes(votes1);
        
    }
}