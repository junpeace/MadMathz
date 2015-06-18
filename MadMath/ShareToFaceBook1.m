//
//  ShareToFaceBook1.m
//  bazicApp
//
//  Created by Jermin Bazazian on 8/17/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import "ShareToFaceBook1.h"

NSString *const kPlaceholderPostMessage = @"Say something about this...";

@implementation ShareToFaceBook1

@synthesize postMessageTextView;
@synthesize postImageView;
@synthesize postNameLabel;
@synthesize postCaptionLabel;
@synthesize postDescriptionLabel;
@synthesize friendID;
@synthesize bgview;

@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;

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
    countinterrupted = 0;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    [self.bgview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    [[postMessageTextView layer] setBorderWidth:1];
    [[postMessageTextView layer] setCornerRadius:5];
    postMessageTextView.enablesReturnKeyAutomatically = NO;
    
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"www.squarefresco.com", @"link", @"MadMathz", @"name", @"www.squarefresco.com", @"caption", @"This game will test your basic mathematic. You will be given a set of numbers and provided with answer then you need to find combination of number to match the answer within ONE minute. It is either you are loser or winner.", @"description", nil];
    
    [self resetPostMessage];
    
    self.postNameLabel.text = [self.postParams objectForKey:@"name"];
    self.postCaptionLabel.text = [self.postParams
                                  objectForKey:@"caption"];
    [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = [self.postParams
                                      objectForKey:@"description"];
    [self.postDescriptionLabel sizeToFit];
    
    connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [connectiontimer invalidate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    if (self.imageConnection) {
        [self.imageConnection cancel];
        self.imageConnection = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortrait)
        return YES;
    else
        return NO;
}

-(void)checkingconnection{
    if([GlobalFunction NetworkStatus] && !isconnected){
        [GlobalFunction RemovingScreen:self];
        countdown = 0;
        isconnected = YES;
    }else if(![GlobalFunction NetworkStatus] && isconnected){
        [GlobalFunction LoadingScreen:self];
        isconnected = NO;
    }else if(![GlobalFunction NetworkStatus] && !isconnected){
        countdown++;
        if(countdown > 1200){
            LoginPage *GtestClasssViewController=[[[LoginPage alloc] initWithNibName:@"LoginPage"  bundle:nil] autorelease];
            [self presentModalViewController:GtestClasssViewController animated:YES];
        }
    }
    
    if(![GlobalFunction isplay]){
        ++countinterrupted;
        if(countinterrupted < 4)
            [GlobalFunction resumebgmusic];
        else if(countinterrupted == 4)
            [self.view makeToast:@"Background Music has been interrupted." duration:(0.5) position:@"center"];
    }
}

- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [postMessageTextView resignFirstResponder];
    
    postMessageTextView.text = [postMessageTextView.text capitalizedString];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.postImageView.image = [UIImage imageWithData:
                                [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)shareButtonAction:(id)sender
{
    [GlobalFunction LoadingScreen:self];
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder])
    {
        [self.postMessageTextView resignFirstResponder];
    }
    
    // Add user message parameter if user filled it in
    if (![self.postMessageTextView.text isEqualToString:kPlaceholderPostMessage] && ![self.postMessageTextView.text isEqualToString:@""])
    {
        [self.postParams setObject:self.postMessageTextView.text forKey:@"message"];
    }
    
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/feed", self.friendID] parameters:self.postParams HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         [GlobalFunction RemovingScreen:self];
         NSString *alertText;
         
         if (error) {
             alertText = @"Failed To Share To Your Friend's Wall Because She Or He Has Disabled User To Post On Wall!";
         } else {
             alertText = @"Successfully Shared To Your Friend's Wall!";
         }
         
         alert = [[UIAlertView alloc] initWithTitle:@"" message:alertText delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
         UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_box.png"]];
         
         backgroundImageView.frame = CGRectMake(0, 0, 282, 150);
         [alert addSubview:backgroundImageView];
         
         [alert sendSubviewToBack:backgroundImageView];
         [alert show];
         
         UILabel *theBody = [alert valueForKey:@"_bodyTextLabel"];
         [theBody setTextColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0]];
         
         UIButton *theButton = [alert valueForKey:@"_buttons"];
         [[theButton objectAtIndex:0] setTitleColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
         
         [alert release];
     }];
}

- (IBAction)cancelButtonAction:(id)sender {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [postMessageTextView release];
    [postImageView release];
    [postNameLabel release];
    [postCaptionLabel release];
    [postDescriptionLabel release];
    [bgview release];
    [super dealloc];
}

@end
