//
//  GRNetworkClientController.h
//  GestureRecognizer
//
//  Created by Andreas on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface GRNetworkClientController : NSObject <GCDAsyncSocketDelegate>{
    GCDAsyncSocket* _socket;
}

@property (readonly, strong) NSString* host;
@property (readonly) NSUInteger port;
@property (readonly) BOOL isConnected;
@property NSInteger connectionTimeout;

- (id)initWithHost:(NSString *) host AndPort:(NSUInteger) port;
- (BOOL) connect;
- (void) disconnect;
- (void) sendRecognizedClassLabel:(NSString*) classLabel;

@end
