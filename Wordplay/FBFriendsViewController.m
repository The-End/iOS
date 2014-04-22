//
//  FBFriendsViewController.m
//  Wordplay
//
//  Created by Blake Martin on 4/20/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "FBFriendsViewController.h"
#import "AppDelegate.h"

@interface FBFriendsViewController ()

@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

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
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
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

@end
