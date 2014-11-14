//
//  DetailNetworkViewController.m
//  Join
//
//  Created by Valentin Perez on 7/20/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "DetailNetworkViewController.h"
#import "ThirdViewController.h"
#import "MBProgressHUD.h"

@implementation DetailNetworkViewController
{    NSString *userName;
    BOOL inContacts;
}
@synthesize user;
- (void) viewDidLoad
{
    //user = [PFUser currentUser];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.80];
    _networkImage.image = [UIImage imageNamed:_networkImageString];
    _networkLabel.text = _networkName;
    
    userName = [[NSString alloc] init];
    [_extraButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_primaryButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

    if ([_networkName isEqualToString:@"Facebook"])
    {
        _extraButton.hidden = YES;
        //[_extraButton setImage:[UIImage imageNamed:@"IconAddFriend.png"] forState:UIControlStateNormal];
    }
    else if ([_networkName isEqualToString:@"Twitter"])
    {
        _extraButton.hidden = YES;
        //[_extraButton setImage:[UIImage imageNamed:@"IconMenuBurger.png"] forState:UIControlStateNormal];
    }
    else if ([_networkName isEqualToString:@"Phone"])
    {
        _extraButton.hidden = NO;
        [_primaryButton setImage:[UIImage imageNamed:@"text-256-white.png"]
                        forState:UIControlStateNormal];
        [_extraButton setImage:[UIImage imageNamed:@"phone-256-white.png"]
                        forState:UIControlStateNormal];
    }
    else if ([_networkName isEqualToString:@"Join"])
    {
        _extraButton.hidden = NO;
        _primaryButton.imageView.image = nil;
        //_extraButton.imageView.image = nil;
        
        if (!_isOtherUser)
            [_primaryButton setTitle:@"See my contacts" forState:UIControlStateNormal];
        else
        {
            NSLog(@"going to check");
           if ([self userAlreadyInContacts:user])
               [_primaryButton setTitle:@"Remove from contacts" forState:UIControlStateNormal];
            else
                [_primaryButton setTitle:@"Add to contacts" forState:UIControlStateNormal];

        }
        
        //[_primaryButton setImage:[UIImage imageNamed:@"add-64-white.png"] forState:UIControlStateNormal];
        //[_extraButton setImage:[UIImage imageNamed:@"IconMenuBurger.png"] forState:UIControlStateNormal];
    }
    else
        _extraButton.hidden = YES;
    
    
    
    if ([_networkName isEqualToString:@"8tracks"])
        userName = user[@"tracks8"];
    else if ([_networkName isEqualToString:@"Join"])
        userName = user.username;
    else
        userName =  user[_networkName];
    
    _userNameTextView.text = userName;
   
    
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
   // [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) userAlreadyInContacts: (PFUser *) userToCheck
{
    NSLog(@"checking if in contacts");
    PFUser *currentUser = [PFUser currentUser];
    NSArray *contacts = currentUser[@"contactos"];
    for (int i = 0; i< contacts.count; i++)
    {
        //NSLog(@"userToCheckId: %@ contact:%@", userToCheck.objectId, currentUser[@"contacts"][i][@"objectId"]);
        NSLog(@"doing user %d", i);
        if (!contacts[i][@"objectId"])
        {
            NSLog(@"objectId is nil!!!!");
            return NO;
        }
        if ([contacts[i][@"objectId"] isEqualToString: userToCheck.objectId])
        {
            NSLog(@"is in contacts");
            inContacts = YES;
            return YES;
        }
    }
    NSLog(@"is NOT in contacts");

    inContacts = NO;
    return NO;
}

- (void) removeUser: (PFUser *) userToRemove fromContactsOf: (PFUser *) userO
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
   
    for (int i =0; i<[userO[@"contactos"] count]; i++)
    {
        if ([userToRemove.objectId isEqualToString:userO[@"contactos"][i][@"objectId"]])
        {
            [userO[@"contactos"] removeObjectAtIndex:i];
            
            [userO saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (!succeeded)
                {
                    [userO saveEventually];
                    NSLog(@"removing contact eventually");
                }
                else
                    NSLog(@"removed already contacts");
                
                /*hud.mode = MBProgressHUDModeText;
                hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
                hud.labelText = @"Removed from contacts";
                 */
                
                if ([self.delegate respondsToSelector:@selector(contactsChanged)])
                {
                    [self.delegate contactsChanged];
                }
                [hud hide:YES afterDelay:0];
                 
                [_primaryButton setTitle:@"Add to contacts" forState:UIControlStateNormal];

            }];
            return;

        }
    }
    
    NSLog(@"didn't find it nor remove it");
}
- (void) saveUser: (PFUser *) userToSave inContactsOf: (PFUser *) userO
{
    if (userO == user)
    {
        NSLog(@"yourself");
        [[[UIAlertView alloc] initWithTitle:nil message:@"That's how you add a user to your contacts. Try with others other than yourself." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        return;
    }
    
    NSDictionary *neededOfUser;
    if (userToSave[@"facebookID"])
        neededOfUser = @{@"objectId": userToSave.objectId, @"firstName":userToSave[@"firstName"], @"lastName": userToSave[@"lastName"], @"username": userToSave.username, @"facebookID": userToSave[@"facebookID"]};
    else
        neededOfUser = @{@"objectId": userToSave.objectId, @"firstName":userToSave[@"firstName"], @"lastName": userToSave[@"lastName"], @"username": userToSave.username};
    
    if (userO[@"contactos"])
    {
        NSMutableArray *currentContacts = [userO[@"contactos"] mutableCopy];
       // PFObject *currentContactss = currentContacts;
                                       
        NSLog(@"adding usertosave: %@", userToSave);
        NSLog(@"added neededOfUser: %@", neededOfUser);
        NSLog(@"currentContacts before: %@", currentContacts);
        [currentContacts addObject:neededOfUser];
        //NSArray *newContacts = [NSArray arr]
        userO[@"contactos"] = currentContacts;
        NSLog(@"currentContacts after: %@", currentContacts);

        //[currentUser[@"contacts"] addObject:user];
    }
    else
    {
        userO[@"contactos"] = [[NSArray alloc] initWithObjects: neededOfUser, nil];
        NSLog(@"no existian contacts");
    }
    NSLog(@"all contactos: %@", userO[@"contactos"]);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    [userO saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!succeeded)
        {
            [userO saveEventually];
            NSLog(@"saving contacts eventually");
        }
        else
            NSLog(@"saved already contacts");
        
        if ([self.delegate respondsToSelector:@selector(contactsChanged)])
        {
            [self.delegate contactsChanged];
        }
        /*hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Saved to contacts";
         hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];*/
        [hud hide:YES afterDelay:0];
        [_primaryButton setTitle:@"Remove from contacts" forState:UIControlStateNormal];
    }];
    
}
- (IBAction)openInApp:(id)sender
{
    NSLog(@"oppan gagnam style");
    NSString *stringURL;
   // NSString *userName = @"valentinperezd";
    
    if ([_networkName isEqualToString:@"Instagram"])
    {
        stringURL = [NSString stringWithFormat: @"instagram://user?username=%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [self openURL:url];
        }
        else
            stringURL = [NSString stringWithFormat: @"http://instagram.com/%@", userName];
    }
    else if ([_networkName isEqualToString:@"Facebook"])
    {
        userName = user[@"facebookID"];
        if (!_isOtherUser)
            stringURL = @"fb://profile/";
        else
        {
            // this is what it should be, but Facebook's url scheme is not working..
            stringURL = [NSString stringWithFormat: @"fb://profile/app_scoped_user_id/%@/", userName];
            stringURL = [NSString stringWithFormat:@"https://www.facebook.com/app_scoped_user_id/%@/", userName];
        }
        
        NSURL *url = [NSURL URLWithString:stringURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [self openURL:url];
        }
        else
        {
            stringURL = [NSString stringWithFormat:@"https://www.facebook.com/app_scoped_user_id/%@/", userName];
        }
    }
    else if ([_networkName isEqualToString:@"Twitter"])
    {
        stringURL = [NSString stringWithFormat: @"twitter://user?screen_name=%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [self openURL:url];
        }
        else
            stringURL = [NSString stringWithFormat: @"http://twitter.com/%@", userName];
    }
    else if ([_networkName isEqualToString:@"LinkedIn"])
    {
        userName = user[@"LinkedInID"];
        stringURL = [NSString stringWithFormat: @"linkedin://profile/%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [self openURL:url];
        }
        else
            stringURL = [NSString stringWithFormat: @"https://www.linkedin.com/profile/view?id=%@", userName];
    }
    else if ([_networkName isEqualToString:@"8tracks"])
        stringURL = [NSString stringWithFormat: @"http://8tracks.com/%@", userName];
    else if ([_networkName isEqualToString:@"Github"])
        stringURL = [NSString stringWithFormat: @"http://github.com/%@", userName];
    else if ([_networkName isEqualToString:@"Tumblr"])
        stringURL = [NSString stringWithFormat: @"http://%@.tumblr.com", userName];
    else if ([_networkName isEqualToString:@"Snapchat"])
    {
        stringURL = [NSString stringWithFormat: @"snapchat://?u=%@", userName];
         [[UIPasteboard generalPasteboard] setString:userName];
       MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"%@ copied to clipboard!", userName];
        hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
        [hud hide:YES afterDelay:1.5];
    }
    else if ([_networkName isEqualToString:@"SoundCloud"])
    {
        stringURL = [NSString stringWithFormat: @"soundcloud://users/%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];

        //if (![[UIApplication sharedApplication] canOpenURL:url])
            stringURL = [NSString stringWithFormat: @"http://soundcloud.com/%@", userName];
        NSLog(@"final soundc : %@", stringURL);
    }
    else if ([_networkName isEqualToString:@"Pinterest"])
    {
        stringURL = [NSString stringWithFormat: @"pinterest://user/%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [self openURL:url];
        }
        else
            stringURL = [NSString stringWithFormat: @"http://pinterest.com/%@", userName];
            
        NSLog(@"final pinterest : %@", stringURL);
    }
    else if ([_networkName isEqualToString:@"LinkedIn"])
    {
        userName = @"227975402";
        userName = @"281997738";
        stringURL = [NSString stringWithFormat: @"linkedin://#profile/%@", userName];
        NSURL *url = [NSURL URLWithString:stringURL];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [self openURL:url];
        }
        else
            stringURL = [NSString stringWithFormat: @"https://www.linkedin.com/profile/view?id=%@", userName];
        
        NSLog(@"final LinkedIn : %@", stringURL);
    }
    else if ([_networkName isEqualToString:@"Phone"])
        stringURL = [NSString  stringWithFormat:@"sms:%@",userName];
    else if ([_networkName isEqualToString:@"Join"])
    {
        PFUser *currentUser = [PFUser currentUser];
        if (!_isOtherUser)
        {
            NSLog (@"will show WHAT IS THIS");
            ThirdViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdController"]; 
            [self presentViewController:vc animated:YES completion:nil];
            
            return;
        }
       
        if (!inContacts)
        {
            [self saveUser:user inContactsOf:currentUser];
        }
        else
        {
            NSLog(@"trying to remove user from contacts");
            [self removeUser:user fromContactsOf:currentUser];
            
        }
        return;
    }
   // stringURL = [NSString  stringWithFormat:@"telprompt:%@",userName];

    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    if ([_networkName isEqualToString:@"Snapchat"])
    {
        [self performSelector:@selector(openURL:) withObject:url afterDelay:1.5];
    }
    else
        [self openURL:url];
    
    //[[UIApplication sharedApplication] openURL:url];
    
}
- (void) openURL: (NSURL *) url
{
    NSLog(@"opening urlL: %@", url);
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Oops" message:[NSString stringWithFormat:@"Can't open %@", _networkName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [calert show];
    }
    
}
- (void) shareProfileOfOther: (BOOL)isOther
{
    NSArray *socialNetworks = [[NSArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Instagram", @"LinkedIn", @"Snapchat", @"Spotify", @"Pinterest", @"SoundCloud", @"tracks8", @"Github", @"Tumblr", @"Email", @"Phone", nil];
    
    NSString *description;
    if (isOther)
        description = [NSString stringWithFormat:@"Simplifying life: all networks in one. Check out this Join profile as: %@. Make yours at: www.joinprofile.com", user.username];
    else
        description = [NSString stringWithFormat:@"I simplify my life: all my networks in one. Find me on Join as: %@. Simplify your life at: www.joinprofile.com", user.username];
    
    for (NSString *network in socialNetworks)
    {
        if ([user[network] length]>0 )
        {
            if ([network isEqualToString:@"tracks8"])
            {
                description = [description stringByAppendingString: [NSString stringWithFormat:@"\n8tracks: %@", user[network]]];
            }
            else
            {
                description = [description stringByAppendingString: [NSString stringWithFormat:@"\n%@: %@", network, user[network]]];
            }
        }
    }
    
    NSLog(@"description is: %@", description);
    UIImage *imageToShare;
    NSArray *activityItems;
    NSString *imageName = [NSString stringWithFormat:@"joinImageForUser%@", user.objectId];
    if ([self loadImageWithName:imageName])
    {
        imageToShare = [self loadImageWithName:imageName];     activityItems = @[description, imageToShare];
    }
    else
        activityItems = @[description];
    
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
    
    
}

- (void) sendFacebookFriendRequest
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"d", @"app_id",
                                   @"", @"id",
                                   nil];
    /*
    
    [FBWebDialogs presentDialogModallyWithSession:nil dialog:@"friends" parameters:[params mutableCopy] handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
    {
        if (error) {
            // Error launching the dialog or sending the request.
            NSLog(@"Error sending request.");
        }
        else
        {
            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"User canceled request.");
            }
            else
            {
                NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                if (![urlParams valueForKey:@"request"])
                {
                    // User clicked the Cancel button
                    NSLog(@"User canceled request.");
                }
                else
                {
                    // User clicked the Send button
                    NSString *requestID = [urlParams valueForKey:@"request"];
                    NSLog(@"Request ID: %@", requestID);
                }
                
            }
        }
    } delegate:self];
     */
    
}
- (UIImage *)loadImageWithName: (NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: name] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

- (IBAction)tappedExtraButton:(id)sender
{
    
    if ([_networkName isEqualToString:@"Phone"])
    {
        NSMutableString *phone = [userName mutableCopy];
        [phone replaceOccurrencesOfString:@" "
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [phone length])];
        [phone replaceOccurrencesOfString:@"("
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [phone length])];
        [phone replaceOccurrencesOfString:@")"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [phone length])];
       NSString *stringURL = [NSString  stringWithFormat:@"tel:%@",phone];
        
        NSURL *url = [NSURL URLWithString:stringURL];
        
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Can't call to that number" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
    }
    else if ([_networkName isEqualToString:@"Join"])
    {
        [self shareProfileOfOther:_isOtherUser];
    }

}
@end
