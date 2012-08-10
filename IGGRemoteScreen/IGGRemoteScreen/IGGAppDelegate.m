//
//  IGGAppDelegate.m
//  IGGRemoteScreen
//
//  Created by Andreas on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGGAppDelegate.h"

@implementation IGGAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _mainController = [[IGGMainController alloc] initWithViewController:self.viewController];
    [_mainController launch];
    
    
}

@end
