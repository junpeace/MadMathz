//
//  GameScene.m
//  MadMath
//
//  Created by Zack Loi on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

#define beganX       28
#define endedX       292
#define beganY       180
#define endedY       460
//v b#define positioninitvalue       100

@implementation GameScene
@synthesize image1, image2, image3, image4, image5, image6, image7, image8, image9, image10, image11, image12, image13, image14, image15, image16, star, star2, star3, star4, star5, star6, answer, completed, posibility, time, username, userpoints, userimage, resulttext, imageData, userID, userName, userScore, allimagenumbers;
@synthesize gamemode, gameplayer,currentanswer, positionvalue, anws, totalPoss, gameID, splayerID, splayerUsername, fcorrect, fcompleteTime, fstrRepeat, fstrWrong, fimagedata, match_id;

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
    
    [GlobalFunction playbgmusic:@"gamecountdown":@"wav":-1];
    self.userpoints.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.username.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    
    self.userpoints.text = [NSString stringWithFormat:@"You have %@ points", self.userScore];
    self.username.text = self.userName;
    
    self.userimage.layer.masksToBounds = YES;
    self.userimage.layer.cornerRadius = 5.0;
    self.userimage.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
    self.userimage.layer.borderWidth = 1.5;
    
    self.answer.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.posibility.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.time.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.completed.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    
    [self.userimage setImage:[UIImage imageWithData:imageData]];
    
    if(self.splayerID != nil)
    {
        NSString *strurl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", self.splayerID];
    
        NSURL *url = [NSURL URLWithString:strurl];
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
            self.fimagedata = [NSData dataWithContentsOfURL:url];
        
            dispatch_async(dispatch_get_main_queue(), ^{
         
                });
        });
    }
    
    [self loaddata];
    [self changeimage:@"default"];
}

- (void)viewWillAppear:(BOOL)animated
{
    connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [connectiontimer invalidate];
    [GlobalFunction stopbgmusic];
}

-(void)checkingconnection{
    if([GlobalFunction NetworkStatus] && !isconnected){
        countdown = 0;
        isconnected = YES;
        isstopped = NO;
        [GlobalFunction resumebgmusic];
        [GlobalFunction RemovingScreen:self];
        timer = [NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
    }else if(![GlobalFunction NetworkStatus] && isconnected){
        [GlobalFunction LoadingScreen:self];
        isconnected = NO;
    }else if(![GlobalFunction NetworkStatus] && !isconnected){
        if(!isstopped){
            [timer invalidate];
            [GlobalFunction pausebgmusic];
        }
        isstopped = YES;
        countdown++;
        if(countdown > 1200){
            LoginPage *GtestClasssViewController=[[[LoginPage alloc] initWithNibName:@"LoginPage"  bundle:nil] autorelease];
            GtestClasssViewController.isneedtoplay = YES;
            [self presentModalViewController:GtestClasssViewController animated:YES];
        }
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate.ispause){
        if(!ispause){
            [timer invalidate];
            [GlobalFunction pausebgmusic];
            [GlobalFunction IncomingCallLoadingScreen:self];
            ispause = YES;
        }
    }else {
        if(ispause){
            [GlobalFunction IncomingCallRemovingScreen:self];
            timer = [NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
            ispause = NO;
            [GlobalFunction resumebgmusic];
        }
    }
    
    if(appDelegate.isquit){
        if(appDelegate.isvalid){
            //[timer invalidate];
        }
        [GlobalFunction stopbgmusic];
        if(self.gameplayer == 2){
            WebServices *ws = [[WebServices alloc] init];
            [ws insertSPlayerDetails:@"I quitted" :@"" :[time.text intValue] :correct :0 :wrong :self.match_id :repeat];
            [ws release];
        }
        UserProfilePage *GtestClasssViewController=[[[UserProfilePage alloc] initWithNibName:@"UserProfilePage"  bundle:nil] autorelease];
        GtestClasssViewController.isneedtoplay = YES;
        [self presentModalViewController:GtestClasssViewController animated:YES];
    }
    
    if(![GlobalFunction isplay]){
        int timeleft = [time.text intValue];
        if(timeleft > 0 && ![posibility.text isEqualToString:completed.text] && !appDelegate.ispause)
            [GlobalFunction resumebgmusic];
    }
}

-(void) loaddata{
    ischose = [[NSMutableArray alloc]init];
    for(int i = 0; i< 16; i++)
        [ischose addObject:[NSNumber numberWithBool:NO]];
    isrepeat = [[NSMutableArray alloc]init];

    time.text = @"60";
    self.answer.text = self.anws;
    self.posibility.text = self.totalPoss;
    self.positionvalue = 0;
    self.currentanswer = 0;
    correct = 0;
    repeat = 0;
    wrong = 0;
    
    
    star.hidden = YES;
    star2.hidden = YES;
    star3.hidden = YES;
    star4.hidden = YES;
    star5.hidden = YES;
    star6.hidden = YES;
    
    star1Initial=star.transform;
    star2Initial=star2.transform;
    star3Initial=star3.transform;
    star4Initial=star4.transform;
    star5Initial=star5.transform;
    star6Initial=star6.transform;
    
    isconnected = YES;
    isstopped = NO;
    ispause = NO;
    resulttext.hidden = YES;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.ispause = NO;
    appDelegate.isquit = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
    connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
}

-(void)changeimage:(NSString *)status{
    if([status isEqualToString:@"default"])
    {
        image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(0, 1)]]];
        image1.tag =  1;
        [image1 setUserInteractionEnabled:YES];
        
        image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(1, 1)]]];
        image2.tag = 2;
        [image2 setUserInteractionEnabled:YES];
        
        image3.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(2, 1)]]];
        image3.tag = 3;
        [image3 setUserInteractionEnabled:YES];
        
        image4.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(3, 1)]]];
        image4.tag = 4;
        [image4 setUserInteractionEnabled:YES];
        
        image5.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(4, 1)]]];
        image5.tag = 5;
        [image5 setUserInteractionEnabled:YES];
        
        image6.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(5, 1)]]];
        image6.tag = 6;
        [image6 setUserInteractionEnabled:YES];
        
        image7.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(6, 1)]]];
        image7.tag = 7;
        [image7 setUserInteractionEnabled:YES];
        
        image8.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(7, 1)]]];
        image8.tag = 8;
        [image8 setUserInteractionEnabled:YES];
        
        image9.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(8, 1)]]];
        image9.tag = 9;
        [image9 setUserInteractionEnabled:YES];
        
        image10.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(9, 1)]]];
        image10.tag = 10;
        [image10 setUserInteractionEnabled:YES];
        
        image11.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(10, 1)]]];
        image11.tag = 11;
        [image11 setUserInteractionEnabled:YES];
        
        image12.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(11, 1)]]];
        image12.tag = 12;
        [image12 setUserInteractionEnabled:YES];
        
        image13.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(12, 1)]]];
        image13.tag = 13;
        [image13 setUserInteractionEnabled:YES];
        
        image14.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(13, 1)]]];
        image14.tag = 14;
        [image14 setUserInteractionEnabled:YES];
        
        image15.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(14, 1)]]];
        image15.tag = 15;
        [image15 setUserInteractionEnabled:YES];
        
        image16.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@", [allimagenumbers substringWithRange:NSMakeRange(15, 1)]]];
        image16.tag = 16;
        [image16 setUserInteractionEnabled:YES];
    }
    else if([status isEqualToString:@"correct"] || [status isEqualToString:@"selected"])
    {
        [self looping:@"_correct"];
    }
    else if([status isEqualToString:@"wrong"] || [status isEqualToString:@"repeat"])
    {
        [self looping:@"_wrong_repeat"];
    }
}

-(void)looping:(NSString *)path{
    for(int i = 0; i< ischose.count; i++)
    {
        if([[ischose objectAtIndex:i] boolValue] == 1 && i == 0)
        {
            image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 1)
        {
            image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 2)
        {
            image3.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 3)
        {
            image4.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 4)
        {
            image5.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 5)
        {
            image6.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 6)
        {
            image7.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 7)
        {
            image8.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 8)
        {
            image9.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 9)
        {
            image10.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 10)
        {
            image11.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 11)
        {
            image12.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 12)
        {
            image13.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 13)
        {
            image14.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 14)
        {
            image15.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
        else if([[ischose objectAtIndex:i] boolValue] == 1 && i == 15)
        {
            image16.image = [UIImage imageNamed:[NSString stringWithFormat:@"stone%@%@", [allimagenumbers substringWithRange:NSMakeRange(i, 1)], path]];
            continue;
        }
    }
}

-(void)displayresulttext:(NSString *)status{
    resulttext.hidden = NO;
    if([status isEqualToString:@"correct"] )
    {
        resulttext.frame = CGRectMake(28, 292, 265, 57);
        resulttext.image = [UIImage imageNamed:@"correct.png"];
    }
    else if([status isEqualToString:@"wrong"])
    {
        resulttext.frame = CGRectMake(118, 269, 85, 102);
        resulttext.image = [UIImage imageNamed:@"wrong.png"];
    }
    else if([status isEqualToString:@"repeat"])
    {
        resulttext.frame = CGRectMake(52, 288, 216, 63);
        resulttext.image = [UIImage imageNamed:@"repeat.png"];
    }
    
    resulttext.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    [UIView animateWithDuration:0.0 animations:^{
        resulttext.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             resulttext.hidden = YES;
                             [self performSelector:@selector(changeimage:) withObject:@"default" afterDelay:0.1];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)transitionstar{
    star.hidden = NO;
    star2.hidden = NO;
    star3.hidden = NO;
    star4.hidden = NO;
    star5.hidden = NO;
    star6.hidden = NO;
    
    star.transform=star1Initial;
    star2.transform=star2Initial;
    star3.transform=star3Initial;
    star4.transform=star4Initial; 
    star5.transform=star5Initial;
    star6.transform=star6Initial;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView animateWithDuration:0.0 animations:^{
        CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
        CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI);
        CGAffineTransform rotate2 = CGAffineTransformMakeRotation(-M_PI);
        CGAffineTransform rotate3 = CGAffineTransformMakeRotation(-M_PI);
        CGAffineTransform rotate4 = CGAffineTransformMakeRotation(M_PI);
        CGAffineTransform rotate5 = CGAffineTransformMakeRotation(-M_PI);
        CGAffineTransform rotate6 = CGAffineTransformMakeRotation(M_PI);
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

-(void)updatetime{
    int timeleft = [time.text intValue];
    if(timeleft >= 0){
        if(timeleft == 0){
            [self result];
            [timer invalidate];
        }else{
            timeleft--;
            time.text = [NSString stringWithFormat:@"%d", timeleft];
        }
    }
}

- (void)result{
    if([time.text isEqualToString:@"0"]){
        if(self.gamemode == 1){
            SingleMatchResultScene *GtestClasssViewController=[[[SingleMatchResultScene alloc] initWithNibName:@"SingleMatchResultScene"  bundle:nil] autorelease];
            GtestClasssViewController.userName = self.userName;
            GtestClasssViewController.imageData = self.imageData;
            GtestClasssViewController.userID = self.userID;
            GtestClasssViewController.userScore = self.userScore;
            
            if([completed.text isEqualToString:posibility.text])
                GtestClasssViewController.iswin = YES;
            else 
                GtestClasssViewController.iswin = NO;
            [self performSelector:@selector(delay:) withObject:GtestClasssViewController afterDelay:0.3];
        }else{
            if(self.gameplayer == 1){
                BattleMatchWaitingScene *GtestClasssViewController=[[[BattleMatchWaitingScene alloc] initWithNibName:@"BattleMatchWaitingScene"  bundle:nil] autorelease];
                GtestClasssViewController.userName = self.userName;
                GtestClasssViewController.imageData = self.imageData;
                GtestClasssViewController.userID = self.userID;
                GtestClasssViewController.userScore = self.userScore;
                
                GtestClasssViewController.correct = [NSString stringWithFormat:@"%d", correct];
                GtestClasssViewController.wrong = [NSString stringWithFormat:@"%d", wrong];
                GtestClasssViewController.repeat = [NSString stringWithFormat:@"%d", repeat];
                GtestClasssViewController.completeTime = [NSString stringWithFormat:@"%d", 60];
                GtestClasssViewController.gameID = self.gameID;
                GtestClasssViewController.splayerID = self.splayerID;
                GtestClasssViewController.splayerUsername = self.splayerUsername;
                
                [self performSelector:@selector(delay:) withObject:GtestClasssViewController afterDelay:0.3];
            }else {
                BattleMatchResultScene *GtestClasssViewController=[[[BattleMatchResultScene alloc] initWithNibName:@"BattleMatchResultScene"  bundle:nil] autorelease];
                GtestClasssViewController.userName = self.userName;
                GtestClasssViewController.imageData = self.imageData;
                GtestClasssViewController.userID = self.userID;
                GtestClasssViewController.userScore = self.userScore;
                
                GtestClasssViewController.correct = [NSString stringWithFormat:@"%d", correct];
                GtestClasssViewController.strWrong = [NSString stringWithFormat:@"%d", wrong];
                GtestClasssViewController.strRepeat = [NSString stringWithFormat:@"%d", repeat];
                GtestClasssViewController.completeTime = [NSString stringWithFormat:@"%d", 60];
                
                GtestClasssViewController.splayerUsername = self.splayerUsername;
                GtestClasssViewController.splayerID = self.splayerID;
                
                GtestClasssViewController.fstrWrong = self.fstrWrong;
                GtestClasssViewController.fstrRepeat = self.fstrRepeat;
                GtestClasssViewController.fcompleteTime = self.fcompleteTime;
                GtestClasssViewController.fcorrect = self.fcorrect;
                GtestClasssViewController.fimagedata = self.fimagedata;
                GtestClasssViewController.match_id = self.match_id;
                
                [self performSelector:@selector(delay:) withObject:GtestClasssViewController afterDelay:0.3];
            }
        }
    }else {
        if(self.gamemode == 1){
            if([completed.text isEqualToString:posibility.text]){
                SingleMatchResultScene *GtestClasssViewController=[[[SingleMatchResultScene alloc] initWithNibName:@"SingleMatchResultScene"  bundle:nil] autorelease];
                GtestClasssViewController.userName = self.userName;
                GtestClasssViewController.imageData = self.imageData;
                GtestClasssViewController.userID = self.userID;
                GtestClasssViewController.userScore = self.userScore;
                
                GtestClasssViewController.iswin = YES;
                [self performSelector:@selector(delay:) withObject:GtestClasssViewController afterDelay:0.3];
            }
        }else{
            if([completed.text isEqualToString:posibility.text]){
                if(self.gameplayer == 1){
                    BattleMatchWaitingScene *GtestClasssViewController=[[[BattleMatchWaitingScene alloc] initWithNibName:@"BattleMatchWaitingScene"  bundle:nil] autorelease];
                    GtestClasssViewController.userName = self.userName;
                    GtestClasssViewController.imageData = self.imageData;
                    GtestClasssViewController.userID = self.userID;
                    GtestClasssViewController.userScore = self.userScore;
                    
                    GtestClasssViewController.correct = [NSString stringWithFormat:@"%d", correct];
                    GtestClasssViewController.wrong = [NSString stringWithFormat:@"%d", wrong];
                    GtestClasssViewController.repeat = [NSString stringWithFormat:@"%d", repeat];
                    GtestClasssViewController.completeTime = [NSString stringWithFormat:@"%d", 60 - [time.text intValue]];
                    GtestClasssViewController.gameID = self.gameID;
                    GtestClasssViewController.splayerID = self.splayerID;
                    GtestClasssViewController.splayerUsername = self.splayerUsername;
                    
                    [self performSelector:@selector(delay:) withObject:GtestClasssViewController afterDelay:0.3];
                }else {
                    BattleMatchResultScene *GtestClasssViewController=[[[BattleMatchResultScene alloc] initWithNibName:@"BattleMatchResultScene"  bundle:nil] autorelease];
                    GtestClasssViewController.userName = self.userName;
                    GtestClasssViewController.imageData = self.imageData;
                    GtestClasssViewController.userID = self.userID;
                    GtestClasssViewController.userScore = self.userScore;
                    
                    GtestClasssViewController.correct = [NSString stringWithFormat:@"%d", correct];
                    GtestClasssViewController.strWrong = [NSString stringWithFormat:@"%d", wrong];
                    GtestClasssViewController.strRepeat = [NSString stringWithFormat:@"%d", repeat];
                    GtestClasssViewController.completeTime = [NSString stringWithFormat:@"%d", 60 - [time.text intValue]];
                    
                    GtestClasssViewController.splayerUsername = self.splayerUsername;
                    GtestClasssViewController.splayerID = self.splayerID;
                    
                    GtestClasssViewController.fstrWrong = self.fstrWrong;
                    GtestClasssViewController.fstrRepeat = self.fstrRepeat;
                    GtestClasssViewController.fcompleteTime = self.fcompleteTime;
                    GtestClasssViewController.fcorrect = self.fcorrect;
                    GtestClasssViewController.fimagedata = self.fimagedata;
                    GtestClasssViewController.match_id = self.match_id;
                    
                    [self performSelector:@selector(delay:) withObject:GtestClasssViewController afterDelay:0.3];
                }
            }
        }
    }
}

-(void)delay:(UIViewController *)viewcontroller{
    [GlobalFunction stopbgmusic];
    [self presentModalViewController:viewcontroller animated:YES];
}

-(int)converter:(NSString*)number{
    
    return [number intValue];
}

-(void)countinganswer{
    if(isbegan && isended){
        BOOL positionrepeat = NO;
        if(currentanswer == [answer.text intValue])
        {
            for(int i = 0; i< isrepeat.count; i++){
                if(positionvalue == [[isrepeat objectAtIndex:i] intValue])
                {
                    //Display Repeat IMAGE;
                    positionrepeat = YES;
                    repeat++;
                    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                    if(!appDelegate.ismute){
                        soundeffect = [GlobalFunction createSoundID: @"wrongrepeat"];
                        AudioServicesPlaySystemSound(soundeffect);
                    }
                    [self changeimage:@"repeat"];
                    [self displayresulttext:@"repeat"];
                    break;
                }
                else 
                {
                    continue;
                }
            }
            
            if(!positionrepeat)
            {
                //Display Correct IMAGE;
                [isrepeat addObject:[NSNumber numberWithInt:positionvalue]];
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                if(!appDelegate.ismute){
                    soundeffect = [GlobalFunction createSoundID: @"correct"];
                    AudioServicesPlaySystemSound(soundeffect);
                }
                [self displayresulttext:@"correct"];
                [self transitionstar];
                correct++;
                completed.text = [NSString stringWithFormat:@"%d", correct];
                [self result];
            } 
        }
        else
        {
            //Display Wrong IMAGE;
            wrong++;
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            if(!appDelegate.ismute){
                soundeffect = [GlobalFunction createSoundID: @"wrongrepeat"];
                AudioServicesPlaySystemSound(soundeffect);
            }
            [self changeimage:@"wrong"];
            [self displayresulttext:@"wrong"];
        }
        isbegan = NO;
        isended = NO;
        currentanswer = 0;
        positionvalue = 0;
        for(int i = 0; i< 16; i++)
            [ischose replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchLocation = [touch locationInView:self.view];
    if(!ispause && [time.text intValue] > 0){
        if(!isbegan && !isended){
            if(currentTouchLocation.x >= beganX && currentTouchLocation.x < endedX)
            {
                if(currentTouchLocation.y >= beganY && currentTouchLocation.y < beganY + image1.frame.size.height)
                {
                    isbegan = YES;
                    isreverse = NO;
                    if(currentTouchLocation.x >= beganX && currentTouchLocation.x < beganX + image1.frame.size.width)
                    {
                        if([[ischose objectAtIndex:0] boolValue] == 0)
                        {
                            currentposition = image1.tag;
                            positionvalue += pow(image1.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(0, 1)]]];
                            [ischose replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width && currentTouchLocation.x < beganX + image1.frame.size.width * 2)
                    {
                        if([[ischose objectAtIndex:1] boolValue] == 0)
                        {
                            currentposition = image2.tag;
                            positionvalue += pow(image2.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(1, 1)]]];
                            [ischose replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX + image1.frame.size.width * 3) 
                    {
                        if([[ischose objectAtIndex:2] boolValue] == 0)
                        {
                            currentposition = image3.tag;
                            positionvalue += pow(image3.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(2, 1)]]];
                            [ischose replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX) 
                    {
                        if([[ischose objectAtIndex:3] boolValue] == 0)
                        {
                            currentposition = image4.tag;
                            positionvalue += pow(image4.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(3, 1)]]];
                            [ischose replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                }
                else if(currentTouchLocation.y >= beganY + image1.frame.size.height && currentTouchLocation.y < beganY + image1.frame.size.height * 2)
                {
                    isbegan = YES;
                    isreverse = NO;
                    if(currentTouchLocation.x >= beganX && currentTouchLocation.x < beganX + image1.frame.size.width)
                    {
                        if([[ischose objectAtIndex:4] boolValue] == 0)
                        {
                            currentposition = image5.tag;
                            positionvalue += pow(image5.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(4, 1)]]];
                            [ischose replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width && currentTouchLocation.x < beganX + image1.frame.size.width * 2)
                    {
                        if([[ischose objectAtIndex:5] boolValue] == 0)
                        {
                            currentposition = image6.tag;
                            positionvalue += pow(image6.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(5, 1)]]];
                            [ischose replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX + image1.frame.size.width * 3) 
                    {
                        if([[ischose objectAtIndex:6] boolValue] == 0)
                        {
                            currentposition = image7.tag;
                            positionvalue += pow(image7.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(6, 1)]]];
                            [ischose replaceObjectAtIndex:6 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX) 
                    {
                        if([[ischose objectAtIndex:7] boolValue] == 0)
                        {
                            currentposition = image8.tag;
                            positionvalue += pow(image8.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(7, 1)]]];
                            [ischose replaceObjectAtIndex:7 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                }
                else if(currentTouchLocation.y >= beganY + image1.frame.size.height * 2 && currentTouchLocation.y < beganY + image1.frame.size.height * 3)
                {
                    isbegan = YES;
                    if(currentTouchLocation.x >= beganX && currentTouchLocation.x < beganX + image1.frame.size.width)
                    {
                        if([[ischose objectAtIndex:8] boolValue] == 0)
                        {
                            currentposition = image9.tag;
                            positionvalue += pow(image9.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(8, 1)]]];
                            [ischose replaceObjectAtIndex:8 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width && currentTouchLocation.x < beganX + image1.frame.size.width * 2)
                    {
                        if([[ischose objectAtIndex:9] boolValue] == 0)
                        {
                            currentposition = image10.tag;
                            positionvalue += pow(image9.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(9, 1)]]];
                            [ischose replaceObjectAtIndex:9 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX + image1.frame.size.width * 3) 
                    {
                        if([[ischose objectAtIndex:10] boolValue] == 0)
                        {
                            currentposition = image11.tag;
                            positionvalue += pow(image11.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(10, 1)]]];
                            [ischose replaceObjectAtIndex:10 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX) 
                    {
                        if([[ischose objectAtIndex:11] boolValue] == 0)
                        {
                            currentposition = image12.tag;
                            positionvalue += pow(image12.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(11, 1)]]];
                            [ischose replaceObjectAtIndex:11 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                }
                else if(currentTouchLocation.y >= beganY + image1.frame.size.height * 3 && currentTouchLocation.y < endedY)
                {
                    isbegan = YES;
                    if(currentTouchLocation.x >= beganX && currentTouchLocation.x < beganX + image1.frame.size.width)
                    {
                        if([[ischose objectAtIndex:12] boolValue] == 0)
                        {
                            currentposition = image13.tag;
                            positionvalue += pow(image13.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(12, 1)]]];
                            [ischose replaceObjectAtIndex:12 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width && currentTouchLocation.x < beganX + image1.frame.size.width * 2)
                    {
                        if([[ischose objectAtIndex:13] boolValue] == 0)
                        {
                            currentposition = image14.tag;
                            positionvalue += pow(image14.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(13, 1)]]];
                            [ischose replaceObjectAtIndex:13 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX + image1.frame.size.width * 3) 
                    {
                        if([[ischose objectAtIndex:14] boolValue] == 0)
                        {
                            currentposition = image15.tag;
                            positionvalue += pow(image15.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(14, 1)]]];
                            [ischose replaceObjectAtIndex:14 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                    }
                    else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX) 
                    {
                        if([[ischose objectAtIndex:15] boolValue] == 0)
                        {
                            currentposition = image16.tag;
                            positionvalue += pow(image16.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(15, 1)]]];
                            [ischose replaceObjectAtIndex:15 withObject:[NSNumber numberWithBool:YES]];
                        }
                    }
                }
                else
                {
                    isoutofbound = YES;
                }
            }
            else
            {
                isoutofbound = YES;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchLocation = [touch locationInView:self.view];
    
    float gapX = image1.frame.size.width / 8;
    float gapY = image1.frame.size.height / 8;
    
    if(isbegan && !isended){
        if(currentTouchLocation.x >= beganX && currentTouchLocation.x < endedX)
        {
            if(currentTouchLocation.y >= beganY && currentTouchLocation.y < beganY + image1.frame.size.height)
            {
                if(currentTouchLocation.x >= beganX && currentTouchLocation.x < beganX + image1.frame.size.width)
                {
                    if((currentTouchLocation.x >= beganX + gapX && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width) && (currentTouchLocation.y >= beganY  + gapY && currentTouchLocation.y < beganY - gapY + image1.frame.size.height))
                    {
                        if([[ischose objectAtIndex:0] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image1.tag;
                            positionvalue += pow(image1.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(0, 1)]]];
                            [ischose replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image1.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width && currentTouchLocation.x < beganX + image1.frame.size.width * 2)
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width * 2) && (currentTouchLocation.y >= beganY  + gapY && currentTouchLocation.y < beganY - gapY + image1.frame.size.height))
                    {
                        if([[ischose objectAtIndex:1] boolValue] == 0 && !isreverse)
                        {
                            
                            currentposition = image2.tag;
                            positionvalue += pow(image2.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(1, 1)]]];
                            [ischose replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image2.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX + image1.frame.size.width * 3) 
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width * 3) && (currentTouchLocation.y >= beganY  + gapY && currentTouchLocation.y < beganY - gapY + image1.frame.size.height))
                    {
                        if([[ischose objectAtIndex:2] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image3.tag;
                            positionvalue += pow(image2.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(2, 1)]]];
                            [ischose replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image3.tag)
                            {
                                isreverse = YES;
                                
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX) 
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX  - gapX) && (currentTouchLocation.y >= beganY  + gapY && currentTouchLocation.y < beganY - gapY + image1.frame.size.height))
                    {
                        if([[ischose objectAtIndex:3] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image4.tag;
                            positionvalue += pow(image4.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(3, 1)]]];
                            [ischose replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image4.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
            }
            else if(currentTouchLocation.y >= beganY + image1.frame.size.height && currentTouchLocation.y < beganY + image1.frame.size.height * 2)
            {
                if(currentTouchLocation.x >= beganX && currentTouchLocation.x < beganX + image1.frame.size.width)
                {
                    if((currentTouchLocation.x >= beganX + gapX && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height && currentTouchLocation.y < beganY - gapY + image1.frame.size.height * 2))
                    {
                        if([[ischose objectAtIndex:4] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image5.tag;
                            positionvalue += pow(image5.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(4, 1)]]];
                            [ischose replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image5.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width && currentTouchLocation.x < beganX + image1.frame.size.width * 2)
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width * 2) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height && currentTouchLocation.y < beganY - gapY + image1.frame.size.height * 2))
                    {
                        if([[ischose objectAtIndex:5] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image6.tag;
                            positionvalue += pow(image6.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(5, 1)]]];
                            [ischose replaceObjectAtIndex:5 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image6.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX + image1.frame.size.width * 3) 
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width * 3) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height && currentTouchLocation.y < beganY - gapY + image1.frame.size.height * 2))
                    {
                        if([[ischose objectAtIndex:6] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image7.tag;
                            positionvalue += pow(image7.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(6, 1)]]];
                            [ischose replaceObjectAtIndex:6 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image7.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX) 
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX  - gapX) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height && currentTouchLocation.y < beganY - gapY + image1.frame.size.height * 2))
                    {
                        if([[ischose objectAtIndex:7] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image8.tag;
                            positionvalue += pow(image8.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(7, 1)]]];
                            [ischose replaceObjectAtIndex:7 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image8.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
            }
            else if(currentTouchLocation.y >= beganY + image1.frame.size.height * 2 && currentTouchLocation.y < beganY + image1.frame.size.height * 3)
            {
                if(currentTouchLocation.x >= beganX && currentTouchLocation.x < beganX + image1.frame.size.width)
                {
                    if((currentTouchLocation.x >= beganX + gapX && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height * 2 && currentTouchLocation.y < beganY - gapY + image1.frame.size.height * 3))
                    {
                        if([[ischose objectAtIndex:8] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image9.tag;
                            positionvalue += pow(image9.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(8, 1)]]];
                            [ischose replaceObjectAtIndex:8 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image9.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width && currentTouchLocation.x < beganX + image1.frame.size.width * 2)
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width * 2) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height * 2 && currentTouchLocation.y < beganY - gapY + image1.frame.size.height * 3))
                    {
                        if([[ischose objectAtIndex:9] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image10.tag;
                            positionvalue += pow(image10.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(9, 1)]]];
                            [ischose replaceObjectAtIndex:9 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image10.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX + image1.frame.size.width * 3) 
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width * 3) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height * 2 && currentTouchLocation.y < beganY - gapY + image1.frame.size.height * 3))
                    {
                        if([[ischose objectAtIndex:10] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image11.tag;
                            positionvalue += pow(image11.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(10, 1)]]];
                            [ischose replaceObjectAtIndex:10 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image11.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX) 
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX  - gapX) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height * 2 && currentTouchLocation.y < beganY - gapY + image1.frame.size.height * 3))
                    {
                        if([[ischose objectAtIndex:11] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image12.tag;
                            positionvalue += pow(image12.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(11, 1)]]];
                            [ischose replaceObjectAtIndex:11 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image12.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
            }
            else if(currentTouchLocation.y >= beganY + image1.frame.size.height * 3 && currentTouchLocation.y < endedY)
            {
                if(currentTouchLocation.x >= beganX && currentTouchLocation.x < beganX + image1.frame.size.width)
                {
                    if((currentTouchLocation.x >= beganX + gapX && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height * 3 && currentTouchLocation.y < endedY - gapY))
                    {
                        if([[ischose objectAtIndex:12] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image13.tag;
                            positionvalue += pow(image13.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(12, 1)]]];
                            [ischose replaceObjectAtIndex:12 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image13.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width && currentTouchLocation.x < beganX + image1.frame.size.width * 2)
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width * 2) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height * 3 && currentTouchLocation.y < endedY - gapY))
                    {
                        if([[ischose objectAtIndex:13] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image14.tag;
                            positionvalue += pow(image14.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(13, 1)]]];
                            [ischose replaceObjectAtIndex:13 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image14.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX + image1.frame.size.width * 3) 
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width * 2 && currentTouchLocation.x < beganX  - gapX + image1.frame.size.width * 3) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height * 3 && currentTouchLocation.y < endedY - gapY))
                    {
                        if([[ischose objectAtIndex:14] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image15.tag;
                            positionvalue += pow(image15.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(14, 1)]]];
                            [ischose replaceObjectAtIndex:14 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image15.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
                else if(currentTouchLocation.x >= beganX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX) 
                {
                    if((currentTouchLocation.x >= beganX + gapX + image1.frame.size.width * 3 && currentTouchLocation.x < endedX  - gapX) && (currentTouchLocation.y >= beganY  + gapY + image1.frame.size.height * 3 && currentTouchLocation.y < endedY - gapY))
                    {
                        if([[ischose objectAtIndex:15] boolValue] == 0 && !isreverse)
                        {
                            currentposition = image16.tag;
                            positionvalue += pow(image16.tag, 3);
                            currentanswer += [self converter:[NSString stringWithFormat:@"%@", [allimagenumbers substringWithRange:NSMakeRange(15, 1)]]];
                            [ischose replaceObjectAtIndex:15 withObject:[NSNumber numberWithBool:YES]];
                            [self changeimage:@"selected"];
                        }
                        else
                        {
                            if(currentposition != image16.tag)
                            {
                                isreverse = YES;
                            }
                            else
                            {
                                isreverse = NO;
                            }
                        }
                    }
                }
            }
            else
            {
                isended = YES;
                isoutofbound = YES;
                if(isbegan && isoutofbound)
                    [self countinganswer];
            }
        }
        else
        {
            isended = YES;
            isoutofbound = YES;
            if(isbegan && isoutofbound)
                [self countinganswer];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if(!isoutofbound)
    {
        isended = YES;
        [self countinganswer];
    }
    else
        isoutofbound = NO;
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
    [image1 release];
    [image2 release];
    [image3 release];
    [image4 release];
    [image5 release];
    [image6 release];
    [image7 release];
    [image8 release];
    [image9 release];
    [image10 release];
    [image11 release];
    [image12 release];
    [image13 release];
    [image14 release];
    [image15 release];
    [image16 release];
    
    [star release];
    [star2 release];
    [star3 release];
    [star4 release];
    [star5 release];
    [star6 release];
    
    [answer release];
    [posibility release];
    [time release];
    [completed release];
    [username release];
    [userpoints release];
    [userimage release];
    [resulttext release];
    
    [ischose release];
    [isrepeat release];
    [super dealloc];
}

@end
