public with sharing class JobTrackerController {

    @AuraEnabled(cacheable=true)
public static List<Job_Tracker__c> getJobsFromAPI(String searchTerm) {
    if (!Schema.sObjectType.Job_Tracker__c.isAccessible()) {
        throw new AuraHandledException('You do not have access to Job Tracker records.');
    }

    String query;

    if (String.isNotBlank(searchTerm)) {
        String searchKey = '%' + searchTerm + '%';
        query = 'SELECT Id, Position_Title__c, Company_Name__c, Status__c, URL__c ' +
                'FROM Job_Tracker__c ' +
                'WHERE Position_Title__c LIKE :searchKey OR Company_Name__c LIKE :searchKey ' +
                'LIMIT 30';
    } else {
        query = 'SELECT Id, Position_Title__c, Company_Name__c, Status__c, URL__c ' +
                'FROM Job_Tracker__c ' +
                'LIMIT 50';
    }

    List<sObject> sObjectList = Database.query(query);
    return (List<Job_Tracker__c>)sObjectList;
}


    @AuraEnabled(cacheable=true)
    public static jobTrackerWrapper jobDetails(String jobId) {
        if (String.isBlank(jobId)) {
            throw new AuraHandledException('Job ID is required.');
        }

        Job_Tracker__c jobInfo = [
            SELECT 
                Id,
                Position_Title__c,
                Company_Name__c,
                Status__c,
                URL__c,
                Location__c
            FROM Job_Tracker__c 
            WHERE Id = :jobId
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        jobTrackerWrapper job = new jobTrackerWrapper();
        job.job = jobInfo;

        return job;
    }

    public class jobTrackerWrapper {
        @AuraEnabled 
        public Job_Tracker__c job { get; set; }
    }


    @AuraEnabled
    public static List<Job_Tracker__c> insertSelectedJobs(List<Job_Tracker__c> selectedJobs, Id contactId) {
        List<Job_Tracker__c> jobsToInsert = new List<Job_Tracker__c>();
    
        for (Job_Tracker__c job : selectedJobs) {
            Job_Tracker__c newJob = new Job_Tracker__c();
            newJob.Name = job.Name;
            newJob.Salary__c = job.Salary__c;
            newJob.Location__c = job.Location__c;
            newJob.URL__c = job.URL__c;
            newJob.Primary_Contact__c = contactId;
            jobsToInsert.add(newJob);
        }
    
        insert jobsToInsert;
        return jobsToInsert; // ✅ Return inserted records
    }
    
}
