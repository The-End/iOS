//
//  PFGame.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PFGame.h"
#import "PFMove.h"

@implementation PFGame

@dynamic active;
@dynamic created;
@dynamic modified;
@dynamic name;
@dynamic owner;
@dynamic moves;
@dynamic player;

-(void) setupNewGameWithPlayer:(PFUser *) user;
{
    self.active = YES;
    self.created = [NSDate date];
    self.modified = [NSDate date];
    self.owner = [PFUser currentUser];
    self.moves = [[NSMutableArray alloc] init];
    self.player = user;
    
}

-(void) setGameAsFinished
{
    self.active = NO;
    [self saveGame];
}

-(void) newCreateMoveWithWord:(NSString *) word
{
    PFMove *createMove = [PFMove newCreateMove:word];
    createMove.moveNumber = [self.moves count];
    [self.moves addObject:createMove];
}

-(void) newDeleteMove:(PFMove *) move
{
    
    PFMove *deleteMove = [PFMove newDeleteMove:move];
    deleteMove.moveNumber = [self.moves count];
    [self.moves addObject:deleteMove];
}

-(void) newInsertWord:(NSString *) word beforeMove:(PFMove *) beforeMove
{
    PFMove *insertMove = [PFMove newInsertMove:word beforeId:beforeMove];
    insertMove.moveNumber = [self.moves count];
    [self.moves addObject:insertMove];
}

-(void) newInsertWord:(NSString *) word afterMove:(PFMove *) afterMove
{
    PFMove *insertMove = [PFMove newInsertMove:word afterId:afterMove];
    insertMove.moveNumber = [self.moves count];
    [self.moves addObject:insertMove];
}

-(void) newLockMove:(PFMove *) lockedMove
{
    PFMove *lockMove = [PFMove newLockMove:lockedMove];
    lockMove.moveNumber = [self.moves count];
    [self.moves addObject:lockMove];
}

-(void) newSwitchMove:(PFMove *) switched forWord:(NSString *) word
{
    PFMove *switchMove = [PFMove newSwitchMove:word onMove:switched];
    switchMove.moveNumber = [self.moves count];
    [self.moves addObject:switchMove];
}

-(void) saveGame
{
    [self saveInBackground];
    for(PFMove *move in self.moves){
        [move saveInBackground];
    }
}

-(NSArray *) getMovesInOrder
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"moveNumber"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [self.moves sortedArrayUsingDescriptors:sortDescriptors];
}

+(void) loadActive:(BOOL)active GamesWithBlock:(void(^)(NSArray *array, NSError *error))block
{
    PFQuery *gameQuery = [PFQuery queryWithClassName:@"PFGame"];
    [gameQuery whereKey:@"active" equalTo:[NSNumber numberWithBool:active]];
    [gameQuery includeKey:@"player"];
    [gameQuery includeKey:@"owner"];
    
    [gameQuery findObjectsInBackgroundWithBlock:block];
}

+(void) loadGame:(PFGame *)game WithBlock:(void(^)(PFGame *game, NSError *error))block
{
    PFQuery *gameQuery = [PFQuery queryWithClassName:@"PFGame"];
    [gameQuery whereKey:@"objectId" equalTo:game.objectId];
    [gameQuery includeKey:@"moves"];
    [gameQuery includeKey:@"player"];
    [gameQuery includeKey:@"owner"];
    
    [gameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *firstError) {
        
        if(firstError){
            NSLog(@"%@", firstError);
            block(nil, firstError);
        } else {
            block([objects objectAtIndex:0], nil);
        }
        
    }];
}

+(NSString *)parseClassName
{
    return @"PFGame";
}

@end
