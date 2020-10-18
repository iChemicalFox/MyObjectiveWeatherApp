//
//  ForecastTableViewCell.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 02.10.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "ForecastTableViewCell.h"

@interface ForecastTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation ForecastTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    [self configureUI];
    return self;
}


- (void) setTitle:(NSString*)title {
    self.titleLabel.text = title;
}

- (void) setTemperatureTitle:(NSString*)temperature {
    self.temperatureLabel.text = temperature;
}

- (void) setIconText:(NSString*)iconText {
    self.icon.image = [UIImage imageNamed:iconText];
}

- (void) configureUI {
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"waiting for data"; //
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:60],
//        [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-20],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];
    
    self.icon.contentMode = UIViewContentModeScaleAspectFit;
    self.icon.backgroundColor = [UIColor clearColor];
    self.icon.image = [UIImage imageNamed:@"loading"]; //
    [self.contentView addSubview:self.icon];
    self.icon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.icon.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:20],
//        [self.icon.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-20],
        [self.icon.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];

    self.temperatureLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    self.temperatureLabel.textColor = UIColor.whiteColor;
    self.temperatureLabel.textAlignment = NSTextAlignmentLeft;
    self.temperatureLabel.text = @"0°"; //
    [self.contentView addSubview:self.temperatureLabel];
    self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.temperatureLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-20],
        [self.temperatureLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];
    
}

@end
