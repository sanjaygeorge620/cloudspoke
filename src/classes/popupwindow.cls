public class popupwindow {
        public boolean displayPopup {get; set;}     
           
        public  List<personalization__c> personRec{get;set;}
        public list<string> checkboxSelections {get;set;}
        public list<ProductFamilywrapper> PFlst{get;set;}
            public class ProductFamilywrapper{
                public boolean isChecked{get;set;}
                public String PfamilyName{get;set;}
            public ProductFamilywrapper(){
                isChecked = False;
            }
            }
            public list<selectOption> getMyCheckboxes(){
            //create list of checkboxes
                PFlst = new list<ProductFamilywrapper>();
                list<selectOption> myOptions = new list<selectOption>();
                Map<String,DescribeDataCategoryGroupStructureResult> DCL = New  Map<String,DescribeDataCategoryGroupStructureResult>();
                for(DescribeDataCategoryGroupStructureResult x: KnowledgeDataCategoryHelper.getDescribeDataCategoryGroupStructureResults()){
                DCL.put(x.getname(), x);
                }
                DescribeDataCategoryGroupStructureResult x = DCL.get('Product');
            for(DataCategory y : x.getTopCategories()){
                system.debug('y.getName: '+y.getName());    
            for(DataCategory z : y.getChildCategories()){
                system.debug('z.getLabel: '+z.getLabel());    
                system.debug('z.getName: '+z.getName());    
                ProductFamilywrapper PFWorkFlowRule = new ProductFamilywrapper();
                PFWorkFlowRule.isChecked = False ;
                PFWorkFlowRule.PfamilyName = z.getLabel(); 
                PFlst.add(PFWorkFlowRule);
                }    
            }
                system.debug('*******size********'+PFlst.size()); 
                system.debug('********Values*******'+PFlst); 
                return myOptions;
                }
            public popupwindow()    {
                PFlst = new list<ProductFamilywrapper>();
                displayPopup = true;
                personRec = [select Id,Name,User__c,Product_Family_Name__c  from personalization__c where User__c =: UserInfo.getUserId()];
                NavegatePopup();
            }
        public  pageReference NavegatePopup(){
                PageReference  pRef ;
                system.debug('********'+personRec.size());
                if(personRec.size() == 0 ){
                    displayPopup = true;
                    getMyCheckboxes();
                }else{
                    displayPopup = false;
                } 
                return null;
        }
        public pageReference submit(){
                personalization__c popWin = new personalization__c();
                popWin.User__c =  UserInfo.getUserId();
                popWin.filtertype__c = 'release';
                PageReference  pRef ;
                String strParem ='?';
                String PfamilyVal ='';
                for(ProductFamilywrapper pfIterate : PFlst){
                        if(pfIterate.isChecked == True) {
                            PfamilyVal  = PfamilyVal + pfIterate.PfamilyName+';';
                        }
                    }
                    System.debug('PfamilyVal-----'+PfamilyVal);
                        if(PfamilyVal <> ''){
                            popWin.Product_Family_Name__c = PfamilyVal   ;
                        insert popWin;   
                }     
                displayPopup = false;
                return null ;
        }
}