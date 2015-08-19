//
//  ILgroup.h
//  marti
//
//  Created by Paul Legault Local on 11-12-12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILtasksList;
@class ILtask;

@interface ILgroup : NSManagedObject

@property (nonatomic, retain) NSString * group_accessRights;
@property (nonatomic, retain) NSString * group_description;
@property (nonatomic, retain) NSNumber * group_fakeIndex;
@property (nonatomic, retain) NSString * group_flags;
@property (nonatomic, retain) NSString * group_language;
@property (nonatomic, retain) NSDate * group_modifiedDate;
@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSString * group_title;
@property (nonatomic, retain) NSString * group_useState;
@property (nonatomic, retain) NSNumber * group_version;
@property (nonatomic, retain) ILtasksList *tasksList;

- (id)initEmptyGroup:(NSString *)title inMOC:(NSManagedObjectContext *)context;

- (ILtasksList *)getTasksList;
- (ILtask *)getLastTask;


- (NSString *)getGroupName;
- (void)setGroupName:(NSString *)groupName;
- (BOOL)isHelpGroup;
- (NSString *)getLanguage;
- (void)setLanguage:(NSString *)language;
- (NSString *)getAccessRights;
- (void)setAccessRights:(NSString *)accessRights;
- (void)setAccessRightsAndCascade:(NSString *)accessRights;
- (NSString *)getUseState;
- (void)setUseState:(NSString *)useState;

@end

// Unused BE AWARE need some thinking to use properly
//
@interface ILgroup (CoreDataGeneratedAccessors)

- (void)addTasksListsObject:(ILtasksList *)value;
- (void)removeTasksListsObject:(ILtasksList *)value;
- (void)addTasksLists:(NSSet *)values;
- (void)removeTasksLists:(NSSet *)values;

@end
