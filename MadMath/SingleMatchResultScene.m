//
//  SingleMatchResultScene.m
//  MadMath
//
//  Created by Zack Loi on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleMatchResultScene.h"

@implementation SingleMatchResultScene
@synthesize userimage, userpoints, username, character, star, star2, star3, star4, star5, star6, lightning, shadow, home, iswin, userID, userName, userScore, imageData, postParams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.home.hidden = YES;
    self.username.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.username.text = self.userName;
    
    self.userimage.layer.masksToBounds = YES;
    self.userimage.layer.cornerRadius = 5.0;
    self.userimage.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
    self.userimage.layer.borderWidth = 1.5;
    
    [self.userimage setImage:[UIImage imageWithData:imageData]];
    
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"www.tiseno.com", @"link", @"MadMathz", @"name", @"You will crazy in one minute", @"caption", @"You hit the hundred pointer !!", @"description", nil];
    
    WebServices *ws = [[WebServices alloc] init];
    
    int number;
    
    if(self.iswin)
    {
        number = 1;
        int us = [self.userScore intValue];
        [ws updateUserScore:self.userID :++us];
        
        if(us % 100 == 0)
        {
            [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/feed", self.userID] parameters:self.postParams HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 if (error) 
                 {
                 } 
                 else 
                 {
                 }
             }];
        }
    }
    else
    {
        number = 0;
    }
    
    [ws insertSingleMatchDetails:0 :number :self.userID];
    self.home.hidden = NO;
    
    [ws release];
    
    star.hidden = YES;
    star2.hidden = YES;
    star3.hidden = YES;
    star4.hidden = YES;
    star5.hidden = YES;
    star6.hidden = YES;
    lightning.hidden = YES;
    
    if(self.iswin){
        shadow.hidden = YES;
        [self performSelector:@selector(transitionstar) withObject:nil afterDelay:1.5];
        [self performSelector:@selector(playsound:) withObject:@"win" afterDelay:1.5];
        score++;
    }else{
        count = 0;
        self.userpoints.hidden = YES;
        character.image = [UIImage imageNamed:@"screen_lose.png"];
        [self performSelector:@selector(lightningblinking) withObject:nil afterDelay:1.5];
        [self performSelector:@selector(playsound:) withObject:@"lose" afterDelay:1.5];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [connectiontimer invalidate];
}

-(void)checkingconnection{
    if([GlobalFunction NetworkStatus] && !isconnected){
        countdown = 0;
        isconnected = YES;
        isstopped = NO;
        [GlobalFunction RemovingScreen:self];
    }else if(![GlobalFunction NetworkStatus] && isconnected){
        [GlobalFunction LoadingScreen:self];
        isconnected = NO;
    }else if(![GlobalFunction NetworkStatus] && !isconnected){
        if(!isstopped)
            isstopped = YES;
        countdown++;
        if(countdown > 1200)
        {
            LoginPage *GtestClasssViewController=[[[LoginPage alloc] initWithNibName:@"LoginPage"  bundle:nil] autorelease];
            GtestClasssViewController.isneedtoplay = YES;
            [self presentModalViewController:GtestClasssViewController animated:YES];
        }
    }
}

-(void)playsound:(NSString *)name{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if(!appDelegate.ismute){
        soundeffect = [GlobalFunction createSoundID: name];
        AudioServicesPlaySystemSound(soundeffect);
    }
}

-(void)transitionstar{
    star.hidden = NO;
    star2.hidden = NO;
    star3.hidden = NO;
    star4.hidden = NO;
    star5.hidden = NO;
    star6.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4f];
    [UIView animateWithDuration:0.0 animations:^{
        CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
        CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI);
         CGAffineTransform rotate2 = CGAffineTransformMakeRotation(-M_PI);
         CGAffineTransform rotate3 = CGAffineTransformMakeRotation(-M_PI);
         CGAffineTransform rotate4 = CGAffineTransformMakeRotation(M_PI);
         CGAffineTransform rotate5 = CGAffineTransformMakeRotation(M_PI);
         CGAffineTransform rotate6 = CGAffineTransformMakeRotation(-M_PI);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(-800, -800);
         CGAffineTransform translate2 = CGAffineTransformMakeTranslation(600, -600);
         CGAffineTransform translate3 = CGAffineTransformMakeTranslation(400, 400);
         CGAffineTransform translate4 = CGAffineTransformMakeTranslation(-200, 200);
         CGAffineTransform translate5 = CGAffineTransformMakeTranslation(900, -300);
         CGAffineTransform translate6 = CGAffineTransformMakeTranslation(-200, 500);
        
        CGAffineTransform transform =  CGAffineTransformConcat(translate, scale);
        transform = CGAffineTransformConcat(transform, rotate);
        
        CGAffineTransform transform2 =  CGAffineTransformConcat(translate2, scale);
        transform2 = CGAffineTransformConcat(transform2, rotate2);
        
        CGAffineTransform transform3 =  CGAffineTransformConcat(translate3, scale);
        transform3 = CGAffineTransformConcat(transform3, rotate3);
        
        CGAffineTransform transform4 =  CGAffineTransformConcat(translate4, scale);
        transform4 = CGAffineTransformConcat(transform4, rotate4);
        CGAffineTransform transform5 =  CGAffineTransformConcat(translate5, scale);
        transform5 = CGAffineTransformConcat(transform5, rotate5);
        CGAffineTransform transform6 =  CGAffineTransformConcat(translate6, scale);
        transform6 = CGAffineTransformConcat(transform6, rotate6);
        
        star.transform = transform;
        star2.transform = transform2;
        star3.transform = transform3;
        star4.transform = transform4;
        star5.transform = transform5;
        star6.transform = transform6;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             star.hidden = YES;
                             star2.hidden = YES;
                             star3.hidden = YES;
                             star4.hidden = YES;
                             star5.hidden = YES;
                             star6.hidden = YES;
                             connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
                         }
                     }];
    [UIView commitAnimations];
}

-(void)lightningblinking{
    count++;
    lightning.hidden = NO;
    lightning.alpha = 0.0f;
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:0.10];
    [UIView animateWithDuration:0.0 animations:^{
        lightning.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) 
                             [self performSelector:@selector(hidelightning) withObject:nil afterDelay:0.5];
                     }];
    [UIView commitAnimations];
}

-(void) hidelightning{
    lightning.hidden = YES;
    if(count <2)
        [self performSelector:@selector(looplightning) withObject:nil afterDelay:2.0];
    else
        connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
}

-(void) looplightning{
    [self lightningblinking];
}


-(IBAction)home:(id)sender{
    UserProfilePage *GtestClasssViewController=[[[UserProfilePage alloc] initWithNibName:@"UserProfilePage"  bundle:nil] autorelease];
    GtestClasssViewController.isneedtoplay = YES;
    [self presentModalViewController:GtestClasssViewController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait)
        return YES;
    else
        return NO;
}

- (void)dealloc {
    [star release];
    [star2 release];
    [star3 release];
    [star4 release];
    [star5 release];
    [star6 release];
    [lightning release];
    [shadow release];
    [home release];
    [character release];
    [username release];
    [userpoints release];
    [userimage release];
    [super dealloc];
}

@end
