//
//  GTMainController.m
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRMainControllerBase.h"

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
                                                             [NSNumber numberWithDouble:DIRECTION_FILTER_THRESHOLD],kGTDirectionThresholdStorageKey,
                                                             [NSNumber numberWithDouble:CLASSIFICATION_THRES],kGRClassificatinThresholdStorageKey,
                                                             [NSNumber numberWithInt:PATTERN_TO_USE_COUNT],kGRClassificatinPatternCountStorageKey,
                                                             TM2S(MOTION_TM),kGTMotionThresholdModeStorageKey,
                                                             dateString, kGTRecordingDateStorageKey,
                                                             HOST,kHostStorageKey,
                                                             [NSNumber numberWithInt:PORT],kPortStorageKey,
                                                             
                                                             nil]];

}

#pragma mark - public mehtods

-(void) launch{
    [self setUpEnvironment];
    
}

-(void) relauch{

}

-(void) hold{

}

-(void) tearDown{

}

-(void)saveDataStorage:(GRDataStorage*) storage toTextFile:(NSString*) filePath{
    
    NSMutableString* textViewContent = [[NSMutableString alloc] init];
    
    //storageInfo
    [textViewContent appendString:@"######## StorageInfo ########\n"];
    for (NSString* infoKey in [storage.storageDataInfo allKeys]) {
        [textViewContent appendFormat:@"# %@: %@\n",infoKey, [storage.storageDataInfo objectForKey:infoKey]];
    }
    //storage data
    NSUInteger num = 0;
    NSUInteger lineNum = 0;
    [textViewContent appendString:@"######## StorageData ########\n"];
    [textViewContent appendString:@"# lineNum;classNum;Class;Norm;X;Y;Z;VecPos\n"];
    for (NSString* classLabel in [storage.storageData allKeys]) {
        //Log(@"%@",classLabel);
        ++num;
        for (GRGesture* gesture in [storage.storageData objectForKey:classLabel]) {
            GRRecord* record = gesture.record;
            for (GRMotionVector* vector in record) {
                [textViewContent appendFormat:@"%d;%d;%@;%f;%f;%f;%f\n",
                 ++lineNum,
                 num,
                 classLabel,
                 [gesture gestureNorm],
                 vector.x,
                 vector.y,
                 vector.z];
            }
        }
    }
    
    // save to file
    NSData* txtData = [textViewContent dataUsingEncoding:NSUTF8StringEncoding];
    if ([txtData writeToFile:filePath atomically:YES]) {
        //[_statusLabel setStringValue:[NSString stringWithFormat:@"Saved to: %@",txtFilePath]];
    };
}

#pragma mark - GTMotionSensorDelegate methods

-(void)motionDetected:(id)sender WithAcceleration:(CMAcceleration) acceleration{
    // start recording data
    /*
    Log(@"Motion detected at: (x=%.2f,y=%.2f,z=%.2f)",
         acceleration.x,
         acceleration.y,
         acceleration.z);
     */
}

#pragma mark - GTViewController methods

- (void)recordingStartRequestet:(UIViewController *)sender{
    [_motionSensor beginSensing];
}

- (void)recordingStopRequestet:(UIViewController *)sender{
    [_motionSensor endSensing];
}

@end
