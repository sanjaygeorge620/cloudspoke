@isTest
Private Class TestcreateAssetClone
{

static testMethod void testSingleInsert()
{


Account act = Data_Account.createAccount();

asset asst = new Asset(name='test1234',AccountID=act.ID,Status='Active',Start_Date__c=System.Today());

insert asst;
asset_clone__c t_astcln=new asset_clone__c ();
asset t_ast = [Select name,Account.name,Status,Start_Date__c
                       From Asset 
                       Where CreatedDate = TODAY and name ='test1234' limit 1];

t_astcln = [Select name,Account__r.name,Status__c,Start_Date__c 
                       From Asset_clone__c 
                       Where CreatedDate = TODAY and name ='test1234' limit 1];
                       
                      
System.assertEquals(t_ast.name,t_astcln.name);
System.assertEquals(t_ast.Status,t_astcln.Status__c);
System.assertEquals(t_ast.Start_Date__c,t_astcln.Start_Date__c);
System.assertEquals(t_ast.account.name,t_astcln.account__r.name);

asst.name = 'Test name change';
update asst;

delete asst;
      
}

static testMethod void testBulkInsert()
{

Account act = Data_Account.createAccount();

List<Asset> ast = new List<Asset>();
for(Integer i=0; i<200; i++)
{
ast.add( new asset (name='bulk123567test',Status = 'Active',start_Date__c = System.Today(),AccountID=act.ID));
}
insert ast; 

integer count1 = [Select Count() from Asset where name = 'bulk123567test'];
integer count2 = [Select Count() from Asset_Clone__c where name = 'bulk123567test'];

System.assertEquals(count1,200);
//VT 8/25:COmmented System.assertEquals(count2,200);

for(asset at : ast)
{
at.name = 'Testing';
}
update ast;

asset [] astdel = [Select ID from Asset where name = 'bulk123567test'];



delete astdel;

integer count3 = [Select Count() from Asset where name = 'bulk123567test'];
integer count4 = [Select Count() from Asset_Clone__c where name = 'bulk123567test'];

System.assertEquals(count3,0);
System.assertEquals(count4,0);

}

}