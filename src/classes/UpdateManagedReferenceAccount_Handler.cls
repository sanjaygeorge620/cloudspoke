/**
 * Author : Pruthvi Ayireddy
 * Date: 07/01/2014 
 * Description : To implement the logic for the trigger which updates the Managed Reference Account field on account whenever there is an update in the 
 *          Managed Reference Account field. 
 */

public class UpdateManagedReferenceAccount_Handler{
    public static void updateReferenceAccount(List<refedge__Reference_Basic_Information__c> newList, Map<Id,refedge__Reference_Basic_Information__c> oldMap, Boolean isInsert){
        try{
            Set<Id> refIdSet = new Set<Id>();
            for(refedge__Reference_Basic_Information__c rfmgacc : newList){
                if(isInsert || rfmgacc.refedge__Managed_Reference_Account__c != oldMap.get(rfmgacc.Id).refedge__Managed_Reference_Account__c){
                    refIdSet.add(rfmgacc.refedge__Account__c);
                }
                System.debug('Id in refIdSet is : '+rfmgacc.refedge__Account__c);
            }
            if(!refIdSet.isEmpty()){
                Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Name,refedge__Managed_Reference_Account__c from Account where Id IN: refIdSet]);
                
                for(refedge__Reference_Basic_Information__c rfmgacc : newList){
                    if(isInsert || rfmgacc.refedge__Managed_Reference_Account__c != oldMap.get(rfmgacc.Id).refedge__Managed_Reference_Account__c){
                        accMap.get(rfmgacc.refedge__Account__c).refedge__Managed_Reference_Account__c = rfmgacc.refedge__Managed_Reference_Account__c;
                    }
                }
                update accMap.values();
            }
        }
        catch(Exception e){
            System.debug('Exception thrown in the method :: updateReferenceAccount :: '+e.getMessage());
        }    
    }
    
    public static void populateReferenceAccount(List<refedge__Reference_Basic_Information__c> newList, Map<Id,refedge__Reference_Basic_Information__c> oldMap, Boolean isInsert){
        try{
            Map<String,Environment_Variable__c> customSettingMap = Environment_Variable__c.getAll();
            Set<Id> refSet = new Set<Id>();
            for(refedge__Reference_Basic_Information__c rfchk : newList){
                if(isInsert || (rfchk.refedge__Managed_Reference_Account__c != oldMap.get(rfchk.Id).refedge__Managed_Reference_Account__c) && rfchk.refedge__Managed_Reference_Account__c == true){
                    refSet.add(rfchk.Id);
                }
                System.debug('Id in refIdSet is : '+rfchk.Id);
            }
            if(!refSet.isEmpty()){
                Map<Id,refedge__Reference_Basic_Information__c> newMap= new Map<Id,refedge__Reference_Basic_Information__c>([Select Id,Name,refedge__Managed_Reference_Account__c,refedge__Reference_Owner__c 
                                                                                                                       from refedge__Reference_Basic_Information__c where Id IN: refSet]);
            	for(refedge__Reference_Basic_Information__c rfchk : newList){
                	if(isInsert || (rfchk.refedge__Managed_Reference_Account__c != oldMap.get(rfchk.Id).refedge__Managed_Reference_Account__c  && rfchk.refedge__Managed_Reference_Account__c == true)){
                           if(rfchk.refedge__Reference_Owner__c != customSettingMap.get('RefEdge.ReferenceOwner1').Value__c 
                       		   && rfchk.refedge__Reference_Owner__c != customSettingMap.get('RefEdge.ReferenceOwner2').Value__c){
                    			newMap.get(rfchk.Id).refedge__Reference_Owner__c = customSettingMap.get('RefEdge.ReferenceOwner3').Value__c;
                           }
                	}
            	}
                update newMap.values();
            }
        }
        catch(Exception e){
           System.debug('Exception thrown in the method :: populateReferenceAccount :: '+e.getMessage()); 
        }
    }
}