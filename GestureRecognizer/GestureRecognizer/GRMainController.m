//
//  GRMainController.m
//  GestureRecognizer
//
//  Created by Andreas on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRMainController.h"
#import "GREqualityFilter.h"
#import "GRDirectionFilter.h"
#import "GREqualityFilter.h"

@implementation GRMainController
@synthesize trainingData = _trainingData;

-(void) setUpEnvironment{
    
    [super setUpEnvironment];
    
    // configuration settings
    double interval = [[_trainingData.storageDataInfo objectForKey:kGTMotionIntervalStorageKey] doubleValue];
    double threshold = [[_trainingData.storageDataInfo objectForKey:kGTMotionThresholdStorageKey] doubleValue];
    enum ThresholdMode thMode = [[_trainingData.storageDataInfo objectForKey:kGTMotionThresholdModeStorageKey] intValue];
        
    self.motionSensor.detectionInterval = interval;
    self.motionSensor.gravitationThreshold = threshold;
    self.motionSensor.thresholdMode = thMode;
    
    GRGestureWeights* gestureWeights = [[GRGestureWeights alloc]init];
    gestureWeights.lenghtWeight = WEIGHT_LEN;
    gestureWeights.maxXWeight = WEIGHT_MAX_X;
    gestureWeights.maxYWeight = WEIGHT_MAX_Y;
    gestureWeights.maxZWeight = WEIGHT_MAX_Z;
    gestureWeights.meanXWeight = WEIGHT_MEAN_X;
    gestureWeights.meanYWeight = WEIGHT_MEAN_Y;
    gestureWeights.meanZWeight = WEIGHT_MEAN_Z;
    gestureWeights.medianXWeight = WEIGHT_MEDIAN_X;
    gestureWeights.medianYWeight = WEIGHT_MEDIAN_Y;
    gestureWeights.medianZWeight = WEIGHT_MEDIAN_Z;
    gestureWeights.powerWeight = WEIGHT_POWER;
    gestureWeights.speedWeight = WEIGHT_SPEED;
    gestureWeights.spatialExtendWeight = WEIGHT_SPAEXT;
    
    [self setUniformGestureWeights:gestureWeights InStorrageData:_trainingData];
    
    [self.feedback preloadSaySoundsForTexts:[_trainingData classLabels] synchronous:NO];
    
    _nnClassifier = [[GRNNClassifier alloc]init];
    _nnClassifier.referenceDataStorage = _trainingData;
    
    // set up the view
    if (self.viewController) {
        [(GRViewController*)self.viewController setDelegate:self];
        // using key value observing to set the storageInfoLabel text when it was created
        [(GRViewController*)self.viewController addObserver:self forKeyPath:@"storageInfoLabel" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    }
}

- (void)launch{
    
    // set Up with contents of file
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* storageFilePath = [docPath stringByAppendingPathComponent:kDataStorageFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:storageFilePath]) {
        Log(@"Loading training data from file: %@", storageFilePath);
        _trainingData = [[GRDataStorage alloc] initWithContensOfFile:storageFilePath];
        Log(@"trainin data=%@",_trainingData);
        if (_trainingData.storageDataInfo) {
            // set the same properties as at record time
            [super launch];
        }
        Log(@"Initialisatzion done");
    }else {
        Log(@"Loading training data faild! File not found: %@", storageFilePath);
        UIAlertView* allert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No training data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [allert show];
    }
    
}

#pragma mark - GTMotionSensorDelegate methods

- (void)motionDetected:(id)sender WithAcceleration:(CMAcceleration)acceleration{
    [super motionDetected:sender WithAcceleration:acceleration];
    
    if(!_liveData){
        _liveData = [[NSMutableArray alloc] init];
    }
    
    GRMotionVector* vector = [[GRMotionVector alloc] initWithX:acceleration.x Y:acceleration.y AndZ:acceleration.z];

    [_liveData addObject:vector];
    
}

-(void)motionFinished:(id)sender{
    //not implemented by motion sensor
    // method is called from self
    
    if (sender == self) {
        // run recognition        
        if ([_liveData count] > MIN_RECORD_LEN) {
            [self setIsAlgorithmRunning:YES];
            GRGesture* liveGesture = [[GRGesture alloc] initWithRecord:_liveData];
            NSString* label = [_nnClassifier bestClassMatchFor:liveGesture];
            [(GRViewController*)self.viewController classLabel].text = label;
            [self.feedback say:label];
            [self setIsAlgorithmRunning:NO];
        }
        [_liveData removeAllObjects];
        
    }  
}

#pragma mark - GTViewController methods

- (void)recordingStopRequestet:(id)sender{
    [super recordingStopRequestet:sender];
    [self motionFinished:self];
}

#pragma mark - private methods

- (void) setUniformGestureWeights:(GRGestureWeights*)gestureWeights InStorrageData:(GRDataStorage*) storage{

    for (NSString* classLabel in storage.storageData) {
        for (GRRecordSet* classRecodSet in [storage.storageData objectForKey:classLabel]) {
            for (GRGesture* gesture in classRecodSet) {
                gesture.gestureWeights = gestureWeights;
            }
        }
    }
    
}

-(void) setIsAlgorithmRunning:(BOOL)running{
    
    if (self.viewController) {
        GRViewController* vctrl = (GRViewController*)self.viewController;
        running == YES ? [vctrl.activityIndicator startAnimating] : [vctrl.activityIndicator stopAnimating];
    }
}

-(NSString*) getPreferencesAsText{

    NSMutableString* text = [[NSMutableString alloc] init];
    [text appendFormat:@"Preferences:\n"];
    [text appendFormat:@"Training data recorded: %@\n",[_trainingData.storageDataInfo objectForKey:kGTRecordingDateStorageKey]];
    [text appendFormat:@"Motion sensing : %.0fHz\n",[[_trainingData.storageDataInfo objectForKey:kGTMotionIntervalStorageKey] doubleValue]];
    [text appendFormat:@"Motion threshold : %.2fg\n",[[_trainingData.storageDataInfo objectForKey:kGTMotionThresholdStorageKey] doubleValue]];
    //[text appendFormat:@"Motion threshold mode : %@\n",[[_trainingData.storageDataInfo objectForKey:kGTMotionThresholdModeStorageKey] string]];
    [text appendFormat:@"Direction filter threshold: %.2f\n",DIRECTION_FILTER_THRESHOLD];
    
    return text;
}

// using key value observing to set the storageInfoLabel text when it was created
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(keyPath == @"storageInfoLabel" && object != nil){
        [((GRViewController*)self.viewController).storageInfoLabel setText:[self getPreferencesAsText]];
    }
}

#pragma mark - former GRRecognizer methods

- (void)calculateRepresentationModelWith:(GRDataStorage *)trainingData {
    _referenceModel = [[GRDataStorage alloc] init];
    NSMutableDictionary* referenceData = [[NSMutableDictionary alloc] init];
    for (NSString* classLabel in trainingData.storageData) {
        NSArray* recordSet = [trainingData.storageData objectForKey:classLabel];
        NSMutableArray* clusterRecordSet = [[NSMutableArray alloc] init];
        for (GRRecord* record in recordSet) {
            // representation with GRGesture
            GRGesture* gesture = [[GRGesture alloc] initWithRecord:record];
            [clusterRecordSet addObject:gesture];
        }
        [referenceData setObject:clusterRecordSet forKey:classLabel];
    }
    [_referenceModel setStorageData:referenceData];
}

-(void) printRepresentation{
    
    for (NSString* classLabel in [_referenceModel.storageData allKeys]) {
        GRRecordSet* classRecSet = [_referenceModel.storageData objectForKey:classLabel];
        Log(@"Records for class: %@",classLabel);
        for (GRGesture* gesture in classRecSet) {
            Log(@"%@",gesture);
        }
    }
}

@end
