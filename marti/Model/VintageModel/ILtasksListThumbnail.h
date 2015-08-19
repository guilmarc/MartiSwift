//
//  ILtasksListThumbnail.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILtasksList;

@interface ILtasksListThumbnail : NSManagedObject

@property (nonatomic, retain) NSData * tasksListThumbnail_data;
@property (nonatomic, retain) NSString * tasksListThumbnail_flags;
@property (nonatomic, retain) NSDate * tasksListThumbnail_modifiedDate;
@property (nonatomic, retain) NSNumber * tasksListThumbnail_version;
@property (nonatomic, retain) ILtasksList *belongToTasksList;

@end
