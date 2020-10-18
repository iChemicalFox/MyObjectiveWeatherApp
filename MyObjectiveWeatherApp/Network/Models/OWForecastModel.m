//
//  OWForecastModel.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 09.09.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "OWForecastModel.h"
#import "OWImagesModel.h"

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

-(NSDictionary *) getDateForecast:(long)day {
    NSMutableDictionary *forecastDateDict = [[NSMutableDictionary alloc] init];

    NSDictionary *dayForecast = _daily[day];
    NSNumber *dt = dayForecast[@"dt"];
    NSDate *fullDate = [NSDate dateWithTimeIntervalSince1970:dt.doubleValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM"];
    NSString *date = [dateFormatter stringFromDate:fullDate];

    NSDictionary *allDayTemp = dayForecast[@"temp"];
    NSNumber *nightTempK = allDayTemp[@"night"];
    NSNumber *dayTempK = allDayTemp[@"day"];
    NSString *nightTempC = [NSString stringWithFormat:@"%@°", [NSNumber numberWithFloat:lroundf(nightTempK.floatValue) - 272]];
    NSString *dayTempC = [NSString stringWithFormat:@"%@°", [NSNumber numberWithFloat:lroundf(dayTempK.floatValue) - 272]];

    NSArray *dayWeather = dayForecast[@"weather"];
    for (NSDictionary *weather in dayWeather) {
        NSString *icon = weather[@"icon"];
        OWImagesModel *imagesModel = [[OWImagesModel alloc] init];
        icon = [imagesModel imageMap][icon];
        [forecastDateDict setValue:icon forKey:@"icon"];
    }

    [forecastDateDict setValue:nightTempC forKey:@"night"];
    [forecastDateDict setValue:dayTempC forKey:@"day"];
    [forecastDateDict setValue:date forKey:@"date"];

    return forecastDateDict;
}

-(NSDictionary *) getTimeForecast:(long)hour {
    NSMutableDictionary *forecastTimeDict = [[NSMutableDictionary alloc] init];

    NSDictionary *hourForecast = _hourly[hour];
    NSNumber *tempK = hourForecast[@"temp"];
    NSString *tempC = [NSString stringWithFormat:@"%@°", [NSNumber numberWithFloat:(lroundf(tempK.floatValue) - 272)]];

    NSNumber *dt = hourForecast[@"dt"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dt.floatValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *time = [dateFormatter stringFromDate:date];

    NSArray *hourWeather = hourForecast[@"weather"];
    for (NSDictionary *weather in hourWeather) {
        NSString *icon = weather[@"icon"];
        OWImagesModel *imagesModel = [[OWImagesModel alloc] init];
        icon = [imagesModel imageMap][icon];
        [forecastTimeDict setValue:icon forKey:@"icon"];
    }

    [forecastTimeDict setValue:tempC forKey:@"temp"];
    [forecastTimeDict setValue:time forKey:@"time"];

    return forecastTimeDict;
}

@end
