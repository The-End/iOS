//
//  ContinuedGameViewController.h
//  Wordplay
//
//  Created by Blake Martin on 5/9/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContinuedGameViewController : UIViewController


@property(nonatomic) NSArray *selectedFriendsNewGame;
-(void) buttonMethod:(id)sender;
-(void)activitySelected:(id)sender;
-(void) displaySentencefromArray:(NSMutableArray *)toPrint withMoves:(NSMutableArray *)associatedMoves;

@end