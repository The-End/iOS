//
//  LoginController.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

- (void)loadUserData;

@end

@implementation LoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)fabookLoginButton:(id)sender
{

    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me",
                                   @"user_relationships",
                                   @"user_birthday",
                                   @"user_location",
                                   @"friends_likes"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            NSLog(@"%@", user.username);
            NSLog(@"YEPPPP");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)loadUserData
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            User *user = [User createNewUser: context];
            
            [user setFacebookId: userData[@"id"]];
            [user setBirthday: userData[@"birthday"]];
            [user setUsername: userData[@"name"]];
            [user setMainUser: [NSNumber numberWithBool:YES]];
            [user save: context];
            
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
