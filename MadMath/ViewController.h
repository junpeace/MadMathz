//
//  FirstScene.h
//  MadMath
//
//  Created by Zack Loi on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserProfilePage.h"
#import "LoginPage.h"
#import "GlobalFunction.h"

extern NSString *const SCSessionStateChangedNotification;

@interface ViewController : UIViewController<FBUserSettingsDelegate, UIAlertViewDelegate>{
    UIAlertView *alert;
}

@property (nonatomic, retain) IBOutlet UIImageView *title1;
@property (nonatomic, retain) IBOutlet UIImageView *title2;
@property (nonatomic, retain) IBOutlet UIImageView *title3;
@property (nonatomic, retain) IBOutlet UIImageView *title4;
@property (nonatomic, retain) IBOutlet UIImageView *title5;
@property (nonatomic, retain) IBOutlet UIImageView *title6;
@property (nonatomic, retain) IBOutlet UIImageView *title7;
@property (nonatomic, retain) IBOutlet UIImageView *title8;

@property (nonatomic, retain) IBOutlet UIImageView *titlebg;
@property (nonatomic, retain) IBOutlet UIImageView *titlebgshine;
@property (nonatomic, retain) IBOutlet UIImageView *credit;

@end
