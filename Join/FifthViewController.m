//
//  FifthViewController.m
//  Join
//
//  Created by Valentin Perez on 8/7/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "FifthViewController.h"
#import "OptionCell.h"
#import "WebViewController.h"
#import "JazzHandsViewController.h"

@implementation FifthViewController
{
    NSArray *titles;
    
}
- (void) viewDidLoad
{
    titles = @[@"Intro", @"Terms of Use", @"Privacy Policy"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    
    /* Make sure our table view resizes correctly */
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // hide empty cells
    [self.tableView setTableFooterView:[UIView new]];
}
- (IBAction)tappedBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
# pragma mark TableView Delegate & DataSource Methods
- (NSInteger) numberOfSectionsInTableView:( UITableView *) tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"webController"];
    if ([titles[indexPath.row] isEqualToString:@"Intro"])
    {
       // JazzHandsViewController *jvc = [self.storyboard instantiateViewControllerWithIdentifier:@"jazzHandsController"];
    
        JazzHandsViewController *jhvc = [JazzHandsViewController new];
        jhvc.isLoggedIn = YES;
        jhvc.view.backgroundColor = [UIColor whiteColor];
        //self.window.backgroundColor = [UIColor whiteColor];
        
        //[self.view makeKeyAndVisible];
        [self presentViewController:jhvc animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
       // vc.link = @"http://joinprofile.com";
    }
    else if ([titles[indexPath.row] isEqualToString:@"Terms of Use"])
    {
        vc.link = @"http://joinprofile.com/legal/terms.html";
    }
    else
    {
        vc.link = @"http://joinprofile.com/legal/privacy.html";
    }
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *) tableView:( UITableView *) tableView cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    OptionCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"optionCell" forIndexPath:indexPath];
    cell.titleLabel.text = titles[indexPath.row];
    [cell.titleLabel setTextColor: [UIColor whiteColor]];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}
@end
