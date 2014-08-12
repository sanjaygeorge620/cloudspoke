global class LX_UpdateArticlesCls{

    /* Class Name   : LX_UpdateArticlesCls 
        * Description   : This is a utility class to increase the test coverage. 
        * Created By   : Charan Vuyyuru
        * Created Date : 13-08-2013
        * Modification Log:  
        * --------------------------------------------------------------------------------------------------------------------------------------
        * Developer                Date                 Modification ID        Description 
        * ---------------------------------------------------------------------------------------------------------------------------------------
        * Charan                13-08-2013                                Initial Version

        */
    
    
     /* Description : This method is being called from Java Interface to publish the articles in the salesforce.com
    *  Param - List<Id> KnowledgeArticleIds : Collection of knowledge article record ids. 
    *  Returns :  VOID
    */
    webservice static void publishArticles(List<Id> KnowledgeArticleIds){
        for(Id helpDocId:KnowledgeArticleIds){
            if(helpDocId != null){
                String articleId = string.valueof(helpdocID);
                system.debug('articleID: ' + articleId);
                KbManagement.PublishingService.publishArticle(articleId, true);
            }
        }

    }
    
    /* Description : This method is being called from Java Interface to Archiving the articles in the salesforce.com
    *  Param - List<Id> KnowledgeArticleIds : Collection of knowledge article record ids. 
    *  Returns :  VOID
    */
    webservice static void archiveArticles(List<Id> KnowledgeArticleIds){
        for(Id helpDocId:KnowledgeArticleIds){
            if(helpDocId != null){
                String articleId = string.valueof(helpdocID);
                system.debug('articleID: ' + articleId);
                KbManagement.PublishingService.archiveOnlineArticle(articleId, null);
            }
        }

    }

    /* Description : This method is being called from Java Interface to edit the published the articles in the salesforce.com
    *  Param - List<Id> KnowledgeArticleIds : Collection of knowledge article record ids. 
    *  Returns :  VOID
    */
    webservice static void unpublishArticles(List<Id> KnowledgeArticleIds){
         for(Id helpDocId:KnowledgeArticleIds){
            if(helpDocId != null){
                String articleId = string.valueof(helpdocID);
                system.debug('articleID: ' + articleId);
                KbManagement.PublishingService.editOnlineArticle(articleId, true);
            }
        }
    }
    
    /* Description : This method is being called from Java Interface to delete the archived articles in the salesforce.com
    *  Param - List<Id> KnowledgeArticleIds : Collection of knowledge article record ids. 
    *  Returns :  VOID
    */
    webservice static void deleteArchiveArticles(List<Id> KnowledgeArticleIds){
         for(Id helpDocId:KnowledgeArticleIds){
            if(helpDocId != null){
                String articleId = string.valueof(helpdocID);
                system.debug('articleID: ' + articleId);
                KbManagement.PublishingService.deleteArchivedArticle(articleId);
            }
        }
    }
    
    /* Description : This method is being called from Java Interface to delete the draft articles in the salesforce.com
    *  Param - List<Id> KnowledgeArticleIds : Collection of knowledge article record ids. 
    *  Returns :  VOID
    */
    webservice static void deleteDraftArticles(List<Id> KnowledgeArticleIds){
         for(Id helpDocId:KnowledgeArticleIds){
            if(helpDocId != null){
                String articleId = string.valueof(helpdocID);
                system.debug('articleID: ' + articleId);
                KbManagement.PublishingService.deleteDraftArticle(articleId);
            }
        }
    }

}