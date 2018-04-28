//
//  NetworkManager.h
//  Uber Bean
//
//  Created by Alejandro Zielinsky on 2018-04-27.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import CoreLocation;

@interface NetworkManager : NSObject

+(void)fetchYelpDataAtCoordinates:(CLLocation*)location block:(void(^)(NSArray* cafes))blockName;


+(void)downloadImage:(NSString*)urlString block:(void(^)(UIImage* image))blockName;

@end
