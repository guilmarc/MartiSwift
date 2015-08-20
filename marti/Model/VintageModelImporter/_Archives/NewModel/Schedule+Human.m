//
//  Schedule+Human.m
//  marti
//
//  Created by Marco Guilmette on 3/1/2014.
//
//

#import "Schedule+Human.h"

@implementation Schedule (Human)

+(Schedule*)createScheduleInMOC:(NSManagedObjectContext*)moc forUser:(User*)user {
    
    Schedule *newSchedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:moc];
    
    newSchedule.name = @"New Schedule";
    newSchedule.user = user;

    return newSchedule;
}


@end
