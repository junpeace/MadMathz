//
//  WebServices.h
//  MadMath
//
//  Created by Jermin Bazazian on 9/11/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePlay.h"

@interface WebServices : NSObject

- (NSString*) selectUserScoreByFBID: (NSString*) FBID;
- (void) updateUserPushToken: (NSString*) pushToken :(NSString*) FBID;
- (NSArray*) selectAllUserFBIDAndScore;
- (GamePlay*) selectGamePlayByID: (int) gpID;
- (void) insertSingleMatchDetails: (int) matchCompTime :(int) matchResult :(NSString*) playerID;
- (void) updateUserScore: (NSString*) FBID :(int) score;
- (NSArray*) selectChallengeResultByFBID: (NSString*) FBID;
- (NSArray*) selectChallengeByFBID: (NSString*) FBID;
- (void) insertFPlayerDetails: (NSString*) fplayerMsg :(NSString*) fplayerID :(int)fplayerCompTime :(int) fplayerCompComb :(int) fplayerPlayedTime :(int) fplayerWrong :(int) gid:(NSString*) fplayerUsername :(int) fplayerRepeat :(NSString*) splayerID :(NSString*) splayerUsername;
- (void) insertSPlayerDetails: (NSString*) splayerMsg :(NSString*) splayerID :(int) splayerCompTime :(int) splayerCompComb :(int) matchPlayedTime :(int) splayerWrong :(int) match_id:(int) splayerRepeat;
- (void) insertNewUser: (NSArray*) personalInfo;

@end
