//
//  PFGame.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PFGame.h"
#import "PFPlayerMove.h"
#import "PFMove.h"

@implementation PFGame

@dynamic active;
@dynamic created;
@dynamic modified;
@dynamic name;
@dynamic owner;
@dynamic playerMoves;
@dynamic player;

-(void) setupNewGameWithPlayer:(PFUser *) user;
{
    self.active = YES;
    self.created = [NSDate date];
    self.modified = [NSDate date];
    self.owner = [PFUser currentUser];
    self.playerMoves = [[NSMutableArray alloc] init];
    self.player = user;
    
}

-(PFPlayerMove *) newCreateMoveWithWord:(NSString *) word forPlayer:(PFPlayerMove *) playerMove
{
    
    if(!playerMove){
        playerMove = [self initializePlayerMove];
    }
    
    PFMove *createMove = [PFMove newCreateMove:word];
    [playerMove giveMove: createMove];
    [self.playerMoves addObject:playerMove];
    
    return playerMove;
}

-(PFPlayerMove *) newDeleteMove:(PFMove *) move forPlayer:(PFPlayerMove *) playerMove
{
    
    if(!playerMove){
        playerMove = [self initializePlayerMove];
    }
    
    [playerMove giveMove: [PFMove newDeleteMove: move]];
    [self.playerMoves addObject:playerMove];
    
    return playerMove;
}

-(PFPlayerMove *) newInsertWord:(NSString *) word beforeMove:(PFMove *) beforeMove forPlayer:(PFPlayerMove *) playerMove
{
    
    if(!playerMove){
        playerMove = [self initializePlayerMove];
    }
    
    
    [playerMove giveMove:[PFMove newInsertBeforeMove:word afterId:beforeMove]];
    [self.playerMoves addObject:playerMove];
    
    return playerMove;
}

-(PFPlayerMove *) newInsertWord:(NSString *) word afterMove:(PFMove *) afterMove forPlayer:(PFPlayerMove *) playerMove
{
    
    if(!playerMove){
        playerMove = [self initializePlayerMove];
    }
    
    
    [playerMove giveMove:[PFMove newInsertAfterMove:word afterId:afterMove]];
    [self.playerMoves addObject:playerMove];
    
    return playerMove;
}

-(PFPlayerMove *) newLockMove:(PFMove *) lockedMove forPlayer:(PFPlayerMove *) playerMove
{
    
    if(!playerMove){
        playerMove = [self initializePlayerMove];
    }
    
    
    [playerMove giveMove: [PFMove newLockMove:lockedMove]];
    [self.playerMoves addObject:playerMove];
    
    return playerMove;
}

-(PFPlayerMove *) newSwitchMove:(PFMove *) switched forWord:(NSString *) word forPlayer:(PFPlayerMove *) playerMove
{
    
    if(!playerMove){
        playerMove = [self initializePlayerMove];
    }
    
    
    [playerMove giveMove:[PFMove newSwitchMove:word onMove:switched]];
    [self.playerMoves addObject:playerMove];
    
    return playerMove;
}

-(PFPlayerMove *) initializePlayerMove
{
    PFPlayerMove *playerMove = [PFPlayerMove object];
    playerMove.player = [PFUser currentUser];
    playerMove.moveNumber = [self.playerMoves count];
    playerMove.time = [NSDate date];
    return playerMove;
}

-(void) saveGame
{
    [self saveInBackground];
    for(PFPlayerMove *move in self.playerMoves){
        [move saveMoves];
    }
}

+(NSString *)parseClassName
{
    return @"PFGame";
}

@end
