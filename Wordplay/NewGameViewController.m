//
//  NewGameViewController.m
//  Wordplay
//
//  Created by Blake Martin on 3/29/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "customButton.h"
#import "NewGameViewController.h"
#import "FBFriendPickerAppInstalled.h"
#import "WordPlayRootViewController.h"

@interface NewGameViewController (){

    NSMutableArray *moves;
    NSMutableArray *buttonArray;
    
}
@end

@implementation NewGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     NSLog(@"STEP 2");
    moves = [[NSMutableArray alloc] init];
    [moves addObject:@"Delete"];
    [moves addObject:@"Lock"];
    [moves addObject:@"Change"];
    [moves addObject:@"Insert After"];
    [moves addObject:@"Insert Before"];
    [moves addObject:@"Close"];
    
    //FBRequest *request = [FBRequest requestForGraphPath:@"/me/friends?fields=installed"];
    
    NSString *testString = [NSString stringWithFormat:@"This is a test string for our app This is a test string for our app This is a test string for our app"];
    NSArray *testArray = [testString componentsSeparatedByString: @" "];
    NSMutableArray *test = [testArray mutableCopy];
    NSMutableArray *locked = [[NSMutableArray alloc] init];
    for (int i = 0; i < testArray.count; i++) {
        if (i % 2) {
            [locked addObject:@"locked"];
        }
        else {
        
            [locked addObject:@"npot"];
        }
    }
    [self displaySentencefromArray:test withMoves: locked];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{


}

/*-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.navigationController popViewControllerAnimated:NO];
        //FBFriendPickerAppInstalled *newFBFPAppInstalled = [[FBFriendPickerAppInstalled alloc] init];
        //[self.navigationController pushViewController:newFBFPAppInstalled animated:YES];
    }
    [super viewWillDisappear:animated];
}*/

-(void) viewWillAppear:(BOOL)animated{

    //NSMutableArray *VCs = [self.navigationController.viewControllers mutableCopy];
    //[VCs removeObjectAtIndex:[VCs count] - 2];
    //self.navigationController.viewControllers = VCs;

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
        
        
        [optionsMenu addSubview:button];
    }
    [self.view addSubview:optionsMenu];
    selected.associatedView = optionsMenu;

}

-(void) activitySelected:(id)sender{
    
    
    CustomButton *selected = (CustomButton *)sender;
    
    if ([selected.titleLabel.text isEqualToString:@"Change"]){
    
        NSLog(@"SHOULD GO AWAY");
        NSString *text = [[NSString alloc] init];
        [selected setBackgroundColor:[UIColor greenColor]];
        for (int i = 0; i < buttonArray.count; i++) {
            [[buttonArray objectAtIndex:i] removeFromSuperview];
            [self.view addSubview:[buttonArray objectAtIndex:i]];
        }
    
    }
    
    [selected.superview removeFromSuperview];
}

-(void) displaySentencefromArray:(NSMutableArray *)toPrint withMoves:(NSMutableArray *)associatedMoves{
    
    buttonArray = [[NSMutableArray alloc] init];
    CustomButton *previousButton;
    
    for (int i = 0 ; i < toPrint.count ; i ++){
        
        
        int yadd = 0;
        int xcoord = 0;
        
        if (i == 0) {
            
            CustomButton *button = [CustomButton buttonWithType:UIButtonTypeRoundedRect];
            button.numberInSentence = i;
            button.sentence = toPrint;
            if ([[associatedMoves objectAtIndex:i]  isEqual: @"locked"]) {
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
            if ([[associatedMoves objectAtIndex:i]  isEqual: @"locked"]) {
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
        
    }
    
    

}


@end
