public class StripeCustomerSyncHelper {

    /*
    @future(callout=true)
    public static void syncStripeCustomers() {
        Integer recordsInserted = 0;
        String status = 'Completed';
        String errorMsg = null;

        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://api.stripe.com/v1/customers');
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');

            // Add Stripe API key from Custom Label
            String apiKey = Label.ApiKey; // Ensure this label exists with your Stripe secret key
            String authHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(apiKey + ':'));
            req.setHeader('Authorization', authHeader);

            System.debug('⚠️ Making Stripe API call...');
            Http http = new Http();
            HttpResponse res = http.send(req);

            System.debug('✅ Response Code: ' + res.getStatusCode());
            System.debug('📦 Response Body: ' + res.getBody());

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> dataList = (List<Object>) responseMap.get('data');

                Set<String> incomingStripeIds = new Set<String>();
                for (Object obj : dataList) {
                    Map<String, Object> stripeMap = (Map<String, Object>) obj;
                    incomingStripeIds.add((String) stripeMap.get('id'));
                }

                Map<String, Stripe_Customer__c> existingMap = new Map<String, Stripe_Customer__c>(
                    [SELECT Stripe_Id__c FROM Stripe_Customer__c WHERE Stripe_Id__c IN :incomingStripeIds]
                );

                List<Stripe_Customer__c> toInsert = new List<Stripe_Customer__c>();
                for (Object obj : dataList) {
                    Map<String, Object> stripeMap = (Map<String, Object>) obj;
                    String stripeId = (String) stripeMap.get('id');

                    if (!existingMap.containsKey(stripeId)) {
                        Stripe_Customer__c customer = new Stripe_Customer__c(
                            Stripe_Id__c = stripeId,
                            Email__c = (String) stripeMap.get('email'),
                            Name__c = (String) stripeMap.get('name'),
                            Created_At__c = DateTime.newInstance(((Integer) stripeMap.get('created')) * 1000)
                        );
                        toInsert.add(customer);
                    }
                }

                if (!toInsert.isEmpty()) {
                    insert toInsert;
                    recordsInserted = toInsert.size();
                }

            } else {
                status = 'Failed';
                errorMsg = 'Stripe API error: ' + res.getStatus() + ' - ' + res.getBody();
            }

        } catch (Exception e) {
            status = 'Failed';
            errorMsg = e.getMessage();
        }

        // Log results
        StripeSyncLogger.logSync(status, recordsInserted, errorMsg, UserInfo.getName());
    }
        */
}
