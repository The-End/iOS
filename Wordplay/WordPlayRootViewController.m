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
    NSMutableArray *VCs = [self.navigationController.viewControllers mutableCopy];
    [VCs removeObjectAtIndex:[VCs count] - 2];
    self.navigationController.viewControllers = VCs;
    [super viewDidLoad];
    FBLoginView *loginView2 = [[FBLoginView alloc] init];
    [self.view addSubview:loginView2];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
