public with sharing class calenderValidation {
    
    public static void validateCalendar(List<Event> eventList) {
        Set<Id> ownerIdSet = new Set<Id>();
        Map<Id, List<Event>> ownerIdToEventMap = new Map<Id, List<Event>>();
        
        // First, collect all owner IDs and map events to their owners
        for(Event event : eventList) {
            if(event.StartDateTime != null && event.EndDateTime != null && event.OwnerId != null) {
                ownerIdSet.add(event.OwnerId);
                if(!ownerIdToEventMap.containsKey(event.OwnerId)) {
                    ownerIdToEventMap.put(event.OwnerId, new List<Event>());
                }
                ownerIdToEventMap.get(event.OwnerId).add(event);
            }
        }
        
        // Query existing events for the owners
        List<Event> existingEvents = [
            SELECT Id, OwnerId, StartDateTime, EndDateTime, IsAllDayEvent
            FROM Event
            WHERE OwnerId IN :ownerIdSet
            AND StartDateTime >= LAST_N_DAYS:30
            AND EndDateTime <= NEXT_N_DAYS:30
        ];
        
        // Check for conflicts
        for(Event newEvent : eventList) {
            if(newEvent.StartDateTime != null && newEvent.EndDateTime != null && newEvent.OwnerId != null) {
                // Check for weekend
                if(isWeekend(newEvent.StartDateTime)) {
                    newEvent.addError('Cannot schedule events on weekends');
                    continue;
                }
                
                // Check for conflicts with existing events
                for(Event existingEvent : existingEvents) {
                    if(existingEvent.OwnerId == newEvent.OwnerId && 
                       !existingEvent.Id.equals(newEvent.Id) && // Skip comparing with self
                       hasTimeConflict(newEvent, existingEvent)) {
                        newEvent.addError('Time chosen conflicts with an existing event');
                        break;
                    }
                }
            }
        }
    }
    
    private static Boolean isWeekend(Datetime dt) {
        Integer dayOfWeek = dt.date().toStartOfWeek().daysBetween(dt.date()) + 1;
        return dayOfWeek == 6 || dayOfWeek == 7; // 6 = Saturday, 7 = Sunday
    }
    
    private static Boolean hasTimeConflict(Event newEvent, Event existingEvent) {
        if(newEvent.IsAllDayEvent && existingEvent.IsAllDayEvent) {
            return true; // All-day events conflict with other all-day events
        }
        
        if(newEvent.IsAllDayEvent || existingEvent.IsAllDayEvent) {
            return false; // All-day events don't conflict with regular events
        }
        
        return (newEvent.StartDateTime <= existingEvent.EndDateTime && 
                newEvent.EndDateTime >= existingEvent.StartDateTime);
    }
}