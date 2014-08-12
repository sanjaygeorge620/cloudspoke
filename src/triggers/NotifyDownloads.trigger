trigger NotifyDownloads on Opportunity (after insert, after update) 
{

        //Added ByPass Logic on 07/25/2013
    if(LX_CommonUtilities.ByPassBusinessRule()&& (UserInfo.getUserId()).left(15) != '005i0000000ZK5i') return;  
  
  
    /**************************************
     Description: Added the code to create User Registration record for Partner Portal
     *            in line 387
     Date Revision: 3/11/2012
     *
     By: Manoj Kolli
     *****************************************/ 
 //------used for support user creation
    Set<ID> contactIDSet = new Set<ID>();             //---------set to hold the contact IDs to be processed
    Set<ID> contactIDforNewPartner = new Set<ID>();
    // Set<ID> contactIDforexistingCustomer = new Set<ID>(); 
    List<ID> contactIDList_cus = new List<ID>();
    List<ID> contactIDforNewPartnerList = new List<ID>();
    //List<ID> contactIDforexistingCustomerList = new List<ID>();  
    Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;         
    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Id recordTypeId = rtMapByName.get('Expansion-Add On').getRecordTypeId();//Replaced Additional Service with Expansion-Add On as part of Record type changes,6/5/2013 Kapil reddy 
    Order__c OrderShellRec;
    List<Opportunity> usethislst = new List<Opportunity>();
    Set<ID> usethisset = new Set<ID>();
    Map<ID,Order__c> ordermap = new Map<ID,Order__c>();
    Map<ID,List<OpportunityLineItem>> linemap = new Map<ID,List<OpportunityLineItem>>();
    //Srinivas: Adding a new map to store opportunity line item detials for creating ORDER records
    Map<ID,List<OpportunityLineItem>> oppLineItemMap = new Map<ID,List<OpportunityLineItem>>();
    Map<ID,set<ID>> conopp = new Map<ID,set<ID>>();
    //Create a set to store Contact IDs 
     Set<ID> setContactIds = new Set<ID>();  
     Set<ID> setLicenseContactIds = new Set<ID>();   
system.debug('FirstRun_Check.FirstRun_Downloads == '+FirstRun_Check.FirstRun_Downloads);     
    IF(FirstRun_Check.FirstRun_Downloads)
    {
    for(opportunity oppRec : Trigger.new)
    {
  if ((trigger.isinsert && FirstRun_Check.FirstRun_Downloads)|| 
            (trigger.isupdate && FirstRun_Check.FirstRun_Downloads))     
             {    
             system.debug('oppRec == '+oppRec);
             //Srinivas Removed Sap Satus condition in the below satemetns.
              if(((trigger.isinsert) && (FirstRun_Check.FirstRun_Downloads && oppRec.bypass_EmailNotify__c == False))|| 
                ((trigger.isupdate) && (trigger.oldMap.get(oppRec.id).SAP_Status__c != OppRec.SAP_Status__c 
                                    && oppRec.SAP_Status__c == 'SUBMITTED'
                                    && FirstRun_Check.FirstRun_Downloads && oppRec.bypass_EmailNotify__c == False)))

              {                                          
                
            //   if(oppRec.RecordTypeId <> recordTypeId )  //do not send notify for additional services/Expansion-Add On record types
            If(oppRec.Software_Solutions__C  == True || oppRec.LX_Opportunity_Division__c != 'ISS')
                {       
                             usethisSet.add(oppRec.id);
                             usethislst.add(oppRec);
                }
             }
    }
    }
    system.debug('OPP' +usethisSet);
    
    if(!usethisset.isEmpty())
    {
        for(OpportunityLineitem oli : [select PricebookEntry.Product2.License_Required__c,opportunityID,id,PricebookEntry.Product2.Name,quantity from opportunitylineitem where opportunity.id in: usethisSet and PricebookEntry.Product2.License_Required__c = true])
        {
            if(linemap.containskey(oli.opportunityID))
            {    
                linemap.get(oli.opportunityID).add(oli);
            }
            else
            {
                list<opportunityLineItem> temp = new list<opportunityLineItem>();
                temp.add(oli);
                linemap.put(oli.opportunityID,temp); 
            }    
        }    
        system.debug('FirstRun_Check.FirstRun_OrderShellCreation == '+FirstRun_Check.FirstRun_OrderShellCreation);    
        if(FirstRun_Check.FirstRun_OrderShellCreation)
        {
            system.debug('inxxx'); 
            system.debug('Before Creating Order Shell Records');           
            ordermap = createOpportunityOrderShell.createOpportunityOrderShellmap(usethisSet,usethislst,linemap);
            system.debug('After Creating Order Shell Records == '+ordermap);      
            system.debug('inxxx' +ordermap);       
         }           
                         
    
    if(!usethisLst.isEmpty())
    {
        for (Opportunity oppRec : usethisLst)   //get all contacts that need to process
        {  
                //Srinivas Added below sap status condition to create portal users
                  if (oppRec.SAP_Status__c == 'SUBMITTED' && linemap.containskey(oppRec.ID)) 
                  {
                      if (linemap.get(oppRec.ID).size() > 0) 
                      {          
                          if(oppRec.Ship_to__c != Null)
                          {                  
                              contactIDSet.add(oppRec.Ship_To__c);
                              
                              if(conopp.containskey(oppRec.Ship_to__c))
                              {
                                //Null check for ordermap variable
                                if(ordermap != null)
                                    conopp.get(oppRec.Ship_to__c).add(ordermap.get(oppRec.id).id);
                              }
                              else
                              {
                                  set<ID> tem = new set<ID>();
                                  //Null check for ordermap variable
                                  if(ordermap != null)
                                  {
                                    if(ordermap.get(oppRec.id) != null)
                                        tem.add(ordermap.get(oppRec.id).id);
                                    conopp.put(oppRec.Ship_to__c,tem);
                                  }
                                  
                              }
                          
                          }
                          if(oppRec.Project_Contact__c != Null)
                          {
                                contactIDSet.add(oppRec.Project_Contact__c);
                          
                              if(conopp.containskey(oppRec.Project_Contact__c ))
                              {
                                //Null check for ordermap variable
                                if(ordermap != null)
                                    conopp.get(oppRec.Project_Contact__c ).add(ordermap.get(oppRec.id).id);
                              }
                              else
                              {
                                  set<ID> tem = new set<ID>();
                                  //Null check for ordermap variable
                                  if(ordermap != null)
                                  {
                                    if(ordermap.get(oppRec.id) != null)
                                        tem.add(ordermap.get(oppRec.id).id); 
                                    conopp.put(oppRec.Project_Contact__c ,tem);
                                  }
                                 
                              }
                          }
                          
                          //Code Added for portal user creation changing on 06/21/2013
                          //Check if opportunity record has populated License Contact field
                          if(oppRec.Ship_To__c != null)
                          {
                                setContactIds.add(oppRec.Ship_To__c);
                                system.debug('License Contact : '+oppRec.Ship_To__c);
                          }
                          FirstRun_Check.FirstRun_Downloads = False;              
                      }
                  }  
                  
                   
        }
        /*if(setLicenseContactIds != null)
        {     
            //Query License Contact object based on license contacts and add Contact Ids to set
            for(LX_Contact_ShiptoSalesOrg__c obj : [select Contact__c from LX_Contact_ShiptoSalesOrg__c where id in: setLicenseContactIds])
            {
                setContactIds.add(obj.Contact__c);
            }
        }*/

        
        map<ID,Account> mp_con = new map<ID,Account>();
        
        map<ID,ID> con_act = new map<ID,ID>();
       
        set<ID> actID = new set<ID>();
        //Code Added for portal user creation changing on 06/21/2013
        //Commeneted below soql replaced it with the following one
        //for(Contact c: [Select ID,AccountID,Email from Contact where ID in: ContactIDSet])
        for(Contact c: [Select ID,AccountID,Email from Contact where ID in: setContactIds])
        {        
            con_act.put(c.ID,c.AccountID);        
            actID.add(c.AccountID);
        
        }
        
        system.debug('ContactIDSet' +ContactIDSet);
        
        map<ID,Account> mp_type = new map<ID,Account>();
        
        for(Account ac: [Select type,ID  from Account where ID in: actID])
        {      
        
        for(string ci : con_act.keyset())
        {
        if(con_act.get(ci) == ac.ID)
        {
        
        mp_con.put(ci,ac);
        
        }
        
        }
        
     //   mp_con.put(con_act.get(ac.ID),ac);
                
        }
        
        Set<ID> Chn_Prtl = new set<ID>();
        Set<ID> Cus_Prtl = new set<ID>();
       
        system.debug('mp_con' +mp_con.keySet());
        
              
         for(string p : mp_con.KeySet())
         {
             //Get partner type from custom setting and compare here
            LX_Customer_Types__c objCustType = LX_Customer_Types__c.getValues('PartnerType');
            String strPartnerType = (objCustType != null ? objCustType.Customer_Type__c : '');    
             
             if(mp_con.get(p).type == strPartnerType)
             //Commented as part of portal user change
             //mp_con.get(p).type ==  'Partner-Channel Level 1' 
                //|| mp_con.get(p).type ==  'Partner-Channel Level 2' 
                 //|| mp_con.get(p).type ==  'Partner-Channel Level 3'
                  //|| mp_con.get(p).type ==  'Partner-OEM')
                  {
                  
                  Chn_Prtl.add(p);
                  
                  }
                  else
                  {
                  
                  Cus_Prtl.add(p);
                  
                  }
                  
                  
                system.debug('CHN PRTL'+ chn_Prtl);  
                system.debug('CUS PRTL'+ cus_Prtl);              
         }
        
        
        
        
        
        
        system.debug('contactIDSet.size():'+ contactIDSet.size());
        system.debug('contactIDSet:'+ contactIDSet);
        
        if (Cus_Prtl.size() > 0) 
        {
            contactIDList_cus.addall(Cus_Prtl);
            Boolean MatchFlag;

            Set<ID> CreateUserListID_cus = new Set<ID>();
            List<ID> ActivateUserList_cus = new List<ID>();                                 //holds the information to activate users
            List<User> currentUserRec_cus = new List<User>(); 
                                              //holds the user that the match was found on
            List<Contact> ContactList_cus = new List<Contact>([select id 
                                                                , Email
                                                                , AccountID
                                                               from contact 
                                                               where Id in :ContactIDList_cus]);
            List<String> ContactEmails_cus = new List<String>();
            for (Integer c =0;c<ContactList_cus.size();c++)
            { 
                ContactEmails_cus.add(contactList_cus[c].Email);
            }
                
            List<User> userRecList_cus ;
            
           
            userRecList_cus = new List<User>([select ContactId 
                                                        , id 
                                                        , IsActive
                                                        , Email
                                                        , AccountID
                                                        from User 
                                                        where (contactId in :ContactIDList_cus)
                                                        and userType = 'PowerCustomerSuccess'
                                                        and profile.name like 'Perceptive Customer Portal%']); //Get List of all users that match contact list
 
 //------------------------Customer Portal
 
 
 
            system.debug('userreclist.size: '+ userRecList_cus.size());
            system.debug('userreclist: ' + userreclist_cus);

            if (userRecList_cus.size()> 0 )
            {
                for (Integer i =0;i<contactList_cus.size();i++){                                   //Loop through contact List
                    MatchFlag = False;                                                          //set matchFlag = false
                    User userRec;
                    for (Integer u =0;u<userRecList_cus.size();u++)
                    {                                //loop through User List
                        If(MatchFlag == False){
                            userRec = userrecList_cus[u];
                            system.debug('userrecList[u].ID: ' + userrecList_cus[u].ID);
                            system.debug('userrecList_cus[u].contactID: ' + userrecList_cus[u].contactID);
                            system.debug('userrecList_cus[u].email: ' + userrecList_cus[u].email);    
                            system.debug('userrecList[u].accountID: ' + userrecList_cus[u].AccountID);
                          
                            system.debug('contactList[i].email: ' + contactList_cus[i].email);
                            system.debug('contactList[i].id: ' + contactList_cus[i].id);
                            system.debug('contactList[i].accountID: ' + contactList_cus[i].AccountID);
                                                    
                            if (contactList_cus[i].id == userrecList_cus[u].contactID){
                                MatchFlag = True;    //set MatchFlag = True
                                system.debug('id match');
                            }
                            else {
                                if (contactList_cus[i].email == userrecList_cus[u].email
                                    && contactList_cus[i].AccountID == userrecList_cus[u].AccountID ){                       //if match
                                    MatchFlag = True;                                                   //set MatchFlag = True
                                    system.debug('email match');
                                }
                           }  
                        }
                    }                                                                           //end loop
                    if(matchFlag == True){
                        system.debug('customer portal - match flag: ' + matchFlag);
                        if (userRec.isActive == False)
                        {                               //if check user to see if active, if active = false
                            system.debug('customer portal - user Rec: ' + userRec);
                            system.debug('customer portal - user Rec.isActive: ' + userRec.isActive);

                            String containsUser = 'False';
                            for (Integer l = 0;l < ActivateUserList_cus.size();l++){
                                system.debug('activateUserList:' + activateUserList_cus);
                                system.debug('userRec.id:' + userRec.id);
                                If(activateUserList_cus[l] == userRec.id){
                                    containsUser = 'True';
                                }
                            }
                            if (containsUser == 'False')
                            {
                                ActivateUserList_cus.add(userRec.id);                            //add user Activate user List
                            }
                       }  
                    }  
                    
                    if (MatchFlag == False){                                            //if Matchflag = false  -- no matches found for user has been created
                        system.debug('right before individual contactlist');
                        CreateUserListID_cus.add(contactList_cus[i].id);                      //add contactId to create User List
                    }
                }                                                                    //end loop
            }
            
              else
            {                                                               //if no users found - automatically assign to be created
                system.debug('right before contact.add all');
                CreateUserListID_cus.addall(cus_Prtl); 
            } 
            system.debug( 'createUserListID: ' + createUserListID_cus);                                                                                
            
            if (CreateUserListID_cus.size()>0) 
            {
            system.debug('right before createcustomerportaluser' +CreateUserListID_cus);
                CreateActivePortalUser.CreateActivePortalUser(createUserListID_cus);    
            }
                
            if (activateUserList_cus.size() > 0) 
            {
                    system.debug('activateUserList:' + activateUserList_cus);
                    ActivateUser.ActivateUser(activateUserList_cus);
            }
        }      
            system.debug('before notifyDownloademail');
            system.debug('contactIDList: ' + Cus_Prtl);
 
 /* For partner User*/
 
  system.debug('contactIDforNewPartner.size()' + contactIDforNewPartner.size());
  
        if (Chn_Prtl.size() > 0) 
        {
        
            contactIDforNewPartnerList.addall(Chn_Prtl);
            system.debug(' contactIDforNewPartnerList ' +  contactIDforNewPartnerList);
            Boolean MatchFlag;

            Set<ID> CreateUserListID = new Set<ID>();
            List<ID> ActivateUserList = new List<ID>();                                 //holds the information to activate users
            List<User> currentUserRec = new List<User>();                                   //holds the user that the match was found on
            List<Contact> ContactList = new List<Contact>([select id 
                                                                , Email
                                                                , AccountID
                                                               from contact 
                                                               where Id in :contactIDforNewPartnerList]);
            List<String> ContactEmails = new List<String>();
            system.debug(' ContactList.size() ' +  ContactList.size());
            for (Integer c =0;c<ContactList.size();c++){ 
            system.debug(' contactList[c] ' +  contactList[c]);
                ContactEmails.add(contactList[c].Email);
            }  
          // system.debug('userRecList');        
           //List<User> userRecList

          //  system.debug('userRecList: ' + userRecList);
        List<User> userRecList = new List<User>([select ContactId 
                                                        , id 
                                                        , IsActive
                                                        , Email        
                                                        , AccountID
                                                        from User 
                                                        where (contactId in :contactIDforNewPartnerList)
                                                        and userType = 'PowerCustomerSuccess'                                                       
                                                        and profile.name like 'Perceptive Channel Portal%']); //Get List of all users that match contact list
   
   //--------------------------- Partner Portal           

            system.debug('userreclist.size: '+ userRecList.size());
            system.debug('userreclist: ' + userreclist);

            if (userRecList.size()> 0 )
            {
             system.debug('contactIDforNewPartnerList.size() ' + contactIDforNewPartnerList.size());
                for (Integer i =0;i<contactList.size();i++)
                {                                   //Loop through contact List
                    MatchFlag = False;                                                          //set matchFlag = false
                    User userRec;
                    system.debug('userRecList.size() ' + userRecList.size());
                    for (Integer u =0;u<userRecList.size();u++){                                //loop through User List
                        If(MatchFlag == False)
                        {
                          userRec = userrecList[u];
                          system.debug('Partner-userrecList[u].contactID: ' + userrecList[u].contactID);
                            system.debug('Partner-userrecList[u].email: ' + userrecList[u].email);    
                            system.debug('Partner-userrecList[u].accountID: ' + userrecList[u].AccountID);                    
                            system.debug('Partner-contactList[i].email: ' + contactList[i].email);
                            system.debug('Partner-contactList[i].id: ' + contactList[i].id);
                            system.debug('Partner-contactList[i].accountID: ' + contactList[i].AccountID);
                        
                          if (contactList[i].id == userrecList[u].contactID)
                          {
                                    MatchFlag = True;    //set MatchFlag = True
                                    system.debug('id match');
                          }
                          else 
                          {
                               if (contactList[i].email == userrecList[u].email
                                   && contactList[i].AccountID == userrecList[u].AccountID )
                                   {                       //if match
                                        MatchFlag = True;                                                   //set MatchFlag = True
                                        system.debug('email match');
                                   }
                           }  
                        }
                    }                                                                           //end loop
                    if(matchFlag == True)
                    {
                        system.debug('Partner portal - match flag: ' + matchFlag);
                        if (userRec.isActive == False)
                        {                               //if check user to see if active, if active = false
                            system.debug('Partner portal - user Rec: ' + userRec);
                            system.debug('Partner portal - user Rec.isActive: ' + userRec.isActive);

                            String containsUser = 'False';
                            for (Integer l = 0;l < ActivateUserList.size();l++){
                                system.debug('activateUserList:' + activateUserList);
                                system.debug('userRec.id:' + userRec.id);
                                If(activateUserList[l] == userRec.id)
                                {
                                    containsUser = 'True';
                                }
                            }
                            if (containsUser == 'False')
                            {
                            
                                ActivateUserList.add(userRec.id);                            //add user Activate user List
                            }
                       }  
                    }
        if (MatchFlag == False)
                    {                                                    //if Matchflag = false  -- no matches found for user has been created
                        system.debug('right before individual contactlist');
                         system.debug('CreateUserListID'+CreateUserListID);
                        CreateUserListID.add(contactList[i].id);                      //add contactId to create User List
                    }
                }                                                                    //end loop
            }  
            else 
            {                                                               //if no users found - automatically assign to be created
                system.debug('right before contact.add all');
                CreateUserListID.addall(chn_Prtl); 
            } 
            
            system.debug( 'createUserListID: ' + createUserListID);                                                                                
            if (CreateUserListID.size()>0) 
            {
                list<Id>  Alllist = new list<ID>();
                Alllist.addall(createUserListID);
                system.debug('right before createportaluser' +CreateUserListID);
                CreatePartnerUserRegistration2.CreatePartnerUserRegistration(CreateUserListID);
                //CreatePartnerUserRegistration.CreatePartnerUserRegistration(CreateUserListID);
                //CreateActivePartnerPortalUser.CreateActivePartnerPortalUser(CreateUserListID);    
            }
                system.debug('activateUserList.size():'+activateUserList.size());
            if (activateUserList.size() > 0) 
            {
            system.debug('activateUserList:'+activateUserList);
                    ActivateUser.ActivateUser(activateUserList);
            }
        }      
        /*---------------*/ 
        //-- Commented Out for US1451
        
          if (contactIDList_cus.size() > 0) 
           {
           for(ID i : contactIDList_cus)
           {
           if(conopp.containskey(i))
           {
           list<ID> nel = new List<ID>();
           nel.addall(conopp.get(i));
           NotifyDownloadEmail.NotifyDownloadEmail(i,nel);   //call class to send email based on contacts set
           }
           } 
           } 
           
           
           if (Chn_Prtl.size() > 0) 
           {
           for(ID i : Chn_Prtl)
           {
           if(conopp.containskey(i))
           {
           list<ID> nel = new List<ID>();
           nel.addall(conopp.get(i));
           NotifyDownloadEmailPrimaryPartner.NotifyDownloadEmail(i,nel);   //call class to send email based on contacts set
           }
           } 
           }
      }
}
}
}