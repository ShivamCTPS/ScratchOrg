public class UserTriggerHandler implements Queueable {
    private List<Id> deactivatedUsersIds;

    public UserTriggerHandler(List<Id> deactivatedUsersIds) {
        this.deactivatedUsersIds = deactivatedUsersIds;
    }

    public void execute(QueueableContext context) {
        try {
            // Bulkify queries and process data outside of the loop
            Map<Id, Id> managerUserMap = new Map<Id, Id>();

            for (User deactivatedUser : [SELECT Id, ManagerId FROM User WHERE Id IN :deactivatedUsersIds]) {
                managerUserMap.put(deactivatedUser.Id, deactivatedUser.ManagerId);
            }

            List<Account> accountRecords = [SELECT Id, OwnerId FROM Account WHERE OwnerId IN :deactivatedUsersIds];
            List<Contact> contactRecords = [SELECT Id, OwnerId FROM Contact WHERE OwnerId IN :deactivatedUsersIds];

            for (Account acc : accountRecords) {
                acc.OwnerId = managerUserMap.get(acc.OwnerId);
            }
            for (Contact con : contactRecords) {
                con.OwnerId = managerUserMap.get(con.OwnerId);
            }

            // Perform DML operations outside of the loop
            update accountRecords;
            update contactRecords;
        } catch (Exception e) {
            // Handle exceptions appropriately
            System.debug('An error occurred: ' + e.getMessage());
        }
    }
     

    public static void assignPermissionSet(List<User> userList) {
        //Typically these would be set in a constant class
        String salesConsoleUser = 'Salesforce Console User';
        //String consultantPermissionName = 'Consultant_Permissions';

        //Store permission set Ids
        Id salesConsoleUserId;
        //Id consultantPermissionId;

        for (PermissionSet permission : [SELECT Id, Name FROM PermissionSet WHERE Name = :salesConsoleUser ]) {
            if (permission.Name == salesConsoleUser) {
                salesConsoleUserId = permission.Id;
            } 
        }

        // Here we will create a list of permission assignments for the user records
        List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();

        for (User userRecord : userList) {
            PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment();

            // Check if the user is a consultant
            if (userRecord.Username.endsWith('.consultant')) {
                // Set permission id to consultant permission set id
                permissionSetAssignment.PermissionSetId = salesConsoleUserId;
            }
            
            // Assign permission set to user
            permissionSetAssignment.AssigneeId = userRecord.Id;

            permissionSetAssignments.add(permissionSetAssignment);
        }

        // Insert the PermissionSetAssignment records to assign the permission set
        insert permissionSetAssignments;
    }
}