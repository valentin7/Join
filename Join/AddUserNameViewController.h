//
//  AddUserNameViewController.h
//  Join
//
//  Created by Valentin Perez on 7/18/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddUserNameViewControllerDelegate;

@interface AddUserNameViewController : UIViewController
@property (nonatomic, assign) id<AddUserNameViewControllerDelegate> delegate;

@property (assign, nonatomic) NSString *networkName;
@property (assign, nonatomic) NSString *imageString;

@property (strong, nonatomic) IBOutlet UIImageView *networkImage;
@property (strong, nonatomic) IBOutlet UILabel *networkLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
- (IBAction)tappedDone:(id)sender;
- (IBAction)tappedCancel:(id)sender;


@end

@protocol AddUserNameViewControllerDelegate<NSObject>

@optional

- (void) justAddedUser: (NSString *) title;
@end