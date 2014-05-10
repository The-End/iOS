//
//  FBFriendsViewController.m
//  Wordplay
//
//  Created by Blake Martin on 4/20/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "FBFriendsViewController.h"
#import "AppDelegate.h"
#import "NewGameViewController.h"

@interface FBFriendsViewController () <FBFriendPickerDelegate>{


    NSMutableArray *SelectedFriendsID;

}
@end

@implementation FBFriendsViewController

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
    self.friendPickerController = [[FBFriendPickerViewController alloc] init];
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
    [super viewDidUnload];
    
    self.friendPickerController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
     
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUserExtraFields>)user{
    return YES;
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
    [self dismissViewControllerAnimated:NO completion:NULL];
        
    
    
}

@end
