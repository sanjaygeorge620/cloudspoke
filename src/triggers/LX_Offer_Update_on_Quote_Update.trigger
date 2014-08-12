/* Trigger Name  : LX_Offer_Update_on_Quote_Update
 * Description   : This trigger is used to populate the quote data on Offer object when the quote is created or updated. 
 * Created By    : Amit Sinha(Deloitte)
 * Created Date  : 1/29/2014
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date          Modification ID       Description 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Amit Sinha          01-29-2014     Initial Version
 * Sumedha Kucherlapati    02-04-2014     1001                Modified line no 29 to include logic differently for insert and update
 */


trigger LX_Offer_Update_on_Quote_Update on BigMachines__Quote__c (After Insert, After Update) 
{

//Added ByPass Logic
if(LX_CommonUtilities.ByPassBusinessRule()) return;

Set <ID> setquotes = new Set <ID>();
Set <ID> setapprquotes = new Set <ID>();//added by Sandeep for US3897
Set <ID> setoffers = new Set <ID>();
Set <ID> setapproffers = new Set <ID>(); //added by Sandeep for US3897
List<BigMachines__Quote__c> lstquotes = New List<BigMachines__Quote__c>();
List<LX_offer__c> tempOffLst = new List<LX_offer__c>(); //added by Abhishek
List<LX_offer__c> apprOffLst = new List<LX_offer__c>(); //added by Sandeep for US3897
    if ((Trigger.isAfter && Trigger.isInsert)||(Trigger.isAfter && Trigger.isUpdate))
    {
        for (BigMachines__Quote__c updatedquotes:Trigger.New)
        {
          //  if(Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c == 'Finalized' && Trigger.oldMap.get(updatedquotes.ID).BigMachines__Status__c != Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c )
            if(((Trigger.isInsert && Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c == 'Finalized')
                || (Trigger.isUpdate && Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c == 'Finalized' && Trigger.oldMap.get(updatedquotes.ID).BigMachines__Status__c != Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c ))
		//Sandeep added for US3897		
                ||((Trigger.isInsert && Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c == 'Approved')
                || (Trigger.isUpdate && Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c == 'Approved' && Trigger.oldMap.get(updatedquotes.ID).BigMachines__Status__c != Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c )))
         //Sandeep added for US3897   
            {
              //if((Trigger.newMap.get(updatedquotes.ID).Expiration_Date__c != Trigger.oldMap.get(updatedquotes.ID).Expiration_Date__c) || (Trigger.newMap.get(updatedquotes.ID).Vistex_Backend_Rebate__c !=  Trigger.oldMap.get(updatedquotes.ID).Vistex_Backend_Rebate__c) || (Trigger.newMap.get(updatedquotes.ID).Revision_Number__c  !=  Trigger.oldMap.get(updatedquotes.ID).Revision_Number__c) || (Trigger.newMap.get(updatedquotes.ID).Quote_Control_Number__c != Trigger.oldMap.get(updatedquotes.ID).Quote_Control_Number__c))   
                {
                    setquotes.add(updatedquotes.ID);  
                    lstquotes.add(updatedquotes);
                }
            }
            //System.debug('checking if condition before Offeremail call in Trigger Offer update on quote update');
           // System.debug('Quote  ID =');
           // System.debug(updatedquotes.ID);
           // System.debug('Quote Status =');
            //System.debug(Trigger.oldMap.get(updatedquotes.ID).BigMachines__Status__c);
            //System.debug(Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c);
		  //Sandeep added for US3902
            if (Trigger.isUpdate && Trigger.newMap.get(updatedquotes.ID).BigMachines__Status__c == 'Approved' && 
                ((Trigger.oldMap.get(updatedquotes.ID).BigMachines__Status__c == 'Pending')||(Trigger.oldMap.get(updatedquotes.ID).BigMachines__Status__c == 'Revision Pending')))
            {
              System.debug('Inside Offeremail call in Trigger Offer update on quote update');
              Lx_offerEmail.OfferQuoteEmail(updatedquotes.Offer__c);
            }
          //US3902        
        }
    }
    
    if(setquotes.size()> 0)
    {    
        for(BigMachines__Quote__c updatedquote:[Select ID, BigMachines__Status__c, Offer__c from BigMachines__Quote__c where ID IN:setquotes])
        {    
            If((updatedquote.BigMachines__Status__c == 'Approved') || (updatedquote.BigMachines__Status__c == 'Finalized'))//Sandeep added for US3897
            {
                setapproffers.add(updatedquote.Offer__c);//Sandeep added for US3897
            }
            If(updatedquote.BigMachines__Status__c == 'Finalized')
            {
                setoffers.add(updatedquote.Offer__c);
            }
                
        }
    }
     
    if(setoffers.size() > 0)
    {
        for(LX_Offer__c offers:[Select ID, Control_Number__c, Vistex_Backend_Rebate__c, Expiration_Date__c, Revision_Number__c  from LX_Offer__c where ID IN:setoffers])
        {
            for(BigMachines__Quote__c finalizedquotes:lstquotes)
            {
            /* commented by Abhishek
            finalizedquotes.Revision_Number__c = offers.Revision_Number__c;
            finalizedquotes.Vistex_Backend_Rebate__c = offers.Vistex_Backend_Rebate__c;
            finalizedquotes.Expiration_Date__c = offers.Expiration_Date__c;
            finalizedquotes.Quote_Control_Number__c = offers.Control_Number__c;
            */
            offers.Revision_Number__c = finalizedquotes.Revision_Number__c;
            offers.Vistex_Backend_Rebate__c = finalizedquotes.Vistex_Backend_Rebate__c;
            offers.Expiration_Date__c = finalizedquotes.Expiration_Date__c;
            offers.Control_Number__c = finalizedquotes.Quote_Control_Number__c ;
            //offers.Lx_offerquote_approved_flag__c = FALSE;	//added by Sandeep US3897
            tempOffLst.add(offers); // added by Abhishek
            
            }
        }
        
        update tempOffLst;
    }
  //added by Sandeep US3897  
    if(setapproffers.size() > 0)
    {
        for(LX_Offer__c offers:[Select ID, Lx_offerquote_approved_flag__c from LX_Offer__c where ID IN:setapproffers])
        {
            offers.Lx_offerquote_approved_flag__c = TRUE;	 
            apprOffLst.add(offers);  
        }
        
        update apprOffLst;
    }
}