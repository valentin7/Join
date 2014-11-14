//
//  AppDelegate.m
//  Join
//
//  Created by Valentin Perez on 4/13/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "JoinViewController.h"
#import "JazzHandsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    NSLog(@"application launching");
   [Parse setApplicationId:@"YA33DD4sRlD4XmKdYwjq2CyD7q93VKZqn8Cf5sVG"
                  clientKey:@"MVvn4I6QIkLaGLkyXkmbcliy9cV0FpEhbiXcA8xZ"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    // Register for push notifications
    /*[application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];*/
    [application registerForRemoteNotifications];
    
    _userReady = NO;

    /*
     * Set up Facebook and Twitter
     */
    [PFFacebookUtils initializeFacebook];
    
    [PFTwitterUtils initializeWithConsumerKey:@"LXJgKBB2QUnDc8OcS8XH8DPuB"
                               consumerSecret:@"fDsAnDpUT4oSxp6qC8SbZ5QeujRoIZLL83HJ5MyBZVBpf0Gb76"];
    

    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    /*self.window.rootViewController = [JazzHandsViewController new];
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];*/
    //[PFUser currentUser][@"contacts"] = [[NSArray alloc] init];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"])
    {
        NSLog(@"showting walkthroug");
        [self showWalkthrough];
        return YES;
    }
    else
        NSLog(@"has seen tuts");
        //[self showWalkthrough];
    
    if (![PFUser currentUser])
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        JoinViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"joinController"];
        self.window.rootViewController = vc;
        return YES;
    }
    
    NSLog(@"setting user ready from appdelegate");
    _userReady = YES;
    return YES;
}

- (void) showWalkthrough
{
    NSLog(@"going in!!!");
   /* UIView *view = [[UIView alloc] initWithFrame:self.window.frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:view];
    self.window.rootViewController = self.pageViewController;
    */
    self.window.rootViewController = [JazzHandsViewController new];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    /*
     // Create the data model

    _pageTitles = @[@"Simplify your life", @"Share your Join profile: share all your networks", @"Join is the ultimate personal profile", @"Find people — and all their social networks"];
    _pageImages = @[@"page1.png", @"someoneNew.png", @"page3.png", @"page4.png"];
    
   NSDictionary *colors =  @{ @"0": @"#2B2726", @"1": @"#0A516D", @"2": @"#018790", @"3": @"#7DAD93", @"4": @"#BACCA4" };
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    // Create page view controller
    self.pageViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
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
    UIView *view = [[UIView alloc] initWithFrame:self.window.frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:view];
    self.window.rootViewController = self.pageViewController;
     */
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
        //[FBAppCall handleOpenURL:(NSURL *) sourceApplication:<#(NSString *)#> withSession:<#(FBSession *)#> fallbackHandler:<#^(FBAppCall *call)handler#>]
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication withSession:[PFFacebookUtils session]
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle
                                      // the links.
                                      // Use the links to show a relevant
                                      // view of your app to the user
                                  }];
    
    return urlWasHandled;
    
   /* return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];*/
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    NSLog(@"remotenotifications!!!");
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"about to terminatee");
    
    if (!_userReady)
        [PFUser logOut];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Helper Methods

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    /*switch (index)
    {
        case 0:
        {
            UIView *view = [[UIView alloc] initWithFrame:self.window.frame];
            UIImageView *back = [[UIImageView alloc] initWithFrame:self.window.frame];
            back.contentMode=  UIViewContentModeScaleAspectFit;
            back.image = [UIImage imageNamed:@"onePersonBack.png"];
            //[view addSubview:back];
            
            UIView *v = self.window.subviews[self.window.subviews.count-1];
            
            //[v addSubview:back];
            //[self.window addSubview:view];
            
        }
            break;
        case 1:
        {
            UIView *view = [[UIView alloc] initWithFrame:self.window.frame];
            UIImageView *back = [[UIImageView alloc] initWithFrame:self.window.frame];
            back.contentMode=  UIViewContentModeScaleAspectFit;
            back.image = [UIImage imageNamed:@"someoneNew.png"];
            
            UIView *v = self.window.subviews[self.window.subviews.count-1];
            [v addSubview:back];
        }
            break;
        default:
            break;
    }
  
    */
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    [pageContentViewController.getStartedButton setHidden: YES];

    UIButton *getStartedButtonS = [[UIButton alloc] initWithFrame:CGRectMake(pageContentViewController.view.frame.size.width/2, pageContentViewController.view.frame.size.height*5/7, 100, 30)];
    [getStartedButtonS setTitle:@"Get wlht sd" forState:UIControlStateNormal];
    getStartedButtonS.titleLabel.textColor = [UIColor blackColor];
    [getStartedButtonS.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    //[pageContentViewController.view addSubview:getStartedButtonS];
    
    if (index == self.pageTitles.count - 1)
    {
      
        
        
        //[getStartedButton addTarget:self action:@selector(pageCont) forControlEvents:UIControlEventTouchUpInside];
        [pageContentViewController.getStartedButton setHidden: NO];
        //[pageContentViewController.getStartedButton setTitle:@"Get Started" forState:UIControlStateNormal];

        //[pageContentViewController.getStartedButton removeFromSuperview];
    }
    else
    {
        //[pageContentViewController.getStartedButton setTitle:@"" forState:UIControlStateNormal];

       // NSLog(@"hiding!");
        [pageContentViewController.getStartedButton setHidden: YES];
    
    }
   // pageContentViewController.getStartedButton.hidden = !(index == self.pageTitles.count-1);
    
    return pageContentViewController;
}

- (BOOL)hasInternetConnection
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Most of Join's features will not work without an internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
}

- (UIColor *) joinColor
{
    return [UIColor colorWithRed:3.0/255.0f green:35.0/255.0f blue:61.0/255.0f alpha:1];
    
}
@end
