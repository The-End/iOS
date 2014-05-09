//
//  User.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/24/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * facebookId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * mainUser;


- (void) setUsername:(NSString *)username;
- (void) setFacebookId:(NSString *)facebookId;
- (void) setBirthday:(NSString *)birthday;
- (void) save:(NSManagedObjectContext *) context;

+ (User *) loadMainUser:(NSManagedObjectContext *) context;
+ (User *) createNewUser:(NSManagedObjectContext *) context;
+ (void) deleteMainUser:(NSManagedObjectContext *) context;

@end
