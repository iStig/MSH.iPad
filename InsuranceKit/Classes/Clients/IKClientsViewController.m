//
//  IKClientsViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-9.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKClientsViewController.h"
#import "IKApplyAuthViewController.h"
#import "IKAppDelegate.h"
#import "IKApplyClaimsViewController.h"
@implementation IKClientsViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];
    

    
    vcList = [[IKClientsListViewController alloc] init];
    vcList.delegate = self;
    [self.view addSubview:vcList.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyAuthorization:) name:@"ApplyAuthorization" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplyClaims:) name:@"ApplyClaims" object:nil];
    
   
}

- (void)ApplyClaims:(NSNotification *)notice{
    IKVisitCDSO *v = [[notice userInfo] objectForKey:@"visit"];
   NSString *claimsNo = [[notice userInfo] objectForKey:@"claimsNo"];
    NSString *claimsState = [[notice userInfo] objectForKey:@"status"];
    NSString *key =[[notice userInfo] objectForKey:@"key"];
    if (v) {
        IKApplyClaimsViewController *vcApplyClaims = [[IKApplyClaimsViewController alloc] init];
        vcApplyClaims.visit = v;
        vcApplyClaims.key =key;
        [self.navigationController pushViewController:vcApplyClaims animated:NO];
    }else if(claimsNo){
    IKApplyClaimsViewController *vcApplyClaims = [[IKApplyClaimsViewController alloc] init];
    vcApplyClaims.claimsNo = claimsNo;
    //vcApplyClaims.claimStatus =claimsState;
    [self.navigationController pushViewController:vcApplyClaims animated:NO];
     }
}

- (void)applyAuthorization:(NSNotification *)notice{
    IKVisitCDSO *v = [[notice userInfo] objectForKey:@"visit"];
    NSString *caseId = [[notice userInfo] objectForKey:@"caseId"];
    if (v){
        IKApplyAuthViewController *vcApply = [[IKApplyAuthViewController alloc] init];
        vcApply.visit = v;
//        vcApply.shouldShowNavigationBar = YES;
        [self.navigationController pushViewController:vcApply animated:NO];
        
    }else if (caseId){
        IKApplyAuthViewController *vcApply = [[IKApplyAuthViewController alloc] init];
        vcApply.CaseId = caseId;
        //        vcApply.shouldShowNavigationBar = YES;
        [self.navigationController pushViewController:vcApply animated:NO];
    }
}

- (void)viewWillLayoutSubviews{
    vcList.view.frame = CGRectMake(0, 0, 278, 768-20);
    vcDetail.view.frame = CGRectMake(278, 0, self.view.frame.size.width-278, 768-20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IKClientsList Delegate
- (void)visitSelected:(IKVisitCDSO *)v{
    if (vcDetail && vcDetail.view.superview){//当vcdetail存在 则删除掉
        [vcDetail.view removeFromSuperview];
        vcDetail = nil;
    }
    
    IKAppDelegate *delegate =  (IKAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.visit = v;//全局当前的v
    
    vcDetail = [[IKClientsDetailViewController alloc] init];
    vcDetail.visit = v;
    [self.view addSubview:vcDetail.view];
}

@end
