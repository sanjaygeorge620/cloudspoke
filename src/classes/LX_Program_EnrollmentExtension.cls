public with sharing class LX_Program_EnrollmentExtension 
{

    public LX_Program_Enrollment__c ObjEnrollment{get; set;}    
    public String ProgramId{get;set;}
    public RecordType objRecordType{get;set;}
    private string  retUrl ;
    ApexPages.StandardController Tempcontroller;
    
    public LX_Program_EnrollmentExtension(ApexPages.StandardController controller) 
    {
        Tempcontroller=controller;
        ProgramId=System.currentPageReference().getParameters().get('programId');
        String  RecordId=System.currentPageReference().getParameters().get('id');
        retUrl = System.currentPageReference().getParameters().get('retURL');
        String strRecordTypeId = System.currentPageReference().getParameters().get('RecordType');
        if(strRecordTypeId != '' && strRecordTypeId != null){
            objRecordType = [select id,developername,name from recordtype where id =: strRecordTypeId];
        }
        
        
        
        ObjEnrollment=(LX_Program_Enrollment__c )controller.getRecord();
       
        if(RecordId==null && ProgramId!=''){
            ObjEnrollment.Master_Program__c = ProgramId;
        }
        
        ObjEnrollment.RecordTypeId = LX_SetRecordIDs.ISSPartnerEnrollment;      
        System.debug('============================ObjEnrollment='+ObjEnrollment);
        system.debug('>>>>>>>>>Azeer check<<<<<<<<<'+ObjEnrollment.Account_Owner__c);
    }
    
    public PageReference doredirect()
    {
        Schema.DescribeSObjectResult s = LX_Program_Enrollment__c.sObjectType.getDescribe();
        String strRecordTypeId = System.currentPageReference().getParameters().get('RecordType');
        if(strRecordTypeId == null) return null;
        
        Recordtype  objRecordType = [select id,developername,name from recordtype where id =: strRecordTypeId];
       
        if(objRecordType.developername ==Label.LX_ISS_Program_Enrollment) return null;
        
        PageReference redirectPage = new PageReference('/'+s.getKeyPrefix()+'/e?retURL=%2F'+s.getKeyPrefix()+'%2Fo&RecordType='+strRecordTypeId+'&nooverride=1'); 
        redirectPage.setRedirect(true);
        return redirectPage ;        
    }        
    
    public pagereference cancel(){
        Pagereference pg;
        if(programId != null && programId != ''){
            pg = new Pagereference ('/'+programId );
        }
        else if(retUrl != null && retUrl  != ''){
            pg = new Pagereference (retUrl );
        }
        return pg;      
    }
    
    public PageReference SaveNew()
    {
        if(ObjEnrollment.LX_Account__c!=null)
        {
            ObjEnrollment.RecordTypeId=LX_SetRecordIDs.ISSPartnerEnrollment;
            system.debug('**********before************'+ObjEnrollment);
            try{
            system.debug('>>>>>>>>>Azeer check<<<<<<<<<'+ObjEnrollment.Account_Owner__c);
            insert ObjEnrollment;
                Pagereference pg = new Pagereference ('/'+ObjEnrollment.id);
                return pg;
            }catch(Exception e){
                LX_CommonUtilities.createExceptionLog(e);
            }            
        }
        return null;
    }
    //Kapil(2/5/2014): Commenting as this method is no more used.    
    /*public boolean ValidationCheck(string AccountId,String PartnerProgramId)
    {
        boolean isValid=false;
        LX_Partner_Program__c ObjPartner;
        for(LX_Partner_Program__c TempObjPartner:[select id,LX_Party_Type__c,ISS_Capability_Segment__c,LX_GEO__c,LX_Region__c,LX_T_County__c,LX_Country__c,LX_T_Minimum_MPS_Capability_Score__c,LX_T_Minimum_Solution_Capability_Score__c from LX_Partner_Program__c where id=:PartnerProgramId])
        {
            ObjPartner=TempObjPartner;
        }

        String WhereFilter=' Name!=\'\' and Recordtype.Name=\'Location Partner\'';
        if(ObjPartner.LX_GEO__c!=null)
            WhereFilter+=' and LX_Geo__c=\''+ObjPartner.LX_GEO__c+'\'';
        if(ObjPartner.LX_Region__c!=null)
            WhereFilter+=' and LXK_Region__c=\''+ObjPartner.LX_Region__c+'\'';
        if(ObjPartner.LX_T_County__c!=null)
            WhereFilter+=' and BillingCountry=\''+ObjPartner.LX_T_County__c+'\'';
        if(ObjPartner.LX_T_Minimum_MPS_Capability_Score__c!=null)
            WhereFilter+=' and Partner_MPS_Capability_Score__c='+ObjPartner.LX_T_Minimum_MPS_Capability_Score__c;
        if(ObjPartner.LX_T_Minimum_Solution_Capability_Score__c!=null)
            WhereFilter+=' and Partner_ISS_Solutions_Capability_Score__c='+ObjPartner.LX_T_Minimum_Solution_Capability_Score__c;
        String soql = 'select  Partner_ISS_Capability_Segment__c,Name,Id,Industry,Party_Role__c,Party_Type__c,BillingCountry,BillingCity,owner.Name from account where id=\''+AccountId+'\' and ';

        soql = soql+WhereFilter;
        System.debug('================soql='+soql);
        if(!database.query(soql).IsEmpty())
        {
            isValid=true;
        }
        return isValid;
    }*/

}