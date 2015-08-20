//
//  User+Human.h
//  marti
//
//  Created by Marco Guilmette on 2/21/2014.
//
//

#import "User.h"

@interface User (Human)

//@property (strong, nonatomic) NSMutableArray* plannedEvents;

-(NSOrderedSet*)rootTasks;
-(NSMutableArray*)plannedEvents;

@end
