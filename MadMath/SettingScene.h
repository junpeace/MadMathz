//
//  SettingScene.h
//  MadMath
//
//  Created by Jermin Bazazian on 9/18/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Facebook.h"
#import "AppDelegate.h"

@interface SettingScene : UIViewController<UIAlertViewDelegate>{
    NSTimer *timer;
    BOOL ischange;
    float currentvolume, aftervolume;
    int countinterrupted;
    UIAlertView *alert;
}

@property (nonatomic, retain) IBOutlet UISlider *bgmusicslider;
@property (nonatomic, retain) IBOutlet UISwitch *soundswitch;

-(IBAction)logoutButtonWasPressed:(id)sender;
-(IBAction)back:(id)sender;

@end
