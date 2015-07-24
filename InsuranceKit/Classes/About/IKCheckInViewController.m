//
//  IKCheckInViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKCheckInViewController.h"

@interface IKCheckInViewController ()

@end

@implementation IKCheckInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kPotentialclient")];
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];
    

    UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(29, 60, 80, 17) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.42 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"kClient");
    [self.view addSubview:lbl];
    tfName = [[UITextField alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+5, lbl.frame.origin.y-15, 265, 47)];
    tfName.backgroundColor = [UIColor clearColor];
    tfName.font = lbl.font;
    tfName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfName];
    
    lbl = [UILabel createLabelWithFrame:CGRectMake(29, 174, 80, 17) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.42 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"kEmail");
    [self.view addSubview:lbl];
    tfEmail = [[UITextField alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+5, lbl.frame.origin.y-15, 265, 47)];
    tfEmail.backgroundColor = [UIColor clearColor];
    tfEmail.font = lbl.font;
    tfEmail.keyboardType = UIKeyboardTypeEmailAddress;
    tfEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfEmail];
    
    lbl = [UILabel createLabelWithFrame:CGRectMake(29, 117, 80, 17) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.42 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"kTelephone");
    [self.view addSubview:lbl];
    CGRect frame = lbl.frame;
    [lbl sizeToFit];
    frame.size.width = lbl.frame.size.width;
    lbl.frame = frame;
    tfPhone = [[UITextField alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+5, lbl.frame.origin.y-15, 265, 47)];
    tfPhone.backgroundColor = [UIColor clearColor];
    tfPhone.font = lbl.font;
    tfPhone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfPhone];
    
    
    for (int i=0;i<3;i++){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 95+57*i, 322, 1)];
        line.backgroundColor = [UIColor colorWithWhite:.82 alpha:1];
        [self.view addSubview:line];
    }

    
    btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.clipsToBounds = YES;
    btnSubmit.layer.cornerRadius = 2;
    btnSubmit.frame = CGRectMake(0, 0, 150, 40);
    btnSubmit.layer.borderColor = [UIColor colorWithRed:.95 green:.18 blue:.04 alpha:1].CGColor;
    btnSubmit.layer.borderWidth = 1;
    [btnSubmit setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.95 green:.35 blue:.31 alpha:1] size:btnSubmit.frame.size] forState:UIControlStateNormal];
    [btnSubmit setTitle:LocalizeStringFromKey(@"kApply") forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnSubmit addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
}

- (void)viewWillLayoutSubviews{
    btnSubmit.center = CGPointMake(self.view.frame.size.width/2, 312);
}

- (void)submitClicked{
//    if (tfEmail.text.length>0 && tfName.text.length>0 && tfPhone.text.length>0)
    if (tfName.text.length>0 && tfPhone.text.length>0){
        [UIAlertView showAlertWithTitle:nil message:@"提交成功" cancelButton:nil];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:tfName.text,@"custom",tfPhone.text,@"telNo",tfEmail.text,@"email", nil];
        
        [NSThread detachNewThreadSelector:@selector(submitInfo:) toTarget:self withObject:info];
        
        tfName.text = nil;
        tfPhone.text = nil;
        tfEmail.text = nil;
        
    }else{
        [UIAlertView showAlertWithTitle:nil message:@"请填写好每一项再提交" cancelButton:nil];
    }
    
    
}

- (void)submitInfo:(NSDictionary *)contactInfo{
    @autoreleasepool {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:contactInfo];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [param setObject:[formatter stringFromDate:[NSDate date]] forKey:@"createTime"];
        
        [param setObject:[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"] forKey:@"providerID"];
        NSString *providerNameCNH = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerNameCNH"];
        if (!providerNameCNH)
            providerNameCNH = @"上海医院";
        if (providerNameCNH)
            [param setObject:providerNameCNH forKey:@"providerNameCNH"];
        
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:@[param],@"data",@"1",@"count", nil];
        NSLog(@"Param:%@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:info options:0 error:nil] encoding:NSUTF8StringEncoding]);
        NSDictionary *dict = [IKDataProvider syncClientRecord:info];
        int result = [[dict objectForKey:@"result"] intValue];
        
        if (result==0 && dict){
            
        }else{
            if (![dict objectForKey:@"data"]){
                NSMutableArray *ary = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FailLogContactInfo"]];
                [ary addObject:param];
                
                [[NSUserDefaults standardUserDefaults] setObject:ary forKey:@"FailLogContactInfo"];
            }
        }
        
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
