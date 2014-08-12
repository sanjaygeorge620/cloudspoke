/**
 * Author : Pruthvi Ayireddy
 * Date: 06/30/2014 
 * Description : To implement the logic for the trigger which updates the reference owner whenever there is an update in the 
 *          MPS Contract,Lighthouse and Managed Reference Account fields. 
 */

public class PopulateRefernceOwnerFieldHandler{
    public static void updateReferenceOwner(List<Account> newList,Map<Id,Account> oldMap)
    {
        try{
            List<refedge__Reference_Basic_Information__c> updateReferenceProfile = new List<refedge__Reference_Basic_Information__c>();
            Map<String,Environment_Variable__c> customSettingMap = Environment_Variable__c.getAll();
            Set<Id> accIdSet = new Set<Id>();
            for(Account refAcc : newList){
                if(refAcc.MPS_Contract__c != oldMap.get(refAcc.Id).MPS_Contract__c || refAcc.Lighthouse__c != oldMap.get(refAcc.Id).Lighthouse__c || refAcc.Local_Priority__c != oldMap.get(refAcc.Id).Local_Priority__c
                   || refAcc.refedge__Managed_Reference_Account__c != oldMap.get(refAcc.Id).refedge__Managed_Reference_Account__c || refAcc.LX_Geo__c != oldMap.get(refAcc.Id).LX_Geo__c || refAcc.Physical_Country__c != oldMap.get(refAcc.Id).Physical_Country__c){
                        accIdSet.add(refAcc.Id);
                        System.debug('The Account Id is added to the accIdSet');
                   }
            }
      Map<string,Id> username = new Map<string,Id>();
            for(user u:[select name,Id from User where Name IN ('Jeanne Talbot','Oliver Friend','Natalia Pastrana','Suzanne Tylka','Andrew Leung')]){
                username.put(u.name,u.id);
            }  

            
            if(!accIdSet.isEmpty()){
            Map<Id,List<refedge__Reference_Basic_Information__c>> accMap = new Map<Id,List<refedge__Reference_Basic_Information__c>>(); 
              for (refedge__Reference_Basic_Information__c refProfileMap : [Select Id,refedge__Account__c,refedge__Reference_Owner__c,refedge__Managed_Reference_Account__c from refedge__Reference_Basic_Information__c where 
                                                                    refedge__Account__c IN: accIdSet]){
                if(accMap.containsKey(refProfileMap.refedge__Account__c))
                {
                    accMap.get(refProfileMap.refedge__Account__c).add(refProfileMap);
                }
                else{
                    List<refedge__Reference_Basic_Information__c> temp = new List<refedge__Reference_Basic_Information__c>();
                    temp.add(refProfileMap);
                    accMap.put(refProfileMap.refedge__Account__c,temp);
                }
            }
            for(Account refAcc : newList){
                if(refAcc.MPS_Contract__c != oldMap.get(refAcc.Id).MPS_Contract__c || refAcc.Lighthouse__c != oldMap.get(refAcc.Id).Lighthouse__c || refAcc.Local_Priority__c != oldMap.get(refAcc.Id).Local_Priority__c
                   || refAcc.refedge__Managed_Reference_Account__c != oldMap.get(refAcc.Id).refedge__Managed_Reference_Account__c || refAcc.LX_Geo__c != oldMap.get(refAcc.Id).LX_Geo__c || refAcc.Physical_Country__c != oldMap.get(refAcc.Id).Physical_Country__c){
                        if(accMap.containskey(refAcc.Id)){
                           for (refedge__Reference_Basic_Information__c refProfileMap : accMap.get(refAcc.id))
                           {
                               system.debug('**- Entered into For Loop');
                            // if(refProfileMap.refedge__Reference_Owner__c != customSettingMap.get('RefEdge.ReferenceOwner1').Value__c && refProfileMap.refedge__Reference_Owner__c != customSettingMap.get('RefEdge.ReferenceOwner2').Value__c){  
                            // if((refAcc.Lighthouse__c == 'Yes' || refAcc.MPS_Contract__c == 'Yes') && !refProfileMap.refedge__Managed_Reference_Account__c){
                               if(refAcc.LX_Software_AEX__c != null && refAcc.Lighthouse__c == 'Yes' && refProfileMap.refedge__Reference_Owner__c == '' && !refProfileMap.refedge__Managed_Reference_Account__c){
                                   refProfileMap.refedge__Reference_Owner__c = refAcc.LX_Software_AEX__c;
                                  system.debug('**-Condition1  '+refAcc.Lighthouse__c+refProfileMap.refedge__Reference_Owner__c+refAcc.LX_Software_AEX__c);
                                   updateReferenceProfile.add(refProfileMap);
                               } else if(refAcc.MPS_Contract__c == 'Yes' && refAcc.LX_Geo__c == 'North America' && !refProfileMap.refedge__Managed_Reference_Account__c){
                               refProfileMap.refedge__Reference_Owner__c = username.get('Jeanne Talbot');
                               system.debug('**-Condition3  '+refAcc.MPS_Contract__c+refAcc.LX_Geo__c+refProfileMap.refedge__Reference_Owner__c);
                               updateReferenceProfile.add(refProfileMap);
                               } 
                            // }
                               else if(refAcc.LX_Software_AEX__c != null && (refAcc.Local_Priority__c == 'Target-1' || refAcc.Local_Priority__c == 'Target-2' || refAcc.Local_Priority__c == 'Target-3') && refAcc.Lighthouse__c == 'No' && !refProfileMap.refedge__Managed_Reference_Account__c){
                                 refProfileMap.refedge__Reference_Owner__c = refAcc.LX_Software_AEX__c;
                                 system.debug('**-Condition2  '+refAcc.Local_Priority__c+refAcc.Lighthouse__c+refAcc.LX_Software_AEX__c);
                                  updateReferenceProfile.add(refProfileMap);
                               
                              }else if(refProfileMap.refedge__Managed_Reference_Account__c){
                                     if(refAcc.LX_Geo__c == 'North America'){
                                         refProfileMap.refedge__Reference_Owner__c = username.get('Jeanne Talbot');
                                       system.debug('**-Condition4  '+refProfileMap.refedge__Managed_Reference_Account__c+refAcc.LX_Geo__c+refProfileMap.refedge__Reference_Owner__c);
                                         updateReferenceProfile.add(refProfileMap);
                                 } else if(refAcc.LX_Geo__c == 'EMEA'){
                                     refProfileMap.refedge__Reference_Owner__c = username.get('Oliver Friend');
                                    system.debug('**-Condition5  '+refProfileMap.refedge__Managed_Reference_Account__c+refAcc.LX_Geo__c+refProfileMap.refedge__Reference_Owner__c);
                                     updateReferenceProfile.add(refProfileMap);
                                   } else if(refAcc.LX_Geo__c == 'Latin America'){
                                       refProfileMap.refedge__Reference_Owner__c = username.get('Natalia Pastrana');
                                       system.debug('**-Condition6  '+refProfileMap.refedge__Managed_Reference_Account__c+refAcc.LX_Geo__c+refProfileMap.refedge__Reference_Owner__c );
                                       updateReferenceProfile.add(refProfileMap);
                                     } else if(refAcc.LX_Geo__c == 'Asia Pacific' && refAcc.Physical_Country__c != 'Australia') {
                                         refProfileMap.refedge__Reference_Owner__c = username.get('Andrew Leung');
                                        system.debug('**-Condition8  '+refProfileMap.refedge__Managed_Reference_Account__c+refAcc.LX_Geo__c+refProfileMap.refedge__Reference_Owner__c );
                                         updateReferenceProfile.add(refProfileMap);
                                        } else if(refAcc.Physical_Country__c == 'Australia'){
                                            refProfileMap.refedge__Reference_Owner__c = username.get('Suzanne Tylka');
                                            system.debug('**-Condition7  '+refProfileMap.refedge__Managed_Reference_Account__c+refAcc.LX_Geo__c+refProfileMap.refedge__Reference_Owner__c);
                                            updateReferenceProfile.add(refProfileMap);
                                        }
                                     }
                                 // }
                           }
                        }                       
                    }
                } 
             update updateReferenceProfile;
            }
        }
        catch(Exception e){
            System.debug('Exception thrown in the method :: updateReferenceOwner '+e.getMessage());
        }
    }
}