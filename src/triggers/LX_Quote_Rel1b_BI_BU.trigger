/* Trigger Name  : LX_Quote_Rel1b_BI_BU 
 * Description   : This trigger is used to create Quote Party records when the partner string is not null
 * Created By    : Veenu Trehan(Deloitte)
 * Created Date  : 9/18/2013
 * Modification Log: 
 * --------------------------------------------------------------------------------------------------------------------------------------
 * Developer            Date       Modification ID       Description 
 * ---------------------------------------------------------------------------------------------------------------------------------------
 * Veenu Trehan      9/18/2013                       Initial Version
 
 */
trigger LX_Quote_Rel1b_BI_BU on BigMachines__Quote__c (after insert,after update) {
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [gajanan 07-Oct-13] : Added Bypass code   
    system.debug('>>>>>>>>>>>>>>>>>>>>>Inside the trigger - LX_Quote_Rel1b_BI_BU >>>>>>>>>>>');
    public static string RecordBreak='@#@';
    public static string FieldBreak='$#$';
    public static string rep='@@@';
    map<id,list<string>> QuoteList = new map<id,list<string>>();
    map<id,list<string>> QuotePartyList = new map<id,list<string>>();
    // Variable used to store the field and corresponding value
    map<String,String> QuoteStringMapping = new map<String,String>();
    //list of Quote Party records to insert
    list<LX_Quote_Party__c> QuotePartyRecList=new list<LX_Quote_Party__c>();
    //New quote Party record
     LX_Quote_Party__c QuotePartyRec;
    List<LX_Quote_Party__c> QuotePartyDelList=new list<LX_Quote_Party__c>();
    set <id> QuoteSetDel=new set <id>();
    if(trigger.IsUpdate||trigger.isInsert){
        for(BigMachines__Quote__c Quote1:trigger.new){
            //condition to check if Partner_Information_String__c is not null or is not the same as its previous value
            if((trigger.isInsert && Quote1.Partner_Information_String__c!=null)||((trigger.isUpdate) && (Quote1.Partner_Information_String__c!=trigger.OldMap.get(Quote1.id).Partner_Information_String__c))){
               
                if(trigger.IsUpdate){
                    //VT 9/25:dd quote Id's to set to later retrive Quote Party records with lookups to the set records
                    system.debug('***********');
                    QuoteSetDel.add(Quote1.id);
                }
                //list of strings to store multiple records delimited by '@#@'
                list<string> PartnerString=new list<string>();
                string PartnerStringfrm=Quote1.Partner_Information_String__c;
                if(PartnerStringfrm!=null){
                    //PartnerString=Quote1.test__c.split(RecordBreak);
                    PartnerString=PartnerStringfrm.split(RecordBreak);
                    system.debug('PartnerString------>'+PartnerString);
                    //iterates over each record string to add the values to each field
                    for(string PString : PartnerString){
                        //initializes a new Quote Party Reocrd
                        QuotePartyRec=new LX_Quote_Party__c();
                        //list of values for each field of the Quote Party record
                        list <String> QuotePString=new list<string>();
                        //list of string delimited by '$#$'
                        System.debug('PString----->'+PString);
                        PString=PString.replace(FieldBreak,rep);
                        system.debug('QPString----->'+PString);
                        QuotePString=PString.split(rep);
                        system.debug('QuotePString------>'+QuotePString);
                        //for loop to get the api name of the field through the custom setting and put the value of the field in the record
                         for(integer n=0;n<QuotePString.size()/2;n++){
                            //system.debug('LX_Quote_PartyString__c.getAll()-->'+LX_Quote_PartyString__c.getAll());
                           // system.debug('QuotePString[2*n]-->'+QuotePString[2*n]);
                          // system.debug('LX_Quote_PartyString__c.getinstance------>'+ LX_Quote_PartyString__c.getAll().get(QuotePString[2*n]).LX_Field__c);
                           if(QuotePString[2*n]!=null && LX_Quote_PartyString__c.getAll()!=null){
                                if(LX_Quote_PartyString__c.getAll().get(QuotePString[2*n]).LX_Field__c!=null){
                                    QuotePartyRec.put(LX_Quote_PartyString__c.getAll().get(QuotePString[2*n]).LX_Field__c,QuotePString[(2*n)+1]);
                               
                                }
                           }
                        }   
                          //to add the Quote record to the quote lookup on Quote Party
                            QuotePartyRec.put('LX_Quote__c',Quote1.Id);
                            system.debug('QuotePartyRec------->'+QuotePartyRec);
                            
                            
                            //add the record to the quote party list to be updated
                         QuotePartyRecList.add(QuotePartyRec);      
                         system.debug('QuotePartyRecList--->'+QuotePartyRecList);
                            
                                  
                        }
             }
                     
            }
        }
        
        //VT 9/25 Added to delete all the old Quote Party Records
        system.debug('QuoteSetDel--->'+QuoteSetDel.size()+'#####'+QuoteSetDel);
        if(QuoteSetDel.size()>0){
        QuotePartyDelList=[SELECT id,name 
                           FROM LX_Quote_Party__c 
                           WHERE LX_Quote__c IN :QuoteSetDel];
         system.debug('-->'+QuotePartyDelList);
         if(QuotePartyDelList!=null){
                     Delete [SELECT id,name 
                           FROM LX_Quote_Party__c 
                           WHERE LX_Quote__c IN :QuoteSetDel]; 
         } 
        }                  
        system.debug('QuotePartyRecList----->'+QuotePartyRecList);
        insert QuotePartyRecList;
    }



}