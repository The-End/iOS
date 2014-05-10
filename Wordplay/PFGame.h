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

@interface PFGame : PFObject<PFSubclassing>

@property BOOL active;
@property NSDate * created;
@property NSDate * modified;
@property NSString * name;
@property PFUser * owner;
@property NSMutableArray * moves;
@property PFUser * player;
@property PFUser * activePlayer;

-(BOOL) isMyTurn;

-(void) setGameAsFinished;

-(void) setupNewGameWithPlayer:(PFUser *) user;

-(void) newCreateMoveWithWord:(NSString *) word;

-(void) newDeleteMove:(PFMove *) move;

-(void) newInsertWord:(NSString *) word beforeMove:(PFMove *) beforeMove;

-(void) newInsertWord:(NSString *) word afterMove:(PFMove *) afterMove;

-(void) newLockMove:(PFMove *) lockedMove;

-(void) newSwitchMove:(PFMove *) switched forWord:(NSString *) word;

-(void) saveGame;

-(NSArray *) getMovesInOrder;\

+(void) loadActive:(BOOL)active GamesWithBlock:(void(^)(NSArray *array, NSError *error))block;

+(void) loadGame:(PFGame *)game WithBlock:(void(^)(PFGame *game, NSError *error))block;

+(NSString *)parseClassName;

@end
