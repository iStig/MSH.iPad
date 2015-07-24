//
//  IKSummaryViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKSummaryViewController.h"
#import "IKDataProvider.h"

@interface IKSummaryViewController ()

@end

@implementation IKSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kCo-paysummary")];
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];
    
    tvList = [[UITableView alloc] initWithFrame:CGRectZero];
    [tvList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PaymentInfo"];
    tvList.delegate = self;
    tvList.dataSource = self;
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvList.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:tvList];
    
    rcList = [[UIRefreshControl alloc] init];
    //        rcList.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [rcList addTarget:self action:@selector(refreshChanged:) forControlEvents:UIControlEventValueChanged];
    [tvList addSubview:rcList];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)refreshChanged:(UIRefreshControl *)rc{
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)dateClicked:(UIButton *)btn{
    [IKDateRangeSelector showAtPoint:CGPointMake(460, 70) delegate:self];
}

- (void)sendClicked{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizeStringFromKey(@"kEnterEmailAddress") message:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") otherButtonTitles:@"发送", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)refresh{
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)loadData{
    @autoreleasepool {
        dCurrentPage = 1;
        NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:providerID forKey:@"ProviderID"];
        [param setObject:@"1" forKey:@"pageNo"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (dateStart)
            [param setObject:[formatter stringFromDate:dateStart] forKey:@"visitStartTime"];
        if (dateEnd)
            [param setObject:[formatter stringFromDate:dateEnd] forKey:@"visitEndTime"];
        
        NSDictionary *dict = [IKDataProvider getCopayInfo:param];
        NSLog(@"Result:%@",dict);
        
        aryList = [NSMutableArray arrayWithArray:[dict objectForKey:@"data"]];

        sw_dispatch_sync_on_main_thread(^{
            [tvList reloadData];
            [rcList endRefreshing];
        });
    }
}

- (void)needMore{
    if (isLoadingMore)
        return;
    isLoadingMore = YES;
    [NSThread detachNewThreadSelector:@selector(loadMoreData) toTarget:self withObject:nil];
}

- (void)loadMoreData{
    @autoreleasepool {
        NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:providerID forKey:@"ProviderID"];
        [param setObject:[NSString stringWithFormat:@"%d",dCurrentPage+1] forKey:@"pageNo"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (dateStart)
            [param setObject:[formatter stringFromDate:dateStart] forKey:@"visitStartTime"];
        if (dateEnd)
            [param setObject:[formatter stringFromDate:dateEnd] forKey:@"visitEndTime"];
        
        NSDictionary *dict = [IKDataProvider getCopayInfo:param];
        
        NSArray *ary = [dict objectForKey:@"data"];
        
        if (ary.count>0){
            [aryList addObjectsFromArray:ary];
            dCurrentPage++;
        }
        
        sw_dispatch_sync_on_main_thread(^{
            [tvList reloadData];
            isLoadingMore = NO;
        });
    }
}

- (void)sendMail{
    @autoreleasepool {
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:strEmailAddress,@"sendEmail",[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"],@"providerID", nil];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (dateStart)
            [param setObject:[formatter stringFromDate:dateStart] forKey:@"visitStartTime"];
        if (dateEnd)
            [param setObject:[formatter stringFromDate:dateEnd] forKey:@"visitEndTime"];
        
        NSDictionary *dict = [IKDataProvider sendMail:param];
        
        
        sw_dispatch_sync_on_main_thread(^{
            int result = [[dict objectForKey:@"result"] intValue];
            if (0==result && dict){
                
                [SVProgressHUD showSuccessWithStatus:@"邮件发送成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"邮件发送失败:%@",[dict objectForKey:@"errStr"]]];
            }
        });
        
        
        
        
    }
}

- (void)viewWillLayoutSubviews{
    tvList.frame = CGRectMake(20, 10, self.view.frame.size.width-20*2, self.view.frame.size.height-10);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentInfo"];
    
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *lblMoney = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *lblTotal = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:103];
    
    if (!lblName){
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        float x = 0;
        float ratios[] = {0.3f,0.2f,0.2f,.3f};
        for (int i=0;i<4;i++){
            float w = tableView.frame.size.width*ratios[i];
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, 0, w, 54) font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithWhite:.2 alpha:1]];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.tag = 100+i;
            [cell.contentView addSubview:lbl];
            x += w;
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53, tableView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:.83 green:.82 blue:.84 alpha:1];
        [cell.contentView addSubview:line];
        
//        line = [[UIView alloc] initWithFrame:CGRectZero];
//        line.layer.borderWidth = 1;
//        line.layer.bor
        
        lblName = (UILabel *)[cell.contentView viewWithTag:100];
        lblMoney = (UILabel *)[cell.contentView viewWithTag:102];
        lblTotal = (UILabel *)[cell.contentView viewWithTag:101];
        lblDate = (UILabel *)[cell.contentView viewWithTag:103];
    }
    
    
    
    
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    lblName.text = [dict objectForKey:@"memberName"];
    lblMoney.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"actualCopay"] floatValue]];
    lblTotal.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"medExpenses"] floatValue]];
    lblDate.text = [dict objectForKey:@"registrationTime"];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 54)];
    v.backgroundColor = self.view.backgroundColor;
    
    float ratios[] = {0.3f,0.2f,0.2f,.3f};
    float x = 0;
//    NSArray *titles = [@"姓名,就诊总费用,自付金额,就诊时间" componentsSeparatedByString:@","];
    NSArray *titles = @[LocalizeStringFromKey(@"kClient"),LocalizeStringFromKey(@"kaboutTotalAmount"),LocalizeStringFromKey(@"kaboutCo-pay"),LocalizeStringFromKey(@"kServiceDate")];
    for (int i=0;i<4;i++){
        float w = tableView.frame.size.width*ratios[i];
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, 0, i==3?(w-50):w, 54) font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithRed:.99 green:.43 blue:.2 alpha:1]];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = 100+i;
        [v addSubview:lbl];
        lbl.text = [titles objectAtIndex:i];
        
        if (3==i){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = lbl.frame;
            [v addSubview:btn];
            [btn addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize size = [lbl.text sizeWithFont:lbl.font];
            
            UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconArrowDownYellow.png"]];
            imgv.center = CGPointMake(btn.frame.size.width/2+size.width/2+5+imgv.frame.size.width/2, btn.frame.size.height/2);
            [btn addSubview:imgv];
        }
        
        x += w;
    }
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, v.frame.size.height-1, v.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:.99 green:.43 blue:.2 alpha:1];
    [v addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"IKButtonSendMail.png"] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.center = CGPointMake(v.frame.size.width-10-btn.frame.size.width/2, v.frame.size.height/2);
    [btn addTarget:self action:@selector(sendClicked) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 54;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int lines = aryList.count;
    if (scrollView.contentOffset.y+scrollView.frame.size.height>lines*48 && aryList.count>0 && aryList.count%20==0)
        [self needMore];
}

#pragma mark - DateRangeSelector Delegate
- (void)didSelectStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    dateStart = startDate;
    dateEnd = endDate;
    
    [self refresh];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"发送"]){
        UITextField *tf = [alertView textFieldAtIndex:0];
        if (tf.text.length>0){
            if ([tf.text isValidEmailAddress]){
                [SVProgressHUD showWithStatus:@"正在发送邮件"];
                strEmailAddress = tf.text;
                [[NSUserDefaults standardUserDefaults] setObject:strEmailAddress forKey:@"EmailReceiver"];
                [NSThread detachNewThreadSelector:@selector(sendMail) toTarget:self withObject:nil];
            }else{
                [UIAlertView showAlertWithTitle:nil message:@"请输入正确的邮箱地址" cancelButton:nil];
            }
        }
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView{
    strEmailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"EmailReceiver"];
    UITextField *tf = [alertView textFieldAtIndex:0];
    tf.text = strEmailAddress;
    
}

@end
