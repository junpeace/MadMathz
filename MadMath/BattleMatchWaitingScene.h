//
//  BattleMatchWaitingScene.h
//  MadMath
//
//  Created by Zack Loi on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LoginPage.h"
#import "UserProfilePage.h"
#import "GlobalFunction.h"

@interface BattleMatchWaitingScene : UIViewController<UITextViewDelegate>{
    NSTimer *connectiontimer;
    BOOL isconnected, isstopped;
    int countdown;
}

@property (nonatomic, retain) IBOutlet UILabel *username;
@property (nonatomic, retain) IBOutlet UILabel *userpoints;
@property (nonatomic, retain) IBOutlet UIImageView *userimage;

@property (nonatomic, retain) IBOutlet UIView *dialogbox;
@property (nonatomic, retain) IBOutlet UILabel *messager;
@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) IBOutlet UIButton *home;

-(IBAction)submit:(id)sender;
-(IBAction)home:(id)sender;

@property (nonatomic) int gameID;

@property (retain, nonatomic) NSString *userID;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userScore;
@property (retain, nonatomic) NSData *imageData;
@property (retain, nonatomic) NSString *correct;
@property (retain, nonatomic) NSString *wrong;
@property (retain, nonatomic) NSString *repeat;
@property (retain, nonatomic) NSString *completeTime;

@property (retain, nonatomic) NSString *splayerID;
@property (retain, nonatomic) NSString *splayerUsername;

@end
