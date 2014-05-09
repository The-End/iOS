//
//  WordPlayRootViewController.m
//  Wordplay
//
//  Created by Blake Martin on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "WordPlayRootViewController.h"
#import "NewGameViewController.h"
#import <FacebookSDK/FacebookSDK.h>



@interface WordPlayRootViewController ()  <FBFriendPickerDelegate>{

    NSArray *selectedFriends;
    BOOL newGameButtonSelected;
 

}
@end

@implementation WordPlayRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(![PFUser currentUser]){
        [self performSegueWithIdentifier:@"goToLoginController" sender:nil];
    } else {
        
        
        
        NSURL *profileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", user.facebookId]];
        
        profilePictureData = [[NSMutableData alloc] init];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:profileUrl
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)InviteFriends:(id)sender {
    
    newGameButtonSelected = NO;
    
    self.friendPickerController = [[FBFriendPickerViewController alloc] init];
    self.friendPickerController.title = @"Invite Friends";
    self.friendPickerController.delegate = self;
    self.friendPickerController.allowsMultipleSelection = YES;
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    [self presentViewController:self.friendPickerController animated:YES completion:nil];
    
    
    
}

- (IBAction)NewGame:(id)sender {
    
    newGameButtonSelected = YES;
    NSLog(@" %s", newGameButtonSelected ? "true" : "false");
    
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

- (IBAction)LogOutButtonAction:(id)sender {
    
    [PFUser logOut];
    [User deleteMainUser: context];
    
    [self performSegueWithIdentifier:@"goToLoginController" sender:nil];
    
}


- (void) friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker{
    
  }

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSLog(@" %s", newGameButtonSelected ? "true" : "false");
    if (self.friendPickerController.selection.count == 0 && !newGameButtonSelected){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Friend Selected"
                                                        message:@"You must either select a friend to invite to play WordPlay or press Cancel."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.friendPickerController.selection.count == 0 && newGameButtonSelected){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Friend Selected"
                                                        message:@"You must select a friend to play against."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // Dismiss the friend picker
    
    if (!newGameButtonSelected) {
        
    
        NSMutableString *text = [[NSMutableString alloc] init];
    

        for (id<FBGraphUser> user in self.friendPickerController.selection) {
            if ([text length]) {
                [text appendString:@", "];
            }
            [text appendString:user.name];
        }
        NSString *message = [NSString stringWithFormat:@"The following friends were invited to join the Wordplay Community: %@", text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Friends Successfully Invited"
                                                    message:message                                                 delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
        [[sender presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (newGameButtonSelected){
    
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (id<FBGraphUser> user in self.friendPickerController.selection) {
            [temp addObject:user];
            }
        selectedFriends = temp;
        NSLog(@"DONE BUTTON");
        NSLog(@"Selected friends: %@", selectedFriends);
        [[sender presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        [self goToNewGame];
    
    }
    
    
}

/*
 * Event: Cancel button clicked
 */
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    NSLog(@"Canceled");
    // Dismiss the friend picker
    [[sender presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUserExtraFields>)user
{
    if (newGameButtonSelected) {
        
    
        BOOL installed = [user objectForKey:@"installed"] != nil;
    
        return installed;
    }
    return YES;
}





-(void) goToNewGame{
    
    NewGameViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"NewGameViewController"];
    temp.selectedFriendsNewGame = selectedFriends;
    NSLog(@"Selected friends: %@", temp.selectedFriendsNewGame);

    [self.navigationController pushViewController:temp animated:YES];
    
}


@end
