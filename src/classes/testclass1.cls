public class testclass1{

     public String val {get;set;}

  

  public List<SelectOption> getName()

  {

    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();    

    List<SelectOption> options = new List<SelectOption>();

     

    for(Schema.SObjectType f : gd)

    {

       System.debug(new SelectOption(f.getDescribe().getLabel(),f.getDescribe().getLabel()));

    }

    return options;

   }

    
}