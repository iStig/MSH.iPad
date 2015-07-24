//
//  IKUnlimitDatePickerController.m
//  InsuranceKit
//
//  Created by iStig on 14/11/3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKUnlimitDatePickerController.h"

@interface IKUnlimitDatePickerController ()
@end
@implementation IKUnlimitDatePickerController
@synthesize datePicker;


- (id)init{
    self = [super init];
    if (self){
        //  self.contentSizeForViewInPopover = CGSizeMake(320, 216);
        NSDate * date = [[NSDate alloc] initWithTimeInterval:(-14*24*60*60) sinceDate:[NSDate date]];
        self.preferredContentSize = CGSizeMake(320, 216);
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        
        if ([InternationalControl isEnglish])
            [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_SC"]];
        else
            [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
//        datePicker.minimumDate = date;
//        datePicker.maximumDate = [NSDate date];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
