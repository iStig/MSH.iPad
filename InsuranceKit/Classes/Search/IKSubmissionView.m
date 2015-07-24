//
//  IKIClaimSubmissionView.m
//  InsuranceKit
//
//  Created by 大明五阿哥 on 15/1/26.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import "IKSubmissionView.h"
//#import "IKClaimsStateSelector.h"
#import "IKDateRangeSelector.h"
#import "IKApplyClaimsPhotoInformation.h"
@interface IKSubmissionViewSelectInfo : NSObject
@property  BOOL      isSelect;

@end
@interface IKSubmissionView ()<UITableViewDataSource,UITableViewDelegate,IKDateRangerDelegate>{
//  UIImageView *imgvArrowTime,*imgvArrowStatus;
//     int applyStatus;
//      NSDate *dateStart,*dateEnd;
    NSMutableArray *allSelectArr;
     
    BOOL isAllSelect;
}
@end

@implementation IKSubmissionView

float cellWidths[] = {0.2,0.2,0.2,0.3,0.2};
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        contentList = [NSMutableArray arrayWithCapacity:0];
        allSelectArr= [NSMutableArray arrayWithCapacity:0];
        
        _noSubmissionTable = [[UITableView alloc] initWithFrame:CGRectZero];
        _noSubmissionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        _noSubmissionTable.delegate = self;
        _noSubmissionTable.dataSource = self;
//        _noSubmissionTable.backgroundColor = [UIColor redColor];
        [self addSubview:_noSubmissionTable];
        
        [self vistWithID:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"RefreshNotSubmitClaimsApplyList" object:nil];
    
    }
 return self;
}
//-(void)setNoSubmissionTableFrame:(CGRect)noSubmissionTableFrame{
//    _noSubmissionTable.frame = noSubmissionTableFrame;
//   
//}
-(void)refreshList:(NSNotification *)notification{
    NSNumber *photoStatus =notification.object;
    BOOL uploaded =[photoStatus boolValue];
    if (uploaded) {
       isAllSelect= NO;
    }else{
        isAllSelect= YES;
    }
    [self vistWithID:nil];
    [_noSubmissionTable reloadData];
}

#pragma mark - UITableView Data Source & Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AuthListIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIButton  *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(20, 12, 30, 30);
        selectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 0);
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = 1000+indexPath.row;
        [cell.contentView addSubview:selectBtn];
        
        float x = 0;
        
        for (int i=0;i<5;i++){
            float w = cellWidths[i]*tableView.frame.size.width;
            x = i==4?x+20:x;
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, 0, w, 48) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
            if (i==4) {
                lbl.textAlignment = NSTextAlignmentLeft;
            }else{
                lbl.textAlignment = NSTextAlignmentCenter;
            }
            
            lbl.tag = 100+i;
            [cell.contentView addSubview:lbl];
            
            x += w;
        }
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, 47, tableView.frame.size.width-30, 1)];
        line.backgroundColor = [UIColor colorWithRed:.89 green:.91 blue:.92 alpha:1];
        [cell.contentView addSubview:line];
    }
    UIButton *selectBtn = (UIButton *)[cell.contentView viewWithTag:1000+indexPath.row];
    IKSubmissionViewSelectInfo *selectInfo = [allSelectArr objectAtIndex:indexPath.row];
    if (selectInfo.isSelect == YES) {
        [selectBtn setImage:[UIImage imageNamed:@"selectImg"] forState:UIControlStateNormal];
        
    }
    else{
        [selectBtn setImage:[UIImage imageNamed:@"unSelectImg"] forState:UIControlStateNormal];
        
    }

    
    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *lblID = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *lblStatus = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *lblcategray = (UILabel *)[cell.contentView viewWithTag:104];
    
    
    
    NSDictionary *info = [contentList objectAtIndex:indexPath.row];
    
    lblDate.text = [info objectForKey:@"submitDate"];
    lblName.text = [info objectForKey:@"memberName"];
    lblID.text = [info objectForKey:@"claimsNo"];
    lblStatus.text = [info objectForKey:@"status"];
    lblcategray.text = [info objectForKey:@"visitType"];
    
    
    cell.contentView.backgroundColor = indexPath.row%2==0?self.backgroundColor:[UIColor colorWithRed:.98 green:.95 blue:.96 alpha:1];
    
    return cell;
}
-(void)selectBtnClick:(UIButton *)btn{
    IKSubmissionViewSelectInfo *info = [allSelectArr objectAtIndex:btn.tag-1000];
     NSMutableArray *array = [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].selectArray;
    IKVisitCDSO *visit = [_visitArr objectAtIndex:btn.tag-1000];

    if (info.isSelect == YES) {
        info.isSelect = NO;
        [array removeObject:visit];
    }
    else{
     info.isSelect = YES;
    [array addObject:visit];
    
    }
    [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].selectArray=array;
    [allSelectArr replaceObjectAtIndex:btn.tag-1000 withObject:info];
    
    BOOL select = YES;
    
    for (int i = 0; i<allSelectArr.count; i++) {
        IKSubmissionViewSelectInfo *info = [allSelectArr objectAtIndex:i];
        if (info.isSelect == NO) {
            select = NO;
        }
    }
    isAllSelect = select;
    
    [self.noSubmissionTable reloadData];
}
-(void)allSelectBtnClick:(UIButton *)btn{
     NSMutableArray *array = [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].selectArray;
    if (isAllSelect) {
        isAllSelect= NO;
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<allSelectArr.count; i++) {
            IKSubmissionViewSelectInfo *info = [allSelectArr objectAtIndex:i];
            info.isSelect   = NO;
            [arr addObject:info];
        }
        
        
        allSelectArr = arr;
      [array removeAllObjects];
        
        }
    else{

        isAllSelect= YES;
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<allSelectArr.count; i++) {
            IKSubmissionViewSelectInfo *info = [allSelectArr objectAtIndex:i];
            info.isSelect   = YES;
            [arr addObject:info];
        }

        [array addObjectsFromArray:_visitArr];
        allSelectArr = arr;
        
    }
    [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].selectArray=array;
    [self.noSubmissionTable reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 48)];
    v.backgroundColor =[UIColor colorWithRed:.98 green:.95 blue:.96 alpha:1];
    
    
    UIButton  *allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectBtn.frame = CGRectMake(30, 12, 20, 20);
    
    [allSelectBtn addTarget:self action:@selector(allSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (isAllSelect == YES) {
         [allSelectBtn setImage:[UIImage imageNamed:@"selectImg"] forState:UIControlStateNormal];
    }
    else{
    [allSelectBtn setImage:[UIImage imageNamed:@"unSelectImg"] forState:UIControlStateNormal];
    }
    allSelectBtn.tag = 99;
    [v addSubview:allSelectBtn];

    
    
    float x = 0;
    
    //    NSArray *titles = [@"申请时间,客户姓名,申请编号,状态,就诊类别" componentsSeparatedByString:@","];
    
    NSArray *titles = @[LocalizeStringFromKey(@"kApplyDate"),
                        LocalizeStringFromKey(@"kClient"),
                        LocalizeStringFromKey(@"kpCase"),
                        LocalizeStringFromKey(@"kStatus"),
                        LocalizeStringFromKey(@"kTreatmentType")];
    for (int i=0;i<5;i++){
        float w = cellWidths[i]*v.frame.size.width;
        
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(i==4?x-10:x, 0, w, 48) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
        if (i==4) {
            lbl.textAlignment = NSTextAlignmentLeft;
        }else{
            lbl.textAlignment = NSTextAlignmentCenter;
        }
        lbl.tag = 100+i;
        [v addSubview:lbl];
        lbl.text = [titles objectAtIndex:i];
     
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
    
//    NSDictionary *dict = [contentList objectAtIndex:indexPath.row];
    
//    NSString *claimsNo = [dict objectForKey:@"claimsNo"];
//    NSString *claimsState = [dict objectForKey:@"status"];
    IKVisitCDSO *visit = [_visitArr objectAtIndex:indexPath.row];
    
    [self removePhotoList];
    
    [self.delegate submissionView:self didSelectRowAtIndexPath:indexPath visitCDSO:visit];

    
//    IKApplyClaimsViewController *vcApplyClaims = [[IKApplyClaimsViewController alloc] init];
//    
//    vcApplyClaims.claimsNo = claimsNo;
//    //vcApplyClaims.claimStatus =claimsState;
//    [self.navigationController pushViewController:vcApplyClaims animated:NO];
}
-(void)removePhotoList{
    
    
    [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoCardArr removeAllObjects];
    [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoPaymentArr removeAllObjects];
    [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoCardArr removeAllObjects];
 
    
}

-(void)vistWithID:(IKVisitCDSO *)visit{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
    
    NSLog(@"--------%@",providerID);
    //    MemberName
    NSEntityDescription *visitEntity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded==%@",[NSNumber numberWithBool:NO]];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded==%@ and providerID=%@",[NSNumber numberWithBool:NO],providerID];
    
    [fetchRequest setEntity:visitEntity];
    
    [fetchRequest setPredicate:predicate];
    
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchLimit:0];
    
    
    
    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
     _visitArr = (NSMutableArray *)[[ary reverseObjectEnumerator] allObjects];
//    _visitArr = (NSMutableArray *) ary;
    contentList= [NSMutableArray array];
//    contentArr = (NSMutableArray *)ary;
    _selectArray =[NSMutableArray array];
//    [_selectArray addObjectsFromArray:_visitArr];
    [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].selectArray removeAllObjects];
    allSelectArr= [NSMutableArray array];
    
    for (int i = 0; i<_visitArr.count; i++) {
        
        IKVisitCDSO *visit = [_visitArr objectAtIndex:i];
       
        NSString *applyTime = [IKVisitCDSO applyForTime:visit.applyForTime];
//        NSDate *applyTimeAndMin =[IKVisitCDSO applyForTimeAndMin:visit.applyForTime];
        NSString *memberName =visit.memberName;
         NSString *visitType =[NSString stringWithFormat:@"%@",visit.serviceType];
        NSString *type = visitType;
        
        //（1-门诊，2-住院，3-齿科，4-眼科，5-体检）
        if ([visitType isEqualToString:@"3"]) {
            type =LocalizeStringFromKey(@"k_Outpatient");//@"门诊"
        }
        else if ([visitType isEqualToString:@"2"]){
         type =LocalizeStringFromKey(@"k_Inpatient");// @"住院";
        }
        
        else if ([visitType isEqualToString:@"1"]){
        type =LocalizeStringFromKey(@"kDental");//@"齿科";
        }
        else if ([visitType isEqualToString:@"4"]){
            type =LocalizeStringFromKey(@"kVision");// @"眼科";
        }
        else if ([visitType isEqualToString:@"5"]){
            type = LocalizeStringFromKey(@"kWellness");//@"体检";
        }
        NSDictionary *info = [[NSDictionary alloc]
                              initWithObjectsAndKeys:@"--",@"claimsNo",memberName,@"memberName",LocalizeStringFromKey(@"kLeftNoSubmitStr"),@"status",applyTime,@"submitDate",type,@"visitType", nil];//applyTimeAndMin,@"time",
        [contentList addObject:info];
        
        IKSubmissionViewSelectInfo *selectInfo = [[IKSubmissionViewSelectInfo alloc] init];
        selectInfo.isSelect = NO;
        [allSelectArr addObject:selectInfo];
    }
//    [contentList addObjectsFromArray:tempAry];//[self arraySort:tempAry]
    
    [_noSubmissionTable reloadData];
    
  
    
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",nil];
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    NSLog(@"%@",reversedArray);
    //    if (0==ary.count){
    
    //        return nil;
    
    //    }else{
    
    //        return [ary objectAtIndex:0];
    
    //    }
    
}
-(NSArray *)arraySort:(NSMutableArray *)array{
//    NSArray *tempAry = [array sortedArrayUsingSelector:@selector(compare:)];
    NSArray *tempAry = [array sortedArrayUsingComparator:
                       ^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                           // 先按照姓排序
                           NSComparisonResult result = [[obj2 objectForKey:@"time"]compare:[obj1 objectForKey:@"time"]];
                           // 如果有相同的姓，就比较名字
//                           result =NSOrderedAscending;
//                           if (result == NSOrderedDescending) {
////                               result = [obj1.firstname compare:obj2.firstname];
//                               NSLog(@"111");
//                               return result;
//                           }
//                           if (result == NSOrderedAscending) {
//                               //                               result = [obj1.firstname compare:obj2.firstname];
//                               NSLog(@"111");
//                               return result;
//                           }
                           
                           return result;
                       }];
    return tempAry;
}
-(NSComparisonResult)compareStudent:(NSMutableDictionary *)dict {
    NSComparisonResult result = [[dict objectForKey:@"submitDate"] compare:[dict objectForKey:@"submitDate"]];
    // 如果有相同的姓，就比较名字
//    if (result == NSOrderedSame) {
//        result = [self.firstname compare:stu.firstname];
//    }
    return result;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNotSubmitClaimsApplyList" object:nil];
    
}
@end
@implementation IKSubmissionViewSelectInfo

@end