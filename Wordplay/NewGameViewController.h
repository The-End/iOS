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

@interface NewGameViewController : UIViewController //<UITextFieldDelegate>
 
@property NSString * selectedFriendFacebookId;
@property (strong) PFGame * game;
@property (weak, nonatomic) IBOutlet UITextField *gameNameField;
@property (weak, nonatomic) IBOutlet UITextField *firstMoveField;
- (IBAction)gameNameField:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *gameFirstMove;

- (IBAction)sendData:(id)sender;

@end
