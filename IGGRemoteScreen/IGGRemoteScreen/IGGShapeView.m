//
//  IGGShapeView.m
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGGShapeView.h"
#define ANIMATION_DURATION 1.5f
#define ANIMATION_FRAMERATE 250.0f
#define SHAPE_LINEWIDTH 5

@implementation IGGShapeView

@synthesize shape = _shape;
@synthesize center = _center;

-(id) initWithShape:(IGGShape*) shape{

    if (self = [super initWithFrame:CGRectMake(0, 0, shape.maxSize.width, shape.maxSize.height)]) {
        _shape = shape;
        [self setHidden:YES];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor clearColor] setFill];
    
    switch (_shape.type) {
        case IGGCircle:
            [self drawCircle];
            break;
        case IGGTriangle:
            [self drawTriangle];
            break;
        case IGGSquare:
            [self drawSquare];
            break;
        case IGGHouse:
            [self drawHouse];
            break;
    }
    
}

-(void) appear{
    
    NSMutableDictionary* animationDict = [NSMutableDictionary dictionary];
    [animationDict setObject:self forKey:NSViewAnimationTargetKey];
    [animationDict setObject:NSViewAnimationFadeInEffect forKey:NSViewAnimationEffectKey];
    _appearAnimation = [[NSViewAnimation alloc]initWithViewAnimations:[NSArray arrayWithObjects:animationDict, nil]];
    _appearAnimation.duration = ANIMATION_DURATION;
    _appearAnimation.frameRate = ANIMATION_FRAMERATE;
    _appearAnimation.delegate = self;
    [_appearAnimation startAnimation];
}

-(void) vanish{
    
    NSMutableDictionary* animationDict = [NSMutableDictionary dictionary];
    [animationDict setObject:self forKey:NSViewAnimationTargetKey];
    [animationDict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
    _vanishAnimation = [[NSViewAnimation alloc]initWithViewAnimations:[NSArray arrayWithObjects:animationDict, nil]];
    _vanishAnimation.duration = ANIMATION_DURATION;
    _vanishAnimation.frameRate = ANIMATION_FRAMERATE;
    _vanishAnimation.delegate = self;
    [_vanishAnimation startAnimation];
    
    [self setNeedsDisplay:YES];
}

#pragma mark - drawing methods

-(void) drawCircle{
    NSPoint center = {self.bounds.size.width/2.0f, self.bounds.size.height/2.0f};
    float dm = self.bounds.size.width;
    float r = dm/2;
    float lineWidth = SHAPE_LINEWIDTH;
    NSRect circleRect = NSMakeRect(center.x - r + lineWidth, center.y - r + lineWidth, dm - 2*lineWidth, dm - 2*lineWidth);
    NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:circleRect];
    [circlePath setLineWidth:lineWidth];
    [[NSColor redColor] set];
    [circlePath stroke];
}

-(void) drawSquare{
    float lineWidth = SHAPE_LINEWIDTH;
    NSBezierPath *squarePath = [NSBezierPath bezierPathWithRect:self.bounds];
    [squarePath setLineWidth:lineWidth];
    [[NSColor blueColor] set];
    [squarePath stroke];
}

-(void) drawTriangle{
    NSPoint topMid = {self.bounds.size.width/2.0f, self.bounds.size.height};
    NSPoint leftBottom = {0.0f, 0.0f};
    NSPoint rightBottom = {self.bounds.size.width, 0.0f};
    float lineWidth = SHAPE_LINEWIDTH;
    NSBezierPath *trianglePath = [NSBezierPath bezierPath];
    [trianglePath moveToPoint:leftBottom];
    [trianglePath lineToPoint:rightBottom];
    [trianglePath lineToPoint:topMid];
    [trianglePath lineToPoint:leftBottom];
    [trianglePath setLineWidth:lineWidth];
    [[NSColor orangeColor] set];
    [trianglePath stroke];
}

-(void) drawHouse{
    NSPoint topMid = {self.bounds.size.width/2.0f, self.bounds.size.height};
    NSPoint leftBottom = {0.0f, 0.0f};
    NSPoint leftCenter = {leftBottom.x, self.bounds.size.height/2};
    NSPoint rightBottom = {self.bounds.size.width, 0.0f};
    NSPoint rightCenter = {rightBottom.x, self.bounds.size.height/2};
    
    float lineWidth = SHAPE_LINEWIDTH;
    
    NSBezierPath *circlePath = [NSBezierPath bezierPath];
    [circlePath moveToPoint:leftCenter];
    [circlePath lineToPoint:leftBottom];
    [circlePath lineToPoint:rightBottom];
    [circlePath lineToPoint:rightCenter];
    [circlePath lineToPoint:topMid];
    [circlePath lineToPoint:leftCenter];
    [circlePath lineToPoint:rightCenter];    
    [circlePath setLineWidth:lineWidth];
    [[NSColor grayColor] set];
    [circlePath stroke];
}

#pragma mark - getter/setter methods

-(void) setCenter:(NSPoint) center{
    _center = center;
    [self setFrame:NSMakeRect(center.x, center.y, self.bounds.size.width, self.bounds.size.height)];
}

#pragma mark - NSAnimationDelegate methods

- (BOOL)animationShouldStart:(NSAnimation *)animation{
    [self setHidden:(animation == _appearAnimation)];
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)animationDidEnd:(NSAnimation *)animation{
    
    [self setHidden:(animation == _vanishAnimation)];
    [self setNeedsDisplay:YES];    
}

@end
