trigger JobTrackerTrigger on Job_Tracker__c (before insert, before update) {
    if (Trigger.isBefore) {
        // Your helper if needed
        JobApplicationHelper.assignPrimaryContacts(Trigger.new);

        // Tax & pay calculations
        incomeCalculator.updateFromJobChanges(Trigger.newMap, Trigger.oldMap);
    }
}