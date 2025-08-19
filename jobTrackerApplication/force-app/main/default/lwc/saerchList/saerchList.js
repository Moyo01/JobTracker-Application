import { LightningElement, track, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import JOB_SELECTED from '@salesforce/messageChannel/jobSelectedChannel__c';
import getJobsFromAPI from '@salesforce/apex/JobTrackerController.getJobsFromAPI';
// import insertSelectedJobs from '@salesforce/apex/JobTrackerController.insertSelectedJobs';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import searchJobs from '@salesforce/apex/JobTrackerController.searchJobs';

export default class SaerchList extends LightningElement {
    @track searchTerm = '';
    @track jobRecords = [];
    @track error;
   

    @wire(MessageContext)
    messageContext;

    @wire(getJobsFromAPI, { searchTerm: '$searchTerm' })
    wiredSearchResults({ error, data }) {
        if (data) {
            this.jobRecords = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.jobRecords = [];
        }
    }

    handleSearch(event) {
        this.searchTerm = event.detail;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'view_job') {
            publish(this.messageContext, JOB_SELECTED, {
                jobId: row.Id,
                jobData: {
                    Id: row.Id,
                    Position_Title__c: row.Position_Title__c,
                    Company_Name__c: row.Company_Name__c,
                    Status__c: row.Status__c,
                    URL__c: row.URL__c
                }
            });
        }
    }

    get noResults(){
        return this.jobRecords && this.jobRecords.length === 0;
    }

   
}
