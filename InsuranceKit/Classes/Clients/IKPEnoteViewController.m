//
//  IKPEnoteViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-9-28.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKPEnoteViewController.h"

@interface IKPEnoteViewController ()

@end

@implementation IKPEnoteViewController
@synthesize penoteLab;

- (id)init{
    self = [super init];
    if (self){

       self.preferredContentSize = CGSizeMake(415, 130);
//       penoteLab = [UILabel createLabelWithFrame:CGRectMake(20, 10, 375, 130) font:[UIFont systemFontOfSize:17] textColor:[UIColor redColor]];
//       penoteLab.numberOfLines = 0;
        penoteLab = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, 375, 130)];
        [penoteLab setBackgroundColor:[UIColor clearColor]];
        [penoteLab setFont:[UIFont systemFontOfSize:17.0]];
        [penoteLab setTextColor:[UIColor redColor]];
        
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   [self.view addSubview:penoteLab];
    
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
