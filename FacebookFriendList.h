//
//  FacebookFriendList.h
//  MadMath
//
//  Created by Jermin Bazazian on 9/11/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ReadyScene.h"
#import "GlobalFunction.h"
#import "LoginPage.h"
#import "ShareToFaceBook1.h"

@interface FacebookFriendList : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSTimer *connectiontimer, *timer;
    BOOL isconnected;
    int countdown, countinterrupted;
}

@property (retain, nonatomic) IBOutlet UITableView *tblfb;
@property (retain, nonatomic) NSArray *arr;
@property (retain, nonatomic) NSMutableArray *matchedUser;

@property (retain, nonatomic) NSString *userID;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *userScore;
@property (retain, nonatomic) NSData *imageData;

-(IBAction)back:(id)sender;

@end
