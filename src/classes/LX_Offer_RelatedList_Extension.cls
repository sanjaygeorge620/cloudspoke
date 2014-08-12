public class LX_Offer_RelatedList_Extension {
    public list<LX_Program_Offer__c> OfferingList {set;get;}
    public Integer RowSize {set;get;}
    public string SelectedOfferingId {set;get;}
    public LX_Partner_Program__c  PP{set;get;}
    public boolean bShowButton{get;set;}
    public Boolean linkshowall{get;set;}
    
    public LX_Offer_RelatedList_Extension(ApexPages.StandardController controller) {
        bShowButton = true;          
        string row= ApexPages.currentPage().getParameters().get('rowsize');
        String linkhide = ApexPages.currentPage().getParameters().get('hideshowall'); //Added for US4399
              
        if(row==null)
            RowSize =5;
        else
            RowSize = Integer.valueof(row);
          
        PP = (LX_Partner_Program__c  )controller.getRecord();        
        OfferingList =[select id,LX_Country__c,Recordtype.Name,LX_Description__c,name, LX_End_Date__c, LX_Geo__c, LX_Offer__c,LX_Offer__r.name,LX_Offer_Status__c, LX_Start_Date__c from LX_Program_Offer__c where Recordtype.Name='Program Offers' and LX_Partner_Program__c =:PP.id];
        
        //Added for US4399
        if(linkhide == null)
        {
            if(offeringlist.size()>5)
              linkshowall = true;
            else
              linkshowall = false;   
        }     
        else if(linkhide == 'true')
            linkshowall = False; 
        
        //Query approval process status of current partner program record
        List<ProcessInstance> lstProcessInst = [select Status,TargetObjectId from ProcessInstance where TargetObjectId =: PP.Id and Status =: 'Pending'];
        if(lstProcessInst != null && lstProcessInst.size() > 0)
            bShowButton = false;
        
    }    
    
    public void DeleteOffer(){
        LX_Program_offer__c del = new LX_Program_offer__c  (id=SelectedOfferingId );
        try{
            if(del != null) //Adding null check as per the CRC review comments
            delete del;
        }
        catch(exception e ){}
    }
}