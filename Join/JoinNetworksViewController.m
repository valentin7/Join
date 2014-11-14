//
//  JoinNetworksViewController.m
//  Join
//
//  Created by Valentin Perez on 6/5/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "JoinNetworksViewController.h"
#import "NetworkCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ConfirmViewController.h"
#import "AddUserNameViewController.h"
#import "PresentDetailTransition.h"
#import "DismissDetailTransition.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "LIALinkedInApplication.h"
#import "LIALinkedInHttpClient.h"

//#import "RootViewController.h"

static NSString *networkCellID = @"networkCell";

@interface JoinNetworksViewController () <UIViewControllerTransitioningDelegate>
{
    NSArray *socialNetworks;
    NSMutableDictionary *userNames;
    NSMutableArray *iconNames;
    PFUser *user;
    LIALinkedInHttpClient *_client;
    AppDelegate *app;

}
@end

@implementation JoinNetworksViewController

- (void) viewDidLoad
{
    app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [_collectionView setDataSource: self];
    [_collectionView setDelegate:self];
    
    socialNetworks = [[NSArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Instagram", @"LinkedIn", @"Snapchat", @"SoundCloud", @"8tracks", @"Github", @"Tumblr", @"Pinterest", @"Email", @"Phone", @"Done", nil];
    
    iconNames = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<socialNetworks.count-1; i++)
        [iconNames addObject: [NSString stringWithFormat:@"SocialIcon%@.png", socialNetworks[i]]];

    [iconNames addObject:@"checkmark-128.png"];
    
    //iconNames = [[NSArray alloc] initWithObjects:@"SocialIconFacebook.png", @"SocialIconTwitter.png", @"SocialIconInstagram.png", @"SocialIconLinkedIn.png", @"icon-aa-facebook.png", @"icon-aa-facebook.png", @"icon-aa-facebook.png", @"checkmark-128.png", nil];
    
    _client = [self client];

   // userNames = [[NSMutableDictionary alloc] init];
    user = [PFUser currentUser];
    
   if ([PFFacebookUtils isLinkedWithUser:user])
   {
       NSLog(@"has facebookkk");
       if ([app hasInternetConnection] && !user[@"facebookID"])
           [self requestFacebookInfo];
       else
           NSLog(@"no internet or already has fbID.");
   }
    
    if ([PFTwitterUtils isLinkedWithUser:user])
    {
        NSLog(@"has twitterrr");
        if ([app hasInternetConnection])
            [self requestTwitterInfo];
        else
        {
            NSLog(@"no internet");
            
        }
    }
    else
        NSLog(@"not twiterrific");
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
# pragma mark - CollectionView methods.

- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    
    return socialNetworks.count;
    //return 27;
}


/*
 * Return 1 for number of sections.
 */
- (NSInteger) collectionView:(UICollectionView *)view numberOfSection:(NSInteger)section
{
    return 1;
}

/*
 * Displays the cells of the collectionView
 */
- (UICollectionViewCell *) collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    
    //UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:networkCellID forIndexPath:indexPath];
    NetworkCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:networkCellID forIndexPath:indexPath];
    if (indexPath.row<iconNames.count)
    {
        NSString *iconName = iconNames[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", iconName]];
    }
    if (indexPath.row==iconNames.count-1)
    {
        cell.imageView.image = [UIImage imageNamed:@"checkmark-128.png"];
    }
   // cell.usernameLabel.text = [userNames objectForKey:socialNetworks[indexPath.row]];
    
    //can't save numbers first in Parse
    if ([socialNetworks[indexPath.row] isEqualToString:@"8tracks"])
    {
        cell.usernameLabel.text = user[@"tracks8"];
    }
    else
        cell.usernameLabel.text = user[socialNetworks[indexPath.row]];
    
    cell.networkNameLabel.text = socialNetworks[indexPath.row];
    
    /*
     //cell.bounds = CGRectMake(0, 0, 102, 102);
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
     
     //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
     //label.text = @"what";
     
     [imageView setImageWithURL: photoURLs[indexPath.row]];
     [imageView setContentMode:UIViewContentModeScaleAspectFill];
     // [imageView setImage:[UIImage imageNamed:@"nmhFullMoon"]];
     [cell addSubview:imageView];
     */
    return cell;
    
}


/*
 * Handles the cell the user clicked in the collectionView.
 */
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //ViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"firstController"];
    //[self presentViewController:profileVC animated:YES completion:nil];
    // If the user clicks on the last collectionViewCell, or the 'Done' cell, show the user's profile.
    NSLog(@"TOUCHING CELL");
    if (indexPath.row == socialNetworks.count-1)
    {
        /*for (int i = 0; i<[userNames allValues].count; i++)
        {
            user[[userNames allKeys][i]] = [userNames allValues][i];
        }
        [user saveInBackground];
         */
        NSLog(@"TOUCHING DONNNEEEE");
        
        if ([PFFacebookUtils isLinkedWithUser:user])
        {
            ConfirmViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmController"];
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.transitioningDelegate = self;
            
            [self presentViewController:vc animated:YES completion:nil];
            return;
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Integrate Facebook" message:@"Join is currently much better with Facebook. Remember, the more networks you join, the better." delegate:self cancelButtonTitle:@"Sure" otherButtonTitles: nil] show];
            return;
        }
        
        
    }
    NSLog(@"trying to link new social network");
    
    //PFUser *user = [PFUser currentUser];
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"trying to link Facebook");
            
            if (![PFFacebookUtils isLinkedWithUser:user]) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NSArray *permissionsArray = @[@"user_groups", @"user_friends"];

                [PFFacebookUtils linkUser:user permissions:permissionsArray block:^(BOOL succeeded, NSError *error) {
                    if ([PFFacebookUtils isLinkedWithUser:user]) {
                        NSLog(@"Woohoo, user logged in with Facebook!");
                        [self requestFacebookInfo];
                          //[[[UIAlertView alloc] initWithTitle:@"Joined Facebook" message:@"Succesfully linked your Facebook!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                        
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"Joined your Facebook!";
                        hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
                        [hud hide:YES afterDelay:1.8];
                        [_collectionView reloadData];
                        
                    }
                    else
                    {
                        [hud hide:YES];
                        NSLog(@"error %@", error);
                        if (error.code==208)
                        {
                            [[[UIAlertView alloc] initWithTitle:@"Oops." message:@"Another user is already linked to this Facebook id. You can switch account by going the settings app."
                                        delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                        }
                        else
                        {
                           /*[[[UIAlertView alloc] initWithTitle:@"Oops" message:error.description
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];*/
                            NSLog(@"error: %@", error.description);
                            
                        }
                        
                    }
                }];
            }
            else
            {
                NSLog(@"user is already linked with Facebook");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook already linked" message:@"Do you want to unlink Facebook?" delegate:self cancelButtonTitle:@"No, leave it" otherButtonTitles:@"Unlink", nil];
                alert.tag = 1;
                [alert show];
                
            }
            NSLog(@"nothing happeneedddede");
        }
            break;
        case 1:
        {
            NSLog(@"trying to link Twitter");
            
            if (![PFTwitterUtils isLinkedWithUser:user]) {
                
               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                [PFTwitterUtils linkUser:user block:^(BOOL succeeded, NSError *error) {
                    if ([PFTwitterUtils isLinkedWithUser:user]) {
                        NSLog(@"Woohoo, user logged in with Twitter!");
                        NSString *twitterName = [[PFTwitterUtils twitter] screenName];
                        user[@"Twitter"] = twitterName;
                        [user saveEventually];
                        //[[[UIAlertView alloc] initWithTitle:@"Joined Twitter" message:@"Succesfully linked your Twitter!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                    
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"Joined your Twitter!";
                        hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
                        [hud hide:YES afterDelay:1.8];
                        [_collectionView reloadData];

                    }
                    else
                    {
                        NSLog(@"error %@", error);
                        if (error.code==208)
                        {
                            [[[UIAlertView alloc] initWithTitle:@"Oops." message:@"Another user is already linked to this Twitter id. You can switch account by going the settings app."
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                        }
                        else
                        {
                            [[[UIAlertView alloc] initWithTitle:@"Oops" message:error.description
                                                       delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                            
                        }
                        [hud hide:YES];
                    }
                }];
            }
            else
            {
                NSLog(@"user is already linked with Twitter");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter already linked" message:@"Do you want to unlink Twitter?" delegate:self cancelButtonTitle:@"No, leave it" otherButtonTitles:@"Unlink", nil];
                alert.tag = 2;
                [alert show];
            }
            NSLog(@"nothing happeneedddede");
            
        }
            break;
        case 3:
        {
            if ([user[@"LinkedIn"] length]>1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LinkedIn already linked" message:@"Do you want to unlink LinkedIn?" delegate:self cancelButtonTitle:@"No, leave it" otherButtonTitles:@"Unlink", nil];
                alert.tag = 3;
                [alert show];
            }
            else
            {
                [self requestLinkedInInfo];
            }
        }
            break;
        default:
        {
            AddUserNameViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addUserNameController"];
            vc.delegate = self;
            vc.networkName = socialNetworks[indexPath.row];
            vc.imageString = iconNames[indexPath.row];
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.transitioningDelegate = self;
            
            [self presentViewController:vc animated:YES completion:nil];
            
        }
            break;
    }
   
    //self.window.rootViewController = self.pageViewController;

    // indexClicked = (int) indexPath.row;
    // [self performSegueWithIdentifier:@"displayFlickrPhotoSegue" sender:self];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Unlink"])
    {
        switch (alertView.tag) {
            case 1:
            {
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"The user is no longer associated with their Facebook account.");
                        user[@"Facebook"] = @"";
                        user[@"facebookID"] = @"";
                       
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"Facebook unlinked";
                        hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
                        [hud hide:YES afterDelay:1.8];
                        [_collectionView reloadData];

                    }
                }];
                
            }
                break;
            case 2:
            {
               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                [PFTwitterUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
                    if (!error && succeeded) {
                        NSLog(@"The user is no longer associated with their Twitter account.");
                        user[@"Twitter"] = @"";
                        
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"Twitter unlinked";
                        hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
                        [hud hide:YES afterDelay:1.8];
                        [_collectionView reloadData];
                    }
                }];
                
            }
                break;
            case 3:
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                user[@"LinkedIn"] = @"";
                user[@"LinkedInID"] = @"";
                user[@"LinkedInHeadline"] = @"";
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"LinkedIn unlinked";
                hud.labelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
                [hud hide:YES afterDelay:1.8];
                [_collectionView reloadData];
            }
                break;
            default:
                break;
        }
        [user saveEventually];
        
    }
    
}


#pragma  mark -  Social Network Methods

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
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
           /* NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            */
            //PFUser *user = [PFUser currentUser];
            if (user)
            {
                user[@"Facebook"] = name;
                user[@"facebookID"] = facebookID;
                [user saveEventually];
                NSLog(@"Current User %@ with fbID: %@", user, facebookID);
                
            }
            
            //[userNames setObject:name forKey:@"Facebook"];
            [hud hide:YES];
            
            [_collectionView reloadData];
            
          
            // Now add the data to the UI elements
            // ...
        }
    }];
    
}

- (void) requestTwitterInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
   
    PF_Twitter *twitter = [PFTwitterUtils twitter];
    
    NSLog(@"twitter infoo:: %@", twitter.screenName);
    if (twitter.screenName)
    {
        //[userNames setObject:twitter.screenName forKey:@"Twitter"];
        user[@"Twitter"] = twitter.screenName;
    }
    NSLog(@"doing again twitter with screenname: %@", twitter.screenName);
    [_collectionView reloadData];
    [hud hide:YES];
    
}

- (void) requestLinkedInInfo
{
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
    
   
    
}
- (void)requestMeWithToken:(NSString *)accessToken {
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        NSString *url = result[@"siteStandardProfileRequest"][@"url"];
        NSString *lID = [self getLinkedInIDForURL:url];
        user[@"LinkedInID"] = lID;
        user[@"LinkedIn"] = [NSString stringWithFormat:@"%@ %@", result[@"firstName"], result[@"lastName"]];
        user[@"LinkedInHeadline"] = result[@"headline"];
        [user saveEventually];
        [self justAddedUser:lID];
    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"There was an error getting your LinkedIn profile" message:@"Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        NSLog(@"failed to fetch current user %@", error);
    }];
    [_collectionView reloadData];

}

- (LIALinkedInHttpClient *)client
{
LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://joinprofile.com"
                                                                                clientId:@"75jo8mtmt4vt28"
                                                                            clientSecret:@"z22i8oECJYzamXmz"
                                                                                   state:@"VCEEFWF45453sdffef424"
                                                                           grantedAccess:@[@"r_basicprofile"]];

return [LIALinkedInHttpClient clientForApplication:application presentingViewController:self];
}

- (NSString *) getLinkedInIDForURL: (NSString *) url
{
    NSString *linkedInID;
    NSRange range;
    int length=1;
    for (int i = 0; i<url.length; i++)
    {
        if ([url characterAtIndex:i]=='=')
        {
            range = [url rangeOfString:@"id="];
            int final;
            length =0;
            for (int i = range.location; i<url.length; i++)
            {
                length++;
                if ([url characterAtIndex:i]=='&')
                {
                    final = i;
                    length-=3;
                    break;
                }
            }
        }
        
    }
    NSRange realRange = NSMakeRange(range.location+3,length-1);
    
    linkedInID =[url substringWithRange:realRange];
    NSLog(@"linked in id found: %@", linkedInID);
    return linkedInID;
    
}


#pragma mark - AddUserNameViewController Delegate Methods
- (void) justAddedUser:(NSString *)title
{
    NSLog(@"just added this user: %@", title);
    [_collectionView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PresentDetailTransition alloc] init];
    
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissDetailTransition alloc] init];
    
}

@end
