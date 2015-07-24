//
//  IKMedicalRecordsViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-9-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.x
//

#import "IKMedicalRecordsViewController.h"
#import "IKApplyClaimsViewController.h"
#import "IKVisitCDSO.h"
#import "IKDataProvider.h"
@interface IKMedicalRecordsViewController ()

@end

@implementation IKMedicalRecordsViewController

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
    [self setNavTitle:LocalizeStringFromKey(@"kTreatmentClients")];
    [self addBGColor:nil];
    [self clearNavBack];
    
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
    tfSearch.placeholder =LocalizeStringFromKey(@"kClientOrName");
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
    [rcList addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [tvList addSubview:rcList];
    
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"ktRefresh")];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"RefreshClaimsApplyList" object:nil];
    
    
    
}

- (void)refresh{
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
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (dateStart)
            [param setObject:[formatter stringFromDate:dateStart] forKey:@"startDate"];
        if (dateEnd)
            [param setObject:[formatter stringFromDate:dateEnd] forKey:@"endDate"];
        
        
        NSDictionary *dict = [IKDataProvider getMedicalRecordsList:param];
        
        NSArray *ary = [dict objectForKey:@"data"];
        aryList = [NSMutableArray arrayWithArray:ary];
        
        sw_dispatch_sync_on_main_thread(^{
            [SVProgressHUD dismiss];
            [tvList reloadData];
            [rcList endRefreshing];
        });
        
        NSLog(@"MedicalRecord List:%@",dict);
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
            [param setObject:tfSearch.text forKey:@"keyword"];
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (dateStart)
            [param setObject:[formatter stringFromDate:dateStart] forKey:@"startDate"];
        if (dateEnd)
            [param setObject:[formatter stringFromDate:dateEnd] forKey:@"endDate"];
        
        [param setObject:[NSString stringWithFormat:@"%d",dCurrentPage+1] forKey:@"pageNo"];
        
        NSDictionary *dict = [IKDataProvider getMedicalRecordsList:param];
        
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

- (void)keywordChanged{
    [SVProgressHUD showWithStatus:@"正在搜索，请稍候"];
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}


-(void)claimClicked:(UIButton*)btn {
    
    NSLog(@"%d",btn.tag);
    int pathIndex = [[btn titleForState:UIControlStateDisabled] intValue];
    
    
    
    NSDictionary *dict = [aryList objectAtIndex:pathIndex];
    NSString *claimsNo = [dict objectForKey:@"claimsNo"];
    NSString *claimsState = [dict objectForKey:@"status"];
    NSString *directbill = [dict objectForKey:@"directbilling"];
    
    
    if (claimsNo.length >0) {
        IKApplyClaimsViewController *vcApplyClaims = [[IKApplyClaimsViewController alloc] init];
        vcApplyClaims.claimsNo = claimsNo;
      //  vcApplyClaims.claimStatus =claimsState;
        [self.navigationController pushViewController:vcApplyClaims animated:NO];
    }else{
        
        if ([directbill isEqualToString:@"Y"]) {
            IKVisitCDSO *v = [IKVisitCDSO vistWithID:[dict objectForKey:@"visitId"]];
            if (v) {
                IKApplyClaimsViewController *vcApplyClaims = [[IKApplyClaimsViewController alloc] init];
                vcApplyClaims.visit = v;
                [self.navigationController pushViewController:vcApplyClaims animated:NO];
            }
            else{
                NSMutableDictionary *otherVisit = [NSMutableDictionary dictionary];
                [otherVisit setObject:[dict objectForKey:@"memberID"] forKey:@"memberID"];
                [otherVisit setObject:[dict objectForKey:@"visitId"] forKey:@"visitId"];
                [otherVisit setObject:[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"] forKey:@"providerID"];
                [otherVisit setObject:[dict objectForKey:@"depID"] forKey:@"depID"];
                IKApplyClaimsViewController *vcApplyClaims = [[IKApplyClaimsViewController alloc] init];
                vcApplyClaims.otherVisitInfo = otherVisit;
                [self.navigationController pushViewController:vcApplyClaims animated:NO];
            }
        }else{
            [UIAlertView showAlertWithTitle:nil message:@"该客户不能直付，无法理赔。" cancelButton:nil];
        }
    }
    
    
    
    
}


#pragma mark - UITableView Data Source & Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ClaimListIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        float widths[] = {1.0f/6.0f,1.0f/6.0f,1.0f/9.0f,1.0f/9.0f,1.0f/6.0f,1.0f/9.0f,1.0f/6.0f};
        float x = 0;
        
        for (int i=0;i<6;i++){
            float w = widths[i]*tableView.frame.size.width;
            
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, 0, w, 48) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.tag = 100+i;
            [cell.contentView addSubview:lbl];
            
            x += w;
        }
        
        UIButton *btnClaim = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClaim.frame = CGRectMake(0, 0, 120, 48);
        btnClaim.center = CGPointMake(22.0f/24.0f*tableView.frame.size.width, 24);
        [btnClaim addTarget:self action:@selector(claimClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnClaim setTitleColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1] forState:UIControlStateNormal];
        [cell.contentView addSubview:btnClaim];
        btnClaim.tag = 106;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 47, tableView.frame.size.width-30, 1)];
        line.backgroundColor = [UIColor colorWithRed:.89 green:.91 blue:.92 alpha:1];
        [cell.contentView addSubview:line];
    }
    
    UILabel *lblVisitDate = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *lblVisitType= (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *lblTotalCopay = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *lblSaleCopay = (UILabel *)[cell.contentView viewWithTag:104];
    UILabel *btnMyselfCopay = (UILabel *)[cell.contentView viewWithTag:105];
    UIButton *btnClaim = (UIButton *)[cell.contentView viewWithTag:106];
    
    [btnClaim setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateDisabled];
    
    NSDictionary *info = [aryList objectAtIndex:indexPath.row];
    
    lblVisitDate.text = [info objectForKey:@"visitDate"];
    lblName.text = [info objectForKey:@"memberName"];
    lblTotalCopay.text = [info objectForKey:@"totalCopay"];
    lblVisitType.text = [info objectForKey:@"visitType"];
    lblSaleCopay.text = [info objectForKey:@"saleCopay"];
    btnMyselfCopay.text = [info objectForKey:@"myselfCopay"];
    
    [btnClaim setTitle:[[info objectForKey:@"claimsNo"] length] > 0? LocalizeStringFromKey(@"kClaimdetail"):LocalizeStringFromKey(@"kClaimapply") forState:UIControlStateNormal];
    
    
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
    
    float widths[] = {1.0f/6.0f,1.0f/6.0f,1.0f/9.0f,1.0f/9.0f,1.0f/6.0f,1.0f/9.0f,1.0f/6.0f};
    float x = 0;
    
    //    NSArray *titles = [@"就诊时间,客户姓名,就诊类别,总额,折后额,自付额,理赔申请" componentsSeparatedByString:@","];
    NSArray *titles = @[LocalizeStringFromKey(@"kServiceDate"),
                        LocalizeStringFromKey(@"kClient"),
                        LocalizeStringFromKey(@"kTreatmentType"),
                        LocalizeStringFromKey(@"kTotalamount"),
                        LocalizeStringFromKey(@"kAmountwithdiscount"),
                        LocalizeStringFromKey(@"kCo-pay"),
                        LocalizeStringFromKey(@"kClaim")];
    
    for (int i=0;i<7;i++){
        float w = widths[i]*v.frame.size.width;
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
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int lines = aryList.count;
    if (scrollView.contentOffset.y+scrollView.frame.size.height>lines*48 && aryList.count>0 && aryList.count%20==0)
        [self needMore];
}


- (void)headerClicked:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            imgvArrowTime.transform = CGAffineTransformMakeRotation(M_PI);
            [IKDateRangeSelector showAtPoint:CGPointMake(125, 105) delegate:self];
            break;
        default:
            break;
    }
}

#pragma mark - DateRangeSelector Delegate
- (void)didSelectStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    dateStart = startDate;
    dateEnd = endDate;
    [SVProgressHUD showWithStatus:@"正在搜索，请稍候"];
    [self refresh];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self keywordChanged];
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
