public with sharing class redirectToSimpleLead{

public pageReference redirectToSimpleLead(){
    String simpleRecordTypeId = Lead.sObjectType.getDescribe().getRecordTypeInfosByName().get('Simple').getRecordTypeId(); 
    PageReference pageRef = new PageReference('/00Q/e?retURL=%2F00Q%2Fo&RecordType=' + simpleRecordTypeId+'&ent=Lead');
    System.debug('**$$ /00Q/e?retURL=%2F00Q%2Fo&RecordType= '+simpleRecordTypeId+'&ent=Lead');
    pageRef.setRedirect(true);
    return pageRef;

    }

}