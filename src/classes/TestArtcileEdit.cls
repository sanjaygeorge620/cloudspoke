@isTest(seealldata=true)
private class TestArtcileEdit{

    static testMethod void myUnitTest() {
     ApexPages.StandardController stndCont;
     
      account acc=new account();
      acc.name='test test2';
      acc.CurrencyIsoCode='USD';
      acc.Physical_Country__c='USA';
      acc.LX_Country_Code__c='US';
      acc.LXK_Region__c='USA';
      acc.BillingCountry = 'USA';

      acc.LX_CountryHidden__c = 'USA';
      acc.LX_Geo__c='North America';
      acc.PSW_Sales_Region__c='USA';
      insert acc;
     
      
      contact con=new contact();
      con.AccountId=acc.Id;
      con.LastName='test test1';
      insert con;
      case c1=new case();
      //c1.CaseNumber='12345';
      c1.Subject='kabdcsdbv';
      c1.status='new';
      c1.Impact__c='user';
      c1.Urgency__c='low';
      c1.Origin='email';
      c1.type='problem';
      c1.contactId=con.Id;
      //c1.RecordTypeID = '012i0000000MmL0';
      c1.Description='hvyujsv';
      c1.Final_Outcome__c='fdfbgdb';
      insert c1;
     pse__Region__c psa = new pse__Region__c(); 
      psa.name='test';
      psa.CurrencyIsoCode='USD';
      insert psa;
      pse__Practice__c pc=new pse__Practice__c();
      pc.name='test';
      pc.CurrencyIsoCode='USD';
      insert pc;
      pse__Grp__c pg=new pse__Grp__c();
  
      pc.CurrencyIsoCode='USD';
      pg.name='test1';
      insert pg;
     pse__Proj__c ps =new pse__Proj__c();
     ps.name='test';
     ps.CurrencyIsoCode='USD';
     ps.pse__Region__c=psa.id;  
     ps.pse__Practice__c=pc.id;
     ps.pse__Group__c=pg.id;
     insert ps;
      Article_Submission__c art=new Article_Submission__c();
      art.Case_Source__c=c1.Id;
      art.Title__c='Test';
      insert art;
      ApexPages.CurrentPage().getParameters().put('id',c1.Id);
      ApexPages.CurrentPage().getParameters().put('ArtId',art.Id);
     ArticleEdit arObj=new ArticleEdit(stndCont);
     Article_Submission__c arSub=arObj.getart();
     arObj.Save();
     arObj.Cancel();
     arObj.SaveNew();
        
     
    }
     static testMethod void myUnitTest1() {
     ApexPages.StandardController stndCont;
      
      account acc=new account();
            acc.name='test test2';
      acc.CurrencyIsoCode='USD';
      acc.Physical_Country__c='usa';
      acc.LX_Country_Code__c='us';
      acc.LXK_Region__c='see';
      acc.LX_Geo__c='emea';
      acc.LX_Country_Code__c ='US';
      acc.LXK_Region__c = 'USA';
      acc.LX_Geo__c = 'North America';

      acc.BillingCountry = 'USA';
      acc.LX_CountryHidden__c = 'USA';
      acc.Local_Language_Physical_Country__c = 'usa';
      acc.PSW_Sales_Region__c = 'usa';   
      // acc.PSW_Sales_Region__c='dachee';
      
      insert acc;
     
      contact con=new contact();
      con.AccountId=acc.Id;
      con.LastName='test test1';
      insert con;
      case c1=new case();
//      c1.CaseNumber='12345';
      c1.Subject='kabdcsdbv';
      c1.status='new';
      c1.Impact__c='user';
      c1.Urgency__c='low';
      c1.Origin='email';
      c1.type='problem';
      c1.contactId=con.Id;
     // c1.RecordTypeID='012c00000004ZFJ';
      c1.Description='hvyujsv';
      c1.Final_Outcome__c='fdfbgdb';
      insert c1;
      pse__Region__c psa = new pse__Region__c(); 
      psa.name='test';
      psa.CurrencyIsoCode='USD';
      insert psa;
      pse__Practice__c pc=new pse__Practice__c();
      pc.name='test';
      pc.CurrencyIsoCode='USD';
      insert pc;
      pse__Grp__c pg=new pse__Grp__c();
  
      pc.CurrencyIsoCode='USD';
      pg.name='test1';
      insert pg;
     pse__Proj__c ps =new pse__Proj__c();
     ps.name='test';
     ps.CurrencyIsoCode='USD';
     ps.pse__Region__c=psa.id;  
     ps.pse__Practice__c=pc.id;
     ps.pse__Group__c=pg.id;
     insert ps;
      Article_Submission__c art=new Article_Submission__c();
      art.Case_Source__c=c1.Id;
      art.Title__c='Test';
      insert art;
      ApexPages.CurrentPage().getParameters().put('id',c1.Id);
      
     ArticleEdit arObj=new ArticleEdit(stndCont);
     Article_Submission__c arSub=arObj.getart();
     arObj.Save();
     arObj.Cancel();
     arObj.SaveNew();
      
    }
 }