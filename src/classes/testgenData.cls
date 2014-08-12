public class testgenData
{
Public Account Act {get; set;}
Public Contact Con {get; set;}
Public user cus_user {get; set;}
public Server__c serv {get; set;}
public testgenData()
{
Act = New Account();
Con = New Contact();
cus_user = New user();
serv = New server__c();
}
}