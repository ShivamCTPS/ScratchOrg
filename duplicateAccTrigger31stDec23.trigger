/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-31-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Trigger to prevent duplication of account record based on name whenever a record is insterted or updated
trigger duplicateAccTrigger31stDec23 on Account (before insert, before Update) {

    // Map<String, Account> accMap = new Map<String, Account>();
    // if (Trigger.isBefore && Trigger.isInsert){
    //     if(!Trigger.new.isEmpty()){
    //         for(Account acc : Trigger.new){
    //             accMap.put(acc.Name, acc);
    //         }
    //     }
    // }
    // if (Trigger.isBefore && Trigger.isUpdate){
    //     if(!Trigger.new.isEmpty()){
    //         for(Account acc : Trigger.new){
    //             if (Trigger.oldMap.get(acc.Id).Name != acc.Name) {
    //                 accMap.put(acc.Name, acc);
    //             }
    //         }
    //     }
    // }
    // List<Account> existingRecords = [SELECT Id, Name FROM Account WHERE Name IN :accMap.keySet()];
    // if (!existingRecords.isEmpty()) {
    //     for (Account accObj : existingRecords) {
    //         if (accObj.Name != null && accMap.containsKey(accObj.Name)) {
    //             System.debug('Duplicate Account Name: @32' + accObj.Name);
    //             accMap.get(accObj.Name).addError('Account is already created with this name. Please enter a unique name.');
    //         }
    //     }
    // }
    set<String> accNames = new set<String>();

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        if(!Trigger.new.isEmpty()){
            for(Account ac : Trigger.new){
                accNames.add(ac.Name);
            }
        }
    }
    List<Account> accList = [SELECT Id, Name FROM Account WHERE Name IN :accNames];

    //Map<Id,Account> existingAccMap = new Map<Id,Account>();
    Map<String, Id> existingAccMap = new Map<String, Id>();

    if(!accList.isEmpty()){
        for(Account acct : accList){
            existingAccMap.put(acct.Name, acct.Id);
        }
        if(!Trigger.new.isEmpty()){
            for (Account accObj : Trigger.new) {
                //if(existingAccMap.containsKey(accObj.Name)){
                    if (existingAccMap.containsKey(accObj.Name) && (Trigger.isInsert || existingAccMap.get(accObj.Name) != accObj.Id)) {
                    System.debug('Duplicate Account Name: ' + accObj.Name);
                    System.debug('Trigger.new: ' + Trigger.new);
                    accObj.addError('Account is already created with this name. Please enter a unique name. @58');
                }
            }
        }
    }
}