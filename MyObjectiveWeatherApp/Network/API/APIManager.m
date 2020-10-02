//
//  OWWeatherNetworkManager.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 27.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "APIManager.h"
#import "NetworkClient.h"

@interface APIManager ()

@property(nonatomic, strong) NetworkClient *networkClient;

@end

@implementation APIManager

- (instancetype _Nonnull)initWithJSON:(NetworkClient* _Nonnull)client {
    self = [super init];
    if (self) {
        self.networkClient = client;
    }
    return self;
}

- (void)getWeatherWithCompletionHandler:(void (^)(OWWeatherModel * _Nonnull weather))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?id=498817&appid=9934278765103a1603d5ae8bfa6d3e91"/*, _city*/];
    NSURL *weatherURL = [NSURL URLWithString:urlString]; // TODO: вынести в константы эндпойнт. Например, в класс с статическими методами, каждый метод которого является эндпойнтом (NSURL)
    [self.networkClient getWithURL:weatherURL onSuccess:^(NSDictionary * _Nonnull jsonResponse) {
        OWWeatherModel *weatherModel = [[OWWeatherModel alloc] initWithJSON:jsonResponse];
        completionHandler(weatherModel);
    } onError:^(NSError * _Nullable error) {
        NSLog(@"Error during weather retreiving:%@", error.localizedDescription);
    }];
}

- (void)getForecastWithCompletionHandler:(void (^)(OWForecastModel * _Nonnull forecast))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/onecall?lat=59.441792&lon=30.337689&exclude=houtly&appid=9934278765103a1603d5ae8bfa6d3e91"/*, lat, lon*/];
    NSURL *forecactURL = [NSURL URLWithString:urlString];
    NSLog(@"aiaiaia");
    
    [self.networkClient getWithURL:forecactURL onSuccess:^(NSDictionary * _Nonnull jsonResponse) {
        OWForecastModel *forecastModel = [[OWForecastModel alloc] initWithJSON:jsonResponse];
        completionHandler(forecastModel);
    } onError:^(NSError * _Nullable error) {
        NSLog(@"Error during forecast retreiving:%@", error.localizedDescription);
    }];
}
@end
