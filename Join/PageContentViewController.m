//
//  PageContentViewController.m
//  Join
//
//  Created by Valentin Perez on 6/5/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "PageContentViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "RootViewController.h"
#import "JoinViewController.h"

@implementation PageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide ];
}

- (IBAction)dismissTutorial:(id)sender {
    NSLog(@"TRYING TO DISMISS");
    
    [self getStarted];
    /*UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewController *firstScreenController = (ViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"firstController"];
    
    RootViewController *rootController = (RootViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"rootController"];
    
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self presentViewController:firstScreenController animated:YES completion:nil];
    [app.window setRootViewController:rootController];
     */

    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) getStarted
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    JoinViewController *joinViewController = (JoinViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"joinController"];

    [self presentViewController:joinViewController animated:YES completion:nil];

   // RootViewController *rootController = (RootViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"rootController"];
    
    //AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    //app.window.rootViewController = joinViewController;

   // [app.window setRootViewController:rootController];

    
}
@end
