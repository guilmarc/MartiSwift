//
//  ILstepAudio.h
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ILstep;

@interface ILstepAudio : NSManagedObject

@property (nonatomic, retain) NSData * stepAudio_data;
@property (nonatomic, retain) NSString * stepAudio_flags;
@property (nonatomic, retain) NSDate * stepAudio_modifiedDate;
@property (nonatomic, retain) NSNumber * stepAudio_version;
@property (nonatomic, retain) ILstep *belongToStep;

@end
