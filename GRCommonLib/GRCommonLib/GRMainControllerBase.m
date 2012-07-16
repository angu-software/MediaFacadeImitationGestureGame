//
//  GTMainController.m
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRMainControllerBase.h"

#define MOTION_INTERVAL 50.0f // Hz arcording to Documentation
#define MOTION_THRESHOLD 1.2f //1.2f //1.4f //1.6f
#define MOTION_TM TMAllAxes

@interface  GRMainControllerBase ()

@end

@implementation GRMainControllerBase
@synthesize motionSensor = _motionSensor;
@synthesize feedback = _feedback;
@synthesize viewController = _viewController;

-(void)setUpEnvironment{
    [self setUpPreferencesDefaults];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    _motionSensor = [[GRMotionSensor alloc] initWithInterval:[userDefaults doubleForKey:kGTMotionIntervalStorageKey]];
    _motionSensor.delegate = self;
    //set up feedback
    _feedback = [[GRFeedbackController alloc] init];
}

-(void)setUpPreferencesDefaults{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HHmmddMMyy"];
    NSString* dateString = [dateFormat stringFromDate:[NSDate date]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithDouble:MOTION_INTERVAL],kGTMotionIntervalStorageKey,
                                                             [NSNumber numberWithDouble:MOTION_THRESHOLD],kGTMotionThresholdStorageKey,
                                                             TM2S(MOTION_TM),kGTMotionThresholdModeStorageKey,
                                                             dateString, kGTRecordingDateStorageKey,
                                                             nil]];

}

#pragma mark - public mehtods

-(void) launch{
    [self setUpEnvironment];
    
}

#pragma mark - GTMotionSensorDelegate methods

-(void)motionDetected:(id)sender WithAcceleration:(CMAcceleration) acceleration{
    // start recording data
    Log(@"Motion detected at: (x=%.2f,y=%.2f,z=%.2f)",
         acceleration.x,
         acceleration.y,
         acceleration.z);
}

#pragma mark - GTViewController methods

- (void)recordingStartRequestet:(UIViewController *)sender{
    [_motionSensor beginSensing];
}

- (void)recordingStopRequestet:(UIViewController *)sender{
    [_motionSensor endSensing];
}

@end
