//
//  RoutingStep+Human.h
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "RoutingStep.h"

@interface RoutingStep (Human)

+(RoutingStep*)createRoutingStepInMOC:(NSManagedObjectContext*)moc;
-(Task*)createTaskInMOC:(NSManagedObjectContext*)moc;
-(RoutingStep*)copy;

-(UIImage*)thumbnailImage;
-(NSString*)title;
@end
