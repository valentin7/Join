//
//  AppDelegate.h
//  Join
//
//  Created by Valentin Perez on 4/13/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
#import <Parse/Parse.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (readwrite, nonatomic) BOOL userReady;
@property (readwrite, nonatomic) BOOL stillAnimatingB;

@property (readwrite, nonatomic) NSString *groupToSearch;
@property (readwrite, nonatomic) NSArray *groupTotalUsers;

- (BOOL)hasInternetConnection;
- (void) showWalkthrough;

- (UIColor *) joinColor;

@end
