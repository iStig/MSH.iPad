//
//  IKClaimViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-9-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKClaimViewController.h"
#import "IKApplyClaimsViewController.h"
#import "IKVisitCDSO.h"
#import "IKDataProvider.h"
#import "IKSubmissionView.h"
#import "IKPhotoCDSO.h"
#import "IKAppDelegate.h"
#import "IKApplyClaimsPhotoInformation.h"
#define leftSubmitBtnTag  (888)
#define leftNoSubmitBtnTag  (889)
@interface IKClaimViewController ()<IKSubmissionViewDelegate>{
    
    UIButton *leftSubmitBtn;
    UIButton *leftNoSubmitBtn;
//    IKSubmissionView *submissionView;
    IKPhotoCDSO *photo;
    NSInteger netLoadIndex;
    NSInteger index;//只掉一次
}
@property (nonatomic ,retain)NSMutableArray *visitAry;
@property (nonatomic ,retain)IKVisitCDSO *visitCDSOTemp;
@property (nonatomic ,retain)IKSubmissionView *submissionView;
@property  NSMutableArray *aryReportImages;
@property NSMutableArray *tempAry;
@end

float widths[] = {0.2,0.2,0.2,0.3,0.2};

@implementation IKClaimViewController
@synthesize submissionView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setNavLeftBtn:(NSString *)leftSubmitBtnStr noSubmitBtnStr:(NSString *)noSubmitBtnStr{
    leftSubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftSubmitBtn.frame = CGRectMake(0, 0, 100, 44);
    [leftSubmitBtn setTitle:leftSubmitBtnStr forState:UIControlStateNormal];
    [leftSubmitBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftSubmitBtn.tag = leftSubmitBtnTag;
    [leftSubmitBtn setBackgroundImage:[UIImage imageNamed:@"submittedImg"] forState:UIControlStateNormal];
    [leftSubmitBtn setTitleColor:[UIColor colorWithRed:243/255.0 green:94/255.0 blue:39/255.0 alpha:1] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftSubmitBtn];
    
    leftNoSubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNoSubmitBtn.frame = CGRectMake(0, 0, 100, 44);
    
    if ([[InternationalControl userLanguage] isEqualToString:@"en"]) {
//        英文
        
        leftSubmitBtn.frame = CGRectMake(0, 0, 120, 44);
        
         leftNoSubmitBtn.frame = CGRectMake(0, 0, 150, 44);;
    }

    [leftNoSubmitBtn setTitle:noSubmitBtnStr forState:UIControlStateNormal];
    [leftNoSubmitBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftNoSubmitBtn setBackgroundImage:nil forState:UIControlStateNormal];
    leftNoSubmitBtn.tag = leftNoSubmitBtnTag;
    leftNoSubmitBtn.titleLabel.textColor = [UIColor whiteColor];
    
    UIBarButtonItem *fixspace = [[UIBarButtonItem alloc] initWithCustomView:leftNoSubmitBtn];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    fixed.width = -17;
      if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        fixed.width = -20;
        
    }
    else{
        
        fixed.width = -17;
        
    }

    self.navigationItem.leftBarButtonItems = @[fixed,item,fixspace];
    
    
    
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
    //                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    negativeSpacer.width = -20;
    //
    //    self.navigationItem.leftBarButtonItems =[NSArray arrayWithObjects:negativeSpacer, nil] ;
    
}
-(void)leftBtnClick:(UIButton *)btn{
    
    NSLog(@"____btn ==== %@",btn);
    switch (btn.tag) {
        case leftSubmitBtnTag:
        {
            [btn setTitle:LocalizeStringFromKey(@"kLeftSubmitStr") forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:243/255.0 green:94/255.0 blue:39/255.0 alpha:1] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"submittedImg"] forState:UIControlStateNormal];
            
            
            [leftNoSubmitBtn setTitle:LocalizeStringFromKey(@"kLeftNoSubmitStr") forState:UIControlStateNormal];
            [leftNoSubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [leftNoSubmitBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            [self setTfSearch];
            self.submissionView.hidden = YES;
            tvList.hidden = NO;
            
        }
            break;
        case leftNoSubmitBtnTag:
        {
            [btn setTitle:LocalizeStringFromKey(@"kLeftNoSubmitStr") forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor colorWithRed:243/255.0 green:94/255.0 blue:39/255.0 alpha:1] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"noSubmittedImg"] forState:UIControlStateNormal];
            
            
            [leftSubmitBtn setTitle:LocalizeStringFromKey(@"kLeftSubmitStr") forState:UIControlStateNormal];
            [leftSubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [leftSubmitBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [self setSubmittedButton];
            self.submissionView.hidden = NO;
            tvList.hidden = YES;

            [self.submissionView vistWithID:self.visit];
            [self.submissionView.noSubmissionTable reloadData];

            
        }
            break;
        default:
            
            NSAssert(NO, @"leftBtnClick");
            break;
    }
    
    
    
}
//获取理赔状态
- (void)loadClaimStateData{
    @autoreleasepool {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDictionary *dict = [IKDataProvider getClaimStateList:param];
        NSArray *ary = [dict objectForKey:@"data"];
        self.ClaimStateList = [NSMutableArray arrayWithArray:ary];
        sw_dispatch_sync_on_main_thread(^{
        });
        NSLog(@"ClaimState List:%@",dict);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kClaimApplication")];
    [self setNavLeftBtn:LocalizeStringFromKey(@"kLeftSubmitStr") noSubmitBtnStr:LocalizeStringFromKey(@"kLeftNoSubmitStr")];
    [self addBGColor:nil];
    //    [self clearNavBack];
    
    NSLog(@"ClaimStateList--ClaimStateList%@",self.ClaimStateList);
    if(self.ClaimStateList.count !=0){
        applyStatus  = [[[self.ClaimStateList objectAtIndex:0] objectForKey:@"index"] intValue];//默认全部
    }else{
        [self loadClaimStateData];
        if(self.ClaimStateList.count !=0){
            applyStatus  = [[[self.ClaimStateList objectAtIndex:0] objectForKey:@"index"] intValue];//默认全部
        }
    }
    
    
    
    [self setTfSearch];
    
    tvList = [[UITableView alloc] initWithFrame:CGRectZero];
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvList.delegate = self;
    tvList.dataSource = self;
    [self.view addSubview:tvList];
    
    rcList = [[UIRefreshControl alloc] init];
    [rcList addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [tvList addSubview:rcList];
    
    [self creatIKSubmissionView];
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kcRefresh")];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"RefreshNotSubmitClaimsApplyList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTvListAndSubmissionView) name:@"RefreshClaimsApplyList" object:nil]; //可以不需要 应为每次进来都会获取一遍
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUploadInfoClick) name:@"saveUploadInfoSuccess" object:nil];
    netLoadIndex=0;
     NSLog(@"___visitCDSO.providerID______%@",self.visit);
}
-(void)saveUploadInfoClick{
    
    [submissionView vistWithID:nil];
    
}
-(void)refreshTvListAndSubmissionView{

//[submissionView vistWithID:nil];
    
    [submissionView vistWithID:nil];
    
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kcRefresh")];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    
}
-(void)refreshList:(NSNotification *)notification{
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kcRefresh")];
     [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

-(void)creatIKSubmissionView{
    
    self.submissionView = [[IKSubmissionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.frame.size.width,  self.view.frame.size.height)];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//    [self.submissionView setNoSubmissionTableFrame:CGRectMake(-10, 0,self.submissionView.frame.size.width, self.submissionView.frame.size.height)];
//    
//    }
//    else{
//
//    [self.submissionView setNoSubmissionTableFrame:CGRectMake(-10, 0, self.view.frame.size.height,  self.submissionView.frame.size.width-20)];
//    
//    }
    self.submissionView.hidden = YES;

//    _visitAry= [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].selectArray;

    self.submissionView.userInteractionEnabled = YES;
    _visitAry= [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].selectArray;

    self.submissionView.delegate = self;
    [self.view addSubview:self.submissionView];
    
}
#pragma mark -
#pragma mark - IKSubmissionViewDelegate
- (void)submissionView:(IKSubmissionView *)submissionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath visitCDSO:(IKVisitCDSO *)visitCDSO{
    IKApplyClaimsViewController *vcApplyClaims = [[IKApplyClaimsViewController alloc] init];
    vcApplyClaims.visit = visitCDSO;
   
    [self.navigationController pushViewController:vcApplyClaims animated:NO];
    
    
}
-(void)setTfSearch{
    
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
    tfSearch.placeholder = [NSString stringWithFormat:@"%@ / %@",LocalizeStringFromKey(@"kClient"),LocalizeStringFromKey(@"kcDate")];
    tfSearch.returnKeyType = UIReturnKeySearch;
    [v addSubview:tfSearch];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:v];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    fixed.width = -10;
    self.navigationItem.rightBarButtonItems = @[fixed,item];
    
    
    
    
}
#pragma mark - 4,2号
- (NSString *)reportImgFor:(NSArray *)arrar{
    if (arrar.count>0){
        NSMutableString *mutstr = [NSMutableString string];
        for (IKPhotoCDSO *PhotoCDSO in arrar){
            NSString *seqID =PhotoCDSO.seqID;
            NSString *type = [NSString stringWithFormat:@"%@", PhotoCDSO.type];
            NSString *str =[NSString stringWithFormat:@"%@!@%@",seqID,type];
            if (seqID.length>0){
                if (mutstr.length>0){
                    [mutstr appendString:@","];
                }
                [mutstr appendString:str];
            }
        }
        
        return mutstr.length>0?mutstr:nil;
    }else
        return nil;
}
- (NSString *)reportImg:(NSArray *)arrar{
    if (arrar.count>0){
        NSMutableString *mutstr = [NSMutableString string];
        for (IKPhotoCDSO *PhotoCDSO in arrar){
            NSString *seqID = PhotoCDSO.seqID;
            if (seqID.length>0){
                if (mutstr.length>0)
                    [mutstr appendString:@","];
                [mutstr appendString:seqID];
            }
        }
        
        return mutstr.length>0?mutstr:nil;
    }else
        return nil;
}
-(void)submitBtnClick:(UIButton *)btn{
    
    netLoadIndex=0;
    IKVisitCDSO *dict =[self visitArray:netLoadIndex];
    if (dict==nil) {
        return;
    }
    [self updateClicked:dict];

}
-(IKVisitCDSO *)visitArray:(NSInteger)index{
    if ([_visitAry count] ==0) {
        return nil;
    }
    IKVisitCDSO *dict =[_visitAry objectAtIndex:index];
    return dict;
}
- (void)updateClicked:(IKVisitCDSO *)visitD{
    _visitCDSOTemp =visitD;
    if (![IKDataProvider canEditClaims]) {
        [UIAlertView showAlertWithTitle:nil message:@"您没有权限进行此项操作" cancelButton:nil];
        [SVProgressHUD dismiss];
        return;
    }
    NSInvocationOperation *invocationOperation =[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadStatus) object:nil];
    sleep(0.1);
    [invocationOperation setCompletionBlock:^{
        [self loadPhoto:visitD];
    }];
    [invocationOperation start];
}
-(void)loadStatus{
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kSubmitingClaim")];
}
-(void)loadPhoto:(IKVisitCDSO *)visitD{
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString*   access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [mut setObject:access_token forKey:@"key"];
    [mut setObject:visitD.visitID forKey:@"visitId"];
    [mut setObject:visitD.depID forKey:@"depID"];
    [mut setObject:visitD.memberID forKey:@"memberID"];
    [mut setObject:visitD.providerID forKey:@"providerID"];
    //左侧信息
    [mut setValuesForKeysWithDictionary:visitD.authInfoDic];
    //开始日期
    [mut setObject:visitD.beginDate  forKey:@"beginDate"];
    //结束日期
    [mut setObject:visitD.endDate forKey:@"endDate"];
    //就诊费用
    [mut setObject:visitD.visitExpenses forKey:@"visitExpenses"];
    //就诊类别
    if (visitD.serviceType.intValue == 1) {
        visitD.serviceType =[NSNumber numberWithInt:3];
        
    }else if (visitD.serviceType.intValue == 3) {
        visitD.serviceType =[NSNumber numberWithInt:1];
    }
    [mut setObject:[NSString stringWithFormat:@"%@",visitD.serviceType ]  forKey:@"visitType"];
    //病例和发票
    self.aryReportImages =[NSMutableArray array];
    for(int i =0;i<[visitD.photoList count];i++){
        IKPhotoCDSO *photoCDTemp =[visitD.photoList objectAtIndex:i];
        int typePhoto =[photoCDTemp.type intValue];
        if (typePhoto ==IKPhotoTypeInsuranceCard ||typePhoto ==IKPhotoTypeClaimClaimsPaymentList ||typePhoto ==IKPhotoTypeClaimClaimsOtherList) {
            [self.aryReportImages addObject:photoCDTemp];
        }
    }
    [self loadOnePhoto:visitD mut:mut ary:self.aryReportImages];
    
    //    [SVProgressHUD showWithStatus:@"正在提交理赔信息"];
    if ([self checkPhotoAllSuccess].count >0) {
        index ++;
        if (index>1) {
            sw_dispatch_sync_on_main_thread(^{
                if (self.aryReportImages.count>0) {
                    for (int i=0;i<self.aryReportImages.count;i++){
                        IKPhotoCDSO *photoCD =[self.aryReportImages objectAtIndex:i];
                        IKPhotoCDSO *photoCD1 =[IKPhotoCDSO photoWithSeqID:photoCD.seqID];
                        if (photoCD1.uploaded.intValue==1) {
                            photoCD1.uploaded =NO;
                        }
                    }
                }
            });
            return;
        }
        [self loadOnePhoto:visitD mut:mut ary:[self checkPhotoAllSuccess]];
    }
    [NSThread detachNewThreadSelector:@selector(submitApply:) toTarget:self withObject:mut];

}
-(void)loadOnePhoto:(IKVisitCDSO *)visitD mut:(NSMutableDictionary*)mut ary:(NSMutableArray *)ary{
    
        NSMutableArray *arr =[NSMutableArray array];
        for(int i =0;i<[ary count];i++){
            IKPhotoCDSO *photoCDTemp =[ary objectAtIndex:i];
            int typePhoto =[photoCDTemp.type intValue];
            if (typePhoto ==IKPhotoTypeInsuranceCard ||typePhoto ==IKPhotoTypeClaimClaimsPaymentList ||typePhoto ==IKPhotoTypeClaimClaimsOtherList) {
//                [self.aryReportImages addObject:photoCDTemp];
                [arr addObject:photoCDTemp];
            }
        }
        
        [mut setObject:[self reportImg:self.aryReportImages]?[self reportImg:self.aryReportImages]:@"" forKey:@"reportImg"];
        if (arr.count>0) {
//            for (int i=0;i<self.aryReportImages.count;i++)
            for (int i=0;i<arr.count;i++){
        @autoreleasepool {
            
            NSMutableDictionary *mutPicture =[NSMutableDictionary dictionary];
            IKPhotoCDSO *photoCD =[arr objectAtIndex:i] ;//上传图片参=[aryReportImages objectAtIndex:i];
            if(photoCD ==nil){
                return;
            }
            NSDate *date = photoCD.createTime;
            if (!date) {//当不存在时间表示是网上留下的图
                continue;
            }
            NSString *seqID = photoCD.seqID;
            if(seqID ==nil){
                break;
            }
            [mutPicture setObject:seqID forKey:@"seqID"];
            
            //                    NSString *imagePath = [[aryReportImages objectAtIndex:i] objectForKey:@"photoPath"];
            UIImage *img = photoCD.image;//图片
            
            NSDateFormatter *formatter_update = [[NSDateFormatter alloc] init];
            [formatter_update setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            [mutPicture setObject:[formatter_update stringFromDate:date] forKey:@"createTime"];//拍摄时间
            [mutPicture setObject:[formatter_update stringFromDate:[NSDate date]]  forKey:@"modifyTime"];//修改时间
            NSNumber *type = photoCD.type;
            
            [mutPicture setObject:visitD.depID forKey:@"depID"];
            [mutPicture setObject:visitD.memberID forKey:@"memberID"];
            [mutPicture setObject:visitD.providerID forKey:@"providerID"];
            [mutPicture setObject:[NSString stringWithFormat:@"%@",type] forKey:@"type"];//在线理赔病历照 = 4
            
            NSData *data = UIImageJPEGRepresentation(img,1.0);// uiimage 转 nsdata
            NSString *base64String = [data base64Encoding];//base64转码
            if (base64String){
                [mutPicture setObject:base64String forKey:@"photoPath"];
                
                BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@[mutPicture],@"data",@"1",@"count",(isInLocal?@"1":@"0"),@"internetType",nil];
                NSDictionary *dict = [IKDataProvider syncPhoto:param];
                NSString *result = [dict objectForKey:@"result"];
                int j = i+1;
                sw_dispatch_sync_on_main_thread(^{
                if (result && result.intValue==0){
                    //  成功上传
                    NSLog(@"上传第 %d 张图片成功",j);
                        photo = [IKPhotoCDSO photoWithSeqID:seqID];//查看coredata看看是否存在图片 如果存在只修改modifyTime
                        if (!photo){
                            
                            photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];//添加图片
                            photo.seqID = seqID;
                            if (self.visit) {//与visit关联
                                photo.visit = self.visit;
                                
                            }else {
                                IKAppDelegate *delegate =    (IKAppDelegate *)[UIApplication sharedApplication].delegate;
                                photo.visit = delegate.visit;
                                
                            }
                            photo.createTime = date;
                            photo.image = img;
                            photo.type = [NSNumber numberWithInt:IKPhotoTypeInsuranceCard];
                            photo.type = type;
                        }
                        NSArray *dataAry =[dict objectForKey:@"data"];
                        if ([dataAry count]>0) {
                            NSString *imgPath =[[dataAry objectAtIndex:0] objectForKey:@"imagePath"];
                            if (imgPath ==nil ||imgPath.length ==0) {
                                photo.uploaded =[NSNumber numberWithBool:NO];
                            }else{
                                photo.uploaded =[NSNumber numberWithBool:YES];
                            }
                        }
                        photo.modifyTime = [NSDate date];
                        
                    
                }
                else{
                    NSLog(@"上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]);
                    photo.uploaded =[NSNumber numberWithBool:NO];
                }
                 [[IKDataProvider managedObjectContext] save:nil];
                });
            }
        }
    }
}
}

-(NSMutableArray *)checkPhotoAllSuccess{
    NSMutableArray *ary =[NSMutableArray array];
     sw_dispatch_sync_on_main_thread(^{
    if (self.aryReportImages.count>0) {
        for (int i=0;i<self.aryReportImages.count;i++){
            IKPhotoCDSO *photoCD =[self.aryReportImages objectAtIndex:i];
            IKPhotoCDSO *photoCD1 =[IKPhotoCDSO photoWithSeqID:photoCD.seqID];
            if (photoCD1.uploaded.intValue==0) {
                [ary addObject:photoCD1];
            }
        }
    }
});
  
    return ary;
}
- (void)submitApply:(NSDictionary *)info{
    NSString *reportImgStr =[NSString stringWithFormat:@"%@",[info objectForKey:@"reportImg"]];
    NSMutableDictionary *dictTemp =[NSMutableDictionary dictionary];
    if (reportImgStr ==nil ||reportImgStr.length==0) {
        [dictTemp addEntriesFromDictionary:info];
    }else{
        [dictTemp addEntriesFromDictionary:info];
        [dictTemp setObject:[self reportImgFor:self.aryReportImages]?[self reportImgFor:self.aryReportImages]:@"" forKey:@"reportImg"];
    }
    
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider getClaimInsert:dictTemp];
        sw_dispatch_sync_on_main_thread(^{
            int result = [[dict objectForKey:@"result"] intValue];
            if (0==result && dict){
                
            photo.uploaded = [NSNumber numberWithBool:YES];
                if (_visitCDSOTemp) {//与visit关联
                    
                    _visitCDSOTemp.claimEditHistory = [NSNumber numberWithBool:YES];
                }else {
                IKAppDelegate *delegate =    (IKAppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.visit.claimEditHistory = [NSNumber numberWithBool:YES];
                }
                
                [self changeDataBaseType:_visitCDSOTemp];
                [SVProgressHUD showSuccessWithStatus:LocalizeStringFromKey(@"kSuccessClaim")];
                [self commitStatus];
            }else{
                
                photo.uploaded = [NSNumber numberWithBool:NO];
                NSLog(@"API Failed:%@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:info options:0 error:nil] encoding:NSUTF8StringEncoding]);
                [self commitStatus];
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"提交理赔授权信息失败:%@",[dict objectForKey:@"errStr"]]];
            }
            
            NSError *error = nil;
            [[IKDataProvider managedObjectContext] save:&error];
        });
        
    }
}
-(void)changeDataBaseType:(IKVisitCDSO *)visitCDSO{
    
    visitCDSO.uploaded = YES;

    [[IKDataProvider managedObjectContext] save:nil];
    
    
}
-(void)commitStatus{
    netLoadIndex++;
    if (netLoadIndex >[_visitAry count]-1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNotSubmitClaimsApplyList" object:photo.uploaded];
        return;
    }
    IKVisitCDSO *dict =[self visitArray:netLoadIndex];
    if (dict ==nil) {
        return;
    }
    [self updateClicked:dict];
}
-(void)setSubmittedButton{
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 5, 76, 33);
    
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:LocalizeStringFromKey(@"kBatchSubmission") forState:UIControlStateNormal];
    [submitBtn setTitle:LocalizeStringFromKey(@"kBatchSubmission") forState:UIControlStateHighlighted];
    [submitBtn setTitleColor:[UIColor colorWithRed:244.0/255.0  green:138.0/255.0 blue: 78.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor colorWithRed:244.0/255.0  green:138.0/255.0 blue: 78.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];

    [submitBtn setBackgroundImage:[UIImage imageNamed:@"submittedButtonImg"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"submittedButtonImg"] forState:UIControlStateHighlighted];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    fixed.width = -10;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        fixed.width = -10;
        
    }
    else{
        
        fixed.width = 0;
        
    }

    self.navigationItem.rightBarButtonItems = @[fixed,item];
    
    
    
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
        
        [param setObject:[NSString stringWithFormat:@"%d",dCurrentPage] forKey:@"pageNo"];//页码
        NSDictionary *dict = [IKDataProvider getClaimList:param];
        
        NSArray *ary = [dict objectForKey:@"data"];
        aryList = [NSMutableArray arrayWithArray:ary];
        
        sw_dispatch_sync_on_main_thread(^{
            [SVProgressHUD dismiss];
            [tvList reloadData];
            
            [rcList endRefreshing];
        });
        
        NSLog(@"Claim List:%@",dict);
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
        [param setObject:[NSString stringWithFormat:@"%d",applyStatus] forKey:@"status"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (dateStart)
            [param setObject:[formatter stringFromDate:dateStart] forKey:@"startDate"];
        if (dateEnd)
            [param setObject:[formatter stringFromDate:dateEnd] forKey:@"endDate"];
        [param setObject:[NSString stringWithFormat:@"%d",dCurrentPage+1] forKey:@"pageNo"];
        
        NSDictionary *dict = [IKDataProvider getClaimList:param];
        
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



- (void)headerClicked:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            imgvArrowTime.transform = CGAffineTransformMakeRotation(M_PI);
            [IKDateRangeSelector showAtPoint:CGPointMake(125, 105) delegate:self];
            break;
        case 3:
            imgvArrowStatus.transform = CGAffineTransformMakeRotation(M_PI);
            [IKClaimsStateSelector showAtPoint:CGPointMake(675,105) states:self.ClaimStateList  delegate:self];
            break;
            
        default:
            break;
    }
}

- (void)viewWillLayoutSubviews{
    tvList.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    submissionView.frame = CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.submissionView.noSubmissionTable setFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    else{
        
        [self.submissionView.noSubmissionTable setFrame:CGRectMake(0, 0, self.view.frame.size.height,  self.view.frame.size.width)];
        
    }
}

- (void)keywordChanged{
    [SVProgressHUD showWithStatus:@"正在搜索，请稍候"];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)refresh{
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}



#pragma mark - UITableView Data Source & Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AuthListIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        float x = 0;
        
        for (int i=0;i<5;i++){
            float w = widths[i]*tableView.frame.size.width;
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
    
    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:101];
    UILabel *lblID = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *lblStatus = (UILabel *)[cell.contentView viewWithTag:103];
    UILabel *lblcategray = (UILabel *)[cell.contentView viewWithTag:104];
    
    
    
    NSDictionary *info = [aryList objectAtIndex:indexPath.row];
    
    lblDate.text = [info objectForKey:@"submitDate"];
    lblName.text = [info objectForKey:@"memberName"];
    lblID.text = [info objectForKey:@"claimsNo"];
    lblStatus.text = [info objectForKey:@"status"];
    lblcategray.text = [info objectForKey:@"visitType"];
    
    
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
    
    //    NSArray *titles = [@"申请时间,客户姓名,申请编号,状态,就诊类别" componentsSeparatedByString:@","];
    
    NSArray *titles = @[LocalizeStringFromKey(@"kApplyDate"),
                        LocalizeStringFromKey(@"kClient"),
                        LocalizeStringFromKey(@"kcDate"),
                        LocalizeStringFromKey(@"kStatus"),
                        LocalizeStringFromKey(@"kTreatmentType")];
    for (int i=0;i<5;i++){
        float w = widths[i]*v.frame.size.width;
        
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(i==4?x-10:x, 0, w, 48) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
        if (i==4) {
            lbl.textAlignment = NSTextAlignmentLeft;
        }else{
            lbl.textAlignment = NSTextAlignmentCenter;
        }
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
    if ([aryList count]==0) {
        return;
    }
    NSDictionary *dict = [aryList objectAtIndex:indexPath.row];
    if (dict ==nil ||[dict objectForKey:@"claimsNo"] ==nil) {
        return;
    }
    NSString *claimsNo = [dict objectForKey:@"claimsNo"];
//    NSString *claimsStateIndex = [dict objectForKey:@"index"];
    
    IKApplyClaimsViewController *vcApplyClaims = [[IKApplyClaimsViewController alloc] init];
    
    vcApplyClaims.claimsNo = claimsNo;
    //vcApplyClaims.claimStatus =claimsState;
//    vcApplyClaims.claimStatusIndex
    [self.navigationController pushViewController:vcApplyClaims animated:NO];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    int lines = aryList.count;
    if ((scrollView.contentOffset.y+scrollView.frame.size.height)>lines*48 && aryList.count>0 && aryList.count%20==0)
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNotSubmitClaimsApplyList" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
