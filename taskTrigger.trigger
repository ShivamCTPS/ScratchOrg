//task is created set the priority to High
trigger taskTrigger on Task (before insert, before Update) {    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        if(!Trigger.new.isEmpty())
        for(Task task : Trigger.new){
            system.debug('Found task record');
            //if(task.Priority == Shi){ // These required fields must be completed: Priority
                task.Priority = 'High';
            	//}
            }
        } 
    }