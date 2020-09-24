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
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) APIManager* apiManager;

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

    self.screenHeight = [UIScreen mainScreen].bounds.size.height;

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

    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 50;
    CGFloat iconHeight = 35;
    CGFloat indent = 75;

    CGRect hiloFrame = CGRectMake(inset,
                                  headerFrame.size.height - (hiloHeight + indent),
                                  headerFrame.size.width - (2 * inset),
                                  hiloHeight);

    CGRect temperatureFrame = CGRectMake(inset,
                                         headerFrame.size.height - (temperatureHeight + hiloHeight + indent),
                                         headerFrame.size.width - (2 * inset),
                                         temperatureHeight);

    CGRect iconFrame = CGRectMake(inset,
                                  temperatureFrame.origin.y - iconHeight,
                                  iconHeight,
                                  iconHeight);

    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);


    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;

    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:temperatureLabel];

    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"wind speed 0ms / pressure 0p";
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    [header addSubview:hiloLabel];

    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Saint-Petersburg";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];

    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20]; // TODO: rework with [UIFont systemFontOfSize:(CGFloat) weight:(UIFontWeight)] for all fonts
    conditionsLabel.textColor = [UIColor whiteColor];
    conditionsLabel.text = @"test";
    [header addSubview:conditionsLabel];

    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"weather-tstorm"];
    [header addSubview:iconView];
    // [iconView.leadingAnchor constraintEqualToAnchor:header constant:20].active = YES; // Just example
    
    [self.apiManager getWeatherWithCompletionHandler:^(OWWeatherModel * _Nonnull weather) {
        conditionsLabel.text = weather.descript;
        iconView.image = [UIImage imageNamed:weather.imageName];
        temperatureLabel.text = [NSString stringWithFormat:@"%ld°", weather.temperature.integerValue - 271]; // TODO: сковертировать кельвины в цельсии. Обратить внимание на возможные отрицательные значения
        hiloLabel.text = [NSString stringWithFormat:@"wind speed %ldms / pressure %ldp", weather.windSpeed.integerValue, weather.pressure.integerValue];
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

// ячеечки надо доделать

    return cell;
}

// надо подумать как растянуть ячейки на весь экран. 7 для прогноза по часам и 7 для прогноза по дням

#pragma mark - UITableViewDelegate

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect bounds = self.view.bounds;

    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

// test


@end
