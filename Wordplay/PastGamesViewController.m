//
//  PastGamesViewController.m
//  Wordplay
//
//  Created by Blake Martin on 3/29/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PastGamesViewController.h"

@interface PastGamesViewController ()

@end

@implementation PastGamesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.gamesTable setDataSource:self];
    [self.gamesTable setDelegate:self];
    
    [PFGame loadActive:YES GamesWithBlock:^(NSArray *returnedGames, NSError *error){
        
        if(!error){
            
            pastGames = returnedGames;
            
            [self.gamesTable reloadData];
        }
        
    }];
    	
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pastGames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    PFGame *game = [pastGames objectAtIndex:indexPath.row];
    cell.textLabel.text = game.name;
    return cell;
}

@end
