//
//  AdjustSearchViewController.h
//  Join
//
//  Created by Valentin Perez on 8/2/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AdjustSearchViewControllerDelegate;

@interface AdjustSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<AdjustSearchViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tappedClose:(id)sender;

@end

@protocol AdjustSearchViewControllerDelegate<NSObject>

@optional

- (void) selectedGroupToSearch: (NSString *) title;

@end