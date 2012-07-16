//
//  GRDirectionFilter.m
//  GestureRecognizer
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRDirectionFilter.h"
#import "GRVectorOperation.h"

@implementation GRDirectionFilter
@synthesize directionThreshold;

- (id)init
{
    self = [super init];
    if (self) {
        self.directionThreshold = 0.2f;
    }
    return self;
}

-(GRRecord*) filterData:(GRRecord*) data{
    
    //Log(@"Filtering %d vectors", [data count]);
    
    NSUInteger curr = 0;
    
    while (curr + 1 < [data count]) {
        GRMotionVector* currVector = [data objectAtIndex:curr];
        GRMotionVector* nextVector = [data objectAtIndex:curr + 1];
        
        GRMotionVector* diffVector = [GRVectorOperation differenceOf:currVector And:nextVector];
        
        if ([GRVectorOperation euclideanNormOf:diffVector] < self.directionThreshold) {
            [data removeObject:nextVector];
        }else {
            curr += 1;
        }
    }
    
    //Log(@"Filtering done. %d vectors left", [data count]);
    
    return data;
}

@end
