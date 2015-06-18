//
//  BattleMatchResultScene.m
//  MadMath
//
//  Created by Zack Loi on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BattleMatchResultScene.h"

@implementation BattleMatchResultScene

@synthesize result, dialogbox, userimage, character, star, star2, star3, star4, star5, star6, lightning, shadow, username, userpoints, message, messager, home, userID, userName, userScore, imageData, match_id;

@synthesize fcompleted, frepeat, fwrong, ftime, fimage, scompleted, srepeat, swrong, stime, simage, completed, repeat, wrong, time, iswin, strWrong, strRepeat, correct, completeTime, fcompleteTime, fcorrect, fstrWrong, fstrRepeat, fimagedata, splayerUsername, splayerID, postParams;

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
    message.enablesReturnKeyAutomatically = NO;
    star.hidden = YES;
    star2.hidden = YES;
    star3.hidden = YES;
    star4.hidden = YES;
    star5.hidden = YES;
    star6.hidden = YES;
    lightning.hidden = YES;
    home.hidden = YES;
    
    self.username.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.username.text = self.userName;
    
    self.userimage.layer.masksToBounds = YES;
    self.userimage.layer.cornerRadius = 5.0;
    self.userimage.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
    self.userimage.layer.borderWidth = 1.5;
    
    [self.userimage setImage:[UIImage imageWithData:imageData]];
    
    self.fimage.layer.masksToBounds = YES;
    self.fimage.layer.cornerRadius = 5.0;
    self.fimage.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
    self.fimage.layer.borderWidth = 1.5;
    
    [self.fimage setImage:[UIImage imageWithData:imageData]];
    
    self.fcompleted.text = correct;
    self.frepeat.text = strRepeat;
    self.fwrong.text = strWrong;
    self.ftime.text = [NSString stringWithFormat:@"%@s", completeTime];
    
    self.scompleted.text = fcorrect;
    self.srepeat.text = fstrRepeat;
    self.swrong.text = fstrWrong;
    self.stime.text = [NSString stringWithFormat:@"%@s", fcompleteTime];
    
    self.simage.layer.masksToBounds = YES;
    self.simage.layer.cornerRadius = 5.0;
    self.simage.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
    self.simage.layer.borderWidth = 1.5;
    
    [self.simage setImage:[UIImage imageWithData:fimagedata]];
    
    self.messager.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.messager.text = [NSString stringWithFormat:@"Write something to %@", splayerUsername];    
    
    self.postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"www.tiseno.com", @"link", @"MadMathz", @"name", @"You will crazy in one minute", @"caption", @"You hit the hundred pointer !!", @"description", nil];
    
    [self checkingresult];
    
    WebServices *ws = [[WebServices alloc] init];
    
    if(self.iswin)
    {
        shadow.hidden = YES;
        [self performSelector:@selector(transitionstar) withObject:nil afterDelay:1.5];
        [self performSelector:@selector(playsound:) withObject:@"win" afterDelay:1.5];
        
        int us = [self.userScore intValue];
        us = us + 2;
        
        [ws updateUserScore:self.userID :us];
        
        //post on user's wall
        if(([self.userScore intValue] % 100 == 98) || ([self.userScore intValue] % 100 == 99))
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
        //get user score
        NSString *splayerScore = [ws selectUserScoreByFBID:self.splayerID];
        
        count=0;
        self.userpoints.hidden = YES;
        character.image = [UIImage imageNamed:@"screen_lose.png"];
        [self performSelector:@selector(lightningblinking) withObject:nil afterDelay:1.5];
        [self performSelector:@selector(playsound:) withObject:@"lose" afterDelay:1.5];
        
        //insert user score
        int us = [splayerScore intValue];
        us = us + 2;   
        
        [ws updateUserScore:self.splayerID :us];    
        
        //post on user's wall
        if(([splayerScore intValue] % 100 == 98) || ([splayerScore intValue] % 100 == 99))
        {
            [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/feed", self.splayerID] parameters:self.postParams HTTPMethod:@"POST"
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
    
    [ws release];
    
    [self performSelector:@selector(transitionresultbg) withObject:nil afterDelay:0.5];
}

-(void)checkingresult
{
    if([self.correct intValue] > [self.fcorrect intValue])
    {
        self.iswin = YES;
    }else if([self.correct intValue] < [self.fcorrect intValue])
    {
        self.iswin = NO;
    }else{
        if([self.completeTime intValue] < [self.fcompleteTime intValue])
        {
            self.iswin = YES;
        }else if([self.completeTime intValue] > [self.fcompleteTime intValue])
        {
            self.iswin = NO;
        }else{
            if([self.strRepeat intValue] < [self.fstrRepeat intValue])
            {
                self.iswin = YES;
            }else if([self.strRepeat intValue] > [self.fstrRepeat intValue])
            {
                self.iswin = NO;
            }else{
                if([self.strWrong intValue] < [self.fstrWrong intValue])
                {
                    self.iswin = YES;
                }else if([self.strWrong intValue] > [self.fstrWrong intValue])
                {
                    self.iswin = NO;
                }else{
                    //result == result
                }
            } 
        } 
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
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
        if(countdown > 1200){
            LoginPage *GtestClasssViewController=[[[LoginPage alloc] initWithNibName:@"LoginPage"  bundle:nil] autorelease];
            GtestClasssViewController.isneedtoplay = YES;
            [self presentModalViewController:GtestClasssViewController animated:YES];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [message resignFirstResponder];
    [self registerForKeyboardNotifications];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self registerForKeyboardNotifications];
}

-(IBAction)submit:(id)sender
{
    WebServices *ws = [[WebServices alloc] init];
    [ws insertSPlayerDetails:message.text :@"" :[completeTime intValue] :[correct intValue] :0 :[strWrong intValue] :self.match_id :[strRepeat intValue]];
    [ws release];
    
    [GlobalFunction LoadingScreen:self];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
}

-(IBAction)home:(id)sender{
    WebServices *ws = [[WebServices alloc] init];
    
    [ws insertSPlayerDetails:message.text :@"" :[completeTime intValue] :[correct intValue] :0 :[strWrong intValue] :self.match_id :[strRepeat intValue]];
    [ws release];
    
    [GlobalFunction LoadingScreen:self];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
}

-(void)delay{
    [GlobalFunction RemovingScreen:self];
    UserProfilePage *GtestClasssViewController=[[[UserProfilePage alloc] initWithNibName:@"UserProfilePage"  bundle:nil] autorelease];
    GtestClasssViewController.isneedtoplay = YES;
    [self presentModalViewController:GtestClasssViewController animated:YES]; 
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
}

-(void) looplightning{
    [self lightningblinking];
}

-(void)transitionresultbg{
    [result setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1.0];
    
    [UIView animateWithDuration:0.0 animations:^{
        result.frame = CGRectMake(0, 460, 320, 160);
        [result setCenter:CGPointMake(160, 310)];
        [self.view addSubview:result];
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self transitionimageviewimage];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)transitionimageviewimage{
    fimage.alpha = 0.0f;
    simage.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView animateWithDuration:0.0 animations:^{
        fimage.alpha = 1.0f;
        simage.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self transitionlabelcompleted];
                         }
                     }];
    
    [UIView commitAnimations];
    
}

-(void)transitionlabelcompleted{
    fcompleted.alpha = 0.0f;
    scompleted.alpha = 0.0f;
    completed.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView animateWithDuration:0.0 animations:^{
        fcompleted.alpha = 1.0f;
        scompleted.alpha = 1.0f;
        completed.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self transitionlabelrepeat];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)transitionlabelrepeat{
    frepeat.alpha = 0.0f;
    srepeat.alpha = 0.0f;
    repeat.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView animateWithDuration:0.0 animations:^{
        frepeat.alpha = 1.0f;
        srepeat.alpha = 1.0f;
        repeat.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self transitionlabelwrong];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)transitionlabelwrong{
    fwrong.alpha = 0.0f;
    swrong.alpha = 0.0f;
    wrong.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView animateWithDuration:0.0 animations:^{
        fwrong.alpha = 1.0f;
        swrong.alpha = 1.0f;
        wrong.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self transitionlabeltime];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)transitionlabeltime{
    ftime.alpha = 0.0f;
    stime.alpha = 0.0f;
    time.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView animateWithDuration:0.0 animations:^{
        ftime.alpha = 1.0f;
        stime.alpha = 1.0f;
        time.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self transitionbox];
                             home.hidden = NO;
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)transitionbox{
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1.0];
    [dialogbox setBackgroundColor:[UIColor clearColor]];
    
    dialogbox.frame = CGRectMake(0, 480, 320, 74);
    [dialogbox setCenter:CGPointMake(160, 433)];
    
    [self.view addSubview:dialogbox];
    
    [UIView commitAnimations];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    dialogbox.frame = CGRectMake(0, self.view.frame.size.height - kbSize.height - 84, 320, 74);
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    dialogbox.frame = CGRectMake(0, 396, 320, 74);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait)
        return YES;
    else
        return NO;
}

- (void)dealloc {
    [result release];
    [dialogbox release];
    [userimage release];
    [userpoints release];
    [username release];
    [star release];
    [star2 release];
    [star3 release];
    [star4 release];
    [star5 release];
    [star6 release];
    [lightning release];
    [shadow release];
    [character release];
    
    [fcompleted release];
    [frepeat release];
    [fwrong release];
    [ftime release];
    [fimage release];
    [scompleted release];
    [srepeat release];
    [swrong release];
    [stime release];
    [simage release];
    [completed release];
    [repeat release];
    [wrong release];
    [time release];
    
    [message release];
    [messager release];
    [home release];
    [super dealloc];
}

@end
