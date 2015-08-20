//
//  ILtasksList.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILgroup, ILstep, ILtask, ILtasksListAudio, ILtasksListThumbnail;

@interface ILtasksList : NSManagedObject

@property (nonatomic, retain) NSString * tasksList_accessRights;
@property (nonatomic, retain) NSString * tasksList_flags;
@property (nonatomic, retain) NSString * tasksList_groupName;
@property (nonatomic, retain) NSDate * tasksList_modifiedDate;
@property (nonatomic, retain) NSString * tasksList_type;
@property (nonatomic, retain) NSString * tasksList_useState;
@property (nonatomic, retain) NSNumber * tasksList_version;
@property (nonatomic, retain) NSString * tasksList_title;
@property (nonatomic, retain) ILgroup *belongToGroup;
@property (nonatomic, retain) ILstep *belongToStep;
@property (nonatomic, retain) NSOrderedSet *tasks;
@property (nonatomic, retain) ILtasksListAudio *tasksList_audio;
@property (nonatomic, retain) ILtasksListThumbnail *tasksList_thumbnail;

#pragma mark - Creation

+ (ILtasksList *)createRootTasksListInMOC:(NSManagedObjectContext *)context withGroupName:(NSString *)name;
+ (ILtasksList *)createSubTasksListInMOC:(NSManagedObjectContext *)context;
+ (ILtasksList *)copyOfTasksList:(ILtasksList *)srcTasksList inMOC:(NSManagedObjectContext *)context;

// Tasks accessors
- (NSInteger)getNumberOfTasks;
- (void)setNumberOfTasks:(NSInteger)nbTasks;
- (ILtask *)getTaskAtIndex:(NSUInteger)index;
- (ILtask *)getSafelyTaskAtIndex:(NSUInteger)index;
- (NSString *)getTaskTitleAtIndex:(NSUInteger)index;
- (void)addTaskAtTheEndOfTasksList:(ILtask *)task;
- (BOOL)deleteTask:(ILtask *)task;
- (BOOL)deleteTaskAtIndex:(NSUInteger)index;
- (BOOL)moveTaskAtIndex:(NSUInteger)srcIndex toIndex:(NSUInteger)dstIndex;

- (NSString *)getTitle;
- (void)setTitle:(NSString *)title;
- (float)getVersion;
- (void)setVersion:(float)version;
- (NSString *)getGroupName;
- (void)setGroupName:(NSString *)groupName;
- (NSString *)getAccessRights;
- (void)setAccessRights:(NSString *)accessRights;
- (void)setAccessRightsAndCascade:(NSString *)accessRights;
- (NSString *)getUseState;
- (void)setUseState:(NSString *)useState;

// Functionals
- (NSString *)getType;
- (void)setType:(NSString *)type;
- (BOOL)isRootTasksList;
- (ILtask *)getLastTask;

@end


// Unused BE AWARE need some thinking to use properly
//
@interface ILtasksList (CoreDataGeneratedAccessors)

- (void)insertObject:(ILtask *)value inTasksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTasksAtIndex:(NSUInteger)idx;
- (void)insertTasks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTasksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTasksAtIndex:(NSUInteger)idx withObject:(ILtask *)value;
- (void)replaceTasksAtIndexes:(NSIndexSet *)indexes withTasks:(NSArray *)values;
- (void)addTasksObject:(ILtask *)value;
- (void)removeTasksObject:(ILtask *)value;
- (void)addTasks:(NSOrderedSet *)values;
- (void)removeTasks:(NSOrderedSet *)values;
@end
