//
//  IKAuthorizationViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKAuthorizationViewController.h"
#import "IKBackLetter.h"
#import "IKApplyAuthViewController.h"

@interface IKAuthorizationViewController ()

@end

float auth_widths[] = {1.0f/6.0f,1.0f/6.0f,1.0f/6.0f,1.0f/6.0f,1.0f/6.0f,1.0f/6.0f};

@implementation IKAuthorizationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kPre-Authorization")];
    [self addBGColor:nil];
    [self clearNavBack];
    
    applyStatus = IKApplyStatusAll;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 235, 32)];
    v.backgroundColor = [UIColor whiteColor];
    v.clipsToBounds = YES;
    v.layer.cornerRadius = 2;
    
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconSearch.png"]];
    imgv.center = CGPointMake(24, 16);
    [v addSubview:imgv];
    
    tfSearch = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, 180, 32)];
    tfSearch.delegate = self;
    tfSearch.backgroundColor = [UIColor clearColor];
    tfSearch.font = [UIFont systemFontOfSize:13];
    tfSearch.placeholder = LocalizeStringFromKey(@"kClientNameCaseNo");
    tfSearch.returnKeyType = UIReturnKeySearch;
    [v addSubview:tfSearch];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:v];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    fixed.width = -10;
    self.navigationItem.rightBarButtonItems = @[fixed,item];
    
    
    tvList = [[UITableView alloc] initWithFrame:CGRectZero];
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvList.delegate = self;
    tvList.dataSource = self;
    [self.view addSubview:tvList];
    
    rcList = [[UIRefreshControl alloc] init];
    [rcList addTarget:self action:@selector(refreshChanged:) forControlEvents:UIControlEventValueChanged];
    [tvList addSubview:rcList];
    
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kpRefresh")];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"RefreshApplyList" object:nil];
}


- (void)refresh{
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}


- (void)refreshChanged:(UIRefreshControl *)rc{
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)loadData{
    @autoreleasepool {
        dCurrentPage = 1;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
        
        [param setObject:providerID forKey:@"providerID"];
        
        if (tfSearch.text.length>0){
            [param setObject:tfSearch.text forKey:@"keyword"];
        }
        
        [param setObject:[NSString stringWithFormat:@"%d",applyStatus] forKey:@"status"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (dateStart)
            [param setObject:[formatter stringFromDate:dateStart] forKey:@"startDate"];
        if (dateEnd)
            [param setObject:[formatter stringFromDate:dateEnd] forKey:@"endDate"];
        
        
        NSDictionary *dict = [IKDataProvider getAuthList:param];
        
        NSArray *ary = [dict objectForKey:@"data"];
        aryList = [NSMutableArray arrayWithArray:ary];
        
        sw_dispatch_sync_on_main_thread(^{
            [SVProgressHUD dismiss];
            [tvList reloadData];
            
            [rcList endRefreshing];
        });
        
        NSLog(@"Auth List:%@",dict);
    }
}

- (void)needMore{
    [NSThread detachNewThreadSelector:@selector(loadMoreData) toTarget:self withObject:nil];
}

- (void)loadMoreData{
    @autoreleasepool {
 
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
        
        [param setObject:providerID forKey:@"providerID"];
        
        if (tfSearch.text.length>0){
            if (tfSearch.text.intValue>0)
                [param setObject:tfSearch.text forKey:@"caseId"];
            else
                [param setObject:tfSearch.text forKey:@"memberName"];
        }
        
        if (applyStatus>0)
            [param setObject:[NSString stringWithFormat:@"%d",applyStatus] forKey:@"status"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (dateStart)
            [param setObject:[formatter stringFromDate:dateStart] forKey:@"startDate"];
        if (dateEnd)
            [param setObject:[formatter stringFromDate:dateEnd] forKey:@"endDate"];
        
        [param setObject:[NSString stringWithFormat:@"%d",dCurrentPage+1] forKey:@"pageNo"];
        
        NSDictionary *dict = [IKDataProvider getAuthList:param];
        
        NSArray *ary = [dict objectForKey:@"data"];
        
        if (ary.count>0){
            [aryList addObjectsFromArray:ary];
            dCurrentPage++;
        }

        sw_dispatch_sync_on_main_thread(^{
            [tvList reloadData];
        });
    }
}





- (void)viewWillLayoutSubviews{
    tvList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mailClicked:(UIButton *)btn{
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kGettingLetter")];
    
    int row = [[btn titleForState:UIControlStateDisabled] intValue];
    
    NSDictionary *apply = [aryList objectAtIndex:row];
    
    NSString *CaseId = [apply objectForKey:@"caseId"];
    
    sw_dispatch_async_on_background_thread(^{
        @autoreleasepool {
            NSDictionary *dict = [IKDataProvider getBackMailInfo:[NSDictionary dictionaryWithObjectsAndKeys:CaseId,@"CaseId", nil]];
            
            sw_dispatch_sync_on_main_thread(^{
                if ([dict objectForKey:@"data"]){
                    [SVProgressHUD dismiss];
                    [IKBackLetter showLetter:[dict objectForKey:@"data"]];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"获取担保函信息失败"];
                }
            });
            
            
        }
    });

}

- (void)keywordChanged{
    [SVProgressHUD showWithStatus:@"正在搜索，请稍候"];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)headerClicked:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            imgvArrowTime.transform = CGAffineTransformMakeRotation(M_PI);
            [IKDateRangeSelector showAtPoint:CGPointMake(125, 105) delegate:self];
            break;
        case 3:
            imgvArrowStatus.transform = CGAffineTransformMakeRotation(M_PI);
            [IKStatusSelector showAtPoint:CGPointMake(675,105) delegate:self];
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableView Data Source & Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AuthListIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        
        float x = 0;
        
        for (int i=0;i<5;i++){
            float w = auth_widths[i]*tableView.frame.size.width;
            
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, 0, w, 48) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.tag = 100+i;
            [cell.contentView addSubview:lbl];
            
            x += w;
        }
        
        UIButton *btnMail = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMail.frame = CGRectMake(0, 0, 48, 48);
        [btnMail setImage:[UIImage imageNamed:@"IKIconMail.png"] forState:UIControlStateNormal];
        btnMail.center = CGPointMake(22.0f/24.0f*tableView.frame.size.width, 24);
        [btnMail addTarget:self action:@selector(mailClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnMail];
        btnMail.tag = 105;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 47, tableView.frame.size.width-30, 1)];
        line.backgroundColor = [UIColor colorWithRed:.89 green:.91 blue:.92 alpha:1];
        [cell.contentView addSubview:line];
    }
    
    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *lblID = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *lblStatus = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *lblPlan = (UILabel *)[cell.contentView viewWithTag:104];
    UIButton *btnMail = (UIButton *)[cell.contentView viewWithTag:105];

    
    NSDictionary *info = [aryList objectAtIndex:indexPath.row];
    
    lblDate.text = [info objectForKey:@"submitDate"];
    lblName.text = [info objectForKey:@"memberName"];
    lblID.text = [info objectForKey:@"caseId"];
    lblPlan.text = [IKDataProvider categoryName:[[info objectForKey:@"category"] intValue]];

    IKApplyStatus status = [[info objectForKey:@"status"] intValue];
//    IKApplyStatusDeny,//拒绝
//    IKApplyStatusApproval,//批准
//    IKApplyStatusReviewing,//审核
//    IKApplyStatusCancel,//取消
//    IKApplyStatusNeedData,//审核中
//    IKApplyStatusAll = 99//全部
    
    switch (status) {
        case IKApplyStatusApproval:
            lblStatus.textColor = [UIColor colorWithRed:.25 green:.72 blue:.35 alpha:1];
            lblStatus.text = LocalizeStringFromKey(@"kApproved");
            btnMail.hidden = NO;
            break;
        case IKApplyStatusReviewing:
            lblStatus.textColor = [UIColor colorWithWhite:.67 alpha:1];
            lblStatus.text = LocalizeStringFromKey(@"kAudit");
            btnMail.hidden = YES;
            break;
        case IKApplyStatusCancel:
            lblStatus.textColor = [UIColor colorWithWhite:.67 alpha:1];
            lblStatus.text = LocalizeStringFromKey(@"kCanceled");
            btnMail.hidden = YES;
            break;
        case IKApplyStatusDeny:
            lblStatus.textColor = [UIColor colorWithRed:1 green:.25 blue:.33 alpha:1];
            lblStatus.text = LocalizeStringFromKey(@"kDenied");
            btnMail.hidden = YES;
            break;
        case IKApplyStatusNeedData:
            lblStatus.textColor = [UIColor colorWithRed:1 green:.25 blue:.33 alpha:1];
            lblStatus.text = LocalizeStringFromKey(@"k_NeedMR");
            btnMail.hidden = YES;
            break;
        default:
            break;
    }
    

    [btnMail setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateDisabled];
    
    cell.contentView.backgroundColor = indexPath.row%2==0?self.view.backgroundColor:[UIColor colorWithRed:.98 green:.95 blue:.96 alpha:1];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 48)];
    v.backgroundColor = self.view.backgroundColor;
    
    float x = 0;
    
    //NSArray *titles = [@"申请时间,客户姓名,申请编号,状态,治疗方案,担保函" componentsSeparatedByString:@","];
    
    NSArray *titles =@[LocalizeStringFromKey(@"kApplyDate"),
                       LocalizeStringFromKey(@"kClient"),
                       LocalizeStringFromKey(@"kpCase"),
                       LocalizeStringFromKey(@"kStatus"),
                       LocalizeStringFromKey(@"kServiceType"),
                       LocalizeStringFromKey(@"kGuaranteeletter")];
    for (int i=0;i<6;i++){
        float w = auth_widths[i]*v.frame.size.width;
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, 0, w, 48) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = 100+i;
        [v addSubview:lbl];
        lbl.text = [titles objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = lbl.frame;
        [v addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize size = [lbl.text sizeWithFont:lbl.font];
        
        if (0==i){
            imgvArrowTime = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconArrowDownYellow.png"]];
            imgvArrowTime.center = CGPointMake(btn.frame.size.width/2+size.width/2+5+imgvArrowTime.frame.size.width/2, btn.frame.size.height/2);
            [btn addSubview:imgvArrowTime];
        }else if (3==i){
            imgvArrowStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconArrowDownYellow.png"]];
            imgvArrowStatus.center = CGPointMake(btn.frame.size.width/2+size.width/2+5+imgvArrowTime.frame.size.width/2, btn.frame.size.height/2);
            [btn addSubview:imgvArrowStatus];
        }
        
        
        x += w;
    }
    

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 47, tableView.frame.size.width-30, 1)];
    line.backgroundColor = [UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1];
    [v addSubview:line];
    
    
    return v;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    
    IKApplyAuthViewController *vcApply = [[IKApplyAuthViewController alloc] init];
    vcApply.CaseId = [dict objectForKey:@"caseId"];
    [self.navigationController pushViewController:vcApply animated:NO];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int lines = aryList.count;
    if (scrollView.contentOffset.y+scrollView.frame.size.height>lines*48 && aryList.count>0 && aryList.count%20==0)
        [self needMore];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self keywordChanged];
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - StatusSelector Delegate
- (void)statusSelected:(IKApplyStatus)status{
    applyStatus = status;
    
    [SVProgressHUD showWithStatus:@"正在搜索，请稍候"];
    
    [self refresh];
}

#pragma mark - DateRangeSelector Delegate
- (void)didSelectStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    dateStart = startDate;
    dateEnd = endDate;
    
    [SVProgressHUD showWithStatus:@"正在搜索，请稍候"];
    
    [self refresh];
}

@end
