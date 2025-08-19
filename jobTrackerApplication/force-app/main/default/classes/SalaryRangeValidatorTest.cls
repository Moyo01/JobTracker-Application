@isTest
private class SalaryRangeValidatorTest {
    @isTest
    static void testValidateSalary() {
        // Test null salary
        SalaryRangeValidator.SalaryValidationResult result = SalaryRangeValidator.validateSalary(null, 'Entry Level');
        System.assertEquals(false, result.isValid, 'Null salary should be invalid');
        
        // Test negative salary
        result = SalaryRangeValidator.validateSalary(-1000, 'Entry Level');
        System.assertEquals(false, result.isValid, 'Negative salary should be invalid');
        
        // Test salary below minimum wage
        result = SalaryRangeValidator.validateSalary(10000, 'Entry Level');
        System.assertEquals(false, result.isValid, 'Salary below minimum wage should be invalid');
        System.assertEquals(15800, result.suggestedSalary, 'Should suggest minimum wage');
        
        // Test salary above maximum cap
        result = SalaryRangeValidator.validateSalary(2000000, 'Entry Level');
        System.assertEquals(false, result.isValid, 'Salary above maximum cap should be invalid');
        
        // Test valid entry level salary
        result = SalaryRangeValidator.validateSalary(45000, 'Entry Level');
        System.assertEquals(true, result.isValid, 'Valid entry level salary should pass');
        
        // Test salary below entry level range
        result = SalaryRangeValidator.validateSalary(25000, 'Entry Level');
        System.assertEquals(false, result.isValid, 'Salary below entry level range should be invalid');
        System.assertEquals(30000, result.suggestedSalary, 'Should suggest minimum entry level salary');
        
        // Test salary above entry level range
        result = SalaryRangeValidator.validateSalary(70000, 'Entry Level');
        System.assertEquals(false, result.isValid, 'Salary above entry level range should be invalid');
        System.assertEquals(60000, result.suggestedSalary, 'Should suggest maximum entry level salary');
    }
    
    @isTest
    static void testValidateMultipleSalaries() {
        List<Job_Tracker__c> jobs = new List<Job_Tracker__c>{
            new Job_Tracker__c(Salary__c = 45000, Job_Level__c = 'Entry Level'),
            new Job_Tracker__c(Salary__c = 75000, Job_Level__c = 'Mid Level'),
            new Job_Tracker__c(Salary__c = 120000, Job_Level__c = 'Senior Level')
        };
        
        List<SalaryRangeValidator.SalaryValidationResult> results = SalaryRangeValidator.validateMultipleSalaries(jobs);
        
        System.assertEquals(3, results.size(), 'Should return results for all jobs');
        System.assertEquals(true, results[0].isValid, 'First job should be valid');
        System.assertEquals(true, results[1].isValid, 'Second job should be valid');
        System.assertEquals(true, results[2].isValid, 'Third job should be valid');
    }
    
    @isTest
    static void testGetSalaryRangeForJobLevel() {
        Map<String, Decimal> range = SalaryRangeValidator.getSalaryRangeForJobLevel('Entry Level');
        System.assertNotEquals(null, range, 'Should return range for valid job level');
        System.assertEquals(30, range.get('min'), 'Should return correct minimum salary');
        System.assertEquals(60, range.get('max'), 'Should return correct maximum salary');
        
        range = SalaryRangeValidator.getSalaryRangeForJobLevel('Invalid Level');
        System.assertEquals(null, range, 'Should return null for invalid job level');
    }
    
    @isTest
    static void testGetAvailableJobLevels() {
        List<String> levels = SalaryRangeValidator.getAvailableJobLevels();
        System.assertEquals(4, levels.size(), 'Should return all job levels');
        System.assert(levels.contains('Entry Level'), 'Should contain Entry Level');
        System.assert(levels.contains('Mid Level'), 'Should contain Mid Level');
        System.assert(levels.contains('Senior Level'), 'Should contain Senior Level');
        System.assert(levels.contains('Executive Level'), 'Should contain Executive Level');
    }
} 