//
//  Round.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 3/29/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>

@interface Round : PFObject<PFSubclassing>
+ (NSString *) parseClassName;
@property (retain) NSString *displayName;

@end
