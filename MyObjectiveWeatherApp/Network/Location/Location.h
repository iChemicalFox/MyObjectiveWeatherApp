//
//  Location.h
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 08.10.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, strong) CLPlacemark *placemark;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, assign) CLAuthorizationStatus *status;

- (NSNumber *) getCoordinateLatitide;
- (NSNumber *) getCoordinateLongitude;
- (void) findCurrentLocation;
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void) getLocation:(CLLocation *)locations;

@end

