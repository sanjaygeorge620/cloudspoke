@isTest
Private Class TestPreventDuplicate
{
static testMethod void testSingleInsert()
{
Price_Book_Definition__c pb = new Price_Book_Definition__c(Name = 'Test price Book',Type__c = 'Product',Discount_Type__c = 'Amount',
Discount_Value__c = 1200);
insert pb;

List<Product_Model__c> pmList = Data_ProductModels.createProductModels(2);
List<Product2> product = Data_Product.createProduct(pmList);   

Exception_Discount__c ed1 = new Exception_Discount__c(Product_Model__c = pmList[0].ID,Price_Book_Definition__c = pb.ID,Discount_Type__c='Amount',
Discount_Value__c = 1200);

insert ed1;

Exception_Discount__c ed3 = new Exception_Discount__c(Product__c = product[0].ID,Price_Book_Definition__c = pb.ID,Discount_Type__c='Amount',
Discount_Value__c = 1200);

insert ed3;

Price_Book_Include__c pi1 = new Price_Book_Include__c(Price_Book_Definition__c = pb.ID,Product_Model__c = pmList[0].ID);

insert pi1;

Price_Book_Include__c pi3 = new Price_Book_Include__c(Price_Book_Definition__c = pb.ID,Product__c = product[0].ID);

insert pi3;

Price_Book_Exclude__c pe1 = new Price_Book_Exclude__c(Price_Book_Definition__c = pb.ID,Product_Model__c = pmList[0].ID);

insert pe1;

Price_Book_Exclude__c pe3 = new Price_Book_Exclude__c(Price_Book_Definition__c = pb.ID,Product__c = product[0].ID);

insert pe3;

//=======================================Testing Starts===================================================

test.StartTest();

Price_Book_Exclude__c pe4 = new Price_Book_Exclude__c(Price_Book_Definition__c = pb.ID,Product__c = product[0].ID);

try
{
insert pe4;
}
catch(System.DMLException e)
{
System.Assert(e.getMessage().contains('Product already exists'));
}



Price_Book_Exclude__c pe2 = new Price_Book_Exclude__c(Price_Book_Definition__c = pb.ID,Product_Model__c = pmList[0].ID);

try
{
insert pe2;
}
catch(System.DMLException e)
{
System.Assert(e.getMessage().contains('Product Model already exists'));
}




Price_Book_Include__c pi4 = new Price_Book_Include__c(Price_Book_Definition__c = pb.ID,Product__c = product[0].ID);

try
{
insert pi4;
}
catch(System.DMLException e)
{
System.Assert(e.getMessage().contains('Product already exists'));
}



Price_Book_Include__c pi2 = new Price_Book_Include__c(Price_Book_Definition__c = pb.ID,Product_Model__c = pmList[0].ID);

try
{
insert pi2;
}
catch(System.DMLException e)
{
System.Assert(e.getMessage().contains('Product Model already exists'));
}


Exception_Discount__c ed4 = new Exception_Discount__c(Product__c = product[0].ID,Price_Book_Definition__c = pb.ID,Discount_Type__c='Amount',
Discount_Value__c = 1200);

try
{
insert ed4;
}
catch(System.DMLException e)
{
System.Assert(e.getMessage().contains('Product already exists'));
}

Exception_Discount__c ed2 = new Exception_Discount__c(Product_Model__c = pmList[0].ID,Price_Book_Definition__c = pb.ID,Discount_Type__c='Amount',
Discount_Value__c = 1200);

try
{
insert ed2;
}
catch(System.DMLException e)
{
System.Assert(e.getMessage().contains('Product Model already exists'));
}

Test.StopTest();


}
}