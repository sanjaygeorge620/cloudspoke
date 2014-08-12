/**
 * ©Lexmark Front Office 2014, all rights reserved
 * 
 * Created Date : 07-11-2014
 *
 * Author : Sneha Kashyap  
 * 
 * Description : Logic to Auto Populate Address based on Customer Account's Address
**/ 

trigger LX_UpdateAddressBIBU on LX_Serial_Number_Sales_Order__c (before insert, before update) {
    //check if the checkbox is checked, find the account type, partner or customer -- copy the values
    
   List<Id> custAccIdList = new List<Id>();
   for(LX_Serial_Number_Sales_Order__c  salesNum : Trigger.New){
       custAccIdList.add(salesNum.LX_Customer_Account__c);
   }
   
   
   Map<id,Account> custAccMap = new Map<id,Account>([Select ShippingState,ShippingPostalCode,ShippingCountry,ShippingCity,BillingCity, BillingState, BillingCountry, BillingPostalCode, Billing_Country_Code__c from Account where Id in :custAccIdList]);
   for(LX_Serial_Number_Sales_Order__c  salesNum : Trigger.New){
       if(salesNum.LX_Address_Same_as_Account_BillTo__c){
           //Copy the address from Customer account
            if(salesNum.LX_Customer_Account__c == null){
                 salesNum.LX_Address_Same_as_Account_BillTo__c.addError('Please select a customer account to copy the address');
            }
              
               salesNum.LX_Bill_To_City__c = custAccMap.get(salesNum.LX_Customer_Account__c).BillingCity;
               salesNum.LX_Bill_To_Country__c = custAccMap.get(salesNum.LX_Customer_Account__c).BillingCountry;
               salesNum.LX_Bill_To_Postal_Code__c = custAccMap.get(salesNum.LX_Customer_Account__c).BillingPostalCode;
               salesNum.LX_Bill_To_State_Province__c = custAccMap.get(salesNum.LX_Customer_Account__c).BillingState;
          
       }
       
       if(salesNum.LX_Address_Same_as_Account_ShipTo__c){
           //Copy the address from Customer account
            if(salesNum.LX_Customer_Account__c == null){
                 salesNum.LX_Address_Same_as_Account_ShipTo__c.addError('Please select a customer account to copy the address');
            }
           salesNum.LX_Ship_To_City__c = custAccMap.get(salesNum.LX_Customer_Account__c).BillingCity;
           salesNum.LX_Ship_To_Country__c = custAccMap.get(salesNum.LX_Customer_Account__c).BillingCountry;
           salesNum.LX_Ship_To_Postal_Code__c = custAccMap.get(salesNum.LX_Customer_Account__c).BillingPostalCode;
           salesNum.LX_Ship_To_State_Province__c = custAccMap.get(salesNum.LX_Customer_Account__c).BillingState;
          
       }
   
   }
    
    
    

}