//
//  IGGAppDelegate.h
//  IGGRemoteScreen
//
//  Created by Andreas on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IGGMainController.h"

@interface IGGAppDelegate : NSObject <NSApplicationDelegate>{

    IGGMainController *_mainController;
}

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet IGGMainViewController *viewController;

@end
