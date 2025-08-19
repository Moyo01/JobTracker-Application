public with sharing class AutoCloseStaleApplications implements Queueable {
   
    Public void execute(QueueableContext context){
        Date staleDate = Date.today().addDays(-30);
       
       
        List<Job_Tracker__c> staleApplications = [
            SELECT Id, Name, Status__c, CreatedDate, Description__c 
            FROM Job_Tracker__c 
            WHERE Status__c NOT IN ('Closed', 'Accepted') 
            AND Follow_Up_Date__c <= :staleDate
        ];
        
        List<Job_Tracker__c> applicationsToUpdate = new List<Job_Tracker__c>();
        
        for(Job_Tracker__c app : staleApplications) {
            app.Status__c = 'Closed';
            String note = 'Application closed due to inactivity on ' + Date.today().format();
            
            if(String.isBlank(app.Description__c)) {
                app.Description__c = note;
            } else {
                app.Description__c = app.Description__c + '\n' + note;
            }
            applicationsToUpdate.add(app);
        }
        
        if(!applicationsToUpdate.isEmpty()) {
            try {
                update applicationsToUpdate;
            } catch(Exception e) {
                System.debug('Error updating stale applications: ' + e.getMessage());
               
            }
        }
    }
}