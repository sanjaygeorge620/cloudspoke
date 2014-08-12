/*
 * Author: Steve Weiss - stevekweiss@gmail.com
 * Modified by: Srikanth Seela
 * 
 */
global with sharing class PostingReaper implements Schedulable {
    global void execute(SchedulableContext SC) {
        Integer e=expirePosts();
        while (e > 0) {
            e=expirePosts();
        }
   }
   
   private static Integer expirePosts() {
        Datetime n = Datetime.now();
        
        List<Posting__c> posts = [select id, createddate from Posting__c order by createddate LIMIT 100];
        set<Id> ids = new set<Id>();
        List<Posting__c> batch = new List<Posting__c>();
        for (Posting__c p : posts) {
            if (p.createddate.addDays(30) < n) {
                batch.add(p);
                ids.add(p.id);
            } else {
                break;
            }
        }
        delete(batch);
        
        batch= [select id from Posting__c where id in:ids];
        return batch.size();
        
        
   }

    public static void schedule() {
        PostingReaper r = new PostingReaper();
        String sch = '0 0 1 * * ?';
        system.schedule('CraigsForce Post Expiration Job', sch, r);
    }

    static testmethod void testExpirePosts() {
        PostingReaper.schedule();
        System.assertEquals(0, expirePosts());
        test.startTest();
            PostingReaper obj = new PostingReaper();
            string tym='00 12 1 * * ?';
            System.schedule('Job1',tym,obj);
        test.stoptest();
        
    }
}