//When a value is enterd in the 'NumberOfLocations__c' of account,contact will be created accordingly. 
//Upon an update if number increased or decrease contact should inc or dec
public class AccountTriggerHandler {
    public static void handleDeactivatedUsers(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
        Set<Id> newAccountIds = new Set<Id>();
        for (Account acc : newAccounts) {
            newAccountIds.add(acc.Id);
        }

        List<Account> newAccountList = [SELECT Id, Name, NumberOfLocations__c FROM Account WHERE Id IN :newAccountIds];

        List<Contact> createContactList = new List<Contact>();
        List<Contact> contactListToDelete = new List<Contact>();

        for (Account newAccount : newAccountList) {
            if (oldAccounts == null) {
                countAndCreate(newAccount, newAccount.NumberOfLocations__c, createContactList);
            } else if (oldAccounts != null && newAccount.NumberOfLocations__c > oldAccounts.get(newAccount.Id).NumberOfLocations__c) {
                Decimal count = newAccount.NumberOfLocations__c - oldAccounts.get(newAccount.Id).NumberOfLocations__c;
                countAndCreate(newAccount, count, createContactList);
            } else if (oldAccounts != null && newAccount.NumberOfLocations__c < oldAccounts.get(newAccount.Id).NumberOfLocations__c) {
                Decimal count = oldAccounts.get(newAccount.Id).NumberOfLocations__c - newAccount.NumberOfLocations__c;
                deleteContacts(newAccount, count, contactListToDelete);
            }
        }
        if (!createContactList.isEmpty()) {
            insert createContactList;
        }
        if (!contactListToDelete.isEmpty()) {
            delete contactListToDelete;
        }
    }

    private static void countAndCreate(Account account, Decimal count, List<Contact> createContactList) {
        for (Integer i = 0; i < count.intValue(); i++) {
            Contact con = new Contact();
            con.AccountId = account.Id;
            con.LastName = account.Name;
            createContactList.add(con);
        }
    }

    private static void deleteContacts(Account account, Decimal count, List<Contact> contactListToDelete) {
        List<Contact> deleteContactList = [SELECT Id, AccountId FROM Contact WHERE AccountId = :account.Id LIMIT :count.intValue()];
        contactListToDelete.addAll(deleteContactList);
    }
    
    public static void handleActivitiesBeforeUpdate(List<Account> newRecords, Map<Id, Account> oldMap) {
    for (Account accRecords : newRecords) {
        if (accRecords.Industry == 'Agriculture' && accRecords.Type == 'Prospect') {
            Account oldRecord = oldMap.get(accRecords.Id);

            // Check for null to avoid potential null pointer exception
            if (oldRecord != null && oldRecord.Ownership != accRecords.Ownership && accRecords.Ownership =='Private') {
                accRecords.addError('Ownership cannot be modified');
            	}
        	}
    	}
	}
    public static void handleActivitiesAfterUpdate(List<Account> websiteRecords, Map<Id, Account> oldMap ){
        //List<Account> addAccountToUpdateChild = new List<Account>();
        Map<Id, String> accToWebsiteMap = new Map<Id, String>();
        //List<Account> addAccIdList = new List<Account>();
        
        for(Account accWeb : websiteRecords){
            //if(accWeb != oldMap.get(accWeb.Id).Website){
            if (!accWeb.Website.equals(oldMap.get(accWeb.Id))) {
                accToWebsiteMap.put(accWeb.Id, accWeb.Website);
                
                //addAccountToUpdateChild.add(accWeb);
                //addAccIdList.add(accWeb.Id);
            }
        }
        if(accToWebsiteMap.keySet().size() > 0){
            List<Contact> addConToUpdate = new List<Contact> ();
            List<Contact> conRecords = [SELECT ID, FirstName,Website__c,AccountId FROM Contact WHERE AccountId IN :accToWebsiteMap.keyset()];
            
            for(Contact con : conRecords){
                con.Website__c = accToWebsiteMap.get(con.AccountId);
                addConToUpdate.add(con);
            }
        
        if(addConToUpdate.size() > 0){
            update addConToUpdate;
        	}
        }
    }
}