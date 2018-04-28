//
//  Cafe.m
//  Uber Bean
//
//  Created by Alejandro Zielinsky on 2018-04-27.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import "Cafe.h"

@implementation Cafe

-(instancetype)initWithData:(NSDictionary*)dictionary
{
    self = [super init];

    _name = dictionary[@"name"];
    NSDictionary * coordinates = dictionary[@"coordinates"];
    NSString *lat = coordinates[@"latitude"];
    NSString *lng = coordinates[@"longitude"];
   
    _rating = dictionary[@"rating"];
   
    _coordinates = CLLocationCoordinate2DMake([lat doubleValue],[lng doubleValue]);
    
    _imageURL = dictionary[@"image_url"];
    
    _title = _name;
    _coordinate = _coordinates;
    
    return self;
}
@end
