//
//  GRNNClassifier.m
//  GestureRecognizer
//
//  Created by Andreas on 14.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRNNClassifier.h"

@implementation GRNNClassifier
@synthesize referenceDataStorage = _referenceDataStorage;

-(NSString*) bestClassMatchFor:(GRGesture*)gesture{
    Log(@"Clac best match for gesture");
    double minDistance = DBL_MAX;
    NSString* bestMatch = @"NONE";
    for (NSString* classLabel in [_referenceDataStorage.storageData allKeys]) {
        double distance = [self minDistanceBetween:gesture AndClass:classLabel];
        if (minDistance > distance) {
            minDistance = distance;
            bestMatch = classLabel;
        }
    }
    
    return bestMatch;
}

#pragma mark - private methods

-(double) minDistanceBetween:(GRGesture*) gesture AndClass:(NSString*) classLabel{
    Log(@"Clac min distance for class %@", classLabel);
    double minDistance = DBL_MAX;
    GRRecordSet* classRecordSet = [_referenceDataStorage.storageData objectForKey:classLabel];
    for (GRGesture* trainingGesture in classRecordSet) {
        double distance = [trainingGesture distanceTo:gesture];
        if (minDistance > distance) {
            minDistance = distance;
        }
    }
    Log(@"min distance: %f", minDistance);    
    return minDistance;
}

/*
-(NSString*) bestClassMatchFor:(GRRecord*)record{
     minDistance = MAX;
    NSString* bestMatch = @"NONE";
    for (NSString* classLabel in [_referenceDataStorage.storageData allKeys]) {
         distance = [self minDistanceBetween:record AndClass:classLabel];
        if (distance < minDistance) {
            minDistance = distance;
            bestMatch = classLabel;
        }
    }
    
    return bestMatch;
}

#pragma mark - private methods

-() minDistanceBetween:(GRRecord*) record AndClass:(NSString*) classLabel{

     minDistance = MAX;
    GRRecordSet* classRecordSet = [_referenceDataStorage.storageData objectForKey:classLabel];
    for (GRRecord* classRec in classRecordSet) {
         distance = [self distanceBetween:record And:classRec];
        if (distance < minDistance) {
            minDistance = distance;
        }
    }
    
    return minDistance;
}

-() distanceBetween:(GRRecord*)record1 And:(GRRecord*) record2{
    
     distSum = 0.0f;
    NSUInteger minLen = [record1 count] < [record2 count] ? [record1 count] : [record2 count];
    for (NSUInteger i = 0; i < minLen; ++i) {
        distSum += [GRVectorOperation euclideanDistanceOf:[record1 objectAtIndex:i] And:[record2 objectAtIndex:i]];
    }
    
     kminDist[5];
    for (int i = 0; i < 5; ++i) {
        kminDist[i] = MAX;
    }
    for (NSUInteger i = 0; i < minLen; ++i) {
         dist = [GRVectorOperation euclideanDistanceOf:[record1 objectAtIndex:i] And:[record2 objectAtIndex:i]];
        for (int i = 0; i < 5; ++i) {
            if (dist < kminDist[i]) {
                kminDist[i] = dist;
            }
        }
    }
    for (int i = 0; i < 5; ++i) {
       distSum += kminDist[i];
    }
    
    return distSum;
}
*/
@end
