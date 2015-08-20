//
//  Step+Human.m
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "Step+Human.h"

@implementation Step (Human)

-(BOOL)isMediaStep {return false;}
-(BOOL)isRoutingStep {return false;}
-(BOOL)isSelectionStep {return false;}

-(UIImage*)thumbnailImage{
    
    return [UIImage imageWithData:self.thumbnail];
    
}





@end
