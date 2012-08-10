//
//  IGGMainViewController.m
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGGMainViewController.h"
#import "IGGShapeView.h"
#import "QuartzCore/QuartzCore.h"

#define APPEAR_ANIMATION_DURATION 3.0f
#define VANISH_ANIMATION_DURATION 1.5f
#define ANIMATION_FRAMERATE 250.0f

#define kReplaceKey @"Replace"

@interface IGGMainViewController ()

@end

@implementation IGGMainViewController
@synthesize shapesCanvasView = _shapeView;
@synthesize playerCountLabel = _playerCountLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize timeLeftLabel = _timeLeftLabel;
@synthesize shapeCount = _shapeCount;
@synthesize playerCount = _playerCount;
@synthesize points = _points;
@synthesize timeLeft = _timeLeft;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        srand([[NSDate date] timeIntervalSince1970]);
        _shapeDict = [[NSMutableDictionary alloc] init];
        _moveAnimationsDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setShapeCount:(NSUInteger)shapeCount{
    if (_shapeCount < shapeCount) {
        [self addShapes: (shapeCount - _shapeCount)];
    }else{
        [self removeShapes: (_shapeCount - shapeCount)];
    }
    _shapeCount = shapeCount;
}

-(BOOL)vanishShapeWithTypeName:(NSString*) typeName Replace:(BOOL) replace{
    NSArray* shapeSet = [_shapeDict objectForKey:typeName];
    if (shapeSet && ([shapeSet count] > 0)) {
        IGGShapeView* shapeView = [shapeSet objectAtIndex:0];
        [self vanishShape:shapeView Replace:replace];
        return YES;
    }
    return NO;
}

-(void)addPlayer{
    ++_playerCount;
    [self updatePlayerLabel];
}

-(void)removePlayer{
    --_playerCount;
    [self updatePlayerLabel];
    
    if (_playerCount == 0) {
        _points = 0;
        [self reset];
    }
}

-(void)reset{
    [self updatePointsLabel];
    [self removeShapes:_shapeCount];
}

-(void)addPoint{
    ++_points;
    [self updatePointsLabel];
}

- (void)setTimeLeft:(double)timeLeft{
    _timeLeft = timeLeft;
    
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDate* now = [NSDate date];
    NSDate* endDate = [NSDate dateWithTimeInterval:_timeLeft sinceDate:now];
    NSDateComponents* dateComponents = [calender components:NSMinuteCalendarUnit | NSSecondCalendarUnit 
                                                   fromDate:now 
                                                     toDate:endDate 
                                                    options:0];
    
    [_timeLeftLabel setStringValue:[NSString stringWithFormat:@"%02d:%02d min.", 
                                    dateComponents.minute, 
                                    dateComponents.second]];
}

#pragma mark - private methods

-(void) updatePlayerLabel{
    NSString* playerCountStr = [NSString stringWithFormat:@"%lu",_playerCount];
    [_playerCountLabel setStringValue:playerCountStr];
}

-(void) updatePointsLabel{
    NSString* scoreCountStr = [NSString stringWithFormat:@"%lu",_points];
    [_scoreLabel setStringValue:scoreCountStr];
}

-(void) addShapes:(NSUInteger) count{
    for (NSUInteger i = 0; i < count; ++i) {
        IGGShape* shape = [IGGShape randomShape];
        IGGShapeView* shapeView = [[IGGShapeView alloc] initWithShape:shape];
        [self addShapeViewToDict:shapeView];
        [_shapeView addSubview:shapeView];
        [NSTimer scheduledTimerWithTimeInterval:(1.0f*(i+1)) 
                                         target:self
                                       selector:@selector(sheduleViewForAppearence:) 
                                       userInfo:shapeView 
                                        repeats:NO];
    }
}

-(void)sheduleViewForAppearence:(NSTimer*)timer{
    IGGShapeView* shapeView = (IGGShapeView*)timer.userInfo;
    shapeView.center = [self randomPointForView:shapeView];
    [self appearShape:shapeView];
}

-(void) addShapeViewToDict:(IGGShapeView *) shapeView{
    NSString* shapeKey = [shapeView.shape description];
    NSMutableArray* shapeSet = [_shapeDict objectForKey:shapeKey];
    if (shapeSet == nil) {
        shapeSet = [NSMutableArray array];
        [_shapeDict setObject:shapeSet forKey:shapeKey];
    }
    [shapeSet addObject:shapeView];
}

-(void) removeShapes:(NSUInteger) count{
    if ([_shapeDict count] > 0) {
        for (NSInteger i = 0; i < count; ++i) {
            IGGShapeView* anyShapeView = [self anyShapeView];
            if (anyShapeView) {
                [self removeShapeFromView:anyShapeView];
            }           
        }
    }
}

-(IGGShapeView*) anyShapeView{

    NSArray* allShapeSets = [_shapeDict allValues];
    if (allShapeSets) {
        NSMutableArray* mergedSet = [NSMutableArray array];
        
        for (NSMutableArray* shapeSet in allShapeSets) {
            for (IGGShapeView* shapeView in shapeSet) {
                [mergedSet addObject:shapeView];
            }
        }
        
        if ([mergedSet count] > 0 ) {
            NSUInteger rIndex = rand()%[mergedSet count];
            
            return [mergedSet objectAtIndex:rIndex];
        }

    }
    return nil;
}

-(void) removeShapeFromView:(IGGShapeView *) shapeView{
    
    // remove view from dict
    NSMutableSet* shapeSet = [_shapeDict objectForKey:[shapeView.shape description]];
    [shapeSet removeObject:shapeView];
    
    // remove from view
    [shapeView removeFromSuperview];
    
}

- (NSPoint)randomPointForView:(IGGShapeView *)view {
    float shapeW = view.shape.maxSize.width;
    float shapeH = view.shape.maxSize.height;
    float viewW = _shapeView.frame.size.width;
    float viewH = _shapeView.frame.size.height;
    float rX = rand()%(NSUInteger)(viewW - shapeW);
    float rY = rand()%(NSUInteger)(viewH - shapeH);
    return NSMakePoint(rX, rY);
}

-(void)appearShape:(IGGShapeView*) shapeView{

    NSMutableDictionary* animationDict = [NSMutableDictionary dictionary];
    [animationDict setObject:shapeView forKey:NSViewAnimationTargetKey];
    [animationDict setObject:NSViewAnimationFadeInEffect forKey:NSViewAnimationEffectKey];
    NSViewAnimation* appearAnimation = [[NSViewAnimation alloc]initWithViewAnimations:[NSArray arrayWithObjects:animationDict, nil]];
    appearAnimation.duration = APPEAR_ANIMATION_DURATION;
    appearAnimation.frameRate = ANIMATION_FRAMERATE;
    appearAnimation.delegate = self;
    [appearAnimation startAnimation];

}

-(void)vanishShape:(IGGShapeView*) shapeView Replace:(BOOL) replace{
    NSMutableDictionary* animationDict = [NSMutableDictionary dictionary];
    [animationDict setObject:shapeView forKey:NSViewAnimationTargetKey];
    [animationDict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
    [animationDict setObject:[NSNumber numberWithBool:replace] forKey:kReplaceKey];
    NSViewAnimation *vanishAnimation = [[NSViewAnimation alloc]initWithViewAnimations:[NSArray arrayWithObjects:animationDict, nil]];
    vanishAnimation.duration = VANISH_ANIMATION_DURATION;
    vanishAnimation.frameRate = ANIMATION_FRAMERATE;
    vanishAnimation.delegate = self;
    [vanishAnimation startAnimation];
}

#pragma mark - NSAnimationDelegate methods

- (BOOL)animationShouldStart:(NSAnimation *)animation{
    return YES;
}

- (void)animationDidEnd:(NSAnimation *)animation{
    NSDictionary* aniDict = [[(NSViewAnimation*)animation viewAnimations] objectAtIndex:0];
    
    if ([aniDict objectForKey:NSViewAnimationEffectKey] == NSViewAnimationFadeOutEffect) {
        IGGShapeView* shapeView = [aniDict objectForKey:NSViewAnimationTargetKey];
        BOOL replace = [[aniDict objectForKey:kReplaceKey] boolValue];
        // if view vanished
        if(shapeView.isHidden){
            [self removeShapeFromView:shapeView];
            if (replace) {
                [self addShapes:1];
            }
        }
    }

}

@end
