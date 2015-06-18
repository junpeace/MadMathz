//
//  LoginPage.h
//  MadMath
//
//  Created by Jermin Bazazian on 9/10/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GlobalFunction.h"
#import "Toast+UIView.h"

@interface LoginPage : UIViewController{
    
}

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic) BOOL isneedtoplay;

- (IBAction)performLogin:(id)sender;

@end
