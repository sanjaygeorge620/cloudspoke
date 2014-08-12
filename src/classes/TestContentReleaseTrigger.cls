/**********************************************************************************************
Name : TestContentReleaseTrigger 
Purpose : gives test coverage for UpdateCSA
author : Mike Fitzgerald
Date : September 2010
************************************************************************************************/
@isTest
Private class TestContentReleaseTrigger {
    @isTest
    static void TestContentReleaseTrigger() {
        
        //Querying a record from Product Config due to all of the changes pending for the SAP Project.
        //may need to fix this at a later point.
        Product_Configuration__c pc = new Product_Configuration__c();
        pc.Name='testProdConfig';
        insert pc;
        //[Select id from Product_Configuration__c limit 1];
        
        //Can't create a workspace so Query the One I need
        //ContentWorkspace cw = [Select id from ContentWorkspace where name like 'Product | Downloads' limit 1];
        
        //Querying the Recordtype I need
        Recordtype rt = [Select id from Recordtype where name='Download' and sObjectType='ContentVersion' limit 1];
        
        
        //Create initial ContentVersion
        ContentVersion cv1 = new ContentVersion();
            cv1.versionData =  Blob.valueOf('Test Document');
            cv1.title = 'Version 1';
            cv1.description = 'Document 1 Description';
            cv1.pathOnClient ='/foo.txt';
            cv1.recordtypeid = rt.id;
        insert cv1;
        
        system.debug(cv1);
        
        //Query back the ContentDocID
        ContentVersion cv2 = [select id,VersionNumber, ContentDocumentId from contentversion where id =:cv1.id];
        
        //Publishing to Workspace I want (ContentWorkspaceDoc)
        //ContentWorkspaceDoc cwd = new ContentWorkspaceDoc();
        //cwd.ContentWorkspaceId = cw.id; /*Workspace*/
       // cwd.ContentDocumentId = cv2.ContentDocumentId; /*queried ContentDocumentId*/
        //insert cwd;
        
        
        //Update the doc after it's published
        //cv2.ProductName__c = pc.id;
        //update cv2;
        
        
        
        //Create 2nd version
        ContentVersion cv3 = new ContentVersion();
            cv3.versionData =  Blob.valueOf('New Test Document');
            cv3.title = 'Version 2';
            cv3.description = 'Document 2 Description';
            cv3.pathOnClient ='/foo2.txt';
            cv3.ContentDocumentId = cv2.ContentDocumentId;
            cv3.ReasonForChange = 'Because I can';
        insert cv3;
        
        
        
        //Tests
        system.debug('cv1.title: '+cv1.title);
        system.assertequals(cv1.title, 'Version 1');
        system.assertequals(cv3.title, 'Version 2');
        
        ContentVersion v1 = [select id, VersionNumber, ContentDocumentId from contentversion where id =:cv1.id];
        system.debug('v1.VersionNumber: '+v1.VersionNumber);
        system.assertequals(v1.VersionNumber, '1'); /*1st version*/
        
        ContentVersion v2 = [select id, VersionNumber, ContentDocumentId from contentversion where id =:cv3.id];
        system.debug('v2.VersionNumber: '+v2.VersionNumber);
        system.assertequals(v2.VersionNumber, '2'); /*2nd version*/
        }
        
}