//
//  IKPaymentInfoViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKPaymentInfoViewController.h"

@interface IKPaymentInfoViewController ()

@end

@implementation IKPaymentInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:@"支付流程"];
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];
    
    UIImage *image = [[InternationalControl userLanguage] isEqualToString:@"zh-Hans"]?[UIImage imageNamed:@"IKViewPaymentProcess.png"]:[UIImage imageNamed:@"IKViewPaymentProcessEn.png"];
    
    
    imgvContent = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imgvContent];
}

- (void)viewWillLayoutSubviews{
    imgvContent.center = CGPointMake(self.view.frame.size.width/2, 44+imgvContent.frame.size.height/2);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
