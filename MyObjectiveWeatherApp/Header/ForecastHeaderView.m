//
//  ForecastHeaderView.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 02.10.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "ForecastHeaderView.h"

@interface ForecastHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ForecastHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    [self configureUI];
    return self;
}


- (void) setTitle:(NSString*)title {
    self.titleLabel.text = title;
}

- (void) configureUI {
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.safeAreaLayoutGuide.leadingAnchor constant:20],
//        [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.contentView.safeAreaLayoutGuide.trailingAnchor constant:-20],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor]
    ]];
}

@end
