//
//  IGGShape.h
//  IGGRemoteScreen
//
//  Created by Andreas on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// shape label definitions

typedef enum {
    IGGSquare = 0,
    IGGCircle = 1,
    IGGTriangle = 2,
    IGGHouse = 3,
}IGGShapeType;

@interface IGGShape : NSObject

@property CGSize minSize;
@property CGSize maxSize;
@property IGGShapeType type;

+(IGGShape*) randomShape;

@end
