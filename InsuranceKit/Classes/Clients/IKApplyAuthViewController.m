//
//  IKApplyAuthViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKApplyAuthViewController.h"
#import "IKPhotoCDSO.h"
#import "IKDecodeWithUTF8.h"
@interface IKApplyAuthViewController ()

@end

@implementation IKApplyAuthViewController
@synthesize dicAuthInfo,CaseId,aryReportImages;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavTitle:LocalizeStringFromKey(@"kPreAuthapply")];
    [self addBGColor:nil];
    [self addNavBack];
    
    aryReportImages = [NSMutableArray array];
    
    self.dicAuthInfo = [NSMutableDictionary dictionary];
    
    vDetail = [[IKApplyDetailView alloc] initWithFrame:CGRectMake(285, 0, 1024-285-42, 768-20)];
    vDetail.vcApplyAuth = self;
    vDetail.visit = self.visit;
    vDetail.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];
    [self.view addSubview:vDetail];
    

    
    
    vLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 285, 768-20-44)];
    vLeft.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:vLeft];
    
    
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKNavBGApplyAuth.png"]];
    [self.view addSubview:imgv];
    
    UILabel *lblNavBar = [UILabel createLabelWithFrame:CGRectMake(0, 0, vLeft.frame.size.width, 44) font:[UIFont boldSystemFontOfSize:20] textColor:[UIColor whiteColor]];

    lblNavBar.textAlignment = NSTextAlignmentCenter;
    lblNavBar.text = LocalizeStringFromKey(@"kPreAuthapply");
    [self.view addSubview:lblNavBar];
    
    UIButton *btnNavBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNavBack setImage:[UIImage imageNamed:@"IKButtonNavBack.png"] forState:UIControlStateNormal];
    [btnNavBack sizeToFit];
    [btnNavBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    btnNavBack.center = CGPointMake(34, 22);
    [self.view addSubview:btnNavBack];

    NSArray *keys = [@"providerNameCNH,doctor,medContacts,medPhone,medFax,medEmail,memberName,patientPhone,diagnosis,medicalHistory" componentsSeparatedByString:@","];
//    NSArray *titles = [@"医院名称：,主治医生：,医院联系人：,医院电话：,医院传真：,医院邮件：,患者姓名：,患者电话：,医疗诊断：,既往病史：" componentsSeparatedByString:@","];
    
        NSArray *titles = @[LocalizeStringFromKey(@"kProvidername"),
                            LocalizeStringFromKey(@"kDoctor"),
                            LocalizeStringFromKey(@"kBProviderContact"),
                            LocalizeStringFromKey(@"kProviderTel"),
                            LocalizeStringFromKey(@"kProviderFax"),
                            LocalizeStringFromKey(@"kProviderEmail"),
                            LocalizeStringFromKey(@"kPatientName"),
                            LocalizeStringFromKey(@"kPatientTel"),
                            LocalizeStringFromKey(@"kDiagnosis"),
                            LocalizeStringFromKey(@"kMedicalhistory")];
    
    float x = 28;
    float y = 0;
    float w = vLeft.frame.size.width-x;
    
    for (int i=0;i<keys.count;i++){
        float h = 0==i?56:42;
        if (6==i)
            y = 450;
        IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(x, y, w, h) title:[titles objectAtIndex:i]];
        input.lineColor = [UIColor colorWithWhite:.84 alpha:1];
        input.key = [keys objectAtIndex:i];
        [vLeft addSubview:input];
        y += h;
        
        if (0==i)
            input.userInteractionEnabled = NO;
        
        if (i<2){
            input.inputField.text = [[IKDataProvider currentHospitalInfo] objectForKey:[keys objectAtIndex:i]];
        }
        else
            input.inputField.text = [self.visit.detailInfo objectForKey:[keys objectAtIndex:i]];
        
        NSString *correctKey = nil;
        switch (i) {
            case 3:correctKey = @"hospitalTel";input.inputField.keyboardType = UIKeyboardTypeNumberPad;break;
            case 4:correctKey = @"hospitalFax";input.inputField.keyboardType = UIKeyboardTypeNumberPad;break;
            case 5:correctKey = @"hospitalEmail";break;
            case 7:input.inputField.keyboardType = UIKeyboardTypeNumberPad;break;
            default:
                break;
        }
        
        if (correctKey && !self.CaseId)
            input.inputField.text = [[IKDataProvider currentHospitalInfo] objectForKey:correctKey];

        
        [input determineNecessary:nil];
        
    }
    
    NSString *name = nil;
    NSString *language = [InternationalControl userLanguage];
    if ([language isEqualToString:@"en"])
        name = @"IKViewApplyCaptureEn";
    else
        name = @"IKViewApplyCapture";
    
    UIButton *btnAddRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddRecord setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btnAddRecord sizeToFit];
    btnAddRecord.center = CGPointMake(vLeft.frame.size.width/2, 362);
    [btnAddRecord addTarget:self action:@selector(addRecordClicked) forControlEvents:UIControlEventTouchUpInside];
    [vLeft addSubview:btnAddRecord];
    
//    lblPhotoNum = [UILabel createLabelWithFrame:CGRectMake(153, 370, btnAddRecord.frame.size.width, 60) font:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithRed:.99 green:.45 blue:.25 alpha:1]];
    
    lblPhotoNum = [[UITextView alloc] initWithFrame:CGRectMake(147, 370, btnAddRecord.frame.size.width/2, 60)];
    lblPhotoNum.editable = NO;
    lblPhotoNum.font =[UIFont systemFontOfSize:15];
    lblPhotoNum.textColor = [UIColor colorWithRed:.99 green:.45 blue:.25 alpha:1];
    lblPhotoNum.backgroundColor = [UIColor clearColor];
    lblPhotoNum.textAlignment =NSTextAlignmentLeft;
    lblPhotoNum.text = [NSString stringWithFormat:@"%@(%d%@)",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),0,LocalizeStringFromKey(@"kPcs")];
    [vLeft addSubview:lblPhotoNum];
    
    
    if (self.CaseId){
        [SVProgressHUD showWithStatus:@"正在获取申请详情"];
        [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    }
    
}

- (void)loadData{
    @autoreleasepool {
        
    BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
        NSDictionary *dict = [IKDataProvider getAuthDetail:[NSDictionary dictionaryWithObjectsAndKeys:self.CaseId,@"CaseId",(isInLocal?@"1":@"0"),@"internetType", nil]];
        
        NSLog(@"Auth Detail:%@",dict);
        sw_dispatch_sync_on_main_thread(^{
            dicAuthInfo = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"data"]];
            aryReportImages = [NSMutableArray arrayWithArray:[dicAuthInfo objectForKey:@"reportImgDetail"]];
            
            for (NSDictionary *photoInfo in aryReportImages){
                NSString *imagePath = [photoInfo objectForKey:@"imagePath"];
                  NSString *urlStr = [IKDecodeWithUTF8 getDecodeWithUTF8:imagePath];
                NSString *seqID = [photoInfo objectForKey:@"seqID"];
                
                sw_dispatch_sync_on_main_thread(^{
                    if (![[NSFileManager defaultManager] fileExistsAtPath:[seqID imageCachePath]]){
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
                        [data writeToFile:[seqID imageCachePath] atomically:NO];
                    }
                });
            }
            
            
            [SVProgressHUD dismiss];
            [self showInfo];
            [vDetail showInfo:dicAuthInfo];
        });
    }
}

- (void)showInfo{
    BOOL isPad = [[dicAuthInfo objectForKey:@"isPad"] isEqualToString:@"Y"];
    int status = [[dicAuthInfo objectForKey:@"status"] intValue];
    BOOL canEdit = isPad && (status==2 || status==4);
    
    vLeft.userInteractionEnabled = canEdit;
    
    for (IKInputView *iv in vLeft.subviews){
        if ([iv isKindOfClass:[IKInputView class]]){
            iv.inputField.text = [dicAuthInfo objectForKey:iv.key];
        }
    }
    
    lblPhotoNum.text = aryReportImages.count>0?[NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),aryReportImages.count,LocalizeStringFromKey(@"kPcs")]:nil;
}

- (void)uploadApply:(NSDictionary *)applyInfo{
    
}

- (NSDictionary *)authInfo{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    
    BOOL finished = YES;
    
    for (IKInputView *v in vLeft.subviews){
        if ([v isKindOfClass:[IKInputView class]]){
            if (v.text && v.text.length>0)
                [info setObject:v.text forKey:v.key];
            else{
                [info setObject:@"" forKey:v.key];
                if (v.necessary){
                    finished = NO;
                    break;
                }
            }
        }
    }
    
    
    if ([self reportImg])
        [info setObject:[self reportImg] forKey:@"reportImg"];
    
    if (finished)
        return info;
    else
        return nil;
}

- (NSString *)reportImg{
    if (aryReportImages.count>0){
        NSMutableString *mutstr = [NSMutableString string];
        for (NSDictionary *dict in aryReportImages){
            NSString *seqID = [dict objectForKey:@"seqID"];
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

- (void)viewWillLayoutSubviews{

}

- (void)navBack{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)resignTextFieldInFirstResponse{
    
    
    for (IKInputView *iv in vLeft.subviews){
        if ([iv isKindOfClass:[IKInputView class]]){
            [iv.inputField resignFirstResponder];
        }
    }
    
    
}

- (void)addRecordClicked{
    
    [self resignTextFieldInFirstResponse];
    [vDetail.tfExpenses resignFirstResponder];
    
    IKAddRecordsPhotoView *v = [IKAddRecordsPhotoView view];
    v.delegate = self;
    v.dicVisitInfo = dicAuthInfo;
    v.visit = self.visit;
    v.aryList = [NSMutableArray arrayWithArray:aryReportImages];
    v.vcParent = self;
    
    [v show];
    
}



#pragma mark - IKAddRecordsPhotoViewDelegate
- (void)recordsAdded:(NSArray *)photos{
//    for (int i=0;i<photos.count;i++){
//        NSDate *date = [[photos objectAtIndex:i] objectForKey:@"date"];
//        
// 
//        NSString *seqID = [[photos objectAtIndex:i] objectForKey:@"seqID"];
//
//        
//        IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
//        if (!photo){
//            NSString *imagePath = [[photos objectAtIndex:i] objectForKey:@"photoPath"];
//            UIImage *img = [[photos objectAtIndex:i] objectForKey:@"image"];
//            
//            if (!img && imagePath.length>0){
//                //  说明图片是在服务器上不在本地的
//                continue;
//            }
//            
//            photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
//            photo.seqID = seqID;
//            photo.visit = self.visit;
//            photo.createTime = date;
//            photo.image = img;
//            photo.type = [NSNumber numberWithInt:IKPhotoTypeRecords];
//        }
//        
//        photo.modifyTime = [NSDate date];
//    }
//    
//    [[IKDataProvider managedObjectContext] save:nil];
    
    aryReportImages = [NSMutableArray arrayWithArray:photos];
    lblPhotoNum.text = aryReportImages.count>0?[NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),aryReportImages.count,LocalizeStringFromKey(@"kPcs")]:nil;
}
@end
