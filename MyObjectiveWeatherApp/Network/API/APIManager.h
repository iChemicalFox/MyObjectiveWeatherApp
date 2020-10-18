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
#import "NetworkClient.h"
#import <CoreLocation/CoreLocation.h>
#import "Location.h"

@interface APIManager : NSObject

- (instancetype _Nonnull)initWithJSON:(NetworkClient* _Nonnull)client;

- (void)getWeatherWithCompletionHandler:(void (^_Nonnull)(OWWeatherModel * _Nonnull weather))completionHandler;
- (void)getForecastWithCompletionHandler:(void (^_Nonnull)(OWForecastModel * _Nonnull weather))completionHandler;

@end

