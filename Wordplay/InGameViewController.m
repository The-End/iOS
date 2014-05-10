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
            [self refreshGame];
        }
    }];
    
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
    [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Add up to %i words!", pointsLeft/4]];
    
    
    currentStringLength = 0;
    currentStringHeight = 0;
    
    for(CustomButton *button in buttons){
        [button removeFromSuperview];
    }
    
    [self showGame];
}

-(void)buttonMethod:(id)sender
{
    [self.inputTextField resignFirstResponder];
    
    if (textInputUp) {
        [self textBoxAnimateUp:NO];
        textInputUp = !textInputUp;
    }
    else{
        
        [self textBoxAnimateUp:YES];
        textInputUp = !textInputUp;
    
    }
    
    if (![inputType isEqualToString:@"Change"]) {
        inputType = @"Change";
        [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Add up to %i words!", pointsLeft/4]];
    }
    
    UIScrollView *optionsMenu;
    CustomButton *selected = (CustomButton *)sender;
    buttonForAlertView = selected;
    
    for (CustomButton *button in buttons) {
        if (button.pressed == YES) {
            [button.associatedView removeFromSuperview];
            button.pressed = NO;
        }
    }
    selected.pressed = YES;
    
    if(!myTurn || selected.locked){
        return;
    }
    
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
    
    if ([selected.titleLabel.text isEqualToString:@"Lock"]){
        
        
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
    
    if ([selected.titleLabel.text isEqualToString:@"Delete"]){
        
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
    
    if ([selected.titleLabel.text isEqualToString:@"Change"]){
        
        inputType = @"Change";
        [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Change \"%@\" to...", selected.word]];
        [self.inputTextField becomeFirstResponder];
//        NSMutableString *text = [[NSMutableString alloc] init];
//        [text appendString:@"Are you sure you want to change \""];
//        [text appendString:selected.word];
//        [text appendString:@"\" To (ADD WORD)?"];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"Change" otherButtonTitles:@"Cancel", nil];
        //UITextField * alertTextField = [[UITextField alloc] init];
//        alertTextField.placeholder = @"Your input must be one word!";
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
//        [alertTextField becomeFirstResponder];
//        [alert show];
        
        
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Insert Before"]) {
        
        inputType = @"Insert Before";
        
        [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Insert before \"%@\"...", selected.word]];
        [self.inputTextField becomeFirstResponder];
//        NSMutableString *text = [[NSMutableString alloc] init];
//        [text appendString:@"Are you sure you want to insert (ADD WORD) before \""];
//        [text appendString:selected.word];
//        [text appendString:@"\"?"];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"Insert" otherButtonTitles:@"Cancel", nil];
//        UITextField * alertTextField = [[UITextField alloc] init];
//        alertTextField.placeholder = @"Your input must be one word!";
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
//        [alertTextField becomeFirstResponder];
//        [alert show];
        
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Insert After"]) {
        
        
        inputType = @"Insert After";
        
        [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Insert after \"%@\"...", selected.word]];
        [self.inputTextField becomeFirstResponder];
//        NSMutableString *text = [[NSMutableString alloc] init];
//        [text appendString:@"Are you sure you want to insert (ADD WORD) after \""];
//        [text appendString:selected.word];
//        [text appendString:@"\"?"];
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"Insert" otherButtonTitles:@"Cancel", nil];
//        UITextField * alertTextField = [[UITextField alloc] init];
//        alertTextField.placeholder = @"Your input must be one word!";
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
//        [alertTextField becomeFirstResponder];
//        [alert show];
        
    }
    
    
    [selected.superview removeFromSuperview];
    if (!textInputUp){
        
        [self textBoxAnimateUp:YES];
        textInputUp = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{\
    
    if ([actionAfterAlertView isEqualToString:@"Delete"] ){
        if (buttonIndex == [alertView cancelButtonIndex]){
            pointsLeft -= 10;
            [game newDeleteMove:buttonForAlertView.move];
            [self refreshGame];
        }
    }
    
    if([actionAfterAlertView isEqualToString:@"Change"]){
        
        pointsLeft -= 15;
        //[game newSwitchMove:buttonForAlertView.move forWord:[alertView textFieldAtIndex:0].text];
        [self refreshGame];
    }
    
    if([actionAfterAlertView isEqualToString:@"Insert Before"]){
        
        pointsLeft -= 5;
        //[game newInsertWord:[alertView textFieldAtIndex:0].text beforeMove:buttonForAlertView.move];
        [self refreshGame];
    }
    
    if([actionAfterAlertView isEqualToString:@"Insert After"]){
        
        pointsLeft -= 5;
        //[game newInsertWord:[alertView textFieldAtIndex:0].text afterMove:buttonForAlertView.move];
        [self refreshGame];
    }
    
    if([actionAfterAlertView isEqualToString:@"Lock"]){
        
        pointsLeft -= 7;
        //[game newLockMove:buttonForAlertView.move];
        [self refreshGame];
    }
    
//    if (textview){
//        
//        [self.lockedArray addObject:wordToPassToAlertView];
//        
//    }
}

-(void)makeButtonsFromGame
{
    
    NSArray *moves = [game getMovesInOrder];
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
    
    PFUser *currentUser = [PFUser currentUser];
    UIColor *myColor = [UIColor greenColor];
    UIColor *theirColor = [UIColor redColor];
    
    NSMutableArray *displayedMoves = [[NSMutableArray alloc] init];
    for(PFMove *move in moves){
        if([move.type isEqualToString:@"CREATE"]){
            NSLog(@"Create");
            [displayedMoves addObject:move];
        } else if([move.type isEqualToString:@"INSERT_BEFORE"]){
            NSLog(@"INSERT_BEFORE");
            
            int index = [self getIndexOfMove:move.affectedMove inArray:displayedMoves];
            [displayedMoves insertObject:move atIndex:index];
            
        } else if([move.type isEqualToString:@"INSERT_AFTER"]){
            NSLog(@"INSERT_AFTER");
            
            int index = [self getIndexOfMove:move.affectedMove inArray:displayedMoves];
            [displayedMoves insertObject:move atIndex:index + 1];
            
        } else if([move.type isEqualToString:@"SWITCH"]){
            NSLog(@"SWITCH");
            
            int index = [self getIndexOfMove:move.affectedMove inArray:displayedMoves];
            [displayedMoves removeObjectAtIndex:index];
            [displayedMoves insertObject:move atIndex:index];
            
        } else if([move.type isEqualToString:@"DELETE"]){
            NSLog(@"DELETE");
            int index = [self getIndexOfMove:move.affectedMove inArray:displayedMoves];
            [displayedMoves removeObjectAtIndex:index];
        }if([move.type isEqualToString:@"LOCK"]){
            [displayedMoves addObject:move];
            NSLog(@"found lock move in moves");
        }
    }
    
    for(PFMove *move in displayedMoves){
        
        if([move.type isEqualToString:@"LOCK"]){
            NSLog(@"Found Lock Move in displayed Moves");
            CustomButton *button = [self findButtonInArray:buttonsArray WithMove:move.affectedMove];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.locked = YES;
        } else {
            CustomButton *button = [self makeButtonWithWord:move.word];
            button.move = move;
            if([currentUser.objectId isEqualToString:move.player.objectId]){
                [button setTitleColor:myColor forState:UIControlStateNormal];
            } else {
                [button setTitleColor:theirColor forState:UIControlStateNormal];
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
    
    CGRect textRect = CGRectMake(10.0, 0.0, self.view.frame.size.width - 20, textParentFrame.size.height);
    UITextField *inputText = [[UITextField alloc] initWithFrame:textRect];
    [inputText setBackgroundColor:[UIColor whiteColor]];
    [inputText setAlpha:0.5];
    [self.parentViewOfText addSubview:inputText];
    self.inputTextField = inputText;
    [self.inputTextField setDelegate:self];
    [self.inputTextField setPlaceholder:[NSString stringWithFormat:@"Add up to %i words!", pointsLeft/4]];

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
    NSLog(@"%@", inputType);
   
  
    if ([inputType isEqualToString:@"Create"]) {
     
    if([word isEqualToString:@""] || temp.count >pointsLeft/4 ){
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
        
        return NO;
    }
    for (int i = 0; i < temp.count; i ++) {
        pointsLeft -= 4;
        [game newCreateMoveWithWord:word];

    }
    
    }
    
    if ([inputType isEqualToString:@"Insert Before"]) {
        
        
        
    }
    
    if ([inputType isEqualToString:@"Insert After"]) {
        
    }
    
    if ([inputType isEqualToString:@"Change"]) {
        
    }
    
    inputType = @"Change";
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
