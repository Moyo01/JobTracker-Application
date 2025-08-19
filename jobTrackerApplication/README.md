# Salesforce Job Tracker Application

A comprehensive Salesforce application for tracking job applications, managing interviews, and automating job search processes.

## Project Overview

This application provides a complete solution for job seekers to:
- Track job applications and their status
- Automate job fetching from external APIs (Jooble)
- Calculate salary ranges and tax implications
- Manage interview schedules and reminders
- Integrate with Stripe for payment processing
- Provide a modern UI with Lightning Web Components

## Apex Classes

### Core Controllers

#### `JobTrackerController.cls`
Main controller for job tracking operations. Handles CRUD operations for job applications, status updates, and data management.

#### `JoobleJobFetcherController.cls`
Integrates with the Jooble API to automatically fetch job listings. Searches for "Salesforce" positions in the United States and creates job tracker records.

#### `ScheduledJoobleJobFetcher.cls`
Scheduled job that runs the Jooble job fetching process automatically at specified intervals.

### Helper Classes

#### `JobApplicationHelper.cls`
Utility class providing helper methods for job application processing and validation.

#### `customerWrapper.cls`
Wrapper class for customer data handling and processing.

#### `StripeCustomerSyncHelper.cls`
Helper class for synchronizing customer data with Stripe payment platform.

#### `StripeSyncLogger.cls`
Logging utility for tracking Stripe synchronization activities and errors.

### Calculation Classes

#### `incomeCalculator.cls`
Calculates income-related metrics and financial projections for job applications.

#### `SingleTaxCalculator.cls`
Handles tax calculations for single filers based on income and location.

#### `screenCalculator.cls`
Provides screening calculations and assessments for job applications.

### Validation Classes

#### `calenderValidation.cls`
Validates calendar entries and interview scheduling to prevent conflicts.

#### `SalaryRangeValidatorTest.cls`
Test class for validating salary range calculations and business logic.

### Automation Classes

#### `AutoCloseStaleApplications.cls`
Automatically closes job applications that have been inactive for a specified period.

#### `InterviewReminderScheduler.cls`
Scheduled job that sends interview reminders to candidates and updates application statuses.

#### `StripeCustomerSyncBatch.cls`
Batch job for synchronizing customer data between Salesforce and Stripe in bulk.

## Lightning Web Components (LWC)

### Job Management Components

#### `jobTile`
Displays individual job listings in a tile format with key information like title, company, and location.

#### `jobDetails`
Shows detailed information about a specific job application including status, notes, and contact information.

#### `viewApplication`
Provides a comprehensive view of job application details with editing capabilities.

### Search and Discovery Components

#### `searchJob`
Search interface for finding job applications with filters and sorting options.

#### `saerchList`
Displays search results in a list format with pagination and filtering capabilities.

### Utility Components

#### `screenCalculator`
Interactive component for calculating screening scores and assessments for job applications.

## Triggers

### `ContactTrigger.trigger`
Handles contact-related events and updates, ensuring data consistency across the application.

### `EventTrigger.trigger`
Manages event creation and updates, particularly for interview scheduling and reminders.

### `JobTrackerTrigger.trigger`
Processes job tracker record changes and maintains data integrity across related objects.

## Message Channels

### `jobSelectedChannel`
Custom message channel for communication between LWC components when job selections change.

## Setup Instructions

1. **Deploy to Salesforce Org**
   ```bash
   sfdx force:source:deploy -p force-app/main/default
   ```

2. **Assign Permissions**
   - Ensure users have appropriate permissions for Job_Tracker__c object
   - Configure API access for Jooble integration

3. **Configure Scheduled Jobs**
   - Set up `ScheduledJoobleJobFetcher` for automatic job fetching
   - Configure `InterviewReminderScheduler` for interview reminders
   - Set up `AutoCloseStaleApplications` for application cleanup

4. **API Configuration**
   - Update Jooble API key in `JoobleJobFetcherController`
   - Configure Stripe integration settings if using payment features

## Features

- **Automated Job Fetching**: Integrates with Jooble API to automatically discover new job opportunities
- **Application Tracking**: Complete lifecycle management from application to offer
- **Interview Management**: Automated scheduling and reminder system
- **Financial Calculations**: Salary range analysis and tax calculations
- **Modern UI**: Responsive Lightning Web Components with modern design
- **Integration Ready**: Built-in Stripe integration for payment processing
- **Automation**: Scheduled jobs for maintenance and data synchronization

## Technologies Used

- **Salesforce Platform**: Apex, Lightning Web Components, SOQL
- **External APIs**: Jooble Job API, Stripe Payment API
- **Testing**: Jest for LWC testing, Apex test classes
- **Development Tools**: SFDX, VS Code, Prettier, ESLint

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
