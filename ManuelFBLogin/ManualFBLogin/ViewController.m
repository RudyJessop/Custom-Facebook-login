//
//  ViewController.m
//  ManualFBLogin
//
//  Created by Rudy on 9/14/14.
//  Copyright (c) 2014 Core Tech Labs, Inc. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController()

- (void)handleFBSessionChangeWithNotification:(NSNotification *)notification;

@end

@implementation ViewController;

// Private method
//Hide related subviews

- (void)hideUserInfo:(BOOL)shouldHide{
    self.imgProfilePicture.hidden = shouldHide;
    self.lblFullname.hidden = shouldHide;
    //self.lblTotalFriends.hidden = shouldHide;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
    //Make image round with white border
    self.imgProfilePicture.layer.masksToBounds = YES;
    self.imgProfilePicture.layer.cornerRadius = 30.0;
    self.imgProfilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgProfilePicture.layer.borderWidth = 1.0;
    
    //
    [self hideUserInfo:YES];
    
    //hide acitivity indicator
    self.activityIndicator.hidden = YES;
    
    //Load the AppDelegate file
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFBSessionChangeWithNotification:) name:@"SessionStateChangeNotification" object:nil];
}

// Custom Facebook implementation
// ---------
//

// Login State
- (IBAction)toggleLoginState:(id)sender {
    if ([FBSession activeSession].state != FBSessionStateOpen &amp;&amp;
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        
        [self.appDelegate openActiveSessionWithPermission:@["public_profile", @"email"] allowLoginUI: YES];
    }
    else{
        // Close an existing session.
        [[FBSession activeSession] closeAndClearTokenInformation];
        
        //Update the UI
        [self hiddenUserInfo:YES];
        self.lblStatus.hidden = NO;
        self.lblStatus.text = @"You are not logged in.";
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBAppCall handleOpenURL:URL sourceApplication:sourceApplication];
}



//Get User Info
- (void)handleFBSessionChangeWithNotification:(NSNotification *)notification{
    //Get the session, state and error values from the notification's userInfo dictionary
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
                      
                      self.lblStatus.text = @"Logging you in...";
                      [self.activityIndicator startAnimating];
                      self.activityIndicator.hidden = NO;
                      
    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
                      if (!error){
                          //In case that there's not any error, then check if the session opened or closed.
                          [FBRequestConnection startWithGraphPath:@"me"
                                                       parameters:@{@"fields:": @"first_name:, last_name:, picture.type(normal), email"}
                                                       HTTPMethod:@"GET"
                                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                              if (!error){
                                  //Set the use full name.
                                  self.lblFullname.text = [NSString stringWithFormat:@"%@ %@",
                                                           [result objectForKey:@"firstname"],
                                                           [result objectForKey:@"last_name"]
                                                           ];
                                  
                                  //Set the email address
                                  self.lblEmail.text = [result objectForKey:@"email"];
                                  
                                  //Get the user's profile picture
                                  NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                  self.imgProfilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
                                  
                                  // Make the user info visible.
                                  [self hideUserInfo:NO];
                                  
                                  //Stop the activity indicator from animating and hiding the status
                                  self.lblStatus.hidden = YES;
                                  [self.activityIndicator stopAnimating];
                                  self.activityIndicator.hidden = YES;
                                  
                                  
                              }
                              else {
                                  NSLog(@"%@", [error localizedDescription]);
                              }
                        }];
                                                    
        [self.btnToggleLoginState setTitle:@"Logout" forState:UIControlStateNormal];
}
                           else if(sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
                               // A session was closed or the login was failed. Update the UI accordingly.
                               [self.btnToggleLoginState setTitle:@"Login" forState:UIControlStateNormal];
                               self.lblStatus.text = @"You are not logged in.";
                               self.activityIndicator.hidden = YES;
                           }
    

                           else{
                               // In case an error has occurred, then just log the error and update the UI accordingly.
                               NSLog(@"Error: %@", [error localizedDescription]);
                               [self hideUserInfo: YES];
                               [self.btnToggleLoginState setTitle:@"Login" forState:UIControlStateNormal];
                           }
                    }




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
