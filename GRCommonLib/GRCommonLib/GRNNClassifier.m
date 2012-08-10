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
@synthesize classificationThreshold = _classificationThreshold;
@synthesize patternToUseCount = _patternToUseCount;
@synthesize minDistance = _minDistance;

-(NSString*) bestClassMatchForGesture:(GRGesture*)gesture{
    Log(@"Clac best match for gesture");
    _minDistance = DBL_MAX;
    NSString* bestMatch = kNoMatch;
    for (NSString* classLabel in [_referenceDataStorage.storageData allKeys]) {
        double distance = [self minDistanceBetween:gesture AndClass:classLabel];
        if (_minDistance > distance) {
            _minDistance = distance;
            bestMatch = classLabel;
        }
    }
    
    if (_minDistance <= _classificationThreshold) {
        return bestMatch;
    }
    
    return kNoMatch;
}

#pragma mark - private methods

-(double) minDistanceBetween:(GRGesture*) gesture AndClass:(NSString*) classLabel{
    Log(@"Clac min distance for class %@", classLabel);
    double minDistance = DBL_MAX;
    GRRecordSet* classRecordSet = [_referenceDataStorage.storageData objectForKey:classLabel];
    for (NSUInteger idx = 0; idx < _patternToUseCount && idx < [classRecordSet count]; ++idx) {
        GRGesture* trainingGesture = [classRecordSet objectAtIndex:idx];
        double distance = [trainingGesture distanceTo:gesture];
        if (minDistance > distance) {
            minDistance = distance;
        }
    }
    Log(@"min distance: %f", minDistance);    
    return minDistance;
}

@end
