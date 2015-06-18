//
//  FacebookFriendList.m
//  MadMath
//
//  Created by Jermin Bazazian on 9/11/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import "FacebookFriendList.h"


@implementation FacebookFriendList

@synthesize tblfb = _tblfb;
@synthesize arr;
@synthesize matchedUser;
@synthesize userID;
@synthesize userName;
@synthesize userScore;
@synthesize imageData;

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
    isconnected = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    countinterrupted = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    connectiontimer = [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(checkingconnection) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    [connectiontimer invalidate];
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

-(IBAction)back:(id)sender{
    [super dismissModalViewControllerAnimated:YES];
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

- (void)refreshTable
{
    [_tblfb reloadData];
}

-(IBAction)inviteFriendEvent: (id)sender
{
    ShareToFaceBook1 *GtestClasssViewController=[[[ShareToFaceBook1 alloc] initWithNibName:@"ShareToFaceBook1"  bundle:nil] autorelease];
    GtestClasssViewController.friendID = [[self.arr objectAtIndex:[sender tag]] objectForKey:@"id"];
    [self presentModalViewController:GtestClasssViewController animated:YES];
}

-(IBAction)challenge: (id)sender
{
    ReadyScene *GtestClasssViewController=[[[ReadyScene alloc] initWithNibName:@"ReadyScene"  bundle:nil] autorelease];
    GtestClasssViewController.gamemode = 2;
    GtestClasssViewController.gameplayer = 1;
    GtestClasssViewController.userName = userName;
    GtestClasssViewController.userScore = userScore;
    GtestClasssViewController.userID = userID;
    GtestClasssViewController.imageData = imageData;
    GtestClasssViewController.splayerID = [[self.arr objectAtIndex:[sender tag]] objectForKey:@"id"];
    GtestClasssViewController.splayerUsername = [[self.arr objectAtIndex:[sender tag]] objectForKey:@"name"];
    
    [self presentModalViewController:GtestClasssViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

//table function
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //this 2 method is not suitable in this case... need some thinkering
    tableView.layer.borderWidth = 2.5;
    tableView.layer.cornerRadius = 10;
    tableView.layer.borderColor = [UIColor colorWithRed:0.3960 green:0.2627 blue:0.1294 alpha:1.0].CGColor;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell %d,  %d", indexPath.row, indexPath.section]; //this is where each cell gets  uniquie identifier which prevents any problems  
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.indentationLevel = cell.indentationLevel + 2;
        cell.frame = CGRectMake(0, 0, 310, 55);
        
        //textLabel properties
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.textLabel.clipsToBounds = YES;
        
        UILabel *lblTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 6, 115, 21)];
        
        lblTextLabel.font = [UIFont boldSystemFontOfSize:14];
        lblTextLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
        lblTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        lblTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        lblTextLabel.clipsToBounds = YES;
        
        lblTextLabel.text = [[self.arr objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        [cell.contentView addSubview:lblTextLabel];
        [lblTextLabel release];
        
        //detailTextLabel properties
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0];
        cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell.detailTextLabel.clipsToBounds = YES;
        
        //add line below
        CGRect lineFrame = CGRectMake(0, cell.frame.size.height+13, cell.frame.size.width, 2);
        UIView *line = [[UIView alloc] initWithFrame:lineFrame];
        line.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
        line.layer.borderWidth = 2.5;
        [cell.contentView addSubview:line];
        [line release];
    }
    
    cell.detailTextLabel.text = [self.matchedUser objectAtIndex:indexPath.row];
    
    if([[self.matchedUser objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        //add cell image button
        UIImage *btnImage = [UIImage imageNamed:@"btn_invite.png"];
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customButton.frame = CGRectMake(195.0f, 5.0f, 90.0f, 53.0f);
        customButton.backgroundColor = [UIColor clearColor];
        customButton.tag = indexPath.row;
        [customButton setBackgroundImage:btnImage forState:UIControlStateNormal];
        [cell addSubview:customButton];
        
        [customButton addTarget:self action:@selector(inviteFriendEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    else 
    {
        //add cell image button
        UIImage *btnImage = [UIImage imageNamed:@"btn_challenge.png"];
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        customButton.frame = CGRectMake(195.0f, 5.0f, 90.0f, 53.0f);
        customButton.backgroundColor = [UIColor clearColor];
        customButton.tag = indexPath.row;
        [customButton setBackgroundImage:btnImage forState:UIControlStateNormal];
        [cell addSubview:customButton];
        
        [customButton addTarget:self action:@selector(challenge:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSString *strurl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [[self.arr objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
    NSURL *url = [NSURL URLWithString:strurl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *imageDatas = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                       
            cell.imageView.image = [UIImage imageWithData:imageDatas];
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.layer.cornerRadius = 5.0;
            cell.imageView.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:66.0/255.0 blue:0 alpha:1.0].CGColor;
            cell.imageView.layer.borderWidth = 1.5;
        });
    });
    
    return cell;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView* headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 51)] autorelease];
    
    UIImageView *header = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_facebook_friend.png"]] autorelease];
    
    [headerView addSubview:header];
    
    return headerView;
}

//set the table's header height !!
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 51.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0;
}

- (void)dealloc 
{
    [_tblfb release];
    [arr release];
    [matchedUser release];
    [super dealloc];
}

@end
