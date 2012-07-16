//
//  GTViewController.m
//  GestureTraining
//
//  Created by Andreas on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GTViewController.h"

@interface GTViewController ()

@end

@implementation GTViewController
@synthesize pickerLabels;
@synthesize selectedLabel;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [labelPicker setDelegate:self];
    [labelPicker setDataSource:self];
}

- (void)viewDidUnload
{
    labelPicker = nil;
    pressView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) increaseCountForLabel:(NSString*) label{
    
    NSUInteger labelIndex = [pickerLabels indexOfObjectIdenticalTo:label];
    NSNumber* intVal = [pickerLabelRecordCounts objectAtIndex:labelIndex];
    [pickerLabelRecordCounts replaceObjectAtIndex:labelIndex withObject:[NSNumber numberWithInt:([intVal intValue])+1]];
    [labelPicker reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[self.pickerLabels objectAtIndex:row] stringByAppendingFormat:@" (%d)", [[pickerLabelRecordCounts objectAtIndex:row] intValue]];
}

#pragma mark - UIPickerViewDataSource methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerLabels ? self.pickerLabels.count : 0;
}

- (void)setPickerLabels:(NSArray *)labels{

    pickerLabels = labels;
    pickerLabelRecordCounts = [[NSMutableArray alloc] initWithCapacity:[labels count]];
    for (NSUInteger i = 0; i < [labels count]; i++) {
        [pickerLabelRecordCounts addObject:[NSNumber numberWithInt:0]];
    }
    [labelPicker reloadAllComponents];
}

#pragma mark - outlet action methods

- (IBAction)longPressAction:(id)sender {
    
    UILongPressGestureRecognizer* pressReco = (UILongPressGestureRecognizer*)sender;
    switch (pressReco.state) {
        case UIGestureRecognizerStateBegan:
            selectedLabel = [pickerLabels objectAtIndex:[labelPicker selectedRowInComponent:0]];
            
            if (self.delegate) {
                pressView.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.25f];
                [delegate recordingStartRequestet:self];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.delegate) {
                pressView.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f];
                [delegate recordingStopRequestet:self];
            }
            break;
        default:
            break;
    }
}

@end
