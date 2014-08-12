@isTest(seeALldata=true)
Private Class TestcreateLicense_key_Clone
{

/*
static testMethod void testSingleInsert()
{

    Account act = Data_Account.createAccount3();
    
    asset ast = new asset(name='Test Asset',accountID=act.ID,status='Inactive');
    
    insert ast;
    
    asset_item__c astcln = new asset_item__c(name = 'Test Asset Item',Asset__c=ast.ID);
    
    insert astcln;
    
    License_key__c lkey = new License_key__c(name='test abc',asset__r=ast,asset_item__c=astcln.ID,status__c='Inactive');
    
    insert lkey;
    
    License_key__c l_key = [Select name,Status__c,asset__r.name,asset_item__r.name 
                           From License_key__c
                           Where CreatedDate = TODAY and name ='test abc' limit 1];
    
    License_key_clone__c l_key_clone = [Select name,Status__c,asset_clone__r.name,Asset_Item_Clone__r.name 
                           From License_key_clone__c
                           Where CreatedDate = TODAY and name ='test abc' limit 1];
                           
                          
    //System.assertEquals(l_key.name,l_key_clone.name);
    //System.assertEquals(l_key.asset__r.name,l_key_clone.asset_clone__r.name);
    //System.assertEquals(l_key.asset_item__r.name,l_key_clone.Asset_Item_Clone__r.name);
    //System.assertEquals(l_key.Status__c,l_key_clone.Status__c);

        
}*/

static testMethod void testBulkInsert()
{


Account act = Data_Account.createAccount3();

asset ast = new asset(name='Test Asset',accountID = act.ID,status='Inactive');

insert ast;

asset_item__c astcln = new asset_item__c(name = 'Test Asset Item',Asset__c=ast.ID);

insert astcln;

List<License_key__c> l_key = new List<License_key__c>();
for(Integer i=0; i<200; i++)
{
l_key.add(new License_key__c(name='bulk123567test',asset__r=ast,asset_item__c=astcln.ID,status__c='Inactive'));
}
insert l_key; 

integer count1 = [Select Count() from license_key__c where name = 'bulk123567test'];
integer count2 = [Select Count() from License_key_clone__c where name = 'bulk123567test'];

//System.assertEquals(count1,200);
//VT8/25: Commented System.assertEquals(count2,200);

License_key__c [] astdel = [Select ID from License_key__c where name = 'bulk123567test'];

delete astdel;

integer count3 = [Select Count() from License_key__c where name = 'bulk123567test'];
integer count4 = [Select Count() from License_key_Clone__c where name = 'bulk123567test'];

//System.assertEquals(count3,0);
//System.assertEquals(count4,0);

}



}