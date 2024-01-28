/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// Trigger so that every time any account is inserted then set the Industry to Education. 
// Also check if the discription is blank than set the value to 'Account Description is Blank' 
// apex trigger when account is created or updated set the value of shipping address to billing address 
// 3. You only need to update the shipping address info with Billing address is having blank value.
trigger AccountTriggerIndustryDescription010124 on Account (before insert, before Update) {

	List<Account> accList = new List<account>();    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        if(!Trigger.new.isEmpty())
        for (Account acc : Trigger.new){
                if(acc.Industry == null) { // null check for Industry field
                    acc.Industry = 'Education';
                }
                if(acc.Description == null) { // null check for Description field
                    acc.Description = 'Account Description is Blank';
        	}
            if(acc.BillingStreet == null)
                acc.shippingStreet 		= acc.BillingStreet;
            
                        // acc.shippingStreet 		= acc.BillingStreet;
                        // acc.shippingCity 		= acc.BillingCity;
                        // acc.shippingState 		= acc.BillingState;
                        // acc.shippingPostalCode 	= acc.BillingPostalCode;
                        // acc.shippingCountry 	= acc.BillingCountry;
        }
    }		  
}