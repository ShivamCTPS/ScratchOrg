public class oppTriggerHandler {
    public static void handleActivitiesBeforeUpdate(List<Opportunity> newRecords, List<Opportunity> oldRecords) {
	}

    public static void handleActivitiesAfterUpdate(List<Opportunity> newRecords) {
        List<Task> taskListToInsert = new List<Task>();

        for (Opportunity opp : newRecords) {
            if (opp.StageName == 'Closed Won') {
                Task taskRecord = new Task();
                taskRecord.Priority = 'High';
                taskRecord.OwnerId = opp.OwnerId;
                taskRecord.Description = 'Please split revenue amongst the team member';
                taskRecord.Status = 'Not Started';
                taskRecord.Subject = 'Split Revenue';
                taskRecord.WhatId = opp.Id;
                taskListToInsert.add(taskRecord);
            }
        }
        if (!taskListToInsert.isEmpty()) {
            insert taskListToInsert;
        }
    }

    // When all Oppo linked to account are closed Won, update Account status to Closed.
    // However, if any Oppo is not closed Won, update the account status to Open
    // https://www.youtube.com/watch?v=T4YNSp43CKM&list=PLybpx-7sKOrSP3vUkMol1U197cNs_YIsD&index=26
    
    public static void handleActivitiesAccount(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
        
        List<Account> listToUpdate = new List<Account>();
        Set<Id> accIds = new Set<Id>(); //Set to store parent acc Ids
        if(!oppList.isEmpty()){
            for(Opportunity newOpp : oppList){
                if(oldMap != null){
                    Opportunity oldOpp = oldMap.get(newOpp.Id);
                    
                    if(oldOpp.AccountId != newOpp.AccountId){
                        accIds.add(oldOpp.AccountId);
                        accIds.add(newOpp.AccountId);
                    }
                    else if(oldOpp.StageName != newOpp.StageName){
                        accIds.add(newOpp.AccountId);
                    }
                }
                else{
                    accIds.add(newOpp.AccountId);
                }
            }
        }
        if(!accIds.isEmpty()){
            Map<Id, List<Opportunity>> accMap = new Map<Id,List<Opportunity>>();
            
            for(Opportunity oppObj : [SELECT Id, AccountId, StageName from Opportunity WHERE AccountId IN : accIds]){
                if(!accMap.containsKey(oppObj.AccountId)){
                    accMap.put(oppObj.AccountId, new List<Opportunity>());
                }
                accMap.get(oppObj.AccountId).add(oppObj); // return the value of map
            }
        
        for(Id ids : accMap.keySet()){
            List<Opportunity> accOpps = accMap.get(ids);
            
            if(!accOpps.isEmpty()){
                
                Boolean allClosedOpps = true;
                
                for(Opportunity opp : accOpps){
                    //if(!opp.StageName.equals('Closed Won')){
                    //if(opp != null && !opp.StageName.equals('Closed Won')){
                    if(opp != null && opp.StageName != null && !opp.StageName.equals('Closed Won')){
                        allClosedOpps = false;
                        break;
                    }
                }
                if(allClosedOpps){
                    listToUpdate.add(new Account(Id = ids, Account_Status__c = 'Closed'));
                }
                else{
                    listToUpdate.add(new Account(Id = ids, Account_Status__c = 'Open'));
                }
            }
        }
        if(!listToUpdate.isEmpty()){
            update listToUpdate;
        	}
        }
    }
}