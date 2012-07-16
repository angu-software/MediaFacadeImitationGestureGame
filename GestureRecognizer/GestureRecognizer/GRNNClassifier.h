//
//  GRNNClassifier.h
//  GestureRecognizer
//
//  Created by Andreas on 14.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRDataStorage.h"
#import "GRGesture.h"

@interface GRNNClassifier : NSObject

@property GRDataStorage* referenceDataStorage;

//-(NSString*) bestClassMatchFor:(GRRecord*)record;

-(NSString*) bestClassMatchFor:(GRGesture*)gesture;

@end
