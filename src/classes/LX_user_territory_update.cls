/* 
* ©Lexmark Front Office 2013, all rights reserved
* 
* Created Date : 07/26/2013
*
* Author : Maruthi Kolla.
* 
* Description : Utility Class referred in 'LX_user_batch' .
*
* Maruthi Kolla: 05/23/2014: Updated to calculate 'MPS' and 'Number of lexmark verticals' on user record. 
* Sanjay Chaudhary: 06/09/2014: Updated as per US3787 to update Partner STT Calculation to be based 'Partner ISS Capability Segment' on instead of 'ISS Internal Segment' 
* Sanjay Chaudhary: 06/09/2014: Updated as per US3940 to Update STT criteria for Enterprise and Include new STT for Channel. 
*/

Public Class LX_user_territory_update
{
    // Method to calculate the 'Sales Territory type' , 'MPS' and 'Number of lexmark verticals' on user record
    Public static void update_Terr(User US1, Set<String> acc_type, Set<String> acc_int_seg,Set<String> acc_MPS_qual,Set<String> acc_local_pri,Set<String> acc_tr_Status, Set<String> acc_iss_coverage,Set<String> lex_verticals)
    {
        Boolean Flag1 = False ;
        
        // Logic to calculate the 'Sales Territory type' on User
        if(acc_type.contains('Partner') && acc_type.contains('Customer'))
        {
                US1.LX_Sales_Territory_Type__c = 'Mixed';
                Flag1 = true;
                           
        }
            
        Else if(acc_type.contains('Partner') && (acc_type.size() ==1))
        {
             if(acc_int_seg.size() == 1 && acc_int_seg.contains('Copier Dealer'))
            {
                US1.LX_Sales_Territory_Type__c = 'Copier Dealer';
                Flag1 = true;
            }
            
             else if(acc_int_seg.size() == 1 && acc_int_seg.contains('Progressive Reseller'))
            {
                US1.LX_Sales_Territory_Type__c = 'Progressive Reseller';
                Flag1 = true;
            }
            
             else if(acc_int_seg.size() == 1 && acc_int_seg.contains('Distributor'))
            {
                US1.LX_Sales_Territory_Type__c = 'Distributor';
                Flag1 = true;
            }
            
             else if(acc_int_seg.size() == 1 && acc_int_seg.contains('Traditional Reseller'))
            {
                US1.LX_Sales_Territory_Type__c = 'Traditional Reseller';
                Flag1 = true;
            }
            
            else if (acc_int_seg.size() == 2 && (acc_int_seg.contains('Progressive Reseller') && acc_int_seg.contains('Copier Dealer')))
            {
                US1.LX_Sales_Territory_Type__c = 'Mixed CD/Progressive Reseller';
                 Flag1 = true;            
            } 
            
            else if (acc_int_seg.size() == 2 && (acc_int_seg.contains('Traditional Reseller') && acc_int_seg.contains('Distributor')))
            {
                US1.LX_Sales_Territory_Type__c = 'Traditional Reseller/Distributor';
                 Flag1 = true;            
            } 
                        
            else if (acc_int_seg.size() >1 && (acc_int_seg.contains('Traditional Reseller') || acc_int_seg.contains('Distributor') || acc_int_seg.contains('Progressive Reseller') || acc_int_seg.contains('Copier Dealer')))
            {
                US1.LX_Sales_Territory_Type__c = 'Mixed Channel';
                 Flag1 = true;            
            } 
        }
        
        Else if(acc_type.contains('Customer') && (acc_type.size() ==1))
        {
                if(acc_MPS_qual.size() == 1 && acc_MPS_qual.contains('MPS') && acc_local_pri.size()>0)
                {
                    US1.LX_Sales_Territory_Type__c = 'Services (DFM)';
                    Flag1 = true;
                }
                               
                
                else if((acc_MPS_qual.contains('MPS') || acc_MPS_qual.contains('Non MPS')) && ((acc_local_pri.contains('Target-1') || acc_local_pri.contains('Target-2') || acc_local_pri.contains('Target-3')) || (acc_local_pri.contains('Key-1') || acc_local_pri.contains('Key-2'))))
                {
                
                    if(acc_MPS_qual.size() == 1 && acc_MPS_qual.contains('Non MPS') && (acc_local_pri.contains('Key-1') || acc_local_pri.contains('Key-2')) && !(acc_local_pri.contains('Target-1') || acc_local_pri.contains('Target-2') || acc_local_pri.contains('Target-3')) )
                    {
                        US1.LX_Sales_Territory_Type__c = 'Farmer (Key)';
                        Flag1 = true;
                    }
                    
                    else if(acc_MPS_qual.size() == 1 && acc_MPS_qual.contains('Non MPS') && (acc_local_pri.contains('Target-1') || acc_local_pri.contains('Target-2') || acc_local_pri.contains('Target-3')) && !(acc_local_pri.contains('Key-1') || acc_local_pri.contains('Key-2')))
                    {
                        US1.LX_Sales_Territory_Type__c = 'Hunter (Target)';
                        Flag1 = true;
                    }
                    
                    else{
                    US1.LX_Sales_Territory_Type__c = 'Mixed Enterprise';
                    Flag1 = true;
                    }
                } 
                
                           
        }
        
        // Logic to calculate the MPS field on USer
        if(acc_MPS_qual.contains('MPS'))
            US1.LX_MPS__c = true;
        else
            US1.LX_MPS__c = false;
            
        // Logic to calculate 'No of lexmark verticals' on user
        if(lex_verticals.contains('National Government') && lex_verticals.contains('State & Local Government')) {

            if((lex_verticals.size()-1) >= 4) {

                us1.LX_Number_of_Lexmak_Verticals__c = '4+';
            }
            else {

                us1.LX_Number_of_Lexmak_Verticals__c = string.valueOf(lex_verticals.size()-1);
            }
        }
        else {
            if((lex_verticals.size()) >= 4) {

                us1.LX_Number_of_Lexmak_Verticals__c = '4+';
            }
            else {

                us1.LX_Number_of_Lexmak_Verticals__c = string.valueOf(lex_verticals.size());
            }
        }
        
        if (flag1==false)
        {
            US1.LX_Sales_Territory_Type__c = '';
            Flag1 = true;
        }
    
        // Logic for updating the user    
        if (flag1 == true && ((US1.LX_Ability_to_Create_Accounts__c == 'Yes') || (US1.LX_Ability_to_Create_Accounts__c == 'No')) )
        {
            try
            {
            Update US1;
            }
        
            catch(Exception ex)
            {
                LX_CommonUtilities.createExceptionLog(ex); // Catching the exception and creating an exception log record.
            }
        }
    }
}