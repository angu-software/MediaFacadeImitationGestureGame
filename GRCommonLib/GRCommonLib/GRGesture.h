//
//  GRGesture.h
//  GestureRecognizer
//
//  Created by Andreas on 14.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRConstants.h"

@interface GRGestureWeights : NSObject <NSCoding>

@property NSUInteger lengthWeight;
@property double maxXWeight;
@property double maxYWeight;
@property double maxZWeight;
@property double meanXWeight;
@property double meanYWeight;
@property double meanZWeight;
@property double medianXWeight;
@property double medianYWeight;
@property double medianZWeight;
@property double powerWeight;
@property double spatialExtendWeight;
@property double speedWeight;

+(GRGestureWeights*)defaultWeights;

@end

@interface GRGesture : NSObject <NSCoding>

@property (readonly) GRRecord* record;

@property NSUInteger length;
@property double maxX;
@property double maxY;
@property double maxZ;
@property double meanX;
@property double meanY;
@property double meanZ;
@property double medianX;
@property double medianY;
@property double medianZ;
@property double power;
@property double spatialExtend;
@property double speed;

@property (strong) GRGestureWeights* gestureWeights;

-(id)initWithRecord:(GRRecord*)record;
-(double) distanceTo:(GRGesture*) gesture;
-(double) gestureNorm;
@end
