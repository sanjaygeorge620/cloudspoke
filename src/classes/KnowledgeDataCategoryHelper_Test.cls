@isTest
private class KnowledgeDataCategoryHelper_Test{
   public static testMethod void getDescribeDataCategoryGroupStructureResultsTest(){
      List<Schema.DescribeDataCategoryGroupStructureResult> describeResult = KnowledgeDataCategoryHelper.getDescribeDataCategoryGroupStructureResults();
      
      //LXK Org has 4
      System.assert(describeResult.size() == 4,'The results should only contain 4 results: ' + describeResult.size());
      
      map<string, DescribeDataCategoryGroupStructureResult> MDC = KnowledgeDataCategoryHelper.MapDataCategory;          
      System.assert(MDC.size() == 4,'The results should only contain 4 results: ' + MDC.size());

   }
   
}