//
//  UserProfilePage.h
//  MadMath
//
//  Created by Jermin Bazazian on 9/10/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "AppDelegate.h"
#import "LoginPage.h"
#import "WebServices.h"
#import "FacebookFriendList.h"
#import "ReadyScene.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalFunction.h"
#import "LoginPage.h"
#import "SettingScene.h"
#import "Toast+UIView.h"

@interface UserProfilePage : UIViewController<UITableViewDataSource, FBDialogDelegate, FBRequestDelegate, UITableViewDelegate>
{
    NSTimer *connectiontimer, *Timer, *refreshTimer;
    BOOL isconnected;
    int countdown, countinterrupted;
}

@property (retain, nonatomic) IBOutlet UIScrollView *svController;
@property (retain, nonatomic) IBOutlet UITableView *tblChallenge;
@property (retain, nonatomic) IBOutlet UITableView *tblResult;
@property (retain, nonatomic) IBOutlet UILabel *lblScore;
@property (retain, nonatomic) IBOutlet UIImageView *imgUser;
@property (retain, nonatomic) IBOutlet UILabel *lblWelcome;

@property (retain, nonatomic) NSString *userScore;
@property (strong, nonatomic) NSArray *fbfriendlist;
@property (strong, nonatomic) NSArray *userList;
@property (strong, nonatomic) NSMutableArray *matchedUser;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSArray *challengeResult;
@property (strong, nonatomic) NSArray *challengeList;

@property (nonatomic) BOOL isneedtoplay;

-(IBAction)singleplayergame:(id)sender;
-(IBAction)functionTappedOwn:(id)sender;
-(IBAction)setting:(id)sender;

@end