//
//  NetworkClient.h
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 24.09.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkClient : NSObject

- (void) getWithURL:(NSURL * _Nonnull)url onSuccess:(void (^_Nonnull)(NSDictionary * _Nonnull jsonResponse))successHandler onError:(void (^_Nonnull)(NSError * _Nullable error))errorHandler;

@end
