//
//  GTViewController.h
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMainController.h"
#import "GRViewControllerDelegate.h"

@interface GTViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

    IBOutlet UIPickerView *labelPicker;
    IBOutlet UIView *pressView;
    BOOL isRecording;
    NSMutableArray* pickerLabelRecordCounts;
}

@property (nonatomic, strong) NSArray* pickerLabels;
@property id<GRViewControllerDelegate> delegate;
@property (readonly, strong) NSString* selectedLabel;

- (IBAction)longPressAction:(id)sender;
-(void) increaseCountForLabel:(NSString*) label;

@end
