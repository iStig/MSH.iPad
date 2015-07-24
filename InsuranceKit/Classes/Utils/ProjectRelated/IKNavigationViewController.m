//
//  IKNavigationViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-10.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKNavigationViewController.h"

@interface IKNavigationViewController ()

@end

@implementation IKNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.99 green:.45 blue:.25 alpha:1] size:CGSizeMake(1024, 44)] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[IKViewController class]])
        self.navigationBarHidden = !((IKViewController *)viewController).shouldShowNavigationBar;
    else{
        
    }
}
@end
