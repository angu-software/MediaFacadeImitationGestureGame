//
//  GRDistanceMeasure.h
//  GestureRecognizer
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GRConstants.h"
#include "GRMotionVector.h"

@interface GRVectorOperation : NSObject

+ (GRMotionVector*) sacaleVector:(GRMotionVector*) vector withFactor:(double) scale;
+ (GRMotionVector*) massOfVectors:(GRRecord*) vectorArray;
+ (double) euclideanDistanceOf:(GRMotionVector*) vect1 And:(GRMotionVector*) vect2;
+ (double) euclideanNormOf:(GRMotionVector*) vect;
+ (GRMotionVector*) differenceOf:(GRMotionVector*) vect1 And:(GRMotionVector*) vect2;
+ (BOOL) isEqual:(GRMotionVector*) vect1 And:(GRMotionVector*) vect2;

@end
