//
//  DBGame.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBPlayerMove, User;

@interface DBGame : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * pointsPerMove;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) NSSet *players;
@property (nonatomic, retain) NSSet *playerMoves;
@end

@interface DBGame (CoreDataGeneratedAccessors)

- (void)addPlayersObject:(User *)value;
- (void)removePlayersObject:(User *)value;
- (void)addPlayers:(NSSet *)values;
- (void)removePlayers:(NSSet *)values;

- (void)addPlayerMovesObject:(DBPlayerMove *)value;
- (void)removePlayerMovesObject:(DBPlayerMove *)value;
- (void)addPlayerMoves:(NSSet *)values;
- (void)removePlayerMoves:(NSSet *)values;

@end
