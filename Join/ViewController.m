//
//  ViewController.m
//  Join
//
//  Created by Valentin Perez on 4/13/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "ViewController.h"
#import "UIKit+AFNetworking.h"
#import "JoinNetworksViewController.h"
#import "PresentDetailTransition.h"
#import "DismissDetailTransition.h"
#import "DetailNetworkViewController.h"
#import "SettingsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"

#import "JazzHandsViewController.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@interface ViewController () <UIViewControllerTransitioningDelegate>
{
    NSMutableArray *circlesToShow;
    NSArray *locationsForProfile;
    int profilePictureRadius;
    int semiCircleY;
    AppDelegate *app;
}
@property (nonatomic) UIDynamicAnimator *animator;

@end

@implementation ViewController

@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*JazzHandsViewController *jhvc = [JazzHandsViewController new];
    jhvc.view.backgroundColor = [UIColor whiteColor];
    //self.window.backgroundColor = [UIColor whiteColor];
    
    //[self.view makeKeyAndVisible];
    [self presentViewController:jhvc animated:YES completion:nil];
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
     */
    //[self setPanGesture];
	// Do any additional setup after loading the view, typically from a nib.
    circlesToShow = [[NSMutableArray alloc] init];
    circlesToShow = [NSMutableArray arrayWithObjects:BubbleTypeFacebook,BubbleTypeLinkedIn, BubbleTypeMail, nil];
    //[self setNeedsStatusBarAppearanceUpdate];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    profilePictureRadius = 95;
    semiCircleY = 275;
    
    if (!_isOtherUser)
    {
        user = [PFUser currentUser];
       // _settingsButton.hidden = NO;
    }
    else
    {
        NSLog(@"should be other user");
        [_menuBurgerButton setImage:[UIImage imageNamed:@"back-256.png"] forState:UIControlStateNormal];
        _settingsButton.hidden = YES;
    }
    //NSLog(@"User's username: %@", user[@"username"]);
    //NSLog(@"User's passwo;rd: %@", user.password);
    NSLog(@"user displaying:: %@", user);
    NSLog(@"User's email: %@", user[@"Email"]);
    NSLog(@"User's fbID: %@", user[@"facebookID"]);
    NSLog(@"users bio: %@", user[@"bioTagline"]);
    _bioTagLineTextView.text = user[@"bioTagline"];
    _firstNameLabel.text = user[@"firstName"];
    _lastNameLabel.text = user[@"lastName"];
    
    
    [self setCoverPhoto];
    
    //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", user[@"facebookID"]]];
    


    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    [overlayView setBackgroundColor:[UIColor blackColor]];
    overlayView.alpha = .55;
    [self.view insertSubview:overlayView aboveSubview:_backgroundImageView];
    
   // UIPageControl *pControl = [[UIPageControl alloc] initWithFrame: CGRectMake(0, 0, 80, 20)];
    
   // [self.view insertSubview:pControl atIndex:5];
    
    if (IS_IPHONE_5)
    {
        //_pageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(_pageControl.frame.origin.x, _pageControl.frame.origin.y+30, _pageControl.frame.size.width, _pageControl.frame.size.height)];
       // _pageControl.center = CGPointMake(_pageControl.center.x, _pageControl.center.y+30);
        //pControl.frame = CGRectOffset(_pageControl.frame, 0, 30);
    }
    
    locationsForProfile = [NSArray arrayWithObjects: @"25", @"100", @"300", nil];
    
    [self setUpSemiCircleProfile: circlesToShow];
    [_semiCircleProfile show];
    
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer: swipeRightGesture];
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer: swipeLeftGesture];
    
   
}

- (void) viewDidAppear:(BOOL)animated
{
    // Put the settings button above the semicircle profile so that it can sense touches.
    //[self.view insertSubview:_settingsButton aboveSubview:_semiCircleProfile];
    //user[@"Networks"] = [NSDictionary dictionaryWithObjectsAndKeys:@"valentinp7", @"Twitter", @"hey", @"Snapchat", nil];
    //[user saveInBackground];
   // NSLog(@"username: %@", user[@"username"]);
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:[NSString stringWithFormat:@"coverPhotoOfUser%@", user[@"username"]]])
    {
        NSURL *url = [NSURL URLWithString:[defaults objectForKey:[NSString stringWithFormat:@"coverPhotoOfUser%@",user[@"username"]]]];
        
        [_backgroundImageView setImageWithURL:url];
        NSLog(@"trying to set it brah");
        //// return;
    }*/
    
}

- (void) setPanGesture
{
    self.view.multipleTouchEnabled = NO;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
}
- (void)panGestureRecognized
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setCoverPhoto
{
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"facebookID::: %@", user[@"facebookID"]);
    if ([self loadImageWithName:[NSString stringWithFormat:@"coverPhotoOfUser%@", user[@"facebookID"]]])
    {
        [_backgroundImageView setImage:[self loadImageWithName:[NSString stringWithFormat:@"coverPhotoOfUser%@", user[@"facebookID"]]]];
        NSLog(@"trying to set it brah with facebookID: %@", user[@"facebookID"]);
    }
    /*if ([ defaults objectForKey:[NSString stringWithFormat:@"coverPhotoOfUser%@", user[@"username"]]])
    {
        NSURL *url = [NSURL URLWithString:[defaults objectForKey:[NSString stringWithFormat:@"coverPhotoOfUser%@",user[@"username"]]]];
        [_backgroundImageView setImageWithURL:url];
        NSLog(@"trying to set it brah");
       //// return;
    }*/
    NSString *path = [NSString stringWithFormat:@"/%@?fields=cover", user[@"facebookID"]];
    /* make the API call for the Cover Photo */
    [FBRequestConnection startWithGraphPath:path
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              // NSLog(@"Cover result: %@", result);
                              //NSString *url = [[result objectForKey:@"cover"] objectForKey:@"source"];
                              //[_backgroundImageView setImageWithURL:[NSURL URLWithString:url]];
                              
                              
                              NSString *graphPathForCovers = [NSString stringWithFormat:@"/%@?fields=images", [[result objectForKey:@"cover"] objectForKey:@"id" ] ];
                              
                             
                              /* make an API call again because we want the highest quality photo*/
                              [FBRequestConnection startWithGraphPath:graphPathForCovers
                                                           parameters:nil
                                                           HTTPMethod:@"GET"
                                                    completionHandler:^(
                                                                        FBRequestConnection *connection,
                                                                        id result,
                                                                        NSError *error
                                                                        ) {
                                                        /* handle the result */
                                                        NSString *url = [[[result objectForKey:@"images"] objectAtIndex:0] objectForKey:@"source"];
                                                        [_backgroundImageView setImageWithURL:[NSURL URLWithString:url]];
                                                        
                                            //            UIImage *coverImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: url]]];
                                                        NSURL *urlT = [NSURL URLWithString:url];
                                                        NSURLRequest *request = [NSURLRequest requestWithURL:urlT];
                                                        
                                                        if (!_isOtherUser)
                                                        {
                                                            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                                                            operation.responseSerializer = [AFImageResponseSerializer serializer];
                                                            
                                                            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                
                                                                UIImage *coverImage = (UIImage *)responseObject;
                                                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                    [self saveImage:coverImage withName:[NSString stringWithFormat:@"coverPhotoOfUser%@",user[@"facebookID"]]];
                                                                });
                                                                
                                                                //[_semiCircleProfile createProfileWithImage:coverImage];
                                                               //
                                                                
                                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                
                                                                NSLog(@"Error: %@", error);
                                                            }];
                                                            
                                                            [operation start];
                                                        }
                                                    }];
                              
                          }];
    
}

- (void)saveImage: (UIImage*)image withName: (NSString *) name
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          name];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage*)loadImageWithName: (NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithString: name] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (void) handleSwipe:( UISwipeGestureRecognizer *) recognizer {
    NSLog(@"swiped!!");

    int y = semiCircleY;//self.view.bounds.size.height/2+20;
    switch (recognizer.direction)
    {
        case UISwipeGestureRecognizerDirectionRight:
        {
            if (_pageControl.currentPage>0)
            {
                _pageControl.currentPage--;
            }
        }
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (_pageControl.currentPage<2)
            {
                _pageControl.currentPage++; 
            }
        }
            break;
        default:
            break;
    }
    
    [self.animator removeAllBehaviors];
    UISnapBehavior *snap;
    switch (_pageControl.currentPage)
    {
        case 0:
        {
            snap = [[UISnapBehavior alloc] initWithItem:_semiCircleProfile snapToPoint:CGPointMake(25, y)];
            app.stillAnimatingB = YES;
            [_semiCircleProfile show];
            [_bioTagLineTextView setHidden:YES];
            //if (!_isOtherUser)
              //  [_settingsButton setHidden:NO];
        }
            break;
        case 1:
        {
            snap = [[UISnapBehavior alloc] initWithItem:_semiCircleProfile snapToPoint:CGPointMake(self.view.center.x-profilePictureRadius/2, y)];
            [_semiCircleProfile hide];
            [_semiCircleProfile hideJoin];
            [_bioTagLineTextView setHidden:NO];
            [_settingsButton setHidden:YES];

        }
            break;
        case 2:
        {
            snap = [[UISnapBehavior alloc] initWithItem:_semiCircleProfile snapToPoint:CGPointMake(self.view.bounds.size.width-25-profilePictureRadius, y)];
            [_semiCircleProfile showJoin];
            [_bioTagLineTextView setHidden:YES];
        }
            break;
        default:
            break;
    }
    snap.damping = 1;
    
    [self.animator addBehavior:snap];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    NSLog(@"saying light!!!!");
    return UIStatusBarStyleLightContent;
}
- (void) setUpSemiCircleProfile : (NSArray *) circlesToShowS
{
    NSString *pictureURL =[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", user[@"facebookID"]];
    
    pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=250&height=250", user[@"facebookID"]];
    NSLog(@"facebook ID:: %@ for user: %@", user[@"facebookID"], user.username);
    //pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", @"10152594369894796"];
    
    _semiCircleProfile = [[SemiCircleProfile alloc] initWithPoint:CGPointMake(25, semiCircleY)
                                                  radius:220
                                                           inView:self.view withImageURL:pictureURL];
    _semiCircleProfile.delegate = self;
    _semiCircleProfile.bubbleRadius = 35; // Default is 40
    //_semiCircleProfile.imageName = @"Valentin Perez";
    _semiCircleProfile.isForJoining = NO;
    
    //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", user[@"facebookID"]]];

    //[_semiCircleProfile createProfileWithImageURL:pictureURL];
   // [_semiCircleProfile createProfileWithImageString: pictureURL];
   // [_semiCircleProfile.profileImageView setImageWithURL:pictureURL];
    
    
    if ([user[@"Facebook"] length]>0)
        _semiCircleProfile.showFacebookBubble = YES;
    if ([user[@"Twitter"] length]>0)
        _semiCircleProfile.showTwitterBubble = YES;
    if ([user[@"Snapchat"] length]>0)
        _semiCircleProfile.showSnapchatBubble = YES;
    if ([user[@"Instagram"] length]>0)
        _semiCircleProfile.showInstagramBubble = YES;
    if ([user[@"Phone"] length]>0)
        _semiCircleProfile.showPhoneBubble = YES;
    //_semiCircleProfile.showGooglePlusBubble = YES;
    if ([user[@"Email"] length]>0)
        _semiCircleProfile.showMailBubble = YES;
    if ([user[@"Tumblr"] length]>0)
        _semiCircleProfile.showTumblrBubble = YES;
   // _semiCircleProfile.showYoutubeBubble = YES;
    if ([user[@"LinkedIn"] length]>0)
        _semiCircleProfile.showLinkedInBubble = YES;
    if ([user[@"Github"] length]>0)
        _semiCircleProfile.showGithubBubble = YES;
    if ([user[@"tracks8"] length]>0)
        _semiCircleProfile.show8tracksBubble = YES;
    if ([user[@"Spotify"] length]>0)
        _semiCircleProfile.showSpotifyBubble = YES;
    if ([user[@"SoundCloud"] length]>0)
        _semiCircleProfile.showSoundCloudBubble = YES;
    if ([user[@"Pinterest"] length]>0)
        _semiCircleProfile.showPinterestBubble = YES;
    //_semiCircleProfile.showPinterestBubble = YES;
    _semiCircleProfile.showJoinBubble = YES;
    //semiCircleProfile.showVkBubble = YES;
    //semiCircleProfile.showRedditBubble = YES;*/
    
    NSURL *url = [NSURL URLWithString:pictureURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    if ([self loadImageWithName:[NSString stringWithFormat: @"profilePictureForUser%@", user[@"facebookID"]]])
    {
        [_semiCircleProfile createProfileWithImage:[self loadImageWithName:[NSString stringWithFormat: @"profilePictureForUser%@", user[@"facebookID"]]]];
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIImage *image = (UIImage *)responseObject;
        [_semiCircleProfile createProfileWithImage:image];
        if (!_isOtherUser)
        {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self saveImage:image withName:[NSString stringWithFormat: @"profilePictureForUser%@", user[@"facebookID"]]];

        });
        }
        
       // [_backgroundImageView setImageWithURL:url];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
    
    [operation start];
    
}


#pragma mark - SemiCircleProfile Delegate Methods

- (void) tappedUserProfile
{
    NSArray *socialNetworks = [[NSArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Instagram", @"LinkedIn", @"Snapchat", @"Spotify", @"SoundCloud", @"tracks8", @"Github", @"Tumblr", @"Pinterest",@"Email", @"Phone", nil];
    NSString *description;
    
    if (_isOtherUser)
        description = [NSString stringWithFormat:@"Simplifying life: all networks in one. Check out this Join profile as: %@. Simplify your life at: www.joinprofile.com", user.username];
    else
        description = [NSString stringWithFormat:@"I simplify my life: all my networks in one. Find me on Join as: %@. Simplify your life at: www.joinprofile.com", user.username];
    
    for (NSString *network in socialNetworks)
    {
        if ([user[network] length]>0)
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
    //for (user[])
    //if (user[])
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

- (void)semiCircleProfileBubblesDidShow
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"shouldTakePicture"])
    {
    
      
        
        if (_backgroundImageView && _semiCircleProfile.profileImageView)
        {
            UIGraphicsBeginImageContext(self.view.frame.size);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self saveImage:viewImage withName:[NSString stringWithFormat:@"joinImageForUser%@", user.objectId]];
                
            });
            
            NSLog(@"taking picture");
            [defaults setBool:NO forKey:@"shouldTakePicture"];
            [defaults synchronize];

        }
        else
            NSLog(@"isn't ready for join pic");
    }
    app.stillAnimatingB = NO;
}

-(void)semiCircleProfile:(SemiCircleProfile *)SemiCircleProfile tappedBubbleWithType:(BubbleType)bubbleType
{
    NSLog(@"tappedBubble with type: %d", bubbleType);
   // NSString *userName = @"valentin_pd";
    switch (bubbleType) {
        case BubbleTypeJoin:
        {
            NSLog(@"Showing type Join");
            [self showScreenForNetwork:@"Join"];
        }
            break;
        case BubbleTypeFacebook:
        {
            NSLog(@"Facebook");
            //[self showScreenForNetwork:@"Facebook"];
           // [self performSelector:@selector(tappedFacebook)];
            [self showScreenForNetwork:@"Facebook"];
        }
            break;
        case  BubbleTypeInstagram:
        {
            [self showScreenForNetwork:@"Instagram"];

            //[self performSelector:@selector(tappedInstagram)];
        }
            break;
        case BubbleTypeTwitter:
        {
            [self showScreenForNetwork:@"Twitter"];
           // [self performSelector:@selector(tappedTwitter)];
           
        }
            break;
        case BubbleTypeMail:
        {
            [self showEmail];
        }
            break;
        case BubbleType8tracks:
        {
            [self showScreenForNetwork:@"8tracks"];
            
        }
            break;
        case BubbleTypeGithub:
        {
            [self showScreenForNetwork:@"Github"];
        }
            break;
        case BubbleTypeTumblr:
        {
            [self showScreenForNetwork:@"Tumblr"];
        }
            break;
        case BubbleTypePinterest:
        {
            [self showScreenForNetwork:@"Pinterest"];
        }
            break;
        case BubbleTypeSnapchat:
        {
            [self showScreenForNetwork:@"Snapchat"];
        }
        case BubbleTypeSpotify:
        {
            [self showScreenForNetwork:@"Spotify"];
        }
            break;
        case BubbleTypeSoundCloud:
        {
            [self showScreenForNetwork:@"SoundCloud"];
        }
            break;
        case BubbleTypeLinkedIn:
        {
            [self showScreenForNetwork:@"LinkedIn"];
        }
            break;
            
        case BubbleTypePhone:
        {
            NSLog(@"type phone");
            [self showScreenForNetwork:@"Phone"];
        }
            break;
        default:
            break;
    }
}

- (void) tappedFacebook
{
    //[self showWalkthrough];
    NSLog(@"doing facebook stuff");
    //RNGridMenu *menu = [[RNGridMenu alloc] initWithTitles:@[@"Open in Facebook", @"Add as friend", @"Send Facebook message"]];
 
   // NSURL *url = [NSURL URLWithString:@"fb://notifications"];
    //[[UIApplication sharedApplication] openURL:url];
}

- (void) tappedInstagram
{
    NSString *userName = @"valentinperezd";
    NSString *stringURL = [NSString stringWithFormat: @"instagram://user?username=%@", userName];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];

    
}

- (void) tappedEmail
{
    
}

- (void) tappedTwitter
{
    NSString *stringURL = [NSString stringWithFormat: @"twitter://user?screen_name=%@", @"valentin_pd"];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void) showScreenForNetwork : (NSString *) network
{
    DetailNetworkViewController *vc;
    
    if ([network isEqualToString:@"Join"])
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailNetworkForJoinController"];
    else
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailNetworkController"];
    
    NSString *imageString = [NSString stringWithFormat:@"SocialIcon%@.png", network];
    vc.networkName = network;
    vc.user = user;
    vc.delegate = self.detailNetworkVCDelegate;
    vc.networkImageString = imageString;
    vc.isOtherUser = _isOtherUser;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    return;
    
    
}
- (void) showWalkthrough
{
    
}
#pragma mark - Transitioning Delegate Methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PresentDetailTransition alloc] init];
    
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissDetailTransition alloc] init];
    
}
#pragma mark - Email Composing Methods
- (void) showEmail
{
    // Email Subject
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:user[@"Email"]];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBActions

- (IBAction)showSideMenu:(id)sender {
    if (_isOtherUser)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
        [self.sideMenuViewController presentLeftMenuViewController];

    
}

- (IBAction)tappedOnSettings:(id)sender {
    NSLog(@"tappedOnSettings");
    SettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsController"];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];

}
@end
