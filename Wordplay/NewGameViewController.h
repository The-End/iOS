//
//  NewGameViewController.h
//  Wordplay
//
//  Created by Blake Martin on 3/29/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PFGame.h"
#import "InGameViewController.h"

@interface NewGameViewController : UIViewController <UITextFieldDelegate>
{
    NSString *gameName;
    NSString *firstMove;
}

@property NSString * selectedFriendFacebookId;
@property PFGame * game;

@property (weak, nonatomic) IBOutlet UITextField *gameNameField;
@property (weak, nonatomic) IBOutlet UITextField *gameMoveField;

- (IBAction)createGame:(id)sender;

@end
