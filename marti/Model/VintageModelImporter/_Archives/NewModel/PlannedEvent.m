//
//  PlannedEvent.m
//  marti
//
//  Created by Marco Guilmette on 3/1/2014.
//
//

#import "PlannedEvent.h"

@implementation PlannedEvent

@synthesize scheduledEvent, date;

-(instancetype)initWithScheduledEvent:(ScheduledEvent*)scheduledEvent andDate:(NSDate*)eventDate{
 
    if (self = [super init])
    {
        // Initialization code here
        self.scheduledEvent = scheduledEvent;
        self.date = eventDate;
    }
    return self;
}

@end
