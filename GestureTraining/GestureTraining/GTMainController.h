//
//  GTMainController.h
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTDataRecorder.h"
#import "GRMainControllerBase.h"

@interface GTMainController : GRMainControllerBase {
    
    NSString* recordLabel;
}

@property (readonly, strong) GTDataRecorder* dataRecorder;

-(void) backUp;

@end
