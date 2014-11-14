//
//  ViewController.h
//  Join
//
//  Created by Valentin Perez on 4/13/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

#import "SemiCircleProfile.h"
#import "RESideMenu.h"
#import "DetailNetworkViewController.h"


@interface ViewController : UIViewController <SemiCircleProfileDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UITextView *bioTagLineTextView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) SemiCircleProfile *semiCircleProfile;

@property (nonatomic, assign) id<DetailNetworkViewControllerDelegate> detailNetworkVCDelegate;
@property (strong, nonatomic) PFUser *user;

@property (strong, nonatomic) IBOutlet UIButton *menuBurgerButton;

@property (assign, nonatomic) BOOL isOtherUser;

- (IBAction)showSideMenu:(id)sender;
- (IBAction)tappedOnSettings:(id)sender;
@end
