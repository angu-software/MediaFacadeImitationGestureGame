//
//  GTDataRecorder.h
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "GRDataStorage.h"
#import "GRFilterChain.h"


@interface GTDataRecorder : GRDataStorage {

    NSMutableDictionary* recordStates;
    GRRecord* _recordBuffer;
}

// filters the recordet data before stored as GRGesture
@property (strong) id<GRFilter> dataFilter;
@property NSUInteger minRecordLength;

-(void)recordData:(CMAcceleration) data ForLabel:(NSString*) label;
-(void)closeDataSetForLabel:(NSString*) dataLabel;
-(BOOL) isRecordOpenForLabel:(NSString*) label;

@end
