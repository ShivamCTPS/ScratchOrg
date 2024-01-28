trigger UpdateAccountLatestCase on Case (after insert) {
    List<Id> accountIds = new List<Id>();
    
    for (Case newCase : Trigger.new) {
        accountIds.add(newCase.AccountId);
    }
    
    List<Account> accountsToUpdate = [
        SELECT Id, Latest_Case_Inserted__c,
        (SELECT CaseNumber FROM Cases ORDER BY CreatedDate DESC LIMIT 1)
        FROM Account WHERE Id IN :accountIds
    ];

    for (Account acc : accountsToUpdate) {
        if (acc.Cases.size() > 0) {
            acc.Latest_Case_Inserted__c = acc.Cases[0].CaseNumber;
        }
    }

    update accountsToUpdate;
}