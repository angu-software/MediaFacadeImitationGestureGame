//
//  GRTrainigData.h
//  GestureRecognizer
//
//  Created by Andreas on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRFilter.h"
#import "GRMotionVector.h"

@interface GRDataStorage : NSObject{
    
    @protected
    NSMutableDictionary* _storageData;
    NSMutableDictionary* _storageDataInfo;
}

@property (readonly, strong) NSArray* classLabels;
@property (nonatomic, strong) NSDictionary* storageDataInfo;
@property (nonatomic, strong) NSDictionary* storageData;
@property BOOL isFiltered;

-(id) initWithContensOfFile:(NSString*) fileName;
-(void) filterStorrageDataWith:(id<GRFilter>) filter;
-(void)saveToFile:(NSString*) fileName;

@end
