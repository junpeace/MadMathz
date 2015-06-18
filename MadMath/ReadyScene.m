//
//  ReadyScene.m
//  MadMath
//
//  Created by Zack Loi on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReadyScene.h"

@implementation ReadyScene
@synthesize tap, gamemode, gameplayer, lblScore, lblUsername, userName, userScore, userID, imgUser, imageData, splayerID, splayerUsername, gameplayid, fcompleteTime, fcorrect, fstrWrong, fstrRepeat, match_id, isshow, fmessage, dialogbox, messager, messagername;

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
    isconnected = YES;
    
    NSString *formatScore = [NSString stringWithFormat:@"You have %@ points", self.userScore];
    
    self.lblScore.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.lblScore.text = formatScore;
    
    self.lblUsername.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.lblUsername.text = self.userName;
    
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.cornerRadius = 5.0;
    self.imgUser.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
    self.imgUser.layer.borderWidth = 1.5;
    
    [self.imgUser setImage:[UIImage imageWithData:imageData]];
    
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singletapcaptured:)];
    [tap addGestureRecognizer:singletap];
    [tap setUserInteractionEnabled:YES];
    if(self.isshow)
        [self performSelector:@selector(transitionbox) withObject:nil afterDelay:0.1];
}



- (void)viewWillAppear:(BOOL)animated
{
    countinterrupted = 0;
    connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [connectiontimer invalidate];
}

-(void)transitionbox{
    self.messagername.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.messagername.text = [NSString stringWithFormat:@"%@ said", splayerUsername];
    self.messager.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.messager.text = fmessage;
    [self.messager sizeToFit];
    
    [dialogbox setBackgroundColor:[UIColor clearColor]];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    dialogbox.frame = CGRectMake(0, 460, 320, 74);
    [dialogbox setCenter:CGPointMake(160, 433)];
    
    [self.view addSubview:dialogbox];
    
    [UIView commitAnimations];
}

-(void)checkingconnection{
    if([GlobalFunction NetworkStatus] && !isconnected){
        [GlobalFunction RemovingScreen:self];
        countdown = 0;
        isconnected = YES;
    }else if(![GlobalFunction NetworkStatus] && isconnected){
        [GlobalFunction LoadingScreen:self];
        isconnected = NO;
    }else if(![GlobalFunction NetworkStatus] && !isconnected){
        countdown++;
        if(countdown > 1200){
            LoginPage *GtestClasssViewController=[[[LoginPage alloc] initWithNibName:@"LoginPage"  bundle:nil] autorelease];
            [self presentModalViewController:GtestClasssViewController animated:YES];
        }
    }
    
    if(![GlobalFunction isplay]){
        ++countinterrupted;
        if(countinterrupted < 4)
            [GlobalFunction resumebgmusic];
        else if(countinterrupted == 4)
            [self.view makeToast:@"Background Music has been interrupted." duration:(0.5) position:@"center"];
    }
}

-(void) singletapcaptured:(UIGestureRecognizer *)gesture{
    [GlobalFunction LoadingScreen:self];
    [self performSelector:@selector(gotoandplay) withObject:nil afterDelay:0.5];
}

-(void)gotoandplay{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            WebServices *ws = [[WebServices alloc] init];
            
            GamePlay *gameplay = nil;
            
            int rndValue = 0;
            
            if(gameplayid == 0)
            {
                rndValue = 14 + arc4random() % (113 - 13);
            }
            else 
            {
                rndValue = gameplayid;
            }
            
            gameplay = [ws selectGamePlayByID:rndValue];
            
            [GlobalFunction RemovingScreen:self];
            
            GameScene *GtestClasssViewController=[[[GameScene alloc] initWithNibName:@"GameScene"  bundle:nil] autorelease];
            GtestClasssViewController.gamemode = self.gamemode;
            GtestClasssViewController.gameplayer = self.gameplayer;
            GtestClasssViewController.userID = self.userID;
            GtestClasssViewController.userName = self.userName;
            GtestClasssViewController.userScore = self.userScore;
            GtestClasssViewController.imageData = self.imageData;
            GtestClasssViewController.anws = gameplay.anws;
            GtestClasssViewController.totalPoss = gameplay.total_Possibility;
            GtestClasssViewController.allimagenumbers = gameplay.img_Numbers;
            GtestClasssViewController.gameID = gameplay.GamePlay_id;
            
            NSLog(@"game play id : %d", gameplay.GamePlay_id);
            //GtestClasssViewController.gameID = rndValue;
            
            GtestClasssViewController.splayerID = self.splayerID;
            GtestClasssViewController.splayerUsername = self.splayerUsername;
            GtestClasssViewController.fstrWrong = self.fstrWrong;
            GtestClasssViewController.fstrRepeat = self.fstrRepeat;
            GtestClasssViewController.fcorrect = self.fcorrect;
            GtestClasssViewController.fcompleteTime = self.fcompleteTime;
            GtestClasssViewController.match_id = match_id;
            [ws release];
            [GlobalFunction stopbgmusic];
            [self presentModalViewController:GtestClasssViewController animated:YES];
        });
    });
}

-(IBAction)back:(id)sender{
    [super dismissModalViewControllerAnimated:YES];
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
    [dialogbox release];
    [messager release];
    [messagername release];
    [userScore release];
    [userName release];
    [tap release];
    [super dealloc];
}

@end
