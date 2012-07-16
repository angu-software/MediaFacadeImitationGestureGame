//
//  TP.h
//  MFThrowingPoetry
//
//  Created by Andreas on 27.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TPCommunicationProtocol.h"

#define CLIENT_ID_LEN sizeof(uint32_t)
#define COMMAND_LEN sizeof(uint8_t)
#define PAYLOAD_SIZE_LEN sizeof(uint32_t)

@implementation TPDataPackage

@synthesize command, payload, clientID;

-(void)dealloc{

    if (payload != nil) {
        [payload release];
    }
    [super dealloc];
}

-(id)initWithReceivedData:(NSData*) data {
    if (self = [super init]) {
        
        uint32_t t_clientID = 0;
        
        [data getBytes:&t_clientID range:NSMakeRange(0, sizeof(uint32_t))];
        clientID = t_clientID;
        
        uint8_t t_command = 0;
        [data getBytes:&t_command range:NSMakeRange(CLIENT_ID_LEN, COMMAND_LEN)];
        command = (TPCommand)t_command;
        
        uint32_t payloadLen = 0;
        [data getBytes:&payloadLen range:NSMakeRange(CLIENT_ID_LEN+COMMAND_LEN,PAYLOAD_SIZE_LEN)];
        
        if (payloadLen > 0) {
            
            uint8_t buff[payloadLen];
            
            [data getBytes:buff range:NSMakeRange(CLIENT_ID_LEN+COMMAND_LEN+PAYLOAD_SIZE_LEN,payloadLen)];
            
            payload = [[NSData alloc]initWithBytes:buff length:payloadLen];
        }
        
    }
    
    return self;
}

-(id)initWithRequest:(TPCommand)req andPayload:(NSData*) pl forClient:(NSUInteger) cID{
    if (self = [super init]) {
        
        command = req;
        clientID = cID;
        if(pl != nil){
            payload = [pl copy];
        }
    }
    
    return self;
}

// prepares the TPDataPackage to send it as NSData object
// returns NSData object (autoreleased)
-(NSData*) prepareToSend{

    // [ClientID][Request][Len][Payload]

    NSMutableData* data = [[NSMutableData alloc] init];
    
    uint32_t t_clientID = clientID; // 4Byte
    uint8_t t_command = command;    // 1Byte
    uint32_t t_dataLen = 0;         // 4Byte
    if (payload != nil) {
        t_dataLen = [payload length];   
    }
    
    [data appendBytes:&t_clientID length:CLIENT_ID_LEN];
    [data appendBytes:&t_command length:COMMAND_LEN];
    [data appendBytes:&t_dataLen length:PAYLOAD_SIZE_LEN];
    if (t_dataLen != 0) {
        [data appendData:payload];
    }
    
    return [data autorelease];
}

@end
