trigger LX_BI_BU_Quote_Status_Check on LX_Offer__c (Before Insert, Before Update) {

//Kapil: Added ByPass Logic on 1/29/2014
if(LX_CommonUtilities.ByPassBusinessRule()) return;

Set <ID> setofferid = new Set <ID>();
Set <ID> setpricelistoffers = new Set <ID>();
Set <ID> setpricelistoffersnotnullpl = new Set <ID>();
Set <ID> setapprovedpricelistoffers = new Set <ID>();
Set <ID> setapprovedoffers = new Set <ID>();
public boolean softwarepricebookoffer{get;set;} 


if (Trigger.isBefore && Trigger.isUpdate)
{
    	softwarepricebookoffer = False;
        for (LX_Offer__c updatedoffers:Trigger.New)
        {
        if (updatedoffers.LX_Offer_Status__c == 'Active' && updatedoffers.LX_Offer_Type__c != 'Pricelist Offer' && Trigger.oldMap.get(updatedoffers.ID).LX_Offer_Status__c != Trigger.newMap.get(updatedoffers.ID).LX_Offer_Status__c )
        setofferid.add(updatedoffers.ID);    
        
        if(updatedoffers.LX_Offer_Type__c == 'Pricelist Offer' && updatedoffers.LX_Offer_Status__c == 'Active' && Trigger.oldMap.get(updatedoffers.ID).LX_Offer_Status__c != Trigger.newMap.get(updatedoffers.ID).LX_Offer_Status__c)
        setpricelistoffers.add(updatedoffers.ID);
            
        if(updatedoffers.LX_Offer_Type__c == 'Software Pricebook' && updatedoffers.LX_Offer_Status__c == 'Active' && Trigger.oldMap.get(updatedoffers.ID).LX_Offer_Status__c != Trigger.newMap.get(updatedoffers.ID).LX_Offer_Status__c)
        softwarepricebookoffer = True;
        }
    
    system.Debug('setofferid==='+setofferid);
    system.Debug('setpricelistoffers==='+setpricelistoffers);
    
 if(!softwarepricebookoffer)
 {  
	if(setofferid.size()> 0)
    {
        for(BigMachines__Quote__c approvedrelatedquote:[Select ID, BigMachines__Status__c, Offer__c from BigMachines__Quote__c where Offer__c IN:setofferid AND BigMachines__Status__c IN ('Approved','Finalized')])
        {
            setapprovedoffers.add(approvedrelatedquote.Offer__c);
        }
        system.Debug('setapprovedoffers=='+setapprovedoffers);
        
        for(LX_Offer__c unapprovedoffers: [Select Id, Name,LX_Offer_Status__c from LX_Offer__c where ID IN:setofferid AND ID NOT IN:setapprovedoffers])
        {
            Trigger.Newmap.get(unapprovedoffers.Id).adderror('You cannot update the status of the Offer until the related Quote is Approved');
        }
               
    }
    
	if(setpricelistoffers.size()> 0)
    {
       //Map<Id,LX_Offer__c> MapPricelistoffersnotnullpl = new Map<Id,LX_Offer__c>( [select ID,ERP_Pricelist__c from LX_Offer__c where ERP_Pricelist__c != NULL AND Id IN:setpricelistoffers ]);
       Map<Id,LX_Offer__c> MapPricelistoffersnotnullpl = new Map<Id,LX_Offer__c>( [select ID from LX_Offer__c where Id IN:setpricelistoffers ]);
        setpricelistoffersnotnullpl = MapPricelistoffersnotnullpl.keySet();
      
        if(setpricelistoffersnotnullpl.size()>0)
        {
            for(BigMachines__Quote__c approvedrelatedquotepl:[Select ID, BigMachines__Status__c, Offer__c from BigMachines__Quote__c where Offer__c IN:setpricelistoffersnotnullpl AND BigMachines__Status__c IN ('Approved','Finalized')])
            {
                setapprovedpricelistoffers.add(approvedrelatedquotepl.Offer__c);
            }
            system.Debug('setapprovedpricelistoffers==='+setapprovedpricelistoffers);
        }
        
        for(LX_Offer__c unapprovedofferspl: [Select Id, Name,LX_Offer_Status__c from LX_Offer__c where ID IN:setpricelistoffers AND ID NOT IN:setapprovedpricelistoffers])
        {
            //Trigger.Newmap.get(unapprovedofferspl.Id).adderror('You cannot update the status of the pricelist Offer until the related Quote is Approved and the ERP Pricelist is populated.');
            Trigger.Newmap.get(unapprovedofferspl.Id).adderror('You cannot update the status of the pricelist Offer until the related Quote is Approved.');
        }
        
    }
 }  
}    

if (Trigger.isBefore && Trigger.isInsert)
{
    system.debug('Triggernew=='+Trigger.New);
    system.debug('Triggernew ID=='+Trigger.New[0].Id);
    system.debug('Triggernew Val=='+Trigger.New[0].LX_Offer_Status__c);
        
    for (LX_Offer__c updatedoffers:Trigger.New)
    {
        if(updatedoffers.LX_Offer_Status__c == 'Active')
        {
            updatedoffers.addError('You cannot create a new offer with an Active Status, please change the status of the offer');
        }
    }
       
}


}