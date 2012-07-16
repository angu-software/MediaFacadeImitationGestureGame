//
//  GRViewControllerDelegate.h
//  GestureTraining
//
//  Created by Andreas on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GRViewControllerDelegate <NSObject>

-(void)recordingStartRequestet:(id)sender;
-(void)recordingStopRequestet:(id)sender;

@end