//
//  SingleMatchResultScene.h
//  MadMath
//
//  Created by Zack Loi on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LoginPage.h"
#import "UserProfilePage.h"
#import "GlobalFunction.h"
#import "WebServices.h"

@interface SingleMatchResultScene : UIViewController{
    int score, count;
    SystemSoundID soundeffect;
    
    NSTimer *connectiontimer;
    BOOL isconnected, isstopped;
    int countdown;
}

@property (nonatomic, retain) IBOutlet UILabel *username;
@property (nonatomic, retain) IBOutlet UILabel *userpoints;
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
@property (nonatomic, retain) IBOutlet UIButton *home;

@property (nonatomic) BOOL iswin;

-(IBAction)home:(id)sender;

@property (retain, nonatomic) NSString *userID;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userScore;
@property (retain, nonatomic) NSData *imageData;

@property (strong, nonatomic) NSMutableDictionary *postParams;

@end
