//
//  PFMove.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PFMove.h"

@implementation PFMove

@dynamic player;
@dynamic time;
@dynamic moveNumber;
@dynamic type;
@dynamic word;
@dynamic affectedMove;

+(PFMove *) newCreateMove:(NSString *) word
{
    PFMove *newMove = [PFMove object];
    newMove.word = word;
    newMove.type = @"CREATE";
    newMove.player = [PFUser currentUser];
    newMove.time = [NSDate date];
    return newMove;
}

+(PFMove *) newDeleteMove:(PFMove *) affectedMove
{
    PFMove *newMove = [PFMove object];
    newMove.affectedMove = affectedMove;
    newMove.type = @"DELETE";
    newMove.player = [PFUser currentUser];
    newMove.time = [NSDate date];
    return newMove;
}

+(PFMove *) newInsertMove:(NSString *) word beforeId:(PFMove *) beforeMove
{
    PFMove *newMove = [PFMove object];
    newMove.word = word;
    newMove.affectedMove = beforeMove;
    newMove.type = @"INSERT_BEFORE";
    newMove.player = [PFUser currentUser];
    newMove.time = [NSDate date];
    return newMove;
}

+(PFMove *) newInsertMove:(NSString *) word afterId:(PFMove *) afterMove
{
    PFMove *newMove = [PFMove object];
    newMove.word = word;
    newMove.affectedMove = afterMove;
    newMove.type = @"INSERT_AFTER";
    newMove.player = [PFUser currentUser];
    newMove.time = [NSDate date];
    return newMove;
}


+(PFMove *) newLockMove:(PFMove *) lockedMove
{
    PFMove *newMove = [PFMove object];
    newMove.affectedMove = lockedMove;
    newMove.type = @"LOCK";
    newMove.player = [PFUser currentUser];
    newMove.time = [NSDate date];
    return newMove;
}

+(PFMove *) newSwitchMove:(NSString *) word onMove:(PFMove *) switchedMove
{
    PFMove *newMove = [PFMove object];
    newMove.affectedMove = switchedMove;
    newMove.word = word;
    newMove.type = @"SWITCH";
    newMove.player = [PFUser currentUser];
    newMove.time = [NSDate date];
    return newMove;
}

+ (NSString *)parseClassName {
    return @"PFMove";
}

@end
