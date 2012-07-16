//
//  GRFilterChain.m
//  GestureRecognizer
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRFilterChain.h"

@implementation GRFilterChain

- (id)init
{
    self = [super init];
    if (self) {
        _filterDict = [[NSMutableDictionary alloc] init];
        _filterChain = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addFilter:(id<GRFilter>) filter WithName:(NSString*)name{
    [_filterDict setObject:filter forKey:name];
    [_filterChain addObject:filter];
}

-(void) removeFilterWithName:(NSString*) name{
    
    id<GRFilter> filter = [_filterDict objectForKey:name];
    if (filter) {
        [_filterChain removeObject:filter];
        [_filterDict removeObjectForKey:name];
    }
    filter = nil;
}

-(id<GRFilter>) filterWithName:(NSString*) name{
    return [_filterDict objectForKey:name];
}

#pragma mark - GRFilter methods

-(GRRecord*) filterData:(GRRecord*) data{

    if ([_filterChain count] > 0) {
        return [self filterData:data WithFilterAtChainIndex:0];
    }
    return data;
}

#pragma mark - private methods

-(GRRecord*) filterData:(NSMutableArray *)data WithFilterAtChainIndex:(NSUInteger) filterIndex{
    
    GRRecord* filteredData = [[_filterChain objectAtIndex:filterIndex] filterData:data];
    
    if ((filterIndex+1) < [_filterChain count]) {
        return [self filterData:filteredData WithFilterAtChainIndex:filterIndex+1];
    }
    
    return filteredData;
} 

@end
