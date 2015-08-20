//
//  ILtaskAudioShort.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILtask;

@interface ILtaskAudioShort : NSManagedObject

@property (nonatomic, retain) NSData * taskAudioShort_data;
@property (nonatomic, retain) NSString * taskAudioShort_flags;
@property (nonatomic, retain) NSDate * taskAudioShort_modifiedDate;
@property (nonatomic, retain) NSNumber * taskAudioShort_version;
@property (nonatomic, retain) ILtask *belongToTask;

@end
