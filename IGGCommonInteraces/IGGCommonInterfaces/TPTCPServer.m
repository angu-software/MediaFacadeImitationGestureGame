//
//  TPTCPServer.m
//  MFThrowingPoetry
//
//  Created by Andreas on 25.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TPTCPServer.h"

#import "TPCommunicationProtocol.h"

#define DEFAULT_TIMEOUT 15.0
#define HELLO_TIMEOUT 15.0
#define DEFAULT_TAG 0
#define HELLO_TAG 1

@implementation TPTCPServer
@synthesize logicController;

- (id)initWithPort:(UInt32) port andLogicController:(TPLogicController*)logic
{
    self = [super init];
    if (self) {
        _port = port;
        _connectedSockets = [[NSMutableArray alloc] init];
        logicController = [logic retain];
        socketQueue = dispatch_queue_create("socketQueue", NULL);
        listenerSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:socketQueue];
    }
    return self;
}

- (void)dealloc
{
    [_connectedSockets release];
    if (logicController != nil) {
       [logicController release];
    }
    [super dealloc];
}

-(void) setUpConnection{
    
    NSError* error = nil;
    if([listenerSocket acceptOnPort:_port error:&error]){
        NSLog(@"TPTCPServer: listening on Port: %d",_port);

    }else {
        NSLog(@"TPTCPServer: Error listening to port: %d\n%@",_port, error.description);
    }
   
}

#pragma public messages

- (void)start{
    [self setUpConnection];
}

- (void)stop{
    [listenerSocket disconnect];
    
    @synchronized(_connectedSockets){
        
        for (int i = 0; i > _connectedSockets.count; i++) {
            [[_connectedSockets objectAtIndex:i] disconnect];
        }
    }
}

#pragma GCDAsyncSocket delegate messages

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket;
{
    NSLog(@"TPTCPServer: New socket connection");
    
	[newSocket readDataWithTimeout:HELLO_TIMEOUT tag:HELLO_TAG];

}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    @synchronized(_connectedSockets){
        [_connectedSockets removeObject:sock];
    }
    NSLog(@"TPTCPServer: socket disconnected");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    TPDataPackage* tpPackage = [[TPDataPackage alloc]initWithReceivedData:data];
    
    if (tag == HELLO_TAG) {

        NSLog(@"Client %lu connected", tpPackage.clientID);
        
        @synchronized(_connectedSockets){
            
            [_connectedSockets addObject:sock];
            [sock setDelegate:self];
        }
        
        NSString *welcomeMsg = @"Welcome to the Throwing Poetry Server\r\n";
        NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
        [sock writeData:welcomeData withTimeout:-1 tag:DEFAULT_TAG];
    }else{


        NSLog(@"Request from client %lu", tpPackage.clientID);
        
        TPDataPackage* resultPackage = [logicController processRequest:tpPackage];
    
        [sock writeData:[resultPackage prepareToSend] withTimeout:-1 tag:tag];
    }
    [tpPackage release];
}


@end
