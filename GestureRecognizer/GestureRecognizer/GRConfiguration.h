//
//  GRConfiguration.h
//  GestureRecognizer
//
//  Created by Andreas on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGestureWeightsCfgKey @"GestureWeights"
#define kGestureWeightsMaxCfgKey @"MaxG"
#define kGestureWeightsMeanCfgKey @"MeanG"
#define kGestureWeightsMedianCfgKey @"MedianG"
#define kGestureWeightsPowerCfgKey @"Power"
#define kGestureWeightsSpeedCfgKey @"Speed"
#define kGestureWeightsSpationExtendCfgKey @"SpatialExtension"
#define kMinRecordLenCfgKey @"MinRecordLen"

@interface GRConfiguration : NSObject

@end
