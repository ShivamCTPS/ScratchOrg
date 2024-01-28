//if opp is modified, update an Opp amount based on probablity * expected revenue
trigger oppTrigger on Opportunity (before update, after update,after Insert, after Delete, after Undelete) {
    
    if(Trigger.isBefore && Trigger.isUpdate){
        oppTriggerHandler.handleActivitiesBeforeUpdate(Trigger.new, Trigger.old);
        
        system.debug('Trigger.new ='+ Trigger.new);
        system.debug('Trigger.old ='+ Trigger.old);
        system.debug('Trigger.newMap ='+ Trigger.newMap);
        system.debug('Trigger.oldMap ='+ Trigger.oldMap);
    }
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        oppTriggerHandler.handleActivitiesAccount(Trigger.new, null);
            }
    else if(Trigger.isAfter && Trigger.isUpdate){
        oppTriggerHandler.handleActivitiesAccount(Trigger.new, Trigger.oldMap);
    }
    else if(Trigger.isAfter && Trigger.isDelete){
        oppTriggerHandler.handleActivitiesAccount(Trigger.new, null);
    }
}