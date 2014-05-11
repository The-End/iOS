//
//  GameListViewController.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 5/10/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "GameListViewController.h"

@interface GameListViewController ()

@end

@implementation GameListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.active = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.gameTable setDataSource:self];
    [self.gameTable setDelegate:self];
    self.gameTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WordPlayBackDrop1.png"]];
    
    [PFGame loadActive:self.active GamesWithBlock:^(NSArray *returnedGames, NSError *error){
        
        if(!error){
            
            games = returnedGames;
            
            [self.gameTable reloadData];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    InGameViewController *gameController = [self.storyboard instantiateViewControllerWithIdentifier:@"InGameViewController"];
    [gameController giveGame:[games objectAtIndex:indexPath.row]];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:gameController animated:YES];
    [UIView commitAnimations];
    
}

//-(void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
//
//        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [games count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    PFGame *game = [games objectAtIndex:indexPath.row];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"fbloginbutton.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = game.name;
    return cell;
}


-(void) viewWillAppear:(BOOL)animated{
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WordPlayBackDrop1.png"]];
    int numberOfGames = [games count];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    //self.tableView.frame = CGRectMake(5, self.navigationController.navigationBar.frame.size.height + 10, self.view.frame.size.width - 10, numberOfGames * self.tableView.cell.size.height);
    
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
