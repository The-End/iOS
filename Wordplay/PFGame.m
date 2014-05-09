//
//  PFGame.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PFGame.h"

@implementation PFGame

@dynamic active;
@dynamic created;
@dynamic modified;
@dynamic name;
@dynamic owner;
@dynamic playerMoves;
@dynamic players;

+(NSString *)parseClassName
{
    return @"PFGame";
}

@end
