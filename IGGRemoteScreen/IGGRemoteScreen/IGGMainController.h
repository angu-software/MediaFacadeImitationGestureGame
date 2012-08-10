//
//  IGGMainController.h
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGGNetworkServerController.h"
#import "IGGMainViewController.h"

@interface IGGMainController : NSObject <IGGNetworkServerDelegate> {
    IGGNetworkServerController *_networkServer;
    IGGMainViewController* _mainViewController;
    NSTimer* _roundTimer;
    NSTimeInterval _timeLeft;
}

-(id)initWithViewController:(IGGMainViewController *)viewController;
-(void) launch;

@end
