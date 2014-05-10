//
//  GameListViewController.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 5/10/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFGame.h"

@interface GameListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *games;
}

@property BOOL active;

@property (weak, nonatomic) IBOutlet UITableView *gameTable;

@end
