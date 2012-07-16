//
//  GTAppDelegate.h
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMainController.h"

@class GTViewController;

@interface GTAppDelegate : UIResponder <UIApplicationDelegate>{

    GTMainController* mainController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GTViewController *viewController;

@end
