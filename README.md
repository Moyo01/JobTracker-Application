# Salesforce Job Tracker Application
# 💫 About Me:
🍺 Job Tracker Application – Salesforce Job Management Solution
🔍 Project Overview
The Job Tracker Application is a comprehensive Salesforce solution designed to streamline the job application process. It demonstrates advanced Salesforce development capabilities including external API integration, automated workflows, and modern UI components to create a complete job search management system.

A comprehensive Salesforce application for tracking job applications, managing interviews, and automating job search processes.
🛠️ Key Contributions
Custom Data Architecture: Designed and implemented objects including Job Tracker, Contact management, and Event scheduling to manage the complete job application lifecycle from discovery to offer.

## Project Overview
LWC Development: Built dynamic Lightning Web Components for job discovery, application tracking, interview management, and financial calculations—providing a seamless user experience for job seekers.

This application provides a complete solution for job seekers to:
- Track job applications and their status
- Automate job fetching from external APIs (Jooble)
- Calculate salary ranges and tax implications
- Manage interview schedules and reminders
- Integrate with Stripe for payment processing
- Provide a modern UI with Lightning Web Components
External API Integration: Implemented Jooble API integration for automated job fetching and Stripe integration for payment processing capabilities.

## Apex Classes
🧰 Technologies Used
Salesforce Lightning Web Components (LWC)

### Core Controllers
Apex (Server-side logic)

#### `JobTrackerController.cls`
Main controller for job tracking operations. Handles CRUD operations for job applications, status updates, and data management.
SOQL (Salesforce Object Query Language)

#### `JoobleJobFetcherController.cls`
Integrates with the Jooble API to automatically fetch job listings. Searches for "Salesforce" positions in the United States and creates job tracker records.
Custom Objects & Relationships

#### `ScheduledJoobleJobFetcher.cls`
Scheduled job that runs the Jooble job fetching process automatically at specified intervals.
Salesforce Security Model (Profiles, Sharing Rules)

### Helper Classes
External APIs (Jooble, Stripe)

#### `JobApplicationHelper.cls`
Utility class providing helper methods for job application processing and validation.
Scheduled Jobs & Automation

#### `customerWrapper.cls`
Wrapper class for customer data handling and processing.
📈 Business Relevance
This project showcases the capability of Salesforce as a comprehensive job management platform and highlights how complex business processes can be automated and streamlined—ideal for demonstrating practical Salesforce development, API integration, and business process automation skills to prospective employers.

#### `StripeCustomerSyncHelper.cls`
Helper class for synchronizing customer data with Stripe payment platform.
## 🌐 Socials:
[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?logo=linkedin&logoColor=white)](https://linkedin.com/in/Moyosore Owolabi) 

#### `StripeSyncLogger.cls`
Logging utility for tracking Stripe synchronization activities and errors.
# 💻 Tech Stack:
![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white) ![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E) ![Salesforce](https://img.shields.io/badge/Salesforce-%2300A1E0.svg?style=for-the-badge&logo=salesforce&logoColor=white) ![Apex](https://img.shields.io/badge/Apex-%2300A1E0.svg?style=for-the-badge&logo=salesforce&logoColor=white)

### Calculation Classes
# 📊 GitHub Stats:
![](https://github-readme-stats.vercel.app/api?username=Moyo01&theme=dark&hide_border=false&include_all_commits=false&count_private=false)<br/>
![](https://nirzak-streak-stats.vercel.app/?user=Moyo01&theme=dark&hide_border=false)<br/>
![](https://github-readme-stats.vercel.app/api/top-langs/?username=Moyo01&theme=dark&hide_border=false&include_all_commits=false&count_private=false&layout=compact)

#### `incomeCalculator.cls`
Calculates income-related metrics and financial projections for job applications.
### 🔝 Top Contributed Repo
![](https://github-contributor-stats.vercel.app/api?username=Moyo01&limit=5&theme=dark&combine_all_yearly_contributions=true)

#### `SingleTaxCalculator.cls`
Handles tax calculations for single filers based on income and location.
---
[![](https://visitcount.itsvg.in/api?id=Moyo01&icon=0&color=0)](https://visitcount.itsvg.in)

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
<!-- Proudly created with GPRM ( https://gprm.itsvg.in ) -->
