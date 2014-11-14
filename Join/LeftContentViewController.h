//
//  LeftContentViewController.h
//  Join
//
//  Created by Valentin Perez on 6/4/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RESideMenu.h"

@interface LeftContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>

@property (strong, readwrite, nonatomic) UITableView *tableView;


@end