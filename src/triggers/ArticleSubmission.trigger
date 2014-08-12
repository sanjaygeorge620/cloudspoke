trigger ArticleSubmission on Article_Submission__c (before insert,before update) {
list<Support_Articles__kav> Supportarticletoinsert = new list<Support_Articles__kav>();
   
    if(trigger.isinsert) 
    {
        integer i=0;
        for(Article_Submission__c km:trigger.new) 
        {
            if(trigger.new[i].Status__c == 'Complete')
            {
                system.debug('km.Title__c@@@@@@@@'+km.Title__c);
                string url1= km.Title__c ;
                url1= url1.trim();
                url1= url1.replaceAll('(\\s+)','-');
                system.debug('url1@@@@@@@@'+url1);

                    Support_Articles__kav t = new Support_Articles__kav();
                    t.Article__c=km.Article__c;
                    t.Title=km.Title__c;
                    t.Resolution__c=km.Resolution__c;
                    t.UrlName = url1;

                    Supportarticletoinsert.add(t);              
            }
            i=i+1;

        }
        
        if(Supportarticletoinsert.size()>0)
            insert Supportarticletoinsert;
    }
    else if(trigger.isUpdate)
    {
        integer i=0;
        for(Article_Submission__c km:trigger.new) 
        {
            if(trigger.new[i].Status__c == 'Complete' && trigger.new[i].Status__c!=trigger.old[i].Status__c)
            {
                system.debug('km.Title__c@@@@@@@@'+km.Title__c);
             string url1= km.Title__c ;
                  url1= url1.trim();
                url1= url1.replaceAll('(\\s+)','-');
                system.debug('url1@@@@@@@@'+url1);
                Support_Articles__kav t = new Support_Articles__kav();
                    
                    t.Title=km.Title__c;
                    t.Article__c=km.Article__c;
                    t.Resolution__c=km.Resolution__c;
                    t.UrlName = url1;
                
                    Supportarticletoinsert.add(t);
              
            }
            i=i+1;
        }
        if(Supportarticletoinsert.size()>0)
            insert Supportarticletoinsert;
    }  
     
 }