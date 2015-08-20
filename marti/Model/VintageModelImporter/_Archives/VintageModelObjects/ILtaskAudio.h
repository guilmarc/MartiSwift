//
//  ILtaskAudio.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILtask;

@interface ILtaskAudio : NSManagedObject

@property (nonatomic, retain) NSData * taskAudio_data;
@property (nonatomic, retain) NSString * taskAudio_flags;
@property (nonatomic, retain) NSDate * taskAudio_modifiedDate;
@property (nonatomic, retain) NSNumber * taskAudio_version;
@property (nonatomic, retain) ILtask *belongToTask;

@end
