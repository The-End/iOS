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
     NSLog(@"STEP 2");
    moves = [[NSMutableArray alloc] init];
    [moves addObject:@"Delete"];
    [moves addObject:@"Lock"];
    [moves addObject:@"Change"];
    [moves addObject:@"Insert After"];
    [moves addObject:@"Insert Before"];
    [moves addObject:@"Close"];
    
    //FBRequest *request = [FBRequest requestForGraphPath:@"/me/friends?fields=installed"];
    
    NSString *testString = [NSString stringWithFormat:@"This is a test string for our app This is a test string for our app This is a test string for our app"];
    NSArray *testArray = [testString componentsSeparatedByString: @" "];
    NSMutableArray *test = [testArray mutableCopy];
    NSMutableArray *locked = [[NSMutableArray alloc] init];
    for (int i = 0; i < testArray.count; i++) {
        if (i % 2) {
            [locked addObject:@"locked"];
        }
        else {
        
            [locked addObject:@"npot"];
        }
    }
    [self displaySentencefromArray:test withMoves: locked];

    [self createGame];

    _gameNameField.placeholder = @"Game Name";
    _firstMoveField.placeholder = @"Your Move";
//    _gameNameField.delegate = self;
//    _firstMoveField.delegate = self;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)gameFirstMove:(id)sender
{
    
    if ([_firstMoveField.text isEqualToString:@""]){
        return;
    }
    
    NSLog(@"%@", _firstMoveField.text);
    
    [_game newCreateMoveWithWord: _firstMoveField.text];
    [_game saveGame];
    
}
- (IBAction)gameNameField:(id)sender
{

    if ([_gameNameField.text isEqualToString:@""]){
        return;
    }
    
    _game.name = _gameNameField.text;

    
}
@end
