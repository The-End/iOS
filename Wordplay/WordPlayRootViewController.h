//
//  WordPlayRootViewController.h
//  Wordplay
//
//  Created by Blake Martin on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginController.h"
#import <CoreData/CoreData.h>

@interface WordPlayRootViewController : UIViewController<NSURLConnectionDelegate>
{
    NSManagedObjectContext *context;
    NSMutableData *profilePictureData;
}

- (IBAction)LogOutButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end