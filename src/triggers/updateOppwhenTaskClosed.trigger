trigger updateOppwhenTaskClosed on Task (after update, after insert) 
{
if(LX_CommonUtilities.ByPassBusinessRule()) return; // [AK 25-Jul-13] : Added Bypass code
List<Task> tasks  = Trigger.new;

//Initialize the mapping matrix for the Task subject vs Opportunity field labels
Map<String, String> tasksubMap = new Map<String, String>{'WFT-ID Decision Maker'=>'ID Decision Maker | 1',
'WFT-Request SE'=>'Request SE | 2','WFT-Send the Response'=>'Send the Response | 2',
'WFT-Selected as a RFP Finalist'=>'Selected as Finalist | 2','WFT-Config Resolution/Prop Prep'=>'Configuration Resolution/Prop Prep | 3',
'WFT-Send Quote'=>'Send Quote | 3','WFT-Quote Review'=>'Quote Review | 3','WFT-Send Proposal'=>'Proposal Sent | 3',
'WFT-Update Order Method'=>'Order Method (PO/MA/T&C) Confirmed | 4'};

    
    //Retreive the metadata for the Opportunity object
    Schema.DescribeSObjectResult r = Opportunity.sObjectType.getDescribe();
   
     for(Task t : tasks)
     {
        //Process only if a task is closed
        if(t.isClosed == true){ 
        
        //Retrieve the map of all the Opportunity fields
        Map<String, Schema.SObjectField> fields = r.fields.getMap() ;
        
        //Loop through each field to determine the field that needs to be updated
        for(String s : fields.keySet())
        {
            // Can now retrieve a particular field and get additional properties
             Schema.SObjectField f = fields.get(s);
             Schema.DescribeFieldResult r2 = f.getDescribe() ;
             String fLabel = r2.getLabel();
             if(fLabel.equalsIgnoreCase(tasksubMap.get(t.subject))){
                 String fName = r2.getName();
             String queryStr = 'Select Id, ' + fName + ' from Opportunity where Id = \'' + t.WhatId + '\'';
             SObject result = Database.query(queryStr);
             result.put(fName, t.LastModifiedDate );
             update result;
             break;
             }
                 
             
         }
        }

    }
}