//
//  IKVersionUpdateViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKVersionUpdateViewController.h"

@interface IKVersionUpdateViewController ()

@end

@implementation IKVersionUpdateViewController
@synthesize dicInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"k_Upgrade")];
    [self addBGColor:nil];
    
    
    float w = [InternationalControl isEnglish]?180:120;
    
    UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(30, 24+44, w, 25) font:[UIFont boldSystemFontOfSize:24] textColor:[UIColor colorWithRed:.99 green:.59 blue:.48 alpha:1]];
    lbl.textAlignment = NSTextAlignmentRight;
    lbl.text = LocalizeStringFromKey(@"k_Thenewestversion");
    [self.view addSubview:lbl];
    
    lblVersion = [UILabel createLabelWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+15, 24+44, 300, 25) font:[UIFont systemFontOfSize:24] textColor:[UIColor blackColor]];
    lblVersion.text = @"MSH 1.0";
    [self.view addSubview:lblVersion];
    lblVersion.center = CGPointMake(lblVersion.center.x, lbl.center.y);
    
    lbl = [UILabel createLabelWithFrame:CGRectMake(30, lblVersion.frame.origin.y+lblVersion.frame.size.height+10, w, 25) font:[UIFont systemFontOfSize:24] textColor:[UIColor grayColor]];
    lbl.text = LocalizeStringFromKey(@"k_Thecurrentversion");
    lbl.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lbl];
    
    lblCurrentVersion = [UILabel createLabelWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+15, lbl.frame.origin.y, 300, 25) font:[UIFont systemFontOfSize:24] textColor:[UIColor grayColor]];
    lblCurrentVersion.text = [NSString stringWithFormat:@"MSH %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];
    [self.view addSubview:lblCurrentVersion];
    lblCurrentVersion.center = CGPointMake(lblCurrentVersion.center.x, lbl.center.y);
    
    lblSize = [UILabel createLabelWithFrame:CGRectMake(115, 48+44, 300, 24) font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
    lblSize.text = @"56.8MB";
//    [self.view addSubview:lblSize];
    
    lblContent = [UILabel createLabelWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+5, 78+44, 300, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
    lblContent.text = @"本更新包含了数项改进及错误修正。";
//    [self.view addSubview:lblContent];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(40, lblVersion.frame.origin.y+lblVersion.frame.size.height+5, 1024, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.75 alpha:1];
    [self.view addSubview:line];
    
    btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnUpdate.clipsToBounds = YES;
    btnUpdate.layer.cornerRadius = 2;
    btnUpdate.frame = CGRectMake(0, 0, [InternationalControl isEnglish]?200:150, 40);
    btnUpdate.layer.borderColor = [UIColor colorWithRed:.95 green:.18 blue:.04 alpha:1].CGColor;
    btnUpdate.layer.borderWidth = 1;
    [btnUpdate setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.95 green:.35 blue:.31 alpha:1] size:btnUpdate.frame.size] forState:UIControlStateNormal];
    [btnUpdate setTitle:LocalizeStringFromKey(@"k_DownloadandSetup") forState:UIControlStateNormal];
    [btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnUpdate.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:btnUpdate];
    [btnUpdate addTarget:self action:@selector(updateClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [SVProgressHUD showWithStatus:@"正在获取版本信息"];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)loadData{
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider getVersionInfo:nil];
        NSLog(@"Version Info:%@",dict);
        sw_dispatch_sync_on_main_thread(^{
            if ([dict objectForKey:@"data"]){
                [SVProgressHUD dismiss];
                dicInfo = [dict objectForKey:@"data"];
                
                lblVersion.text = [NSString stringWithFormat:@"MSH %@",[dicInfo objectForKey:@"number"]];
                lblContent.text = [dicInfo objectForKey:@"introduce"];
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"版本信息更新失败"];
            }
        });
        
    }
}

- (void)updateClicked{
    NSString *link = [dicInfo objectForKey:@"link"];
    if (link){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    }
}

- (void)viewWillLayoutSubviews{
    btnUpdate.center = CGPointMake(self.view.frame.size.width/2, 240+44);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
