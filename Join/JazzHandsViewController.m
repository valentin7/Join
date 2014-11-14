//
//  JazzHandsViewController.m
//  Join
//
//  Created by Valentin Perez on 8/13/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import "JazzHandsViewController.h"
#import "JoinViewController.h"

#define NUMBER_OF_PAGES 8

#define screenWidth (NSInteger) (self.view.frame.size.width)
#define timeForPage(page) (NSInteger) (screenWidth * (page -1))

#define storyPersonHeight 220

@interface JazzHandsViewController ()

@property (strong, nonatomic) UIImageView *wordmark;

@property (strong, nonatomic) UIImageView *firstPerson;
@property (strong, nonatomic) UIImageView *secondPerson;

@property (strong, nonatomic) UIImageView *facebook;
@property (strong, nonatomic) UIImageView *twitter;
@property (strong, nonatomic) UIImageView *instagram;
@property (strong, nonatomic) UIImageView *allNetworks;
@property (strong, nonatomic) UIImageView *join;


@property (strong, nonatomic) UIButton *getStartedButton;
@property (strong, nonatomic) UILabel *firstLabel;

@end



@implementation JazzHandsViewController

- (id)init
{
    if ((self = [super init])) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide ];
    
    self.scrollView.contentSize = CGSizeMake(NUMBER_OF_PAGES * CGRectGetWidth(self.view.frame),
                                             CGRectGetHeight(self.view.frame));
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self placeViews];
    [self configureAnimation];
    
    self.delegate = self;
}
- (void)placeViews
{
    // put a firstPerson in the middle of page one
    self.firstPerson = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personDark.png"]];
    self.firstPerson.center = self.view.center;
    [self.firstPerson setContentMode:UIViewContentModeScaleAspectFit];
    self.firstPerson.frame = CGRectMake(0, 0, self.firstPerson.frame.size.width*1/4, self.firstPerson.frame.size.height*1/4);
    self.firstPerson.frame = CGRectOffset(self.firstPerson.frame,25,storyPersonHeight);
    self.firstPerson.alpha = 0.0f;
    [self.scrollView addSubview:self.firstPerson];
    
    
    // put a secondPerson in the middle of page two, hidden
    self.secondPerson = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personDark.png"]];
    self.secondPerson.center = self.view.center;
    [self.secondPerson setContentMode:UIViewContentModeScaleAspectFit];
    self.secondPerson.frame = CGRectMake(0, 0, self.secondPerson.frame.size.width*1/4, self.secondPerson.frame.size.height*1/4);
    self.secondPerson.frame = CGRectOffset(self.secondPerson.frame,timeForPage(3)-50-self.secondPerson.frame.size.width/2,storyPersonHeight);
    self.secondPerson.alpha = 1.0f;
    [self.scrollView addSubview:self.secondPerson];
    
    
    // put a Facebook bubble in page two, hidden
    self.facebook = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SocialIconFacebook.png"]];
    self.facebook.center = self.view.center;
    [self.facebook setContentMode:UIViewContentModeScaleAspectFit];
    self.facebook.frame = CGRectMake(0, 0, 50, 50);
    self.facebook.frame = CGRectOffset(self.facebook.frame,timeForPage(2)+25+self.facebook.frame.size.width/2,storyPersonHeight);
    self.facebook.alpha = 0.0f;
    [self.scrollView addSubview:self.facebook];
    
    // put a Twitter bubble in page three, hidden
    self.twitter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SocialIconTwitter.png"]];
    self.twitter.center = self.view.center;
    [self.twitter setContentMode:UIViewContentModeScaleAspectFit];
    self.twitter.frame = CGRectMake(0, 0, 50, 50);
    self.twitter.frame = CGRectOffset(self.twitter.frame,timeForPage(3)+25+self.twitter.frame.size.width/2,storyPersonHeight);
    self.twitter.alpha = 0.0f;
    [self.scrollView addSubview:self.twitter];
    
    // put an Instagram bubble in page four, hidden
    self.instagram = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SocialIconInstagram.png"]];
    self.instagram.center = self.view.center;
    [self.instagram setContentMode:UIViewContentModeScaleAspectFit];
    self.instagram.frame = CGRectMake(0, 0, 50, 50);
    self.instagram.frame = CGRectOffset(self.instagram.frame,timeForPage(4)+25+self.instagram.frame.size.width/2,storyPersonHeight);
    self.instagram.alpha = 0.0f;
    [self.scrollView addSubview:self.instagram];
    
    // put allNetwork bubbles in page five, hidden
    self.allNetworks = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"allNetworks.png"]];
    self.allNetworks.center = self.view.center;
    [self.allNetworks setContentMode:UIViewContentModeScaleAspectFit];
    self.allNetworks.frame = CGRectMake(0, 0, _allNetworks.frame.size.width*2/6, self.allNetworks.frame.size.height*2/6);
    self.allNetworks.frame = CGRectOffset(self.allNetworks.frame,timeForPage(6)+130-self.allNetworks.frame.size.width/2,90);
    self.allNetworks.alpha = 0.0f;
    [self.scrollView addSubview:self.allNetworks];
    
    // put Join's bubble in page six, hidden
    self.join = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SocialIconJoin.png"]];
    self.join.center = self.view.center;
    [self.join setContentMode:UIViewContentModeScaleAspectFit];
    self.join.frame = CGRectMake(0, 0, 50, 50);
    self.join.frame = CGRectOffset(self.join.frame,timeForPage(6)+80,storyPersonHeight);
    self.join.alpha = 0.0f;
    [self.scrollView addSubview:self.join];
    
    // put Join's logo on first page
    self.wordmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JoinLogoBlue.png"]];
    self.wordmark.frame = CGRectMake(0, 0, self.wordmark.frame.size.width*2/6, self.wordmark.frame.size.height*2/6);
    self.wordmark.center = self.view.center;
    self.wordmark.frame = CGRectOffset(
                                       self.wordmark.frame,
                                       0,
                                       -200
                                       );
    [self.scrollView addSubview:self.wordmark];
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.text = @"Simplify your life  →";
    self.firstLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self.firstLabel sizeToFit];
    self.firstLabel.textColor = [self joinColor];
    self.firstLabel.center = self.view.center;
    self.firstLabel.frame = CGRectOffset(self.firstLabel.frame,0,-50);

    [self.scrollView addSubview:self.firstLabel];
    
    UILabel *secondPageText = [[UILabel alloc] init];
    secondPageText.text = @"Let's say you meet someone.";
    [secondPageText sizeToFit];
    secondPageText.center = self.view.center;
    secondPageText.textColor = [self joinColor];
    secondPageText.frame = CGRectOffset(secondPageText.frame, timeForPage(2), -200);
    secondPageText.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self.scrollView addSubview:secondPageText];
    
    UILabel *thirdPageText = [[UILabel alloc] init];
    thirdPageText.text = @"To keep in touch, you share...";
    [thirdPageText sizeToFit];
    thirdPageText.center = self.view.center;
    thirdPageText.textColor = [self joinColor];
    thirdPageText.frame = CGRectOffset(thirdPageText.frame, timeForPage(3), -200);
    thirdPageText.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self.scrollView addSubview:thirdPageText];
    
    UILabel *fourthPageText = [[UILabel alloc] init];
    fourthPageText.text = @"some";
    [fourthPageText sizeToFit];
    fourthPageText.center = self.view.center;
    fourthPageText.textColor = [self joinColor];
    fourthPageText.frame = CGRectOffset(fourthPageText.frame, timeForPage(4), -150);
    fourthPageText.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self.scrollView addSubview:fourthPageText];

    
    
    UILabel *fifthPageText = [[UILabel alloc] init];
    fifthPageText.text = @"of";
    [fifthPageText sizeToFit];
    fifthPageText.center = self.view.center;
    fifthPageText.textColor = [self joinColor];
    fifthPageText.frame = CGRectOffset(fifthPageText.frame, timeForPage(5), -150);
    fifthPageText.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self.scrollView addSubview:fifthPageText];

    
    UILabel *sixthPageText = [[UILabel alloc] init];
    sixthPageText.text = @"your networks.";
    [sixthPageText sizeToFit];
    sixthPageText.center = self.view.center;
    sixthPageText.textColor = [self joinColor];
    sixthPageText.frame = CGRectOffset(sixthPageText.frame, timeForPage(6), -200);
    sixthPageText.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self.scrollView addSubview:sixthPageText];
    
    UILabel *sixthPageText2 = [[UILabel alloc] init];
    sixthPageText2.text = @"But you probably have many...";
    [sixthPageText2 sizeToFit];
    sixthPageText2.center = self.view.center;
    sixthPageText2.textColor = [self joinColor];
    sixthPageText2.frame = CGRectOffset(sixthPageText2.frame, timeForPage(6), 200);
    sixthPageText2.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
    [self.scrollView addSubview:sixthPageText2];

    UILabel *seventhPageText = [[UILabel alloc] init];
    seventhPageText.numberOfLines = 2;
    seventhPageText.text = @"So just share your Join profile.";
    [seventhPageText sizeToFit];
    seventhPageText.center = self.view.center;
    seventhPageText.textColor = [self joinColor];
    seventhPageText.frame = CGRectOffset(seventhPageText.frame, timeForPage(7), -200);
    seventhPageText.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self.scrollView addSubview:seventhPageText];
    
    UILabel *seventhPageText2 = [[UILabel alloc] init];
    seventhPageText2.numberOfLines = 2;
    seventhPageText2.text = @"Join all your networks with Join.";
    [seventhPageText2 sizeToFit];
    seventhPageText2.center = self.view.center;
    seventhPageText2.textColor = [self joinColor];
    seventhPageText2.frame = CGRectOffset(seventhPageText2.frame, timeForPage(7), 200);
    seventhPageText2.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    [self.scrollView addSubview:seventhPageText2];
    
    /*UILabel *seventhPageText3 = [[UILabel alloc] init];
    seventhPageText3.numberOfLines = 2;
    seventhPageText3.text = @"for a unified personal profile with Join.";
    [seventhPageText3 sizeToFit];
    seventhPageText3.center = self.view.center;
    seventhPageText3.textColor = [self joinColor];
    seventhPageText3.frame = CGRectOffset(seventhPageText3.frame, timeForPage(7), 220);
    seventhPageText3.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    [self.scrollView addSubview:seventhPageText3];
    */
   /*
    //UIButton *getStarted = [[UIButton alloc] init];
    UILabel *getStarted = [[UILabel alloc] init];
    //[getStarted setTitle:@"Get Started" forState:UIControlStateNormal];
    getStarted.text = @"Get Started";
    [getStarted sizeToFit];
    getStarted.center = self.view.center;
    getStarted.frame = CGRectOffset(getStarted.frame, timeForPage(8), -200);
    //getStarted.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    [self.scrollView addSubview:getStarted];
*/
    
    //UIButton *getStarted = [UIButton buttonWithType:UIButtonTypeCustom];
     UIButton *getStarted = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 70)];
    
    if (!_isLoggedIn)
        [getStarted setTitle:@"Get Started" forState:UIControlStateNormal];
    
    else
        [getStarted setTitle:@"Dismiss" forState:UIControlStateNormal];

    //getStarted.imageView.image = [UIImage imageNamed:@"SocialIconFacebook.png"];
    //getStarted.text = @"Get Started";
    //[getStarted sizeToFit];
    getStarted.center = self.view.center;
    getStarted.frame = CGRectOffset(getStarted.frame, timeForPage(8), 180);
    getStarted.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22];
    getStarted.titleLabel.textColor = [UIColor whiteColor];
    getStarted.backgroundColor = [self joinLightColor];
    [getStarted addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:getStarted];
    
    
    //[self.scrollView addSubview:getStarted];
    [self.view insertSubview:self.dismissButton aboveSubview:self.scrollView];

    //self.getStartedButton = getStarted;
}

- (void)configureAnimation
{
    CGFloat dy = 240;
    
    NSLog(@"animation!!!!");
    // apply a 3D zoom animation to the first label
    IFTTTTransform3DAnimation * labelTransform = [IFTTTTransform3DAnimation animationWithView:self.firstLabel];
    IFTTTTransform3D *tt1 = [IFTTTTransform3D transformWithM34:0.03f];
    IFTTTTransform3D *tt2 = [IFTTTTransform3D transformWithM34:0.3f];
    tt2.rotate = (IFTTTTransform3DRotate){ -(CGFloat)(M_PI), 1, 0, 0 };
    tt2.translate = (IFTTTTransform3DTranslate){ 0, 0, 50 };
    tt2.scale = (IFTTTTransform3DScale){ 1.f, 2.f, 1.f };
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0)
                                                                andAlpha:1.0f]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1)
                                                          andTransform3D:tt1]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.5)
                                                          andTransform3D:tt2]];
    [labelTransform addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.5) + 1
                                                                andAlpha:0.0f]];
   // [self.animator addAnimation:labelTransform];
    
    
    // let's animate the first label
    IFTTTFrameAnimation *labelFrameAnimation = [IFTTTFrameAnimation animationWithView:self.firstLabel];
    [self.animator addAnimation:labelFrameAnimation];
    
    [labelFrameAnimation addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:CGRectOffset(self.firstLabel.frame, 0, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(self.firstLabel.frame, screenWidth*2, 0)]
                                           /*[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.wordmark.frame, screenWidth, dy)],
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.wordmark.frame, 0, dy)],*/
                                           ]];
    
    // Fade out the label by dragging on the second page
    IFTTTAlphaAnimation *firstLabelAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.firstLabel];
    [firstLabelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:1.0f]];
    [firstLabelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.7f) andAlpha:0.0f]];
    [self.animator addAnimation:firstLabelAlphaAnimation];

    
    // let's animate the wordmark
    IFTTTFrameAnimation *wordmarkFrameAnimation = [IFTTTFrameAnimation animationWithView:self.wordmark];
    [self.animator addAnimation:wordmarkFrameAnimation];
    
    [wordmarkFrameAnimation addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0) andFrame:CGRectOffset(self.wordmark.frame, 0, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:self.wordmark.frame]
                                           ,
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(8) andFrame:CGRectOffset(self.wordmark.frame, timeForPage(8), 0)]
                                           /*[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.wordmark.frame, screenWidth, dy)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.wordmark.frame, 0, dy)],*/
                                           ]];
    
    // Fade out the label by dragging on the second page
    IFTTTAlphaAnimation *wordMarkAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.wordmark];
    [wordMarkAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:1.0f]];
    [wordMarkAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.7f) andAlpha:0.0f]];
    [wordMarkAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(7.9f) andAlpha:0.0f]];
    [wordMarkAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(8.0f) andAlpha:1.0f]];

    [self.animator addAnimation:wordMarkAlphaAnimation];


    // Rotate 2 full circles from pages 0 to 1 to 2
    IFTTTAngleAnimation *wordmarkRotationAnimation = [IFTTTAngleAnimation animationWithView:self.wordmark];
    [self.animator addAnimation:wordmarkRotationAnimation];
    [wordmarkRotationAnimation addKeyFrames:@[
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAngle:0.0f],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAngle:(CGFloat)(2 * M_PI)],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0) andAngle:(CGFloat)(-2 * M_PI)],
                                              ]];
    
    // now, we animate the firstPerson
    IFTTTFrameAnimation *firstPersonFrameAnimation = [IFTTTFrameAnimation animationWithView:self.firstPerson];
    [self.animator addAnimation:firstPersonFrameAnimation];
    
    [firstPersonFrameAnimation addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0) andFrame:CGRectOffset(self.firstPerson.frame, 0, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:self.firstPerson.frame],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(self.firstPerson.frame, screenWidth, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.firstPerson.frame, screenWidth*2, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.firstPerson.frame, screenWidth*3, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5) andFrame:CGRectOffset(self.firstPerson.frame, screenWidth*4, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(6) andFrame:CGRectOffset(self.firstPerson.frame, screenWidth*5, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(7) andFrame:CGRectOffset(self.firstPerson.frame, screenWidth*6, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(8) andFrame:CGRectOffset(self.firstPerson.frame, screenWidth*7, 0)],
                                           ]];
    
    // now, we animate the firstPerson
    IFTTTFrameAnimation *secondPersonFrameAnimation = [IFTTTFrameAnimation animationWithView:self.secondPerson];
    [self.animator addAnimation:secondPersonFrameAnimation];
    
    [secondPersonFrameAnimation addKeyFrames:@[
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0) andFrame:CGRectOffset(self.secondPerson.frame, 0, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andFrame:self.secondPerson.frame],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(self.secondPerson.frame, 0, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.secondPerson.frame, screenWidth, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.secondPerson.frame, screenWidth*2, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5) andFrame:CGRectOffset(self.secondPerson.frame, screenWidth*3, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(6) andFrame:CGRectOffset(self.secondPerson.frame, screenWidth*4, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(8) andFrame:CGRectOffset(self.secondPerson.frame, screenWidth*6, 0)]
                                              ]];
    
    
    // Animate Facebook bubble
    IFTTTAlphaAnimation *facebookAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.facebook];
    [facebookAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:0.0f]];
    [facebookAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2.1f) andAlpha:1.0f]];
    [facebookAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3.5f) andAlpha:1.0f]];
    [facebookAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3.75f) andAlpha:0.0f]];


    [self.animator addAnimation:facebookAlphaAnimation];

    
    IFTTTFrameAnimation *facebookFrameAnimation = [IFTTTFrameAnimation animationWithView:self.facebook];
    [self.animator addAnimation:facebookFrameAnimation];
    
    [facebookFrameAnimation addKeyFrames:@[
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andFrame:CGRectOffset(self.facebook.frame, 0, 0)],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:
                                                CGRectOffset(self.facebook.frame, screenWidth*3/2 -self.facebook.frame.size.width -25 , 0)],
                                               [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.facebook.frame, screenWidth*3-75, 0)]
                                               ]];
    
    // Animate Twitter bubble
    IFTTTAlphaAnimation *twitterAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.twitter];
    [twitterAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:0.0f]];
    [twitterAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3.1f) andAlpha:1.0f]];
    [twitterAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.5f) andAlpha:1.0f]];
    [twitterAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.75f) andAlpha:0.0f]];
    
    [self.animator addAnimation:twitterAlphaAnimation];
    
    
    IFTTTFrameAnimation *twitterFrameAnimation = [IFTTTFrameAnimation animationWithView:self.twitter];
    [self.animator addAnimation:twitterFrameAnimation];
    
    [twitterFrameAnimation addKeyFrames:@[
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andFrame:CGRectOffset(self.twitter.frame, 0, 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:
                                            CGRectOffset(self.twitter.frame, screenWidth*3/2 -self.twitter.frame.size.width -25 , 0)],
                                           [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5) andFrame:CGRectOffset(self.twitter.frame, screenWidth*3-75, 0)]
                                           ]];
    
    // Animate Instagram bubble
    IFTTTAlphaAnimation *instagramAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.instagram];
    [instagramAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:0.0f]];
    [instagramAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.1f) andAlpha:1.0f]];
    [instagramAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5.5f) andAlpha:1.0f]];
    [instagramAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5.75f) andAlpha:0.0f]];
    
    [self.animator addAnimation:instagramAlphaAnimation];
    
    
    IFTTTFrameAnimation *instagramFrameAnimation = [IFTTTFrameAnimation animationWithView:self.instagram];
    [self.animator addAnimation:instagramFrameAnimation];
    
    [instagramFrameAnimation addKeyFrames:@[
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andFrame:CGRectOffset(self.instagram.frame, 0, 0)],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5) andFrame:
                                           CGRectOffset(self.instagram.frame, screenWidth*3/2 -self.instagram.frame.size.width -25 , 0)],
                                          [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(6) andFrame:CGRectOffset(self.instagram.frame, screenWidth*3-75, 0)]
                                          ]];
    
    
    // Animate All network bubbles
    IFTTTAlphaAnimation *allNetworksAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.allNetworks];
    [allNetworksAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5.7f) andAlpha:0.0f]];
    [allNetworksAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(6.0f) andAlpha:1.0f]];
    [self.animator addAnimation:allNetworksAlphaAnimation];

    
    IFTTTFrameAnimation *allNetworksFrameAnimation = [IFTTTFrameAnimation animationWithView:self.allNetworks];
    [self.animator addAnimation:allNetworksFrameAnimation];
    
    [allNetworksFrameAnimation addKeyFrames:@[
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(6) andFrame:CGRectOffset(self.allNetworks.frame, 0, 0)],
                                            [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(7) andFrame:
                                             CGRectOffset(CGRectMake(timeForPage(6)+80+_join.frame.size.width/2, storyPersonHeight+_join.frame.size.height/2, 0, 0), screenWidth, 0)]]];
    
    
    // Animate Join bubble
    IFTTTAlphaAnimation *joinAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.join];
    [joinAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(6.9f) andAlpha:0.0f]];
    [joinAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(7.0f) andAlpha:1.0f]];
    [joinAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(8.5f) andAlpha:1.0f]];
    [joinAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(8.75f) andAlpha:0.0f]];

    [self.animator addAnimation:joinAlphaAnimation];

    IFTTTFrameAnimation *joinFrameAnimation = [IFTTTFrameAnimation animationWithView:self.join];
    [self.animator addAnimation:joinFrameAnimation];
    
    [joinFrameAnimation addKeyFrames:@[
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(6) andFrame:CGRectOffset(self.join.frame, 0, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(7) andFrame:
                                               CGRectOffset(self.join.frame, screenWidth, 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(8) andFrame:
                                               CGRectOffset(self.join.frame, screenWidth*5/2 -self.join.frame.size.width -55 , 0)],
                                              [IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(8) andFrame:
                                               CGRectOffset(self.join.frame, screenWidth*4 - 75 , 0)]
                                              ]];
    
    
    CGFloat ds = 50;
    
    // move down and to the right, and shrink between pages 0 and 1
    /*[firstPersonFrameAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(0) andFrame:self.firstPerson.frame]];
    [firstPersonFrameAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1)
                                                                       andFrame:CGRectOffset(CGRectInset(self.firstPerson.frame, ds, ds), timeForPage(1), dy)]];*/
    
    IFTTTAlphaAnimation *secondPersonAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.secondPerson];
    [self.animator addAnimation:secondPersonAlphaAnimation];
    
    [secondPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5) andAlpha:1.0f]];
    [secondPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(5.8) andAlpha:0.0f]];
    [secondPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(7.2) andAlpha:0.0f]];
    [secondPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(7.3) andAlpha:1.0f]];

    
    
    // fade the firstPerson in on page 2 and out on page 4
    IFTTTAlphaAnimation *firstPersonAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.firstPerson];
    [self.animator addAnimation:firstPersonAlphaAnimation];
    
    [firstPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1) andAlpha:0.0f]];
    [firstPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(1.1) andAlpha:1.0f]];
    [firstPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(2) andAlpha:1.0f]];
    [firstPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(3) andAlpha:1.0f]];
    [firstPersonAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:1.0f]];
    
   
    
    // Fade out the label by dragging on the last page
    IFTTTAlphaAnimation *labelAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.getStartedButton];
    [labelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4) andAlpha:1.0f]];
    [labelAlphaAnimation addKeyFrame:[IFTTTAnimationKeyFrame keyFrameWithTime:timeForPage(4.35f) andAlpha:0.0f]];
    [self.animator addAnimation:labelAlphaAnimation];
}

- (UIColor *) joinColor
{
    return [UIColor colorWithRed:3.0/255.0f green:35.0/255.0f blue:61.0/255.0f alpha:1];
    
}
- (UIColor *) joinLightColor
{
    return [UIColor colorWithRed:41.0/255.0f green:107.0/255.0f blue:121.0/255.0f alpha:1];
    
}

#pragma mark - IFTTTAnimatedScrollViewControllerDelegate

- (void)animatedScrollViewControllerDidScrollToEnd:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
{
    NSLog(@"Scrolled to end of scrollview!");
}

- (void)animatedScrollViewControllerDidEndDraggingAtEnd:(IFTTTAnimatedScrollViewController *)animatedScrollViewController
{
    NSLog(@"Ended dragging at end of scrollview!");
}


- (IBAction)dismiss:(id)sender
{
    if (!_isLoggedIn)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        JoinViewController *joinViewController = (JoinViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"joinController"];
        
        [self presentViewController:joinViewController animated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
