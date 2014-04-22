//
//  WordPlayRootViewController.m
//  Wordplay
//
//  Created by Blake Martin on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "WordPlayRootViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface WordPlayRootViewController ()

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
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogOutButtonAction:(id)sender {
    
    [PFUser logOut];
    
    [self performSegueWithIdentifier:@"goToLoginController" sender:nil];
    
}
@end
