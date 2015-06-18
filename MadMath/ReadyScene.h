//
//  ReadyScene.h
//  MadMath
//
//  Created by Zack Loi on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScene.h"
#import "GlobalFunction.h"
#import "LoginPage.h"
#import "WebServices.h"
#import "GamePlay.h"

@interface ReadyScene : UIViewController{
    NSTimer *connectiontimer;
    BOOL isconnected;
    int countdown, countinterrupted;
}

@property (nonatomic) int gamemode;
@property (nonatomic) int gameplayer;
@property (nonatomic) int gameplayid;
@property (nonatomic) int match_id;

@property (retain, nonatomic) IBOutlet UIImageView *tap;
@property (retain, nonatomic) IBOutlet UILabel *lblScore;
@property (retain, nonatomic) IBOutlet UILabel *lblUsername;
@property (retain, nonatomic) IBOutlet UIImageView *imgUser;

@property (nonatomic, retain) IBOutlet UIView *dialogbox;
@property (nonatomic, retain) IBOutlet UILabel *messager;
@property (nonatomic, retain) IBOutlet UILabel *messagername;
@property (retain, nonatomic) NSString *fmessage;

@property (retain, nonatomic) NSString *userID;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userScore;
@property (retain, nonatomic) NSData *imageData;

@property (retain, nonatomic) NSString *splayerID;
@property (retain, nonatomic) NSString *splayerUsername;

@property (retain, nonatomic) NSString *fcorrect;
@property (retain, nonatomic) NSString *fstrWrong;
@property (retain, nonatomic) NSString *fstrRepeat;
@property (retain, nonatomic) NSString *fcompleteTime;

@property (nonatomic) BOOL isshow;

-(IBAction)back:(id)sender;

@end
