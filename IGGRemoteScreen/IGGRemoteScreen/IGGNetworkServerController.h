//
//  IGGNetworkServerController.h
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol IGGNetworkServerDelegate <NSObject>

-(void) newClientConnectedWithID:(NSString*) uID;
-(void) receivedClassLabel:(NSString*) classLabel FromClient:(NSString*) uID;

@optional
-(void) clientDisconnected;

@end

@interface IGGNetworkServerController : NSObject <GCDAsyncSocketDelegate> {

    dispatch_queue_t socketQueue;
    GCDAsyncSocket* _listenSocket;
}

@property id<IGGNetworkServerDelegate> delegate;
@property (readonly, strong) NSString* host;
@property (readonly) NSUInteger port;

-(id)initWithListenPort:(NSUInteger) port;
-(void)startListen;
-(void) stopListen;
@end
