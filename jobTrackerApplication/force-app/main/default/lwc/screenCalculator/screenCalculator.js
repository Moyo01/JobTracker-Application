import { LightningElement, track } from 'lwc';

export default class ScreenCalculator extends LightningElement {
    @track salary = 0;
    @track federalTax = 0;
    @track medicare = 0;
    @track socialSecurity = 0;
    @track takehome = 0;
    @track yearlyPay = 0;
    @track sixmonthsPay = 0;
    @track monthlyPay = 0;
    @track biWeekly = 0;
    @track taxStatus = ''; 

    taxStatusOptions = [
        { label: 'Single', value: 'Single' },
        { label: 'Married', value: 'Married' },
        { label: 'Head of Household', value: 'Head' }
    ];

    handleTaxStatusChange(event) {
        this.taxStatus = event.detail.value;
    }

    handleSalaryChange(event) {
        this.salary = parseFloat(event.target.value) || 0;
    }

    calculateTakeHome() {
        let taxRate = 0.12; // Default tax rate

        switch (this.taxStatus) {
            case 'Married':
                taxRate = 0.10;
                break;
            case 'Head':
                taxRate = 0.11;
                break;
            case 'Single':
            default:
                taxRate = 0.12;
                break;
        }

        this.federalTax = this.salary * taxRate;
        this.medicare = this.salary * 0.0145;
        this.socialSecurity = this.salary * 0.062;

        const deductions = this.federalTax + this.medicare + this.socialSecurity;
        this.takehome = this.salary - deductions;

        this.yearlyPay = this.takehome;
        this.sixmonthsPay = this.takehome / 2;
        this.monthlyPay = this.takehome / 12;
        this.biWeekly = this.takehome / 26;
    }

}