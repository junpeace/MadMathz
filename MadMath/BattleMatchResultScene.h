//
//  BattleMatchResultScene.h
//  MadMath
//
//  Created by Zack Loi on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LoginPage.h"
#import "UserProfilePage.h"
#import "GlobalFunction.h"

@interface BattleMatchResultScene : UIViewController<UITextViewDelegate>{
    int count;
    SystemSoundID soundeffect;
    
    NSTimer *connectiontimer;
    BOOL isconnected, isstopped;
    int countdown;
}

@property (nonatomic, retain) IBOutlet UIView *result;
@property (nonatomic, retain) IBOutlet UIView *dialogbox;
@property (nonatomic, retain) IBOutlet UIImageView *userimage;
@property (nonatomic, retain) IBOutlet UIImageView *character;
@property (nonatomic, retain) IBOutlet UIImageView *star;
@property (nonatomic, retain) IBOutlet UIImageView *star2;
@property (nonatomic, retain) IBOutlet UIImageView *star3;
@property (nonatomic, retain) IBOutlet UIImageView *star4;
@property (nonatomic, retain) IBOutlet UIImageView *star5;
@property (nonatomic, retain) IBOutlet UIImageView *star6;
@property (nonatomic, retain) IBOutlet UIImageView *lightning;
@property (nonatomic, retain) IBOutlet UIImageView *shadow;
@property (nonatomic, retain) IBOutlet UILabel *username;
@property (nonatomic, retain) IBOutlet UILabel *userpoints;

@property (nonatomic, retain) IBOutlet UILabel *fcompleted;
@property (nonatomic, retain) IBOutlet UILabel *fwrong;
@property (nonatomic, retain) IBOutlet UILabel *frepeat;
@property (nonatomic, retain) IBOutlet UILabel *ftime;
@property (nonatomic, retain) IBOutlet UIImageView *fimage;
@property (nonatomic, retain) IBOutlet UILabel *scompleted;
@property (nonatomic, retain) IBOutlet UILabel *swrong;
@property (nonatomic, retain) IBOutlet UILabel *srepeat;
@property (nonatomic, retain) IBOutlet UILabel *stime;
@property (nonatomic, retain) IBOutlet UIImageView *simage;
@property (nonatomic, retain) IBOutlet UILabel *completed;
@property (nonatomic, retain) IBOutlet UILabel *repeat;
@property (nonatomic, retain) IBOutlet UILabel *wrong;
@property (nonatomic, retain) IBOutlet UILabel *time;

@property (nonatomic, retain) IBOutlet UILabel *messager;
@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) IBOutlet UIButton *home;

@property (nonatomic) BOOL iswin;

-(IBAction)submit:(id)sender;
-(IBAction)home:(id)sender;

@property (retain, nonatomic) NSString *userID;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userScore;
@property (retain, nonatomic) NSData *imageData;

@property (retain, nonatomic) NSString *correct;
@property (retain, nonatomic) NSString *strWrong;
@property (retain, nonatomic) NSString *strRepeat;
@property (retain, nonatomic) NSString *completeTime;

@property (retain, nonatomic) NSString *fcorrect;
@property (retain, nonatomic) NSString *fstrWrong;
@property (retain, nonatomic) NSString *fstrRepeat;
@property (retain, nonatomic) NSString *fcompleteTime;
@property (retain, nonatomic) NSData *fimagedata;

@property (retain, nonatomic) NSString *splayerUsername;
@property (retain, nonatomic) NSString *splayerID;

@property (nonatomic) int match_id;

@property (strong, nonatomic) NSMutableDictionary *postParams;

@end
