public with sharing class StripeCustomerSyncBatch implements Schedulable, Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts {

    private static final String STRIPE_API_URL = 'https://api.stripe.com/v1/customers';

    public void execute(SchedulableContext sc) {
        Database.executeBatch(this, 1);
    }

    public Iterable<String> start(Database.BatchableContext bc) {
        return new List<String>{ 'StartSync' };
    }

    public void execute(Database.BatchableContext bc, List<String> scope) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(STRIPE_API_URL);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        String apiKey = Label.ApiKey;
        String authHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(apiKey + ':'));
        req.setHeader('Authorization', authHeader);

        Integer recordsInserted = 0;

        try {
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> dataList = (List<Object>) responseMap.get('data');

                if (dataList == null || dataList.isEmpty()) {
                    StripeSyncLogger.logSync('Completed', 0, 'No customers returned from Stripe.');
                    return;
                }

                // Collect all incoming Stripe IDs
                Set<String> incomingIds = new Set<String>();
                for (Object obj : dataList) {
                    Map<String, Object> stripeMap = (Map<String, Object>) obj;
                    String stripeId = (String) stripeMap.get('id');
                    if (String.isNotBlank(stripeId)) {
                        incomingIds.add(stripeId);
                    }
                }

                // Query Salesforce once for existing Stripe IDs
                Set<String> existingStripeIds = new Set<String>();
                for (Stripe_Customer__c existing : [
                    SELECT Stripe_Id__c FROM Stripe_Customer__c WHERE Stripe_Id__c IN :incomingIds
                ]) {
                    existingStripeIds.add(existing.Stripe_Id__c);
                }

                // Only build records for new Stripe IDs
                List<Stripe_Customer__c> newCustomers = new List<Stripe_Customer__c>();

                for (Object obj : dataList) {
                    Map<String, Object> stripeMap = (Map<String, Object>) obj;
                    String stripeId = (String) stripeMap.get('id');

                    // Skip existing records entirely
                    if (String.isBlank(stripeId) || existingStripeIds.contains(stripeId)) {
                        continue;
                    }

                    Stripe_Customer__c newCustomer = new Stripe_Customer__c();
                    newCustomer.Stripe_Id__c = stripeId;
                    newCustomer.Email__c = (String) stripeMap.get('email');
                    newCustomer.Name__c = (String) stripeMap.get('name');

                    if (stripeMap.containsKey('created')) {
                        Object createdRaw = stripeMap.get('created');
                        if (createdRaw instanceof Integer) {
                            Integer createdUnix = (Integer) createdRaw;
                            newCustomer.Created_At__c = DateTime.newInstance(createdUnix * 1000L);
                        }
                    }

                    newCustomers.add(newCustomer);
                }

                if (!newCustomers.isEmpty()) {
                    insert newCustomers;
                    recordsInserted = newCustomers.size();
                }

                StripeSyncLogger.logSync('Completed', recordsInserted, null);

            } else {
                String errorMessage = 'Stripe API failed: ' + res.getStatus() + ' - ' + res.getBody();
                StripeSyncLogger.logSync('Failed', 0, errorMessage);
            }

        } catch (Exception ex) {
            String errorMessage = 'Exception: ' + ex.getMessage();
            StripeSyncLogger.logSync('Error', 0, errorMessage);
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Stripe customer sync batch completed.');
    }
}
