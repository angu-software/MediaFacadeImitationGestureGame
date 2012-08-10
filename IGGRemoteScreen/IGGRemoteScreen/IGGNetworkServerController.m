//
//  IGGNetworkServerController.m
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGGNetworkServerController.h"

#define kHelloTag 0
#define kGameRunningTag 1
#define kWelcome @"Welcome"
#define HOST @"localhost"
#define kInfiniteTimeout -1

#define kUserInfoStateKey @"State"
#define kUserInfoClientIDKey @"ClientID"
#define kUserInfoClassLabelKey @"ClassLabel"

#define kDelegateStateNewClient 1
#define kDelegateStateClientDisconnected 2
#define kDelegateStateClassLabel 3

@implementation IGGNetworkServerController

@synthesize host = _host;
@synthesize port = _port;
@synthesize delegate = _delegate;

- (id)initWithListenPort:(NSUInteger) port
{
    self = [super init];
    if (self) {
        _host = HOST;
        _port = port;
        socketQueue = dispatch_queue_create("socketQueue", NULL);
        _listenSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:socketQueue];
    }
    return self;
}

-(void)startListen{

    NSError* error;
    if ([_listenSocket acceptOnPort:_port error:&error]) {
        Log(@"Listening on port %lu",_port);
    }else {
        Log(@"Error listening on port %lu: %@",_port, error);
    }
}

-(void) stopListen{
    [_listenSocket disconnect];
}

#pragma mark - private methods

-(void)notifyDelegate:(NSDictionary*) userInfo{
    if (_delegate) {
        
        NSInteger state = [[userInfo objectForKey:kUserInfoStateKey] intValue];
        NSString* clientID = [userInfo objectForKey:kUserInfoClientIDKey];
        switch (state) {
            case kDelegateStateNewClient:
                [_delegate newClientConnectedWithID:clientID];                
                break;
            case kDelegateStateClientDisconnected:
                [_delegate clientDisconnected];
                break;
            default:{
                NSString* classLabel = [userInfo objectForKey:kUserInfoClassLabelKey];
                [_delegate receivedClassLabel:classLabel FromClient:clientID];
                break;
            }
        }
        
    }
}

#pragma mark - GCAsyncSocketDelegate methods

// runs in socket queue

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    Log(@"New client just connected.");
    [newSocket readDataWithTimeout:-1 tag:kHelloTag];
}

-(void) socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:kGameRunningTag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *clientID;
    NSString *classLabel;
    // split data into the client id and the payload
    NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* dataComponents = [dataString componentsSeparatedByString:@";"];
    if ([dataComponents count] > 1) {
        classLabel = [dataComponents objectAtIndex:1];
    }
    clientID = [dataComponents objectAtIndex:0];
    
    Log(@"Received message from client with tag %lu: %@", tag, dataString);
    
    // set up user data to notify delegate
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:clientID forKey:kUserInfoClientIDKey];
    
    if (tag == kHelloTag) {
        [userInfo setObject:[NSNumber numberWithInteger:kDelegateStateNewClient] forKey:kUserInfoStateKey];
        [sock writeData:[kWelcome dataUsingEncoding:NSUTF8StringEncoding] withTimeout:kInfiniteTimeout tag:kHelloTag];        
    }else {
        [userInfo setObject:[NSNumber numberWithInteger:kDelegateStateClassLabel] forKey:kUserInfoStateKey];
        [userInfo setObject:classLabel forKey:kUserInfoClassLabelKey];
        [sock readDataWithTimeout:-1 tag:kGameRunningTag];
    }

    // hand over data to delegate for further processing
    [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:userInfo waitUntilDone:NO];

}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    Log(@"Client disconnected");
    if (_delegate &&
        [_delegate respondsToSelector:@selector(clientDisconnected)]) {
        
         NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:@"0" forKey:kUserInfoClientIDKey];
        [userInfo setObject:[NSNumber numberWithInteger:kDelegateStateClientDisconnected] forKey:kUserInfoStateKey];
        [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:userInfo waitUntilDone:NO];
    }
}

@end
