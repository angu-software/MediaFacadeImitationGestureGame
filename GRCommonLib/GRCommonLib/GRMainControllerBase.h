//
//  GTMainController.h
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRConstants.h"
#import "GRMotionSensor.h"
#import "GRFeedbackController.h"
#import "GRViewControllerDelegate.h"
#import "GRDataStorage.h"
#import "GRGesture.h"

@interface GRMainControllerBase : NSObject <GRMotionSensorDelegate, GRViewControllerDelegate>

@property (readonly, strong) GRMotionSensor* motionSensor;
@property (readonly, strong) GRFeedbackController* feedback;
@property (strong) UIViewController* viewController;

-(void)setUpEnvironment;
-(void) launch;
-(void) relauch;
-(void) hold;
-(void) tearDown;

-(void)saveDataStorage:(GRDataStorage*) storage toTextFile:(NSString*) filePath;

@end
