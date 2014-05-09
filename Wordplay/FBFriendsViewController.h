//
//  FBFriendsViewController.h
//  Wordplay
//
//  Created by Blake Martin on 4/20/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FriendProtocols.h"


@interface FBFriendsViewController : FBFriendPickerViewController

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUserExtraFields>)user;
- (void) friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;


@end

