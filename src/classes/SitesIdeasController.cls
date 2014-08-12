/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public with sharing class SitesIdeasController extends SitesController {

    Public list<idea> getFeaturedIdeas(){
        list<idea> i = [select id, status, IsLocked, CreatedBy.Id, CreatedBy.CommunityNickname, categories, title,votetotal, body, createddate  from idea where id=:SITE_IDEAS_FEATURED limit 1];
      return i;     
    }    
    
    public String howUserVoted {
                get {
                        if (howUserVoted == null) {
                            List<Vote> v = [select Type from Vote where ParentId = :SITE_IDEAS_FEATURED and CreatedById = :UserInfo.getUserId()];
                            if (v.size()> 0) {
                                howUserVoted = v[0].Type;
                        } else {
                            howUserVoted = 'None';
                        }
                     }
                return howUserVoted;
                }
            set;
        }
}