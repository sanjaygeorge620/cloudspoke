/*
Class Name : LX_Quick_Bid_AI_AU
Description : Trigger to Auto create/update Partner record in the Opportunity Party Object when a quick bid opportunity is created. As per User Story US4167
Created By : Sanjay Chaudhary (sanchaudhary@deloitte.com)
Created Date : 29-July-2014
Modification Log:
-----------------------------a--------------------------------------------
Developer           Date            Modification ID        Description
-------------------------------------------------------------------------
Sanjay Chaudhary   29-July-2014           1000               Initial Version
Shubhashish Rai    1-August-2014                             Added logic so that if the record has been submitted for approval then don't allow the user to edit
*************************************************************************/

trigger LX_Quick_Bid_BI_BU_AI_AU on Opportunity (before insert,before update, after insert, after update) {

    if(LX_CommonUtilities.ByPassBusinessRule()) return; //Added Bypass code 
    
    List <LX_Opportunity_Parties__c> oppPartyList = new List<LX_Opportunity_Parties__c>();
    Map<String,String> accidMDMidMap = new Map<String,String>();
    List <LX_Opportunity_Parties__c> oppPartyUpdateList = new List<LX_Opportunity_Parties__c>();
    Set<String> OppAccUpdated = new Set<String>();    
    Map<String,List<LX_Opportunity_Parties__c>> oppOppPartyMap = new Map<String,List<LX_Opportunity_Parties__c>> ();
    Map<String,String> slsOrgNameIdMap = new Map<String,String>();
    Set<String> oppSet = new Set<String>();
    List<Opportunity> oppUpdateList = new List<Opportunity>();
    Set <String> accCountrySet = new Set<String>();
    Map<String,List<LX_Opportunity_Pricelist_Product__c>> OppPriceListProductMap = new Map<String,List<LX_Opportunity_Pricelist_Product__c>> ();
    Set<String> OppCurrencyUpdated = new Set<String>();
    List<LX_Opportunity_Pricelist_Product__c> OppPriceListProductList = new List<LX_Opportunity_Pricelist_Product__c> ();
//    Id profileId=userinfo.getProfileId();
//    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;


   
   //Added logic for not allowing the user to edit if the LX_In_Approval_Process_Quick_Bid__c box is checked then don't allow the user to edit
/*    if(Trigger.isBefore && Trigger.isUpdate){
        for(Opportunity opp: Trigger.new){
            if(opp.recordtypeId == Label.LX_QuickBid_RecordTypeId && opp.LX_In_Approval_Process_Quick_Bid__c && Trigger.oldMap.get(opp.Id).LX_In_Approval_Process_Quick_Bid__c){
               if (profileName != 'System Administrator')
                   opp.addError('The quick bid has already been submitted to approval. You cannot edit the quick bid now');
            }
        }
    }*/
    
     //Sending Email when the Quick Bid is Approved
    if(Trigger.isBefore && Trigger.isUpdate)
    {
       system.debug('FirstRun_Check outside---->'+FirstRun_Check.FirstRun_QuickBidApprovalEmail);  
      if(true){
        system.debug('FirstRun_Check inside---->'+FirstRun_Check.FirstRun_QuickBidApprovalEmail);  
        
        set<id> oppsbmtforapprvIDS = new set<id>();
        set<id> oppapprvdIDS = new set<id>();
        map<id,opportunity> mpOpportunity = new MAP<id,opportunity>();
      for(Opportunity opp: Trigger.new){
//            if(opp.recordtypeId == Label.LX_QuickBid_RecordTypeId && Trigger.oldMap.get(opp.Id).LX_In_Approval_Process_Quick_Bid__c != opp.LX_In_Approval_Process_Quick_Bid__c){
              system.debug('**If Check**'+opp.recordtypeId+Label.LX_QuickBid_RecordTypeId+Trigger.oldMap.get(opp.Id).Quote_Status__c+opp.Quote_Status__c+opp.LX_In_Approval_Process_Quick_Bid__c);
              if(opp.recordtypeId == Label.LX_QuickBid_RecordTypeId &&Trigger.oldMap.get(opp.Id).Quote_Status__c!=opp.Quote_Status__c &&FirstRun_Check.FirstRun_QuickBidApprovalEmail){
                  //List to send when submitted for Approval
                  FirstRun_Check.FirstRun_QuickBidApprovalEmail = false;
                  if(( opp.Quote_Status__c == 'Pending Approval')){
                    oppsbmtforapprvIDS.add(opp.id);
                    mpOpportunity.put(opp.id,opp);
                    }
                  //List to send when quick bid is approved/Finalized  
                  if(opp.Quote_Status__c =='Finalized'){
                    oppapprvdIDS.add(opp.id);
                    mpOpportunity.put(opp.id,opp);   
                    }
                }
//            }
        }
       system.debug('Submit for Approval---->'+oppsbmtforapprvIDS.size());  
       system.debug('Approved QB---->'+oppapprvdIDS.size());   
        
      if(oppsbmtforapprvIDS.size() >0){
          system.debug('---->Opp List Size'+oppsbmtforapprvIDS.size());
          map<id,opportunity> mpOppSubmittedforApproval= new map<id,opportunity>([select id,Partner_Contact__r.Email,Distributor_Contact__r.Email,Name,Account.Name,Opportunity_Number__c,Account.Ownerid,Quote_Status__c,stagename,
                                    Description,CloseDate,createdby.email,createdbyid from opportunity where id in:oppsbmtforapprvIDS]);
          list<LX_Opportunity_Pricelist_Product__c> listPrdctsSubmittedforApproval = [select id,Name,LX_Opportunity__c,LX_Part_Number__c,LX_Quantity__c,LX_Product__r.Name,
                                    LX_Discount__c,LX_Total_Requested_Discount__c from LX_Opportunity_Pricelist_Product__c 
                                    where LX_Opportunity__c in:oppsbmtforapprvIDS];
          
          list<id> userids = new list<id>();
          for(id tempoppid : mpOppSubmittedforApproval.keyset()){
            userids.add(mpOppSubmittedforApproval.get(tempoppid).Account.Ownerid);            
          }
          map<id,user> mpUsers = new map<id,user>();
          if(userids.size()>0){
          List<user> listusers = [select id,Name,Email from User where id in:userids];
              for(id tempid: mpOppSubmittedforApproval.keyset()){
                  for(user tempuser : listusers){
                  if(mpOppSubmittedforApproval.get(tempid).Account.Ownerid == tempuser.id )
                       mpUsers.put(tempid,tempuser);
                  }
              }
          }
          system.debug('-----> list of products prior check'+listPrdctsSubmittedforApproval.size());
          system.debug('---->Opp Map Size'+mpOppSubmittedforApproval.size());

          //check for if atleast one product exists for that opportunity
          if(listPrdctsSubmittedforApproval.size() > 0){
              map<id,list<LX_Opportunity_Pricelist_Product__c>> mpOppproductList = new map<id,list<LX_Opportunity_Pricelist_Product__c>>();
              list<LX_Opportunity_Pricelist_Product__c> tempoppprdctlist = new list<LX_Opportunity_Pricelist_Product__c>();            
              for(id tempid: mpOppSubmittedforApproval.keyset()){
                  for(LX_Opportunity_Pricelist_Product__c tempprodcts : listPrdctsSubmittedforApproval){
                    if(tempid == tempprodcts.LX_Opportunity__c){
                      if(mpOppproductList.containsKey(tempid)){
                         tempoppprdctlist = mpOppproductList.get(tempid);
                         tempoppprdctlist.add(tempprodcts);
                         mpOppproductList.put(tempid,tempoppprdctlist);
                         }
                     else{
                          tempoppprdctlist = new list<LX_Opportunity_Pricelist_Product__c>();            
                          tempoppprdctlist.add(tempprodcts);
                          mpOppproductList.put(tempid,tempoppprdctlist);
                         }
                     }
                  }
              }
           system.debug('---->products map Size'+ mpOppproductList.size());   
            List<Messaging.SingleEmailMessage> listEmails = new list<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage emailSbmtforApproval = new Messaging.SingleEmailMessage(); 
            
            for(id oppid: mpOppSubmittedforApproval.keyset()){
               system.debug('---->Entry to Email Loop');
               string acctname = '', opportunitynno ='' , ownername ='',quotestatus = '',descrition ='', stagename='';
               if(mpOppSubmittedforApproval.get(oppid).Account.Name != null)
                   acctname  = mpOppSubmittedforApproval.get(oppid).Account.Name;
               if(mpOppSubmittedforApproval.get(oppid).Opportunity_Number__c != null)
                   opportunitynno = mpOppSubmittedforApproval.get(oppid).Opportunity_Number__c;
               if(mpUsers.get(oppid).Name != null){
                   ownername = mpUsers.get(oppid).Name;
                   }
               if(mpOpportunity.get(oppid).Quote_Status__c !=null)
                   quotestatus = mpOpportunity.get(oppid).Quote_Status__c;
               if(mpOppSubmittedforApproval.get(oppid).Description != null)
                   descrition = mpOppSubmittedforApproval.get(oppid).Description;
               if(mpOppSubmittedforApproval.get(oppid).stagename != null)
                   stagename = mpOppSubmittedforApproval.get(oppid).stagename;
               
               string str  = '<html> <body><div>A new Bid Desk submission has been entered on behalf '+ acctname +'</div> <table width = "50%" align="center">';
                str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Opportunity ID: </td><td colspan="3">' + opportunitynno +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Partner: </td><td colspan="3">' + acctname +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Lexmark Account Manager: </td><td colspan="3">' +  ownername +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Opportunity Status: </td><td colspan="3">' + quotestatus +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Opportunity Detail: </td><td colspan="3">' + descrition +'</td></tr>';
                string strDate = '';
                if(mpOppSubmittedforApproval.get(oppid).CloseDate != null){
                Datetime dt= mpOppSubmittedforApproval.get(oppid).CloseDate;
                strDate = DateTime.newInstanceGMT(System.Date.newInstance(2000, dt.month(), 1), System.Time.newInstance(0, 0, 0, 0)).formatGMT('MMM') + ' ' + dt.day() + ' '+dt.year();
                }
                str = str + '<tr width = "20%"> <td colspan="2"> Stage: </td><td colspan="3">' + stagename +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Expected Close Date: </td><td colspan="3">' + strDate +'</td></tr>';
                 str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                  str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                   
                list<LX_Opportunity_Pricelist_Product__c> prdctstobemailed = mpOppproductList.get(oppid);
                system.debug('---->products list Size check'+ oppid );
                if(prdctstobemailed.size() > 0){
                   system.debug('---->Entry to Sub products Email Loop'+ prdctstobemailed.size());
                    str = str + '<tr width = "20%"> <td colspan="2"><u>Product Details</u></td></tr>';
                    str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                    str = str + '<tr width = "100%"><td style="border:1px solid black;border-collapse:collapse;">Product Name</td><td style="border:1px solid black;border-collapse:collapse;">SKU</td><td style="border:1px solid black;border-collapse:collapse;">Quantity</td><td style="border:1px solid black;border-collapse:collapse;">Requested Discount</td><td style="border:1px solid black;border-collapse:collapse;">Total Discount</td></tr>';
                    for(LX_Opportunity_Pricelist_Product__c prdct:prdctstobemailed)
                    {
                     string prdctname = '', partno = '', quantity ='' , requestdiscperaunit = '' ,totalrequesteddisc ='', currencycode='';
                     
                     
                     if(mpOpportunity.get(oppid).CurrencyIsoCode !=null)
                        currencycode = mpOpportunity.get(oppid).CurrencyIsoCode;
                     if(prdct.LX_Product__r.Name != null)
                        prdctname = prdct.LX_Product__r.Name; 
                     if(prdct.LX_Part_Number__c != null)
                        partno = prdct.LX_Part_Number__c;
                     if(prdct.LX_Quantity__c != null)
                        quantity = string.valueof(prdct.LX_Quantity__c);
                     if(prdct.LX_Discount__c != null)
                        requestdiscperaunit = string.valueof(prdct.LX_Discount__c);
                     if(prdct.LX_Total_Requested_Discount__c != null)
                        totalrequesteddisc = string.valueof(prdct.LX_Total_Requested_Discount__c);
                       
                    str = str + '<tr width = "100%"><td style="border:1px solid black;border-collapse:collapse;">'+prdctname+'</td><td style="border:1px solid black;border-collapse:collapse;">'+ partno+'</td><td style="border:1px solid black;border-collapse:collapse;">'+quantity+'</td><td style="border:1px solid black;border-collapse:collapse;"> '+currencycode +' '+requestdiscperaunit+'</td><td style="border:1px solid black;border-collapse:collapse;">'+currencycode+' '+ totalrequesteddisc +'</td></tr>';
                    }
                   system.debug('---->Exit from Sub products Email Loop');
                }
                 str = str + '</table></body></html>';
                 system.debug(str);
             List<String> sendTo = new List<String>();
             if(mpUsers.get(oppid).Email !=null && mpUsers.get(oppid).Email !='' ){             
             sendTo.add(mpUsers.get(oppid).Email);
             }
             //sendTo.add('kamma.raviteja@gmail.com');
             sendTo.add('rkamma@deloitte.com');
             if(mpOppSubmittedforApproval.get(oppid).Partner_Contact__r.Email !=null && mpOppSubmittedforApproval.get(oppid).Partner_Contact__r.Email !='' ){
             sendTo.add(mpOppSubmittedforApproval.get(oppid).Partner_Contact__r.Email);
             }
             sendTo.add('shrai@deloitte.com');
             //sendTo.add('sanchaudhary@deloitte.com');
             if(mpOppSubmittedforApproval.get(oppid).CreatedBy.Email !=null && mpOppSubmittedforApproval.get(oppid).CreatedBy.Email !='' ){
             sendTo.add(mpOppSubmittedforApproval.get(oppid).CreatedBy.Email);
             }
             emailSbmtforApproval = new Messaging.SingleEmailMessage();
             emailSbmtforApproval.setSubject('Test Mail');
             system.debug('**Pending Approval Recepients**'+sendTo);
             emailSbmtforApproval.setToAddresses(sendTo);
             emailSbmtforApproval.setHtmlBody(str);
             emailSbmtforApproval.setSubject('New Bid Desk '+mpOppSubmittedforApproval.get(oppid).Opportunity_Number__c+' submitted by ' + mpOppSubmittedforApproval.get(oppid).Account.Name+'.');
             listEmails.add(emailSbmtforApproval);
             system.debug('---->Exit from Email Loop');   
            }
            system.debug('---->'+listEmails.size()); 
            try{
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(listEmails);
                  }
               catch(Exception e){
                   LX_CommonUtilities.createExceptionLog(e);
                } 
          }                                              
      }
       if(oppapprvdIDS.size() >0){
        map<id,opportunity> mpOppSubmittedforApproval= new map<id,opportunity>([select id,Name,Distributor_Contact__r.Email,Partner_Contact__r.Email,Account.Name,Opportunity_Number__c,Account.Ownerid,Quote_Status__c,stagename,
                                    Description,CloseDate,createdby.email,createdbyid from opportunity where id in:oppapprvdIDS]);
        list<LX_Opportunity_Pricelist_Product__c> listPrdctsSubmittedforApproval = [select id,Name,LX_Opportunity__c,LX_Part_Number__c,LX_Quantity__c,
                                    LX_Product__r.Name,LX_Discount__c,LX_Total_Requested_Discount__c,LX_Approved_Discount_Per_Unit__c,LX_Total_Approved_Discount__c from LX_Opportunity_Pricelist_Product__c 
                                    where LX_Opportunity__c in:oppapprvdIDS];
                                    
        list<LX_Opportunity_Parties__c> listOppParties = [select id,LX_Opportunity_Party_Type__c,
                                                    LX_Opportunity__c,LX_Account_Name__c,LX_Account_Text__c,
                                                    LX_Account_City__c,LX_Account_City_Text__c,
                                                    LX_Account_Street__c,LX_Account_Street_Text__c,
                                                    LX_Account_State__c,LX_Account_State_Text__c,
                                                    LX_Account__c from LX_Opportunity_Parties__c where LX_Opportunity__c in:oppapprvdIDS];
        List<BigMachines__Quote__c>  listBigMachinesQuote = [select id,Quote_Control_Number__c,BigMachines__Opportunity__c
                                                                from BigMachines__Quote__c where BigMachines__Opportunity__c in:oppapprvdIDS];
      
        
         system.debug('--->lists: produtcs count '+listPrdctsSubmittedforApproval.size()+' opp parties count ' + listOppParties.size()+ ' Quote Count '+listBigMachinesQuote.size());
      
      //To get related Quote details
      map<id,BigMachines__Quote__c> mpOppQuoteList = new map<id,BigMachines__Quote__c>();
      if(listBigMachinesQuote.size() > 0){
            for(id tempid: mpOppSubmittedforApproval.keyset()){
                for(BigMachines__Quote__c tempQuote : listBigMachinesQuote){
                  if(tempid == tempQuote.BigMachines__Opportunity__c)
                       mpOppQuoteList.put(tempid,tempQuote);
                }
            }
        }
        
      
      //To get related Parties
      map<id,LX_Opportunity_Parties__c> mpOppPartiesRef = new map<id,LX_Opportunity_Parties__c>();
      map<id,list<LX_Opportunity_Parties__c>> mpOppParitesList = new map<id,list<LX_Opportunity_Parties__c>>();
      
      if(listOppParties.size() > 0){
          for(LX_Opportunity_Parties__c tempOppPartRef: listOppParties){
                mpOppPartiesRef.put(tempOppPartRef.id,tempOppPartRef);
            }
          
          list<LX_Opportunity_Parties__c> tempoppPartieslist = new list<LX_Opportunity_Parties__c>();            
            for(id tempid: mpOppSubmittedforApproval.keyset()){
                for(LX_Opportunity_Parties__c tempprodcts : listOppParties){
                    if(tempid == tempprodcts.LX_Opportunity__c){
                      if(mpOppParitesList.containsKey(tempid)){
                         tempoppPartieslist = mpOppParitesList.get(tempid);
                         tempoppPartieslist.add(tempprodcts);
                         mpOppParitesList.put(tempid,tempoppPartieslist);
                        }
                     else{
                          tempoppPartieslist = new list<LX_Opportunity_Parties__c>();            
                          tempoppPartieslist.add(tempprodcts);
                          mpOppParitesList.put(tempid,tempoppPartieslist);
                        }
                    }
                }
            }
        }
      
      
      //To get related Users
      list<id> userids = new list<id>();
          for(id tempoppid : mpOppSubmittedforApproval.keyset()){
            userids.add(mpOppSubmittedforApproval.get(tempoppid).Account.Ownerid);
          }
          map<id,user> mpUsers = new map<id,user>();
          if(userids.size()>0){
          List<user> listusers = [select id,Name,Email from User where id in:userids];
              for(id tempid: mpOppSubmittedforApproval.keyset()){
                  for(user tempuser : listusers){
                  if(mpOppSubmittedforApproval.get(tempid).Account.Ownerid == tempuser.id)
                       mpUsers.put(tempid,tempuser);
                  }
              }
          }
       system.debug('--->Maps: opp parties count ' + mpOppPartiesRef.size()+ ' :: '+mpOppParitesList.size()+ ' Quote Count '+mpOppQuoteList.size() +' users count '+ mpUsers.size() );  
        //To get related Products
       if(listPrdctsSubmittedforApproval.size() > 0){
           map<id,list<LX_Opportunity_Pricelist_Product__c>> mpOppproductList = new map<id,list<LX_Opportunity_Pricelist_Product__c>>();
           list<LX_Opportunity_Pricelist_Product__c> tempoppprdctlist = new list<LX_Opportunity_Pricelist_Product__c>();            
            for(id tempid: mpOppSubmittedforApproval.keyset()){
                for(LX_Opportunity_Pricelist_Product__c tempprodcts : listPrdctsSubmittedforApproval){
                    if(tempid == tempprodcts.LX_Opportunity__c){
                      if(mpOppproductList.containsKey(tempid)){
                         tempoppprdctlist = mpOppproductList.get(tempid);
                         tempoppprdctlist.add(tempprodcts);
                         mpOppproductList.put(tempid,tempoppprdctlist);
                        }
                     else{
                          tempoppprdctlist = new list<LX_Opportunity_Pricelist_Product__c>();            
                          tempoppprdctlist.add(tempprodcts);
                          mpOppproductList.put(tempid,tempoppprdctlist);
                        }
                    }
                }
            }
            
            List<Messaging.SingleEmailMessage> listEmails = new list<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage emailSbmtforApproval = new Messaging.SingleEmailMessage(); 
            
            for(id oppid: mpOppSubmittedforApproval.keyset()){
               LX_Opportunity_Parties__c objpartner = new LX_Opportunity_Parties__c(), objcustomer = new LX_Opportunity_Parties__c();
               boolean getonecustomer =false,getonepartner = false;
               string strAcctName='',strAcctcity='',strAcctState='',strAcctAddress='',strCustAcctName='',bdusername= '';
               system.debug('---> cust name '+strCustAcctName);
               system.debug('---->Entry to Email Loop');
               string bdaccname = '', bdoppno = '',bdquotestno ='', bdcontrolno='';
               if(mpOppSubmittedforApproval.get(oppid).Account.Name != null)
                  bdaccname = mpOppSubmittedforApproval.get(oppid).Account.Name;
               if(mpOppSubmittedforApproval.get(oppid).Opportunity_Number__c !=null)
                   bdoppno = mpOppSubmittedforApproval.get(oppid).Opportunity_Number__c;
               if(mpOpportunity.get(oppid).Quote_Status__c != null)
                   bdquotestno = mpOpportunity.get(oppid).Quote_Status__c;
               if(mpOppQuoteList.get(oppid).Quote_Control_Number__c != null)  
                   bdcontrolno = mpOppQuoteList.get(oppid).Quote_Control_Number__c;
               if(mpUsers.get(oppid).Name != null)
                   bdusername = mpUsers.get(oppid).Name;     
               string str  = '<html> <body><div>A new Bid Desk request has been approved for '+ bdaccname +' by Lexmark.</div> <table width = "50%" align="center">';
                str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"><u>Bid Desk Details</u></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> ID: </td><td colspan="3">' + bdoppno +'</td></tr>';
                if(mpOppParitesList.get(oppid).size() >0){
                    for(LX_Opportunity_Parties__c tempoppparty : mpOppParitesList.get(oppid))
                    {
                    system.debug('---> oppParty Name::::' +tempoppparty.LX_Opportunity_Party_Type__c +' isonecustomer '+ getonecustomer);
                      if(tempoppparty != null){
                          if(tempoppparty.LX_Opportunity_Party_Type__c == 'Customer' && !getonecustomer){
                                system.debug('---> Customer Loop ');
                                if(mpOppPartiesRef.containskey(tempoppparty.id))
                                  objcustomer = mpOppPartiesRef.get(tempoppparty.id);
                                  system.debug('-->objcust '+ objcustomer );
                                getonecustomer = true;
                            }
                          if(tempoppparty.LX_Opportunity_Party_Type__c == 'Partner' && !getonepartner){
                          system.debug('---> Partner Loop ');
                               if(mpOppPartiesRef.containskey(tempoppparty.id))
                                  objpartner = mpOppPartiesRef.get(tempoppparty.id);
                                getonepartner = true;
                            }
                        }
                    }
                    if(objcustomer !=null){
                        if(objcustomer.LX_Account__c != null){
                            if(objcustomer.LX_Account_Name__c != null){   
                              strCustAcctName = objcustomer.LX_Account_Name__c;
                            }
                            }
                            else{
                              if(objcustomer.LX_Account_Text__c != null){
                              strCustAcctName = objcustomer.LX_Account_Text__c;
                            }}
                    }
                     system.debug('---> cust name '+strCustAcctName);
                    if(objpartner !=null){
                        if(objpartner.LX_Account__c != null || objpartner.LX_Account__c !=''){
                            if(objpartner.LX_Account_Name__c != null)
                                strAcctName = objpartner.LX_Account_Name__c;
                            if(objpartner.LX_Account_City__c != null)   
                                strAcctcity = objpartner.LX_Account_City__c;
                            if(objpartner.LX_Account_Street__c != null)
                                strAcctAddress = objpartner.LX_Account_Street__c;
                            if(objpartner.LX_Account_State__c != null)
                                strAcctState = objpartner.LX_Account_State__c;
                        }
                        else{
                            if(objpartner.LX_Account_Text__c != null)
                                strAcctName = objpartner.LX_Account_Text__c;
                            if(objpartner.LX_Account_City_Text__c != null)  
                                strAcctcity = objpartner.LX_Account_City_Text__c;
                            if(objpartner.LX_Account_Street_Text__c != null)
                                strAcctAddress = objpartner.LX_Account_Street_Text__c;
                            if(objpartner.LX_Account_State_Text__c != null)
                                strAcctState = objpartner.LX_Account_State_Text__c;
                        }
                    }
                }
                
                str = str + '<tr width = "20%"> <td colspan="2"> End User Account: </td><td colspan="3">' + strCustAcctName +'</td></tr>';
                
                str = str + '<tr width = "20%"> <td colspan="2">Quote Status:</td><td colspan="3">'+ bdquotestno +'</td></tr>';
                
                str = str + '<tr width = "20%"> <td colspan="2"> Control Number: </td><td colspan="3">' +  bdcontrolno +'</td></tr>';
                
                str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"><u>Partner Details</u></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Name: </td><td colspan="3">' + strAcctName +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Address: </td><td colspan="3">' + strAcctAddress +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> City: </td><td colspan="3">' + strAcctcity +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> State: </td><td colspan="3">' + strAcctState +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Partner Rep: </td><td colspan="3">' + strAcctState +'</td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"> Lexmark Rep: </td><td colspan="3">' + bdusername +'</td></tr>';
                list<LX_Opportunity_Pricelist_Product__c> prdctstobemailed = mpOppproductList.get(oppid);
                system.debug('---->products list Size check'+ oppid );
                if(prdctstobemailed.size() > 0){
                    str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                    str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                    str = str + '<tr width = "20%"> <td colspan="2"><u>Product Details</u></td><td colspan="3"></td></tr>';
                    system.debug('---->Entry to Sub products Email Loop'+ prdctstobemailed.size());
                    str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                    str = str + '<tr width = "100%"><td style="border:1px solid black;border-collapse:collapse;">Product Name</td><td style="border:1px solid black;border-collapse:collapse;">SKU</td><td style="border:1px solid black;border-collapse:collapse;">Quantity</td><td style="border:1px solid black;border-collapse:collapse;">Approved Discount</td><td style="border:1px solid black;border-collapse:collapse;">Total Discount</td></tr>';
                    for(LX_Opportunity_Pricelist_Product__c prdct:prdctstobemailed)
                    {
                     string prdctname = '', partno = '', quantity ='' , appvddiscperaunit = '' ,totalappvdeddisc ='',currencycode='';
                     
                     if(mpOpportunity.get(oppid).CurrencyIsoCode !=null)
                        currencycode = mpOpportunity.get(oppid).CurrencyIsoCode;
                     if(prdct.LX_Product__r.Name != null)
                        prdctname = prdct.LX_Product__r.Name; 
                     if(prdct.LX_Part_Number__c != null)
                        partno = prdct.LX_Part_Number__c;
                     if(prdct.LX_Quantity__c != null)
                        quantity = string.valueof(prdct.LX_Quantity__c);
                     if(prdct.LX_Approved_Discount_Per_Unit__c != null)
                        appvddiscperaunit = string.valueof(prdct.LX_Approved_Discount_Per_Unit__c);
                     if(prdct.LX_Total_Approved_Discount__c != null)
                        totalappvdeddisc = string.valueof(prdct.LX_Total_Approved_Discount__c);
                        
                    str = str + '<tr width = "100%"><td style="border:1px solid black;border-collapse:collapse;">'+prdctname+'</td><td style="border:1px solid black;border-collapse:collapse;">'+partno+'</td><td style="border:1px solid black;border-collapse:collapse;">'+quantity+'</td><td style="border:1px solid black;border-collapse:collapse;">'+currencycode+' '+appvddiscperaunit+'</td><td style="border:1px solid black;border-collapse:collapse;">'+currencycode+' '+totalappvdeddisc+'</td></tr>';
                    }
                   system.debug('---->Exit from Sub products Email Loop');
                }
                str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="2"></td><td colspan="3"></td></tr>';
                str = str + '<tr width = "20%"> <td colspan="5"><b>Please Note: </b>This Bid is valid for 30 days from the date of this email.</td></tr>';
                 
                str = str + '</table></body></html>';
             List<String> sendTo = new List<String>();
             if(mpUsers.get(oppid).Email !=null && mpUsers.get(oppid).Email !='' ){             
             sendTo.add(mpUsers.get(oppid).Email);
             }
             //sendTo.add('kamma.raviteja@gmail.com');
             sendTo.add('rkamma@deloitte.com');
             if(mpOppSubmittedforApproval.get(oppid).Partner_Contact__r.Email !=null && mpOppSubmittedforApproval.get(oppid).Partner_Contact__r.Email !='' ){
             sendTo.add(mpOppSubmittedforApproval.get(oppid).Partner_Contact__r.Email);
             }
             
             if(mpOppSubmittedforApproval.get(oppid).Distributor_Contact__r.Email !=null && mpOppSubmittedforApproval.get(oppid).Distributor_Contact__r.Email !='' ){
             sendTo.add(mpOppSubmittedforApproval.get(oppid).Distributor_Contact__r.Email);
             }
             if(mpOppSubmittedforApproval.get(oppid).CreatedBy.Email !=null && mpOppSubmittedforApproval.get(oppid).CreatedBy.Email !='' ){
             sendTo.add(mpOppSubmittedforApproval.get(oppid).CreatedBy.Email);
             }
             System.debug('**Created By Email on Approval**'+mpOppSubmittedforApproval.get(oppid).CreatedBy.Email);             
             sendTo.add('shrai@deloitte.com');
             //sendTo.add('sanchaudhary@deloitte.com');
             emailSbmtforApproval = new Messaging.SingleEmailMessage();
             emailSbmtforApproval.setSubject('Test Mail');
             system.debug('**Approved Email Recepients**'+sendTo);
             emailSbmtforApproval.setToAddresses(sendTo);
             emailSbmtforApproval.setHtmlBody(str);
             emailSbmtforApproval.setSubject('Bid Desk ID '+mpOppSubmittedforApproval.get(oppid).Opportunity_Number__c+' for '+ mpOppSubmittedforApproval.get(oppid).Account.Name +' is Approved.');
             listEmails.add(emailSbmtforApproval);
             system.debug('---->Exit from Email Loop');  
            }
            system.debug('---->'+listEmails.size()); 
            try{
                Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(listEmails);
                  }
               catch(Exception e){
                   LX_CommonUtilities.createExceptionLog(e);
                } 
          }    
        }   
            
   }
      
    }
   
   
   
   //Update the Opportunity Stage with respective to the Quiote Status
     if(Trigger.isBefore){
      Map<String,String> mpStatus = new Map<String,String>();
            mpStatus.put('Start','Qualifying');
            mpStatus.put('Pending','Qualifying');
            mpStatus.put('Pending Approval','Closing');
            mpStatus.put('Revision Pending','Qualifying');
            mpStatus.put('Approved','Closed Won');
            mpStatus.put('Finalized','Closed Won');
            mpStatus.put('Superceded','Closing');
            mpStatus.put('Cancelled','Closed Withdrawn');
            mpStatus.put('Rejected','Closed Lost');
            mpStatus.put('Full Reject','Closed Lost');
            
     for(Opportunity opp: Trigger.new){
     if(Trigger.isUpdate){
      if(opp.recordtypeId == Label.LX_QuickBid_RecordTypeId && opp.Quote_Status__c != '' && Trigger.oldMap.get(opp.Id).Quote_Status__c != opp.Quote_Status__c ){
         if(mpStatus.containsKey(opp.Quote_Status__c)){
           opp.stagename = mpStatus.get(opp.Quote_Status__c);
           if(opp.Quote_Status__c == 'Approved' || opp.Quote_Status__c == 'Finalized'){
               opp.LX_Approved_Date__c = system.today();
               opp.LX_Expiry_Date__c = system.today() + 30;
               }
           }
       }
      }
      if(Trigger.isInsert){
       if(opp.recordtypeId == Label.LX_QuickBid_RecordTypeId && opp.Quote_Status__c != ''){
         if(mpStatus.containsKey(opp.Quote_Status__c)){
            opp.stagename = mpStatus.get(opp.Quote_Status__c);
            if(opp.Quote_Status__c == 'Approved' || opp.Quote_Status__c == 'Finalized'){
               opp.LX_Approved_Date__c = system.today();
               opp.LX_Expiry_Date__c = system.today() + 30 ;
               }
            }
       }
      }
      }
     
     }

// Setting Sales Organization Country on the Opportunity based on the Oppty Account's Country. 
//Commented by Shubhashish because the sales organization country is populated on the click of button itself.    
   /* if (Trigger.isbefore)
    {           
       for (Opportunity op:Trigger.new){
           if (op.recordtypeId == Label.LX_QuickBid_RecordTypeId &&(Trigger.isinsert || (Trigger.isupdate && op.accountid != Trigger.oldMap.get(op.id).accountId)))           
               if (op.Account_Physical_Country__c == 'USA')
                   accCountrySet.add('United States');
               accCountrySet.add(op.Account_Physical_Country__c);                       
       }
                     
        if (accCountrySet.size()>0)
        {
        for (Sales_Organization__c slsOrg:[Select Id,Name from Sales_Organization__c where LX_Default__c = true and Status__c = 'Active' AND Name in:accCountrySet]){
            if (slsOrg.Name == 'United States'){
                slsOrgNameIdMap.put('USA',slsOrg.Id);
                slsOrgNameIdMap.put('United States',slsOrg.Id);
                }
            else
                slsOrgNameIdMap.put(slsOrg.Name,slsOrg.Id);            
            }
        }           
        
               
        for (Opportunity o:Trigger.new){
            if (o.recordtypeId == Label.LX_QuickBid_RecordTypeId &&(Trigger.isinsert || (Trigger.isupdate && o.accountid != Trigger.oldMap.get(o.id).accountId))){
                if (slsOrgNameIdMap.size()>0)
                    o.Sales_Organization__c = slsOrgNameIdMap.get(o.Account_Physical_Country__c);
                else
                    o.Sales_Organization__c = null;
            oppUpdateList.add(o);
            }
            }  
        
    }*/
// Insert Opportunity Party 'Partner' record once an Quick Bid Opportunity is created.     
    if (Trigger.isInsert && Trigger.isafter)
    {
        for (Opportunity opp:Trigger.new) 
        {
            if (opp.recordtypeId == Label.LX_QuickBid_RecordTypeId)
            {
                accidMDMidMap.put(opp.accountId,opp.account.MDM_Account_Number__c);
                LX_Opportunity_Parties__c oppParty= new LX_Opportunity_Parties__c ();
                oppParty.LX_Opportunity__c = opp.Id ;
                oppParty.LX_Account__c = opp.accountId ;
                oppParty.LX_Opportunity_Party_Type__c = 'Partner';
                oppParty.LX_Product_Line_Items__c = 'Printers;Options';   
                oppParty.LX_Claiming_Party__c = 'No';
                oppParty.LX_Ship_Debit__c = 'Yes';
                oppParty.LX_Timing_of_Discount__c = 'Back-end';
                oppParty.LX_Purchasing_Method__c = 'Indirect';                        
                oppPartyList.add(oppParty);    
            }     
        }
        if (oppPartyList.size()>0)
            insert oppPartyList;
            
        
    }
    
//  Update Opportunity Party & Opportunity Pricelist Products.   
    if (Trigger.isUpdate && Trigger.isafter)
    {    
        for (Opportunity opp:Trigger.new)
        {
            if (opp.accountid != Trigger.oldMap.get(opp.id).accountId && opp.recordtypeId == Label.LX_QuickBid_RecordTypeId) 
                OppAccUpdated.add(opp.Id);   
                
            if (opp.CurrencyIsoCode != Trigger.oldMap.get(opp.id).CurrencyIsoCode && opp.recordtypeId == Label.LX_QuickBid_RecordTypeId) 
                OppCurrencyUpdated.add(opp.Id);                         
        } 
// Update Opportunity Party 'Partner' record once an Account on Quick Bid Opportunity is updated.  
       
        if (OppAccUpdated.size()>0)
        {
             for (Opportunity o:[Select Id, (Select Id from Opportunity_Parties__r where LX_Opportunity_Party_Type__c = 'Partner') from Opportunity where id in:OppAccUpdated])    
                 oppOppPartyMap.put(o.Id,o.Opportunity_Parties__r); 
                 
             for (Opportunity o:Trigger.new)  
             {
                 for (LX_Opportunity_Parties__c lxp:oppOppPartyMap.get(o.Id))
                     {
                         lxp.LX_Account__c = o.accountid;
                         oppPartyUpdateList.add(lxp);
                     }
             
             }        
        update oppPartyUpdateList;  
        }

// Update Opportunity Pricelist Product's currency when Opportunitie's currency is updated        
        if (OppCurrencyUpdated.size()>0)
        {
            for (Opportunity o:[Select Id,(Select Id from Opportunity_Pricelist_Products__r) from Opportunity where id in :OppCurrencyUpdated])
                OppPriceListProductMap.put(o.Id,o.Opportunity_Pricelist_Products__r); 
                
            for (Opportunity o:Trigger.new)   
            {
                for(LX_Opportunity_Pricelist_Product__c opp:OppPriceListProductMap.get(o.Id))
                {
                    opp.CurrencyIsoCode = o.CurrencyIsoCode ;
                    OppPriceListProductList.add(opp);
                }
            
            }
        update OppPriceListProductList ;
        }
        
    }
    
}