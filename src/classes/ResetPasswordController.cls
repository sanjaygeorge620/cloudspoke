/******************************************************************************************************************************
* Name        - ResetPasswordController
* Description - This controller sets the password for multiple users at a given time.
* Modification Log :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Pavan                       01/07/2011             Created
*******************************************************************************************************************************/
public class ResetPasswordController{
/*
   public void resetPassword(){
        try{
                
                if(Selected.size() > 0)
                {
                    if(password != Null && password.length() > 0)
                    {
                            for(String users : Selected)
                               System.setPassword(users,password);
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Password reset successful for selected users.');
                            ApexPages.addMessage(myMsg);
                    }
                    else
                    {
                          password.subString(0,10);
                    }
                }
                 else
                 {
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please select a user for password reset.');
                       ApexPages.addMessage(myMsg);
                 } 
           }
           catch(StringException e)
           {
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please enter password....');
                ApexPages.addMessage(errMsg);  
           }  
           catch(Exception e)
           {
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.Error,e.getMessage());
                ApexPages.addMessage(errMsg);  
           }  
    }


    public String Password { get; set; }

//Declare Variables
public List<String>UsersSelected = new List<String>();
public List<String>UsersRemoved = new List<String>();
public Map<String,String> UsersAvbltemp = new Map<String,String>();
public Map<String,String> UsersAvblMap = new Map<String,String>();

public List<String> remainingUsers = new List<String>();
public List<String> UsersAvbl = new List<String>();
public Set<String> Selected = new Set<String>(); //collection that holds all selected Users
// Query the user object to retrieve all the users from salesforce org
public List<User> userList = [Select Name from user where isActive = true order by Name];

//Constructor
public ResetPasswordController()
{
   // AssignPickListValues();
    // Get the picklist Values
        try{
            UsersAvbltemp.clear();
            UsersAvbl.clear();
            for(User u : userList)
            {
                UsersAvbltemp.put(u.Id,u.Name); 
                //Map that has user names
                UsersAvblMap.put(u.Id,u.Name); 
                UsersAvbl.add(u.Id);
            }
        }catch(Exception e)
        {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
           ApexPages.addMessage(myMsg);
        }

}
//Method that populates the select option values during page load
public void AssignPickListValues()
{
}  
 public List<SelectOption> getAvblUsers() {
        List<SelectOption> options = new List<SelectOption>();
        remainingUsers.clear();
        for(String s : UsersAvbl)
            UsersAvbltemp.put(s,UsersAvblMap.get(s));
        
        if(Selected.size() == 0) //Initial Load
        {
                for(String s : UsersAvbl)
                {
                   System.debug(s);
                    options.add(new SelectOption(s,UsersAvblMap.get(s))); // Add the picklist values
                }
        
        }
        else
        {
                 for(String s : Selected)
                 {
                      if(UsersAvbltemp.get(s) != Null) 
                          UsersAvbltemp.remove(s);         
                 }
                for(String key : UsersAvbltemp.keyset())
                    remainingUsers.add(key);
                
                for(String s : remainingUsers)
                {
                 options.add(new selectOption(s,UsersAvblMap.get(s)));
                }
              
        }
        return options;
    }   
    
    public List<SelectOption> getUsersInSelectList() {
        List<SelectOption> options = new List<SelectOption>();
        for(String s : UsersAvbl)
        {
            for(String selectedVals : Selected)
            {
                if(selectedVals == s)
                {
                    options.add(new SelectOption(s,UsersAvblMap.get(s))); // Add the picklist values
                    break;
                }
            }
        }
        return options;
    }
   
    public void removeUsers() // removes selected Users from the list
    {
         for(String s : UsersRemoved)
          {
             Selected.remove(s);
          }
                           
    }
    public void addUsers() //Adds Users to existing selected Users
    {
      for(String s : UsersSelected)
         Selected.add(s);
    }
    
    public List<String> getUsersSelected(){ return UsersSelected ;}//this method maintains the selected items in Available list.
    public void setUsersSelected(List<String> UsersSelected){ this.UsersSelected  = UsersSelected ;}
    
    public List<String> getremoveList(){ return UsersRemoved;}// this method maintains the selected items in removal list
    public void setremoveList(List<String> UsersRemoved){this.UsersRemoved = UsersRemoved;}
    
  
*/         
}