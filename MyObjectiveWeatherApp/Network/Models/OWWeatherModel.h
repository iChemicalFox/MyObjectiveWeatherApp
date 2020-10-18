//
//  OWWeatherModel.h
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 27.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWWeatherModel : NSObject

@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSString *iconURLString; // TODO: think abount proper name
@property (nonatomic, strong) NSString *conditions;
@property (nonatomic, strong) NSNumber *pressure;

-(NSString *) imageName;

-(instancetype)initWithJSON:(NSDictionary*)json;

@end
