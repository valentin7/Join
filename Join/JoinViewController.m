//
//  JoinViewController.m
//  Join
//
//  Created by Valentin Perez on 6/5/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "JoinViewController.h"
#import "JoinNetworksViewController.h"
#import "AppDelegate.h"
#import "PageContentViewController.h"
#import "RootViewController.h"
#import "MBProgressHUD.h"

@interface JoinViewController ()
{
    UISwipeGestureRecognizer *swipeDownGesture;
    SemiCircleProfile *semiCircleProfile;
    AppDelegate *app;

}
@end

@implementation JoinViewController

- (void) viewDidLoad
{
    app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    //[self presentViewController:joinViewController animated:YES completion:nil];
    // [app.window setRootViewController:rootController];
     [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide ];
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    semiCircleProfile = [[SemiCircleProfile alloc] initWithPoint:CGPointMake(25, 262)
                                                                             radius:170
                                                                             inView:self.view withImageURL:nil];
    semiCircleProfile.delegate = self;
    semiCircleProfile.bubbleRadius = 30; // Default is 40
    semiCircleProfile.imageName = @"none";
    semiCircleProfile.isForJoining = YES;
    semiCircleProfile.showFacebookBubble = YES;
    //semiCircleProfile.showLinkedInBubble = YES;
    //semiCircleProfile.showMailBubble = YES;
    semiCircleProfile.showTwitterBubble = YES;
    
    [self performSelector:@selector(showBubbles) withObject:nil afterDelay:.5];
    
    //UISwipeGestureRecognizer *
    
    swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
   // [self.view addGestureRecognizer: swipeDownGesture ];
    

}
- (void) showBubbles
{
    [semiCircleProfile show];

    
}
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

-(void)semiCircleProfile:(SemiCircleProfile *)SemiCircleProfile tappedBubbleWithType:(BubbleType)bubbleType
{
    NSLog(@"tappedBubble");
    // NSString *userName = @"valentin_pd";
    
    if (![app hasInternetConnection])
    {
        [self showBubbles];
        return;
    }

    switch (bubbleType) {
        case BubbleTypeFacebook:
        {
            NSLog(@"Facebook");
            [self performSelector:@selector(logInWithFacebook)];
            
        }
            break;
        case  BubbleTypeLinkedIn:
        {
            [self performSelector:@selector(tappedLinkedIn)];
        }
            break;
        case BubbleTypeTwitter:
        {
            NSLog(@"twitter bubble");
            [self performSelector:@selector(logInWithTwitter)];
           // [self performSelector:@selector(tappedTwitter)];
            
        }
            break;
        case BubbleTypeMail:
        {
            [self performSelector:@selector(tappedEmail)];

        }
            break;
        default:
            break;
    }
    
  
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) logInWithFacebook
{
    // The permissions requested from the user
    //NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
   NSArray *permissionsArray = @[@"user_groups", @"user_friends"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [hud hide:YES];

        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                [self showBubbles];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                if ( error.code == 2)
                {
                    [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must allow access to your Facebook account. You can manage what can access your Facebook in the Settings app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];

                }
                else
                  [[[UIAlertView alloc] initWithTitle:@"Oops" message:error.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                
                [self showBubbles];

            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self showStartingNextView];
           
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
            [self showNextView];
            
        }
    }];
    
    
    
}

-(void) logInWithTwitter
{
    NSLog(@"twitter");
    /*__weak JoinViewController *weakSelf = self;
    [PFTwitterUtils getTwitterAccounts:^(BOOL accountsWereFound, NSArray *twitterAccounts) {
        [weakSelf handleTwitterAccounts:twitterAccounts];
    }];
    */
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    //hud.labelText = @"Loading";

    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        [hud hide:YES];

        NSLog(@"trying to lig in with twitter");
        if (!user) {
            if (error){
                NSLog(@"error: %@",error);
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:error.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
            else
            {
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                [self showBubbles];

            }
            return;
        } else if (user.isNew) {
            
            //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.labelText = @"Creating new account";
           NSString *twitterName = [[PFTwitterUtils twitter] screenName];
            user[@"Twitter"] = twitterName;
            [user saveEventually];
            NSLog(@"User signed up and logged in with Twitter!");
            [self showStartingNextView];
        } else {
            hud.labelText = @"Logging you in";
            
            NSLog(@"User logged in with Twitter!");
            [self showNextView];
            
        }
        
    }];
    
}
/*
#pragma mark - Twitter Login Methods

- (void)handleTwitterAccounts:(NSArray *)twitterAccounts
{
    switch ([twitterAccounts count]) {
        case 0:
        {
            // This will be covered in the Next Section
        }
            break;
        case 1:
            [self onUserTwitterAccountSelection:twitterAccounts[0]];
            break;
        default:
            self.twitterAccounts = twitterAccounts;
            [self displayTwitterAccounts:twitterAccounts];
            break;
    }
    
}

- (void)displayTwitterAccounts:(NSArray *)twitterAccounts
{
    __block UIActionSheet *selectTwitterAccountsActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Twitter Account";
                                                                                          delegate:self
                                                                                 cancelButtonTitle:nil
                                                                            destructiveButtonTitle:nil
                                                                                 otherButtonTitles:nil];
    
    [twitterAccounts enumerateObjectsUsingBlock:^(id twitterAccount, NSUInteger idx, BOOL *stop) {
        [selectTwitterAccountsActionSheet addButtonWithTitle:[twitterAccount username]];
    }];
    selectTwitterAccountsActionSheet.cancelButtonIndex = [selectTwitterAccountsActionSheet addButtonWithTitle:@"Cancel"];
    
    [selectTwitterAccountsActionSheet showInView:self.view];
}

- (void)onUserTwitterAccountSelection:(ACAccount *)twitterAccount
{
    // Login User with the Appropriate Account
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self onUserTwitterAccountSelection:self.twitterAccounts[buttonIndex]];
    }
}
*/
- (void) showStartingNextView
{
    JoinNetworksViewController *joinNetworksVC = [self.storyboard instantiateViewControllerWithIdentifier:@"joinNetworksController"];
    [self presentViewController:joinNetworksVC animated:YES completion:nil];
    
}
- (void) showNextView
{
   // AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    app.userReady = YES;
    RootViewController *rootController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
    app.window.rootViewController = rootController;

    
}
- (void) tappedLinkedIn
{
    NSLog(@"linkedss");
    
}

- (void) tappedEmail
{
    
    
}

- (void) requestFacebookInfo
{
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            /*
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            */
            // Now add the data to the UI elements
            // ...
        }
    }];
    
}

- (void) hideAll
{
    _describeButton.hidden = YES;
    _joinWithLabel.hidden = YES;
    _joinLogoImageView.hidden = YES;
    semiCircleProfile.hidden = YES;
    
}
- (IBAction)clickedBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)clickedDescribe:(id)sender
{
    [self hideAll];
   /* NSArray  *_pageTitles = @[@"Share your Join profile: share all your networks.", @"The ultimate personal profile.", @"Find people and connect with them in all their social networks.", @"Discover people within your groups."];
   NSArray *_pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    // Create page view controller
    
    
   UIPageViewController *pageViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height - 60);
    //self.pageViewController.view.frame = CGRectMake(0, 0, , self.pageViewController.view.frame.size.height - 30);
    
    //[self presentViewController:_pageViewController animated:NO completion:nil];
    //[self addChildViewController:_pageViewController];
    //[self.view addSubview:_pageViewController.view];
    //[self.pageViewController didMoveToParentViewController:self];
    // Set the root controller to the signInVC so that there is no glimpse of the findVC
    self.window.rootViewController = self.pageViewController;
    
    */
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
     AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [app showWalkthrough];
    
}
@end
