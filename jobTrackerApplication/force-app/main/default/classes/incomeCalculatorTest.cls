@isTest
private class incomeCalculatorTest {
    @isTest
    static void testCalculateTakeHomePay() {
        // Create test contact with Single filing status
        Contact testContact = new Contact(
            LastName = 'Test',
            Tax_Status__c = 'Single'
        );
        insert testContact;
        
        // Create test job with $80,000 salary
        Job_Tracker__c testJob = new Job_Tracker__c(
            Salary__c = 80000,
            Primary_Contact__c = testContact.Id
        );
        insert testJob;
        
        // Create test tax brackets for Single filing status using actual values from org
        List<Tax_Bracket__mdt> brackets = new List<Tax_Bracket__mdt>{
            new Tax_Bracket__mdt(
                Bracket_Order__c = 1,
                Bracket_Limit__c = 11.925,
                Base_Tax__c = 0,
                Marginal_Rate__c = 10,
                Filling_status__c = 'Single'
            ),
            new Tax_Bracket__mdt(
                Bracket_Order__c = 2,
                Bracket_Limit__c = 48.475,
                Base_Tax__c = 1193,
                Marginal_Rate__c = 12,
                Filling_status__c = 'Single'
            ),
            new Tax_Bracket__mdt(
                Bracket_Order__c = 3,
                Bracket_Limit__c = 103.350,
                Base_Tax__c = 4544,
                Marginal_Rate__c = 22,
                Filling_status__c = 'Single'
            )
        };
        
        // Calculate taxes
        incomeCalculator.calculateTaxes(new List<Job_Tracker__c>{testJob}, brackets);
        
        // Verify calculations
        System.assertEquals(12514.00, testJob.Federal_Income_Tax__c, 'Federal tax should be $12,514');
        System.assertEquals(1160.00, testJob.Medicare_Withholding__c, 'Medicare tax should be $1,160');
        System.assertEquals(4960.00, testJob.Social_Security__c, 'Social Security tax should be $4,960');
        System.assertEquals(61366.00, testJob.Take_home_calculations__c, 'Take-home pay should be $61,366');
    }
} 