/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-31-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// Prevent duplication of Contact records based on Email & Phone
trigger preventDuplication30thDec23 on Contact (before insert, before update) {
    // Map to store unique Email and Phone values
    Map<String, Contact> emailMap = new Map<String, Contact>();
    Map<String, Contact> phoneMap = new Map<String, Contact>();

    if (Trigger.isBefore && Trigger.isInsert) {
        if (!Trigger.new.isEmpty()) {
            for (Contact con : Trigger.new) {
                emailMap.put(con.Email, con);
                phoneMap.put(con.Phone, con);
            }
        }
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        if (!Trigger.new.isEmpty()) {
            for (Contact con : Trigger.new) {
                if (Trigger.oldMap.get(con.Id).Email != con.Email) {
                    emailMap.put(con.Email, con);
                }
                if (Trigger.oldMap.get(con.Id).Phone != con.Phone) {
                    phoneMap.put(con.Phone, con);
                }
            }
        }
    }
    String errorMessage = '';

    List<Contact> existingRecord = [SELECT Id, Email, Phone FROM Contact WHERE 
                                    Email IN :emailMap.keySet() OR Phone IN :phoneMap.keySet()];
    
    if (!existingRecord.isEmpty()) {
        for (Contact conObj : existingRecord) {
            if (conObj.Email != null && emailMap.get(conObj.Email) != null) {
                errorMessage = 'Email';
            }
            if (conObj.Phone != null && phoneMap.get(conObj.Phone) != null) {
                errorMessage = errorMessage + (errorMessage != '' ? ' and Phone' : 'Phone');
            }
        }

        if (!Trigger.new.isEmpty()) {
            for (Contact conObj : Trigger.new) {
                if(errorMessage != ''){
                conObj.addError('Your Contact ' + errorMessage + ' already exists in the system');
            	}
            }
        }
    }
}