//
//  PFMove.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface PFMove : PFObject<PFSubclassing>

@property PFUser *player;
@property NSDate *time;
@property int moveNumber;
@property NSString * type;
@property NSString * word;
@property PFMove * affectedMove;

+(PFMove *) newCreateMove:(NSString *) word;

+(PFMove *) newDeleteMove:(PFMove *) affectedId;

+(PFMove *) newInsertMove:(NSString *) word beforeId:(PFMove *) beforeId;

+(PFMove *) newInsertMove:(NSString *) word afterId:(PFMove *) afterId;

+(PFMove *) newLockMove:(PFMove *) affectedId;

+(PFMove *) newSwitchMove:(NSString *) word onMove:(PFMove *) affectedId;

+(NSString * )parseClassName;

@end
