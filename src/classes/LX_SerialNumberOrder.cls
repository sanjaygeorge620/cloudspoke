/*
 * Created Date : 7/8/2014
 *
 * Author : Swati Sharma
 * 
 * Description : This class acts as an extenstion to Standard controller of 
 *               LX_Serial_Number_Sales_Order__c and is used on 
 *               LX_Serial_Number_Sales_Order_Form page
 * 
 * 7/8/2014 : Swati Sharma - Original Version
 *
 */
public class LX_SerialNumberOrder{

       //Check if customer account is not empty
       public boolean IsCustomerAccNOTempty {get;private set;}
       //check if partner account is not empty 
       public boolean IsPartnerAccNOTempty {get;private set;}
       //index to get the serial number line item row to be deleted
       public integer index{get;set;}
       //check profile to give access to edit button
       public boolean Profilecheck{get;set;}
       // wrapper list to store serial number line item list added on the page
       public List<SerialNumberWrapper> serialNumberList{get;set;}
       //counter to keep the count of serial number line item added
       public integer counterSerialNumber=0;
       //record to capture sales order info 
       public LX_Serial_Number_Sales_Order__c salesOrder{get;set;}
       //list to store all the serial number line items that can be added
       public list<Serial_Number__c> listSerialNumberLineItem {get;set;}
       //Select option list for Serial number drop down
       public list<selectoption> SNlist;
       // Method to update Account Name when Customer Account is given
       Public void UpdateAccName(){
           IsCustomerAccNOTempty = (salesOrder.LX_Customer_Account__c!=null) ? true : false ;
       
           if(salesorder.LX_Customer_Account__c!=null){
               String NewAccountName = [select Name from Account where id=:salesorder.LX_Customer_Account__c].Name;
               salesOrder.LX_Account_Name__c = NewAccountName ;
           }
       }
       
       //Method to set the customer account to null when account requested is checked
       Public void ClearAccName(){
       if(salesorder.LX_Account_Requested__c ==true){
       salesorder.LX_Customer_Account__c = null;
       }
       }
       //Constructor
       public LX_SerialNumberOrder(ApexPages.StandardController controller) {
          IsCustomerAccNOTempty =false;
          Profilecheck = LX_CreditAppLead_Utility.globalDataAdmin( UserInfo.getUserid(),  UserInfo.getprofileid());
        //Varible initialization
        listSerialNumberLineItem = new list<Serial_Number__c>();
        SNList = new list<selectoption>();
        this.salesOrder = (LX_Serial_Number_Sales_Order__c)controller.getRecord();
        counterSerialNumber = 0;
        Id SOid = apexpages.currentpage().getparameters().get('id');
        serialNumberList = new List<SerialNumberWrapper>();
        //Prepare Serial Line Item List for new/existing Sales Order
        SerialNumberWrapper snw ; 
        if(SOid !=null)
        {   //query existing sales order and related line items
            salesOrder = [select lx_website__C,LX_Assigned_User__c,lx_bill_to_phone__C,lx_bill_to_title__c ,Id,LX_Ship_To_Address__c,LX_Account_Name__c,Name,LX_Status__c ,LX_Customer_Account__r.OwnerId,LX_Customer_Account__r.Name,LX_Account_Requested__c,LX_Customer_Account__r.LX_Sales_Team_Assigned__c ,LX_Bill_To_Email_Address__c ,LX_Bill_To_Postal_Code__c ,LX_Bill_To_Country__c ,
                             LX_Ship_To_Country__c ,LX_Ship_To_Postal_Code__c,LX_Ship_To_State_Province__c ,LX_Bill_To_State_Province__c,
                             LX_Ship_To_City__c ,LX_Bill_To_City__c,LX_Bill_To_Address__c,LX_Phone_Number__c ,LX_Address_Same_as_Account_ShipTo__c ,
                             LX_City__c,LX_State__c ,LX_Ship_To_Name__c ,LX_Address_Same_as_Account_BillTo__c ,LX_Bill_To_Name__c ,LX_Country__c ,
                             LX_Province__c ,LX_Zip_Postal_Code__c ,LX_Email_Address__c ,LX_Street_Address_Line_2__c ,LX_Street_Address__c ,
                             LX_Last_Name__c ,LX_First_Name__c,LX_Customer_Account__c,LX_Partner_Account__c,LX_System_Locked__c
                             from LX_Serial_Number_Sales_Order__c 
                             where id=:SOid];
                        //     system.debug('%%%%%%%%%%->>>>>>>>' +salesOrder.LX_Activate__c);  
            list<Serial_Number__c> ListRelatedSNLI = new List<Serial_Number__c>();
            ListRelatedSNLI = [select Serial_Number__c,Part_Number__c,
                                License_Activated__c,Part_Name__c,Part_Name__r.SMSA_Product__c,Part_Name__r.SMSA_Product__r.name,Part_Name__r.SMSA_Product__r.Part_Number__c,
                                                                  Serial_Number_Sales_Order__c
                               from Serial_Number__c
                               where Partner_Account__c=:salesOrder.LX_Partner_Account__c and Serial_Number_Sales_Order__c=:SOid ];
            //if related line items exist, prepare wrapper list to display on page
            if(ListRelatedSNLI !=null && ListRelatedSNLI.size()!=0)
            {
                for(Serial_Number__c s:ListRelatedSNLI)
                {     snw = new SerialNumberWrapper();
                      snw.counterWrap =counterSerialNumber ;
                      snw.serialnumberlineItem = s;
                      serialNumberList.add(snw);
                      counterSerialNumber++;
                }
           }
           else{ 
               snw = new SerialNumberWrapper();
               snw.counterWrap =counterSerialNumber ;
               serialNumberList.add(snw);
               counterSerialNumber++;
            }
        } 
           //else prepare a new wrapper list
           else{ 
               snw = new SerialNumberWrapper();
               snw.counterWrap =counterSerialNumber ;
               serialNumberList.add(snw);
               counterSerialNumber++;
            }
       //Prepare SelectOptions to display on page
       updateSNList();
        system.debug('==>in constructor serialNumberList'+serialNumberList);
    }
    //getter for SNList - fetches the Serial numbers from associated serial number line item records
    public list<selectoption> getSNList() {
    
    List<SelectOption> options = new List<SelectOption>();
    // None is added as default SelectOption
    Options.add(new SelectOption('','None'));
    system.debug('****' + listSerialNumberLineItem);
    system.debug('****' + options);
    Set<String> allVals = new Set<String>();
    if(listSerialNumberLineItem!=null || listSerialNumberLineItem.size()!=0)
     {
        for(Serial_Number__c s:listSerialNumberLineItem ){
            if(!allVals.contains(s.Serial_Number__c)){
                if(s.Serial_Number__c != null)
                {
                    options.add(new SelectOption (s.Serial_Number__c,s.Serial_Number__c));
                    allVals.add(s.Serial_Number__c);
                }
            } 
        }
    }
    system.debug('****' + options);
    return options;
    }
    //Method called on change of Partner account to update SelectOption list accordingly
    public void updateSNList(){    
        
           
          system.debug('IsCustomer---->'+IsCustomerAccNOTempty );
        listSerialNumberLineItem = new list<Serial_Number__c>();
        if(salesOrder.LX_Partner_Account__c!=null)
        {    IsPartnerAccNOTempty = true;
            if(salesOrder.id==null)
            {
                listSerialNumberLineItem = [select License_Activated__c,Serial_Number__c,Part_Name__c,Part_Number__c,Serial_Number_Sales_Order__c
                                         
                                            from Serial_Number__c 
                                            where Partner_Account__c =:salesOrder.LX_Partner_Account__c and  
                                            (Serial_Number_Sales_Order__c = null OR Serial_Number_Sales_Order__c ='')];
            }
        else
        {
                listSerialNumberLineItem = [select License_Activated__c,Serial_Number__c,Part_Name__c,Part_Number__c,Serial_Number_Sales_Order__c
                                            from Serial_Number__c where 
                                            Partner_Account__c =:salesOrder.LX_Partner_Account__c and  
                                            (Serial_Number_Sales_Order__c = null OR Serial_Number_Sales_Order__c =:salesorder.id)];
        
        }
    
    //SNList = getSNList();
        }
        else{
            IsPartnerAccNOTempty =false;
            listSerialNumberLineItem = new List<Serial_Number__c>();
        }
    }
    //Method to Update List of Serial Number Line Items added by choosing from drop down
    public void updateserialNumberList()
    {        system.debug('==>Inside update');
             system.debug('===>serialNumberList'+serialNumberList);
             system.debug('===>indext'+index);
    
            for(SerialNumberWrapper s: serialNumberList)
            {   if(s.counterWrap == index)
                {   
                    system.debug('===>s.serialnumberlineItem'+s.serialnumberlineItem);
                    system.debug('===>listSerialNumberLineItem '+listSerialNumberLineItem );
                    for(Serial_Number__c sn :listSerialNumberLineItem )
                    {    if(s.serialnumberlineItem.Serial_Number__c==sn.Serial_Number__c)
                         {    system.debug('==>inside if');
                              s.serialnumberlineItem= sn.clone();
                            
                         }
                         else if(s.serialnumberlineItem.Serial_Number__c =='' || s.serialnumberlineItem.Serial_Number__c ==null)
                          {
                              s.serialnumberlineItem = new Serial_Number__c();
                          }
                    }
                }
            }
        
    }
    public void addSerialNumberOrder(){
        
        for(SerialNumberWrapper s: serialNumberList)
        {    
            if(s.serialnumberlineitem.serial_number__c == ''||s.serialnumberlineitem.serial_number__c==null)
            {
                Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Please select a serial number for the existing before adding another line item'));
                return ;
            }
        }
        
        system.debug('==>Inside Add');
        system.debug('===>serialNumberList'+serialNumberList);
        system.debug('===>indext'+index);
        counterSerialNumber++; 
        SerialNumberWrapper serialNumber = new SerialNumberWrapper();
        serialNumber.counterWrap = counterSerialNumber;
        serialNumberList.add(serialNumber);
    }
    public list< Serial_Number__c> ListSNtoRemove = new list< Serial_Number__c> ();
   
    public pagereference removeSerialNumberOrder(){
    system.debug('==>in remove index'+index);
    system.debug('==>in remove index'+serialNumberList);
    
        system.debug('==>inside remove'+serialNumberList.size());
        if(serialNumberList.size()<2)
        {
              Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Please enter at least 1 Serial Number to complete the form. '));
           
        }
        else 
        {    for(Integer i=0;i<serialNumberList.size();i++){
                   if(serialNumberList[i].counterWrap == index ){
                        ListSNtoRemove.add(serialNumberList[i].serialnumberlineItem);
                        system.debug('==>in remove ListSNtoRemove'+ListSNtoRemove);
                        serialNumberList.remove(i);
             }   
        }
   }
   return null;
   }
   public pagereference save_form()
   {     
         salesorder.lx_status__c = 'Saved';
         boolean serialListCheck = false;
         set<Serial_Number__c> SetSNtoUpdate = new set<Serial_Number__c>();
         System.Debug('----->>> :'+ IsCustomerAccNOTempty  + salesOrder.LX_Account_Requested__c);
         //skip the validations when account requested is checked
         if(!salesOrder.LX_Account_Requested__c){
             for(SerialNumberWrapper s: serialNumberList)
             {
                if(s.serialnumberlineitem.serial_number__c !='' && s.serialnumberlineitem.serial_number__c !=null)
                {
                    serialListCheck =true;
                }
                else if(s.serialnumberlineitem.serial_number__c =='' || s.serialnumberlineitem.serial_number__c ==null)
                {
                     Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Please select a serial number for the line without one or please remove that line from the list.'));   
                     return null;
                }
            }
        
            if(serialListCheck ==false)
            {       Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Please enter at least 1 Serial Number to save the form.  '));
                    return null;
            }
        
            else
            {
                try{
                     upsert salesorder;
                }
                catch(exception e)
            {
                Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Unable to save. Please try again'));
                return null;
            }
        
        for(SerialNumberWrapper s: serialNumberList)
        {     
               for(Serial_Number__c sn :listSerialNumberLineItem )
                {    if(s.serialnumberlineItem.Serial_Number__c==sn.Serial_Number__c)
                        {   
                            s.serialnumberlineItem= sn;
                        }
                }
                s.serialnumberlineItem.Serial_Number_Sales_Order__c = salesorder.id;
                SetSNtoUpdate.add(s.serialnumberlineItem); 
         }
         for(Serial_Number__c s :ListSNtoRemove)
         {
             if(!SetSNtoUpdate.contains(s))
             {          
                    for(Serial_Number__c sn :listSerialNumberLineItem )
                {    if(s.Serial_Number__c==sn.Serial_Number__c)
                        {   
                            s= sn;
                        }
                }
                 s.Serial_Number_Sales_Order__c = null;
                    SetSNtoUpdate.add(s); 
             }
         }
        list<Serial_Number__c> listSNtoUpdate = new list<Serial_Number__c>();
        
        listSNtoUpdate.addall(SetSNtoUpdate);
        system.debug('==>listSNtoUpdate'+listSNtoUpdate);
        try
        {
            update listSNtoUpdate;
        }
        catch(exception e)
        {
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Unable to save. Please try again' +e));
            return apexpages.currentpage();
        }
        }
        }
         else
            {
                try{
                     upsert salesorder;
                }
                catch(exception e)
            {
                Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Unable to save. Please try again'));
                return null;
            }
            }
       
        PageReference secondPage = Page.LX_Serial_Number_Sales_Order_Save;
        secondPage.setRedirect(true);
        secondPage.getParameters().put('id',salesorder.id); 
        return secondPage; 
    }
    //method to submit a sales order and related line items
    public Pagereference submit()
    {
       if(salesorder.LX_Customer_Account__c == null)
       {    
              Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Customer Account is required for Submission. '));   
              return ApexPages.currentPage();
       }
       if(salesorder.LX_Bill_To_Name__c ==null && salesorder.LX_Bill_To_Email_Address__c==null)
       {    
                    Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Please collect a Bill To Name and Email Address for the SMSA renewal against the customer.'));   
                return ApexPages.currentPage();
       }
              boolean serialListCheck =false;
       
       for(SerialNumberWrapper s: serialNumberList)
       {
            if(s.serialnumberlineitem.serial_number__c !='' && s.serialnumberlineitem.serial_number__c !=null)
            {
                serialListCheck =true;
            }
            else if(s.serialnumberlineitem.serial_number__c =='' || s.serialnumberlineitem.serial_number__c ==null)
            {
                Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Please select a serial number for the line without one or please remove that line from the list.'));   
                return ApexPages.currentPage();
            }
       }
       if(serialListCheck ==false)
       {    Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Please enter at least 1 Serial Number to save the form.  '));
            return ApexPages.currentPage();
       }
        salesOrder.lx_system_locked__c = true;
        salesorder.lx_status__C = 'Submitted';
        update salesOrder;
        set<Serial_Number__c> SetSNtoUpdate = new set<Serial_Number__c>();
 
        for(SerialNumberWrapper s: serialNumberList)
        {     
               for(Serial_Number__c sn :listSerialNumberLineItem )
                {    if(s.serialnumberlineItem.Serial_Number__c==sn.Serial_Number__c)
                        {   
                            s.serialnumberlineItem= sn;
                            s.serialnumberlineItem.Customer_Account__c = salesorder.LX_Customer_Account__c ;
                            SetSNtoUpdate.add(s.serialnumberlineItem); 

                        }
                }
        }
          list<Serial_Number__c> listSNtoUpdate = new list<Serial_Number__c>();
        
        listSNtoUpdate.addall(SetSNtoUpdate);
        system.debug('==>listSNtoUpdate'+listSNtoUpdate);
        try
        {
            update listSNtoUpdate;
        }
        catch(exception e)
        {
            Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'Unable to save. Please try again' +e));
            return apexpages.currentpage();
        }
       
        PageReference secondPage = Page.LX_Serial_Number_Sales_Order_Save;
        secondPage.setRedirect(true);
        secondPage.getParameters().put('id',salesorder.id); 
        return secondPage; 
    }
    //Method to activate the serial item line items after submit
    public Pagereference activate()
    {    
        list<Serial_Number__c> ListActivateSn = new list<Serial_Number__c>();
        //fetch line items from the object to compare with changes done on the page
        List<Serial_Number__c> listInactiveSN = [select License_Activated__c,Serial_Number__c,Part_Name__c,Part_Name__r.SMSA_Product__c,Part_Name__r.SMSA_Product__r.name,Part_Name__r.SMSA_Product__r.Part_Number__c,
                                                                  Serial_Number_Sales_Order__c
                                                           from Serial_Number__c 
                                                           where Partner_Account__c =:salesOrder.LX_Partner_Account__c and  
                                                           Serial_Number_Sales_Order__c =:salesOrder.id and License_Activated__c=false];
         set<ID> setInactiveSN = new set<ID>();
         if(listInactiveSN!=null && listInactiveSN.size()>0)
                { for(Serial_Number__c s:listInactiveSN)
                if(s.Part_Name__r.SMSA_Product__r.name != ''){          
                  setInactiveSN.add(s.id);     
                }
                else{
                    ApexPages.Message myerror = new ApexPages.Message(ApexPages.Severity.ERROR,'No SMSA product accociated with this line item');
                    ApexPages.addMessage(myerror); 
                    return ApexPages.currentPage();
                    }                           
           } 
           if(setInactiveSN!=null && setInactiveSN.size()>0)
           {
             system.debug('==>serialNumberList'+serialNumberList);
         //prepare the list of serial number items to be activated
         for(SerialNumberWrapper s:serialNumberList) 
         {
            // system.debug('==> setInactiveSN.contains(s.serialnumberlineItem)'+ setInactiveSN.contains(s.serialnumberlineItem));
             if(s.serialnumberlineItem.License_Activated__c==true && setInactiveSN.contains(s.serialnumberlineItem.id))
                  ListActivateSn.add(s.serialnumberlineItem);                          
         }
         system.debug('==>ListActivateSn'+ListActivateSn);       
      Lx_Oppactive.ActivateEnum  result = Lx_Oppactive.Utility(ListActivateSn,salesOrder);          
          //update line items 
       if(result ==Lx_Oppactive.ActivateEnum.Success  ){
          //    system.debug('%%%%%%%%%%-<<<<<<' +salesOrder.LX_Activate__c);  
             update ListActivateSn;
             salesorder.LX_Workflow__c = true;
             update salesorder;
          }else if(result  ==Lx_Oppactive.ActivateEnum.NoSerialItems)
         {
          
              
          ApexPages.Message myerror = new ApexPages.Message(ApexPages.Severity.ERROR,'No Serial Line Items Selected');
          ApexPages.addMessage(myerror); 
          return ApexPages.currentPage();
          }
          else {
          ApexPages.Message myerror = new ApexPages.Message(ApexPages.Severity.ERROR,'Exception thrown on the Page, please contact the System Administrator.');
          ApexPages.addMessage(myerror); 
          return null;          
          }
          
          }                  
         PageReference secondPage = Page.LX_Serial_Number_Sales_Order_Save;
         secondPage.setRedirect(true);
         secondPage.getParameters().put('id',salesorder.id); 
         return secondPage; 
     
    }
    //Wrapper Class to bind counter with Serial number line item
    public class SerialNumberWrapper{
        public Integer counterWrap{get;set;}
        public Serial_Number__c serialnumberlineItem{get;set;}  
        // constuctor for wrapper class
        public SerialNumberWrapper(){
            serialnumberlineItem = new Serial_Number__c();
        }
    }
}