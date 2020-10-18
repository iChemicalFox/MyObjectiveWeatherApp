//
//  ForecastTableViewCell.h
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 02.10.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForecastTableViewCell : UITableViewCell

- (void) setTitle:(NSString*)title;
- (void) setTemperatureTitle:(NSString*)temperature;
- (void) setIconText:(NSString*)iconText;

@end

NS_ASSUME_NONNULL_END
