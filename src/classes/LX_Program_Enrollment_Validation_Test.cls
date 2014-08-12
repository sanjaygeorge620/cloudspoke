@isTest(seeAllData=true)
private class LX_Program_Enrollment_Validation_Test{
    
    public static testmethod void m1(){
        RecordType rec = [Select id from RecordType where name='Local ISS Program' and sobjectType='LX_Partner_Program__c'];
        RecordType perec = [Select id from RecordType where name='ISS Program Enrollment' and sobjectType='LX_Program_Enrollment__c'];
        LX_Partner_Program__c pgm = new LX_Partner_Program__c();
        pgm.Name='test pgm';
        pgm.recordtypeId = rec.Id;
        pgm.Program_Level__c='Level2';
        insert pgm;
    
        LX_Program_Enrollment__c pe = new LX_Program_Enrollment__c();
        pe.Master_Program__c = pgm.Id;
        pe.recordtypeid = perec.id ;
        insert pe;
    
    }


}