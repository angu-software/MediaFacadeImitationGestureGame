//
//  GTMotionSensor.h
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

#define TM2S(x) (x==TMAllAxes)?(@"TMAllAxes"):((x==TMXAxes)?(@"TMXAxes"):((x==TMYAxes)?(@"TMYAxes"):(@"TMZAxes")))
#define S2TM(x) (x==@"TMAllAxes")?(TMAllAxes):((x==@"TMXAxes")?(TMXAxes):((x==@"TMYAxes")?(TMYAxes):(TMZAxes)))

enum ThresholdMode{
    TMAllAxes = 0,
    TMXAxes = 1,
    TMYAxes = 2,
    TMZAxes = 3,
}ThresholdMode;

@protocol GRMotionSensorDelegate <NSObject>

-(void)motionDetected:(id)sender WithAcceleration:(CMAcceleration) acceleration;
@optional
-(void)motionFinished:(id)sender;

@end

@interface GRMotionSensor : NSObject{

    CMMotionManager* _motionManager;
    BOOL isMotionInProgress; // YES if motion manager detect motion over threshold, NO if motion falls under threshold after motion was detected over threshold. Not implemented yet
    CMAcceleration _currAcceleration; // the current acceleration of the device
}

@property NSTimeInterval detectionInterval;
@property double gravitationThreshold;
@property enum ThresholdMode thresholdMode;
@property id<GRMotionSensorDelegate> delegate;

// interval in Hz
- (id)initWithInterval:(NSUInteger)valueHz;
-(void) beginSensing;
-(void) endSensing;

@end