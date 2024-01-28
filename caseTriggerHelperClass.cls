public class caseTriggerHelperClass {
    public static void updateCaseNumber(List<Case> caseList){
        Set<Id> accIds = new Set<Id>(); //set to store parent account Id	
        if(!caseList.isEmpty()){
            for(Case caseObj:caseList){
                if(caseObj.AccountId != NULL){
                    accIds.add(caseObj.AccountId);
                }
            }
        }
        if(!accIds.isEmpty()){
            Map<Id,Account> accMap = new Map<Id,Account>([SELECT Id, Latest_Case_Inserted__c FROM Account 
                                                          WHERE Id IN:accIds]);
            
            Map<Id,Account> mapToUpdate = new Map<Id,Account>();
            if(!caseList.isEmpty()){
                for(Case caseRcd : caseList){
                    if(accMap.containsKey(caseRcd.AccountId)){
                        Account acc = accMap.get(caseRcd.AccountId);
                        if(acc.Latest_Case_Inserted__c != caseRcd.caseNumber){
                            acc.Latest_Case_Inserted__c = caseRcd.caseNumber;
                        }
                    }
                }
            }
            if(!mapToUpdate.isEmpty()){
                update mapToUpdate.Values();
            }
        }
    }
}