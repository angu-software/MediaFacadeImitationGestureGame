//
//  GTFeedbackController.h
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define MAX_SAYSOUNDCACHE 10

@interface GRFeedbackController : NSObject{
    AVAudioPlayer* _audioPlayer;
    NSMutableDictionary* _preloadedSaySounds;
}

-(void) vibrate;
-(void) preloadSaySoundsForTexts:(NSArray*) texts synchronous:(BOOL)synchronous;
-(void) say:(NSString*) text;

@end
