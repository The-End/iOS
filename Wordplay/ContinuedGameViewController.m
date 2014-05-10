//
//  ContinuedGameViewController.m
//  Wordplay
//
//  Created by Blake Martin on 5/9/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "CustomButton.h"
#import "ContinuedGameViewController.h"

@interface ContinuedGameViewController ()

{

    NSMutableArray *moves;
    NSMutableArray *buttonArray;
    int numberToPassToAlertView;
    NSString *wordToPassToAlertView;
    BOOL textview;
    

}
@end

@implementation ContinuedGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lockedArray = [[NSMutableArray alloc] init];
        self.toDisplay = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    moves = [[NSMutableArray alloc] init];
    [moves addObject:@"Delete"];
    [moves addObject:@"Lock"];
    [moves addObject:@"Change"];
    [moves addObject:@"Insert Before"];
    [moves addObject:@"Insert After"];
    [moves addObject:@"Close"];
    
    NSMutableArray *locked = [[NSMutableArray alloc] init];
    NSString *testString = [NSString stringWithFormat:@"This is a test string for our app This is a test string for our app This is a test string for our"];
    NSArray *testArray = [testString componentsSeparatedByString: @" "];
    
    
    if (self.toDisplay == Nil) {
        self.toDisplay = [testArray mutableCopy];
    }
    
    if (self.lockedArray == nil){
        
        for (int i = 0; i < testArray.count; i++) {
            if (i % 2) {
                [locked addObject:@"locked"];
            }
            else {
                [locked addObject:@"lsdfaocked"];
            }
        }
        self.lockedArray = locked;
    }
    
   
    if(!self.reenter){
        self.pointsLeft = 16;
    }
    UITextView *score = [[UITextView alloc] initWithFrame:CGRectMake(self.navigationController.navigationBar.frame.origin.x + 10, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + 5, self.view.frame.size.width - 20, 30)];
    [score setBackgroundColor:[UIColor orangeColor]];
    score.font = [UIFont systemFontOfSize:14];
    NSString *pointsRemaining = [NSString stringWithFormat: @"You have %i points remaining this round", self.pointsLeft];
    
    [score setText:pointsRemaining];
    [self.view addSubview:score];
    [self displaySentencefromArray:self.toDisplay];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    
    
}



-(void) viewWillAppear:(BOOL)animated{
    
    if (self.reenter) {
        
        NSMutableArray *VCs = [self.navigationController.viewControllers mutableCopy];
        [VCs removeObjectAtIndex:[VCs count] - 2];
        self.navigationController.viewControllers = VCs;
    }
}

-(void) buttonMethod:(id)sender{
    
    UIScrollView *optionsMenu;
    CustomButton *selected = (CustomButton *)sender;
    
    for (int i = 0; i < buttonArray.count; i++) {
        CustomButton *temp = [buttonArray objectAtIndex:i];
        if (temp.pressed == YES) {
            
            [temp.associatedView removeFromSuperview];
        }
    }
    selected.pressed = YES;
    
    
    
    NSString *longest = @"Insert Before";
    CGSize longestSize = [longest sizeWithFont:[UIFont systemFontOfSize:15]];
    if ((selected.frame.origin.x + longestSize.width) > (self.view.frame.origin.x + self.view.frame.size.width)){
        optionsMenu = [[UIScrollView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - (longestSize.width+10)),(selected.frame.origin.y + selected.frame.size.height),longestSize.width + 10,(moves.count*longestSize.height + (moves.count + 1)*5))];
        
    }
    
    else{
        optionsMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(selected.frame.origin.x,(selected.frame.origin.y + selected.frame.size.height),longestSize.width + 10,(moves.count*longestSize.height + (moves.count + 1)*5))];
    }
    
    [optionsMenu setBackgroundColor:[UIColor lightGrayColor]];
    for (int i = 0; i < moves.count; i++){
        
        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(activitySelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[moves objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        CGSize stringsize = [[moves objectAtIndex: i] sizeWithFont:[UIFont systemFontOfSize:15]];
        
        
        button.frame = CGRectMake(5, (5+i*23), stringsize.width, stringsize.height);
        [button setBackgroundColor:[UIColor whiteColor]];
        button.numberInSentence = selected.numberInSentence;
        button.word = selected.titleLabel.text;
        
        [optionsMenu addSubview:button];
    }
    [self.view addSubview:optionsMenu];
    selected.associatedView = optionsMenu;
    
}

-(void) activitySelected:(id)sender{
    
    
    CustomButton *selected = (CustomButton *)sender;
    
    if ([selected.titleLabel.text isEqualToString:@"Lock"]){
        
        
        
        wordToPassToAlertView = @"Lock";
        numberToPassToAlertView =selected.numberInSentence;
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
        
        
        
        wordToPassToAlertView = @"Delete";
        numberToPassToAlertView =selected.numberInSentence;
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
        
        wordToPassToAlertView = @"Change";
        numberToPassToAlertView = selected.numberInSentence;
        NSMutableString *text = [[NSMutableString alloc] init];
        [text appendString:@"Change \""];
        [text appendString:selected.word];
        [text appendString:@"\" To:"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"Change" otherButtonTitles:@"Cancel", nil];
        UITextField * alertTextField = [[UITextField alloc] init];
        alertTextField.placeholder = @"Your input must be one word!";
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        [alertTextField becomeFirstResponder];
        [alert show];
        
        
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Insert Before"]) {
        
        wordToPassToAlertView = @"Insert Before";
        numberToPassToAlertView = selected.numberInSentence;
        NSMutableString *text = [[NSMutableString alloc] init];
        [text appendString:@"Enter word to insert before \""];
        [text appendString:selected.word];
        [text appendString:@"\":"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"Insert" otherButtonTitles:@"Cancel", nil];
        UITextField * alertTextField = [[UITextField alloc] init];
        alertTextField.placeholder = @"Your input must be one word!";
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        [alertTextField becomeFirstResponder];
        [alert show];
        
    }
    
    if ([selected.titleLabel.text isEqualToString:@"Insert After"]) {
        
        wordToPassToAlertView = @"Insert After";
        numberToPassToAlertView = selected.numberInSentence;
        NSMutableString *text = [[NSMutableString alloc] init];
        [text appendString:@"Enter word to insert After \""];
        [text appendString:selected.word];
        [text appendString:@"\":"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"Insert" otherButtonTitles:@"Cancel", nil];
        UITextField * alertTextField = [[UITextField alloc] init];
        alertTextField.placeholder = @"Your input must be one word!";
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        [alertTextField becomeFirstResponder];
        [alert show];
        
    }
    
    
    [selected.superview removeFromSuperview];
}

-(void) displaySentencefromArray:(NSMutableArray *)toPrint{
    
    buttonArray = [[NSMutableArray alloc] init];
    CustomButton *previousButton;
    
    for (int i = 0 ; i < toPrint.count ; i ++){
        
        
        int yadd = 0;
        int xcoord = 0;
        
        if (i == 0) {
            
            CustomButton *button = [CustomButton buttonWithType:UIButtonTypeRoundedRect];
            button.numberInSentence = i;
            button.sentence = toPrint;
            if ([[self.lockedArray objectAtIndex:i]  isEqual:@"locked"]) {
                [button setBackgroundColor:[UIColor redColor]];
                button.locked = YES;
                button.userInteractionEnabled = NO;
            }
            [button addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[toPrint objectAtIndex: i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            CGSize stringsize = [[toPrint objectAtIndex: i] sizeWithFont:[UIFont systemFontOfSize:15]];
            //NSLog(@"%f%f", stringsize.width, stringsize.height);
            button.frame = CGRectMake(20, (self.navigationController.navigationBar.frame.size.height + 80), stringsize.width, stringsize.height);
            
            
            [self.view addSubview:button];
            [buttonArray addObject:button];
            previousButton = button;
            
        }
        
        
        
        
        if (i > 0){
            
            CustomButton *button = [CustomButton buttonWithType:UIButtonTypeRoundedRect];
            button.numberInSentence = i;
            button.sentence = toPrint;
            if ([[self.lockedArray objectAtIndex:i]  isEqual:@"locked"]) {
                [button setBackgroundColor:[UIColor redColor]];
                button.locked = YES;
                button.userInteractionEnabled = NO;
            }
            [button addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:[toPrint objectAtIndex: i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            //NSLog(previousButton.titleLabel.text);
            CGSize stringsize = [[toPrint objectAtIndex: i] sizeWithFont:[UIFont systemFontOfSize:15]];
            if ((previousButton.frame.origin.x + previousButton.frame.size.width + 10 + button.frame.size.width) > (self.view.frame.size.width - 20)){
                
                
                yadd = previousButton.frame.size.height + 10;
                xcoord = 20;
                
                
            }
            else{
                xcoord = previousButton.frame.origin.x + previousButton.frame.size.width + 10;
                
            }
            button.frame = CGRectMake(xcoord, (previousButton.frame.origin.y + yadd), stringsize.width, stringsize.height);
            [self.view addSubview:button];
            [buttonArray addObject:button];
            previousButton = button;
        }
        
        if (i == toPrint.count-1){
            NSLog(@"TextField");
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, (previousButton.frame.origin.y + previousButton.frame.size.height + 10), (self.view.frame.size.width - 20),previousButton.frame.size.height)];
            [textField addTarget:self
                               action:@selector(textFieldFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.font = [UIFont systemFontOfSize:14];
            textField.placeholder = @"Enter up to (3- Change When calculated) words";
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDone;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.delegate = self;
            [self.view addSubview:textField];
        
        }
        
    }
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == [alertView cancelButtonIndex]){
        
        if ([wordToPassToAlertView isEqualToString:@"Delete"]){
            
            
            NSMutableArray *toPassDisplay = [[NSMutableArray alloc]init];
            toPassDisplay = self.toDisplay;
            NSMutableArray *toPassLocked = [[NSMutableArray alloc]init];
            toPassLocked = self.lockedArray;
            [toPassDisplay removeObjectAtIndex:numberToPassToAlertView];
            [toPassLocked removeObjectAtIndex:numberToPassToAlertView];
            ContinuedGameViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"ContinuedGameViewController"];
            temp.toDisplay = toPassDisplay;
            temp.lockedArray = toPassLocked;
            temp.reenter = YES;
            temp.pointsLeft = self.pointsLeft - 10;
            [self.navigationController pushViewController:temp animated:NO];
            
            
            
        }
    }
    
        if([wordToPassToAlertView isEqualToString:@"Change"]){
            
            [self.toDisplay replaceObjectAtIndex:numberToPassToAlertView withObject:[alertView textFieldAtIndex:0].text];
            ContinuedGameViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"ContinuedGameViewController"];
            temp.toDisplay = self.toDisplay;
            temp.lockedArray = self.lockedArray;
            temp.reenter = YES;
            temp.pointsLeft = self.pointsLeft - 15;
            [self.navigationController pushViewController:temp animated:NO];
            
        
        }
    
        if([wordToPassToAlertView isEqualToString:@"Insert Before"]){
        
            [self.toDisplay insertObject:[alertView textFieldAtIndex:0].text atIndex:numberToPassToAlertView];
            [self.lockedArray insertObject:@"notLocked" atIndex:numberToPassToAlertView];
            
            ContinuedGameViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"ContinuedGameViewController"];
            temp.toDisplay = self.toDisplay;
            temp.lockedArray = self.lockedArray;
            temp.reenter = YES;
            temp.pointsLeft = self.pointsLeft - 5;
            [self.navigationController pushViewController:temp animated:NO];
        
        
        }
    
        if([wordToPassToAlertView isEqualToString:@"Insert After"]){
        
            [self.toDisplay insertObject:[alertView textFieldAtIndex:0].text atIndex:(numberToPassToAlertView + 1)];
            [self.lockedArray insertObject:@"notLocked" atIndex:(numberToPassToAlertView + 1)];
        
            ContinuedGameViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"ContinuedGameViewController"];
            temp.toDisplay = self.toDisplay;
            temp.lockedArray = self.lockedArray;
            temp.reenter = YES;
            temp.pointsLeft = self.pointsLeft - 5;
            [self.navigationController pushViewController:temp animated:NO];
        
        
        }
    
        if([wordToPassToAlertView isEqualToString:@"Lock"]){
        
            [self.lockedArray replaceObjectAtIndex:numberToPassToAlertView withObject:@"locked"];
            ContinuedGameViewController *temp = [self.storyboard instantiateViewControllerWithIdentifier:@"ContinuedGameViewController"];
            temp.toDisplay = self.toDisplay;
            temp.lockedArray = self.lockedArray;
            temp.reenter = YES;
            temp.pointsLeft = self.pointsLeft - 7;
            [self.navigationController pushViewController:temp animated:NO];
        
        
        }
    
        if (textview){
    
            [self.lockedArray addObject:wordToPassToAlertView];
        
        }
}



-(BOOL) textFieldFinished:(id)sender{
    UITextField *temp = sender;
    NSMutableString *text = [[NSMutableString alloc] init];
    
    if ([temp.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid input."
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    [text appendString:@"Are you sure you want to add \""];
    [text appendString:temp.text];
    [text appendString:@"\"?"];
    textview = YES;
    wordToPassToAlertView = temp.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:text
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No", nil];
    [alert show];
    
    
    
    [sender resignFirstResponder];
    return YES;
}


@end
