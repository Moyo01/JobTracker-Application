public with sharing class ScheduledJoobleJobFetcher implements Schedulable {
    public void execute(SchedulableContext sc) {
        JoobleJobFetcherController.fetchJoobleJobs();
    }
}