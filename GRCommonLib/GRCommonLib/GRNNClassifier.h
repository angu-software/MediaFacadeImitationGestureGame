//
//  GRNNClassifier.h
//  GestureRecognizer
//
//  Created by Andreas on 14.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRDataStorage.h"
#import "GRGesture.h"

#define kNoMatch @"No match"

@interface GRNNClassifier : NSObject

@property GRDataStorage* referenceDataStorage;
@property double classificationThreshold;
@property NSUInteger patternToUseCount;
@property double minDistance;

-(NSString*) bestClassMatchForGesture:(GRGesture*)gesture;

@end
