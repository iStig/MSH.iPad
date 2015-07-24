//
//  IKApplyClaimsViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyClaimsViewController.h"
#import "IKShootingView.h"
#import "IKAddRecordsPhotoView.h"

#define SHOOTINGVIEWTAG    1000

@interface IKApplyClaimsViewController ()
{
     NSDictionary *dicApplyInfo;
}
@end

@implementation IKApplyClaimsViewController
@synthesize claimsNo,dicAuthInfo,otherVisitInfo,claimStatus;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addBGColor:nil];
   
    

    vDetail = [[IKApplyClaimsDetailView alloc] initWithFrame:CGRectMake(285, 0, 1024-285-42, 768-20)];
    vDetail.vcApplyClaims = self;
    vDetail.visit = self.visit;
    vDetail.key =self.key;
    vDetail.otherVisitInfo = otherVisitInfo;
    vDetail.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];
    [self.view addSubview:vDetail];
    [vDetail showInfo];
    
    vLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 285, 768-20-44)];
    vLeft.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:vLeft];
    
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKNavBGApplyAuth.png"]];
    [self.view addSubview:imgv];
    
    
    UILabel *lblNavBar = [UILabel createLabelWithFrame:CGRectMake(0, 0, vLeft.frame.size.width, 44) font:[UIFont boldSystemFontOfSize:20] textColor:[UIColor whiteColor]];
    lblNavBar.textAlignment = NSTextAlignmentCenter;
    lblNavBar.text =LocalizeStringFromKey(@"kClaimApplication");
    [self.view addSubview:lblNavBar];
    
    UIButton *btnNavBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNavBack setImage:[UIImage imageNamed:@"IKButtonNavBack.png"] forState:UIControlStateNormal];
    [btnNavBack sizeToFit];
    [btnNavBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    btnNavBack.center = CGPointMake(34, 22);
    [self.view addSubview:btnNavBack];
    
//    NSArray *titles = [@"医院名称,患者姓名,联系电话,邮寄地址,电子邮箱" componentsSeparatedByString:@","];
    
    NSArray *titles = @[LocalizeStringFromKey(@"kProvidername"),
                           LocalizeStringFromKey(@"kPatientName"),
                           LocalizeStringFromKey(@"kTelephone"),
                           LocalizeStringFromKey(@"kAddress"),
                           LocalizeStringFromKey(@"kEmail")];
    NSArray *keys = [@"providerName,patientName,patientPhone,address,email" componentsSeparatedByString:@","];
    NSArray *shootingTitles = @[LocalizeStringFromKey(@"kShootingRecords"),
                        LocalizeStringFromKey(@"kShootingPayDetail"),
                        LocalizeStringFromKey(@"kShootingOther")];
    NSString *str =[NSString stringWithFormat:@"%@0%@", LocalizeStringFromKey(@"kShootingFinished"),LocalizeStringFromKey(@"kPcs")];
    NSArray *shootingPhotos = [NSArray arrayWithObjects:@"shooting_records",@"shooting_pay",@"shooting_Other", nil];
    NSArray *type = [NSArray arrayWithObjects:[NSNumber numberWithInteger: claimTypeShootingRecords],[NSNumber numberWithInteger:claimTypeShootingPayDetail],[NSNumber numberWithInteger:claimTypeShootingOther], nil];
    float x = 28;
    float y = 0;
    float w = vLeft.frame.size.width-x;
    for (int i=0;i<titles.count;i++){
       float h = 46;
        IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(x, y, w, h) title:[titles objectAtIndex:i] textColor:[UIColor colorWithRed:231.f/255.f green:107.f/255.f blue:35.f/255.f alpha:1]];
        input.lineColor = [UIColor colorWithWhite:.84 alpha:1];
        input.key = [keys objectAtIndex:i];
        [vLeft addSubview:input];
        y += h;
        
        if (0==i){
            input.userInteractionEnabled = NO;
            input.inputField.text = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerNameCNH"];
        }
     
        if (visit) {
              if (1==i){
             input.userInteractionEnabled = NO;
             input.inputField.text = [visit.detailInfo objectForKey:@"memberName"];
              }
            
            if (i==2){
               input.userInteractionEnabled = YES;
                input.inputField.text = [visit.authInfoDic objectForKey:@"patientPhone"];
            }
            if (i==3){
                input.userInteractionEnabled = YES;
                input.inputField.text = [visit.authInfoDic objectForKey:@"address"];
            }
            if (i==4){
                input.userInteractionEnabled = YES;
                input.inputField.text = [visit.authInfoDic objectForKey:@"email"];
            }
           
        }
        else{
         input.userInteractionEnabled = NO;
        
        }
      
    }
    
    float height =46*titles.count +300;
    for (int j=0;j<shootingTitles.count;j++){
        float d =50;
//        NSInteger type;
//        claimTypeShootingPayDetail,
//        claimTypeShootingOther
        
//        type=claimTypeShootingRecords;
        NSInteger tt =[[type objectAtIndex:j] integerValue];
       IKShootingView  *shootingView = [[IKShootingView alloc] initWithFrame:CGRectMake(x, height, w, d) title:[shootingTitles objectAtIndex:j] shootingPagesTextColor:[UIColor colorWithRed:231.f/255.f green:107.f/255.f blue:35.f/255.f alpha:1] shootingPagesText:str photoImgName:[shootingPhotos objectAtIndex:j]claimType:tt  visit:self.visit];
        shootingView.delegate= self;
        shootingView.lineColor = [UIColor colorWithWhite:.84 alpha:1];
        shootingView.key = [keys objectAtIndex:j];
        shootingView.claimsNo =claimsNo;
        shootingView.visit =self.visit;
        [shootingView setTag:SHOOTINGVIEWTAG+j];
        shootingView.otherVisitInfo =otherVisitInfo;
        [vLeft addSubview:shootingView];
        
        height += d;
        
    }

    if (self.claimsNo){
        [SVProgressHUD showWithStatus:@"正在获取申请详情"];
        [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    }
    
    
    [self vistWithID:nil];

}

//IKPhotoTypeInsuranceCard,
//IKPhotoTypeClaimClaimsPaymentList,
//IKPhotoTypeClaimClaimsOtherList,
- (void)loadData{
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider getClaimDetail:[NSDictionary dictionaryWithObjectsAndKeys:self.claimsNo,@"claimsNo", nil]];
        
        NSLog(@"Claim Detail:%@",dict);
        sw_dispatch_sync_on_main_thread(^{
            dicAuthInfo = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]];
        
           self.claimStatus = [dicAuthInfo objectForKey:@"status"];
            
            [SVProgressHUD dismiss];
            [self showInfo];
            [vDetail showInfo:dicAuthInfo];
            [self getSelectArrWithDictionary:dicAuthInfo];
            for (int i =0; i<3; i++) {
                IKShootingView *shView =(IKShootingView *)[self.view viewWithTag:SHOOTINGVIEWTAG+i];
                shView.photoStatus =self.claimStatus;
                [shView showInfo:dicAuthInfo];
            }
            
        });
    }
}



- (NSDictionary *)authInfo{

    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    BOOL finished = YES;
    
    for (IKInputView *v in vLeft.subviews){
        if ([v isKindOfClass:[IKInputView class]]){
            if (v.text && v.text.length>0)
                [info setObject:v.text forKey:v.key];
            else{
                [info setObject:@"" forKey:v.key];//提交理赔申请界面的患者姓名自动带出，联系电话，邮寄地址，电子邮箱是非必填项
//                if (YES){
//                    finished = NO;
//                    break;
//                }
            }
        }
    }



    if (finished)//如果填写完整则输出
        return info;
    else
        return nil;
    
    
    
    
}
-(void)vistWithID:(NSString *)visit{
  //  NSArray *imgArr = [self.visit.photos allObjects];
     NSArray *imgArr = self.visit.getShootingPhotoList;
    NSMutableArray *photoArr = [NSMutableArray array];
    for (int i = 0; i<imgArr.count; i++) {
        IKPhotoCDSO *photo = [imgArr objectAtIndex:i];
        
            [photoArr addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:photo.createTime,@"date",photo.image,@"image",photo.seqID,@"seqID",photo.type,@"type", nil]];
        
        
        
    }
    self.selectArr =photoArr;

}


- (void)getSelectArrWithDictionary:(NSDictionary *)info{
    
    
    NSMutableArray *photoArr = [NSMutableArray arrayWithArray:[info objectForKey:@"reportImgDetail"]];
     self.selectArr =photoArr;
}

#pragma mark -
#pragma mark - IKShootingViewDelegate
- (void)selectImageArr:(NSArray *)allImgArr{

    self.selectArr = allImgArr;
    
}
- (NSArray *)selectImgArr{
    NSArray *arr = [NSArray array];
    arr = self.selectArr;
    return arr;

}
- (void)showInfo{
//
//    if (!dicAuthInfo){
//        vLeft.userInteractionEnabled = NO;
//        return;
//    }else
//        vLeft.userInteractionEnabled = YES;
    
//    vLeft.userInteractionEnabled = NO;
    
    for (IKInputView *iv in vLeft.subviews){
        if ([iv isKindOfClass:[IKInputView class]]){
         
            iv.inputField.text = [dicAuthInfo objectForKey:iv.key];
        }
    }
    

}

- (void)resignTextFieldInFirstResponse{


    for (IKInputView *iv in vLeft.subviews){
        if ([iv isKindOfClass:[IKInputView class]]){
            [iv.inputField resignFirstResponder];
        }
    }


}


- (void)navBack{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
