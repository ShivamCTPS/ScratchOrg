//lead record is updated, set the status to Working - Contacted
trigger leadTrigger on Lead (before update) {
    if(Trigger.isBefore && Trigger.isUpdate){
    for(Lead lead : Trigger.new){
        if(!Trigger.new.isEmpty()){
            lead.Status = 'Working - Contacted';
//Whenever a Lead is updated and Industry is Healthcare, set Lead Source as purchased, SIC Code (Zip/Postal Code) as 1100 and Rating as Hot
            if(lead.Industry == 'Healthcare'){
                lead.PostalCode = '1100';
                lead.LeadSource = 'Purchased List';
            	}
    		}  
     	}
    }
}