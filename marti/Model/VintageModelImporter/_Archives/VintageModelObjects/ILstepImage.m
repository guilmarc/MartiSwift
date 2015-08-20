//
//  ILstepImage.m
//  marti
//
//  Created by Paul Legault Local on 11-12-09.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ILstepImage.h"
#import "ILstep.h"


@implementation ILstepImage

@dynamic stepImage_data;
@dynamic stepImage_flags;
@dynamic stepImage_modifiedDate;
@dynamic stepImage_version;
@dynamic belongToStep;
@dynamic steppictogramid;


-(void)setPictogramid:(NSString*) pictId{
    self.steppictogramid = pictId;
}
@end
