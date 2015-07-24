//
//  IKContactViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKContactViewController.h"

@interface IKContactViewController ()

@end

@implementation IKContactViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kContactinformation")];
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];
    
    imgvContent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKViewContact.png"]];
    [self.view addSubview:imgvContent];
    
    float x = 200;
    float y = 318;
    float w = 480;
    float delta = 30;
    float h = 18;
    float fontSize = 18;
    
    int i = 0;
    
    UIColor *color = [UIColor colorWithWhite:.25 alpha:1];
    
    lblName = [UILabel createLabelWithFrame:CGRectMake(x, y+delta*i++, w, h) font:[UIFont systemFontOfSize:fontSize] textColor:color];
    lblCellPhone = [UILabel createLabelWithFrame:CGRectMake(x, y+delta*i++, w, h) font:[UIFont systemFontOfSize:fontSize] textColor:color];
    lblMail = [UILabel createLabelWithFrame:CGRectMake(x, y+delta*i++, w, h) font:[UIFont systemFontOfSize:fontSize] textColor:color];
    lblTelephone = [UILabel createLabelWithFrame:CGRectMake(x, y+delta*i++, w, h) font:[UIFont systemFontOfSize:fontSize] textColor:color];
    lblSite = [UILabel createLabelWithFrame:CGRectMake(x, y+delta*i++, w, h) font:[UIFont systemFontOfSize:fontSize] textColor:color];
    vLine = [[UIView alloc] init];
    vLine.backgroundColor = [UIColor blueColor];
    [self.view addSubview:vLine];
    
    [self.view addSubview:lblName];
    [self.view addSubview:lblCellPhone];
    [self.view addSubview:lblMail];
    [self.view addSubview:lblTelephone];
    [self.view addSubview:lblSite];
    
    UIButton *btnSite = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSite.frame = CGRectMake(lblSite.frame.origin.x, lblSite.frame.origin.y-15, lblSite.frame.size.width, lblSite.frame.size.height+15*2);
    [btnSite addTarget:self action:@selector(siteClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSite];
    
    [self showInfo];
    
    NSLog(@"Hospital Info:%@",[IKDataProvider currentHospitalInfo]);
    
    [NSThread detachNewThreadSelector:@selector(refreshHospitalInfo) toTarget:self withObject:nil];
}

- (void)refreshHospitalInfo{
    @autoreleasepool {
        NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
        NSDictionary *dict = [IKDataProvider getProviderInfo:[NSDictionary dictionaryWithObjectsAndKeys:providerID,@"providerID",nil]];
        sw_dispatch_sync_on_main_thread(^{
            if ([dict objectForKey:@"data"]){
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]];
                [info setObject:providerID forKey:@"providerID"];
                [IKDataProvider saveHospitalInfo:info];
                [self showInfo];
            }
        });
        
    }
}

- (void)showInfo{
    NSDictionary *hospitalInfo = [IKDataProvider currentHospitalInfo];
    lblName.text = [NSString stringWithFormat:@"%@：%@",LocalizeStringFromKey(@"kContact"),[hospitalInfo objectForKey:@"CSNameCHN"]];
    lblCellPhone.text = [NSString stringWithFormat:@"%@：%@",LocalizeStringFromKey(@"kTelephone"),[hospitalInfo objectForKey:@"TelNo"]];
    lblMail.text = [NSString stringWithFormat:@"%@：%@",LocalizeStringFromKey(@"kEmail"),[hospitalInfo objectForKey:@"Email"]];
    lblTelephone.text = [NSString stringWithFormat:@"%@：%@",LocalizeStringFromKey(@"kMSHCHINAHotline"),[hospitalInfo objectForKey:@"mshTelNo"]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：",LocalizeStringFromKey(@"kWeb")] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil]]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[hospitalInfo objectForKey:@"webSite"] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName,[UIColor blueColor],NSForegroundColorAttributeName, nil]]];
    lblSite.attributedText = attr;
    CGSize size = [[NSString stringWithFormat:@"%@：%@",LocalizeStringFromKey(@"kWeb"),[hospitalInfo objectForKey:@"webSite"]] sizeWithFont:lblSite.font];
    vLine.frame = CGRectMake(lblSite.frame.origin.x+53, lblSite.frame.origin.y+lblSite.frame.size.height+2, size.width-53, 1);
}

- (void)siteClicked{
    NSDictionary *hospitalInfo = [IKDataProvider currentHospitalInfo];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://" stringByAppendingString:[hospitalInfo objectForKey:@"webSite"]]]];
}

- (void)viewWillLayoutSubviews{
    imgvContent.center = CGPointMake(self.view.frame.size.width/2, 180+44+imgvContent.frame.size.height/2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
