//
//  InGameViewController.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 5/10/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "InGameViewController.h"

@interface InGameViewController ()

@end

@implementation InGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appEnteredBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pointsLeft = 16;
    
    [PFGame loadGame:game WithBlock:^(PFGame *foundGame, NSError *error){
        if(error){
            //do something
        } else {
            game = foundGame;
            [self showGame];
        }
    }];
    
    currentStringHeight = 0;
    currentStringLength = 0;
    [self setupViewElements];
    [self registerForKeyboardNotifications];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    if(animated){
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.80];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        
        [UIView commitAnimations];
    }
}

-(void)appEnteredBackground
{
    
}

- (IBAction)submitButton:(id)sender {
}

-(void)showGame
{
    [self makeButtonsFromGame];
    
    for(CustomButton *button in buttons){
        [button addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.parentView addSubview:button];
    }
    
}

-(void)refreshGame
{
    
    NSString *pointsRemaining = [NSString stringWithFormat: @"You have %i points remaining this round", pointsLeft];
    [self.pointsLeftLabel setText:pointsRemaining];
    
    currentStringLength = 0;
    currentStringHeight = 0;
    
    for(CustomButton *button in buttons){
        [button removeFromSuperview];
    }
    
    [self showGame];
}

-(void)buttonMethod:(id)sender
{
    
}

-(void)makeButtonsFromGame
{
    
    NSArray *moves = [game getMovesInOrder];
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    
    PFUser *currentUser = [PFUser currentUser];
    UIColor *myColor = [UIColor greenColor];
    UIColor *theirColor = [UIColor redColor];
    for(PFMove *move in moves){
        
        if([move.type isEqualToString:@"CREATE"]){
            
            CustomButton *button = [self makeButtonWithWord:move.word];
            button.move = move;
            if([currentUser.objectId isEqualToString:move.player.objectId]){
                [button setTitleColor:myColor forState:UIControlStateNormal];
            } else {
                [button setTitleColor:theirColor forState:UIControlStateNormal];
            }
            [buttonsArray addObject:button];
            
        } else if([move.type isEqualToString:@"INSERT_BEFORE"]){
            
        } else if([move.type isEqualToString:@"INSERT_AFTER"]){
            
        } else if([move.type isEqualToString:@"SWITCH"]){
            
        } else if([move.type isEqualToString:@"LOCK"]){
            
        } else if([move.type isEqualToString:@"DELETE"]){
            
        }
        
    }
    
    buttons = buttonsArray;
}

-(CustomButton *)makeButtonWithWord:(NSString *)word
{
    CustomButton *button = [[CustomButton alloc] init];
    [button setTitle:word forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    CGSize stringSize = [word sizeWithFont:[UIFont systemFontOfSize:14]];
    
    float x = 0.0;
    if(stringSize.width + currentStringLength + 3 <= self.parentView.frame.size.width){
        x = currentStringLength + ((currentStringLength == 0) ? 0 : 3);
        currentStringLength = x + stringSize.width;
    } else {
        currentStringHeight++;
        currentStringLength = stringSize.width;
    }
    
    float y = (stringSize.height + 5) * currentStringHeight;
    
    button.frame = CGRectMake(x, y, stringSize.width, stringSize.height);
    
    return button;
}

-(void)updateScore
{
    [self.pointsLeftView setText:[NSString stringWithFormat: @"You have %i points remaining this round", pointsLeft]];
}

-(void)giveGame:(PFGame *)newGame
{
    game = newGame;
}

-(void)setupViewElements
{
    CGRect pointsFrame = CGRectMake(0.0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 60);
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:pointsFrame];
    [pointsLabel setBackgroundColor:[UIColor orangeColor]];
    NSString *pointsRemaining = [NSString stringWithFormat: @"You have %i points remaining this round", pointsLeft];
    [pointsLabel setText:pointsRemaining];
    self.pointsLeftLabel = pointsLabel;
    [self.view addSubview:pointsLabel];
    
    CGRect scrollFrame = CGRectMake(10, self.navigationController.navigationBar.frame.size.height + pointsFrame.size.height, self.view.frame.size.width - 20, self.view.frame.size.height - 40);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: scrollView];
    self.parentView = scrollView;
    
    CGRect textParentFrame = CGRectMake(0.0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
    UIView *textParent = [[UIView alloc] initWithFrame:textParentFrame];
    [textParent setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:textParent];
    self.parentViewOfText = textParent;
    
    CGRect textRect = CGRectMake(10.0, 0.0, self.view.frame.size.width - 20, textParentFrame.size.height);
    UITextField *inputText = [[UITextField alloc] initWithFrame:textRect];
    [inputText setBackgroundColor:[UIColor whiteColor]];
    [inputText setAlpha:0.5];
    [self.parentViewOfText addSubview:inputText];
    self.inputTextField = inputText;
    [self.inputTextField setDelegate:self];
    [self.inputTextField setPlaceholder:@"Add new word!"];

}

- (void) animateUp:(BOOL)up
{
    const float movementDuration = 0.15f;
    
    int movement = (up ? - heightOfKeyboard : heightOfKeyboard);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.parentViewOfText.frame = CGRectOffset(self.parentViewOfText.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *word = textField.text;
    if(![word isEqualToString:@""]){
        pointsLeft -= 4;
        [game newCreateMoveWithWord:word];
        [self refreshGame];
    }
    [textField setText:@""];
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize sizeOfKeyboard = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    heightOfKeyboard = sizeOfKeyboard.height;
    [self animateUp:YES];

}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [self animateUp:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
