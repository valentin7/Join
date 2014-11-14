//
//  AddUserNameViewController.m
//  Join
//
//  Created by Valentin Perez on 7/18/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "AddUserNameViewController.h"
#import <Parse/Parse.h>

@implementation AddUserNameViewController
{
    PFUser *user;
    
}
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.80];
    UIColor *color = [UIColor lightTextColor];
    user = [PFUser currentUser];
    
    
  //  if (!user[_networkName])
    NSString *description;
    if ([_networkName isEqualToString:@"Phone"])
    {
        description = @"Write your phone number here";
    }
    else if ([_networkName isEqualToString:@"Email"])
    {
        
        description = @"Write your email here";
    }
    else
    {
        description = @"Write your username here";
    }
    
    _usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:description attributes:@{NSForegroundColorAttributeName: color}];
    
    _usernameTextField.tintColor = [UIColor colorWithWhite:1 alpha:1];
    
    //else
    
    
    
  
    if ([_networkName isEqualToString:@"8tracks"])
    {
        if (user[@"tracks8"])
        {
            _usernameTextField.text = user[@"tracks8"];
        }
        
    }
    else
    {
        if (user[_networkName])
        {
            NSLog(@"has current network: %@", _networkName);
           
            _usernameTextField.text = user[_networkName];
        }
        
    }
    
    _networkLabel.text = _networkName;
    
    _networkImage.image = [UIImage imageNamed:_imageString];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScreen)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) tappedOnScreen
{
    [self.view endEditing:YES];
}

- (IBAction)tappedDone:(id)sender
{
  
    if ((_usernameTextField.text.length >=1) &&  [_usernameTextField.text characterAtIndex:0] == '@')
    {
        _usernameTextField.text = [_usernameTextField.text substringFromIndex:1];
    }
    NSLog(@"user's net: %@", user[_networkName]);
    //if (_usernameTextField.text.length>0)
    if ([_networkName isEqualToString:@"8tracks"])
    {
        user[@"tracks8"] = _usernameTextField.text;
        NSLog(@"saving tracks8");
    }
    else
    {
        NSLog(@"el otro");
        user[_networkName] = _usernameTextField.text;
    }
    [user saveEventually];
    
    if([self.delegate respondsToSelector:@selector(justAddedUser:)])
    {
            [self.delegate justAddedUser:_usernameTextField.text];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
