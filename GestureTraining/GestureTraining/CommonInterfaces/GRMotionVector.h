//
//  GRMotionVector.h
//  GestureTraining
//
//  Created by Andreas on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRMotionVector : NSObject <NSCoding>

@property double x;
@property double y;
@property double z;

-(id)initWithX:(double)x Y:(double)y AndZ:(double)z;

@end
