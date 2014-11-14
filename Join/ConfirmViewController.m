//
//  ConfirmViewController.m
//  Join
//
//  Created by Valentin Perez on 6/7/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "ConfirmViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@implementation ConfirmViewController
{
    BOOL actuallyEdited;
    
    PFUser *user;
}
-(void) viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.80];
    user = [PFUser currentUser];
    _bioTagLineTextView.delegate = self;


    _firstNameTextField.text = _firstName;
    _lastNameTextField.text = _lastName;
    
    _userNameTextField.delegate = self;
    
    
    
    
    if (user[@"firstName"])
        _firstNameTextField.text = user[@"firstName"];
    else
    {
        if ([PFFacebookUtils isLinkedWithUser:user])
            [self requestFacebookInfo];
    }
    
    if (user[@"lastName"])
        _lastNameTextField.text = user[@"lastName"];
    
    if (user.username)
    {
        _userNameTextField.text = user.username;
        NSLog(@"username length: %lu",(unsigned long)user.username.length);
        NSLog(@"username : %@",user.username);

        if (user.username.length >=20)
        {
            _userNameTextField.text = @"";
            NSLog(@"too longa means NEEEEWW");
        }
    }
    
    
    if ([user[@"bioTagline"] length]>0)
    {
        NSLog(@"has bioTagline: %@", user[@"bioTagline"]);
        _bioTagLineTextView.text = user[@"bioTagline"];
    }

    _firstNameTextField.tintColor = [UIColor colorWithWhite:1 alpha:1];
    _lastNameTextField.tintColor = [UIColor colorWithWhite:1 alpha:1];
    _userNameTextField.tintColor = [UIColor colorWithWhite:1 alpha:1];

    /*UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer: swipeDownGesture ];*/
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScreen)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void) requestFacebookInfo
{
    NSLog(@"requesting Facebook");
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSLog (@"result: %@", userData);
            
            NSString *firstName = userData[@"first_name"];
            NSString *lastName = userData[@"last_name"];
            /* NSString *location = userData[@"location"][@"name"];
             NSString *gender = userData[@"gender"];
             NSString *birthday = userData[@"birthday"];
             NSString *relationship = userData[@"relationship_status"];
             */
            //PFUser *user = [PFUser currentUser];
            if (user)
            {
                _firstNameTextField.text = firstName;
                _lastNameTextField.text = lastName;
            }
            
            [hud hide:YES];
            
            // Now add the data to the UI elements
            // ...
        }
    }];
    
}
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) tappedOnScreen
{
    [self.view endEditing:YES];    
}

- (void) handleSwipe:( UISwipeGestureRecognizer *) recognizer {
    
    switch (recognizer.direction)
    {
        case UISwipeGestureRecognizerDirectionDown:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark UITextView delegate methods
/*
 * Erases the "place holder" in the description textView when the user starts editing
 * it.
 */

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"What better describes you"]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField==_userNameTextField)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        UITextPosition *beginning = textField.beginningOfDocument;
        UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
        UITextPosition *end = [textField positionFromPosition:start offset:range.length];
        UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
        
        // replace the text in the range with the upper case version of the replacement string
        [textField replaceRange:textRange withText:[string lowercaseString]];
        // don't change the characters automatically
        return NO;

        
        return YES;
    }
    
    return YES;
   /* if (textField.tag ==3)
    {
    // not so easy to get an UITextRange from an NSRange...
    // thanks to Nicolas Bachschmidt (see http://stackoverflow.com/questions/9126709/create-uitextrange-from-nsrange)
       }
    else
    
        return YES;*/
}
/*- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"What better describes you";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
   
    actuallyEdited = ![textView.text isEqualToString:@"What better describes you"];
    NSLog(@"actually edited? %hhd", actuallyEdited);
    
    [textView resignFirstResponder];
}*/
- (BOOL) textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    static const NSUInteger MAX_NUMBER_OF_LINES_ALLOWED = 3;
    
    NSMutableString *t = [NSMutableString stringWithString:
                          _bioTagLineTextView.text];
    [t replaceCharactersInRange: range withString: text];
    
    NSUInteger numberOfLines = 0;
    for (NSUInteger i = 0; i < t.length; i++) {
        if ([[NSCharacterSet newlineCharacterSet]
             characterIsMember: [t characterAtIndex: i]]) {
            numberOfLines++;
        }
    }
    
    return (numberOfLines < MAX_NUMBER_OF_LINES_ALLOWED);
}

- (IBAction)tappedConfirm:(id)sender
{
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //PFUser *user = [PFUser currentUser];
    if ([_bioTagLineTextView.text isEqualToString:@""])
    {
        _bioTagLineTextView.text = @"What better describes you";
        _bioTagLineTextView.textColor = [UIColor lightGrayColor]; //optional
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldTakePicture"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    actuallyEdited = ![_bioTagLineTextView.text isEqualToString:@"What better describes you"];
    
    [_bioTagLineTextView resignFirstResponder];
    [self.view endEditing:YES];
    
    float rows = round( (_bioTagLineTextView.contentSize.height - _bioTagLineTextView.textContainerInset.top - _bioTagLineTextView.textContainerInset.bottom) / _bioTagLineTextView.font.lineHeight );
    
    NSLog(@"number of rows:: %f", rows);
    
    if (actuallyEdited)
        user[@"bioTagline"] = _bioTagLineTextView.text;
    
    else
        user[@"bioTagline"] = @"";
    
    NSString *lFN = [_firstNameTextField.text lowercaseString];
    user[@"lowerFirstName"] = lFN;
    user[@"firstName"] = _firstNameTextField.text;
    user[@"lastName"] = _lastNameTextField.text;
    //user.username = _userNameTextField.text;
    
    
    if ( [allTrim(_userNameTextField.text) length] <=0)
    {
          [[[UIAlertView alloc] initWithTitle:@"Username field can't be empty." message:@"It's the last username you'll need to remember." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [hud hide:YES];
        return;
    }
    if (allTrim( _firstNameTextField.text).length<=0 || allTrim( _lastNameTextField.text).length<=0)
    {
        [[[UIAlertView alloc] initWithTitle:@"First and last name fields can't be empty." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [hud hide:YES];
        return;
    }
    
    if (_userNameTextField.text.length>=20)
    {
         [[[UIAlertView alloc] initWithTitle:@"Username too long." message:@"Please keep your username less than 20 characters long." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [hud hide:YES];

    }
    else if ([user.username isEqualToString: _userNameTextField.text])
    {
        [user setUsername:_userNameTextField.text];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (!succeeded)
                [user saveEventually];
            
        }];
        [hud hide:YES];
        
        AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        app.userReady = YES;
        RootViewController *rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
        app.window.rootViewController = rootController;
        
    }
    else
    {
        NSLog (@"new usernam");
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:_userNameTextField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error && objects.count>0) {
                    NSLog(@"%@",objects);
                    NSLog(@"USERNAME DOES EXIST");
                    [[[UIAlertView alloc] initWithTitle:@"Username taken" message:@"Please try another username" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                    [hud hide:YES];
                    //self.unique.image = [UIImage imageNamed:@"cross.png"];
                    
                } else {
                    NSLog(@"%@",objects);
                    NSLog(@"USERNAME DOESN’T EXIST");
                    
                    [user setUsername:_userNameTextField.text];
                    
                    
                    [user saveInBackground];
                    [hud hide:YES];
                    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                    app.userReady = YES;
                    RootViewController *rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
                    app.window.rootViewController = rootController;

                    //self.unique.image = [UIImage imageNamed:@"tick.png"];
                }
        }];
    }
       //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
