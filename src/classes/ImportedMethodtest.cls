@isTest(seeAllData=true)
public class ImportedMethodtest{

    static testMethod void ImportedMethod() {
         String var = 'Please check the availability of atleast one PS demo product or Check the Bill to or Ship to if Demotype is equal to standard demo';
         system.assertequals(var, 'Please check the availability of atleast one PS demo product or Check the Bill to or Ship to if Demotype is equal to standard demo');       
        Opportunity opp = new Opportunity();
        Account acc = new Account();
               
        LX_Seed_Order_Request__c lxe = new LX_Seed_Order_Request__c();    
        lxe.LX_Opportunity__c = opp.id;
        lxe.LX_Account__c = acc.id; 
        lxe.LX_Monitor_Type__c = 'WACCOM'; 
        lxe.LX_Bill_To_Address__c = 'test';
        lxe.LX_Form_Submitted__c = FALSE;
        lxe.LX_Bill_To_City__c = 'test';
        lxe.LX_Bill_To_State_Province__c = 'test';
        lxe.LX_Bill_To_Postal_Code__c = 'test';
        lxe.LX_Bill_To_Country__c = 'test';
        lxe.LX_Demo_Type__c = 'Standard Demo';
        lxe.LX_Ship_To_City__c = 'test';
        lxe.LX_Ship_To_Address__c = 'test';
        lxe.LX_Ship_To_Postal_Code__c = 'test';
        lxe.LX_Ship_To_State_Province__c = '';
        lxe.LX_Ship_To_Country__c = 'test';
      //  lxe.Evaluation_Products__r =  ; 
        insert lxe;
      Importedclass.ImportedMethod(lxe.id);
         if((lxe.Evaluation_Products__r.size() > 0 && lxe.LX_Ship_To_State_Province__c != null && lxe.LX_Ship_To_City__c != null && lxe.LX_Ship_To_Postal_Code__c != null && lxe.LX_Bill_To_Address__c != null && lxe.LX_Bill_To_City__c != null && lxe.LX_Bill_To_State_Province__c != null && lxe.LX_Bill_To_Postal_Code__c != null && lxe.LX_Bill_To_Country__c != null &&  lxe.LX_Ship_To_Address__c != null && lxe.LX_Ship_To_Country__c != null && lxe.LX_Demo_Type__c == 'Standard Demo')||(lxe.Evaluation_Products__r.size() > 0 && lxe.LX_Demo_Type__c != 'Standard Demo')) {            
                lxe.LX_Form_Submitted__c  = true;
                update lxe;
               for(LX_Evaluation_Product__c evalProduct :  lxe.Evaluation_Products__r)
                Importedclass.approvalProcessRequest(evalProduct.id);                                 
            }      
    Importedclass.approvalProcessRequest(lxe.id);
    }
    }