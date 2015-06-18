//
//  GlobalFunction.m
//  MadMath
//
//  Created by Zack Loi on 9/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kFadeDuration               0.2

#import "GlobalFunction.h"

@implementation GlobalFunction

+(BOOL)NetworkStatus
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus==NotReachable);
}

+ (void)LoadingScreen:(UIViewController *)viewcontroller {
    UIView *existingToast = [viewcontroller.view viewWithTag:888];
    if (existingToast != nil) {
        [existingToast removeFromSuperview];
    }
    
    activityContainer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];

    [activityContainer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    activityContainer.tag = 888;
    
    UIImageView *head = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_icon_head.png"]] autorelease];
    
    head.frame = CGRectMake((activityContainer.frame.size.width - head.image.size.width) / 2, (activityContainer.frame.size.height - head.image.size.height) / 2 , head.image.size.width, head.image.size.height);
    
    eye = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_icon_eye.png"]] autorelease];
    
    eye.frame = CGRectMake((activityContainer.frame.size.width - eye.image.size.width) / 2, (activityContainer.frame.size.height - eye.image.size.height) / 2 + 3, eye.image.size.width, eye.image.size.height);
    eye.tag = 2;
    
    
    
    [activityContainer addSubview:head];
    [activityContainer addSubview:eye];
    [viewcontroller.view addSubview:activityContainer];
    transition = eye.transform;
    [self moveleft];
}

+(void)moveright{
    eye.transform = transition;
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView animateWithDuration:0.0 animations:^{
        CGAffineTransform translate = CGAffineTransformMakeTranslation(7.0, 0.0);
        CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
        CGAffineTransform transform =  CGAffineTransformConcat(translate, scale);
        transform = CGAffineTransformRotate(transform, 0);
        eye.transform = transform;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             transition = eye.transform;
                             [self moveleft];
                         }
                     }];
    [UIView commitAnimations]; 
}

+(void)moveleft{
    eye.transform = transition;
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView animateWithDuration:0.0 animations:^{
        CGAffineTransform translate = CGAffineTransformMakeTranslation(-7.0, 0.0);
        CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
        CGAffineTransform transform =  CGAffineTransformConcat(translate, scale);
        transform = CGAffineTransformRotate(transform, 0);
        eye.transform = transform;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             transition = eye.transform;
                             [self moveright];
                         }
                     }];
    [UIView commitAnimations]; 
}

+(void)RemovingScreen:(UIViewController *)viewcontroller{
    UIView *existingToast = [viewcontroller.view viewWithTag:888];
    if (existingToast != nil) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kFadeDuration];
        [UIView setAnimationDelegate:existingToast];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [existingToast setAlpha:0.0];
        [UIView commitAnimations];
    }
}

+ (void)IncomingCallLoadingScreen:(UIViewController *)viewcontroller {
    UIView *existingToast = [viewcontroller.view viewWithTag:8888];
    if (existingToast != nil) {
        [existingToast removeFromSuperview];
    }
    
    UIView *bgview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    [bgview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    bgview.tag = 8888;
    
    UIImageView *pause = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pause.png"]] autorelease];
    resume = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_resume.png"]] autorelease];
    quit = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_quit.png"]] autorelease];
    
    pause.frame = CGRectMake((bgview.frame.size.width - pause.image.size.width) / 2, (bgview.frame.size.height - pause.image.size.height - resume.image.size.height - quit.image.size.height - 20) / 2 , pause.image.size.width, pause.image.size.height);
    [bgview addSubview:pause];
    
    resume.frame = CGRectMake((bgview.frame.size.width - resume.image.size.width) / 2, pause.frame.origin.y + pause.frame.size.height + 10, resume.image.size.width, resume.image.size.height);
    UITapGestureRecognizer *resumegesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resume:)];
    [resume addGestureRecognizer:resumegesture];
    [resume setUserInteractionEnabled:YES];
    [bgview addSubview:resume];
    [resumegesture release];
    
    quit.frame = CGRectMake((bgview.frame.size.width - quit.image.size.width) / 2, resume.frame.origin.y + resume.frame.size.height + 10, quit.image.size.width, quit.image.size.height);
    UITapGestureRecognizer *quitgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quit:)];
    [quit addGestureRecognizer:quitgesture];
    [quit setUserInteractionEnabled:YES];
    [bgview addSubview:quit];
    [quitgesture release];
    
    [viewcontroller.view addSubview:bgview];
}

+(void)IncomingCallRemovingScreen:(UIViewController *)viewcontroller{
    UIView *existingToast = [viewcontroller.view viewWithTag:8888];
    if (existingToast != nil) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kFadeDuration];
        [UIView setAnimationDelegate:existingToast];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [existingToast setAlpha:0.0];
        [UIView commitAnimations];
    }
}

+ (SystemSoundID) createSoundID: (NSString*)name
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", name] ofType:@"wav"];
    
    SystemSoundID soundID;
    
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    
    return soundID;
}

+(void) playbgmusic:(NSString *)name:(NSString *)format:(int)repeat{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", name] ofType:format];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = repeat; 

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [player setVolume:appDelegate.volume];
    [player play];
}

+(void) stopbgmusic{
    [player stop];
}

+(void) resumebgmusic{
    [player play];
}

+(void) pausebgmusic{
    [player pause];
}

+(void) setvolumebgmusic:(float)volume{
    [player setVolume:volume];
}

+(float) getvolumebgmusic{
    return [player volume];
}

+(BOOL) isplay{
    return player.playing;
}

+(void) resume:(UIGestureRecognizer *)gesture{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.ispause = NO;
}

+(void) quit:(UIGestureRecognizer *)gesture{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.isquit = YES;
    appDelegate.isvalid = NO;
}
@end
