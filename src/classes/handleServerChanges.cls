Public without sharing Class handleServerChanges
{
public Static void handleUpdate(Set<ID> serverIdset)
{
map<ID,List<Asset>> astmap = new map<ID,List<Asset>>();
List<Asset> updateList = new List<Asset>();
List<Asset> astList = [Select ID,Name,Agreement__c,Server__c,AccountID,Server__r.Account__c,Server__r.Account__r.name,Server__r.Agreement__c from Asset where Server__r.id in: serverIdset];

for(Asset ast : astList)
{
//Server__c serv = new Server__c(ID = ast.Server__c , Account__c = ast.Server__r.Account__c , Agreement__c = ast.Server__r.Agreement__c);
Asset asttemp = new Asset(ID = ast.id,name = ast.Server__r.Account__r.name,Server__c = ast.Server__c,Agreement__c = ast.Server__r.Agreement__c,AccountID = ast.Server__r.Account__c);

if(astmap.containskey(ast.Server__c))
{
List<Asset> temlst = new List<Asset>();
temlst = astmap.get(ast.Server__c);
temlst.add(asttemp);
astmap.put(ast.id,temlst);
}
else if(!astmap.containskey(ast.Server__c))
{
List<Asset> temlst = new List<Asset>();
temlst.add(asttemp);
astmap.put(ast.id,temlst);
}
updateList.add(asttemp);
}
if(!updateList.isEmpty())
{
update updateList;
}
}
}