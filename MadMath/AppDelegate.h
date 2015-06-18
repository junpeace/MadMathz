//
//  AppDelegate.h
//  MadMath
//
//  Created by Zack Loi on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>    
#import <CoreTelephony/CTCall.h>   
#import <CoreTelephony/CTCarrier.h>    
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "ViewController.h"
#import "LoginPage.h"
#import "Facebook.h"
#import "UserProfilePage.h"
#import "GlobalFunction.h"
#import "GameScene.h"

extern NSString *const SCSessionStateChangedNotification;

@class ViewController;
@class LoginPage;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *alertMsg;
    BOOL isneed;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginPage *loginViewController;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSString *tokendevice;

@property ( nonatomic) float volume;

@property (nonatomic) BOOL ispause;
@property (nonatomic) BOOL isquit;
@property (nonatomic) BOOL isvalid;
@property (nonatomic) BOOL ismute;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
