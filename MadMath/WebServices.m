//
//  WebServices.m
//  MadMath
//
//  Created by Jermin Bazazian on 9/11/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import "WebServices.h"

@interface WebServices()

@property (nonatomic, strong) NSMutableData *receivedData;

@end

@implementation WebServices

@synthesize receivedData = receivedData_;


- (void)viewDidLoad
{
    //[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //initialize receivedData_
    receivedData_ = [[NSMutableData alloc] init];
    
    /*SELECT statement*/
    /*
     dispatch_async(kBgQueue, ^{
     NSData* data = [NSData dataWithContentsOfURL: kUserInfoURL];
     [self performSelectorOnMainThread:@selector(fetchedData:) 
     withObject:data waitUntilDone:YES];
     });*/
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
}

/**** NSURLConnectionDelegate Async callbacks : START ****/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"No internet access !!!");
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    int code = [httpResponse statusCode];
    
    if(code > 400){NSLog(@"Server error !!");}
    
    [receivedData_ setLength:0];
}

- (void) connection: (NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData_ appendData:data];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
    NSString* strResponse = [[NSString alloc] initWithData:receivedData_ encoding:NSUTF8StringEncoding];
    
    NSLog(@"Query status : %@", strResponse);
    
    [strResponse release];
    
    receivedData_ = nil;
}
/**** NSURLConnectionDelegate Async callbacks : END ****/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)fetchedData:(NSData *)responseData 
{
    //parse out the json data
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          options:kNilOptions error:&error];
    
    NSArray* users = [json objectForKey:@"posts"]; //2
    
    for(int i = 0;i < users.count;i++)
    {
        NSDictionary* user = [users objectAtIndex:i];
        
        NSDictionary* use = [user objectForKey:@"user"];
        
        NSString* email = [use objectForKey:@"email"];
        
        NSLog(@"output : %@", email);
    }
}

- (void)updateUserPushToken: (NSString*) pushToken :(NSString*) FBID
{
    /* how to call */
    // [self updateUserPushToken:@"92038324889479354386728457394857" :@"10001000"];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"PushToken\":\"%@\",\"FBID\":\"%@\"}", pushToken, FBID];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=updateUserPushToken&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) updateUserScore: (NSString*) FBID :(int) score
{
    /* how to call */
    //[self updateUserScore:@"10001000" :100];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"Score\":\"%d\",\"FBID\":\"%@\"}", score, FBID];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=updateUserScore&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) insertNewUser: (NSArray*) personalInfo
{
    /* how to call */
    //NSArray *personalInfo = [NSArray arrayWithObjects:@"tan", @"ah fai", @"male", @"ahfai@yahoo.com", @"xiao fai", @"10031003", @"28434857982318236", nil];
    //[self insertNewUser:personalInfo];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"FirstName\":\"%@\",\"LastName\":\"%@\",\"Gender\":\"%@\",\"Email\":\"%@\",\"FBUsername\":\"%@\",\"FBID\":\"%@\",\"PushToken\":\"%@\"}", [personalInfo objectAtIndex:0], [personalInfo objectAtIndex:1], [personalInfo objectAtIndex:2], [personalInfo objectAtIndex:3], [personalInfo objectAtIndex:4], [personalInfo objectAtIndex:5], [personalInfo objectAtIndex:6]];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=insertNewUser&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) insertSingleMatchDetails: (int) matchCompTime :(int) matchResult :(NSString*) playerID
{
    /* how to call */
    //[self insertSingleMatchDetails:40 :1 :@"10001000"];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"MatchCompTime\":\"%d\",\"MatchResult\":\"%d\",\"FBID\":\"%@\"}", matchCompTime, matchResult, playerID];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=insertSMatchDetails&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) insertFPlayerDetails: (NSString*) fplayerMsg :(NSString*) fplayerID :(int)fplayerCompTime :(int) fplayerCompComb :(int) fplayerPlayedTime :(int) fplayerWrong :(int) gid:(NSString*) fplayerUsername :(int) fplayerRepeat :(NSString*) splayerID :(NSString*) splayerUsername
{
    /* how to call */
    //NSString *fplayerMsg = @"Simple message";
    //NSString *fplayerID = @"10001000";
    //int fplayerCompTime = 30;
    //int fplayerCompComb = 3;
    //int fplayerPlayedTime = 30;
    //int fplayerWrong = 2;
    //int gid = 1;
    //[self insertFPlayerDetails:fplayerMsg :fplayerID :fplayerCompTime :fplayerCompComb :fplayerPlayedTime :fplayerWrong :gid];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"FBID\":\"%@\",\"Message\":\"%@\",\"CompTime\":\"%d\",\"CompPoss\":\"%d\",\"MatchResult\":\"%d\",\"WrongAttemp\":\"%d\",\"GID\":\"%d\",\"FUserName\":\"%@\",\"Repeat\":\"%d\",\"SPlayerID\":\"%@\",\"SPlayerUserName\":\"%@\"}", fplayerID, fplayerMsg, fplayerCompTime, fplayerCompComb, fplayerPlayedTime, fplayerWrong, gid, fplayerUsername, fplayerRepeat, splayerID, splayerUsername];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=insertFPlayerDetails&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) insertSPlayerDetails: (NSString*) splayerMsg :(NSString*) splayerID :(int) splayerCompTime :(int) splayerCompComb :(int) matchPlayedTime :(int) splayerWrong :(int) match_id:(int) splayerRepeat
{
    /* how to call */
    //NSString *splayerMsg = @"Simple message 2";
    //NSString *splayerID = @"10021002";
    //int splayerCompTime = 50;
    //int splayerCompComb = 2;
    //int matchPlayedTime = 85; //1st and 2nd user's time add 2gether
    //int splayerWrong = 1;
    //int match_id = 100001;
    //[self insertSPlayerDetails:splayerMsg :splayerID :splayerCompTime :splayerCompComb :matchPlayedTime :splayerWrong :match_id];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"FBID\":\"%@\",\"Message\":\"%@\",\"CompTime\":\"%d\",\"CompPoss\":\"%d\",\"MatchResult\":\"%d\",\"WrongAttemp\":\"%d\",\"MatchID\":\"%d\",\"Repeat\":\"%d\"}", splayerID, splayerMsg, splayerCompTime, splayerCompComb, matchPlayedTime, splayerWrong, match_id, splayerRepeat];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=insertSPlayerDetails&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (GamePlay*) selectGamePlayByID: (int) gpID
{
    /* how to call */
    //[self selectGamePlayByID:2];
    /*
     GamePlay *gameplay = nil;
     gameplay = [self selectGamePlayByID:3];
     
     NSLog(@"id : %d", gameplay.GamePlay_id);
     NSLog(@"img nums : %@", gameplay.img_Numbers);
     NSLog(@"total : %@", gameplay.total_Possibility);
     NSLog(@"poss 3 : %@", gameplay.poss_3);
     NSLog(@"poss 4 : %@", gameplay.poss_4);
     */
    
    GamePlay *gameplay = [[GamePlay alloc] init];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"GPID\":\"%d\"}", gpID];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=selectGamePlayByID&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    //response returned by the server
    NSURLResponse *response;
    
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //output the result in string
    //NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //NSLog(@"Reply: %@", theReply);
    
    //[self performSelectorOnMainThread:@selector(gamePlayData:) withObject:POSTReply waitUntilDone:YES];
    
    gameplay = [self gamePlayData:POSTReply];
    
    NSLog(@"%@", gameplay.poss_3);
    
    return gameplay;
}

- (GamePlay*)gamePlayData:(NSData *)responseData 
{
    //parse out the json data
    NSError* error;
    
    GamePlay *gameplay = [[GamePlay alloc] init];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray* gamePlayArray = [json objectForKey:@"posts"];
    
    //loop the result passed back
    for(int i = 0; i < gamePlayArray.count; i++)
    {
        NSDictionary* gpinfo = [gamePlayArray objectAtIndex:i];
        
        NSDictionary* gpdetails = [gpinfo objectForKey:@"game_play"];
        
        NSString* gpid = [gpdetails objectForKey:@"id"];
        
        NSString* imgNumbers = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", [gpdetails objectForKey:@"img_number1"], [gpdetails objectForKey:@"img_number2"], [gpdetails objectForKey:@"img_number3"], [gpdetails objectForKey:@"img_number4"], [gpdetails objectForKey:@"img_number5"], [gpdetails objectForKey:@"img_number6"], [gpdetails objectForKey:@"img_number7"], [gpdetails objectForKey:@"img_number8"], [gpdetails objectForKey:@"img_number9"], [gpdetails objectForKey:@"img_number10"], [gpdetails objectForKey:@"img_number11"], [gpdetails objectForKey:@"img_number12"], [gpdetails objectForKey:@"img_number13"], [gpdetails objectForKey:@"img_number14"], [gpdetails objectForKey:@"img_number15"], [gpdetails objectForKey:@"img_number16"]];
        
        NSString* anws = [gpdetails objectForKey:@"answer"];
        
        NSString* totalPoss = [gpdetails objectForKey:@"total_possibility"];
        
        NSString* poss3 = [gpdetails objectForKey:@"possibility_3"];
        
        NSString* poss4 = [gpdetails objectForKey:@"possibility_4"];
        
        //NSLog(@"gpid : %@", gpid);
        //NSLog(@"imgnumbers : %@", imgNumbers);
        //NSLog(@"answer : %@", anws);
        //NSLog(@"total possibility : %@", totalPoss);
        //NSLog(@"possibility 3 : %@", poss3);
        //NSLog(@"possibility 4 : %@", poss4);
        
        gameplay.GamePlay_id = [gpid intValue];
        gameplay.img_Numbers = imgNumbers;
        gameplay.anws = anws;
        gameplay.total_Possibility = totalPoss;
        gameplay.poss_3 = poss3;
        gameplay.poss_4 = poss4;
    }
    
    return gameplay;
}

- (NSString*) selectUserScoreByFBID: (NSString*) FBID
{
    /* how to call */
    //[self selectUserScoreByFBID:@"10001000"];
    NSString *score = @"";
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"FBID\":\"%@\"}", FBID];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=selectScoreByFBID&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    //response returned by the server
    NSURLResponse *response;
    
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //output the result in string
    //NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //NSLog(@"Reply: %@", theReply);
    
    //[self performSelectorOnMainThread:@selector(userScoreData:) withObject:POSTReply waitUntilDone:YES];
    
    score = [self userScoreData:POSTReply];
    
    return score;
}

- (NSString*)userScoreData:(NSData *)responseData 
{
    //parse out the json data
    NSError* error;
    
    NSString* score = @"";
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray* userScoreArray = [json objectForKey:@"posts"];
    
    //loop the result passed back
    for(int i = 0; i < userScoreArray.count; i++)
    {
        NSDictionary* usinfo = [userScoreArray objectAtIndex:i];
        
        NSDictionary* usdetails = [usinfo objectForKey:@"user"];
        
        score = [usdetails objectForKey:@"score"];
    }
    
    return score;
}

- (NSArray*) selectAllUserFBIDAndScore
{
    NSString *jsonRequest = [NSString stringWithFormat:@"{}"];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=selectAllUserFBIDAndScore&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSURLResponse *response;
    
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //output the result in string
    //NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //NSLog(@"Reply: %@", theReply);
    
    NSArray *resultArray = [self userFBIDandScore:POSTReply];
    
    return resultArray;
}

-(NSArray*) userFBIDandScore: (NSData*)responseData
{
    //parse out the json data
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *resultArray = [json objectForKey:@"posts"];
    
    return resultArray;
}

-(NSArray*) selectChallengeResultByFBID: (NSString*) FBID
{
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"FBID\":\"%@\"}", FBID];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=selectChallengeResultByFBID&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSURLResponse *response;
    
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //output the result in string
    //NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //NSLog(@"Reply: %@", theReply);
    
    NSArray *resultArray = [self challengeResult:POSTReply];
    
    return resultArray;
}

-(NSArray*) challengeResult: (NSData*)responseData
{
    //parse out the json data
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *resultArray = [json objectForKey:@"posts"];
    
    return resultArray;
}

-(NSArray*) selectChallengeByFBID: (NSString*) FBID
{
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"FBID\":\"%@\"}", FBID];
    
    NSLog(@"Request: %@", jsonRequest);
    
    NSURL *url = [NSURL URLWithString:@"http://zrlim.com/mm/request_user_details.php?mName=selectChallengeByFBID&format=json"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //use delegate method for error handling, response and status returned
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSURLResponse *response;
    
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //output the result in string
    //NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //NSLog(@"Reply: %@", theReply);
    
    NSArray *resultArray = [self challengeList:POSTReply];
    
    return resultArray;
}

-(NSArray*) challengeList: (NSData*)responseData
{
    //parse out the json data
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSArray *resultArray = [json objectForKey:@"posts"];
    
    return resultArray;
}

@end
