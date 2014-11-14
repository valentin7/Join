//
//  DetailNetworkViewController.h
//  Join
//
//  Created by Valentin Perez on 7/20/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol DetailNetworkViewControllerDelegate;


@interface DetailNetworkViewController : UIViewController

@property (nonatomic, assign) id<DetailNetworkViewControllerDelegate> delegate;
@property (assign, nonatomic) NSString *networkImageString;
@property (assign, nonatomic) NSString *networkName;
@property (strong, nonatomic) IBOutlet UILabel *networkLabel;
@property (strong, nonatomic) IBOutlet UIImageView *networkImage;
@property (strong, nonatomic) IBOutlet UITextView *userNameTextView;
@property (strong, nonatomic) IBOutlet UIButton *extraButton;
@property (strong, nonatomic) IBOutlet UIButton *primaryButton;
@property (assign, nonatomic) PFUser *user;
@property (assign, nonatomic) BOOL isOtherUser;

- (IBAction)openInApp:(id)sender;
- (IBAction)tappedExtraButton:(id)sender;
@end

@protocol DetailNetworkViewControllerDelegate<NSObject>

@optional

- (void) contactsChanged;

@end
