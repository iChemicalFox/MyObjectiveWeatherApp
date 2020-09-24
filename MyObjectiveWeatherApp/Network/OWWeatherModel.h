//
//  OWWeatherModel.h
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 27.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWWeatherModel : NSObject

@property (nonatomic, strong) NSDictionary *weather;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSString *icon; // iconURLString
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSNumber *pressure;

-(NSString *) imageName;

@end
