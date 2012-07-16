//
//  GREqualityFilter.m
//  GestureRecognizer
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GREqualityFilter.h"
#import "GRVectorOperation.h"

@implementation GREqualityFilter

-(GRRecord*) filterData:(GRRecord*) data{
    
    //Log(@"Filtering %d vectors", [data count]);
    
    NSUInteger curr = 0;
    
    while (curr + 1 < [data count]) {
        GRMotionVector* currVector = [data objectAtIndex:curr];
        GRMotionVector* nextVector = [data objectAtIndex:curr + 1];
        
        if ([GRVectorOperation isEqual:currVector And: nextVector]) {
            [data removeObject:nextVector];
        }else {
            curr += 1;
        }
    }
    
    //Log(@"Filtering done. %d vectors left", [data count]);
    
    return data;
}

@end
