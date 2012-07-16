//
//  GRViewController.h
//  GestureRecognizer
//
//  Created by Andreas on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRMainController.h"

@interface GRViewController : UIViewController{

    IBOutlet UIView *_pressView;
}

@property (strong, nonatomic) IBOutlet UILabel *storageInfoLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@property id<GRViewControllerDelegate> delegate;

- (IBAction)longPressAction:(id)sender;

@end
