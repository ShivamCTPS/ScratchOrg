//Case is created & Case Origin is Phone, Set Priority as High, else set Priority as Low
trigger caseTrigger on Case (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        if(!Trigger.new.isEmpty()){
            for(Case cas : Trigger.new){
            If(cas.Origin == 'Phone'){
                cas.Priority = 'High';
            	}
                else(cas.Priority = 'Low');
        	}
        }
    }
}