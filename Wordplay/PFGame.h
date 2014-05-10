//
//  PFGame.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFUser.h>
#import <Parse/PFObject+Subclass.h>
#import "PFMove.h"
#import "PFPlayerMove.h"

@interface PFGame : PFObject<PFSubclassing>

@property BOOL active;
@property NSDate * created;
@property NSDate * modified;
@property NSString * name;
@property PFUser * owner;
@property NSMutableArray * playerMoves;
@property PFUser * player;

-(void) setupNewGameWithPlayer:(PFUser *) user;

-(PFPlayerMove *) newCreateMoveWithWord:(NSString *) word forPlayer:(PFPlayerMove *) playerMove;

-(PFPlayerMove *) newDeleteMove:(PFMove *) move forPlayer:(PFPlayerMove *) playerMove;

-(PFPlayerMove *) newInsertWord:(NSString *) word beforeMove:(PFMove *) beforeMove forPlayer:(PFPlayerMove *) playerMove;

-(PFPlayerMove *) newInsertWord:(NSString *) word afterMove:(PFMove *) afterMove forPlayer:(PFPlayerMove *) playerMove;

-(PFPlayerMove *) newLockMove:(PFMove *) lockedMove forPlayer:(PFPlayerMove *) playerMove;

-(PFPlayerMove *) newSwitchMove:(PFMove *) switched forWord:(NSString *) word forPlayer:(PFPlayerMove *) playerMove;

-(PFPlayerMove *) initializePlayerMove;

-(void) saveGame;

+(void) loadActive:(BOOL)active GamesWithBlock:(void(^)(NSArray *array, NSError *error))block;

+(void) loadGame:(PFGame *)game WithBlock:(void(^)(PFGame *game, NSError *error))block;

+(NSString *)parseClassName;

@end
