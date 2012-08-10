//
//  IGGMainViewController.h
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IGGMainViewController : NSViewController <NSAnimationDelegate>{

    NSMutableDictionary* _shapeDict;
    NSMutableDictionary* _moveAnimationsDict;
}

@property (strong) IBOutlet NSView *shapesCanvasView;
@property (strong) IBOutlet NSTextField *playerCountLabel;
@property (strong) IBOutlet NSTextField *scoreLabel;
@property (strong) IBOutlet NSTextField *timeLeftLabel;

@property (nonatomic) NSUInteger shapeCount;
@property (nonatomic) NSUInteger playerCount;
@property (nonatomic) NSUInteger points;
@property (nonatomic) double timeLeft;

-(BOOL)vanishShapeWithTypeName:(NSString*) typeName Replace:(BOOL) replace;
-(void)addPlayer;
-(void)removePlayer;
-(void)addPoint;
-(void)reset;

@end
