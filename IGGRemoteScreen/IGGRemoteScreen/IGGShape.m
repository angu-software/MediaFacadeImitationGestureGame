//
//  IGGShape.m
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IGGShape.h"

@implementation IGGShape

@synthesize minSize = _minSize;
@synthesize maxSize = _maxSize;
@synthesize type = _type;

+(IGGShape*) randomShape{
    
    IGGShapeType rType = (IGGShapeType)rand()%4;
    //rType = IGGHouse;
    IGGShape* rShape = [[IGGShape alloc] init];
    rShape.type = rType;
    return rShape;
}

- (id)init
{
    self = [super init];
    if (self) {
        srand([[NSDate date] timeIntervalSince1970]);
        _minSize = CGSizeMake(10.0f, 10.0f);
        _maxSize = CGSizeMake(250.0f, 250.0f);
    }
    return self;
}

- (NSString *)description{

    switch (_type) {
        case IGGSquare:
            //return @"Square";
            return @"Quadrat";
            break;
            
        case IGGCircle:
            //return @"Circle";
            return @"Kreis";
            break;
        case IGGTriangle:
            //return @"Triangle";
            return @"Dreieck";
            break;
        case IGGHouse:
            //return @"House";
            return @"Haus";
            break;
    }
    
}

@end
