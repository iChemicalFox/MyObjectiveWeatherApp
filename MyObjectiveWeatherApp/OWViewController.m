//
//  ViewController.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 26.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "OWViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "OWWeatherModel.h"
#import "APIManager.h"

@interface OWViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic, strong) UIView *header;

@end

@implementation OWViewController

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.apiManager = [[APIManager alloc] initWithJSON:[NetworkClient alloc]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *backgroundImage = [UIImage imageNamed:@"SaintPetersburg"];

    self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];

    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:backgroundImage blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];

    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    /*
     1. Несколько методов, в каждый из которых установить необходимый параметер
     2. Сделать метод configureWithWeather:(OWWeatherModel*)weather;
     
     */

    float temperatureLabelSize = 100;
    float textInfoSize = 20;
    float leftIndent = 20;

    self.header = [[UIView alloc] initWithFrame:CGRectZero];
    self.header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;

    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Saint-Petersburg";
    cityLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.header addSubview:cityLabel];
    cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [cityLabel.topAnchor constraintEqualToAnchor:self.header.topAnchor constant:20],
        [cityLabel.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor],
        [cityLabel.trailingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.trailingAnchor]
    ]];

    UILabel *windAndPressureLabel = [[UILabel alloc] init];
    windAndPressureLabel.backgroundColor = [UIColor clearColor];
    windAndPressureLabel.textColor = [UIColor whiteColor];
    windAndPressureLabel.text = @"wind speed 0 ms / pressure 0 hPa";
    windAndPressureLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    [self.header addSubview:windAndPressureLabel];
    windAndPressureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [windAndPressureLabel.bottomAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.bottomAnchor constant:-30],
        [windAndPressureLabel.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor constant:leftIndent],
        [windAndPressureLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.header.trailingAnchor constant:-20]
    ]];

    UILabel *temperatureLabel = [[UILabel alloc] init];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont systemFontOfSize:temperatureLabelSize weight:UIFontWeightUltraLight];
    [self.header addSubview:temperatureLabel];
    temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [temperatureLabel.topAnchor constraintEqualToAnchor:windAndPressureLabel.topAnchor constant:-20-temperatureLabelSize],
        [temperatureLabel.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor constant:leftIndent]
    ]];

    UILabel *conditionsLabel = [[UILabel alloc] init];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    conditionsLabel.textColor = [UIColor whiteColor];
    conditionsLabel.text = @"waiting for condition";
    [self.header addSubview:conditionsLabel];
    conditionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [conditionsLabel.topAnchor constraintEqualToAnchor:windAndPressureLabel.topAnchor constant:-140],
        [conditionsLabel.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor constant:60]
    ]];

    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"loading"];
    [self.header addSubview:iconView];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [iconView.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor constant:leftIndent],
        [iconView.topAnchor constraintEqualToAnchor:conditionsLabel.topAnchor constant:-5]
    ]];
    
    [self.apiManager getWeatherWithCompletionHandler:^(OWWeatherModel * _Nonnull weather) {
        conditionsLabel.text = weather.conditions;
        iconView.image = [UIImage imageNamed:weather.imageName];
        temperatureLabel.text = [NSString stringWithFormat:@"%ld°", weather.temperature.integerValue - 271];
        windAndPressureLabel.text = [NSString stringWithFormat:@"wind speed %ld ms / pressure %ld hP", weather.windSpeed.integerValue, weather.pressure.integerValue];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];

    if (indexPath.section == 0) { // есть баги
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Hourly Forecast"];
        } else {
            // configurateHourlyCell
        }
    }
    
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Daily Forecast"];
        } else {
        // configurateDailyCell
        }
    }

    return cell;
}

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

// надо подумать как растянуть ячейки на весь экран. 7 для прогноза по часам и 7 для прогноза по дням

#pragma mark - UITableViewDelegate

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect bounds = self.view.bounds;

    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
    self.header.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds) - self.view.safeAreaInsets.bottom);
}

// test


@end
