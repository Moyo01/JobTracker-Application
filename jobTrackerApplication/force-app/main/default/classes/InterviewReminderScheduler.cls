public with sharing class InterviewReminderScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        // Set date range for tomorrow
        DateTime now = System.now();
        Date tomorrow = now.date().addDays(1);
        DateTime startOfDay = DateTime.newInstance(tomorrow, Time.newInstance(0, 0, 0, 0));
        DateTime endOfDay = DateTime.newInstance(tomorrow, Time.newInstance(23, 59, 59, 999));

        // Query events scheduled for tomorrow with subject "Interview"
        List<Event> interviews = [
            SELECT Id, Subject, StartDateTime, EndDateTime, Owner.Email, Owner.Name,
                   Description, Location
            FROM Event
            WHERE Subject LIKE '%Interview%'
            AND StartDateTime >= :startOfDay
            AND StartDateTime <= :endOfDay
            AND IsDeleted = FALSE
        ];

        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Event interview : interviews) {
            if (interview.Owner.Email == null) continue;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { interview.Owner.Email });
            mail.setSubject('Interview Reminder: ' + (interview.Subject != null ? interview.Subject : 'Upcoming Interview'));
            
            String body = 'Hello ' + interview.Owner.Name + ',\n\n' +
                'This is a reminder for your interview scheduled tomorrow.\n\n' +
                '📅 Date: ' + interview.StartDateTime.format('MMMM dd, yyyy') + '\n' +
                '🕑 Time: ' + interview.StartDateTime.format('h:mm a') + ' - ' + interview.EndDateTime.format('h:mm a') + '\n' +
                (interview.Location != null ? '📍 Location: ' + interview.Location + '\n' : '') +
                (interview.Description != null ? '\n📝 Description:\n' + interview.Description + '\n' : '') +
                '\nThank you,\nRecruiting Team';

            mail.setPlainTextBody(body);
            emailsToSend.add(mail);
        }

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
}
