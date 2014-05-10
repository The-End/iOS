//
//  PFPlayerMove.m
//  Wordplay
//
//  Created by Marshall Mann-Wood on 4/28/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "PFPlayerMove.h"
#import "PFMove.h"

@implementation PFPlayerMove

@dynamic moves;
@dynamic player;
@dynamic moveNumber;
@dynamic time;

- (void) giveMove:(PFMove *) move
{
    if(!self.moves){
        self.moves = [[NSMutableArray alloc] init];
    }
    
    move.moveNumber = [self.moves count];
    [self.moves addObject: move];
}

-(void) saveMoves{
    
    [self saveInBackground];
    
    NSLog(@"Moves Count: %lu", (unsigned long) [self.moves count]);
    
    for(PFMove *move in self.moves){
        [move saveInBackground];
    }
    
}

+ (NSString * )parseClassName{
    return @"PFPlayerMove";
}

@end
