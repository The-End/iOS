//
//  PFPlayerMove.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFUser.h>
#import <Parse/PFObject+Subclass.h>
#import "PFMove.h"

@interface PFPlayerMove : PFObject<PFSubclassing>

@property NSMutableArray *moves;
@property PFUser *player;
@property int moveNumber;
@property NSDate *time;

- (void) giveMove:(PFMove *) move;

- (void) saveMoves;

+ (NSString * )parseClassName;

@end
