//
//  PlannedEvent.h
//  marti
//
//  Created by Marco Guilmette on 3/1/2014.
//
//

#import <Foundation/Foundation.h>

#import "ScheduledEvent.h"


@interface PlannedEvent : NSObject

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) ScheduledEvent* scheduledEvent;

-(instancetype)initWithScheduledEvent:(ScheduledEvent*)scheduledEvent andDate:(NSDate*)eventDate;

@end
