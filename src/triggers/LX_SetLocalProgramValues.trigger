/* Trigger Name : LX_SetLocalProgramValues
* Description : This trigger executes on before Insert,before update,after update for object LX_Partner_Program__c.
*               It sets Partner_Program object fields  for level 3(local program)
* Created By :  Arun thakur(arunsingh6@deloitte.com)
* Created Date : 06/June/2013
* Modification Log: 
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer     Date     Modification ID     Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* 
*/
trigger LX_SetLocalProgramValues on LX_Partner_Program__c (before Insert,before update,after update) 
{

 //if(LX_SAP_Record_Utility.IsUpdated==false)
 
    if(LX_CommonUtilities.ByPassBusinessRule()) return; // [arun 08-Aug-13] : Added Bypass code
        List<Id> Child_LX_List_GlobalProgramId=new List<Id>();
        List<Id> Parent_LX_List_GlobalProgramId=new List<Id>();
        for(LX_Partner_Program__c ObjPartnerProgram:Trigger.New)
        {
            // US-2750
            if(Trigger.isBefore){
                 system.debug('Enter loop3'+ObjPartnerProgram.RecordType.Name+' '+ObjPartnerProgram.RecordTypeid);
                if(ObjPartnerProgram.RecordTypeid==LX_SetRecordIDs.LocalISSProgramRTID){
                    system.debug('Enter loop');
                    if(ObjPartnerProgram.LX_Start_Date__c==null){
                        system.debug('Enter loop2');
                        ObjPartnerProgram.LX_Start_Date__c=ObjPartnerProgram.LX_Local_Program_Start_Date__c;
                    }
                    if(ObjPartnerProgram.Program_End_Date__c==null)
                        ObjPartnerProgram.Program_End_Date__c=ObjPartnerProgram.LX_Local_Program_End_Date__c;
                }
                else if(ObjPartnerProgram.RecordTypeid==LX_SetRecordIDs.GlobalISSProgramCategoryRTID){
                    if(ObjPartnerProgram.LX_Start_Date__c==null)
                        ObjPartnerProgram.LX_Start_Date__c=ObjPartnerProgram.LX_Global_Program_Start_Date__c;
                    if(ObjPartnerProgram.Program_End_Date__c==null)
                        ObjPartnerProgram.Program_End_Date__c=ObjPartnerProgram.LX_Global_Program_End_Date__c;
                }
            }          
            if(ObjPartnerProgram.LX_Program_Enrolled__c!=null)
                {
                    Child_LX_List_GlobalProgramId.Add(ObjPartnerProgram.LX_Program_Enrolled__c);
                }
                else
                {
                    Parent_LX_List_GlobalProgramId.Add(ObjPartnerProgram.Id);
                }
        }
        
        if(Trigger.IsBefore)
     {
      // Populate 'Global Program Value' field for Level 3 records
        Set<ID> global_program_level = new  Set<ID>();
        Set<ID> global_Programs = new Set<ID>();
        For(LX_Partner_Program__c lx_program : Trigger.New)
        {
            if(lx_program.Program_Level__c == Label.Local_Program_Name_Partner_Program)
            global_program_level.add(lx_program.LX_Program_Enrolled__c);
        }
        
        List < LX_Partner_Program__c> global_program_levels = [Select id,Global_Program__c from LX_Partner_Program__c where id in :global_program_level];
        Map<ID,ID> local_global =new Map<ID,ID>();
        For(LX_Partner_Program__c lx_program : global_program_levels)
        {          
            global_Programs.add(lx_program.Global_Program__c);
            local_global.put(lx_program.id,lx_program.Global_Program__c);
        }
        
        Map <ID,LX_Partner_Program__c > local_Program = new Map<ID,LX_Partner_Program__c > ([select ID,name from LX_Partner_Program__c where id in :global_Programs]);
        
        for(LX_Partner_Program__c lx_program : Trigger.New)
        {
            if(lx_program.Program_Level__c == Label.Local_Program_Name_Partner_Program)
            lx_program.LX_Global_Program_Value__c = local_Program.get(local_global.get(lx_program.LX_Program_Enrolled__c)!=null ?local_global.get(lx_program.LX_Program_Enrolled__c):null)!=null ? local_Program.get(local_global.get(lx_program.LX_Program_Enrolled__c)!=null ?local_global.get(lx_program.LX_Program_Enrolled__c):null).name : null;
            system.debug(local_program.get(local_global.get(lx_program.LX_Program_Enrolled__c)));
        
       
        
        
        }
     
     /*
        //Commented by arun thakur :DE241
        //Get parent Partner program values 
        Map<Id,LX_Partner_Program__c> Lx_MapPartnerProgram= new Map< Id,LX_Partner_Program__c >([select id,LX_Party_Type__c,ISS_Capability_Segment__c,Primary_Lexmark_Vertical_Focus__c
        from LX_Partner_Program__c where id in :Child_LX_List_GlobalProgramId]);

        for(LX_Partner_Program__c ObjPartnerProgram:Trigger.New)
        {
            if(ObjPartnerProgram.LX_Program_Enrolled__c!=null)
                {
                    LX_Partner_Program__c Lx_GlobalLevelRecord= Lx_MapPartnerProgram.get(ObjPartnerProgram.LX_Program_Enrolled__c);
                    if(Lx_GlobalLevelRecord!=null)
                    {
                        //set values from Parent Partner program
                        ObjPartnerProgram.LX_Party_Type__c=Lx_GlobalLevelRecord.LX_Party_Type__c;
                        ObjPartnerProgram.ISS_Capability_Segment__c=Lx_GlobalLevelRecord.ISS_Capability_Segment__c;
                        ObjPartnerProgram.Primary_Lexmark_Vertical_Focus__c=Lx_GlobalLevelRecord.Primary_Lexmark_Vertical_Focus__c;
                    }
                    
                }
        }*/
        }
   
   System.debug('===Parent_LX_List_GlobalProgramId='+Parent_LX_List_GlobalProgramId);
   /* 
     if(Trigger.IsAfter)
     {
        //Commented by arun thakur :DE241
        //Get parent Partner program values 
        List<LX_Partner_Program__c>  List_Update_LX_Partner_Program=new List<LX_Partner_Program__c>();
        if(Trigger.newMap!=null)
        for(LX_Partner_Program__c ObjPartnerProgram:[select id,LX_Program_Enrolled__c,LX_Party_Type__c,ISS_Capability_Segment__c,Primary_Lexmark_Vertical_Focus__c
        from LX_Partner_Program__c where LX_Program_Enrolled__c in :Parent_LX_List_GlobalProgramId])
        {
        System.debug('===============================ObjLX_Partner_Program='+ObjPartnerProgram);
            LX_Partner_Program__c Lx_GlobalLevelRecord=Trigger.newMap.get(ObjPartnerProgram.LX_Program_Enrolled__c);
             System.debug('===============================ObjParentPartnerProgram='+Lx_GlobalLevelRecord);
            if(Lx_GlobalLevelRecord!=null)
            {
                    ObjPartnerProgram.LX_Party_Type__c=Lx_GlobalLevelRecord.LX_Party_Type__c;
                    ObjPartnerProgram.ISS_Capability_Segment__c=Lx_GlobalLevelRecord.ISS_Capability_Segment__c;
                    ObjPartnerProgram.Primary_Lexmark_Vertical_Focus__c=Lx_GlobalLevelRecord.Primary_Lexmark_Vertical_Focus__c;
                    List_Update_LX_Partner_Program.add(ObjPartnerProgram);
            }
            
        }
        System.debug('===============================List_Update_LX_Partner_Program='+List_Update_LX_Partner_Program);
        if(!List_Update_LX_Partner_Program.IsEmpty())
        update List_Update_LX_Partner_Program;

        }*/
        
    
    

}