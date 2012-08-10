//
//  GRAppDelegate.h
//  GestureRecognizer
//
//  Created by Andreas on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRMainController.h"

@class GRViewController;

@interface GRAppDelegate : UIResponder <UIApplicationDelegate>{

    GRMainController* _mainController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GRViewController *viewController;

@end
