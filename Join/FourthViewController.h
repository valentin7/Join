//
//  FourthViewController.h
//  Join
//
//  Created by Valentin Perez on 8/7/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FourthViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)showSideMenu:(id)sender;

@end
