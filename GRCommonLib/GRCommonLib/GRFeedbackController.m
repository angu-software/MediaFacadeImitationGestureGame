//
//  GTFeedbackController.m
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "GRFeedbackController.h"

@implementation GRFeedbackController

- (id)init
{
    self = [super init];
    if (self) {
        [self setUpSystemSounds];
    }
    return self;
}

-(void) vibrate{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (NSString *)filePathForSaySoundName:(NSString *)name {
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* soundFilePath = [docPath stringByAppendingPathComponent:name];
    return soundFilePath;
}

-(void) saveSaySound:(NSData*)soundData toFilesystemWithName:(NSString*)name{
    NSString *soundFilePath = [self filePathForSaySoundName:name];
    [soundData writeToFile:soundFilePath atomically:YES];
}

-(NSData*) loadSaySoundFromFileSystemWithName:(NSString*)name{
    NSString* soundFilePath = [self filePathForSaySoundName:name];
    NSData* soundData = [NSData dataWithContentsOfFile:soundFilePath];
    return soundData;
}

- (void)addSaySound:(NSData *)data withName:(NSString *)name {
    [_preloadedSaySounds setObject:data forKey:name];
    //save data to filesystem
    [self saveSaySound:data toFilesystemWithName:name];
}

-(void) preloadSaySoundsForTexts:(NSArray*) texts synchronous:(BOOL) synchronous{

    _preloadedSaySounds = [[NSMutableDictionary alloc] initWithCapacity:[texts count] > MAX_SAYSOUNDCACHE ? MAX_SAYSOUNDCACHE : [texts count]];
    
    for (NSString* text in texts) {
        // load from file
        NSData* soundData = [self loadSaySoundFromFileSystemWithName:text];
        if (soundData) {
            [_preloadedSaySounds setObject:soundData forKey:text];
        }else {
            // request
            NSMutableURLRequest * request = [self createRequestForText:text];
            
            if (synchronous) {
                NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                if (data) {
                    [self addSaySound:data withName:text];
                }
            }else {
                [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * response, NSData *data, NSError *error) {
                    
                    @synchronized(_preloadedSaySounds){
                        if (data != nil) {
                            [self addSaySound:data withName:text];                            
                        }
                    }
                }];
            }

        }
    }
}

-(void) say:(NSString*) text{
    
    @synchronized(_preloadedSaySounds){
        if (_preloadedSaySounds && [[_preloadedSaySounds allKeys] containsObject:text]) {
            // play preloaded sound
            [self playSaySoundWithData:[_preloadedSaySounds objectForKey:text]];
        }else{
            // request sound for text
            NSMutableURLRequest *request = [self createRequestForText:text];
            
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * response, NSData *data, NSError *error) {
                if (data != nil) {
                    [self playSaySoundWithData:data];    
                }
                
            }];
        }
    }
}

#pragma mark - private methods

-(void) setUpSystemSounds{


}

- (NSMutableURLRequest *)createRequestForText:(NSString *)text {
    NSString* lang = @"de";
    NSString* speakServiceAddress = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?tl=%@&q=%@",lang,text];
    
    NSURL* url = [NSURL URLWithString: [speakServiceAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (kHTML, like Gecko) Safari/125.8" forHTTPHeaderField:@"User-Agent"];
    return request;
}

- (void)playSaySoundWithData:(NSData *)data {
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    _audioPlayer.volume = 1.0f;
    [_audioPlayer play];
}

@end
