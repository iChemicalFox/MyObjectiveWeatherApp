//
//  NetworkClient.m
//  MyObjectiveWeatherApp
//
//  Created by Алексей on 24.09.2020.
//  Copyright © 2020 Алексей. All rights reserved.
//

#import "NetworkClient.h"

@implementation NetworkClient

- (void) getWithURL:(NSURL * _Nonnull)url onSuccess:(void (^_Nonnull)(NSDictionary * _Nonnull jsonResponse))successHandler onError:(void (^_Nonnull)(NSError * _Nullable error))errorHandler {

    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorHandler(error);
            });
        }
    
        NSError *serializationError;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&serializationError];
        if (serializationError) {
            NSLog(@"Failed to serialized into JSON %@", serializationError.localizedDescription);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            successHandler(responseJSON);
        });
        
    }] resume];
}

@end
