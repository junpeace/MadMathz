//
//  GamePlay.m
//  MadMath
//
//  Created by Jermin Bazazian on 9/11/12.
//  Copyright (c) 2012 tiseno integrated solutions sdn bhd. All rights reserved.
//

#import "GamePlay.h"

@implementation GamePlay

@synthesize GamePlay_id;

@synthesize img_Numbers, anws, total_Possibility, poss_3, poss_4;

-(void)dealloc
{
    //[img_Numbers, anws, total_Possibility, poss_3, poss_4 release];
    
    [super dealloc];
}

@end
