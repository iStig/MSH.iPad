//
//  IKDatePickerViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKDatePickerViewController.h"

@interface IKDatePickerViewController ()

@end

@implementation IKDatePickerViewController
@synthesize datePicker;

- (id)init{
    self = [super init];
    if (self){
      //  self.contentSizeForViewInPopover = CGSizeMake(320, 216);
//        NSDate * date = [[NSDate alloc] initWithTimeInterval:(-14*24*60*60) sinceDate:[NSDate date]];
        self.preferredContentSize = CGSizeMake(320, 216);
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
//        datePicker.minimumDate = date;
//        datePicker.maximumDate = [NSDate date];// 限制让取消
        datePicker.datePickerMode = UIDatePickerModeDate;
      //  [datePicker setDate:[NSDate date] animated:YES];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view addSubview:datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
