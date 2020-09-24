//
//  OWWeatherNetworkManager.h
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 27.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OWWeatherModel.h"
#import "OWForecastModel.h"

@interface OWWeatherNetworkManager : NSObject

-(void) getWeather;
-(void) getForecast;

@end

