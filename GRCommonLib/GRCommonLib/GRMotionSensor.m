//
//  GTMotionSensor.m
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRMotionSensor.h"

@implementation GRMotionSensor
@synthesize gravitationThreshold = _gravitationThreshold;
@synthesize thresholdMode = _thresholdMode;
@synthesize delegate = _delegate;
@synthesize detectionInterval = _detectionInterval;

- (id)initWithInterval:(NSUInteger)valueHz
{
    self = [super init];
    if (self) {
        _motionManager = [[CMMotionManager alloc] init];
        [_motionManager setAccelerometerUpdateInterval:1/valueHz];
        self.gravitationThreshold = 1.0f;
    }
    return self;
}

-(void) beginSensing{
    if (self.delegate) {
        Log(@"Start sensing. Inerval: %.2fs G-Threshold: %.2fG G-ThresMode: %@",
             [_motionManager accelerometerUpdateInterval],
             self.gravitationThreshold,
             TM2S(self.thresholdMode));
        NSOperationQueue* accQueue = [[NSOperationQueue alloc] init];
        [_motionManager startAccelerometerUpdatesToQueue:accQueue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            /*XLog(@"Motion: (x=%.2f,y=%.2f;z=%.2f)",
                 accelerometerData.acceleration.x,
                 accelerometerData.acceleration.y,
                 accelerometerData.acceleration.z);
             */
            [self updateCurrentAccelerationWith:accelerometerData.acceleration];
            if ([self accelerometerDataExceedsThreshold:_currAcceleration]) {
               
                // motion starts
                isMotionInProgress = YES;
                [self.delegate motionDetected:self WithAcceleration:_currAcceleration];
            }else if(isMotionInProgress){
                // motion finished
                isMotionInProgress = NO;
                if ([self.delegate respondsToSelector:@selector(motionFinished:)]) {
                    // not implemented. Reason: decision for condition when motion is finished is related to the start-stop-problem in pattern recognition
                    //[self.delegate motionFinished:self];
                }

            }
            
        }];
    }else {
        Log(@"Won't start sensing. No delegate set!");
    }
}

-(void) endSensing{
    Log(@"Sensing finished");
    [_motionManager stopAccelerometerUpdates];
} 

#pragma mark --- private methods

-(BOOL) accelerometerDataExceedsThreshold:(CMAcceleration)acceleration{

    double thresValueTest = 0; // holds the value that should be testet against the threshold with respect to the thresold mode
    switch (self.thresholdMode) {
        case TMXAxes:
            thresValueTest = fabs(acceleration.x);
            break;
        case TMYAxes:
            thresValueTest = fabs(acceleration.y);
            break;
        case TMZAxes:
            thresValueTest = fabs(acceleration.z);
            break;
        default:
            // euclids norm
            thresValueTest = sqrtf(powf(acceleration.x, 2.0f) + powf(acceleration.y, 2.0f) + powf(acceleration.z, 2.0f));
            break;
    }
    
    return thresValueTest >= (self.gravitationThreshold);
    
}

#define kFilteringFactor 0.1f

-(void) updateCurrentAccelerationWith:(CMAcceleration) acceleration{

    
    // using simple high-pass filter to extract the instanious motion (see Motion Events Handling Guide)
    
    // Subtract the low-pass value from the current value to get a simplified high-pass filter
    //_currAcceleration.x = acceleration.x - ( (acceleration.x * kFilteringFactor) + (_currAcceleration.x * (1.0 - kFilteringFactor)) );
    //_currAcceleration.y = acceleration.y - ( (acceleration.y * kFilteringFactor) + (_currAcceleration.y * (1.0 - kFilteringFactor)) );
    //_currAcceleration.z = acceleration.z - ( (acceleration.z * kFilteringFactor) + (_currAcceleration.z * (1.0 - kFilteringFactor)) );
    
    // Use the acceleration data. 
    
    _currAcceleration.x = acceleration.x;
    _currAcceleration.y = acceleration.y;
    _currAcceleration.z = acceleration.z;
}

@end
