//
//  MovieTableViewCell.h
//  Movie.io Test
//
//  Created by James Lonely on 15/3/8.
//  Copyright (c) 2015年 James Lonely. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface MovieTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *posterImageView;
@property (nonatomic, retain) CWStarRateView *starRateView;
@property (nonatomic, retain) UILabel *titleLabel,*subtitleLabel;

@end
