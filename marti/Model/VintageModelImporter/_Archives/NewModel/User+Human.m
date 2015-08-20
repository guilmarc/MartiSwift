//
//  User+Human.m
//  marti
//
//  Created by Marco Guilmette on 2/21/2014.
//
//

#import "User+Human.h"
#import "ScheduleManager.h"

@implementation User (Human)

NSMutableArray* _plannedEvents;

//@dynamic plannedEvents;

-(NSOrderedSet*)rootTasks{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isRoot == %@", [NSNumber numberWithBool: YES]];
    return [self.tasks filteredOrderedSetUsingPredicate:predicate];
}

/*-(void)setPlannedEvents:(NSMutableArray *)plannedEvents{
    if( _plannedEvents )
}*/

-(NSMutableArray*)plannedEvents{
    if( _plannedEvents != nil ) {return _plannedEvents;}
    
    _plannedEvents = [[ScheduleManager sharedInstance] generatePlannedEventsForUser:self];
    return _plannedEvents;
}



@end
