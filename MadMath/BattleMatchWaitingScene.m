//
//  BattleMatchWaitingScene.m
//  MadMath
//
//  Created by Zack Loi on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BattleMatchWaitingScene.h"

@implementation BattleMatchWaitingScene

@synthesize username, userpoints, userimage, dialogbox, message, messager, home, userID, userName, userScore, imageData, correct, wrong, repeat, completeTime, gameID, splayerUsername, splayerID;

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
    home.hidden = YES;
    self.username.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.username.text = self.userName;
    
    self.userimage.layer.masksToBounds = YES;
    self.userimage.layer.cornerRadius = 5.0;
    self.userimage.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
    self.userimage.layer.borderWidth = 1.5;
    
    [self.userimage setImage:[UIImage imageWithData:imageData]];
    
    self.userpoints.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.userpoints.text = [NSString stringWithFormat:@"You completed %@ combinations in %@ seconds", correct, completeTime];
    
    self.messager.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    self.messager.text = [NSString stringWithFormat:@"Write something to %@", splayerUsername];
    
    [self performSelector:@selector(transitionbox) withObject:nil afterDelay:1.5];
}

- (void)viewWillAppear:(BOOL)animated
{
    
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

-(IBAction)submit:(id)sender{
    WebServices *ws = [[WebServices alloc] init];
    
    [ws insertFPlayerDetails:message.text :userID :[completeTime intValue] :[correct intValue] :0 :[wrong intValue] :gameID :userName :[repeat intValue] :splayerID :splayerUsername];
    
    [ws release];
    [GlobalFunction LoadingScreen:self];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
}

-(IBAction)home:(id)sender{
    WebServices *ws = [[WebServices alloc] init];
    
    [ws insertFPlayerDetails:message.text :userID :[completeTime intValue] :[correct intValue] :0 :[wrong intValue] :gameID :userName :[repeat intValue] :splayerID :splayerUsername];
    
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

-(void)transitionbox{
    [dialogbox setBackgroundColor:[UIColor clearColor]];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1.0];
    
    dialogbox.frame = CGRectMake(0, 480, 320, 74);
    [dialogbox setCenter:CGPointMake(160, 433)];
    
    [self.view addSubview:dialogbox];
    
    [UIView commitAnimations];
    home.hidden = NO;
    connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
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
    [userimage release];
    [userpoints release];
    [username release];
    [message release];
    [messager release];
    [home release];
    [super dealloc];
}

@end
