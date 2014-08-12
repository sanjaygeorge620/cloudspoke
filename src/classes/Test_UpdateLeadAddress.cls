@isTest
private class Test_UpdateLeadAddress {
      static testMethod void testBulkInsert()
        {
        Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');  
         Campaign cCam = Data_Campaign.createCampaign('Child Campaign', pCam.id);
         
        List<lead> ld = new List<lead>();
        for(Integer i=0; i<200; i++)
        {
        
        ld.add( new lead (LastName='Test Contact',
                             firstName='TestFirst',
                             Status = 'Open' ,
                             Company ='Testing Company', 
                             Sector__c ='Cross Industry',
                             LX_Account_Owner__c = '005i0000000ZKUc',
                             Physical_Country__c = 'USA',
                             LX_PSW_Sales_Region__c = 'USA',
                             Lead_Type__c ='Expansion-Add On',
                             Email = 'test@lexmark.com',
                             Physical_Street_Address__c = 'test',
                             Physical_Street_Address_2__c = 'test',
                             Physical_City__c = 'test',
                             Physical_State__c = 'test',
                             Physical_Postal_Code__c = 'test',
                             LX_Country_Code__c = 'US',
                             LXK_Region__c = 'USA',
                             Region__c = 'North America',
                             Country = 'Test',
                             State = 'IL',
                            // Campaign = campaign,
                             Preferred_Language__c = 'English', 
                             LX_ISS_Coverage_Model__c = 'Channel', 
                             LX_ISS_Coverage_Method__c = 'Face To Face',
                             LX_Party_Group__c = 'Partner',
                             LX_Party_Role__c = 'Distributor',
                             LX_Party_Type__c = 'Pan-National', 
                             Street = '123 Street',
                             City = 'Bangalore',
                             phone = '1234567890',
                             
                             PostalCode = '560040'));
        }
        insert ld; 
                
        }
        
    static testMethod void Test_UpdateLeadAddress() {
         Campaign pCam = Data_Campaign.createCampaign('Parent Campaign', '');  
         Campaign cCam = Data_Campaign.createCampaign('Child Campaign', pCam.id);    
         Lead newLead = Data_Lead.createLeads(pCam.id);     
         System.assert(cCam.id != null);
         
        
        //update standard address fields
        
            newLead.Street = '12365 Street';
            newLead.City = 'TestingCity';
            newLead.State = 'Alabama';
            newLead.PostalCode = '12365';
            newLead.Country = 'USA';
                
        system.debug('lead:' + newLead);
        test.startTest();
        update newLead;
        newLead.Country = 'test1';
        update newLead;
        test.stopTest();
        
   //     system.AssertEquals('12365 Street',            [select Physical_Street_Address__c from Lead where id = :newLead.id].Physical_Street_Address__c);
            
    //    system.AssertEquals('TestingCity',            [select Physical_City__c from Lead where id = :newLead.id].Physical_City__c);

     //   system.AssertEquals('Alabama',            [select Physical_State__c from Lead where id = :newLead.id].Physical_State__c);
            
     //   system.AssertEquals('12365',            [select Physical_Postal_Code__c from Lead where id = :newLead.id].Physical_Postal_Code__c); 

     //   system.AssertEquals('UK',            [select Physical_Country__c from Lead where id = :newLead.id].Physical_Country__c);
        
                 
    }
}