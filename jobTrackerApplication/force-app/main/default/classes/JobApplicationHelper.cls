public with sharing class JobApplicationHelper {


    // if the primary contact is null and there is at least one related contact.
    // Use the first contact available in the contact-related list or the first contact related to the Company(Account).

    public static void assignPrimaryContacts(List<Job_Tracker__c> jobApps) {
    Set<Id> jobAppIds = new Set<Id>();
    Set<Id> inferredAccountIds = new Set<Id>();

    // Step 1: Collect Job Apps missing Primary Contact
    if(!jobApps.isEmpty()){
        for (Job_Tracker__c job : jobApps) {
        if (job.Primary_Contact__c == null) {
            jobAppIds.add(job.Id);
            if(job.Account__c != null) {
                inferredAccountIds.add(job.Account__c);
            }
        }
    }
    }

    // Step 2: Get all Contacts related to these Job Apps
    Map<Id, List<Contact>> jobToContacts = new Map<Id, List<Contact>>();
    Map<Id, Id> jobToAccountId = new Map<Id, Id>();

    List<Contact> jobContacts = [
        SELECT Id, Job_Tracker__c, AccountId
        FROM Contact
        WHERE Job_Tracker__c IN :jobAppIds
    ];

    for (Contact con : jobContacts) {
        if (!jobToContacts.containsKey(con.Job_Tracker__c)) {
            jobToContacts.put(con.Job_Tracker__c, new List<Contact>());
        }
        jobToContacts.get(con.Job_Tracker__c).add(con);

        // Capture account ID for fallback
        if (con.AccountId != null) {
            jobToAccountId.put(con.Job_Tracker__c, con.AccountId); // for contacts with job tracker account
            inferredAccountIds.add(con.AccountId); // added to inferredAccountIds
        }
    }

    // Step 3: Get Contacts grouped by Account
    Map<Id, List<Contact>> accountToContacts = new Map<Id, List<Contact>>();
    List<Contact> conlist = new list<Contact>([
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :inferredAccountIds
            ORDER BY CreatedDate ASC
        ]);
        // to group contacts with account
    if (!inferredAccountIds.isEmpty()) {
        for (Contact con : conlist ) {
            if (!accountToContacts.containsKey(con.AccountId)) {
                accountToContacts.put(con.AccountId, new List<Contact>());
            }
            accountToContacts.get(con.AccountId).add(con);
        }
    }

    // Step 4: Assign Primary Contacts
    for (Job_Tracker__c job : jobApps) {
        if (job.Primary_Contact__c != null) continue;

        // First: Directly related contacts
        if (jobToContacts.containsKey(job.Id) && !jobToContacts.get(job.Id).isEmpty()) {
            job.Primary_Contact__c = jobToContacts.get(job.Id)[0].Id;
        }
        // check if account field is empty and there is no primary contact on job
        else if (job.Account__c != null) {
    Id acctId = job.Account__c;
    if (accountToContacts.containsKey(acctId) && !accountToContacts.get(acctId).isEmpty()) {
        job.Primary_Contact__c = accountToContacts.get(acctId)[0].Id;
    }
}

    }
}

}
