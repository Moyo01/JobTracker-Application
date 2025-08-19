import { LightningElement, api, track, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import JOB_SELECTED from '@salesforce/messageChannel/jobSelectedChannel__c';
import getJobsFromAPI from '@salesforce/apex/JobTrackerController.getJobsFromAPI';

const COLUMNS = [
    { label: 'Position/Title', fieldName: 'Position_Title__c' },
    { label: 'Company Name', fieldName: 'Company_Name__c' },
    { label: 'Url', fieldName: 'URL__c', type: 'url' },
    { label: 'Status', fieldName: 'Status__c' },
    {   label: 'Action',fieldName: 'Action',
        type: 'button',
        typeAttributes: {
            label: 'View Job',
            name: 'view_job',
            title: 'View Application',
            disabled: false,
            value: 'select',
            iconPosition: 'left'
        }
    }
];

export default class JobTile extends LightningElement {
    @api jobRecords = [];
    @track columns = COLUMNS;
    @track errors;
    @wire(MessageContext)
    messageContext;

    @wire(getJobsFromAPI)
    wiredJobs({ error, data }) {
        if (data) {
            this.jobRecords = data;
            this.errors = undefined;
        } else if (error) {
            this.errors = error;
            this.jobRecords = undefined;
        }
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
}
