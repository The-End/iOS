//
//  User.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/23/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>


@implementation User

@dynamic mainUser;
@dynamic username;
@dynamic facebookId;
@dynamic birthday;


- (void) setUsername:(NSString *)username
{
    [self willChangeValueForKey:@"username"];
    [self setPrimitiveValue:username forKey:@"username"];
    [self didChangeValueForKey:@"username"];
    
    [[PFUser currentUser] setUsername: username];
}

- (void) setFacebookId:(NSString *)facebookId
{
    [self willChangeValueForKey:@"facebookId"];
    [self setPrimitiveValue:facebookId forKey:@"facebookId"];
    [self didChangeValueForKey:@"facebookId"];
    
    [[PFUser currentUser] setValue: facebookId forKey:@"id"];
}

- (void) setBirthday:(NSString *)birthday
{
    [self willChangeValueForKey:@"birthday"];
    [self setPrimitiveValue:birthday forKey:@"birthday"];
    [self didChangeValueForKey:@"birthday"];
    
    [[PFUser currentUser] setValue: birthday forKey: @"birthday"];
}

- (void) save:(NSManagedObjectContext *) context
{
    [[PFUser currentUser] saveInBackground];
    
    NSError *error;
    if (![context save:&error]) NSLog(@"ERROR saving: %@", [error localizedDescription]);
}

+ (User *) loadMainUser:(NSManagedObjectContext *)context
{
    NSFetchRequest *userFetch = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mainUser == %@", [NSNumber numberWithBool:YES]];
    
    [userFetch setPredicate:predicate];
    [userFetch setEntity: entity];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:userFetch error:&error];
    
    if([results count] == 0){
        NSLog(@"No users found, returning nil");
        return nil;
    }
    
    NSLog(@"User found, returning user");
    return [results objectAtIndex:0];
}

+ (User *) createNewUser:(NSManagedObjectContext *) context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
}

+ (void) deleteMainUser:(NSManagedObjectContext *) context
{
    [context deleteObject: [User loadMainUser: context]];
    
    NSError *error;
    if (![context save:&error]) NSLog(@"ERROR saving: %@", [error localizedDescription]);
}

@end
