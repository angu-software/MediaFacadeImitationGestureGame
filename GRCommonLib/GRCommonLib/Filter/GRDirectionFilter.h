//
//  GRDirectionFilter.h
//  GestureRecognizer
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRFilter.h"

@interface GRDirectionFilter : NSObject <GRFilter>

@property double directionThreshold;

@end
