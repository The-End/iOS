//
//  WordPlayRootViewController.h
//  Wordplay
//
//  Created by Blake Martin on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginController.h"
#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FriendProtocols.h"
#import "GameListViewController.h"

@interface WordPlayRootViewController : UIViewController <FBFriendPickerDelegate>
- (IBAction)InviteFriends:(id)sender;
- (IBAction)NewGame:(id)sender;

- (IBAction)LogOutButtonAction:(id)sender;

@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
-(void) goToNewGame;
- (IBAction)pastGamesButtonPushed:(id)sender;
- (IBAction)activeGamesButtonPushed:(id)sender;

@end