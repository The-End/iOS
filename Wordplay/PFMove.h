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

@property NSString * type;
@property NSString * word;
@property NSString * affectedId;

+(PFMove *) newCreateMove:(NSString *) word;

+(PFMove *) newDeleteMove:(NSString *) affectedId;

+(PFMove *) newInsertMove:(NSString *) word afterId:(NSString *) afterId;

+(PFMove *) newLockMove:(NSString *) affectedId;

+(PFMove *) newSwitchMove:(NSString *) word onMove:(NSString *) affectedId;

+(NSString * )parseClassName;

@end
