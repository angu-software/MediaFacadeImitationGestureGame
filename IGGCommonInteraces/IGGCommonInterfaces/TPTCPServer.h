//
//  TPTCPServer.h
//  MFThrowingPoetry
//
//  Created by Andreas on 25.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "TPLogicController.h"

@interface TPTCPServer : NSObject <GCDAsyncSocketDelegate>{

    dispatch_queue_t socketQueue;
    UInt32 _port;
    GCDAsyncSocket* listenerSocket;
    NSMutableArray* _connectedSockets;
}

@property(readonly) TPLogicController* logicController;

- (id)initWithPort:(UInt32) port andLogicController:(TPLogicController*)logic;

-(void)start;
-(void)stop;

@end
