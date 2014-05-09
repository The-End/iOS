//
//  FBFriendPickerAppInstalled.h
//  Wordplay
//
//  Created by Blake Martin on 4/30/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FriendProtocols.h"
#import "NewGameViewController.h"

@interface FBFriendPickerAppInstalled : FBFriendPickerViewController

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUserExtraFields>)user;
- (void) friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

@end
