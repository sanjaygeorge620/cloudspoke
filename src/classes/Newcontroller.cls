public class Newcontroller{
   public LX_Seed_Order_Request__c lxObj ; 
   public Newcontroller(ApexPages.StandardController controller) {
     
     lxObj = [SELECT Id,    LX_Bill_To_Name__c,
                            LX_Bill_To_Address__c,
                            LX_Bill_To_City__c,
                            LX_Bill_To_State_Province__c,
                            LX_Bill_To_Postal_Code__c,
                            LX_Bill_To_Country__c,
                            LX_Bill_To_Email_Address__c,
                            LX_Ship_To_Company_Name__c,
                            LX_Ship_To_Name__c,
                            LX_Ship_To_Address__c,
                            LX_Ship_To_City__c,
                            LX_Ship_To_State_Province__c,
                            LX_Ship_To_Postal_Code__c,
                            LX_Ship_To_Country__c,
                            LX_Demo_Type__c,
                            RecordType.Name,                                                      
                            LX_Form_Submitted__c from LX_Seed_Order_Request__c  where Id= :ApexPages.CurrentPage().getparameters().get('id')];                 
     
    }
   public PageReference dispObj() {
    try{
     If((lxObj.LX_Demo_Type__c == 'Standard Demo') &&(lxObj.LX_Bill_To_Name__c != Null) && (lxObj.LX_Bill_To_Address__c!= Null)&& (lxObj.LX_Bill_To_City__c!= Null)&& (lxObj.LX_Bill_To_State_Province__c!= Null)&& (lxObj.LX_Bill_To_Postal_Code__c!= Null)
&& (lxObj.LX_Bill_To_Country__c!= Null)&& (lxObj.LX_Bill_To_Email_Address__c!= Null)&& (lxObj.LX_Ship_To_Company_Name__c!= Null)&& (lxObj.LX_Ship_To_Name__c!= Null)&& (lxObj.LX_Ship_To_Address__c!= Null)
&& (lxObj.LX_Ship_To_City__c!= Null)&& (lxObj.LX_Ship_To_State_Province__c!= Null)&& (lxObj.LX_Ship_To_Postal_Code__c!= Null)&& (lxObj.LX_Ship_To_Country__c!= Null))
     {
     lxObj.LX_Form_Submitted__c = True;
    }
        update lxObj;
       }
    catch(DmlException ex){
        ApexPages.addMessages(ex);
       }

   return new PageReference ('/' + lxObj.Id);
}
}