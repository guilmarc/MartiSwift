//
//  Task+Human.h
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "Task.h"
#import "User.h"
#import "Step+Human.h"

@interface Task (Human)

@property (strong, nonatomic) Step* currentStep;
@property ( nonatomic ) NSUInteger currentStepIndex;

+(Task*)createTaskInMOC:(NSManagedObjectContext*)moc forUser:(User*)user;

-(Task*)copy;

-(BOOL)isWriteProtected;

-(NSOrderedSet*)activeSteps;

-(BOOL)isFirstStep;
-(BOOL)isLastStep;

-(UIImage*)thumbnailImage;
-(NSString*)title;
-(NSString*)structureDescription;

@end
