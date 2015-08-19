//
//  VintageDataImporter.h
//  MartiPro
//
//  Created by Marco Guilmette on 2/13/2014.
//  Copyright (c) 2014 Infologique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VintageDataImporter : NSObject

-(void)importData;
+ (VintageDataImporter*)sharedInstance;

@end
