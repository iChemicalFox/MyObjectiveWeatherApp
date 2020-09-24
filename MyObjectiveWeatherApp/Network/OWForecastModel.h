//
//  OWForecastModel.h
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 09.09.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OWForecastModel : NSObject

@property (nonatomic, strong) NSDictionary *forecast;
@property (nonatomic, strong) NSArray *daily;
@property (nonatomic, strong) NSArray *hourly;

-(NSDictionary *) getDateForecast:(NSInteger) day;
-(NSDictionary *) getTimeForecast:(NSInteger) hour;

@end
