//
//  GRDistanceMeasure.m
//  GestureRecognizer
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRVectorOperation.h"

@implementation GRVectorOperation

+ (GRMotionVector*) sacaleVector:(GRMotionVector*) vector withFactor:(double) scale{
    
    GRMotionVector* scaleVect = [[GRMotionVector alloc] init];
    
    scaleVect.x = vector.x * scale;
    scaleVect.y = vector.y * scale;
    scaleVect.z = vector.z * scale;
    
    return scaleVect;
    
}

+ (double) euclideanDistanceOf:(GRMotionVector*) vect1 And:(GRMotionVector*) vect2{

    double distance = sqrtf(powf(vect1.x-vect2.x,2) + powf(vect1.y-vect2.y,2) + powf(vect1.z-vect2.z,2));
    return distance;
}

+ (double) euclideanNormOf:(GRMotionVector*) vect{

    return sqrtf(powf(vect.x, 2.0f) + powf(vect.y, 2.0f) + powf(vect.z, 2.0f));
}

+ (GRMotionVector*) differenceOf:(GRMotionVector*) vect1 And:(GRMotionVector*) vect2{
    
    GRMotionVector* diffVect = [[GRMotionVector alloc] init];
    
    diffVect.x = vect1.x - vect2.x;
    diffVect.y = vect1.y - vect2.y;
    diffVect.z = vect1.z - vect2.z;
    
    return diffVect;
}

+ (GRMotionVector*) massOfVectors:(GRRecord*) vectorArray{

    GRMotionVector* mass = [[GRMotionVector alloc] init];
    NSUInteger vectorCount = [vectorArray count];
    
    for (GRMotionVector* vector in vectorArray) {
        mass.x += vector.x;
        mass.y += vector.y;
        mass.z += vector.z;
    }
    mass.x = mass.x/(double)vectorCount;
    mass.y = mass.y/(double)vectorCount;
    mass.z = mass.z/(double)vectorCount;
    
    return mass;
}

+ (BOOL) isEqual:(GRMotionVector*) vect1 And:(GRMotionVector*) vect2{
    
    return (vect1.x == vect2.x &&
            vect1.y == vect2.y &&
            vect1.z == vect2.z);
}

@end
