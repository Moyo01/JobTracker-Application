public class StripeSyncLogger {
    public static void logSync(String status, Integer recordCount, String errorMsg) {
        try {
            Stripe_Sync_Log__c log = new Stripe_Sync_Log__c();
            log.Sync_Date__c = System.now();
            log.Status__c = status;
            log.Records_Processed__c = recordCount != null ? recordCount : 0;
            log.Error_Message__c = errorMsg;
            log.Triggered_By__c = UserInfo.getName();
            insert log;
        } catch (Exception e) {
            System.debug('⚠️ Failed to insert log: ' + e.getMessage());
        }
    }


    
}
