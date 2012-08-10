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
@synthesize gameHost = _gameHost;
@synthesize hostPort = _hostPort;


- (id)init
{
    self = [super init];
    if (self) {
        _gameHost = HOST;
        _hostPort = PORT;
    }
    return self;
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
        if ([_liveData count] >= MIN_RECORD_LEN) {
            [self setIsAlgorithmRunning:YES];
            //filter data
            [self filterLiveData];
            GRGesture* liveGesture = [[GRGesture alloc] initWithRecord:_liveData];

            NSString* label = [_nnClassifier bestClassMatchForGesture:liveGesture];
            double minDistance = _nnClassifier.minDistance;
            [(GRViewController*)self.viewController classLabel].text = [NSString stringWithFormat:@"%@ (%f)",label,minDistance];
            [self.feedback say:label];
            [_networkController sendRecognizedClassLabel:label];
            Log(@"Gesture classified as: %@ (%f)",label,minDistance);
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

#pragma mark - overridden methods from CRMainControllerBase

- (void)checkNetwok {
    if (!_networkController.isConnected) {
        [self showAlertWithText:@"No connection to host!"];
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
        [self relauch];
    }else {
        [self showAlertWithText:[NSString stringWithFormat:@"Loading training data faild! File not found: %@", storageFilePath]];
        
    }    
    
}

-(void)tearDown{
    [self hold];
} 

-(void)relauch{
    [_networkController connect];
    [self checkNetwok];
}

-(void)hold{
    [_networkController disconnect];
}

-(void) setUpEnvironment{
    
    [super setUpEnvironment];
    
    // configuration settings from storrage file
    double interval = [[_trainingData.storageDataInfo objectForKey:kGTMotionIntervalStorageKey] doubleValue];
    double threshold = [[_trainingData.storageDataInfo objectForKey:kGTMotionThresholdStorageKey] doubleValue];
    double directionThres = [[_trainingData.storageDataInfo objectForKey:kGTDirectionThresholdStorageKey] doubleValue];
    enum ThresholdMode thMode = [[_trainingData.storageDataInfo objectForKey:kGTMotionThresholdModeStorageKey] intValue];
    
    // using settings from user defaults
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    
    BOOL userDefaultsForSettings = [defaults boolForKey:@"Filesettings"];
    if (!userDefaultsForSettings) {
        interval = [defaults doubleForKey:kGTMotionIntervalStorageKey];
        threshold = [defaults doubleForKey:kGTMotionThresholdStorageKey];
        directionThres = [defaults doubleForKey:kGTDirectionThresholdStorageKey];
        thMode = [defaults integerForKey:kGTMotionThresholdModeStorageKey];
        
        // update the storageinfo of the trainingdata
        NSMutableDictionary* newStorageInfo = [NSMutableDictionary dictionaryWithDictionary:_trainingData.storageDataInfo];
        [newStorageInfo setObject:[NSNumber numberWithDouble:interval] forKey:kGTMotionIntervalStorageKey];
        [newStorageInfo setObject:[NSNumber numberWithDouble:threshold] forKey:kGTMotionThresholdStorageKey];
        [newStorageInfo setObject:[NSNumber numberWithDouble:directionThres] forKey:kGTDirectionThresholdStorageKey];
        [newStorageInfo setObject:[NSNumber numberWithInt:thMode] forKey:kGTMotionThresholdModeStorageKey];
        _trainingData.storageDataInfo = newStorageInfo;
     
    }
    
    double classThres = [defaults doubleForKey:kGRClassificatinThresholdStorageKey];
    int patternToUseCount  = [defaults integerForKey:kGRClassificatinPatternCountStorageKey];
    
    
    self.motionSensor.detectionInterval = interval;
    self.motionSensor.gravitationThreshold = threshold;
    self.motionSensor.thresholdMode = thMode;
    
    [self setUniformGestureWeights:[GRGestureWeights defaultWeights] InStorrageData:_trainingData];
    
    // set up filter chain
    _filterChain = [[GRFilterChain alloc] init];
    GRDirectionFilter* directionFilter = [[GRDirectionFilter alloc] init];
    directionFilter.directionThreshold = directionThres;
    GREqualityFilter* equalityFilter = [[GREqualityFilter alloc] init];
    [_filterChain addFilter:directionFilter WithName:@"DirectionFilter"];
    [_filterChain addFilter:equalityFilter WithName:@"EqualityFilter"];

    // filtering trainingdata
    [_trainingData filterStorrageDataWith:_filterChain];
    
    [self.feedback preloadSaySoundsForTexts:[_trainingData classLabels] synchronous:NO];
    //ToDo: save feedback sounds from preload cache
    
    _nnClassifier = [[GRNNClassifier alloc]init];
    _nnClassifier.referenceDataStorage = _trainingData;
    _nnClassifier.classificationThreshold = classThres;
    _nnClassifier.patternToUseCount = patternToUseCount;
    
    // get host and port from user defaults
    NSString* host = [defaults stringForKey:@"Host"];
    NSUInteger port = [defaults integerForKey:@"Port"];
    NSInteger timeout = TIMEOUT;
    _networkController = [[GRNetworkClientController alloc] initWithHost:host AndPort:port];
    _networkController.connectionTimeout = timeout;
    
    // set up the view
    if (self.viewController) {
        [(GRViewController*)self.viewController setDelegate:self];
        // using key value observing to set the storageInfoLabel text when it was created
        [(GRViewController*)self.viewController addObserver:self forKeyPath:@"storageInfoLabel" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
    }
    
    if ([defaults boolForKey:@"BackupDataSet"]) {
        [self backUp];
    }
    
    [self evaluationOutput];
    
}

-(void) evaluationOutput{

    //preferences
    Log(@"Konfiguration");
    Log(@"%@",[self getPreferencesAsText]);
    
    // average vector count per class
    Log(@"Average vector count per record of gesture classes");
    for (NSString* classLabel in [_trainingData.storageData allKeys]) {
        double avrCount = 0;
        GRRecordSet* classRecord = [_trainingData.storageData objectForKey:classLabel];
        for (GRGesture* gesture in classRecord) {
            avrCount += [gesture.record count];
        }
        avrCount /= [classRecord count];
        Log(@"%@: %.2f",classLabel,avrCount);
    }
}

-(void) backUp{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HHmmddMMyy"];
    NSString* dateString = [dateFormat stringFromDate:[NSDate date]];
    
    NSString* documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //NSString* fileName = [NSString stringWithFormat:@"%@_new_%@",dateString,kDataStorageFileName];
    NSString* fileName = kDataStorageFileName;
    fileName = [[fileName stringByDeletingPathExtension] stringByAppendingFormat:@"_%@.%@",[_trainingData.storageDataInfo objectForKey:kGTRecordingDateStorageKey], [fileName pathExtension]];
    NSString* storageFilePath = [documentDir stringByAppendingPathComponent:fileName];
    
    [_trainingData saveToFile:storageFilePath];
    
    NSString* txtFilePath = [storageFilePath stringByReplacingOccurrencesOfString:[storageFilePath pathExtension] withString:@"txt"];
    [self saveDataStorage:_trainingData toTextFile:txtFilePath];
    
}

#pragma mark - private methods

-(void) filterLiveData{
    
    _liveData = [_filterChain filterData:_liveData];
    
}

- (void) setUniformGestureWeights:(GRGestureWeights*)gestureWeights InStorrageData:(GRDataStorage*) storage{
    
    for (NSString* classLabel in storage.storageData) {
        for (GRGesture* gesture in [storage.storageData objectForKey:classLabel]) {
            
            gesture.gestureWeights = gestureWeights;
            
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
    [text appendFormat:@"Direction filter threshold: %.3f\n",[[_trainingData.storageDataInfo objectForKey:kGTDirectionThresholdStorageKey] doubleValue]];
    
    return text;
}

-(void) showAlertWithText:(NSString*) alertText{
    Log(@"ERROR: %@",alertText);
    UIAlertView* allert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [allert show];
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
