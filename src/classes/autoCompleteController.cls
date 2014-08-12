/****************************************************
  Controller for autoComplete visualforce component
****************************************************/

global class autoCompleteController 
{
    @RemoteAction
    global static List<ApexClass> queryApexClasses(string qry, string addFields) 
    {
        //More than one field can be passed in the addFields parameter
        // Split it into an array for later use 
        List<String> fieldList=new List<String>();
        if (addFields != '')  
        fieldList = addFields.split(',');     
        
        /* Creating the filter text */
        String filter = ' like \'%' + String.escapeSingleQuotes(qry) + '%\'';
        
        /* Begin building the dynamic soql query */
        String soql = 'SELECT Name';
        
        // If any additional field was passed, adding it to the soql 
        if (fieldList.size()>0) 
        {
            for (String s : fieldList) 
            {
                soql += ', ' + s;
            }
        }
        
        /* Adding the object and filter by name to the soql */
        soql += ' FROM ApexClass WHERE Name' + filter;
        
       
        
        // Adding the filter for additional fields to the soql 
        if (fieldList != null) 
        {
            for (String s : fieldList) 
            {
                soql += ' or ' + s + filter;
            }
        } 
        
        soql += ' ORDER BY Name LIMIT 20';
        
        system.debug('Qry: '+soql);
        
        List<ApexClass> QueryReturned = new List<ApexClass>();
        List<ApexClass> SchedulableClasses = new List<ApexClass>();
        try 
        {
             QueryReturned = Database.query(soql);
        }
        catch (QueryException e) 
        {
            system.debug('Query Exception:'+e.getMessage());
            return null;
        }
        //loop through all classes that are returned and filter out the ones that do not implement the Schedulable Interface
        for(ApexClass cls: QueryReturned){
            System.Type t;
            try {
                t = System.Type.forName(cls.Name);
             } catch (Exception ex) { continue; }          
             // Check for Schedulable interface...             
             Schedulable s;
             try {
                s = (Schedulable) JSON.deserialize('{}',t);
             } catch (Exception ex) {}
             if (s != null) {
               SchedulableClasses.add(cls);
            }
        }
        return SchedulableClasses;
   }
}