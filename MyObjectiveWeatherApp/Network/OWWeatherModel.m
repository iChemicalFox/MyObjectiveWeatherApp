//
//  OWWeatherModel.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 27.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "OWWeatherModel.h"

@implementation OWWeatherModel

- (instancetype) init {
    self = [super init];
    if (self) { // доделать
        NSDictionary *windDict = _weather[@"wind"];
        _windSpeed = windDict[@"speed"];

        NSDictionary *mainDict = _weather[@"main"];
        _temperature = mainDict[@"temp"];
        _pressure = mainDict[@"pressure"];

        NSArray *weatherArray = _weather[@"weather"];

        for (NSDictionary *weatherDict in weatherArray) {
            _icon = weatherDict[@"icon"];
            _descript = weatherDict[@"description"];
        }
    }
    return self;
}

+ (NSDictionary *)imageMap {
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"01n" : @"weather-moon",
                      @"02d" : @"weather-few",
                      @"02n" : @"weather-few-night",
                      @"03d" : @"weather-few",
                      @"03n" : @"weather-few-night",
                      @"04d" : @"weather-broken",
                      @"04n" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"09n" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"10n" : @"weather-rain-night",
                      @"11d" : @"weather-tstorm",
                      @"11n" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"13n" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}

- (NSString *)imageName {
    return [OWWeatherModel imageMap][self.icon];
}

@end
