//
//  NewGameViewController.m
//  Wordplay
//
//  Created by Blake Martin on 3/29/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "customButton.h"
#import "NewGameViewController.h"
#import "FBFriendPickerAppInstalled.h"
#import "WordPlayRootViewController.h"

@interface NewGameViewController ()

-(void) createGame;

@end

@implementation NewGameViewController

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
    
    [self createGame];	

    _gameNameField.placeholder = @"Game Name";
    _gameNameField.delegate = self;
    _gameMoveField.placeholder = @"First Move";
    _gameMoveField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)createGame
{
    _game = [PFGame object];
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"facebookId" equalTo: _selectedFriendFacebookId];
    [userQuery findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error){
        
        if([objects count] != 1){
            NSLog(@"Wrong size returned: %lu", (unsigned long)[objects count]);
        } else {
            NSLog(@"Object: %@", [[objects objectAtIndex:0] class]);
            PFUser * friend = [objects objectAtIndex:0];
            [_game setupNewGameWithPlayer:friend];
        }
        
    }];
}

- (IBAction)createGame:(id)sender
{
    [self gameFinishedCreating];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self gameFinishedCreating];
    return YES;
}

-(void)gameFinishedCreating
{
    gameName = _gameNameField.text;
    firstMove = _gameMoveField.text;
    
    NSArray *move = [firstMove componentsSeparatedByString:@" "];
    if([move count] > 4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too much word"
                                                        message:@"You can only add up to four words."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    if([gameName isEqualToString:@""]){
        return;
    } else if([firstMove isEqualToString:@""]){
        return;
    }
    
    _game.name = gameName;
    for(NSString *word in move){
        [_game newCreateMoveWithWord:word];
    }
    [_game saveGame];
    
    InGameViewController *gameController = [self.storyboard instantiateViewControllerWithIdentifier:@"InGameViewController"];
    [gameController giveGame:_game];
    [self.navigationController pushViewController:gameController animated:YES];
    
    NSLog(@"Pushed onto stack");
    
    NSMutableArray* navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [navArray removeObjectAtIndex:1];
    [self.navigationController setViewControllers:navArray animated:NO];
    
    NSLog(@"Removed from stack");
    
    return;
}

@end
