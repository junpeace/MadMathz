//
//  GlobalFunction.h
//  MadMath
//
//  Created by Zack Loi on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#import "AppDelegate.h"

UIImageView *eye, *resume, *quit;
CGAffineTransform transition;
UIView *activityContainer;
AVAudioPlayer *player;

@interface GlobalFunction : UIView{
    
}

+(BOOL)NetworkStatus;

+ (void)LoadingScreen:(UIViewController *)viewcontroller;

+(void)RemovingScreen:(UIViewController *)viewcontroller;

+(void)IncomingCallLoadingScreen:(UIViewController *)viewcontroller;

+(void)IncomingCallRemovingScreen:(UIViewController *)viewcontroller;

+ (SystemSoundID) createSoundID: (NSString*)name;

+(void) playbgmusic:(NSString *)name:(NSString *)format:(int)repeat;

+(void) stopbgmusic;

+(void) resumebgmusic;

+(void) pausebgmusic;

+(void) setvolumebgmusic:(float)volume;

+(float) getvolumebgmusic;

+(BOOL) isplay;

@end
