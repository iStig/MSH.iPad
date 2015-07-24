//
//  IKHospitalListViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKHospitalListViewController.h"
#import "IKDataProvider.h"

@interface IKHospitalListViewController ()

@end

@implementation IKHospitalListViewController
@synthesize aryAccountList;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    imgvContent = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKViewHospitalList.png"]];
    [self.view addSubview:imgvContent];
    
    tvList = [[UITableView alloc] initWithFrame:CGRectMake(243, 170, 682, 528)];
    tvList.delegate = self;
    tvList.dataSource = self;
    tvList.backgroundColor = [UIColor clearColor];
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tvList];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(256, 129, 64, 32);
    btn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(951, 35, 40, 40);
    btn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(closeClicked) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)closeClicked{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getProviderInfo:(NSString *)providerID{
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider getProviderInfo:[NSDictionary dictionaryWithObjectsAndKeys:providerID,@"providerID",nil]];
        
        sw_dispatch_sync_on_main_thread(^{
            if ([dict objectForKey:@"data"]){
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]];
                [info setObject:providerID forKey:@"providerID"];
                [IKDataProvider saveHospitalInfo:info];
                [SVProgressHUD dismiss];
                
                [self.delegate hospitalSelected];
                [self closeClicked];
            }else{
                [SVProgressHUD showErrorWithStatus:@"获取资料失败"];
            }
        });
        
    }
}

#pragma mark - UITableView Data Source & Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"HospitalCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.contentView.backgroundColor = [UIColor colorWithRed:.89 green:.84 blue:.86 alpha:1];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor colorWithWhite:.45 alpha:1];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:.45 alpha:1];
        
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(0, 67, tableView.frame.size.width, 1);
        line.backgroundColor = [UIColor grayColor].CGColor;
        [cell.contentView.layer addSublayer:line];
    }
    
    NSDictionary *dict = [aryAccountList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"providerNameCNH"];
    cell.detailTextLabel.text = [dict objectForKey:@"providerID"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryAccountList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [SVProgressHUD showWithStatus:@"正在配置数据，请稍候"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[aryAccountList objectAtIndex:indexPath.row] forKey:@"HospitalDetailInfo"];
    
    [NSThread detachNewThreadSelector:@selector(getProviderInfo:) toTarget:self withObject:[[aryAccountList objectAtIndex:indexPath.row] objectForKey:@"providerID"]];
    
    
}

@end
