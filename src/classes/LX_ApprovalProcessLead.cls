/* This class is called when Request New Account button is clicked */
global class LX_ApprovalProcessLead {

WebService static void sendRecordToApproval(string id) {

/*// Create an approval request for the Lead
        Approval.ProcessSubmitRequest req = 
            new Approval.ProcessSubmitRequest();
        req.setComments('Submitting record for approval.');
        req.setObjectId(id);
        
        // Submit the approval request for the Lead
        Approval.ProcessResult result = Approval.process(req); */
        List<Group> queueId = new List<Group>();
        Set< String > listUSCanada = new Set< String >{'Canada', 'USA', 'Guam'};
        Set< String > listCEECountries = new Set< String >{'Afghanistan', 'Bosnia and Herzegovina', 'Czech Republic', 'Estonia', 'Georgia', 
        'Hungary', 'Israel', 'Kazakhstan', 'Latvia', 'Lithuania', 'Slovakia', 'Ukraine'};
        Set< String > listAustria = new Set< String >{'Austria'};
        Set< String > listGermany = new Set< String >{'Germany', 'Liechtenstein', 'Switzerland'};
        Set< String > listBeneluxCountries = new Set< String >{'Belgium', 'Luxembourg', 'Netherlands'};
        Set< String > listUK = new Set< String >{'United Kingdom', 'Ireland', 'Jersey'};
        Set< String > listSEECountries = new Set< String >{'Albania','Bulgaria','Croatia','Cyprus','Greece','Malta','Montenegro','Romania','Serbia','Slovenia'};
        Set< String > listSouthAfrica = new Set< String >{'South Africa'};
        Set< String > listNorthAfrica = new Set< String >{'Morocco','Tunisia','Algeria','Burkina Faso','Comoros','Ethiopia','Gabon','Niger','Tanzania','Togo','Uganda'};
        Set< String > listIberica = new Set< String >{'Spain','Portugal'};
        Set< String > listItaly = new Set< String >{'Italy'};
        Set< String > listNordics = new Set< String >{'Denmark','Faroe Islands','Finland','Greenland','Iceland','Norway','Sweden'};
        Set< String > listFrance = new Set< String >{'France','Guadeloupe','Martinique','New Caledonia','Reunion'};
        Set< String > listLIMECountries  = new Set< String >{'Bahrain','Egypt','Iran','Iraq','Jordan','Kuwait','Lebanon','Libya','Oman','Qatar','Saudi Arabia','Syrian Arab Republic',
        'United Arab Emirates'};
        Set< String > listAPCountries = new Set< String >{'American Samoa','Bangladesh','China','Hong Kong','India','Indonesia','Japan','Macao','Malaysia','Nepal','New Zealand',
        'Pakistan','Philippines','Singapore','Sri Lanka','Taiwan','Thailand','Vanuatu','Vietnam','South Korea','Australia'};
        Set< String > listLACountries = new Set< String >{'Anguilla','Antigua & Barbuda','Argentina','Aruba','Barbados','Costa Rica','Dominica','Dominican Republic','Ecuador',
        'El Salvador','Guatemala','Guyana','Haiti','Honduras','Jamaica','Netherlands Antilles','Nicaragua','Panama','Paraguay','Peru','Puerto Rico','Suriname','Trinidad and Tobago',
        'Turks & Caicos Islands','Uruguay','US Virgin Islands','Venezuela','Belize','Bermuda','Bolivia','Bonaire','Brazil','British Virgin Islands','Cayman Islands','Chile,Colombia'
        ,'Bahamas','Mexico'};
        Set< String > listEMEACountries  = new Set< String >{'Benin','Botswana','Cameroon','Congo','Ghana','Ivory Coast','Kenya','Madagascar',
        'Mali','Mauritius','Nigeria','Senegal','Sierra Leone','Sudan','Algeria','Tunisia','Poland','Russian Federation','Turkey'};
        Lead leadRec = [Select Id, Name, Business_Unit__c, LX_ISS_Coverage_Model__c, Physical_Country__c, OwnerId from Lead where Id =: id];
        if (leadRec.Business_Unit__c == 'ISS' && (leadRec.LX_ISS_Coverage_Model__c == 'OLA' || leadRec.LX_ISS_Coverage_Model__c == 'SMB')){
            if( listUSCanada.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User - US Canada' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listCEECountries.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User CEE Countries' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listAustria.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User Austria' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listGermany.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User Germany' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listBeneluxCountries.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User Benelux' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listUK.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User UK' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listSEECountries.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User SEE Countries' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listSouthAfrica.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User South Africa' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listNorthAfrica.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User North Africa' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listIberica.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User Iberica' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listItaly.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User Italy' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listNordics.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User Nordics Countries' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listFrance.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User France' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listLIMECountries.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User LIME Countries' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listAPCountries.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User AP Countries' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listLACountries.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User LA Countries' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
            else if( listEMEACountries.contains( leadRec.Physical_Country__c ) ){
                queueId = [select Id from Group where Name = 'Key User EMEA Countries' and Type = 'Queue'];
                leadRec.OwnerId = queueId[0].Id;
            }
        }
        update leadRec;
}

WebService static void copyRequestorId(string id) {
    List<Group> queueId = new List<Group>();
    List<RecordType> simpleRecId = new List<RecordType>();
    Lead leadRec = [Select Id,RecordSubmittedForApproval__c, RecordTypeId, Business_Unit__c,LX_Party_Group__c, LX_ISS_Coverage_Model__c, LX_User_who_requested_Account__c from Lead where Id =: id];
    leadRec.LX_User_who_requested_Account__c = UserInfo.getUserId();
    leadRec.LX_Req_New_Accnt_Button_Clicked__c = true;
    simpleRecId = [select Id from RecordType where Name = 'Simple Partner' and SobjectType = 'Lead'];
    system.debug ('Business_Unit__c+LX_Party_Group__c'+leadRec.Business_Unit__c+leadRec.LX_Party_Group__c);
    
// SC:06/13/2014 : Updated as per US3766 such that the ISS Partner Lead first goes to Approval Process when Request New Account Butoon is clicked on Lead.      
    if (leadRec.Business_Unit__c == 'ISS' && leadRec.LX_Party_Group__c == 'Partner' && leadRec.RecordTypeId  == simpleRecId[0].Id && leadRec.RecordSubmittedForApproval__c == false) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(leadRec.Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            System.debug('Submitted for approval successfully: '+result.isSuccess());
    }
    
    else {
    if(leadRec.RecordTypeId  == simpleRecId[0].Id){
        queueId = [select Id from Group where Name = 'Global Data Admin' and Type = 'Queue'];
        leadRec.OwnerId = queueId[0].Id;
    }
    if(leadRec.Business_Unit__c == 'PSW'){
        queueId = [select Id from Group where Name = 'Pending Account Request' and Type = 'Queue'];
        leadRec.OwnerId = queueId[0].Id;
    }
    else {
        queueId = [select Id from Group where Name = 'Global Data Admin' and Type = 'Queue'];
        leadRec.OwnerId = queueId[0].Id;
    }
    update leadRec;
    }
    }
}