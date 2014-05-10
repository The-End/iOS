//
//  PastGamesViewController.m
//  Wordplay
//
//  Created by Blake Martin on 3/29/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PastGamesViewController.h"

@interface PastGamesViewController ()

@end

@implementation PastGamesViewController

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
    
    [PFGame loadActive:YES GamesWithBlock:^(NSArray *array, NSError *error){
        
        if(!error){
            
            PFGame *game = [array objectAtIndex: 0];
            
            [PFGame loadGame:game WithBlock:^(PFGame *foundGame, NSError *newError){
                if(!newError){
                    NSLog(@"%@", foundGame);
                }
            }];
            
        }
        
    }];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
