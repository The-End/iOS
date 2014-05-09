//
//  LoginController.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "User.h"
#import "WordPlayMasterViewController.h"

@interface LoginController : UIViewController

- (IBAction)fabookLoginButton:(id)sender;

@end
