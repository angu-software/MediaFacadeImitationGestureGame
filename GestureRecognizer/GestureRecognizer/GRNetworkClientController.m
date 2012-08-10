//
//  GRNetworkClientController.m
//  GestureRecognizer
//
//  Created by Andreas on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRNetworkClientController.h"
#import "NSString+UUID.h"

#define kInfiniteTimeout -1
#define kHelloMessage @"Hello"
#define kHelloTag 0

@interface GRNetworkClientController ()

@end

// Protokoll
// Client-->[Hello]-->Host
// Client<--[Wellcome]<--Host
// Client-->[Class Label]-->Host

@implementation GRNetworkClientController
@synthesize host = _host;
@synthesize port = _port;
@synthesize isConnected = _isConnected;
@synthesize connectionTimeout = _connectionTimeout;

- (id)initWithHost:(NSString *) host AndPort:(NSUInteger) port{
    if(self = [super init]){
        _host = host;
        _port = port;
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _connectionTimeout = kInfiniteTimeout;
    }
    
    return self;
}

#pragma mark - public methods

- (BOOL) connect{
    
    NSError* error;
    _isConnected = [_socket connectToHost:_host onPort:_port withTimeout:_connectionTimeout error:&error];
    if (!_isConnected) {
        Log(@"ERROR connectin to host %@:%d: %@",_host,_port,error);
    }
    
    return _isConnected;
}

- (void) disconnect{
    [_socket disconnect];
}

- (void) sendRecognizedClassLabel:(NSString*) classLabel{

    NSString* payload = [[NSString uuid] stringByAppendingFormat:@";%@",classLabel];
    [_socket writeData:[payload dataUsingEncoding:NSUTF8StringEncoding] withTimeout:kInfiniteTimeout tag:1];
}

#pragma mark - GCDAsyncSocketDelegate methods

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    Log(@"Connected to host: %@:%d", host, port);
    [sock writeData:[[[NSString uuid] stringByAppendingFormat:@";%@", kHelloMessage] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:kInfiniteTimeout tag:kHelloTag];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    Log(@"Data send to host with tag: %lu", tag);
    [_socket readDataWithTimeout:kInfiniteTimeout tag:kHelloTag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    Log(@"Data received from host with tag: %lu", tag);
    Log(@"Message from host: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
