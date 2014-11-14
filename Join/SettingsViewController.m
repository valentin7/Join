//
//  SettingsViewController.m
//  Join
//
//  Created by Valentin Perez on 7/30/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "SettingsViewController.h"
#import "JoinNetworksViewController.h"
#import "JoinViewController.h"

@implementation SettingsViewController

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.80];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScreen)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) tappedOnScreen
{
    // [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedEditNetworks:(id)sender {
    
    JoinNetworksViewController *joinNetworksVC = [self.storyboard instantiateViewControllerWithIdentifier:@"joinNetworksController"];
    [self presentViewController:joinNetworksVC animated:YES completion:nil];

}

- (IBAction)tappedLogOut:(id)sender
{
    [PFUser logOut];
    JoinViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"joinController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end
