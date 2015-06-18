//
//  UserProfilePage.m
//  MadMath
//
//  Created by Jermin Bazazian on 9/10/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import "UserProfilePage.h"

@implementation UserProfilePage

@synthesize svController;
@synthesize tblChallenge;
@synthesize tblResult;
@synthesize userScore;
@synthesize lblScore;
@synthesize imgUser;
@synthesize fbfriendlist = _fbfriendlist;
@synthesize userList = _userList;
@synthesize matchedUser = _matchedUser;
@synthesize userID;
@synthesize userName;
@synthesize imageData;
@synthesize lblWelcome;
@synthesize challengeResult;
@synthesize challengeList;
@synthesize isneedtoplay;

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
    if(self.isneedtoplay)
        [GlobalFunction playbgmusic:@"bgmusic":@"mp3":-1];
    
    self.tblChallenge.hidden = YES;
    self.tblResult.hidden = YES;
    
    [GlobalFunction LoadingScreen:self];
    isconnected = YES;
    
    [self.svController setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_default.png"]]];
    
    self.imgUser.layer.masksToBounds = YES;
    self.imgUser.layer.cornerRadius = 5.0;
    self.imgUser.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
    self.imgUser.layer.borderWidth = 1.5;
    
    userID = [[NSString alloc] init];
    userName = [[NSString alloc] init];
    userScore = [[NSString alloc] init];
    
    self.lblWelcome.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.5];
}

- (void)viewWillAppear:(BOOL)animated
{
    countinterrupted = 0;
    [self performSelector:@selector(delay2) withObject:nil afterDelay:0.2];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [Timer invalidate];
    [refreshTimer invalidate];
    [connectiontimer invalidate];
}

-(void)delay2{
    Timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadtable) userInfo:nil repeats:YES];
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(retrieveResult) userInfo:nil repeats:YES];
    connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
}

-(void)delay{
    if([GlobalFunction NetworkStatus]){
        if (FBSession.activeSession.isOpen) 
        {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) 
             {
                 if (!error) 
                 {
                     userID = [[userID stringByAppendingString:[NSString stringWithFormat:@"%@",user.id]] retain];
                     
                     userName = [[userName stringByAppendingString: [NSString stringWithFormat:@"%@",user.name]]retain];
                     
                     NSString *strurl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", userID];
                     
                     NSURL *url = [NSURL URLWithString:strurl];
                     
                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                         
                         imageData = [[NSData dataWithContentsOfURL:url] retain];
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             WebServices *ws2 = [[WebServices alloc] init];
                             
                             userScore = [[ws2 selectUserScoreByFBID:userID] retain];
                             
                             AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                             
                             //check if new user
                             if([userScore isEqualToString:@""])
                             {
                                 NSArray *personalInfo = [NSArray arrayWithObjects:user.first_name, user.last_name, [user objectForKey:@"gender"], [user objectForKey:@"email"], user.name, userID, appDelegate.tokendevice, nil];
                                 
                                 [ws2 insertNewUser:personalInfo];
                                 
                                 self.svController.contentSize = CGSizeMake(320, 480);
                                 
                                 userScore = @"0";
                             }
                             else
                             {
                                 [ws2 updateUserPushToken:appDelegate.tokendevice :userID];
                             }
                             
                             NSString *formatScore = [NSString stringWithFormat:@"You have %@ points", userScore]; 
                             
                             self.lblScore.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
                             self.lblScore.text = formatScore;
                             
                             [ws2 release];
                             
                             [self.imgUser setImage:[UIImage imageWithData:imageData]];
                             
                             challengeResult = [[ws2 selectChallengeResultByFBID:userID] retain];
                             
                             challengeList = [[ws2 selectChallengeByFBID:userID] retain];
                                                          
                             [GlobalFunction RemovingScreen:self];
                             
                             if(challengeList.count > 0){
                                 self.tblChallenge.hidden = NO;
                                 self.tblChallenge.frame = CGRectMake(15, 258, 290, 51 + 72 * challengeList.count);
                                 if(challengeResult.count != 0){
                                     self.tblResult.hidden = NO;
                                     self.tblResult.frame = CGRectMake(15, 72 * challengeList.count + 319, 290, 51 + 72 * challengeResult.count);
                                     self.svController.contentSize = CGSizeMake(320, 51 * 2 + 72 * (challengeList.count + challengeResult.count) + 278);
                                 }
                                 else{
                                     self.svController.contentSize = CGSizeMake(320, 51 + 72 * challengeList.count + 268);
                                 }
                             }else{
                                 if(challengeResult.count > 0){
                                     self.tblResult.hidden = NO;
                                     self.tblResult.frame = CGRectMake(15, 258, 290, 51 + 72 * challengeResult.count);
                                     self.svController.contentSize = CGSizeMake(320, 51 + 72 * (challengeList.count + challengeResult.count) + 268);
                                 }
                                 else{
                                     self.svController.contentSize = CGSizeMake(320, 258);
                                 }
                             }
                             
                             self.tblResult.scrollEnabled = NO;
                             self.tblChallenge.scrollEnabled = NO;
                             [tblChallenge reloadData];
                             [tblResult reloadData];
                             
                             if(![GlobalFunction isplay])
                                 [self.view makeToast:@"Background Music has been interrupted." duration:(0.5) position:@"center"];
                         });
                     });
                 }
             }];
        }
        
        WebServices *ws = [[WebServices alloc] init];
        _userList = [[ws selectAllUserFBIDAndScore] retain];
        _matchedUser = [[NSMutableArray alloc] init];
        
        [ws release];
    }
}

-(void)checkingconnection{
    if([GlobalFunction NetworkStatus] && !isconnected){
        [GlobalFunction RemovingScreen:self];
        countdown = 0;
        isconnected = YES;
        Timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadtable) userInfo:nil repeats:YES];
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(retrieveResult) userInfo:nil repeats:YES];
    }else if(![GlobalFunction NetworkStatus] && isconnected){
        [GlobalFunction LoadingScreen:self];
        isconnected = NO;
        [Timer invalidate];
        [refreshTimer invalidate];
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
    }
}

-(IBAction)setting:(id)sender{
    SettingScene *GtestClasssViewController=[[[SettingScene alloc] initWithNibName:@"SettingScene"  bundle:nil] autorelease];
    [self presentModalViewController:GtestClasssViewController animated:YES];
}

-(IBAction)functionTappedOwn:(id)sender
{
    [GlobalFunction LoadingScreen:self];
    [sender setUserInteractionEnabled:NO];
    
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) 
         {
             
             if (!error) 
             {
                 [GlobalFunction RemovingScreen:self];
                 //sort the friendlist
                 NSArray *sortItem = [[(NSDictionary*) user objectForKey:@"data"] retain];
                 BOOL notExist = true;
                 
                 _fbfriendlist = [sortItem sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
                 
                 for(int i = 0; i < [_fbfriendlist count]; i++)
                 {
                     NSDictionary *friend = [_fbfriendlist objectAtIndex:i];
                     
                     for(int j = 0; j < [_userList count]; j++)
                     {
                         NSDictionary* usinfo = [_userList objectAtIndex:j];
                         
                         NSDictionary* usdetails = [usinfo objectForKey:@"user"];
                         
                         if([[friend objectForKey:@"id"] isEqualToString:[usdetails objectForKey:@"fb_id"]])
                         {
                             NSString *strTemp = [NSString stringWithFormat:@"%@%@", [usdetails objectForKey:@"score"], @" points"];
                             
                             [_matchedUser addObject:strTemp];
                             notExist = false;
                             break;
                         }
                     }
                     
                     if(notExist)
                     {
                         [_matchedUser addObject:@""];
                     }
                     else 
                     {
                         notExist = true;
                     }
                 }
                 
             }
             [sender setUserInteractionEnabled:YES];
             
             FacebookFriendList *ffl = [[FacebookFriendList alloc] initWithNibName:@"FacebookFriendList" bundle:nil];
             
             ffl.arr = _fbfriendlist;
             ffl.matchedUser = _matchedUser;
             ffl.userScore = userScore;
             ffl.userID = userID;
             ffl.imageData = imageData;
             ffl.userName = userName;
             [self presentModalViewController:ffl animated:YES];
         }];   
    }
}

-(IBAction)singleplayergame:(id)sender
{
    
    ReadyScene *GtestClasssViewController=[[[ReadyScene alloc] initWithNibName:@"ReadyScene"  bundle:nil] autorelease];
    GtestClasssViewController.gamemode = 1;
    GtestClasssViewController.userName = userName;
    GtestClasssViewController.userScore = userScore;
    GtestClasssViewController.userID = userID;
    GtestClasssViewController.imageData = imageData;
    
    [self presentModalViewController:GtestClasssViewController animated:YES];
}

-(IBAction)acceptChallenge: (id)sender
{
    //[connectiontimer invalidate];
    
    ReadyScene *GtestClasssViewController=[[[ReadyScene alloc] initWithNibName:@"ReadyScene"  bundle:nil] autorelease];
    GtestClasssViewController.gamemode = 2;
    GtestClasssViewController.gameplayer = 2;
    GtestClasssViewController.userName = userName;
    GtestClasssViewController.userScore = userScore;
    GtestClasssViewController.userID = userID;
    GtestClasssViewController.imageData = imageData;
    
    //pass the gameplay_id as well
    NSDictionary* usinfo = [self.challengeList objectAtIndex:[sender tag]];
    NSDictionary* usdetails = [usinfo objectForKey:@"user"];
    
    GtestClasssViewController.gameplayid = [[usdetails objectForKey:@"gameplay_id"] intValue];
    
    //pass fplayer combo, repeat, wrong, time
    GtestClasssViewController.fstrWrong = [usdetails objectForKey:@"fplayer_wrong_tried"];
    GtestClasssViewController.fstrRepeat = [usdetails objectForKey:@"fplayer_repeat"];
    GtestClasssViewController.fcorrect = [usdetails objectForKey:@"fplayer_comp_poss"];
    GtestClasssViewController.fcompleteTime = [usdetails objectForKey:@"fplayer_comp_time"];
    GtestClasssViewController.splayerID = [usdetails objectForKey:@"fplayer_id"];
    GtestClasssViewController.splayerUsername = [usdetails objectForKey:@"fplayer_username"];
    GtestClasssViewController.match_id = [[usdetails objectForKey:@"match_id"] intValue];
    GtestClasssViewController.fmessage = [usdetails objectForKey:@"fplayer_msg"];
    
    GtestClasssViewController.isshow = YES;
    
    [self presentModalViewController:GtestClasssViewController animated:YES];
}

-(IBAction)reChallenge: (id)sender
{
    //[connectiontimer invalidate];
    
    ReadyScene *GtestClasssViewController=[[[ReadyScene alloc] initWithNibName:@"ReadyScene"  bundle:nil] autorelease];
    GtestClasssViewController.gamemode = 2;
    GtestClasssViewController.gameplayer = 1;
    GtestClasssViewController.userName = userName;
    GtestClasssViewController.userScore = userScore;
    GtestClasssViewController.userID = userID;
    GtestClasssViewController.imageData = imageData;
    
    NSDictionary* usinfo = [self.challengeResult objectAtIndex:[sender tag]];
    NSDictionary* usdetails = [usinfo objectForKey:@"user"];
    
    if([[usdetails objectForKey:@"fplayer_id"] isEqualToString:userID])
    {
        GtestClasssViewController.splayerID = [usdetails objectForKey:@"splayer_id"];
        GtestClasssViewController.splayerUsername = [usdetails objectForKey:@"splayer_username"];
    }
    else 
    {
        GtestClasssViewController.splayerID = [usdetails objectForKey:@"fplayer_id"];
        GtestClasssViewController.splayerUsername = [usdetails objectForKey:@"fplayer_username"];
    }
    
    [self presentModalViewController:GtestClasssViewController animated:YES];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else
        return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if(tableView == tblResult)
    {
        return challengeResult.count;
    }
    else 
    {
        return challengeList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    tableView.layer.borderWidth = 2.5;
    tableView.layer.cornerRadius = 10;
    tableView.layer.borderColor = [UIColor colorWithRed:0.3960 green:0.2627 blue:0.1294 alpha:1.0].CGColor;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tableView setSeparatorColor:[UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0]];
    
    static NSString *CellIdentifier = @"Cell";
    NSString* tempID = @"";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //textLabel properties
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.clipsToBounds = YES;
        
        UILabel *lblTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, 3, 115, 21)];
        
        lblTextLabel.font = [UIFont boldSystemFontOfSize:14];
        lblTextLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
        lblTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        lblTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        lblTextLabel.clipsToBounds = YES;
        lblTextLabel.text = @"this is label text";
        
        if(tableView == tblResult)
        {
            if(challengeResult != nil || [challengeResult count] != 0)
            {
                UILabel *lblDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, 19, 122, 21)];
                
                lblDetailTextLabel.font = [UIFont systemFontOfSize:11];
                lblDetailTextLabel.textColor = [UIColor redColor];
                lblDetailTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                lblDetailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
                lblDetailTextLabel.clipsToBounds = YES;
                
                UILabel *lblFeedback = [[UILabel alloc] initWithFrame:CGRectMake(66, 37, 122, 32)];
                
                lblFeedback.font = [UIFont systemFontOfSize:11];
                lblFeedback.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
                lblFeedback.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                lblFeedback.lineBreakMode = UILineBreakModeWordWrap;
                lblFeedback.numberOfLines = 0;
                lblFeedback.clipsToBounds = YES;
                
                NSDictionary* usinfo = [challengeResult objectAtIndex:indexPath.row];
                
                NSDictionary* usdetails = [usinfo objectForKey:@"user"];
                
                //first player
                if([[usdetails objectForKey:@"fplayer_id"] isEqualToString:userID])
                {
                    lblTextLabel.text = [usdetails objectForKey:@"splayer_username"];
                    lblFeedback.text = [usdetails objectForKey:@"splayer_msg"];
                    tempID = [usdetails objectForKey:@"splayer_id"];
                    
                    if([[usdetails objectForKey:@"fplayer_comp_poss"] intValue] > [[usdetails objectForKey:@"splayer_comp_poss"] intValue])
                    {
                        //user win
                        lblDetailTextLabel.text = [NSString stringWithFormat:@"You win! %d combo more.", [[usdetails objectForKey:@"fplayer_comp_poss"] intValue] - [[usdetails objectForKey:@"splayer_comp_poss"] intValue]];
                    }
                    else if([[usdetails objectForKey:@"fplayer_comp_poss"] intValue] < [[usdetails objectForKey:@"splayer_comp_poss"] intValue])
                    {
                        //user lose
                        lblDetailTextLabel.text = [NSString stringWithFormat:@"You lose! %d combo less.", [[usdetails objectForKey:@"splayer_comp_poss"] intValue] - [[usdetails objectForKey:@"fplayer_comp_poss"] intValue]];
                    }
                    else
                    {
                        if([[usdetails objectForKey:@"fplayer_comp_time"] intValue] < [[usdetails objectForKey:@"splayer_comp_time"] intValue])
                        {
                            //user win
                            lblDetailTextLabel.text = [NSString stringWithFormat:@"You win! %ds faster.", [[usdetails objectForKey:@"splayer_comp_time"] intValue] - [[usdetails objectForKey:@"fplayer_comp_time"] intValue]];
                        }
                        else if([[usdetails objectForKey:@"fplayer_comp_time"] intValue] > [[usdetails objectForKey:@"splayer_comp_time"] intValue])
                        {
                            //user lose
                            lblDetailTextLabel.text = [NSString stringWithFormat:@"You lose! %ds slower.", [[usdetails objectForKey:@"fplayer_comp_time"] intValue] - [[usdetails objectForKey:@"splayer_comp_time"] intValue]];
                        }
                        else 
                        {
                            if([[usdetails objectForKey:@"fplayer_wrong_tried"] intValue] < [[usdetails objectForKey:@"splayer_wrong_tried"] intValue])
                            {
                                //user win
                                lblDetailTextLabel.text = [NSString stringWithFormat:@"You win! %d less wrong.", [[usdetails objectForKey:@"splayer_wrong_tried"] intValue] - [[usdetails objectForKey:@"fplayer_wrong_tried"] intValue]];
                            }
                            else if([[usdetails objectForKey:@"fplayer_wrong_tried"] intValue] > [[usdetails objectForKey:@"splayer_wrong_tried"] intValue])
                            {
                                //user lose
                                lblDetailTextLabel.text = [NSString stringWithFormat:@"You lose! %d more wrong.", [[usdetails objectForKey:@"fplayer_wrong_tried"] intValue] - [[usdetails objectForKey:@"splayer_wrong_tried"] intValue]];
                            }
                            else 
                            {
                                if([[usdetails objectForKey:@"fplayer_repeat"] intValue] < [[usdetails objectForKey:@"splayer_repeat"] intValue])
                                {
                                    //user win
                                    lblDetailTextLabel.text = [NSString stringWithFormat:@"You win! %d less repeat.", [[usdetails objectForKey:@"splayer_repeat"] intValue] - [[usdetails objectForKey:@"fplayer_repeat"] intValue]];
                                }
                                else if([[usdetails objectForKey:@"fplayer_repeat"] intValue] > [[usdetails objectForKey:@"splayer_repeat"] intValue])
                                {
                                    //user lose
                                    lblDetailTextLabel.text = [NSString stringWithFormat:@"You lose! %d more repeat.", [[usdetails objectForKey:@"fplayer_repeat"] intValue] - [[usdetails objectForKey:@"splayer_repeat"] intValue]];
                                }
                                else 
                                {
                                    //user draw
                                    lblDetailTextLabel.text = @"Draw !!";
                                }
                                
                            }
                        }
                    }
                }
                else
                {
                    lblTextLabel.text = [usdetails objectForKey:@"fplayer_username"];
                    //lblFeedback.text = [usdetails objectForKey:@"fplayer_msg"];
                    lblFeedback.text = @"";
                    
                    tempID = [usdetails objectForKey:@"fplayer_id"];
                    
                    if([[usdetails objectForKey:@"fplayer_comp_poss"] intValue] > [[usdetails objectForKey:@"splayer_comp_poss"] intValue])
                    {
                        //user lose
                        lblDetailTextLabel.text = [NSString stringWithFormat:@"You lose! %d combo less.", [[usdetails objectForKey:@"fplayer_comp_poss"] intValue] - [[usdetails objectForKey:@"splayer_comp_poss"] intValue]];
                    }
                    else if([[usdetails objectForKey:@"fplayer_comp_poss"] intValue] < [[usdetails objectForKey:@"splayer_comp_poss"] intValue])
                    {
                        //user win
                        lblDetailTextLabel.text = [NSString stringWithFormat:@"You win! %d combo more.", [[usdetails objectForKey:@"splayer_comp_poss"] intValue] - [[usdetails objectForKey:@"fplayer_comp_poss"] intValue]];
                    }
                    else
                    {
                        if([[usdetails objectForKey:@"fplayer_comp_time"] intValue] < [[usdetails objectForKey:@"splayer_comp_time"] intValue])
                        {
                            //user lose
                            lblDetailTextLabel.text = [NSString stringWithFormat:@"You lose! %ds slower.", [[usdetails objectForKey:@"splayer_comp_time"] intValue] - [[usdetails objectForKey:@"fplayer_comp_time"] intValue]];
                        }
                        else if([[usdetails objectForKey:@"fplayer_comp_time"] intValue] > [[usdetails objectForKey:@"splayer_comp_time"] intValue])
                        {
                            //user win
                            lblDetailTextLabel.text = [NSString stringWithFormat:@"You win! %ds faster.", [[usdetails objectForKey:@"fplayer_comp_time"] intValue] - [[usdetails objectForKey:@"splayer_comp_time"] intValue]];
                        }
                        else 
                        {
                            if([[usdetails objectForKey:@"fplayer_wrong_tried"] intValue] < [[usdetails objectForKey:@"splayer_wrong_tried"] intValue])
                            {
                                //user lose
                                lblDetailTextLabel.text = [NSString stringWithFormat:@"You lose! %d more wrong.", [[usdetails objectForKey:@"splayer_wrong_tried"] intValue] - [[usdetails objectForKey:@"fplayer_wrong_tried"] intValue]];
                            }
                            else if([[usdetails objectForKey:@"fplayer_wrong_tried"] intValue] > [[usdetails objectForKey:@"splayer_wrong_tried"] intValue])
                            {
                                //user win
                                lblDetailTextLabel.text = [NSString stringWithFormat:@"You win! %d less wrong.", [[usdetails objectForKey:@"fplayer_wrong_tried"] intValue] - [[usdetails objectForKey:@"splayer_wrong_tried"] intValue]];
                            }
                            else 
                            {
                                if([[usdetails objectForKey:@"fplayer_repeat"] intValue] < [[usdetails objectForKey:@"splayer_repeat"] intValue])
                                {
                                    //user lose
                                    lblDetailTextLabel.text = [NSString stringWithFormat:@"You lose! %d more repeat.", [[usdetails objectForKey:@"splayer_repeat"] intValue] - [[usdetails objectForKey:@"fplayer_repeat"] intValue]];
                                }
                                else if([[usdetails objectForKey:@"fplayer_repeat"] intValue] > [[usdetails objectForKey:@"splayer_repeat"] intValue])
                                {
                                    //user win
                                    lblDetailTextLabel.text = [NSString stringWithFormat:@"You win! %d less repeat.", [[usdetails objectForKey:@"fplayer_repeat"] intValue] - [[usdetails objectForKey:@"splayer_repeat"] intValue]];
                                }
                                else 
                                {
                                    //user draw
                                    lblDetailTextLabel.text = @"Draw !!";
                                }
                            }
                        }
                    }
                }
                
                NSString *strurl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", tempID];
                
                NSURL *url = [NSURL URLWithString:strurl];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    NSData *imageData_ = [NSData dataWithContentsOfURL:url];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // Update the UI            
                        cell.imageView.image = [UIImage imageWithData:imageData_];
                        cell.imageView.layer.masksToBounds = YES;
                        cell.imageView.layer.cornerRadius = 5.0;
                        cell.imageView.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
                        cell.imageView.layer.borderWidth = 1.5;
                    });
                });
                
                [lblFeedback sizeToFit];
                
                [cell.contentView addSubview:lblDetailTextLabel];
                [lblDetailTextLabel release];
                [cell.contentView addSubview:lblFeedback];
                [lblFeedback release];
            }
        }
        else 
        {
            if(challengeList != nil || [challengeList count] != 0)
            {
                NSDictionary* usinfo = [challengeList objectAtIndex:indexPath.row];
                
                NSDictionary* usdetails = [usinfo objectForKey:@"user"];
                
                UILabel *lblDetailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, 20, 122, 32)];
                
                lblDetailTextLabel.font = [UIFont systemFontOfSize:11];
                lblDetailTextLabel.textColor = [UIColor redColor];
                lblDetailTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                lblDetailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
                lblDetailTextLabel.numberOfLines = 0;
                lblDetailTextLabel.clipsToBounds = YES;
                lblDetailTextLabel.text = @"this is detail label text";
                
                UILabel *lblFeedback = [[UILabel alloc] initWithFrame:CGRectMake(66, 45, 122, 21)];
                
                lblFeedback.font = [UIFont systemFontOfSize:11];
                lblFeedback.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
                lblFeedback.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                lblFeedback.lineBreakMode = UILineBreakModeTailTruncation;
                lblFeedback.clipsToBounds = YES;
                lblFeedback.text = @"this is feedback label text";

                if([[usdetails objectForKey:@"fplayer_id"] isEqualToString:userID])
                {
                    lblTextLabel.text = [usdetails objectForKey:@"splayer_username"];
                    tempID = [usdetails objectForKey:@"splayer_id"];
                    lblDetailTextLabel.text = [NSString stringWithFormat:@"You completed in %@ seconds", [usdetails objectForKey:@"fplayer_comp_time"]];
                }
                else 
                {
                    lblTextLabel.text = [usdetails objectForKey:@"fplayer_username"];   
                    tempID = [usdetails objectForKey:@"fplayer_id"];
                    lblDetailTextLabel.text = [NSString stringWithFormat:@"Completed in %@ seconds", [usdetails objectForKey:@"fplayer_comp_time"]];
                }
                
                int tempDifferent = [[usdetails objectForKey:@"DiffTime"] intValue];
                
                tempDifferent = tempDifferent / 60;
                
                if(tempDifferent == 0)
                {
                    lblFeedback.text = [NSString stringWithFormat:@"%@ seconds ago", [usdetails objectForKey:@"DiffTime"]];
                }
                else 
                {
                    if(tempDifferent < 2)
                    {
                        lblFeedback.text = @"1 minute ago";
                    }
                    else if(tempDifferent < 60)
                    {
                         lblFeedback.text = [NSString stringWithFormat:@"%d minutes ago", tempDifferent];
                    }
                    else if(tempDifferent > 60)
                    {
                        tempDifferent = tempDifferent / 60;
                        
                        if(tempDifferent < 2)
                        {
                             lblFeedback.text = [NSString stringWithFormat:@"%d hour ago", tempDifferent];
                        }
                        else 
                        {
                             lblFeedback.text = [NSString stringWithFormat:@"%d hours ago", tempDifferent];
                        }
                    }
                }
                
                NSString *strurl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", tempID];
                
                NSURL *url = [NSURL URLWithString:strurl];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    NSData *imageData_ = [NSData dataWithContentsOfURL:url];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                                   
                        cell.imageView.image = [UIImage imageWithData:imageData_];
                        cell.imageView.layer.masksToBounds = YES;
                        cell.imageView.layer.cornerRadius = 5.0;
                        cell.imageView.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
                        cell.imageView.layer.borderWidth = 1.5;
                    });
                });
                
                [cell.contentView addSubview:lblDetailTextLabel];
                [lblDetailTextLabel release];
                [cell.contentView addSubview:lblFeedback];
                [lblFeedback release];
            }
        }
        
        [cell.contentView addSubview:lblTextLabel];
        [lblTextLabel release];
    }
    
    if(tableView == self.tblChallenge)
    {
        if(challengeList != nil || [challengeList count] != 0)
        {
            //add cell image button
            NSDictionary* usinfo = [challengeList objectAtIndex:indexPath.row];
            
            NSDictionary* usdetails = [usinfo objectForKey:@"user"];
            
            //first player
            if([[usdetails objectForKey:@"fplayer_id"] isEqualToString:userID])
            {
                UIImage *btnImage = [UIImage imageNamed:@"btn_waiting.png"];
                UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
                customButton.frame = CGRectMake(195.0f, 5.0f, 90.0f, 53.0f);
                customButton.backgroundColor = [UIColor clearColor];
                customButton.tag = indexPath.row;
                [customButton setBackgroundImage:btnImage forState:UIControlStateNormal];
                customButton.userInteractionEnabled = NO;
                [cell addSubview:customButton];
            }
            else 
            {
                UIImage *btnImage = [UIImage imageNamed:@"btn_accept.png"];
                UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
                customButton.frame = CGRectMake(195.0f, 5.0f, 90.0f, 53.0f);
                customButton.backgroundColor = [UIColor clearColor];
                customButton.tag = indexPath.row;
                [customButton setBackgroundImage:btnImage forState:UIControlStateNormal];
                [cell addSubview:customButton];
                
                [customButton addTarget:self action:@selector(acceptChallenge:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    else 
    {
        if(challengeResult != nil || [challengeResult count] != 0)
        {
            //add cell image button
            UIImage *btnImage = [UIImage imageNamed:@"btn_rechallenge.png"];
            UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
            customButton.frame = CGRectMake(195.0f, 5.0f, 90.0f, 53.0f);
            customButton.backgroundColor = [UIColor clearColor];
            customButton.tag = indexPath.row;
            [customButton setBackgroundImage:btnImage forState:UIControlStateNormal];
            [cell addSubview:customButton];
            
            [customButton addTarget:self action:@selector(reChallenge:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView* headerView = nil;
    if(tableView == self.tblChallenge){
        if(challengeList.count != 0){
            headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 51)] autorelease];
            UIImageView *header = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_challenge_board.png"]] autorelease];
            [headerView addSubview:header];
        }
    }else{
        if(challengeResult.count != 0){
            headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 51)] autorelease];
            UIImageView *header = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_challenge_result.png"]] autorelease];
            [headerView addSubview:header];
        }
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0;
}

-(void)reloadtable{
    [tblChallenge reloadData];
    [tblResult reloadData];
}

- (void) retrieveResult
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
         
        dispatch_async(dispatch_get_main_queue(), ^{
            [Timer invalidate];
            
            WebServices *ws = [[WebServices alloc] init];
            
            NSArray *arrUpdatedChallengeList = [ws selectChallengeByFBID:userID];
            
            NSArray *arrUpdatedChallengeResult = [ws selectChallengeResultByFBID:userID];
            
            [ws release];
            
            if((challengeResult.count != arrUpdatedChallengeResult.count) || (challengeList.count != arrUpdatedChallengeList.count))
            {
                if(challengeList.count != arrUpdatedChallengeList.count)
                {
                    challengeList = [arrUpdatedChallengeList copy];
                }
                
                if(challengeResult.count != arrUpdatedChallengeResult.count)
                {
                    challengeResult = [arrUpdatedChallengeResult copy];
                }
                
                if(challengeList.count > 0){
                    self.tblChallenge.hidden = NO;
                    self.tblChallenge.frame = CGRectMake(15, 258, 290, 51 + 72 * challengeList.count);
                    if(challengeResult.count != 0){
                        self.tblResult.hidden = NO;
                        self.tblResult.frame = CGRectMake(15, 72 * challengeList.count + 319, 290, 51 + 72 * challengeResult.count);
                        self.svController.contentSize = CGSizeMake(320, 51 * 2 + 72 * (challengeList.count + challengeResult.count) + 278);
                    }
                    else{
                        self.svController.contentSize = CGSizeMake(320, 51 + 72 * challengeList.count + 268);
                    }
                }else{
                    if(challengeResult.count > 0){
                        self.tblResult.hidden = NO;
                        self.tblResult.frame = CGRectMake(15, 258, 290, 51 + 72 * challengeResult.count);
                        self.svController.contentSize = CGSizeMake(320, 51 + 72 * (challengeList.count + challengeResult.count) + 268);
                    }
                    else{
                        self.svController.contentSize = CGSizeMake(320, 258);
                    }
                }
                
                self.tblResult.scrollEnabled = NO;
                self.tblChallenge.scrollEnabled = NO;
                [tblChallenge reloadData];
                [tblResult reloadData];
            }
            
            Timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reloadtable) userInfo:nil repeats:YES];
         });
    });
}

- (void)dealloc {
    [svController release];
    [tblChallenge release];
    [tblResult release];
    [imgUser release];
    [userID release];
    [userName release];
    [super dealloc];
}

@end
