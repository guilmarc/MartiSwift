//
//  RoutingStep+Human.m
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "RoutingStep+Human.h"
#import "Task+Human.h"

@implementation RoutingStep (Human)

-(BOOL)isMediaStep {return false;}
-(BOOL)isRoutingStep {return true;}
-(BOOL)isSelectionStep {return false;}


+(RoutingStep*)createRoutingStepInMOC:(NSManagedObjectContext*)moc{
    
    RoutingStep *newRoutingStep = [NSEntityDescription insertNewObjectForEntityForName:@"RoutingStep" inManagedObjectContext:moc];
    
    //Creating first choice
    [newRoutingStep createTaskInMOC:moc];
    //Creating second choice
    [newRoutingStep createTaskInMOC:moc];
  
    return newRoutingStep;
}

-(Task*)createTaskInMOC:(NSManagedObjectContext*)moc{
    Task *newTask = [Task createTaskInMOC:moc forUser:[[MartiCDManager sharedInstance] currentUser]];
    newTask.isRoot = @false;
    
    //TODO: Find the way to link the newly created task to this RoutingStep
    [[self mutableOrderedSetValueForKeyPath:@"tasks"] addObject:newTask];
    
    return newTask;
}

-(RoutingStep*)copy{
    RoutingStep *newRoutingStep = [NSEntityDescription insertNewObjectForEntityForName:@"RoutingStep" inManagedObjectContext:self.managedObjectContext];
    newRoutingStep.active = self.active;
    newRoutingStep.audioAssistant = self.audioAssistant;
    newRoutingStep.duration = self.duration;
    newRoutingStep.index = self.index;
    newRoutingStep.name = self.name;
    newRoutingStep.textualAssistant = self.textualAssistant;
    newRoutingStep.thumbnail = self.thumbnail;
    newRoutingStep.type = self.type;
    
    for(Task* thisTask in self.tasks) {
        [[newRoutingStep mutableOrderedSetValueForKeyPath:@"tasks"] addObject:[thisTask copy]];
    }
    
    return newRoutingStep;
}


-(UIImage*)thumbnailImage{
    if( self.thumbnail != nil ) {
        return [UIImage imageWithData:self.thumbnail];
    } else {
        return [UIImage imageNamed:@"routingStepPlaceHolder"];
    }
}

-(NSString*)title{
    if( self.name ) {
        return self.name;
    } else {
        return NSLocalizedString(@"DummyTitleChoiceStepKey", @"");
    }
}
@end
