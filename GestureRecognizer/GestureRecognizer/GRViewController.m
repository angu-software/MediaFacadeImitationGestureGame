//
//  GRViewController.m
//  GestureRecognizer
//
//  Created by Andreas on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRViewController.h"

@interface GRViewController ()

@end

@implementation GRViewController

@synthesize storageInfoLabel;
@synthesize activityIndicator;
@synthesize classLabel;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setClassLabel:nil];
    _pressView = nil;
    [self setActivityIndicator:nil];
    [self setStorageInfoLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - outlet action methods

- (IBAction)longPressAction:(id)sender {
    if (activityIndicator.isAnimating) {
        return;
    }
    UILongPressGestureRecognizer* pressReco = (UILongPressGestureRecognizer*)sender;
    switch (pressReco.state) {
        case UIGestureRecognizerStateBegan:            
            if (self.delegate) {
                _pressView.backgroundColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.25f];
                [delegate recordingStartRequestet:self];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.delegate) {
                _pressView.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.25f];
                [delegate recordingStopRequestet:self];
            }
            break;
        default:
            break;
    }
}

@end
