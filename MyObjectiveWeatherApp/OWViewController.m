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
#import "ForecastHeaderView.h"
#import "ForecastTableViewCell.h"
#import "Location.h"

@interface OWViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *windAndPressureLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *conditionsLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) OWForecastModel *forecast;
@property (nonatomic, strong) Location *location;

@end

@implementation OWViewController

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.apiManager = [[APIManager alloc] initWithJSON:[NetworkClient alloc]];
        self.location = [[Location alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.location findCurrentLocation];
    [[self.location locationManager] requestAlwaysAuthorization];

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
    
    [self.tableView registerClass:[ForecastHeaderView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    [self.tableView registerClass:[ForecastTableViewCell class] forCellReuseIdentifier:@"Cell"];

    float temperatureLabelSize = 100;
    float textInfoSize = 20;
    float leftIndent = 20;

    self.header = [[UIView alloc] initWithFrame:CGRectZero];
    self.header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;

    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.text = @"loading city...";
    self.cityLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.header addSubview:self.cityLabel];
    self.cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.cityLabel.topAnchor constraintEqualToAnchor:self.header.topAnchor constant:20],
        [self.cityLabel.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor],
        [self.cityLabel.trailingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.trailingAnchor]
    ]];

    self.windAndPressureLabel = [[UILabel alloc] init];
    self.windAndPressureLabel.backgroundColor = [UIColor clearColor];
    self.windAndPressureLabel.textColor = [UIColor whiteColor];
    self.windAndPressureLabel.text = @"wind speed 0 ms / pressure 0 hPa";
    self.windAndPressureLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    [self.header addSubview:self.windAndPressureLabel];
    self.windAndPressureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.windAndPressureLabel.bottomAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.bottomAnchor constant:-30],
        [self.windAndPressureLabel.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor constant:leftIndent],
        [self.windAndPressureLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.header.trailingAnchor constant:-20]
    ]];

    self.temperatureLabel = [[UILabel alloc] init];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.text = @"0°";
    self.temperatureLabel.font = [UIFont systemFontOfSize:temperatureLabelSize weight:UIFontWeightUltraLight];
    [self.header addSubview:self.temperatureLabel];
    self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.temperatureLabel.topAnchor constraintEqualToAnchor:self.windAndPressureLabel.topAnchor constant:-20-temperatureLabelSize],
        [self.temperatureLabel.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor constant:leftIndent]
    ]];

    self.conditionsLabel = [[UILabel alloc] init];
    self.conditionsLabel.backgroundColor = [UIColor clearColor];
    self.conditionsLabel.font = [UIFont systemFontOfSize:textInfoSize weight:UIFontWeightLight];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    self.conditionsLabel.text = @"waiting for condition";
    [self.header addSubview:self.conditionsLabel];
    self.conditionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.conditionsLabel.topAnchor constraintEqualToAnchor:self.windAndPressureLabel.topAnchor constant:-140],
        [self.conditionsLabel.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor constant:60]
    ]];

    self.iconView = [[UIImageView alloc] init];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.backgroundColor = [UIColor clearColor];
    self.iconView.image = [UIImage imageNamed:@"loading"];
    [self.header addSubview:self.iconView];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.header.safeAreaLayoutGuide.leadingAnchor constant:leftIndent],
        [self.iconView.topAnchor constraintEqualToAnchor:self.conditionsLabel.topAnchor constant:-5]
    ]];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

        [self.apiManager getWeatherWithCompletionHandler:^(OWWeatherModel * _Nonnull weather) {
            self.conditionsLabel.text = weather.conditions;
            self.iconView.image = [UIImage imageNamed:weather.imageName];
            self.temperatureLabel.text = [NSString stringWithFormat:@"%ld°", weather.temperature.integerValue - 271];
            self.windAndPressureLabel.text = [NSString stringWithFormat:@"wind speed %ld ms / pressure %ld hP",
                                         weather.windSpeed.integerValue, weather.pressure.integerValue];
            self.cityLabel.text = [[self.location placemark] administrativeArea];
        }];
        
        __weak OWViewController *weakSelf = self;
        [self.apiManager getForecastWithCompletionHandler:^(OWForecastModel * _Nonnull forecast) {
            weakSelf.forecast = forecast;
    //        [weakSelf reloadData];
        }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) reloadData {
//    forEach
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ForecastHeaderView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (section == 0) {
        [header setTitle:@"Hourly Forecast"];
    } else if (section == 1) {
        [header setTitle:@"Daily Forecast"];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        NSDictionary *dateForecastDict = [self.forecast getDateForecast:indexPath.item+1];
        [cell setTitle:dateForecastDict[@"date"]];
        [cell setTemperatureTitle:[NSString stringWithFormat:@"%@ / %@", dateForecastDict[@"day"], dateForecastDict[@"night"]]];
        [cell setIconText:dateForecastDict[@"icon"]];
    }
    if (indexPath.section == 0) {
        NSDictionary *timeForecastDict = [self.forecast getTimeForecast:indexPath.item+1];
        [cell setTitle:timeForecastDict[@"time"]];
        [cell setTemperatureTitle:[NSString stringWithFormat:@"%@", timeForecastDict[@"temp"]]];
        [cell setIconText:timeForecastDict[@"icon"]];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect bounds = self.view.bounds;

    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
    self.header.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds) - self.view.safeAreaInsets.bottom);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}

@end
