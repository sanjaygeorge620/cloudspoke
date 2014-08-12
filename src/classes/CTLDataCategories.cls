public with sharing class CTLDataCategories {



    public list<string> getSelectedCategories(){
        list<string> l = new list<string>();
            l.add('ISYS');
            l.add('ImageNow');
        return l;
    }
    
    
    public map<string, list<DataCategory>> DataCategory_Results{
        get{
            if(DataCategory_Results==null){
                DataCategory_Results = new map<string, list<DataCategory>>();
                //for(DescribeDataCategoryGroupStructureResult x: DescribeDataCategoryGroupStructures.getDescribeDataCategoryGroupStructureResults()){
                   DescribeDataCategoryGroupStructureResult x = getProductResults();
                     for(DataCategory y : x.getTopCategories()){
                        system.debug('y.getName: '+y.getName());    
                        
                        for(DataCategory z : y.getChildCategories()){
                            system.debug('z.getLabel: '+z.getLabel());    
                            system.debug('z.getName: '+z.getName());    
                            DataCategory_Results.put(z.getName(), z.getChildCategories()); 
                        }    
                    }
                                               
                //}
            }
            return DataCategory_Results;
            }
        set;
    }
    
    
    
    public DescribeDataCategoryGroupStructureResult getProductResults(){
        return DataCategoryResults.get('Product');
    }
    public DescribeDataCategoryGroupStructureResult getReleaseResults(){
        return DataCategoryResults.get('Release');
    }
    
    public map<string, DescribeDataCategoryGroupStructureResult> DataCategoryResults{
        get{
            if(DataCategoryResults==null){
                DataCategoryResults = new map<string, DescribeDataCategoryGroupStructureResult>();
                for(DescribeDataCategoryGroupStructureResult x: KnowledgeDataCategoryHelper.getDescribeDataCategoryGroupStructureResults()){
                        DataCategoryResults.put(x.getname(), x);
                }
            }
            return DataCategoryResults;
            }
        set;
    }
    
    
    public map<string,map<string,list<Datacategory>>> DataCategories{
    get{
        if(DataCategories==null){
            DataCategories = new map<string,map<string,list<Datacategory>>>();
            list<DescribeDataCategoryGroupStructureResult> x = new list<DescribeDataCategoryGroupStructureResult>();
            x.add(getProductResults());
            
            map<string,list<Datacategory>> Levels;
            for(DescribeDataCategoryGroupStructureResult L0: x){
                levels = new map<string,list<Datacategory>>();
                
                for(DataCategory L1 : L0.getTopCategories()){
                    system.debug('L1.getLabel: '+L1.getLabel());    
                    system.debug('L1.getName: '+L1.getName());    
                    levels.PUT('TOP__' +L1.getName(),L1.getChildCategories());
                    for(DataCategory L2 : L1.getChildCategories()){
                        system.debug('L2.getLabel: '+L2.getLabel());    
                        system.debug('L2.getName: '+L2.getName());    
                        levels.PUT('__' +L2.getName(),L2.getChildCategories());
                         
                        for(DataCategory L3 : L2.getChildCategories()){
                            system.debug('L3.getLabel: '+L3.getLabel());    
                            system.debug('L3.getName: '+L3.getName()); 
                            levels.PUT('___' +L3.getName(),L3.getChildCategories());
                            
                            for(DataCategory L4 : L3.getChildCategories()){
                                system.debug('L4.getLabel: '+L4.getLabel());    
                                system.debug('L4.getName: '+L4.getName()); 
                                levels.PUT('____' +L4.getName(),L4.getChildCategories());
                                
                                for(DataCategory L5 : L4.getChildCategories()){
                                    system.debug('L5.getLabel: '+L5.getLabel());    
                                    system.debug('L5.getName: '+L5.getName());    
                                    levels.PUT('_____' +L5.getName(),L5.getChildCategories());
                                }          
                            }       
                        }    
                    }
                 DataCategories.PUT(L1.getName(), levels); 
                }
                
            }
            
        }
        return DataCategories;
    }
    set;
    }

}