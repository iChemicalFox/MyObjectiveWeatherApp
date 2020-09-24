//
//  OWWeatherNetworkManager.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 27.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "OWWeatherNetworkManager.h"

@interface OWWeatherNetworkManager ()

@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *country;

@end

@implementation OWWeatherNetworkManager

-(void) getWeather {
    NSString *urlString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?id=498817&appid=9934278765103a1603d5ae8bfa6d3e91"/*, _city*/];
    NSURL *weatherURL = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:weatherURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        NSError *err;
        NSDictionary *weatherDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err) {
            NSLog(@"Failed to serialized into JSON %@", err);
            return;
        }

        OWWeatherModel *weatherModel = OWWeatherModel.new;
        weatherModel.weather = weatherDictionary;
        
        NSLog(@"aaa");
        
    }] resume];
}

-(void) getForecast {
    NSString *urlString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/onecall?lat=59.441792&lon=30.337689&exclude=houtly&appid=9934278765103a1603d5ae8bfa6d3e91"/*, lat, lon*/];
    NSURL *forecactURL = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:forecactURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        NSError *err;
        NSDictionary *forecastDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err) {
            NSLog(@"Failed to serialized into JSON %@", err);
            return;
        }

        OWForecastModel *forecastModel = OWForecastModel.new;
        forecastModel.forecast = forecastDictionary;
        
        NSLog(@"bbb");
        
    }] resume];
}
@end
