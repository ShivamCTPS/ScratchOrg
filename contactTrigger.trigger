//If a Contact is created without a parent Account, do not allow user to create the contact record
//https://www.youtube.com/watch?v=eNcDHmo0n3E&list=PLEKSN4V4WEnLERCMYfvLAfg6cYTSI4hc0&index=9
trigger contactTrigger on Contact (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        if(!Trigger.new.isEmpty()){
            for(Contact con : Trigger.new){
                if(con.AccountId == NULL){
                    con.AccountId.addError('Contacts must be associated with an Account.');
                }
            }
        }
    }
}