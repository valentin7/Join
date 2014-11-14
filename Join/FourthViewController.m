//
//  FourthViewController.m
//  Join
//
//  Created by Valentin Perez on 8/7/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "FourthViewController.h"
#import "JoinNetworksViewController.h"
#import "OptionCell.h"
#import "JoinViewController.h"
#import "RESideMenu.h"
#import "AppDelegate.h"

@implementation FourthViewController
{
    NSArray *titles;
    
}
- (void) viewDidLoad
{
    titles = @[@"Edit Networks", @"Feedback", @"Suggestions", @"About", @"Log Out"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    /* Make sure our table view resizes correctly */
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // hide empty cells
    [self.tableView setTableFooterView:[UIView new]];
    // _tableView.SEP
}

- (void) showEmail
{
    NSString *emailTitle = @"Join Feedback";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"hello@joinprofile.com"];

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
    if ([titles[indexPath.row] isEqualToString:@"About"])
    {
       // [self performSegueWithIdentifier:@"toFifthSegue" sender:self];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"fifthController"] animated:YES];
    }
    else if ([titles[indexPath.row] isEqualToString:@"Edit Networks"])
    {
        JoinNetworksViewController *joinNetworksVC = [self.storyboard instantiateViewControllerWithIdentifier:@"joinNetworksController"];
        [self presentViewController:joinNetworksVC animated:YES completion:nil];
        
    }
    else if ([titles[indexPath.row] isEqualToString:@"Feedback & Suggestions"])
    {
        [self showEmail];
    }
    else if ([titles[indexPath.row] isEqualToString:@"Log Out"])
    {
        [PFUser logOut];
        JoinViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"joinController"];
        [self presentViewController:vc animated:YES completion:nil];
        
    }
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
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if (app.stillAnimatingB)
        return;
    
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
- (IBAction)showSideMenu:(id)sender
{
    
    [self.sideMenuViewController presentLeftMenuViewController];
    //self.sideMenuViewController presentLeftMenuViewController];
}
@end
