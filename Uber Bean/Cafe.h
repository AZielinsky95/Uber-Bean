//
//  Cafe.h
//  Uber Bean
//
//  Created by Alejandro Zielinsky on 2018-04-27.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@interface Cafe : NSObject

//geo coordinates, the image url, and the name of the place
@property CLLocationCoordinate2D coordinates;
@property NSString *imageURL;
@property NSString *name;

-(instancetype)initWithData:(NSDictionary*)dictionary;
@end
