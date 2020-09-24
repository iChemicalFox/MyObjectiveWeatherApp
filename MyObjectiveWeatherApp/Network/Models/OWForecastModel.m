//
//  OWForecastModel.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 09.09.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "OWForecastModel.h"

@interface OWForecastModel ()

@property (nonatomic, strong) NSArray *daily;
@property (nonatomic, strong) NSArray *hourly;

@end

@implementation OWForecastModel

- (instancetype)initWithJSON:(NSDictionary*)json {
    self = [super init];
    if (self) {
        self.daily = json[@"daily"];
        self.hourly = json[@"hourly"];
    }
    return self;
}

-(NSDictionary *) getDateForecast:(NSInteger) day {
    NSMutableDictionary *forecastDict = [[NSMutableDictionary alloc] init];

    NSDictionary *dayForecast = _daily[day];
    NSNumber *dt = dayForecast[@"dt"];
    NSDate *fullDate = [NSDate dateWithTimeIntervalSince1970:dt.doubleValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM"];
    NSString *date = [dateFormatter stringFromDate:fullDate];

    NSDictionary *allDayTemp = dayForecast[@"temp"];
    NSNumber *nightTempK = allDayTemp[@"night"];
    NSNumber *dayTempK = allDayTemp[@"day"];
    NSNumber *nightTempC = [NSNumber numberWithFloat:lroundf(nightTempK.floatValue) - 272];
    NSNumber *dayTempC = [NSNumber numberWithFloat:lroundf(dayTempK.floatValue) - 272];

    NSArray *dayWeather = dayForecast[@"weather"];
    for (NSDictionary *weather in dayWeather) {
        NSString *icon = weather[@"icon"];
        [forecastDict setValue:icon forKey:@"icon"];
    }

    [forecastDict setValue:nightTempC forKey:@"night"];
    [forecastDict setValue:dayTempC forKey:@"day"];
    [forecastDict setValue:date forKey:@"date"];

    return forecastDict;
}

-(NSDictionary *) getTimeForecast:(NSInteger) hour {
    NSMutableDictionary *forecastDict = [[NSMutableDictionary alloc] init];

    NSArray *hourly = _hourly[hour];
    NSDictionary *hourForecast = hourly[hour];
    NSNumber *tempK = hourForecast[@"temp"];
    NSNumber *tempC = [NSNumber numberWithFloat:(lroundf(tempK.floatValue) - 272)];

    NSNumber *dt = hourForecast[@"dt"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dt.floatValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *time = [dateFormatter stringFromDate:date];

    NSArray *hourWeather = hourForecast[@"weather"];
    for (NSDictionary *weather in hourWeather) {
        NSString *icon = weather[@"icon"];
        [forecastDict setValue:icon forKey:@"icon"];
    }

    [forecastDict setValue:tempC forKey:@"temp"];
    [forecastDict setValue:time forKey:@"time"];

    return forecastDict;
}

@end
