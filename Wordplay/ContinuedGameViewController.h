//
//  ContinuedGameViewController.h
//  Wordplay
//
//  Created by Blake Martin on 5/9/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFGame.h"

@interface ContinuedGameViewController : UIViewController <UIAlertViewDelegate>
{
    
    PFGame *game;
    NSMutableArray *moves;
    NSMutableArray *buttonArray;
    int numberToPassToAlertView;
    NSString *wordToPassToAlertView;
    BOOL textview;
}


@property(nonatomic) NSArray *selectedFriendsNewGame;
@property(nonatomic) NSMutableArray *toDisplay;
@property(nonatomic) NSMutableArray *lockedArray;
@property(nonatomic) BOOL reenter;
@property(nonatomic) int pointsLeft;


-(void) buttonMethod:(id)sender;
-(void)activitySelected:(id)sender;
-(void) displaySentencefromArray:(NSMutableArray *)toPrint;
-(BOOL) textFieldFinished:(id)sender;
-(void)giveGame:(PFGame *)newGame;

@end