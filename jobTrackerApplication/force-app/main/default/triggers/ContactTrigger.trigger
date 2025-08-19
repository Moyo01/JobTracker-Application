trigger ContactTrigger on Contact (after insert, after update) {
    if (Trigger.isAfter) {
        incomeCalculator.updateContact(Trigger.newMap, Trigger.oldMap);
    }
} 