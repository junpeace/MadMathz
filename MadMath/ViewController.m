//
//  FirstScene.m
//  MadMath
//
//  Created by Zack Loi on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize title1, title2, title3, title4, title5, title6, title7, title8;
@synthesize titlebg, titlebgshine, credit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(fade1) withObject:nil afterDelay:0.2];
}

-(void)fade1{
    title1.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView animateWithDuration:0.0 animations:^{
        title1.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self fade2];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)fade2{
    title2.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView animateWithDuration:0.0 animations:^{
        title2.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self fade3];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)fade3{
    title3.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView animateWithDuration:0.0 animations:^{
        title3.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self fade4];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)fade4{
    title4.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView animateWithDuration:0.0 animations:^{
        title4.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self fade5];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)fade5{
    title5.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView animateWithDuration:0.0 animations:^{
        title5.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self fade6];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)fade6{
    title6.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView animateWithDuration:0.0 animations:^{
        title6.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self fade7];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)fade7{
    title7.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView animateWithDuration:0.0 animations:^{
        title7.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self fade8];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)fade8{
    title8.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.1];
    
    [UIView animateWithDuration:0.0 animations:^{
        title8.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self fadebg];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)fadebg{
    titlebg.alpha = 0.0f;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [UIView animateWithDuration:0.0 animations:^{
        titlebg.alpha = 1.0f;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self shining];
                             [self transitioncredit];
                         }
                     }];
    
    [UIView commitAnimations];
}

-(void)shining{
    titlebgshine.alpha = 0.5f;
    CALayer *maskLayer = [CALayer layer];
    
    maskLayer.backgroundColor = [[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f] CGColor];
    maskLayer.contents = (id)[[UIImage imageNamed:@"shining.png"] CGImage];
    
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(-titlebgshine.frame.size.width , 
                                 0.0f, 
                                 titlebgshine.frame.size.width * 2, 
                                 titlebgshine.frame.size.height);
    
    
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnim.byValue = [NSNumber numberWithFloat:self.view.frame.size.width * 9];
    maskAnim.repeatCount = 10;
    maskAnim.duration = 3.0f;
    [maskLayer addAnimation:maskAnim forKey:@"shineAnim"];
    
    titlebgshine.layer.mask = maskLayer;
}

-(void)transitioncredit{
    credit.alpha = 1.0f;
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView animateWithDuration:0.0 animations:^{
        CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(-118.0, -66.0);
        CGAffineTransform scale = CGAffineTransformMakeScale(1, 1);
        CGAffineTransform transform =  CGAffineTransformConcat(translate, scale);
        transform = CGAffineTransformConcat(rotate, transform );
        credit.transform = transform;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self alertview];
                         }
                     }];
    [UIView commitAnimations];
}

-(void)alertview{
    alert = [[UIAlertView alloc] initWithTitle:@"Enable Music and Sound?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_box.png"]];
    
    backgroundImageView.frame = CGRectMake(0, 0, 282, 130);
    [alert addSubview:backgroundImageView];
    
    [alert sendSubviewToBack:backgroundImageView];
    [alert show];
    
    UILabel *theTitle = [alert valueForKey:@"_titleLabel"];
    [theTitle setTextColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0]];
    
    UIButton *theButton = [alert valueForKey:@"_buttons"];
    [[theButton objectAtIndex:0] setTitleColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
    [[theButton objectAtIndex:1] setTitleColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if(buttonIndex == 0){
        [alert dismissWithClickedButtonIndex:0 animated:NO];
        [self gotoandplay];
    }else{
        [alert dismissWithClickedButtonIndex:1 animated:NO];
        appDelegate.volume = 1.0;
        appDelegate.ismute = NO;
        [GlobalFunction setvolumebgmusic:appDelegate.volume];
        [self gotoandplay];
    }
}

-(void)gotoandplay
{
    if([GlobalFunction NetworkStatus]){
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:NO];
        if(FBSession.activeSession.isOpen){
            UserProfilePage *GtestClasssViewController=[[[UserProfilePage alloc] initWithNibName:@"UserProfilePage"  bundle:nil] autorelease];
            [self presentModalViewController:GtestClasssViewController animated:YES];
        }else{
            LoginPage *GtestClasssViewController=[[[LoginPage alloc] initWithNibName:@"LoginPage"  bundle:nil] autorelease];
            [self presentModalViewController:GtestClasssViewController animated:YES];
        }
    }else{
        LoginPage *GtestClasssViewController=[[[LoginPage alloc] initWithNibName:@"LoginPage"  bundle:nil] autorelease];
        [self presentModalViewController:GtestClasssViewController animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait)
        return YES;
    else
        return NO;
}

- (void)dealloc {
    [title1 release];
    [title2 release];
    [title3 release];
    [title4 release];
    [title5 release];
    [title6 release];
    [title7 release];
    [title8 release];
    [titlebg release];
    [titlebgshine release];
    [credit release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(fade1) withObject:nil afterDelay:0.2];
}

@end
