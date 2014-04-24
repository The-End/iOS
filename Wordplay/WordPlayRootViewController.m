//
//  WordPlayRootViewController.m
//  Wordplay
//
//  Created by Blake Martin on 3/21/14.
//  Copyright (c) 2014 Blake Martin. All rights reserved.
//

#import "WordPlayRootViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface WordPlayRootViewController ()

@end

@implementation WordPlayRootViewController

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
    
    User *user = [User loadMainUser: context];
    
    if(user == nil){
        
        [self performSegueWithIdentifier:@"goToLoginController" sender:nil];
        
    } else {
        
        NSURL *profileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", user.facebookId]];
        
        profilePictureData = [[NSMutableData alloc] init];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:profileUrl
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogOutButtonAction:(id)sender {
    
    [PFUser logOut];
    [User deleteMainUser: context];
    
    [self performSegueWithIdentifier:@"goToLoginController" sender:nil];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [profilePictureData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    UIImage *profilePicutureImage = [UIImage imageWithData:profilePictureData];
    [_profilePicture setImage:profilePicutureImage];
}

@end
