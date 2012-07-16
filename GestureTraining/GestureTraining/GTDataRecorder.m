//
//  GTDataRecorder.m
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GTDataRecorder.h"
#import "GRGesture.h"
#import "GRMotionVector.h"

@implementation GTDataRecorder
@synthesize dataFilter = _dataFilter;
@synthesize minRecordLenght = _minRecordLenght;
- (id)init
{
    self = [super init];
    if (self) {
        recordStates = [[NSMutableDictionary alloc] init];
        _recordBuffer = [[GRRecord alloc] init];
        _minRecordLenght = 0;
    }
    return self;
}

-(void)recordData:(CMAcceleration) data ForLabel:(NSString*) dataLabel{

    [_recordBuffer addObject:[[GRMotionVector alloc] initWithX:data.x Y:data.y AndZ:data.z]];
}

-(void)closeDataSetForLabel:(NSString*) dataLabel{
    [self setRecordOpen:NO ForLabel:dataLabel];
    
    if ([_recordBuffer count] > _minRecordLenght) {
        GRRecordSet* trainingSet = [_storageData objectForKey:dataLabel];
        if (!trainingSet) {
            // add new trainings set
            trainingSet = [[GRRecordSet alloc] init];
            [_storageData setObject:trainingSet forKey:dataLabel];
        }
        
        if (_dataFilter) {
            _recordBuffer = [_dataFilter filterData:_recordBuffer];
        }
        
        if (_recordBuffer) {
            // create gesture instance ans add to trainingset
            GRGesture* gesture = [[GRGesture alloc] initWithRecord:_recordBuffer];
            [trainingSet addObject:gesture];
            [_recordBuffer removeAllObjects];
        }else {
            Log(@"ERROR: record buffer empty!");
        }
    }

            
}

-(BOOL) isRecordOpenForLabel:(NSString*) label{
    NSNumber* boolNumber = [recordStates objectForKey:label];
    
    if (boolNumber) {
        return [boolNumber boolValue];
    }
    return NO;
}

-(void) setRecordOpen:(BOOL) open ForLabel:(NSString*) label{
    [recordStates setObject:[NSNumber numberWithBool:open] forKey:label];
}

@end
