//
//  Location.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 08.10.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype) init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;

        [self.locationManager requestLocation];
    }
    return self;
}

- (NSNumber *) getCoordinateLatitide {
    return @(self.currentLocation.coordinate.latitude);
}

- (void) getLocation:(CLLocation *)locations {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        self.placemark = [placemarks lastObject];
    }];
}

- (NSNumber *) getCoordinateLongitude {
    return @(self.currentLocation.coordinate.longitude);
}

- (void)findCurrentLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];

    if (location.horizontalAccuracy > 0) {
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
    }

    [self getLocation: location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

@end
