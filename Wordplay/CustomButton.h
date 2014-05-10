//
//  CustomButton.h
//  Wordplay
//
//  Created by Blake Martin on 5/8/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMove.h"

@interface CustomButton : UIButton

@property NSString *word;
@property BOOL pressed;
@property BOOL locked;
@property int numberInSentence;
@property UIScrollView *associatedView;
@property NSMutableArray *sentence;
@property PFMove *move;

@end
