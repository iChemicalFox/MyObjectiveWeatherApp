//
//  OWHeaderViewController.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 30.09.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "OWHeaderViewController.h"
#import "APIManager.h"

@interface OWHeaderViewController ()

@property (nonatomic, strong) APIManager* apiManager;

@end

@implementation OWHeaderViewController

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.apiManager = [[APIManager alloc] initWithJSON:[NetworkClient alloc]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;

    float temperatureLabelSize = 100;
    float textInfoSize = 20;
    float leftIndent = 20;
    
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
//       self.tableView.tableHeaderView = header;
    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Saint-Petersburg";
    cityLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];
    cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [cityLabel.topAnchor constraintEqualToAnchor:header.topAnchor constant:20],
        [cityLabel.leadingAnchor constraintEqualToAnchor:header.safeAreaLayoutGuide.leadingAnchor],
        [cityLabel.trailingAnchor constraintEqualToAnchor:header.safeAreaLayoutGuide.trailingAnchor]
    ]];
    UILabel *windAndPressureLabel = [[UILabel alloc] init];
    windAndPressureLabel.backgroundColor = [UIColor clearColor];
    windAndPressureLabel.textColor = [UIColor whiteColor];
    windAndPressureLabel.text = @"wind speed 0 ms / pressure 0 hPa";
    windAndPressureLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    [header addSubview:windAndPressureLabel];
    windAndPressureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [windAndPressureLabel.bottomAnchor constraintEqualToAnchor:header.bottomAnchor constant:-30],
        [windAndPressureLabel.leftAnchor constraintEqualToAnchor:header.leftAnchor constant:20]
    ]];
    UILabel *temperatureLabel = [[UILabel alloc] init];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont systemFontOfSize:temperatureLabelSize weight:UIFontWeightUltraLight];
    [header addSubview:temperatureLabel];
    temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [temperatureLabel.topAnchor constraintEqualToAnchor:windAndPressureLabel.topAnchor constant:-20-temperatureLabelSize].active = YES;
    [temperatureLabel.leftAnchor constraintEqualToAnchor:header.leftAnchor constant:leftIndent].active = YES;
    UILabel *conditionsLabel = [[UILabel alloc] init];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    conditionsLabel.textColor = [UIColor whiteColor];
    conditionsLabel.text = @"waiting for condition";
    [header addSubview:conditionsLabel];
    conditionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [conditionsLabel.topAnchor constraintEqualToAnchor:windAndPressureLabel.topAnchor constant:-140],
        [conditionsLabel.leftAnchor constraintEqualToAnchor:header.leftAnchor constant:60]
    ]];
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"loading"];
    [header addSubview:iconView];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [iconView.leftAnchor constraintEqualToAnchor:header.leftAnchor constant:leftIndent],
        [iconView.topAnchor constraintEqualToAnchor:conditionsLabel.topAnchor constant:-5]
    ]];
    
    [self.apiManager getWeatherWithCompletionHandler:^(OWWeatherModel * _Nonnull weather) {
        conditionsLabel.text = weather.conditions;
        iconView.image = [UIImage imageNamed:weather.imageName];
        temperatureLabel.text = [NSString stringWithFormat:@"%ld°", weather.temperature.integerValue - 271];
        windAndPressureLabel.text = [NSString stringWithFormat:@"wind speed %ld ms / pressure %ld hPa", weather.windSpeed.integerValue,weather.pressure.integerValue];
    }];
}

@end
