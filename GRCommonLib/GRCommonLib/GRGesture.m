//
//  GRGesture.m
//  GestureRecognizer
//
//  Created by Andreas on 14.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRGesture.h"
#import "GRMotionVector.h"

#pragma mark - GRGestureWeights implementation

#define kLengthWeightKey @"kLengthWeightKey"
#define kMaxXWeightKey @"kMaxXWeightKey"
#define kMaxYWeightKey @"kMaxYWeightKey"
#define kMaxZWeightKey @"kMaxZWeightKey"
#define kMeanXWeightKey @"kMeanXWeightKey"
#define kMeanYWeightKey @"kMeanYWeightKey"
#define kMeanZWeightKey @"kMeanZWeightKey"
#define kMedianXWeightKey @"kMedianXWeightKey"
#define kMedianYWeightKey @"kMedianYWeightKey"
#define kMedianZWeightKey @"kMedianZWeightKey"
#define kPowerKey @"kPowerKey"
#define kSpeedKey @"kSpeedKey"
#define kSpatExtKey @"kSpatExtKey"

@implementation GRGestureWeights

@synthesize lengthWeight = _lengthWeight;
@synthesize maxXWeight = _maxXWeight;
@synthesize maxYWeight = _maxYWeight;
@synthesize maxZWeight = _maxZWeight;
@synthesize meanXWeight = _meanXWeight;
@synthesize meanYWeight = _meanYWeight;
@synthesize meanZWeight = _meanZWeight;
@synthesize medianXWeight = _medianXWeight;
@synthesize medianYWeight = _medianYWeight;
@synthesize medianZWeight = _medianZWeight;
@synthesize powerWeight = _powerWeight;
@synthesize spatialExtendWeight = _spatialExtendWeight;
@synthesize speedWeight = _speedWeight;

+(GRGestureWeights*)defaultWeights{
    GRGestureWeights* defaultWeights = [[GRGestureWeights alloc] init];
    
    defaultWeights.lengthWeight = WEIGHT_LEN;
    defaultWeights.maxXWeight = WEIGHT_MAX_X;
    defaultWeights.maxYWeight = WEIGHT_MAX_Y;
    defaultWeights.maxZWeight = WEIGHT_MAX_Z;
    defaultWeights.meanXWeight = WEIGHT_MEAN_X;
    defaultWeights.meanYWeight = WEIGHT_MEAN_Y;
    defaultWeights.meanZWeight = WEIGHT_MEAN_Z;
    defaultWeights.medianXWeight = WEIGHT_MEDIAN_X;
    defaultWeights.medianYWeight = WEIGHT_MEDIAN_Y;
    defaultWeights.medianZWeight = WEIGHT_MEDIAN_Z;
    defaultWeights.powerWeight = WEIGHT_POWER;
    defaultWeights.speedWeight = WEIGHT_SPEED;
    defaultWeights.spatialExtendWeight = WEIGHT_SPAEXT;
    
    return defaultWeights;
}

- (id)init
{
    self = [super init];
    if (self) {
        _lengthWeight = 1;
        _maxXWeight = 1;
        _maxYWeight = 1;
        _maxZWeight = 1;
        _meanXWeight = 1;
        _meanYWeight = 1;
        _meanZWeight = 1;
        _medianXWeight = 1;
        _medianYWeight = 1;
        _medianZWeight = 1;
        _powerWeight = 1;
        _spatialExtendWeight = 1;
        _speedWeight = 1;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _lengthWeight = [aDecoder decodeDoubleForKey:kLengthWeightKey];
        _maxXWeight = [aDecoder decodeDoubleForKey:kMaxXWeightKey];
        _maxYWeight = [aDecoder decodeDoubleForKey:kMaxYWeightKey];
        _maxZWeight = [aDecoder decodeDoubleForKey:kMaxZWeightKey];
        _meanXWeight = [aDecoder decodeDoubleForKey:kMeanXWeightKey];
        _meanYWeight = [aDecoder decodeDoubleForKey:kMeanYWeightKey];
        _meanZWeight = [aDecoder decodeDoubleForKey:kMeanZWeightKey];
        _medianXWeight = [aDecoder decodeDoubleForKey:kMedianXWeightKey];
        _medianYWeight = [aDecoder decodeDoubleForKey:kMedianYWeightKey];
        _medianZWeight = [aDecoder decodeDoubleForKey:kMedianZWeightKey];
        _powerWeight = [aDecoder decodeDoubleForKey:kPowerKey];
        _spatialExtendWeight = [aDecoder decodeDoubleForKey:kSpatExtKey];
        _speedWeight = [aDecoder decodeDoubleForKey:kSpeedKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:_lengthWeight forKey:kLengthWeightKey];
    [aCoder encodeDouble:_maxXWeight forKey:kMaxXWeightKey];
    [aCoder encodeDouble:_maxYWeight forKey:kMaxYWeightKey];
    [aCoder encodeDouble:_maxZWeight forKey:kMaxZWeightKey];
    [aCoder encodeDouble:_meanXWeight forKey:kMeanXWeightKey];
    [aCoder encodeDouble:_meanYWeight forKey:kMeanYWeightKey];
    [aCoder encodeDouble:_meanZWeight forKey:kMeanZWeightKey];
    [aCoder encodeDouble:_medianXWeight forKey:kMedianXWeightKey];
    [aCoder encodeDouble:_medianYWeight forKey:kMedianYWeightKey];
    [aCoder encodeDouble:_medianZWeight forKey:kMedianZWeightKey];
    [aCoder encodeDouble:_powerWeight forKey:kPowerKey];
    [aCoder encodeDouble:_spatialExtendWeight forKey:kSpatExtKey];
     [aCoder encodeDouble:_speedWeight forKey:kSpeedKey];
}

@end

#pragma mark - GRGesture implementation

@implementation GRGesture
@synthesize length = _length;
@synthesize record = _record;
@synthesize maxX = _maxX;
@synthesize maxY = _maxY;
@synthesize maxZ = _maxZ;
@synthesize meanX = _meanX;
@synthesize meanY = _meanY;
@synthesize meanZ = _meanZ;
@synthesize medianX = _medianX;
@synthesize medianY = _medianY;
@synthesize medianZ = _medianZ;
@synthesize power = _power;
@synthesize spatialExtend = _spatialExtend;
@synthesize speed = _speed;
@synthesize gestureWeights = _gestureWeights;

-(id)initWithRecord:(GRRecord*)record{

    if (self = [super init]) {
        _maxX = 0;
        _maxY = 0;
        _maxZ = 0;
        _meanX = 0;
        _meanY = 0;
        _meanZ = 0;
        _medianX = 0;
        _medianY = 0;
        _medianZ = 0;
        _power = 0;
        _speed = 0;
        _spatialExtend = 0;
        _gestureWeights = [GRGestureWeights defaultWeights];
        _record = [record copy];
        if (_record) {
            [self calcPropertiesWith:_record];
        }        
        
    }
    return self;
}

#pragma mark - NSCoder methods

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _record = (GRRecord*)[aDecoder decodeObjectForKey:@"recordData"];
        _gestureWeights = (GRGestureWeights*) [aDecoder decodeObjectForKey:@"gestureWeights"];
        [self calcPropertiesWith:_record];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.record forKey:@"recordData"];
    [aCoder encodeObject:self.gestureWeights forKey:@"gestureWeights"];
}

-(double) distanceTo:(GRGesture*) gesture{

    // calc weighted euclidean distance
    double dist = sqrt(pow(self.length - gesture.length,2.0f) * _gestureWeights.lengthWeight +
                       pow(self.maxX - gesture.maxX,2.0f) * _gestureWeights.maxXWeight + 
                       pow(self.maxY - gesture.maxY,2.0f) * _gestureWeights.maxYWeight +
                       pow(self.maxZ - gesture.maxZ,2.0f) * _gestureWeights.maxZWeight +
                       pow(self.meanX - gesture.meanX,2.0f) * _gestureWeights.meanXWeight +
                       pow(self.meanY - gesture.meanY,2.0f) * _gestureWeights.meanYWeight +
                       pow(self.meanZ - gesture.meanZ,2.0f) * _gestureWeights.meanZWeight +
                       pow(self.medianX - gesture.medianX,2.0f) * _gestureWeights.medianXWeight +
                       pow(self.medianY - gesture.medianY,2.0f) * _gestureWeights.medianYWeight +
                       pow(self.medianZ - gesture.medianZ,2.0f) * _gestureWeights.medianZWeight +
                       pow(self.power - gesture.power,2.0f) * _gestureWeights.powerWeight +
                       pow(self.speed - gesture.speed,2.0f) * _gestureWeights.speedWeight +
                       pow(self.spatialExtend - gesture.spatialExtend,2.0f) * _gestureWeights.spatialExtendWeight);
    // evtl noch die vektoren (record) einfließen lassen
    //Log("distance: %f",dist);
    return dist;
}

-(double) gestureNorm{
    
    // calc weightend euclidean norm
    return sqrt(pow(self.length,2.0f) * _gestureWeights.lengthWeight + 
                pow(self.maxX,2.0f) * _gestureWeights.maxXWeight + 
                pow(self.maxY,2.0f) * _gestureWeights.maxYWeight +
                pow(self.maxZ,2.0f) * _gestureWeights.maxZWeight +
                pow(self.meanX,2.0f) * _gestureWeights.meanXWeight +
                pow(self.meanY,2.0f) * _gestureWeights.meanYWeight +
                pow(self.meanZ,2.0f) * _gestureWeights.meanZWeight +
                pow(self.medianX,2.0f) * _gestureWeights.medianXWeight +
                pow(self.medianY,2.0f) * _gestureWeights.medianYWeight +
                pow(self.medianZ,2.0f) * _gestureWeights.medianZWeight +
                pow(self.power,2.0f) * _gestureWeights.powerWeight +
                pow(self.speed,2.0f) * _gestureWeights.speedWeight +
                pow(self.spatialExtend,2.0f) * _gestureWeights.spatialExtendWeight);
   // evtl noch die vektoren (record) einfließen lassen
    
}

#pragma mark - private methods

-(void)calcPropertiesWith:(GRRecord*)record{
    
    _length = [record count];
    
    double s = 0;
    double l = 0;
    
    // calc max and mean
    for (GRMotionVector* vector in record) {
        double x = vector.x;
        double y = vector.y;
        double z = vector.z;
        
        // max
        if (_maxX < abs(x)) {
            _maxX = x;
        }
        if (_maxY < abs(y)) {
            _maxY = y;
        }
        if (_maxZ < abs(z)) {
            _maxZ = z;
        }
        
        // mean (average)
        _meanX += x;
        _meanY += y;
        _meanZ += z;
        
        // variables to calc power, spatialExtent and Speed
        // see /Users/Andreas/Library/Containers/com.apple.Preview/Data/Downloads/wave_like_an_egyptian_final.pdf
        s += pow(x, 2.0f) + pow(y, 2.0f) + pow(z, 2.0f);
        l += fabs(x) + fabs(y) + fabs(z);
    }
    
    // mean
    _meanX /= (double)_length;
    _meanY /= (double)_length;
    _meanZ /= (double)_length;
    
    _power = s/(double)_length;
    _spatialExtend = s/l;
    _speed = s*l/pow((double)_length,2);
    
    //median
    _medianX = [self medianOfRecord:record ForVectorPosition:kVectorPositionX];
    _medianY = [self medianOfRecord:record ForVectorPosition:kVectorPositionY];
    _medianZ = [self medianOfRecord:record ForVectorPosition:kVectorPositionZ];
    
}

-(double) medianOfRecord:(GRRecord*)record ForVectorPosition:(NSUInteger) pos{
    
    NSArray* sortRec = [record sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        double v1 = 0;
        double v2 = 0;
        
        switch (pos) {
            case kVectorPositionX:
                v1 = ((GRMotionVector*)obj1).x;
                v2 = ((GRMotionVector*)obj2).x;
                break;
            case kVectorPositionY:
                v1 = ((GRMotionVector*)obj1).y;
                v2 = ((GRMotionVector*)obj2).y;
                break;
            case kVectorPositionZ:
                v1 = ((GRMotionVector*)obj1).z;
                v2 = ((GRMotionVector*)obj2).z;
                break;
            default:
                break;
        }
        
        if (v1 < v2) {
            return NSOrderedAscending;
        }else if (v2 < v1){
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
        
    }];
    
    NSUInteger len = [sortRec count];
    double mid1 = 0;
    double mid2 = 0;
    
    if (!(len % 2)) {
        // use the mean of the two center elements
        NSUInteger mid1Idx = (len / 2);
        NSUInteger mid2Idx = ++mid1Idx;
        
        switch (pos) {
            case kVectorPositionX:
                mid1 = ((GRMotionVector*)[sortRec objectAtIndex:mid1Idx]).x;
                mid2 = ((GRMotionVector*)[sortRec objectAtIndex:mid2Idx]).x;
                break;
            case kVectorPositionY:
                mid1 = ((GRMotionVector*)[sortRec objectAtIndex:mid1Idx]).y;
                mid2 = ((GRMotionVector*)[sortRec objectAtIndex:mid2Idx]).y;
                break;
            case kVectorPositionZ:
                mid1 = ((GRMotionVector*)[sortRec objectAtIndex:mid1Idx]).z;
                mid2 = ((GRMotionVector*)[sortRec objectAtIndex:mid2Idx]).z;
                break;
        }
        
        return (mid1 + mid2)/2.0f;
        
    }else {
        NSUInteger recPos = (len/2);
        
        switch (pos) {
            case kVectorPositionX:
                mid1 = ((GRMotionVector*)[sortRec objectAtIndex:recPos]).x;
                break;
            case kVectorPositionY:
                mid1 = ((GRMotionVector*)[sortRec objectAtIndex:recPos]).y;
                break;
            case kVectorPositionZ:
                mid1 = ((GRMotionVector*)[sortRec objectAtIndex:recPos]).z;
                break;
        }
        return mid1;
    }
}

-(NSString*) description{
    NSMutableString* strGesture = [[NSMutableString alloc] init];
    [strGesture appendFormat:@"max(x=%f,y=%f,z=%f)", self.maxX, self.maxY, self.maxZ];
    [strGesture appendFormat:@", mean(x=%f,y=%f,z=%f)", self.meanX, self.meanY, self.meanZ];
    [strGesture appendFormat:@", median(x=%f,y=%f,z=%f)", self.medianX, self.medianY, self.medianZ];
    [strGesture appendFormat:@", power=%f, speed=%f, spatial extent=%f", self.power, self.speed, self.spatialExtend];
    [strGesture appendFormat:@"length=%d", self.length];
    //[strGesture appendFormat:@", data=%@ ", self.record];
    
    return strGesture;
}

@end
