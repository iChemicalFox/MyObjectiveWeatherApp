//
//  AppDelegate.h
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 26.08.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

