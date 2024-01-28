/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * 𝑾𝒉𝒆𝒏𝒆𝒗𝒆𝒓 𝒂 𝒖𝒔𝒆𝒓 𝒊𝒔 𝒅𝒆𝒂𝒄𝒕𝒊𝒗𝒂𝒕𝒆𝒅 𝒂𝒔𝒔𝒊𝒈𝒏 𝒂𝒍𝒍 𝒉𝒊𝒔/𝒉𝒆𝒓 𝒂𝒄𝒄𝒐𝒖𝒏𝒕𝒔 𝒂𝒏𝒅 𝒄𝒐𝒏𝒕𝒂𝒄𝒕 𝒕𝒐 𝒕𝒉𝒆 𝒓𝒆𝒔𝒑𝒆𝒄𝒕𝒊𝒗𝒆 𝒖𝒔𝒆𝒓'𝒔 𝒎𝒂𝒏𝒂𝒈𝒆𝒓. 
 * 𝑼𝒔𝒆𝒓 - 𝒊𝒔 𝑨𝒄𝒕𝒊𝒗𝒆(𝑩𝒐𝒐𝒍𝒆𝒂𝒏) 𝑼𝒔𝒆𝒓 - 𝑴𝒂𝒏𝒂𝒈𝒆𝒓 𝑰𝒅(𝑼𝒔𝒆𝒓 𝒍𝒐𝒐𝒌𝒖𝒑)
**/
trigger userTrigger04012024 on User (after update, after Insert) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Id> deactivatedUsersIds = new List<Id>();

        // Bulkification: Move logic outside of the loop
        for (User user : Trigger.new) {
            if (!user.IsActive) {
                deactivatedUsersIds.add(user.Id);
            }
        }

        if (!deactivatedUsersIds.isEmpty()) {
            try {
                // Enqueue job for asynchronous processing
                System.enqueueJob(new UserTriggerHandler(deactivatedUsersIds));
            } catch (Exception e) {
                // Handle exceptions appropriately
                System.debug('An error occurred: ' + e.getMessage());
            }
        }
    }
//Automatically Assign a Permission Set (any for time being) to New User. ==>Assign Permission Set To New User --> Not Working, will check in future
    // if (Trigger.isAfter && Trigger.isInsert) {
     //   UserTriggerHandler.assignPermissionSet(Trigger.new);
   // }
}