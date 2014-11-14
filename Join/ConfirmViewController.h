//
//  ConfirmViewController.h
//  Join
//
//  Created by Valentin Perez on 6/7/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (assign, nonatomic) NSString *firstName;
@property (assign, nonatomic) NSString *lastName;


@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *bioTagLineTextView;
- (IBAction)tappedConfirm:(id)sender;
- (IBAction)tappedCancel:(id)sender;
@end
