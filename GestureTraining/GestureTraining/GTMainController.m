//
//  GTMainController.m
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GTMainController.h"
#import "GTViewController.h"
#import "GRGesture.h"
#import "GRFilterChain.h"
#import "GREqualityFilter.h"
#import "GRDirectionFilter.h"

@implementation GTMainController
@synthesize dataRecorder = _dataRecorder;

-(void)setUpEnvironment{
    
    [super setUpEnvironment];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.viewController) {
        [(GTViewController*)self.viewController setDelegate:self];
    }
    
    // set up motion sensing
    self.motionSensor.gravitationThreshold = [userDefaults doubleForKey:kGTMotionThresholdStorageKey];
    self.motionSensor.thresholdMode = S2TM([userDefaults stringForKey:kGTMotionThresholdModeStorageKey]);
    self.motionSensor.delegate = self;
    
    // set up feedback
    NSArray* sayArray = [NSArray arrayWithObjects:@"Start", nil];
    [self.feedback preloadSaySoundsForTexts:sayArray synchronous:NO];
    
    //set up data recorder
    _dataRecorder = [[GTDataRecorder alloc] init];
    _dataRecorder.minRecordLength = MIN_RECORD_LEN;
    
    _dataRecorder.storageDataInfo = [self extractStorrageDataInfoFromUserDefaults:userDefaults];
    
    // set up filter chain
    GRFilterChain* filterChain = [[GRFilterChain alloc] init];
    GRDirectionFilter* directionFilter = [[GRDirectionFilter alloc] init];
    directionFilter.directionThreshold = [userDefaults doubleForKey:kGTDirectionThresholdStorageKey];
    GREqualityFilter* equalityFilter = [[GREqualityFilter alloc] init];
    [filterChain addFilter:directionFilter WithName:@"DirectionFilter"];
    [filterChain addFilter:equalityFilter WithName:@"EqualityFilter"];
    _dataRecorder.dataFilter = filterChain;
    
}

#pragma mark - public mehtods

-(void) backUp{
    
    NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString* fileName = kDataStorageFileName;
    fileName = [[fileName stringByDeletingPathExtension] stringByAppendingFormat:@"_%@.%@",[_dataRecorder.storageDataInfo objectForKey:kGTRecordingDateStorageKey], [fileName pathExtension]];
    NSString* storageFilePath = [documentDir stringByAppendingPathComponent:fileName];
    
    [_dataRecorder saveToFile:storageFilePath];
    
    NSString* txtFilePath = [storageFilePath stringByReplacingOccurrencesOfString:[storageFilePath pathExtension] withString:@"txt"];
    [self saveDataStorage:_dataRecorder toTextFile:txtFilePath];
    
}

#pragma mark - private methods

- (NSMutableDictionary *)extractStorrageDataInfoFromUserDefaults:(NSUserDefaults *)userDefaults {
    // getStorrageInfo from user defaults
    NSDictionary* userDefaultsDict = [userDefaults dictionaryRepresentation];
    NSMutableDictionary* storageDataInfo = [NSMutableDictionary dictionary];
    for (NSString* key in [userDefaultsDict allKeys]) {
        if ([key isEqualToString:kGTMotionIntervalStorageKey] ||
            [key isEqualToString:kGTMotionThresholdStorageKey] ||
            [key isEqualToString:kGTMotionThresholdModeStorageKey] ||
            [key isEqualToString:kGTRecordingDateStorageKey]||
            [key isEqualToString:kGTDirectionThresholdStorageKey]) {
            [storageDataInfo setObject:[userDefaultsDict objectForKey:key] forKey:key];
        }
    }
    return storageDataInfo;
}

#pragma mark - GTMotionSensorDelegate methods

-(void)motionDetected:(id)sender WithAcceleration:(CMAcceleration) acceleration{

    [super motionDetected:sender WithAcceleration:acceleration];
    
    [_dataRecorder recordData:acceleration ForLabel:recordLabel];
    
}

#pragma mark - GTViewController methods

- (void)recordingStartRequestet:(GTViewController *)sender{
    recordLabel = sender.selectedLabel;
    [self.feedback say:@"Start"];
    [super recordingStartRequestet:sender];
}

- (void)recordingStopRequestet:(GTViewController *)sender{
    
    [super recordingStopRequestet:sender];
    
    [_dataRecorder closeDataSetForLabel:recordLabel];
    [(GTViewController*)self.viewController increaseCountForLabel:recordLabel];
}

@end
