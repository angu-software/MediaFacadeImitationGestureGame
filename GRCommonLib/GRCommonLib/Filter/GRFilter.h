//
//  GRFilter.h
//  GestureRecognizer
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRConstants.h"

@protocol GRFilter <NSObject>

-(GRRecord*) filterData:(GRRecord*) data;

@end
