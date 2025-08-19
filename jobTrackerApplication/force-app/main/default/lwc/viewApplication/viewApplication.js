import { LightningElement, track, api, wire } from 'lwc';
import jobDetails from '@salesforce/apex/JobTrackerController.jobDetails';
import { subscribe, MessageContext, unsubscribe } from 'lightning/messageService';
import JOB_SELECTED from '@salesforce/messageChannel/jobSelectedChannel__c';

export default class ViewApplication extends LightningElement {
    @track jobs;
    @track jobInfo;
    @track error;
    isJobSelected = false;
    subscription = null;
    selectedJob = null;
    isEditClicked = false;
    editableJobId;
   // @api recordId;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                JOB_SELECTED,
                (message) => this.handleJobSelected(message)
            );
        }
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleJobSelected(message) {
        if (message && message.jobData) {
            this.selectedJob = message.jobData;
            this.editableJobId = message.jobId;
            this.getJobDetails(this.selectedJob.Id);
        }
    }

    getJobDetails(JobId) {
        jobDetails({ jobId: JobId }) // ✅ Correct usage
            .then(result => {
                this.jobInfo = result.job;
                this.isJobSelected = !!this.jobInfo;
            })
            .catch(error => {
                this.error = error;
                this.isJobSelected = false;
            });
    }

    handleCancelClick() {
        this.isEditClicked = false;
    }

    handleSuccess() {
        this.isEditClicked = false;
        // Refresh the job data if needed
    }

    handleEdit(event) {
        this.isEditClicked = true;
        this.editableJobId = this.selectedJob.Id;
    }

}
