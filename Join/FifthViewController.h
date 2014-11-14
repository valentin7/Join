//
//  FifthViewController.h
//  Join
//
//  Created by Valentin Perez on 8/7/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FifthViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)tappedBack:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
