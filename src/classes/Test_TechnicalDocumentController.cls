@isTest(seeAllData = false)
Public class Test_TechnicalDocumentController{

static testMethod void TechnicalDocumentController(){

Project__c pro = new Project__c();
pro.Name = 'Test Project';
insert pro;

Sprint__c  sp = new Sprint__c();
sp.Name = 'Test Sprint 1';
insert sp;

List<Requirements__c> rList = new List<Requirements__c>();
Requirements__c r = new Requirements__c();
r.Allocated_Sprint__c = sp.Id;
//r.Functional_Area__c  = 'SFA';
r.Sub_Process__c = 'Marketing';
r.User__c = UserInfo.getUserId();
r.Supporting_BA__c = UserInfo.getUserId();
r.Development_Stage__c = '9. Done';
r.User_Type__c = 'Any User';

insert r;
rList.add(r);

UserStory2Design__c  usd = new UserStory2Design__c();
usd.User_Story__c = r.Id;
insert usd;

ApexPages.currentPage().getParameters().put('Project','Test Project');
ApexPages.currentPage().getParameters().Put('Ids',r.id);
TechnicalDocumentController TDC = new TechnicalDocumentController();

TDC.getUserStories();
TDC.lstSprint.add(sp.Id);
TDC.initUS= r ;
TDC.createQuerySOQL();
TDC.toggleSort();
TechnicalDocumentController.cUS  cus = new TechnicalDocumentController.cUS(r);
cus.selected = true;
    
TDC.userStoriesList.add(cus);
TDC.processSelected();
TDC.selectedUS.add(r);
TDC.getProjNameList();
TDC.Project_Name = 'Test Project';
TDC.createDocument();
TDC.CreateFunctionalDocument();
TDC.generateQAcards();
Pagereference pr1 = TDC.TempPage();


//delete r;
TechnicalDocumentController TDC1 = new TechnicalDocumentController();
TDC1.getUserStories();
list<opportunity> lstProd = new list<opportunity>();
opportunity opp = new opportunity(Name='Sample');
lstProd.add(opp);
ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(lstProd);

GenerateCard gcard = new GenerateCard(setcon);
if(gcard != null){
    string st1 = gcard.domainName;
    list<string> lsst1 = gcard.editableFields;
    //gcard.getOpportunities();
}
  
//Site site_EX = new Site(name='QRScan');
//insert site_EX;

//list<Requirements__c> OppList = gcard.getOpportunities();
//ApexPages.StandardController Con = new ApexPages.StandardController();
//KanbanBoardCntrl2 = new KanbanBoardCntrl2(Con);

    test.startTest();
    TechnicalDocumentController tech = new TechnicalDocumentController();
    tech.lstSprint = new list<id>();
    tech.initUS= r; 
    tech.createQuerySOQL();
    //tech.getUserStories();
    test.stopTest();
    

list<Requirements__c> lstFullUS= new list<Requirements__c>();
try {
                 lstFullUS = new list<Requirements__c>();
                  
                 if (lstFullUS.size()==0){
                     
                     //Boolean TryThrown =  e.getMessage().contains('NO Records found') ? true : false; 
                     //system.assertEquals(TryThrown,true);        
              } 
              }
             catch(Exception e) {
                  
                  Boolean ExceptionThrown =  e.getMessage().contains('Oooooooooops. Seems like the SOQL Query was wrongly created.') ? true : false; 
                  system.assertEquals(ExceptionThrown,true);   
             }

//Code added to test GenerateCard
    ApexPages.StandardSetController samCon = new ApexPages.StandardSetController(rList);
    GenerateCard gcardnew = new GenerateCard(samCon );
    List<Requirements__c> tempRequirementsList = new List<Requirements__c>();
    tempRequirementsList  = gcardnew.getOpportunities();
    //Site testSite = new site();
    //testSite.name = 'QRScan';
    //insert testSite;
    string st2 = gcardnew.domainName;
  
}

}