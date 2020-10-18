//
//  OWWeatherModel.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 27.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "OWWeatherModel.h"
#import "OWImagesModel.h"

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

- (NSString *)imageName {
    OWImagesModel *imagesModel = [[OWImagesModel alloc] init];
    return [imagesModel imageMap][self.iconURLString];
}

@end
