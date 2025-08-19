public with sharing class JoobleJobFetcherController {
    

    public class Job {
        public String title;
        public String location;
        public String company;
        public String link;
    }

    public class JoobleResponse {
        public List<Job> jobs;
    }

    @future(callout=true)
    public static void fetchJoobleJobs() {
        String apiKey = 'c7f60933-f1a8-4b15-85c7-c0064878aa51';
        String endpoint = 'https://jooble.org/api/' + apiKey;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        // Request payload
        String body = JSON.serialize(new Map<String, Object>{
            'keywords' => 'Salesforce',
            'location' => 'United States',
            'page' => 1
        });
        req.setBody(body);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            system.debug('res.getStatusCode()' + res.getStatusCode());
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            List<Object> jobs = (List<Object>) result.get('jobs');
            List<Job_Tracker__c> applicationsToInsert = new List<Job_Tracker__c>();

            for (Object jobObj : jobs) {
                Map<String, Object> job = (Map<String, Object>) jobObj;

                applicationsToInsert.add(new Job_Tracker__c(
                    Position_Title__c = (String) job.get('title'),
                    Company_Name__c = (String) job.get('company'),
                    Location__c = (String) job.get('location'),
                    URL__c = (String) job.get('link'),
                    Status__c = 'Saved'
                ));
            }

            if (!applicationsToInsert.isEmpty()) {
                insert applicationsToInsert;
            }
        } else {
            System.debug('Jooble API call failed: ' + res.getBody());
        }
    }
}