//
//  RootViewController.h
//  Join
//
//  Created by Valentin Perez on 6/3/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "RESideMenu.h"
#import "PageContentViewController.h"

@interface RootViewController : RESideMenu <UIPageViewControllerDataSource>

- (IBAction)startWalkthrough:(id)sender;
    
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
