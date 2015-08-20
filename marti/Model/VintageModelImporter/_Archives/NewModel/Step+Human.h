//
//  Step+Human.h
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "Step.h"

@interface Step (Human)


-(BOOL)isMediaStep;
-(BOOL)isRoutingStep;
-(BOOL)isSelectionStep;

-(UIImage*)thumbnailImage;

@end
