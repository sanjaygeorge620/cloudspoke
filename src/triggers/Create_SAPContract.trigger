trigger Create_SAPContract on Opportunity (after update) {


/*  When opportunity  Contract_Number__c is set,
        Create SAP Contract
*/
         
         List<SAP_Contract__c> NewContracts = new List<SAP_Contract__c>();
         system.debug('FirstRun: ' + FirstRun_Create_SAPContract.FirstRun);
         system.debug('before trigger loop:');
         for(Opportunity OppRecord : Trigger.new) {        //go through each record pull back\
         
                if (Trigger.oldMap.get(OppRecord.id).Contract_Number__c == null 
                                && OppRecord.Contract_Number__c != null 
                                && FirstRun_Create_SAPContract.FirstRun){
                    SAP_Contract__c contractRec = new SAP_Contract__c();
                    contractRec.Account__c = OppRecord.accountID;
                    contractRec.Opportunity__c = OppRecord.id;
                    contractRec.Contract_Number__c = OppRecord.Contract_Number__c;
                    
                    system.debug('contractRec: ' + contractRec);
                    FirstRun_Create_SAPContract.FirstRun = False;
                    NewContracts.add(contractRec);   
                }
         // }
        }
        system.debug('NewSAPContracts' + NewContracts);
        insert   NewContracts;
  //   }
}