//
//  FriendProtocols.h
//  Wordplay
//
//  Created by Blake Martin on 4/24/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol FBGraphUserExtraFields <FBGraphUser>

@property (nonatomic, retain) NSArray *devices;

@end