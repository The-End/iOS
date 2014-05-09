//
//  CustomButton.m
//  Wordplay
//
//  Created by Blake Martin on 5/8/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.locked = NO;
        self.pressed = NO;
        self.numberInSentence = -1;
        self.associatedView = [[UIScrollView alloc] init];
        self.sentence = [[NSMutableArray alloc] init];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
