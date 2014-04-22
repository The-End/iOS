//
//  LoginController.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "LoginController.h"
#import "WordPlayRootViewController.h"

@interface LoginController ()

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
    // Do any additional setup after loading the view.
    
    facebook = [[FBLoginView alloc] init];
    facebook.readPermissions = @[@"basic_info", @"email"];
    facebook.delegate = self;
    firstLogin = YES;
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
    if (firstLogin) {
   
    //UINavigationController *navController = self.navigationController;
    //[navController popViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"transition" sender:nil];
        firstLogin = NO;
        NSLog(@"Poop");
    }
    //self.profilePictureView.profileID = user.id;
    //self.nameLabel.text = user.name;
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
