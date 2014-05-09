//
//  PFMove.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PFMove.h"

@implementation PFMove

@dynamic type;
@dynamic word;
@dynamic affectedId;

+(PFMove *) newCreateMove:(NSString *) word
{
    PFMove *newMove = [[PFMove alloc] init];
    newMove.word = word;
    newMove.type = @"CREATE";
    return newMove;
}

+(PFMove *) newDeleteMove:(NSString *) affectedId
{
    PFMove *newMove = [[PFMove alloc] init];
    newMove.affectedId = affectedId;
    newMove.type = @"DELETE";
    return newMove;
}

+(PFMove *) newInsertMove:(NSString *) word afterId:(NSString *) afterId
{
    PFMove *newMove = [[PFMove alloc] init];
    newMove.word = word;
    newMove.affectedId = afterId;
    newMove.type = @"INSERT";
    return newMove;
}

+(PFMove *) newLockMove:(NSString *) affectedId
{
    PFMove *newMove = [[PFMove alloc] init];
    newMove.affectedId = affectedId;
    newMove.type = @"LOCK";
    return newMove;
}

+(PFMove *) newSwitchMove:(NSString *) word onMove:(NSString *) affectedId
{
    PFMove *newMove = [[PFMove alloc] init];
    newMove.affectedId = affectedId;
    newMove.word = word;
    newMove.type = @"SWITCH";
    return newMove;
}

+ (NSString *)parseClassName {
    return @"PFMove";
}

@end
