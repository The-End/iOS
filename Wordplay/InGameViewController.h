//
//  InGameViewController.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 5/10/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFGame.h"
#import "CustomButton.h"

@interface InGameViewController : UIViewController <UITextFieldDelegate>
{
    BOOL myTurn;
    PFGame *game;
    int pointsLeft;
    NSArray *buttons;
    int heightOfKeyboard;
    int currentStringLength;
    int currentStringHeight;
    NSMutableArray *moveTypes;
    CustomButton *buttonForAlertView;
    NSString *actionAfterAlertView;
    BOOL textInputUp;
    NSString *inputType;
    CustomButton *selectedButton;
    
}

@property (nonatomic, retain) UITextView *pointsLeftView;
@property (weak, nonatomic) IBOutlet UIScrollView *parentView;
@property (weak, nonatomic) IBOutlet UIView *parentViewOfText;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *pointsLeftLabel;


-(void)displayScore;

-(void)updateScore;

-(void)showGame;

-(void)refreshGame;

-(void)buttonMethod:(id) sender;

-(void) activitySelected:(id)sender;

-(void)makeButtonsFromGame;

-(CustomButton *) makeButtonWithWord:(NSString *)word;

- (IBAction)submitButton:(id)sender;

-(void)giveGame:(PFGame *)newGame;

-(void)setupViewElements;

@end
