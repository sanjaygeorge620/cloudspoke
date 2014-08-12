public with sharing class SitesKnowledgeWidget {
    //https://developer.salesforce.com/docs/atlas.en-us.knowledge_dev.meta/knowledge_dev/knowledge_customize_searchpage_visualforce_04searchfilter.htm
    public string KB_KEYWORDSEARCH{get;set;}
    public string KB_CATEGORIES{get{If(KB_CATEGORIES==null) KB_CATEGORIES = 'ImageNow__c';return KB_CATEGORIES;}set;}
    
    public LIST<KnowledgeArticleVersion> getArticles(){
        List<KnowledgeArticleVersion> articleList = new List<KnowledgeArticleVersion>();
        if(KB_KEYWORDSEARCH!=null && KB_KEYWORDSEARCH.length()>2){
            string qryString = 'FIND \'' + KB_KEYWORDSEARCH + '*\'  RETURNING KnowledgeArticleVersion ';
                   qryString += ' (Id, Title,UrlName, tolabel(ArticleType),LastPublishedDate  WHERE language=\'en_US\' AND PublishStatus=\'online\')'; 
                   qryString += ' WITH DATA CATEGORY Product__c Below (AcuoInsight__c,ImageNow_eForms__c, Process_Design__c) limit 1000';
             List<List<SObject>>searchList = search.query(qryString);
             articleList = (List<KnowledgeArticleVersion>)searchList[0];
        }
    return articleList;
    
    }
    
    

}