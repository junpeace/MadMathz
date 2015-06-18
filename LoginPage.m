//
//  LoginPage.m
//  MadMath
//
//  Created by Jermin Bazazian on 9/10/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import "LoginPage.h"

@implementation LoginPage

@synthesize loginButton = _loginButton;
@synthesize isneedtoplay;

- (IBAction)performLogin:(id)sender 
{
    if([GlobalFunction NetworkStatus]){
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate openSessionWithAllowLoginUI:YES];
    }else{
       [self.view makeToast:@"Please connect to internet!" duration:(0.3) position:@"center"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];  
    if(self.isneedtoplay)
        [GlobalFunction playbgmusic:@"bgmusic":@"mp3":-1];
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

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

@end
