//
//  IKSearchViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-9-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKSearchViewController.h"
#import "IKMedicalRecordsViewController.h"
#import "IKAuthorizationViewController.h"
#import "IKClaimViewController.h"
#import "IKAppDelegate.h"

@interface IKSearchViewController ()

@end

@implementation IKSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self addBGColor:[UIColor colorWithRed:248.f/250.f green:246.f/250.f blue:248.f/250.f alpha:1]];
    int x = 33 ;
    int y = 220 ;
    int width = 285;
    int height = 195;
    
    NSString *names = nil;
    NSString *language = [InternationalControl userLanguage];
    if ([language isEqualToString:@"en"])
        names = @"IKMedicalRecordButtonEn,IKAuthButtonEn,IKClaimButtonEn";
    else
        names = @"IKMedicalRecordButton,IKAuthButton,IKClaimButton";
    
    NSArray *imageName = [names componentsSeparatedByString:@","];

    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        btn.frame = CGRectMake(x, y, width, height);
        [btn addTarget:self action:@selector(searchTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:[imageName objectAtIndex:i]] forState:UIControlStateNormal];
         x +=  width + 33;
        [self.view addSubview:btn];
    }
    
   [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

//获取理赔状态
- (void)loadData{
    @autoreleasepool {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDictionary *dict = [IKDataProvider getClaimStateList:param];
        NSArray *ary = [dict objectForKey:@"data"];
        aryList = [NSMutableArray arrayWithArray:ary];
        sw_dispatch_sync_on_main_thread(^{
        });
        NSLog(@"ClaimState List:%@",dict);
    }
}



-(void)searchTypeClicked:(UIButton*)btn{

    IKsearchType searchType = btn.tag;
    
    switch (searchType) {
        case IKSearchMedicalRecords:{
            IKMedicalRecordsViewController *IKMRvc = [[IKMedicalRecordsViewController alloc] init];
            IKMRvc.shouldShowNavigationBar = YES;
            [self.navigationController pushViewController:IKMRvc animated:NO];
        }
            break;
        case IKSearchAuthorization:{
            IKAuthorizationViewController *IKAuthorizationvc = [[IKAuthorizationViewController alloc] init];
            IKAuthorizationvc.shouldShowNavigationBar = YES;
            [self.navigationController pushViewController:IKAuthorizationvc animated:NO];
        }
            break;
        case IKSearchClaim:{
           
            IKAppDelegate *delegate =    (IKAppDelegate *)[UIApplication sharedApplication].delegate;
            IKClaimViewController *IKClaimvc = [[IKClaimViewController alloc] init];
            IKClaimvc.shouldShowNavigationBar = YES;
            IKClaimvc.visit = delegate.visit;
            IKClaimvc.ClaimStateList =[NSMutableArray array];
            [IKClaimvc.ClaimStateList addObjectsFromArray:aryList];
            [self.navigationController pushViewController:IKClaimvc animated:NO];
        }
            break;
            
        default:
            break;
    }




}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
