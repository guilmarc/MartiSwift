//
//  ILgroup.m
//  marti
//
//  Created by Paul Legault Local on 11-12-12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ILgroup.h"
#import "ILtasksList.h"
#import "ILtask.h"
#import "MartiMetricsManager.h"

@implementation ILgroup

@dynamic group_accessRights;
@dynamic group_description;
@dynamic group_fakeIndex;
@dynamic group_flags;
@dynamic group_language;
@dynamic group_modifiedDate;
@dynamic group_name;
@dynamic group_title;
@dynamic group_useState;
@dynamic group_version;
@dynamic tasksList;

#pragma mark - Creation

- (id)initEmptyGroup:(NSString *)name inMOC:(NSManagedObjectContext *)context
{
   
    self = [super initWithEntity:[NSEntityDescription entityForName:@"ILgroup" inManagedObjectContext:context]
                                    insertIntoManagedObjectContext:context];
   
    if (self)
    {
        self.tasksList = [ILtasksList createRootTasksListInMOC:context withGroupName:name];
        self.group_name = name;
        self.group_accessRights = nil; // ACCESS_RIGHTS_ALL
    }
    return self;
}

- (ILtasksList *)getTasksList
{
    return self.tasksList;
}

- (ILtask *)getLastTask
{
    return [self.tasksList getLastTask];
}

- (BOOL)isHelpGroup
{
    return (self.group_name && [self.group_name isEqualToString:MARTI_HELP_GROUP_NAME]);
}

- (NSString *)getGroupName
{
    return self.group_name;
}

- (void)setGroupName:(NSString *)name
{
    if (!name || !name.length)
    {
        self.group_name = nil;
    }
    else
    {
        self.group_name = name;
    }
}

- (NSString *)getLanguage
{
    return self.group_language;
}

- (void)setLanguage:(NSString *)language
{
    if (!language || !language.length)
    {
        self.group_language = nil;
    }
    else
    {
        self.group_language = language;
    }
}

- (NSString *)getAccessRights
{
    return self.group_accessRights;
}

- (void)setAccessRights:(NSString *)accessRights
{
    if (!accessRights || !accessRights.length)
    {
        self.group_accessRights = nil;
    }
    else
    {
        self.group_accessRights = accessRights;
    }
}

- (void)setAccessRightsAndCascade:(NSString *)accessRights
{
    [self setAccessRights:accessRights];
    if (self.tasksList)
    {
        [self.tasksList setAccessRightsAndCascade:accessRights];
    }
}

- (NSString *)getUseState
{
    return self.group_useState;
}

- (void)setUseState:(NSString *)useState
{
    if (!useState || !useState.length)
    {
        self.group_useState = nil;
    }
    else
    {
        self.group_useState = useState;
    }
}

@end
