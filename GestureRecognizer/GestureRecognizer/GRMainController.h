//
//  GRMainController.h
//  GestureRecognizer
//
//  Created by Andreas on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRMainControllerBase.h"
#import "GRDataStorage.h"
#import "GRViewController.h"
#import "GRFilterChain.h"
#import "GRNNClassifier.h"
#import "GRNetworkClientController.h"

@interface GRMainController : GRMainControllerBase {
    NSMutableArray * _liveData;
    GRFilterChain* _filterChain;
    GRNNClassifier* _nnClassifier;
    GRDataStorage* _referenceModel;
    GRNetworkClientController* _networkController;
}

@property (readonly) GRDataStorage* trainingData;
@property NSString* gameHost;
@property NSInteger hostPort;

@end
