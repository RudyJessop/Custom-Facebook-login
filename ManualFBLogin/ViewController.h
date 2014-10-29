//
//  ViewController.h
//  ManualFBLogin
//
//  Created by Rudy on 9/14/14.
//  Copyright (c) 2014 Core Tech Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnToggleLoginState;

@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePicture;

@property (weak, nonatomic) IBOutlet UILabel *lblFullname;

@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) AppDelegate *appDelegate;

//Not used
//@property (weak, nonatomic) fb *lblTotalFriends

- (IBAction)toggleLoginState:(id)sender;

@end
