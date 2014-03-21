//
//  LoginController.h
//  Wordplay
//
//  Created by Marshall Mann-Wood on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginController : UIViewController <FBLoginViewDelegate>{
    
    FBLoginView *facebook;
    
}

@end
