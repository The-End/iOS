//
//  FBFriendPickerAppInstalled.m
//  Wordplay
//
//  Created by Blake Martin on 4/30/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "FBFriendPickerAppInstalled.h"

@interface FBFriendPickerAppInstalled ()<FBFriendPickerDelegate>{
    
    
    NSMutableArray *SelectedFriendsID;
    
}
@end

@implementation FBFriendPickerAppInstalled
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
    NSLog(@"Got Here");
    self.friendPickerController = [[FBFriendPickerAppInstalled alloc] init];
    self.friendPickerController.title = @"Pick Friends";
    self.friendPickerController.delegate = self;
    self.friendPickerController.allowsMultipleSelection = NO;
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    NSSet *fields = [NSSet setWithObjects:@"installed", nil];
    self.friendPickerController.fieldsForRequest = fields;
    
    
    [self presentViewController:self.friendPickerController animated:YES completion:nil];
    
}

- (void)viewDidUnload {
    self.friendPickerController = nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUserExtraFields>)user
{
    
    BOOL installed = [user objectForKey:@"installed"] != nil;
    
    return installed;
}
- (void) friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker{
    
    
    SelectedFriendsID = [[NSMutableArray alloc]init];
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        [SelectedFriendsID addObject:user.id];
        NSLog(@"Friend selected: %@", user.id);
    }
    NSLog(@"my friends are %@", SelectedFriendsID);
    
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    if (self.friendPickerController.selection.count == 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Friend Selected"
                                                        message:@"You must select a friend to play against in Wordplay."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    FBFriendPickerViewController *friendPickerController =
    (FBFriendPickerViewController*)sender;
    NSLog(@"Selected friends: %@", friendPickerController.selection);
    // Dismiss the friend picker
    [[sender presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

/*
 * Event: Cancel button clicked
 */
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    NSLog(@"Canceled");
    // Dismiss the friend picker
    [[sender presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
}

@end

