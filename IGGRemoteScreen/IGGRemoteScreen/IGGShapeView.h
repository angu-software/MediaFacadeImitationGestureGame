//
//  IGGShapeView.h
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IGGShape.h"

@interface IGGShapeView : NSView <NSAnimationDelegate>{

    NSViewAnimation* _appearAnimation;
    NSViewAnimation* _vanishAnimation;
}

@property (readonly) IGGShape* shape;
@property (nonatomic) NSPoint center;

-(id) initWithShape:(IGGShape*) shape;
//-(void) appear;
//-(void) vanish;

@end
