//
//  IGGMainController.m
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGGMainController.h"
#import "IGGShape.h"

#define PORT 1234567
#define SHAPES_PER_PLAYER 3
#define TIME_PER_ROUND 2.0f // minutes
#define TIME_ADD_PER_PLAYER 0.5f //minutes

@implementation IGGMainController

- (id)initWithViewController:(IGGMainViewController *)viewController
{
    self = [super init];
    if (self) {
        _mainViewController = viewController;
        _networkServer = [[IGGNetworkServerController alloc] initWithListenPort:PORT];
        [_networkServer setDelegate:self];
    }
    return self;
}

-(void) launch{
    [self setUpView];
    [_networkServer startListen];
}

#pragma mark - private methods

-(void) setUpView{
    [_mainViewController setShapeCount:_mainViewController.shapeCount + SHAPES_PER_PLAYER];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(removeShape) userInfo:nil repeats:YES];
}

-(void) removeShape{
    
    IGGShape* shape = [IGGShape randomShape];
    Log(@"%@",shape);
    [_mainViewController vanishShapeWithTypeName:shape.description Replace:YES];
}

#pragma mark - IGGNetworkServerDelegate methodes

- (void)newClientConnectedWithID:(NSString *)uID{
    [_mainViewController addPlayer];
    [_mainViewController setShapeCount:_mainViewController.shapeCount + SHAPES_PER_PLAYER];
    if (_mainViewController.playerCount == 1) {
        // set up and start timer
        [self startRound];
    }else {
        // add time
        _timeLeft += TIME_ADD_PER_PLAYER * 60.0f;
    }
}

-(void) startRound{
    if (_roundTimer == nil) {
        _timeLeft = TIME_PER_ROUND * 60.0f;
        [_mainViewController setTimeLeft:_timeLeft];
        _roundTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(roundTimerTick) userInfo:nil repeats:YES];
    }
}

-(void)roundTimerTick{
    [self performSelectorOnMainThread:@selector(decreaseTimeLeft) withObject:nil waitUntilDone:NO];
}

-(void)decreaseTimeLeft{
    --_timeLeft;
    [_mainViewController setTimeLeft:_timeLeft];
    if (_timeLeft == 0) {
        [self finishRound];
    }
}

-(void)finishRound{
    [_roundTimer invalidate];
    _roundTimer = nil;
    [_mainViewController reset];
}

- (void)receivedClassLabel:(NSString *)classLabel FromClient:(NSString *)uID{
    if([_mainViewController vanishShapeWithTypeName:classLabel Replace:YES]){
        [_mainViewController addPoint];
    }
    Log(@"User %@ vanished %@",uID,classLabel);
}

-(void)clientDisconnected{
    if (_mainViewController.playerCount == 1 &&
        _roundTimer) {
        [self finishRound];
    }
    [_mainViewController removePlayer];
}

@end
