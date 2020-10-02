//
//  OWWeatherModel.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 27.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "OWWeatherModel.h"

@implementation OWWeatherModel

- (instancetype)initWithJSON:(NSDictionary*)json {
    self = [super init];
    if (self) {
        NSDictionary *windDict = json[@"wind"];
        self.windSpeed = windDict[@"speed"];

        NSDictionary *mainDict = json[@"main"];
        self.temperature = mainDict[@"temp"];
        self.pressure = mainDict[@"pressure"];

        NSArray *weatherArray = json[@"weather"];

        for (NSDictionary *weatherDict in weatherArray) {
            self.iconURLString = weatherDict[@"icon"];
            self.conditions = weatherDict[@"description"];
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
    return [OWWeatherModel imageMap][self.iconURLString];
}

@end
