@isTest(seealldata = true)
Private Class TestcreateAsset_Item_Clone
{

static testMethod void testSingleInsert()
{

  Account acct = Data_Account.createAccount3();

asset ast = new Asset(name='test1234',AccountID=acct.ID,Status='Active',Start_Date__c=System.Today());

insert ast;

asset_item__c asst = new asset_item__c(name='test12345',asset__c=ast.ID,start_date__c=system.Today(),status__c='active');

insert asst;

asset_item__c asst2 = new asset_item__c(name='test12345',asset__c=ast.ID,start_date__c=system.Today(),status__c='active',Upgrade_From__c = asst.id);

insert asst2;

asst.Status__c = 'Inactive';
asst.Exclude__c = True;
update asst;


//asset_item__c t_ast = [Select name,Status__c,Start_Date__c,asset__r.name 
//                       From Asset_item__c 
//                       Where CreatedDate = TODAY and name ='test12345' limit 1];
//asset_item_clone__c t_astcln=new asset_item_clone__c ();
//t_astcln = [Select name,Status__c,Start_Date__c,asset_clone__r.name from Asset_item_clone__c where CreatedDate = TODAY and name ='test12345' limit 1];
                       
                      
//System.assertEquals(t_ast.name,t_astcln.name);
//System.assertEquals(t_ast.Status__c,t_astcln.Status__c);
//System.assertEquals(t_ast.Start_Date__c,t_astcln.Start_Date__c);
//System.assertEquals(t_ast.asset__r.name,t_astcln.asset_clone__r.name);
       
}

static testMethod void testBulkInsert()
{

  Account acct = Data_Account.createAccount3();

asset asst=new asset(name='Test Asset',accountID=acct.ID);

insert asst;

List<Asset_item__c> ast = new List<Asset_item__c>();
for(Integer i=0; i<200; i++)
{
ast.add( new asset_item__c (name='bulk123567test',asset__c=asst.ID,start_date__c=system.Today(),status__c='Inactive'));
}
insert ast; 

integer count1 = [Select Count() from Asset_item__c where name = 'bulk123567test'];
integer count2 = [Select Count() from Asset_item_clone__c where name = 'bulk123567test'];

System.assertEquals(count1,200);
//VT 8/25:Commented System.assertEquals(count2,200);

asset_item__c [] astdel = [Select ID from Asset_item__c where name = 'bulk123567test'];

delete astdel;

integer count3 = [Select Count() from Asset_item__c where name = 'bulk123567test'];
integer count4 = [Select Count() from Asset_item_Clone__c where name = 'bulk123567test'];

System.assertEquals(count3,0);
System.assertEquals(count4,0);

}



}