public with sharing class SingleTaxCalculator {
    private static final Decimal MEDICARE_RATE = 0.0145;
    private static final Decimal SOCIAL_SECURITY_RATE = 0.062;
    private static final Decimal SOCIAL_SECURITY_LIMIT = 160200;

    public static void calculateTaxes(List<Job_Tracker__c> jobs) {
        List<Tax_Bracket__mdt> brackets = [
            SELECT Bracket_Order__c, Bracket_Limit__c, Base_Tax__c,
                   Marginal_Rate__c, Filling_status__c, Label
            FROM Tax_Bracket__mdt
            WHERE Filling_status__c = 'Single'
            ORDER BY Bracket_Order__c
        ];

        if (brackets.isEmpty()) return;

        for (Job_Tracker__c job : jobs) {
            Decimal salary = job.Salary__c;
            if (salary == null || salary <= 0) continue;

            // Calculate Medicare and Social Security
            Decimal medicareTax = salary * MEDICARE_RATE;
            Decimal ssTax = Math.min(salary, SOCIAL_SECURITY_LIMIT) * SOCIAL_SECURITY_RATE;

            // Calculate Federal Tax
            Decimal fedTax = 0;
            Decimal remainingIncome = salary;
            Decimal previousBracketLimit = 0;

            for (Tax_Bracket__mdt bracket : brackets) {
                if (remainingIncome <= 0) break;

                // Convert bracket limit from thousands to actual amount
                Decimal bracketLimit = bracket.Bracket_Limit__c * 1000;
                // Convert rate from percentage to decimal
                Decimal rate = bracket.Marginal_Rate__c / 100;

                if (salary > previousBracketLimit) {
                    Decimal taxableInThisBracket = Math.min(remainingIncome, salary - previousBracketLimit);
                    Decimal taxForThisBracket = taxableInThisBracket * rate;
                    fedTax += taxForThisBracket;
                    remainingIncome -= taxableInThisBracket;
                }
                previousBracketLimit = bracketLimit;
            }

            // Calculate take-home
            Decimal totalDeductions = fedTax + medicareTax + ssTax;
            Decimal takeHome = salary - totalDeductions;

            // Update the job record
            job.Federal_Income_Tax__c = fedTax;
            job.Medicare_Withholding__c = medicareTax;
            job.Social_Security__c = ssTax;
            job.Take_home_calculations__c = takeHome;
        }
    }
} 