//
//  PFPlayerMove.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import <Parse/PFObject+Subclass.h>

@interface PFPlayerMove : PFObject<PFSubclassing>

@property NSArray *moves;
@property User *player;
@property int moveNumber;
@property NSDate *time;

+ (NSString * )parseClassName;

@end
