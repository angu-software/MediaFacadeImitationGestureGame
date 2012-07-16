//
//  GRFilterChain.h
//  GestureRecognizer
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRFilter.h"

@interface GRFilterChain : NSObject <GRFilter>{

    NSMutableDictionary* _filterDict;
    NSMutableArray* _filterChain;
}

-(void) addFilter:(id<GRFilter>) filter WithName:(NSString*)name;
-(void) removeFilterWithName:(NSString*) name;
-(id<GRFilter>) filterWithName:(NSString*) name;

@end
