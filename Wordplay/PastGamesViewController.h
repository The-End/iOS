//
//  PastGamesViewController.h
//  Wordplay
//
//  Created by Blake Martin on 3/29/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFGame.h"

@interface PastGamesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    NSArray *pastGames;
    
}

@property (weak, nonatomic) IBOutlet UITableView *gamesTable;

@end
