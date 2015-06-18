//
//  AppDelegate.m
//  MadMath
//
//  Created by Zack Loi on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

NSString *const SCSessionStateChangedNotification = @"com.facebook.MadMathz:SCSessionStateChangedNotification";

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize loginViewController = _loginViewController;
@synthesize tokendevice, ispause, isquit, isvalid, ismute, volume;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.volume = 0.0;
    self.ismute = YES;
    [GlobalFunction playbgmusic:@"bgmusic":@"mp3":-1];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    NSDictionary *tmpDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
    if (tmpDic != nil) {
        [self openSessionWithAllowLoginUI:NO];
        UserProfilePage *GtestClasssViewController=[[[UserProfilePage alloc] initWithNibName:@"UserProfilePage"  bundle:nil] autorelease];
        self.window.rootViewController = GtestClasssViewController;
        
    }else{
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
        self.window.rootViewController = self.viewController;
    }
    
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    CTCallCenter *ctCallCenter = [[[CTCallCenter alloc] init] autorelease];
    if (ctCallCenter.currentCalls != nil)
    {
        self.ispause = YES;
    }else{
        self.ispause = YES;
        self.isvalid = YES;
        //isneed = YES;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [FBSession.activeSession close]; 
    }
    
    if(isneed)
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.1];
    isneed = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *temp = [NSString stringWithFormat:@"%@", deviceToken];
    temp = [temp stringByReplacingOccurrencesOfString:@"<" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@">" withString:@""];
    self.tokendevice = temp;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplicationState state = [application applicationState];
    
    if (!state == UIApplicationStateActive)
    {
        for(UIView *uiview in self.window.subviews)
            [uiview removeFromSuperview];
        self.volume = 0.5;
        [GlobalFunction playbgmusic:@"bgmusic":@"mp3":-1];
        UserProfilePage *GtestClasssViewController=[[[UserProfilePage alloc] initWithNibName:@"UserProfilePage"  bundle:nil] autorelease];
        self.window.rootViewController = GtestClasssViewController;
    }
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) 
    {
        case FBSessionStateOpen: 
        {    
            for(UIView *uiview in self.window.subviews)
                [uiview removeFromSuperview];
            UserProfilePage *GtestClasssViewController=[[[UserProfilePage alloc] initWithNibName:@"UserProfilePage"  bundle:nil] autorelease];
            self.window.rootViewController = GtestClasssViewController;
            break;
        }
            
        case FBSessionStateClosed:
            
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            LoginPage *GtestClasssViewController=[[[LoginPage alloc] initWithNibName:@"LoginPage"  bundle:nil] autorelease];
            self.window.rootViewController = GtestClasssViewController;
            break;
        }
        default:
            break;
    }
    
    //send the notification whenever the session state changes 
    [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification object:session];
    
    if (error) 
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI 
{
    //permission required to post/retrieve information on user behalf
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", @"user_photos", @"publish_stream", @"email", nil];
    
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                         [self sessionStateChanged:session state:state error:error];
                                     }];    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation 
{
    // We need to handle URLs by passing them to FBSession in order for SSO authentication to work.
    return [FBSession.activeSession handleOpenURL:url]; 
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    
}

-(void)delay{
    self.isquit = YES;
}

@end
