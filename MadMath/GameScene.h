//
//  GameScene.h
//  MadMath
//
//  Created by Zack Loi on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SingleMatchResultScene.h"
#import "BattleMatchResultScene.h"
#import "BattleMatchWaitingScene.h"
#import "GlobalFunction.h"
#import "LoginPage.h"
#import "AppDelegate.h"
#import "UserProfilePage.h"

@interface GameScene : UIViewController{
    NSTimer *timer;
    NSMutableArray *ischose, *isrepeat;
    BOOL isbegan, isended, isoutofbound, isreverse;
    int correct, repeat, wrong, currentposition;
    SystemSoundID soundeffect;
    
    CGAffineTransform star1Initial,star2Initial,star3Initial,star4Initial,star5Initial,star6Initial;
    
    NSTimer *connectiontimer;
    BOOL isconnected, isstopped;
    int countdown;
    
    BOOL ispause;
}

@property (nonatomic, retain) IBOutlet UIImageView *image1;
@property (nonatomic, retain) IBOutlet UIImageView *image2;
@property (nonatomic, retain) IBOutlet UIImageView *image3;
@property (nonatomic, retain) IBOutlet UIImageView *image4;
@property (nonatomic, retain) IBOutlet UIImageView *image5;
@property (nonatomic, retain) IBOutlet UIImageView *image6;
@property (nonatomic, retain) IBOutlet UIImageView *image7;
@property (nonatomic, retain) IBOutlet UIImageView *image8;
@property (nonatomic, retain) IBOutlet UIImageView *image9;
@property (nonatomic, retain) IBOutlet UIImageView *image10;
@property (nonatomic, retain) IBOutlet UIImageView *image11;
@property (nonatomic, retain) IBOutlet UIImageView *image12;
@property (nonatomic, retain) IBOutlet UIImageView *image13;
@property (nonatomic, retain) IBOutlet UIImageView *image14;
@property (nonatomic, retain) IBOutlet UIImageView *image15;
@property (nonatomic, retain) IBOutlet UIImageView *image16;

@property (nonatomic, retain) IBOutlet UIImageView *star;
@property (nonatomic, retain) IBOutlet UIImageView *star2;
@property (nonatomic, retain) IBOutlet UIImageView *star3;
@property (nonatomic, retain) IBOutlet UIImageView *star4;
@property (nonatomic, retain) IBOutlet UIImageView *star5;
@property (nonatomic, retain) IBOutlet UIImageView *star6;

@property (nonatomic, retain) IBOutlet UILabel *answer;
@property (nonatomic, retain) IBOutlet UILabel *posibility;
@property (nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) IBOutlet UILabel *completed;
@property (nonatomic, retain) IBOutlet UILabel *username;
@property (nonatomic, retain) IBOutlet UILabel *userpoints;
@property (nonatomic, retain) IBOutlet UIImageView *userimage;
@property (nonatomic, retain) IBOutlet UIImageView *resulttext;


@property (nonatomic) int gamemode;
@property (nonatomic) int gameplayer;
@property (nonatomic) int positionvalue;
@property (nonatomic) int currentanswer;
@property (nonatomic) int gameID;
@property (nonatomic) int match_id;

@property (retain, nonatomic) NSString *userID;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userScore;
@property (retain, nonatomic) NSData *imageData;
@property (retain, nonatomic) NSString *allimagenumbers;
@property (retain, nonatomic) NSString *anws;
@property (retain, nonatomic) NSString *totalPoss;

@property (retain, nonatomic) NSString *splayerID;
@property (retain, nonatomic) NSString *splayerUsername;

@property (retain, nonatomic) NSString *fcorrect;
@property (retain, nonatomic) NSString *fstrWrong;
@property (retain, nonatomic) NSString *fstrRepeat;
@property (retain, nonatomic) NSString *fcompleteTime;
@property (retain, nonatomic) NSData *fimagedata;

@end
