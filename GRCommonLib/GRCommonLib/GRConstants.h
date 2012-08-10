//
//  GRConstants.h
//  GestureTraining
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDataStorageFileName @"TrainingData.gtd"
#define kConfigurationFileName @"RecognitionConfig.plist"
// storage keys
#define kGTMotionIntervalStorageKey @"MotionInterval"
#define kGTMotionThresholdStorageKey @"MotionThreshold"
#define kGTMotionThresholdModeStorageKey @"ThresholdMode"
#define kGTRecordingDateStorageKey @"RecordingDate"
#define kGTStorageInfoIdentifier @"StorageInfo"
#define kGTDirectionThresholdStorageKey @"DirectionFilterThreshold"
#define kGRClassificatinThresholdStorageKey @"ClassificationThreshold"
#define kGRClassificatinPatternCountStorageKey @"PatternCount"
#define kHostStorageKey @"Host"
#define kPortStorageKey @"Port"

#define kVectorPositionX 0
#define kVectorPositionY 1
#define kVectorPositionZ 2

typedef NSMutableArray GRRecordSet;
typedef NSMutableArray GRRecord; // discribes a gesture with a array of vectors

#define MOTION_INTERVAL 60.0f // Hz arcording to Documentation
#define MOTION_THRESHOLD 1.2f 
#define MOTION_TM TMAllAxes
#define DIRECTION_FILTER_THRESHOLD 0.0f //0;0.2f;0.07;0.02f;0.007;0.003f
#define MIN_RECORD_LEN 20
#define CLASSIFICATION_THRES 100
#define PATTERN_TO_USE_COUNT 20

#define WEIGHT_MAX_X 1.0f       //1;1;0;0;0;0   |0.5
#define WEIGHT_MAX_Y 1.0f       //1;1;0;0;0;0   |0.5
#define WEIGHT_MAX_Z 1.0f       //1;1;0;0;0;0   |0.25
#define WEIGHT_MEAN_X 1.0f      //1;0;1;0;0;0   |1
#define WEIGHT_MEAN_Y 1.0f      //1;0;1;0;0;0   |1
#define WEIGHT_MEAN_Z 1.0f      //1;0;1;0;0;0   |0.75
#define WEIGHT_MEDIAN_X 1.0f    //1;0;0;1;0;0   |1
#define WEIGHT_MEDIAN_Y 1.0f    //1;0;0;1;0;0   |1
#define WEIGHT_MEDIAN_Z 1.0f    //1;0;0;1;0;0   |0.75
#define WEIGHT_POWER 1.0f       //1;0;0;0;1;0   |0.5
#define WEIGHT_SPEED 1.0f       //1;0;0;0;1;0   |0.5
#define WEIGHT_SPAEXT 1.0f      //1;0;0;0;1;0   |0.5
#define WEIGHT_LEN 1.0f         //1;0;0;0;0;1   |1

#define HOST @"localhost"
#define PORT 1234567
#define TIMEOUT 30
