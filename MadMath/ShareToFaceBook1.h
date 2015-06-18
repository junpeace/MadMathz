//
//  ShareToFaceBook1.h
//  bazicApp
//
//  Created by Jermin Bazazian on 8/17/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Facebook.h"
#import "GlobalFunction.h"
#import "LoginPage.h"
#import "Toast+UIView.h"

@interface ShareToFaceBook1 : UIViewController<UITextViewDelegate, UIAlertViewDelegate>{
    NSTimer *connectiontimer;
    BOOL isconnected;
    int countdown, countinterrupted;
    UIAlertView *alert;
}

@property (retain, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (retain, nonatomic) IBOutlet UIImageView *postImageView;
@property (retain, nonatomic) IBOutlet UILabel *postNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (retain, nonatomic) IBOutlet UIView *bgview;
@property (retain, nonatomic) NSString *friendID;

- (IBAction)shareButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

@end
