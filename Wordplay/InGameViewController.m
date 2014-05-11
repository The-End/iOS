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
    turnEnding = NO;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Finish Turn" style:UIBarButtonItemStylePlain target:self action:@selector(changeTurnPopup:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    currentStringHeight = 0;
    currentStringLength = 0;
    [self setupViewElements];
    [self registerForKeyboardNotifications];
    
    moveTypes = [[NSMutableArray alloc] init];
    [moveTypes addObject:@"Delete"];
    [moveTypes addObject:@"Lock"];
    [moveTypes addObject:@"Change"];
    [moveTypes addObject:@"Insert Before"];
    [moveTypes addObject:@"Insert After"];
    [moveTypes addObject:@"Close"];
    textInputUp = YES;
    inputType = [NSString stringWithFormat:@"Create"];
    
    [PFGame loadGame:game WithBlock:^(PFGame *foundGame, NSError *error){
        if(error){
            //do something
        } else {
            game = foundGame;
            myTurn = [game isMyTurn];
            [self setupViewElements];
            [self refreshGame];
        }
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
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
    
    [self changeTurn:NO];
    [game saveGame];
}

-(void)appEnteredBackground
{
    
}

- (IBAction)submitButton:(id)sender {
}

-(void)showGame
{
    buttons = [[NSArray alloc] init];
    [self makeButtonsFromGame];
    
    for(CustomButton *button in buttons){
        [button addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.parentView addSubview:button];
    }
    
    if(game.active && buttons.count >= 2){
        CustomButton *secondToLastButton = [buttons objectAtIndex:[buttons count] - 2];
        CustomButton *lastButton = [buttons objectAtIndex:[buttons count] - 1];
        if([secondToLastButton.move.word caseInsensitiveCompare:@"the"] == NSOrderedSame && [lastButton.move.word caseInsensitiveCompare:@"end"] == NSOrderedSame){
            game.active = NO;
            [game saveGame];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The End"
                                                            message:@"Ya done did it."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self refreshGame];
        }
    }
    
}

-(void)refreshGame
{
    [game saveGame];
    
    currentStringLength = 0;
    currentStringHeight = 0;
    
    for(CustomButton *button in buttons){
        [button removeFromSuperview];
    }
    
    
    if(pointsLeft < 4 && [game isMyTurn]){
        [self changeTurn:NO];
        [self setupViewElements];
    }
    
    NSString *announcement;
    if(!game.active){
        announcement = @"The End";
        pointsLeft = 0;
    } else if(myTurn){
        announcement = [NSString stringWithFormat: @"You have %i points remaining this round", pointsLeft];
    } else {
        PFUser *me =[PFUser currentUser];
        if([me.objectId isEqualToString:game.owner.objectId]){
            announcement = [NSString stringWithFormat:@"It's %@\'s turn", game.player[@"name"]];
        } else {
            announcement = [NSString stringWithFormat:@"It's %@\'s turn", game.owner[@"name"]];
        }
    }
    
    [self.pointsLeftLabel setText:announcement];
    
    [self showGame];
}

-(void)buttonMethod:(id)sender
{
    if (selectedButton == sender) {
        return;
    }
    
    [self.inputTextField resignFirstResponder];
    
    if (![inputType isEqualToString:@"Create"]) {
        inputType = @"Create";
        [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Add up to %i words!", pointsLeft/4]];
    }
    
    UIScrollView *optionsMenu;
    CustomButton *selected = (CustomButton *)sender;
    buttonForAlertView = selected;
    
    BOOL needToHideTextBox = YES;
    for (CustomButton *button in buttons) {
        if (button.pressed == YES) {
            [button.associatedView removeFromSuperview];
            button.pressed = NO;
            needToHideTextBox = NO;
            break;
        }
    }
    selected.pressed = YES;
    
    if(!myTurn || selected.locked){
        return;
    }
    NSLog(@"NeedToHideTextBox: %d", needToHideTextBox);
    if(needToHideTextBox){
        NSLog(@"NeedToHideTextBox: %d", needToHideTextBox);
        [self textBoxAnimateUp:NO];
    }
    
    selectedButton = sender;
    
    NSString *longest = @"Insert Before";
    CGSize longestSize = [longest sizeWithFont:[UIFont systemFontOfSize:15]];
    
    if ((selected.frame.origin.x + longestSize.width) > (self.parentView.frame.origin.x + self.parentView.frame.size.width)){
        optionsMenu = [[UIScrollView alloc] initWithFrame:CGRectMake((self.parentView.frame.size.width - (longestSize.width+10)),(selected.frame.origin.y + selected.frame.size.height),longestSize.width + 10,(moveTypes.count*longestSize.height + (moveTypes.count + 1)*5))];
        
    } else {
        optionsMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(selected.frame.origin.x,(selected.frame.origin.y + selected.frame.size.height),longestSize.width + 10,(moveTypes.count*longestSize.height + (moveTypes.count + 1)*5))];
    }
    
    [optionsMenu setBackgroundColor:[UIColor lightGrayColor]];
    
    for (int i = 0; i < moveTypes.count; i++){
        
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(activitySelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[moveTypes objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        CGSize stringsize = [[moveTypes objectAtIndex: i] sizeWithFont:[UIFont systemFontOfSize:15]];
        
        
        button.frame = CGRectMake(5, (5+i*23), stringsize.width, stringsize.height);
        [button setBackgroundColor:[UIColor whiteColor]];
        button.numberInSentence = selected.numberInSentence;
        button.word = selected.titleLabel.text;
        
        [optionsMenu addSubview:button];
    }
    
    [self.parentView addSubview:optionsMenu];
    selected.associatedView = optionsMenu;
    
}

-(void) activitySelected:(id)sender{
    
    CustomButton *selected = (CustomButton *)sender;
    actionAfterAlertView = selected.titleLabel.text;
    
    if ([selected.titleLabel.text isEqualToString:@"Lock"] && pointsLeft/7 != 0){
        
        
        NSMutableString *text = [[NSMutableString alloc] init];
        [text appendString:@"Are you sure you want to lock the word \""];
        [text appendString:selected.word];
        [text appendString:@"\"?"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        [alert show];
        
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Delete"] && pointsLeft/10 != 0){
        
        NSMutableString *text = [[NSMutableString alloc] init];
        [text appendString:@"Are you sure you want to delete the word \""];
        [text appendString:selected.word];
        [text appendString:@"\"?"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
        [alert show];
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Insert Before"] && pointsLeft/5 != 0){
        inputType = @"Insert Before";
        [self.inputTextField becomeFirstResponder];
        self.inputTextField.placeholder = [NSString stringWithFormat:@"Insert a word before \"%@\"...", selected.word];
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Insert After"] && pointsLeft/5 != 0){
        inputType = @"Insert After";
        [self.inputTextField becomeFirstResponder];
        self.inputTextField.placeholder = [NSString stringWithFormat:@"Insert a word after \"%@\"...", selected.word];
        }
    if ([selected.titleLabel.text isEqualToString:@"Change"] && pointsLeft/15 != 0){
        inputType = @"Change";
        [self.inputTextField becomeFirstResponder];
        self.inputTextField.placeholder = [NSString stringWithFormat:@"Change \"%@\" to...", selected.word];
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Delete"] && pointsLeft/10 == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You do not have enough points to delete \"%@\"", selected.word]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Insert Before"] && pointsLeft/5 == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You do not have enough points to insert a word before \"%@\"", selected.word ]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Insert After"] && pointsLeft/5 == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You do not have enough points to insert a word after \"%@\"", selected.word ]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Change"] && pointsLeft/15 == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You do not have enough points to change \"%@\".", selected.word ]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Lock"] && pointsLeft/7 == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"You do not have enough points to lock \"%@\".", selected.word ]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    selectedButton.pressed = NO;
    [self textBoxAnimateUp:YES];
    textInputUp = YES;
    [selected.superview removeFromSuperview];
    selectedButton = nil;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(turnEnding){
        if(buttonIndex == [alertView cancelButtonIndex]) {
            [self changeTurn:YES];
        } else {
            turnEnding = NO;
        }
    }
    
    if ([actionAfterAlertView isEqualToString:@"Delete"] && pointsLeft/10 != 0){
        if (buttonIndex == [alertView cancelButtonIndex]){
            pointsLeft -= 10;
            [game newDeleteMove:buttonForAlertView.move];
            [self refreshGame];
        }
    }
    
    if([actionAfterAlertView isEqualToString:@"Change"]){
        
    
    }
    
    if([actionAfterAlertView isEqualToString:@"Insert Before"]){
        

    }
    
    if([actionAfterAlertView isEqualToString:@"Insert After"]){
        

    }
    
    if([actionAfterAlertView isEqualToString:@"Lock"] && buttonIndex == [alertView cancelButtonIndex] && pointsLeft/7 != 0){
        
        pointsLeft -= 7;
        [game newLockMove:buttonForAlertView.move];
        [self refreshGame];
    }
    inputType =@"Create";
    self.inputTextField.placeholder =[NSString stringWithFormat:@"Add up to %i words!", pointsLeft/4];
    if (!textInputUp){
        [self textBoxAnimateUp:YES];
        textInputUp = YES;
    }
}

-(void)makeButtonsFromGame
{
    
    NSArray *moves = [game getMovesInOrder];
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    
    PFUser *currentUser = [PFUser currentUser];
    UIColor *myColor = [UIColor colorWithRed:0.238 green:0.686 blue:0.891 alpha:1.000];
    UIColor *theirColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    
    
    NSMutableArray *displayedMoves = [[NSMutableArray alloc] init];
    for(PFMove *move in moves){
        if([move.type isEqualToString:@"CREATE"]){
            [displayedMoves addObject:move];
        } else if([move.type isEqualToString:@"INSERT_BEFORE"]){
            
            int index = [self getIndexOfMove:move.affectedMove inArray:displayedMoves];
            [displayedMoves insertObject:move atIndex:index];
            
        } else if([move.type isEqualToString:@"INSERT_AFTER"]){
            
            int index = [self getIndexOfMove:move.affectedMove inArray:displayedMoves];
            [displayedMoves insertObject:move atIndex:index + 1];
            
        } else if([move.type isEqualToString:@"SWITCH"]){
            
            int index = [self getIndexOfMove:move.affectedMove inArray:displayedMoves];
            [displayedMoves removeObjectAtIndex:index];
            [displayedMoves insertObject:move atIndex:index];
            
        } else if([move.type isEqualToString:@"DELETE"]){
            
            int index = [self getIndexOfMove:move.affectedMove inArray:displayedMoves];
            [displayedMoves removeObjectAtIndex:index];
        }if([move.type isEqualToString:@"LOCK"]){
            
            [displayedMoves addObject:move];
        }
    }
    
    for(PFMove *move in displayedMoves){
        
        if([move.type isEqualToString:@"LOCK"]){
            CustomButton *button = [self findButtonInArray:buttonsArray WithMove:move.affectedMove];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.locked = YES;
        } else {
            CustomButton *button = [self makeButtonWithWord:move.word];
            button.move = move;
            if([currentUser.objectId isEqualToString:move.player.objectId]){
                [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundColor:myColor];
            } else {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundColor:theirColor];
                
            }
            [buttonsArray addObject:button];
        }
    }
    
    buttons = buttonsArray;
}

-(int)getIndexOfMove:(PFMove *)searchingFor inArray:(NSMutableArray *) array
{
    for(int i = 0; i < array.count; i++){
        PFMove *found = [array objectAtIndex:i];
        if([searchingFor.objectId isEqualToString:found.objectId]){
            NSLog(@"Searching for:%@\nFound:%@\nAt index:%i", searchingFor, found, i);
            return i;
        }
    }
    
    NSLog(@"Search failed: %@", searchingFor);
    
    return -1;
}

-(CustomButton *)findButtonInArray:(NSArray *)array WithMove:(PFMove *)move
{
    for(CustomButton *button in array){
        if([button.move.objectId isEqualToString:move.objectId]){
            return button;
        }
    }
    return nil;
}

-(CustomButton *)makeButtonWithWord:(NSString *)word
{
    CustomButton *button = [[CustomButton alloc] init];
    [button setTitle:word forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    CGSize stringSize = [word sizeWithFont:[UIFont systemFontOfSize:20]];
    
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
    [pointsLabel setBackgroundColor:[UIColor colorWithWhite:0.298 alpha:1.000]];
    [pointsLabel setTextColor:[UIColor whiteColor]];
    NSString *pointsRemaining = [NSString stringWithFormat: @"Loading Game"];
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
    
    if(myTurn){
        CGRect textRect = CGRectMake(10.0, 0.0, self.view.frame.size.width - 20, textParentFrame.size.height);
        UITextField *inputText = [[UITextField alloc] initWithFrame:textRect];
        [inputText setBackgroundColor:[UIColor whiteColor]];
        [inputText setAlpha:0.5];
        inputText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.parentViewOfText addSubview:inputText];
        self.inputTextField = inputText;
        [self.inputTextField setDelegate:self];
        [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Add up to %i words!", pointsLeft/4]];
    }

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

- (void) textBoxAnimateUp:(BOOL)up{

    const float movementDuration = 0.15f;
    
    int movement = (up ? - self.parentViewOfText.frame.size.height : self.parentViewOfText.frame.size.height);
    
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
    NSArray *temp = [word componentsSeparatedByString:@" "];
    NSLog(@"%@ HERE", inputType);
   
    if (temp.count > pointsLeft/4){
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Invalid Move. You cannot add more than %i words!", pointsLeft/4]
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        inputType = @"Create";
        [textField setText:@""];
        return YES;
    
    }
    if ([word isEqualToString:@""]) {
        if ([inputType isEqualToString:@"Change"]) {
            
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Move. Cannot change word to nothing! Duh!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
        
        }
        
        if ([inputType isEqualToString:@"Insert After"] || [inputType isEqualToString:@"Insert Before"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Move. You cannot insert nothing! Duh!"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            
            
        }
        
        
        inputType = @"Create";
        return YES;
    }
    
    if ([inputType isEqualToString:@"Create"]) {
     
        if([word isEqualToString:@""] || temp.count > pointsLeft/4 ){
            if ([word isEqualToString:@""]) {
           
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You must enter something! Duh!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
                [alert show];
            }
        
            if (temp.count > pointsLeft/4) {
                NSString *text = [NSString stringWithFormat:@"You only have enough points to add %i words!", pointsLeft/4];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
                [alert show];
            }
        
    
        }
        
        for (int i = 0; i < temp.count; i ++) {
            pointsLeft -= 4;
            [game newCreateMoveWithWord:[temp objectAtIndex:i]];
        }
    
    } else if ([inputType isEqualToString:@"Insert Before"]) {
        pointsLeft -= 5;
        [game newInsertWord:textField.text beforeMove:buttonForAlertView.move];
        
    }
    
    if ([inputType isEqualToString:@"Insert After"]) {
        pointsLeft -= 5;
        [game newInsertWord:textField.text afterMove:buttonForAlertView.move];
        
    }
    
    if ([inputType isEqualToString:@"Change"]) {
        pointsLeft -= 15;
        [game newSwitchMove:buttonForAlertView.move forWord:textField.text];

    }
    
    inputType = @"Create";
    [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Add up to %i words!", pointsLeft/4]];
    
    
    [self refreshGame];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string {
    
    if (![inputType isEqualToString:@"Create"]){
    NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
    NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
    if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound)      {
        return YES;
    }  else  {
        return NO;
    }
    }
    
    
    return YES;
}

-(void)changeTurnPopup:(id)selector
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Sure?"
                                                    message:@"You've got more points. This doesn't have to be the end."
                                                   delegate:self
                                          cancelButtonTitle:@"I'm done"
                                          otherButtonTitles:@"Cancel", nil];
    [alert show];
    turnEnding = YES;
    
}

-(void)changeTurn:(BOOL) forceChange
{
    if(forceChange || pointsLeft != 16){
        myTurn = NO;
        PFUser *user;
        PFUser *me = [PFUser currentUser];
        if([me.objectId isEqualToString:game.owner.objectId]){
            user = game.player;
        } else {
            user = game.owner;
        }
    
        [game setActivePlayer:user];
        [game saveGame];
    
        [self refreshGame];
    }
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
