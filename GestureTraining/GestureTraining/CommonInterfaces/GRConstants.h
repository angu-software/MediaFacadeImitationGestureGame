//
//  GRConstants.h
//  GestureTraining
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDataStorageFileName @"TraingData.gtd"
#define kConfigurationFileName @"RecognitionConfig.plist"
// storage keys
#define kGTMotionIntervalStorageKey @"MotionInterval"
#define kGTMotionThresholdStorageKey @"MotionThreshold"
#define kGTMotionThresholdModeStorageKey @"ThresholdMode"
#define kGTRecordingDateStorageKey @"RecordingDate"
#define kGTStorageInfoIdentifier @"StorageInfo"

#define kVectorPositionX 0
#define kVectorPositionY 1
#define kVectorPositionZ 2

typedef NSMutableArray GRRecordSet;
typedef NSMutableArray GRRecord; // discribes a gesture with a array of vectors

#define DIRECTION_FILTER_THRESHOLD 0.2f
#define MIN_RECORD_LEN 20

#define WEIGHT_MAX_X 0.5f
#define WEIGHT_MAX_Y 0.5f
#define WEIGHT_MAX_Z 0.25f
#define WEIGHT_MEAN_X 1
#define WEIGHT_MEAN_Y 1
#define WEIGHT_MEAN_Z 0.75f
#define WEIGHT_MEDIAN_X 1
#define WEIGHT_MEDIAN_Y 1
#define WEIGHT_MEDIAN_Z 0.75f
#define WEIGHT_POWER 0.5f
#define WEIGHT_SPEED 0.5f
#define WEIGHT_SPAEXT 0.5f
#define WEIGHT_LEN 1