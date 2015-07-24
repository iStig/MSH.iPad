//
//  IKMinitePickerViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-9-25.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKMinitePickerViewController.h"

@interface IKMinitePickerViewController ()

@end

@implementation IKMinitePickerViewController
@synthesize datePicker;

- (id)init{
    self = [super init];
    if (self){
        //  self.contentSizeForViewInPopover = CGSizeMake(320, 216);
        self.preferredContentSize = CGSizeMake(320, 216);
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        datePicker.maximumDate = [NSDate date];
               // [datePicker setDate:[NSDate date] animated:YES];
        datePicker.datePickerMode = UIDatePickerModeCountDownTimer;

        
  
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
         [self.view addSubview:datePicker];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
