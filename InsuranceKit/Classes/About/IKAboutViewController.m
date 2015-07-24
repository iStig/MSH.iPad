//
//  IKAboutViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKAboutViewController.h"
#import "IKContactViewController.h"
#import "IKNewsViewController.h"
#import "IKCheckInViewController.h"
#import "IKSummaryViewController.h"
#import "IKPaymentInfoViewController.h"
#import "IKCompanyInfoViewController.h"
#import "IKAppDelegate.h"
#import "IKCustomerViewController.h"
#import "IKHospitalViewController.h"

@interface IKAboutViewController ()

@end

@implementation IKAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:.3 alpha:1];
    
    //    IKClientsDetailViewController *vcDetail = [[IKClientsDetailViewController alloc] init];
    navRight = [[IKNavigationViewController alloc] init];
    [self.view addSubview:navRight.view];
    
    IKAboutListViewController *vcList = [[IKAboutListViewController alloc] init];
    vcList.delegate = self;
    vcList.shouldShowNavigationBar = YES;
    navLeft = [[IKNavigationViewController alloc] initWithRootViewController:vcList];
    [self.view addSubview:navLeft.view];
    

    
    [self didSelectLeftItemAtIndex:0];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyAuthorization:) name:@"ApplyAuthorization" object:nil];
}

- (void)applyAuthorization:(NSNotification *)notice{

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
        case 0:{
            IKContactViewController *vcContact = [[IKContactViewController alloc] init];
            vcContact.shouldShowNavigationBar = NO;
            navRight.viewControllers = @[vcContact];
        }
            break;
        case 1:{
            IKPaymentInfoViewController *vcPaymentInfo = [[IKPaymentInfoViewController alloc] init];
            vcPaymentInfo.shouldShowNavigationBar = NO;
            navRight.viewControllers = @[vcPaymentInfo];
        }
            break;
        case 2:{
            /*
            IKCompanyInfoViewController *vcCompanyInfo = [[IKCompanyInfoViewController alloc] init];
            vcCompanyInfo.shouldShowNavigationBar = YES;
            navRight.viewControllers = @[vcCompanyInfo];
             */
            UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
            UIViewController *vc = w.rootViewController;
            NSMutableArray *ary = [NSMutableArray array];
            for (int i=0;i<4;i++)
                [ary addObject:[NSString stringWithFormat:@"cover%d.png",i+1]];
            BSTCoverView *vCover = [[BSTCoverView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) info:@{@"images":ary}];
            vCover.delegate = self;
            [vc.view addSubview:vCover];
            
        }
            break;
        case 3:{
            IKNewsViewController *vcNews = [[IKNewsViewController alloc] init];
            vcNews.shouldShowNavigationBar = NO;
            navRight.viewControllers = @[vcNews];
        }
            break;
        case 4:{
            IKCheckInViewController *vcCheckIn = [[IKCheckInViewController alloc] init];
            vcCheckIn.shouldShowNavigationBar = NO;
            navRight.viewControllers = @[vcCheckIn];
        }
            break;
        case 5:{
            IKSummaryViewController *vcSummary = [[IKSummaryViewController alloc] init];
            vcSummary.shouldShowNavigationBar = NO;
            navRight.viewControllers = @[vcSummary];
        }
            break;
            
        case 6:{
            IKHospitalViewController *vcHospital = [[IKHospitalViewController alloc] init];
            vcHospital.shouldShowNavigationBar = NO;
            navRight.viewControllers = @[vcHospital];
        }
            break;
        case 7:{
            IKCustomerViewController *vcCustomer = [[IKCustomerViewController alloc] init];
            vcCustomer.shouldShowNavigationBar = NO;
            navRight.viewControllers = @[vcCustomer];
        }
            break;
        default:
            break;
    }
}

#pragma mark - BSTCoverView Delegate
- (void)animateEnded:(id)view{
    [self didSelectLeftItemAtIndex:0];
    
    [view removeFromSuperview];
    view = nil;
}

@end
