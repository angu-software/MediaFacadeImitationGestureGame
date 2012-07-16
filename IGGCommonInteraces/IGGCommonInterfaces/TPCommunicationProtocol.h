//
//  TPCommunicationProtocol.h
//  MFThrowingPoetry
//
//  Created by Andreas on 27.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TPCommunicationProtocol.h"

typedef enum {
    TPCommandNone= 0x00,
    TPCommandClientID = 0x01,
    TPCommandRandomWord = 0x02,
    TPCommandAddWord = 0x03,
    TPCommandRemoveWord = 0x04,
    TPCommandSwitchWords = 0x05,
    TPCommandMoveWord = 0x06,
    TPCommandNewSentence = 0x07,
}TPCommand;

typedef enum {
    TPWordPositionBegin = 0,
    TPWordPositionEnd = 1,
    TPWordPositionLeft = 2,
    TPWordPositionRight = 3,
}TPWordPosition;

@interface TPDataPackage : NSObject

@property(readonly) NSUInteger clientID;
@property(retain,readonly) NSData* payload;
@property(readonly) TPCommand command;

-(id)initWithReceivedData:(NSData*) data;
-(id)initWithRequest:(TPCommand)request andPayload:(NSData*) payload forClient:(NSUInteger) clientID;

-(NSData*) prepareToSend;

@end