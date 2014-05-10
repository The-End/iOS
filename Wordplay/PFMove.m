//
//  PFMove.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PFMove.h"

@implementation PFMove

@dynamic moveNumber;
@dynamic type;
@dynamic word;
@dynamic affectedMove;

+(PFMove *) newCreateMove:(NSString *) word
{
    PFMove *newMove = [PFMove object];
    newMove.word = word;
    newMove.type = @"CREATE";
    return newMove;
}

+(PFMove *) newDeleteMove:(PFMove *) affectedMove
{
    PFMove *newMove = [PFMove object];
    newMove.affectedMove = affectedMove;
    newMove.type = @"DELETE";
    return newMove;
}

+(PFMove *) newInsertBeforeMove:(NSString *) word afterId:(PFMove *) afterMove
{
    PFMove *newMove = [PFMove object];
    newMove.word = word;
    newMove.affectedMove = afterMove;
    newMove.type = @"INSERT_BEFORE";
    return newMove;
}

+(PFMove *) newInsertAferMove:(NSString *) word afterId:(PFMove *) afterMove
{
    PFMove *newMove = [PFMove object];
    newMove.word = word;
    newMove.affectedMove = afterMove;
    newMove.type = @"INSERT_AFTER";
    return newMove;
}


+(PFMove *) newLockMove:(PFMove *) lockedMove
{
    PFMove *newMove = [PFMove object];
    newMove.affectedMove = lockedMove;
    newMove.type = @"LOCK";
    return newMove;
}

+(PFMove *) newSwitchMove:(NSString *) word onMove:(PFMove *) switchedMove
{
    PFMove *newMove = [PFMove object];
    newMove.affectedMove = switchedMove;
    newMove.word = word;
    newMove.type = @"SWITCH";
    return newMove;
}

+ (NSString *)parseClassName {
    return @"PFMove";
}

@end
