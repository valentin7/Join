//
//  SemiCircleProfile.m
//  Join
//
//  Created by Valentin Perez on 4/21/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//
// Inspired by:
//
//  AAShareBubbles.m
//  AAShareBubbles
//
//  Created by Almas Adilbek on 26/11/13.
//  Copyright (c) 2013 Almas Adilbek. All rights reserved.
//  https://github.com/mixdesign/AAShareBubbles
//

#import "SemiCircleProfile.h"
#import "UIKit+AFNetworking.h"


@implementation SemiCircleProfile
{
    NSMutableArray *bubbles;
    NSMutableArray *joinBubble;
    NSMutableDictionary *bubbleIndexTypes;
    NSMutableDictionary *joinBubbleIndexTypes;

    CGPoint centerPoint;
    int position;
    UIView *bgView;
    int profileRadius;
}
@synthesize delegate = _delegate, parentView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithPoint:(CGPoint)point radius:(int)radiusValue inView:(UIView *)inView withImageURL: (NSString *) imageURL
{
self = [super initWithFrame:CGRectMake(point.x - radiusValue, point.y - radiusValue, 2 * radiusValue, 2 * radiusValue)];
if (self) {
    self.radius = radiusValue;
    self.bubbleRadius = 40;
    self.parentView = inView;
    
    self.profileImageURL = imageURL;
    
    centerPoint = point;
    
    position = 0; // 0 is left; 1 is middle; 2 is right;
    
    self.facebookBackgroundColorRGB = 0x3c5a9a;
    self.twitterBackgroundColorRGB = 0x3083be;
    self.mailBackgroundColorRGB = 0xbb54b5;
    self.googlePlusBackgroundColorRGB = 0xd95433;
    self.tumblrBackgroundColorRGB = 0x385877;
    self.vkBackgroundColorRGB = 0x4a74a5;
    self.linkedInBackgroundColorRGB = 0x008dd2;
    self.pinterestBackgroundColorRGB = 0xb61d23;
    self.youtubeBackgroundColorRGB = 0xce3025;
    self.vimeoBackgroundColorRGB = 0x00acf2;
    self.redditBackgroundColorRGB = 0xffffff;
    
    if (imageURL)
    {
        NSLog(@"trying with URL");
        //[self createProfileWithImageString:imageURL];
    }
    //[self createProfileWithImage:[UIImage imageNamed:@"Valentin Perez"]];
    //_profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, profileRadius*2, profileRadius*2)];

}
return self;
}

#pragma mark -
#pragma mark Actions

-(void)buttonWasTapped:(UIButton *)button {
    NSLog(@"tapped button circle");
    BubbleType buttonType = [[bubbleIndexTypes objectForKey:[NSNumber numberWithInteger:button.tag]] intValue];
    [self shareButtonTappedWithType:buttonType];
}

- (void)shareButtonTappedWithType:(BubbleType)buttonType {
   
    if (_isForJoining)
        [self hide];
    
    if([self.delegate respondsToSelector:@selector(semiCircleProfile:tappedBubbleWithType:)]) {
        [self.delegate semiCircleProfile:self tappedBubbleWithType:buttonType];
    }
}

- (void) tappedProfile
{
    if ([self.delegate respondsToSelector:@selector(tappedUserProfile)])
    {
        [self.delegate tappedUserProfile];
    }
    
}

#pragma mark -
#pragma mark Methods
- (void) showJoin
{
    NSLog(@"showing Join bubble");
    if (_showingJoin)
        return;
    
    _showingJoin = YES;
    
    self.isAnimating = YES;
    
    [self.parentView addSubview:self];
    // Create background
    CGRect bgRect = CGRectMake(0, 68, self.parentView.bounds.size.width, self.parentView.bounds.size.height);
    //bgView = [[UIView alloc] initWithFrame:self.parentView.bounds];
    bgView = [[UIView alloc] initWithFrame:bgRect];
    
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewBackgroundTapped:)];
    [bgView addGestureRecognizer:tapges];
  
    if(joinBubble) {
        joinBubble = nil;
    }
    
    joinBubble = [[NSMutableArray alloc] init];
    joinBubbleIndexTypes = [[NSMutableDictionary alloc] init];
    
    if(self.showJoinBubble)        [self createButtonWithIcon:@"SocialIconJoin.png" backgroundColor:self.facebookBackgroundColorRGB andType:BubbleTypeJoin];

    if(joinBubble.count == 0) return;

    float bubbleDistanceFromPivot = self.radius - self.bubbleRadius;
    
    int angleTotal = 0;
    float bubblesBetweenAngel = angleTotal / joinBubble.count;
    float angely = (angleTotal - bubblesBetweenAngel) * 0.5;
    float startAngel = angleTotal - angely;
    
    NSMutableArray *coordinates = [NSMutableArray array];
    
    for (int i = 0; i < joinBubble.count; i++)
    {
        UIButton *bubble = [joinBubble objectAtIndex:i];
        
        // make join's bubble tag more than what the normal bubbles' tag can be
        bubble.tag = 707;//bubbles.count+i;
        
        float angle = startAngel + i * bubblesBetweenAngel;
        float x =  - cos(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius*5/4;
        float y = .9*sin(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
        //float x = self.radius;
        
        [coordinates addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", [NSNumber numberWithFloat:y], @"y", nil]];
        
        bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
        bubble.center = CGPointMake(self.radius, self.radius);
    }
    
    int inetratorI = 0;
    for (NSDictionary *coordinate in coordinates)
    {
        UIButton *bubble = [joinBubble objectAtIndex:inetratorI];
        float delayTime = inetratorI * 0.1;
        [self performSelector:@selector(showBubbleWithAnimation:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:bubble, @"button", coordinate, @"coordinate", nil] afterDelay:delayTime];
        inetratorI++;
    }
    
}
- (void)show
{
    if (_showingBubbles)
        return;
    
    _showingBubbles = YES;
    
    //if(!self.isAnimating)
    //{
        self.isAnimating = YES;
        
        [self.parentView addSubview:self];
        
        // Create background
        CGRect bgRect = CGRectMake(0, 68, self.parentView.bounds.size.width, self.parentView.bounds.size.height);
        //bgView = [[UIView alloc] initWithFrame:self.parentView.bounds];
        bgView = [[UIView alloc] initWithFrame:bgRect];

        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewBackgroundTapped:)];
        [bgView addGestureRecognizer:tapges];
        //[bgView setBackgroundColor:[UIColor blackColor]];
        //bgView.alpha = .4;
       // [parentView insertSubview:bgView belowSubview:self];
        // --
        
        if(bubbles) {
            bubbles = nil;
        }
        
        bubbles = [[NSMutableArray alloc] init];
        bubbleIndexTypes = [[NSMutableDictionary alloc] init];

    
    if(self.showPhoneBubble)         [self createButtonWithIcon:@"SocialIconPhone.png" backgroundColor:self.mailBackgroundColorRGB andType:BubbleTypePhone];
    if(self.showMailBubble)         [self createButtonWithIcon:@"SocialIconEmail.png" backgroundColor:self.mailBackgroundColorRGB andType:BubbleTypeMail];
    

        if(self.showGooglePlusBubble)   [self createButtonWithIcon:@"icon-aa-googleplus.png" backgroundColor:self.googlePlusBackgroundColorRGB andType:BubbleTypeGooglePlus];
        if(self.showTumblrBubble)       [self createButtonWithIcon:@"SocialIconTumblr.png" backgroundColor:self.tumblrBackgroundColorRGB andType:BubbleTypeTumblr];
    
        if(self.showSpotifyBubble)   [self createButtonWithIcon:@"SocialIconSpotify.png" backgroundColor:self.googlePlusBackgroundColorRGB andType:BubbleTypeSpotify];
        if(self.show8tracksBubble)       [self createButtonWithIcon:@"SocialIcon8tracks.png" backgroundColor:self.tumblrBackgroundColorRGB andType:BubbleType8tracks];
        if(self.showSoundCloudBubble)   [self createButtonWithIcon:@"SocialIconSoundCloud.png" backgroundColor:self.googlePlusBackgroundColorRGB andType:BubbleTypeSoundCloud];
        if(self.showGithubBubble)         [self createButtonWithIcon:@"SocialIconGithub.png" backgroundColor:self.mailBackgroundColorRGB andType:BubbleTypeGithub];
    
    
        
        if(self.showVkBubble)           [self createButtonWithIcon:@"icon-aa-vk.png" backgroundColor:self.vkBackgroundColorRGB andType:BubbleTypeVk];
    
        if(self.showPinterestBubble)    [self createButtonWithIcon:@"SocialIconPinterest.png" backgroundColor:self.pinterestBackgroundColorRGB andType:BubbleTypePinterest];
        if(self.showYoutubeBubble)      [self createButtonWithIcon:@"icon-aa-youtube.png" backgroundColor:self.youtubeBackgroundColorRGB andType:BubbleTypeYoutube];
        //if(self.showVimeoBubble)        [self createButtonWithIcon:@"icon-aa-vimeo.png" backgroundColor:self.vimeoBackgroundColorRGB andType:BubbleTypeVimeo];
        if(self.showRedditBubble)        [self createButtonWithIcon:@"icon-aa-reddit.png" backgroundColor:self.redditBackgroundColorRGB andType:BubbleTypeReddit];
        
    if(self.showLinkedInBubble)     [self createButtonWithIcon:@"SocialIconLinkedIn.png" backgroundColor:self.linkedInBackgroundColorRGB andType:BubbleTypeLinkedIn];
     if(self.showSnapchatBubble)      [self createButtonWithIcon:@"SocialIconSnapchat.png" backgroundColor:self.twitterBackgroundColorRGB andType: BubbleTypeSnapchat];
     if(self.showInstagramBubble)
         [self createButtonWithIcon:@"SocialIconInstagram.png" backgroundColor:self.mailBackgroundColorRGB andType:BubbleTypeInstagram];
    if(self.showTwitterBubble)
        [self createButtonWithIcon:@"SocialIconTwitter.png" backgroundColor:self.twitterBackgroundColorRGB andType: BubbleTypeTwitter];
    if(self.showFacebookBubble)
        [self createButtonWithIcon:@"SocialIconFacebook.png" backgroundColor:self.facebookBackgroundColorRGB andType:BubbleTypeFacebook];
    
   // if(self.showVimeoBubble)        [self createButtonWithIcon:@"SocialIconFacebook.png" backgroundColor:self.facebookBackgroundColorRGB andType:BubbleTypeVimeo];

    
       // if (!_isForJoining)
        //    [self createProfileWithImage:[UIImage imageNamed:@"defaultUser"]];
        //[self addSubview:_profileImageView];
    
        //[self performSelector:@selector(showBubbleWithAnimation:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:bubble, @"button", coordinate, @"coordinate", nil] afterDelay:delayTime];
        
        if(bubbles.count == 0) return;
        
        
        float bubbleDistanceFromPivot = self.radius - self.bubbleRadius;
        
        int angleTotal = 180;
        float bubblesBetweenAngel = angleTotal / bubbles.count;
        float angely = (angleTotal - bubblesBetweenAngel) * 0.5;
        float startAngel = angleTotal - angely;
        
        NSMutableArray *coordinates = [NSMutableArray array];
        
        for (int i = 0; i < bubbles.count; i++)
        {
            UIButton *bubble = [bubbles objectAtIndex:i];
            bubble.tag = i;
            
            float angle = startAngel + i * bubblesBetweenAngel;
            float x = - cos(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            float y = .9*sin(angle * M_PI / 180) * bubbleDistanceFromPivot + self.radius;
            
            [coordinates addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", [NSNumber numberWithFloat:y], @"y", nil]];
            
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.center = CGPointMake(self.radius, self.radius);
        }
        
        int inetratorI = 0;
        for (NSDictionary *coordinate in coordinates)
        {
            UIButton *bubble = [bubbles objectAtIndex:inetratorI];
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(showBubbleWithAnimation:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:bubble, @"button", coordinate, @"coordinate", nil] afterDelay:delayTime];
            inetratorI++;
        }
    UIImage *imageOfScreen = [self imageWithView:self];
    //}
}

- (void) hideJoin
{
    self.isAnimating = YES;
    int inetratorI = 0;
    for (UIButton *bubble in joinBubble)
    {
        float delayTime = inetratorI * 0.1;
        [self performSelector:@selector(hideBubbleWithAnimation:) withObject:bubble afterDelay:delayTime];
        ++inetratorI;
    }
    
    _showingJoin = NO;
    
}
-(void)hide
{
    //if (_isForJoining)
      //  return;
    
    
    //if(!self.isAnimating)
   // {
        self.isAnimating = YES;
        int inetratorI = 0;
        for (UIButton *bubble in bubbles)
        {
            float delayTime = inetratorI * 0.1;
            [self performSelector:@selector(hideBubbleWithAnimation:) withObject:bubble afterDelay:delayTime];
            ++inetratorI;
        }
        
        _showingBubbles = NO;
    //}
}

-(void) moveToLeft
{
    if (position==0)
        return;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.center = CGPointMake(centerPoint.x, self.center.y);
        // bubble.center = CGPointMake([[coordinate objectForKey:@"x"] floatValue], [[coordinate objectForKey:@"y"] floatValue]);
        // bubble.alpha = 1;
        // bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [self show];
    }];
    
}

-(void) moveToMiddle
{
    if (position==1)
        return;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.center = CGPointMake( self.parentView.bounds.size.width/2 - self.bounds.size.width/4, self.center.y);
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        // bubble.center = CGPointMake([[coordinate objectForKey:@"x"] floatValue], [[coordinate objectForKey:@"y"] floatValue]);
        // bubble.alpha = 1;
        // bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [self show];
    }];
    
}

-(void) moveToRight
{
    
    
}

#pragma mark -
#pragma mark Helper functions

-(void)shareViewBackgroundTapped:(UITapGestureRecognizer *)tapGesture {
    [tapGesture.view removeFromSuperview];
    [self hide];
}

-(void)showBubbleWithAnimation:(NSDictionary *)info
{
    UIButton *bubble = (UIButton *)[info objectForKey:@"button"];
    NSDictionary *coordinate = (NSDictionary *)[info objectForKey:@"coordinate"];
    

    [UIView animateWithDuration:0.25 animations:^{
        bubble.center = CGPointMake([[coordinate objectForKey:@"x"] floatValue], [[coordinate objectForKey:@"y"] floatValue]);
        bubble.alpha = 1;
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            bubble.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                bubble.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                if(bubble.tag == bubbles.count - 1)
                {
                    if(!self.isForJoining)
                    {
                        if([self.delegate respondsToSelector:@selector(semiCircleProfileBubblesDidShow)]) {
                            [self.delegate semiCircleProfileBubblesDidShow];
                        } 
                    }
                    self.isAnimating = NO;

                }
                bubble.layer.shadowColor = [UIColor blackColor].CGColor;
                bubble.layer.shadowOpacity = 0.2;
                bubble.layer.shadowOffset = CGSizeMake(0, 1);
                bubble.layer.shadowRadius = 2;
            }];
        }];
    }];
}
-(void)hideBubbleWithAnimation:(UIButton *)bubble
{
    [UIView animateWithDuration:0.2 animations:^{
        bubble.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            bubble.center = CGPointMake(self.radius, self.radius);
            bubble.transform = CGAffineTransformMakeScale(0.001, 0.001);
            bubble.alpha = 0;
        } completion:^(BOOL finished) {
            if(bubble.tag == bubbles.count - 1) {
              
                if([self.delegate respondsToSelector:@selector(semiCircleProfileBubblesDidHide)]) {
                    [self.delegate semiCircleProfileBubblesDidHide];
                }
                self.isAnimating = NO;
                //  self.hidden = YES;
                [bgView removeFromSuperview];
                bgView = nil;
                
                
                //[self removeFromSuperview];
            }
            [bubble removeFromSuperview];
        }];
    }];
}

-(void)createButtonWithIcon:(NSString *)iconName backgroundColor:(int)rgb andType:(BubbleType)type
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.bubbleRadius/2, self.bubbleRadius/2, 2 * self.bubbleRadius, 2 * self.bubbleRadius);
    button.layer.anchorPoint = CGPointMake(.3, .5);

    // Circle background
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(self.bubbleRadius/2, self.bubbleRadius/2, 2 * self.bubbleRadius, 2 * self.bubbleRadius)];
    //circle.backgroundColor = [self colorFromRGB:rgb];
    circle.backgroundColor = [UIColor clearColor];
    circle.layer.cornerRadius = self.bubbleRadius;
    circle.layer.masksToBounds = YES;
    circle.opaque = NO;
    circle.alpha = 1;
    
    // Circle icon
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.bubbleRadius/2, self.bubbleRadius/2, self.bubbleRadius *2, self.bubbleRadius *2)];
   // UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AAShareBubbles.bundle/icon-aa-facebook@2x.png"]];

    ///UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", iconName]]];
    NSLog(@"creating one : %@", iconName);
    //[icon setImage:[UIImage imageNamed:@"AAShareBubbles.bundle/icon-aa-facebook.png"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", iconName]]];
    
    CGRect f = icon.frame;
    f.origin.x = (circle.frame.size.width - f.size.width) * 0.5;
    f.origin.y = (circle.frame.size.height - f.size.height) * 0.5;
    icon.frame = f;
    [circle addSubview:icon];
    
    [button setBackgroundImage:[self imageWithView:circle] forState:UIControlStateNormal];
    
    
    if (type == BubbleTypeJoin)
    {
        [joinBubble addObject:button];
        [bubbleIndexTypes setObject:[NSNumber numberWithInteger:type] forKey:[NSNumber numberWithInteger:707]];
    }
    else
    {
        [bubbles addObject:button];
        [bubbleIndexTypes setObject:[NSNumber numberWithInteger:type] forKey:[NSNumber numberWithInteger:(bubbles.count - 1)]];
    }
    [self insertSubview:button atIndex:0];
}


- (void) createProfileWithImageString: (NSString *) imageString
{
    int radius = 75;
    NSLog(@"Center point x: %f, y: %f", centerPoint.x-radius/2, centerPoint.y);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(tappedProfile) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.radius - radius/2, self.radius - radius, 2 * radius, 2 * radius);
    button.alpha = 1;
    
    // Profile "Background"
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.radius/2, 100, radius*2, radius*2)];
    view.backgroundColor = [UIColor grayColor];
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    view.opaque = NO;
    view.alpha = 1;
    
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, radius*2, radius*2)];
    //profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    //[_profileImageView setImage:image];
    
    [_profileImageView setImageWithURL: [NSURL URLWithString: imageString]];
    
    CGRect f = _profileImageView.frame;
    f.origin.x = (view.frame.size.width - f.size.width) * 0.5;
    f.origin.y = (view.frame.size.height - f.size.height) * 0.5;
    _profileImageView.frame = f;
    [view addSubview:_profileImageView];
    //[button setBackgroundImage:[self imageWithView:view] forState:UIControlStateNormal];
    [button setBackgroundImage: [self imageWithView:view] forState:UIControlStateNormal];
    /*
    UIImageView *icon = [[UIImageView alloc] init];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [icon setImage:image];
    CGRect f = icon.frame;
    f.origin.x = (view.frame.size.width - f.size.width) * 0.5;
    f.origin.y = (view.frame.size.height - f.size.height) * 0.5;
    icon.frame = f;
    [view addSubview:icon];
    */
   // [button setBackgroundImage:[self imageWithView:view] forState:UIControlStateNormal];


    NSLog(@"Adding it");
    [self addSubview:button];
}
- (void) createProfileWithImage: (UIImage *) image
{
    int radius = 90;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(tappedProfile) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.radius - radius/2, self.radius - radius, 2 * radius, 2 * radius);
    button.alpha = 1;
    
    // Profile "Background"
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.radius/2, 100, radius*2, radius*2)];
    view.backgroundColor = [UIColor grayColor];
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    view.opaque = NO;
    view.alpha = 1;
    
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, radius*2, radius*2)];
    //profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    //[_profileImageView setImageWithURL:[NSURL URLWithString: imageURL]];
    
    //[_profileImageView setImageWithURL: [NSURL URLWithString: _profileImageURL]];
    [_profileImageView setImage:image];

    CGRect f = _profileImageView.frame;
    f.origin.x = (view.frame.size.width - f.size.width) * 0.5;
    f.origin.y = (view.frame.size.height - f.size.height) * 0.5;
    _profileImageView.frame = f;
    [view addSubview:_profileImageView];
    //[button setBackgroundImage:[self imageWithView:view] forState:UIControlStateNormal];
    [button setBackgroundImage: [self imageWithView:view] forState:UIControlStateNormal];
    /*
     UIImageView *icon = [[UIImageView alloc] init];
     icon.contentMode = UIViewContentModeScaleAspectFit;
     [icon setImage:image];
     CGRect f = icon.frame;
     f.origin.x = (view.frame.size.width - f.size.width) * 0.5;
     f.origin.y = (view.frame.size.height - f.size.height) * 0.5;
     icon.frame = f;
     [view addSubview:icon];
     */
    // [button setBackgroundImage:[self imageWithView:view] forState:UIControlStateNormal];
    
    
    [self addSubview:button];
    
    
}

-(UIColor *)colorFromRGB:(int)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}

-(UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
