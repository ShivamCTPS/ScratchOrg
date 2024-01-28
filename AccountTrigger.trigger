//When a value is enterd in the 'NumberOfLocations__c' of account,contact will be created accordingly. 
//Upon an update if number increased or decrease contact should inc or dec
trigger AccountTrigger on Account (after insert, after update, before update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        //AccountTriggerHandler.handleDeactivatedUsers(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isBefore && Trigger.isUpdate){
        AccountTriggerHandler.handleActivitiesBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    
//Write a trigger Every time an account website is updated, 
//update the website field on all child contacts for the account
	if	(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.handleActivitiesAfterUpdate(Trigger.new, Trigger.oldMap);
    	}
    }