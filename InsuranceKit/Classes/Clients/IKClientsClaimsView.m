//
//  IKClientClaimsView.m
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKClientsClaimsView.h"
#import "IKClientsAuthCell.h"
#import "IKApplyAuthViewController.h"
#import "IKClientClaimsCell.h"

@implementation IKClientsClaimsView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];
        
        tvList = [[UITableView alloc] initWithFrame:self.bounds];
        tvList.delegate = self;
        tvList.dataSource = self;
        tvList.backgroundColor = [UIColor clearColor];
        tvList.backgroundView = [[UIView alloc] init];
        tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
        tvList.showsVerticalScrollIndicator = NO;
        [self addSubview:tvList];
        
        rcList = [[UIRefreshControl alloc] init];
        [rcList addTarget:self action:@selector(refreshChanged:) forControlEvents:UIControlEventValueChanged];
        [tvList addSubview:rcList];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshApplyList) name:@"RefreshClaimsApplyList" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshApplyList) name:@"saveUploadInfoSuccess" object:nil];
        
    }
    return self;
}


- (void)refreshChanged:(UIRefreshControl *)rc{
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}
- (void)refreshApplyList{
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kcRefresh")];

    [NSThread detachNewThreadSelector:@selector(loadData1) toTarget:self withObject:nil];
}


- (void)showInfo{
    [rcList beginRefreshing];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}
- (void)loadData1{
    
    
    
    @autoreleasepool {
        NSString *providerID = self.visit.providerID;
        NSString *memberID = self.visit.memberID;
        //        NSString *memberID = @"创世汇智-0004";
        NSString *depID = self.visit.depID;
        
        NSDictionary *dict = [IKDataProvider getClaimList:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"status",providerID,@"providerID",memberID,@"memberID",depID,@"depID", nil]];
        
        
        //        NSDictionary *dict = [IKDataProvider getClaimList:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"status",providerID,@"providerID", nil]];
        
        NSLog(@"Auth List:%@",dict);
        aryList = [NSMutableArray arrayWithArray:[dict objectForKey:@"data"]];
        //
        [SVProgressHUD dismiss];

        sw_dispatch_sync_on_main_thread(^{
            
            [rcList endRefreshing];
            [self queryVistWithVisitID];
            [tvList reloadData];
        });
    }
}

- (void)loadData{
    
  
    
    @autoreleasepool {
        NSString *providerID = self.visit.providerID;
        NSString *memberID = self.visit.memberID;
//        NSString *memberID = @"创世汇智-0004";
        NSString *depID = self.visit.depID;
        
        NSDictionary *dict = [IKDataProvider getClaimList:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"status",providerID,@"providerID",memberID,@"memberID",depID,@"depID", nil]];
        
        
//        NSDictionary *dict = [IKDataProvider getClaimList:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"status",providerID,@"providerID", nil]];
        
        NSLog(@"Auth List:%@",dict);
        aryList = [NSMutableArray arrayWithArray:[dict objectForKey:@"data"]];
//
       
        sw_dispatch_sync_on_main_thread(^{
            
            [rcList endRefreshing];
            [self queryVistWithVisitID];
            [tvList reloadData];
        });
    }
}


-(void )queryVistWithVisitID{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    
    NSEntityDescription *visitEntity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];
//    NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
    NSString *providerID = self.visit.providerID;
     NSString *memberID = self.visit.memberID;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded==%@",[NSNumber numberWithBool:NO]];

    NSString *memberName = self.visit.memberName;
   

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded==%@ and providerID=%@ and memberName=%@ and memberID=%@",[NSNumber numberWithBool:NO],providerID,memberName,memberID];

//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded==%@ and providerID=%@ and memberID=%@",[NSNumber numberWithBool:NO],providerID,memberID];

    

    
    [fetchRequest setEntity:visitEntity];
    
    [fetchRequest setPredicate:predicate];
    
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchLimit:0];
    
    
    
   NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
  visitDatabaArr =(NSMutableArray *)[[ary reverseObjectEnumerator] allObjects];
   NSMutableArray *contentList= [NSMutableArray array];
    
    for (int i = 0; i<visitDatabaArr.count; i++) {
        
        IKVisitCDSO *newVisit = [visitDatabaArr objectAtIndex:i];
        
        NSString *applyTime = [IKVisitCDSO applyForTime:newVisit.applyForTime];
       
        NSString *visitType =[NSString stringWithFormat:@"%@",newVisit.serviceType];
        NSString *type = visitType;
        
        //（1-门诊，2-住院，3-齿科，4-眼科，5-体检）
        if ([visitType isEqualToString:@"3"]) {
//            type = @"门诊";
            type =LocalizeStringFromKey(@"k_Outpatient");//@"门诊"
        }
        else if ([visitType isEqualToString:@"2"]){
//            type = @"住院";
            type =LocalizeStringFromKey(@"k_Inpatient");// @"住院";
        }
        
        else if ([visitType isEqualToString:@"1"]){
//            type = @"齿科";
            type =LocalizeStringFromKey(@"kDental");//@"齿科";
        }
        else if ([visitType isEqualToString:@"4"]){
//            type = @"眼科";
            type =LocalizeStringFromKey(@"kVision");// @"眼科";
        }
        else if ([visitType isEqualToString:@"5"]){
//            type = @"体检";
            type = LocalizeStringFromKey(@"kWellness");//@"体检";
        }
        NSDictionary *info = [[NSDictionary alloc]
                              initWithObjectsAndKeys:@"",@"claimsNo",LocalizeStringFromKey(@"kLeftNoSubmitStr"),@"status",applyTime,@"submitDate",type,@"visitType", nil];
        [contentList addObject:info];
        

    }
  
    if (contentList.count>0) {
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                               NSMakeRange(0,[contentList count])];
        [aryList insertObjects:contentList atIndexes:indexes];
    }
   
}

- (void)applyAuthorization{
    if ([IKDataProvider canEditClaims])
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyAuthorization" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.visit,@"visit", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyClaims" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.visit,@"visit", nil]];
        
    else
        [UIAlertView showAlertWithTitle:nil message:@"您没有权限进行此项操作" cancelButton:nil];
}

#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier0 = @"ApplyClaims";
    static NSString *identifier1 = @"ClaimsList";
    
    NSString *identifier = indexPath.row==0?identifier0:identifier1;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        if (0==indexPath.row){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.backgroundView = [[UIView alloc] init];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 55, 55);
            btn.clipsToBounds = YES;
            btn.tag =100;
            btn.layer.cornerRadius = btn.frame.size.width/2;
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:.52 blue:.55 alpha:1] size:btn.frame.size] forState:UIControlStateNormal];
            
            [btn setImage:[UIImage imageNamed:@"IKButtonAddWhite.png"] forState:UIControlStateNormal];
            btn.center = CGPointMake(tableView.frame.size.width/2, 55/2);
            [cell.contentView addSubview:btn];
            [btn addTarget:self action:@selector(applyAuthorization) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            cell = [[IKClientClaimsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    
    
    if(indexPath.row == 0){
        
        UIButton *btn = (UIButton*)[cell viewWithTag:100];
    
        if ([[self.visit.detailInfo objectForKey:@"directbilling"] intValue] == 1 && !self.visit.claimEditHistory) {
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:.52 blue:.55 alpha:1] size:btn.frame.size] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:.8 blue:.8 alpha:1] size:btn.frame.size] forState:UIControlStateNormal];
            btn.enabled = NO;
        }

    }
    
    
    if (indexPath.row>0){
        ((IKClientClaimsCell *)cell).dicInfo = [aryList objectAtIndex:indexPath.row-1];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryList.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row==0?55:94;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tvList.frame.size.width, 22)];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > visitDatabaArr.count){
        NSString *caseId = [[aryList objectAtIndex:indexPath.row-1] objectForKey:@"claimsNo"];
               NSString *caseState = [[aryList objectAtIndex:indexPath.row-1] objectForKey:@"status"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyClaims" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:caseId,@"claimsNo",caseState,@"status",nil]];
        
    }
    
    else if (indexPath.row <= visitDatabaArr.count && indexPath.row > 0){
        IKVisitCDSO *newVisit = [visitDatabaArr objectAtIndex:indexPath.row-1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyClaims" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:newVisit,@"visit", nil]];
    
    }
}



@end
