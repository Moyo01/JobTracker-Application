public with sharing class incomeCalculator {
    private static final Decimal MEDICARE_RATE = 0.0145;
    private static final Decimal SOCIAL_SECURITY_RATE = 0.062;
    private static final Decimal SOCIAL_SECURITY_LIMIT = 160200;

    public static void updateFromJobChanges(Map<Id, Job_Tracker__c> newMap, Map<Id, Job_Tracker__c> oldMap) {
        if (newMap == null || newMap.isEmpty()) return;
    
        List<Job_Tracker__c> jobsToUpdate = new List<Job_Tracker__c>();
    
        for (Job_Tracker__c newJob : newMap.values()) {
            Job_Tracker__c oldJob = oldMap != null ? oldMap.get(newJob.Id) : null;
    
            Boolean isInsert = oldJob == null;
            Boolean salaryChanged = oldJob != null && oldJob.Salary__c != newJob.Salary__c;
    
            if (isInsert || salaryChanged) {
                jobsToUpdate.add(newJob);
            }
        }
    
        if (jobsToUpdate.isEmpty()) return;
    
        List<Tax_Bracket__mdt> allBrackets = [
            SELECT Bracket_Order__c, Bracket_Limit__c, Base_Tax__c,
                   Marginal_Rate__c
            FROM Tax_Bracket__mdt
            ORDER BY Bracket_Order__c
        ];
    
        for (Job_Tracker__c job : jobsToUpdate) {
            if (job.Salary__c == null || job.Salary__c <= 0) continue;
    
            Decimal salary = job.Salary__c;
    
            job.yearly_pay__c = salary;
            job.six_months_pay__c = (salary / 2).setScale(2);
            job.monthly_pay__c = (salary / 12).setScale(2);
            job.bi_weekly__c = (salary / 26).setScale(2);
    
            Decimal medicareTax = salary * MEDICARE_RATE;
            Decimal ssTax = Math.min(salary, SOCIAL_SECURITY_LIMIT) * SOCIAL_SECURITY_RATE;
    
            Decimal fedTax = 0;
            Decimal previousLimit = 0;
    
            for (Tax_Bracket__mdt bracket : allBrackets) {
                Decimal bracketLimit = bracket.Bracket_Limit__c * 1000;
    
                if (salary > previousLimit) {
                    Decimal rate = bracket.Marginal_Rate__c / 100;
                    if (salary <= bracketLimit) {
                        fedTax = bracket.Base_Tax__c + (salary - previousLimit) * rate;
                        break;
                    } else {
                        fedTax += (bracketLimit - previousLimit) * rate;
                        previousLimit = bracketLimit;
                    }
                }
            }
    
            Decimal totalDeductions = fedTax + medicareTax + ssTax;
            Decimal takeHome = salary - totalDeductions;
    
            job.Federal_Income_Tax__c = fedTax.setScale(2);
            job.Medicare_Withholding__c = medicareTax.setScale(2);
            job.Social_Security__c = ssTax.setScale(2);
            job.Take_home_calculations__c = takeHome.setScale(2);
        }
    }
    
}
