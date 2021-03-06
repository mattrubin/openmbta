//
//  TimePickerViewController.m
//  OpenMBTA
//
//  Created by Daniel Choi on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimePickerViewController.h"

@implementation TimePickerViewController
@synthesize timePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    timePicker.date = [NSDate date];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (IBAction)doneButtonPressed:(id)sender {
    NSDate *selected = [timePicker date];
    NSTimeInterval intervalFromNow = fabs([selected timeIntervalSinceDate:[NSDate date]]);
    
    // If the done button is pressed and the user didn't change the time, don't shift the time
    if (intervalFromNow > (2 * 60)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseTimeChanged"
                                                            object:self
                                                          userInfo:@{@"NewBaseTime": selected}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseTimeChanged"
                                                            object:self
                                                          userInfo:nil];
    }
        
        
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetButtonPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaseTimeChanged"
                                                        object:self
                                                      userInfo:nil];    
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
