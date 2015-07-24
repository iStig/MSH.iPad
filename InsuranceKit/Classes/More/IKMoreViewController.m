//
//  IKMoreViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKMoreViewController.h"
#import "IKMoreListViewController.h"
#import "IKChangePasswordViewController.h"
#import "IKVersionUpdateViewController.h"
#import "IKInstitutionViewController.h"

@interface IKMoreViewController ()

@end

@implementation IKMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:1];
    
    //    IKClientsDetailViewController *vcDetail = [[IKClientsDetailViewController alloc] init];
    navRight = [[IKNavigationViewController alloc] init];
    [self.view addSubview:navRight.view];
    
    IKMoreListViewController *vcMoreList = [[IKMoreListViewController alloc] init];
    vcMoreList.delegate = self;
    vcMoreList.shouldShowNavigationBar = YES;
    navLeft = [[IKNavigationViewController alloc] initWithRootViewController:vcMoreList];
    [self.view addSubview:navLeft.view];
    

    
    [self didSelectLeftItemAtIndex:0];
}

- (void)viewWillLayoutSubviews{
    navLeft.view.frame = CGRectMake(0, 0, 285, 768-20);
    navRight.view.frame = CGRectMake(285, 0, self.view.frame.size.width-285, 768-20);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IKViewController Delegate
- (void)didSelectLeftItemAtIndex:(NSInteger)index{
    switch (index) {
//        case 0:{
//            IKInstitutionViewController *vcInstitution = [[IKInstitutionViewController alloc] init];
////            vcInstitution.shouldShowNavigationBar = YES;
//            navRight.viewControllers = @[vcInstitution];
//        }
//            break;
        case 0:{
            IKChangePasswordViewController *vcChangePassword = [[IKChangePasswordViewController alloc] init];
//            vcChangePassword.shouldShowNavigationBar = YES;
            navRight.viewControllers = @[vcChangePassword];
        }
            break;
        case 1:{
            IKVersionUpdateViewController *vcVersionUpdate = [[IKVersionUpdateViewController alloc] init];
//            vcVersionUpdate.shouldShowNavigationBar = YES;
            navRight.viewControllers = @[vcVersionUpdate];
        }
            break;
        default:
            break;
    }
}

@end
