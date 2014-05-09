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

@interface PFGame : PFObject<PFSubclassing>

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) PFUser * owner;
@property (nonatomic, retain) NSSet * playerMoves;
@property (nonatomic, retain) NSSet * players;

+(NSString *)parseClassName;

@end
