//
//  NewGameViewController.h
//  Wordplay
//
//  Created by Blake Martin on 3/29/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>

@interface NewGameViewController : UIViewController{




}

@property(nonatomic) NSArray *selectedFriendsNewGame;
-(void) buttonMethod:(id)sender;
-(void)activitySelected:(id)sender;
-(void) displaySentencefromArray:(NSMutableArray *)toPrint withMoves:(NSMutableArray *)associatedMoves;

@end
