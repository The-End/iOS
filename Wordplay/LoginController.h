//
//  LoginController.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface LoginController : UIViewController <FBLoginViewDelegate>{
    
}
- (IBAction)fabookLoginButton:(id)sender;

@end
