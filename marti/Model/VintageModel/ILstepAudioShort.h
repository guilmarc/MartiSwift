//
//  ILstepAudioShort.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILstep;

@interface ILstepAudioShort : NSManagedObject

@property (nonatomic, retain) NSData * stepAudioShort_data;
@property (nonatomic, retain) NSString * stepAudioShort_flags;
@property (nonatomic, retain) NSDate * stepAudioShort_modifiedDate;
@property (nonatomic, retain) NSNumber * stepAudioShort_version;
@property (nonatomic, retain) ILstep *belongToStep;

@end
