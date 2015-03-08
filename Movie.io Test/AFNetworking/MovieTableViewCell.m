//
//  MovieTableViewCell.m
//  Movie.io Test
//
//  Created by James Lonely on 15/3/8.
//  Copyright (c) 2015年 James Lonely. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell
@synthesize posterImageView, starRateView, titleLabel, subtitleLabel;

-(void)dealloc{
    self.posterImageView=nil;
    self.starRateView=nil;
    self.titleLabel=nil;
    self.subtitleLabel=nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.posterImageView = [UIImageView new];
        self.posterImageView.frame = CGRectMake(10, 5, 50, 70);
        [self addSubview:self.posterImageView];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.frame = CGRectMake(65, 12, self.frame.size.width-70, 40);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.preferredMaxLayoutWidth = 250;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
    
        self.subtitleLabel = [UILabel new];
        self.subtitleLabel.frame = CGRectMake(65, 55, self.frame.size.width-70, 20);
        self.subtitleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.subtitleLabel];
                
        self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(self.frame.size.width-80, 55, 80, 16) numberOfStars:5];
        self.starRateView.scorePercent = 0;
        self.starRateView.allowIncompleteStar = YES;
        self.starRateView.hasAnimation = YES;
        [self addSubview:self.starRateView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
