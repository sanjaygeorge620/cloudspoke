public class LX_creditAppController {

private static final set<String> Logoset = new set<String>{'LX_Lexmark_Credit_Image_Lexmark','LX_Lexmark_Credit_Image_Special_Line','LX_Lexmark_Credit_Image_Normal_Line','LX_Lexmark_Credit_Image_Checkbox'};
public Case Cs {get;private set;}

public LX_creditAppController (){
    
  String CaseID = ApexPages.currentPage().getParameters().get('id') ;
  List<case> CaseList =[select id ,SuppliedCompany, LX_Company_Registration_Number__c,LX_Payment_Terms__c, LX_Trade_Name__c, LX_Account_Address__c, LX_Country__c, SuppliedEmail, SuppliedPhone, LX_D_U_N_S_Number__c, LX_Type_of_Business__c, LX_Total_Opportunity_Cost__c, LX_Highest_Month_Revenue__c, LX_Party_Role__c, LX_Party_type__c,  LX_MPS_Deal_Type__c, LX_Opportunity_Existing_Devices_Leased__c, LX_Opportunity_TCV__c, LX_Term__c, LX_Printer__c, LX_Options__c, LX_Supplies__c from Case where id=:CaseID  ]   ;
  if(CaseList!=null&& CaseList.size()>0){
      Cs = CaseList[0]; 
 //
   }
 }
public string getspacer() {
    return ' ';

}
public Map<String,String> MapDocmentURL{get{
    if(MapDocmentURL==null){
        MapDocmentURL = new Map<String,String>();
        string strOrgId = UserInfo.getOrganizationId();
         string strDocUrl = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+ '/servlet/servlet.ImageServer?id=<DocID>&oid=' + strOrgId;
         String replaceURL;
        List<Document> lstDocument = [Select Id,Name,developername,LastModifiedById from Document where developername IN :Logoset ];
        for(Document Doc: lstDocument ){
            replaceURL = strDocUrl.replace('<DocID>',Doc.id);
            MapDocmentURL.put(Doc.DeveloperName,replaceURL ); 
            system.debug('Map Value-->'+MapDocmentURL);   
        }
        
    }
    return MapDocmentURL;
}set;}

}