//
//  ILtasksList.m
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ILtasksList.h"
#import "ILgroup.h"
#import "ILstep.h"
#import "ILtask.h"
#import "ILtasksListAudio.h"
#import "ILtasksListThumbnail.h"


@implementation ILtasksList

@dynamic tasksList_accessRights;
@dynamic tasksList_flags;
@dynamic tasksList_groupName;
@dynamic tasksList_modifiedDate;
@dynamic tasksList_type;
@dynamic tasksList_useState;
@dynamic tasksList_version;
@dynamic tasksList_title;
@dynamic belongToGroup;
@dynamic belongToStep;
@dynamic tasks;
@dynamic tasksList_audio;
@dynamic tasksList_thumbnail;

#pragma mark - Creation

+ (ILtasksList *)createRootTasksListInMOC:(NSManagedObjectContext *)context withGroupName:(NSString *)groupName
{
    ILtasksList *rootTasksList = [[ILtasksList alloc] initWithEntity:[NSEntityDescription entityForName:@"ILtasksList"
                                                                                 inManagedObjectContext:context]
                                      insertIntoManagedObjectContext:context];
    if (rootTasksList)
    {
        rootTasksList.tasksList_groupName = groupName;
        rootTasksList.tasksList_type = @"root";
    }
    return rootTasksList;
}

+ (ILtasksList *)createSubTasksListInMOC:(NSManagedObjectContext *)context
{
    ILtasksList *subTasksList = [[ILtasksList alloc] initWithEntity:[NSEntityDescription entityForName:@"ILtasksList"
                                                                                 inManagedObjectContext:context]
                                      insertIntoManagedObjectContext:context];
    if (subTasksList)
    {
        subTasksList.tasksList_type = @"sub";
    }
    return subTasksList;
}

// Not included in the copy
//
// tasksList_flags          // not used
// tasksList_modifiedDate   // not used
// tasksList_audio          // not used
// tasksList_thumbnail      // not used
// belongToGroup            // Done by caller
// belongToStep             // Done by caller
//
+ (ILtasksList *)copyOfTasksList:(ILtasksList *)srcTasksList inMOC:(NSManagedObjectContext *)context
{
    ILtasksList *dstTasksList = [[ILtasksList alloc] initWithEntity:[NSEntityDescription entityForName:@"ILtasksList"
                                                                                inManagedObjectContext:context]
                                     insertIntoManagedObjectContext:context];
    if (dstTasksList)
    {
        [dstTasksList setTitle:[srcTasksList getTitle]];
        [dstTasksList setGroupName:[srcTasksList getGroupName]];
        [dstTasksList setType:[srcTasksList getType]];
        [dstTasksList setUseState:[srcTasksList getUseState]];
        [dstTasksList setAccessRights:[srcTasksList getAccessRights]];
        [dstTasksList setVersion:[srcTasksList getVersion]];
        
        for (NSUInteger index = 0; index < [srcTasksList getNumberOfTasks]; index++)
        {
            ILtask* dstTask = [ILtask copyOfTask:[srcTasksList getTaskAtIndex:index] inMOC:context];
            if (!dstTask)
            {
                return nil;
            }
            [[dstTasksList mutableOrderedSetValueForKeyPath:@"tasks"] addObject:dstTask];
//            if( SHOW_NSLOG )NSLog(@"\ndstTasksList : %@", dstTasksList);
//            if( SHOW_NSLOG )NSLog(@"\ndstTask.belongToTasksList : %@", dstTask.belongToTasksList);
        }
    }
    return dstTasksList;
}

#pragma mark - Tasks accessors

- (NSInteger)getNumberOfTasks
{
    return self.tasks.count;
}

- (void)setNumberOfTasks:(NSInteger)nbTasks
{
    while (nbTasks > [self getNumberOfTasks])
    {
        [self addTaskAtTheEndOfTasksList:[ILtask createTaskWithSimpleStep:YES InMOC:self.managedObjectContext]];
    }
    while (nbTasks < [self getNumberOfTasks])
    {
        [self deleteTaskAtIndex:[self getNumberOfTasks]-1];
    }
}

- (ILtask *)getTaskAtIndex:(NSUInteger)index
{
    return [self.tasks objectAtIndex:index];
}

- (ILtask *)getSafelyTaskAtIndex:(NSUInteger)index
{
    if (index < [self getNumberOfTasks])
    {
        return [self.tasks objectAtIndex:index];
    }
    return NULL;
}

- (NSString *)getTaskTitleAtIndex:(NSUInteger)index
{
    ILtask* task = [self getTaskAtIndex:index];
    if (task != NULL)
    {
        return [task getTitle];
    }    
    return NULL;
}

- (void)addTaskAtTheEndOfTasksList:(ILtask *)task
{
    [[self mutableOrderedSetValueForKeyPath:@"tasks"] addObject:task];
}

- (BOOL)deleteTask:(ILtask *)task
{
    NSUInteger index = [self.tasks indexOfObject:task];
    if (index == NSNotFound)
        return NO;
    return [self deleteTaskAtIndex:index];
}

- (BOOL)deleteTaskAtIndex:(NSUInteger)index
{
    if (index < [self getNumberOfTasks])
    {
        [self.managedObjectContext deleteObject:[self getTaskAtIndex:index]];
        [[self mutableOrderedSetValueForKeyPath:@"tasks"] removeObjectAtIndex:index];
        
        [self.managedObjectContext save:nil];
        return YES;
    }
    return NO;
}

- (BOOL)moveTaskAtIndex:(NSUInteger)srcIndex toIndex:(NSUInteger)dstIndex
{
    NSUInteger nbTasks = [self getNumberOfTasks];
    if (dstIndex >= nbTasks)
    {
        dstIndex = nbTasks-1;
    }
    if (srcIndex != dstIndex)
    {
        [[self mutableOrderedSetValueForKeyPath:@"tasks"]
                        moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:srcIndex] toIndex:dstIndex];
         return YES;
    }
    return NO;
}

- (NSString *)getTitle
{
    return self.tasksList_title;
}

- (void)setTitle:(NSString *)title
{
    if (!title || !title.length)
    {
        self.tasksList_title = NULL;
    }
    else if ([title length] > 30)
    {
        self.tasksList_title = [title substringToIndex:30];
    }
    else
    {
        self.tasksList_title = title;
    }
}

- (float)getVersion
{
    return  (self.tasksList_version ? self.tasksList_version.floatValue : 1.02);  // TODO softCode
}

- (void)setVersion:(float)version
{
    self.tasksList_version = [NSNumber numberWithFloat:version];
}

- (NSString *)getGroupName
{
    return self.tasksList_groupName;
}

- (void)setGroupName:(NSString *)groupName
{
    if (!groupName || !groupName.length)
    {
        self.tasksList_groupName = NULL;
    }
    else
    {
        self.tasksList_groupName = groupName;
    }
}

- (NSString *)getAccessRights
{
    return self.tasksList_accessRights;
}

- (void)setAccessRights:(NSString *)accessRights
{
    if (!accessRights || !accessRights.length)
    {
        self.tasksList_accessRights = NULL;
    }
    else
    {
        self.tasksList_accessRights = accessRights;
    }
}

- (void)setAccessRightsAndCascade:(NSString *)accessRights
{
    [self setAccessRights:accessRights];
    for (NSUInteger index = 0; index < [self getNumberOfTasks]; index++)
    {
        [[self getTaskAtIndex:index] setAccessRightsAndCascade:accessRights];
    }
}

- (NSString *)getUseState
{
    return self.tasksList_useState;
}

- (void)setUseState:(NSString *)useState
{
    if (!useState || !useState.length)
    {
        self.tasksList_useState = NULL;
    }
    else
    {
        self.tasksList_useState = useState;
    }
}

#pragma mark - Functionals

- (NSString *)getType
{
    return self.tasksList_type;
}

- (void)setType:(NSString *)type
{
    if (!type || !type.length)
    {
        self.tasksList_type = NULL;
    }
    else
    {
        self.tasksList_type = type;
    }
}

- (BOOL)isRootTasksList
{
    return (self.tasksList_type && [self.tasksList_type isEqualToString:@"root"]);
}

- (ILtask *)getLastTask
{
    return  ([self getNumberOfTasks] ? [self getTaskAtIndex:[self getNumberOfTasks]-1] : nil);
}

@end
