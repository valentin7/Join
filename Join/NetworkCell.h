//
//  NetworkCell.h
//  Join
//
//  Created by Valentin Perez on 6/5/14.
//  Copyright (c) 2014 Valpe Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;

@end
