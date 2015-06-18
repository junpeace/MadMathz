//
//  SettingScene.m
//  MadMath
//
//  Created by Jermin Bazazian on 9/18/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import "SettingScene.h"

@implementation SettingScene

@synthesize bgmusicslider, soundswitch;

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_default.png"]]];
    ischange = NO;
    countinterrupted = 0;
    bgmusicslider.value = [GlobalFunction getvolumebgmusic];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if(appDelegate.ismute)
        [soundswitch setOn:NO animated:YES];
    else
        [soundswitch setOn:YES animated:YES];
    timer = [NSTimer scheduledTimerWithTimeInterval:(0.5) target:self selector:@selector(musicvalue) userInfo:nil repeats:YES];
}

-(void)musicvalue{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.volume = bgmusicslider.value;
    [GlobalFunction setvolumebgmusic:bgmusicslider.value];
    
    if(soundswitch.on)
        appDelegate.ismute = NO;
    else
        appDelegate.ismute = YES;
    
    if(![GlobalFunction isplay]){
        ++countinterrupted;
        if(countinterrupted < 4)
            [GlobalFunction resumebgmusic];
        else if(countinterrupted == 4)
            [self.view makeToast:@"Background Music has been interrupted." duration:(0.5) position:@"center"];
    }
}

-(IBAction)logoutButtonWasPressed:(id)sender
{
    [self alertview];
}

-(IBAction)back:(id)sender{
    [timer invalidate];
    [super dismissModalViewControllerAnimated:YES];
}

-(void)alertview{
    alert = [[UIAlertView alloc] initWithTitle:@"Sign Out From Facebook?" message:@"Are You Sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_box.png"]];
    
    backgroundImageView.frame = CGRectMake(0, 0, 282, 135);
    [alert addSubview:backgroundImageView];
    
    [alert sendSubviewToBack:backgroundImageView];
    [alert show];
    
    UILabel *theTitle = [alert valueForKey:@"_titleLabel"];
    [theTitle setTextColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0]];
    
    UILabel *theBody = [alert valueForKey:@"_bodyTextLabel"];
    [theBody setTextColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0]];

    UIButton *theButton = [alert valueForKey:@"_buttons"];
    [[theButton objectAtIndex:0] setTitleColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
    [[theButton objectAtIndex:1] setTitleColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }else{
        [alert dismissWithClickedButtonIndex:1 animated:NO];
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else
        return NO;
}

-(void)dealloc{
    [bgmusicslider release];
    [soundswitch release];
    [super dealloc];
}

@end
