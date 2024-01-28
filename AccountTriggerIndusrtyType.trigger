//If an Account with Indusrty Agriculture and Type Prospect is updated and Ownership is set to Private, 
//do not allow user to set this ownership
trigger AccountTriggerIndusrtyType on Account (before update) {
	
    if(Trigger.isBefore && Trigger.isUpdate){
        
    }
}