//
//  GRMotionVector.m
//  GestureTraining
//
//  Created by Andreas on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRMotionVector.h"

@implementation GRMotionVector
@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;

-(id)initWithX:(double)x Y:(double)y AndZ:(double)z{
    if (self = [super init]) {
        _x = x;
        _y = y;
        _z = z;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"(x=%f,y=%f,z=%f)", _x,_y,_z];
}

#pragma mark - NSCoding methods

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _x = [aDecoder decodeDoubleForKey:@"x"];
        _y = [aDecoder decodeDoubleForKey:@"y"];
        _z = [aDecoder decodeDoubleForKey:@"z"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:_x forKey:@"x"];
    [aCoder encodeDouble:_y forKey:@"y"];
    [aCoder encodeDouble:_z forKey:@"z"];
}

@end
