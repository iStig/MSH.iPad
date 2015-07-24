//
//  IKAddClientView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKAddClientView.h"
#import "IKAppDelegate.h"
#import "IKScanView.h"
#import "IKAddPhotoView.h"
#import "IKSignNameView.h"
#import "IKPhotoCDSO.h"
#import "IKDatePickerViewController.h"
#import "IKMinitePickerViewController.h"
#import "IKAddSecondPhotoView.h"
@implementation IKAddClientView
@synthesize vcParent,visit,addedVisit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bCanGoBack = YES;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        IKScanView *vScan = [IKScanView view];
        vScan.delegate = self;
        vScan.tag = dCurrentPage;
        vScan.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        
        
        vContent = [[UIView alloc] initWithFrame:vScan.frame];
        vContent.clipsToBounds = YES;
        [self addSubview:vContent];
        
        vScan.frame = vContent.bounds;
        [vContent addSubview:vScan];
        
        float y =40;
        
        registerTimerLab = [[UILabel alloc] initWithFrame:CGRectMake(30, y, 120, 30)];//405
        registerTimerLab.font = [UIFont boldSystemFontOfSize:19];
        registerTimerLab.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.0];
        registerTimerLab.backgroundColor = [UIColor clearColor];
        registerTimerLab.text = LocalizeStringFromKey(@"kSpecifyVisitTime");
        [registerTimerLab sizeToFit];
        [vContent addSubview:registerTimerLab];
        
        
        
        NSDateFormatter *formatterDay = [[NSDateFormatter alloc] init];
        [formatterDay setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDay = [formatterDay stringFromDate:[NSDate date]];
        yyyymmddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yyyymmddBtn.frame = CGRectMake(registerTimerLab.frame.size.width+registerTimerLab.frame.origin.x+30, y-10, 189, 51);
        [yyyymmddBtn setBackgroundImage:[UIImage imageNamed:@"IKRegisterTimerDay"] forState:UIControlStateNormal];
        [yyyymmddBtn setTitleColor:[UIColor colorWithRed:150.f/255.f green:150.f/255.f blue:150.f/255.f alpha:1.0] forState:UIControlStateNormal];
        [yyyymmddBtn setTitle:currentDay forState:UIControlStateNormal];
        yyyymmddBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        yyyymmddBtn.tag = 99;
        [yyyymmddBtn addTarget:self action:@selector(popTimePicker:) forControlEvents:UIControlEventTouchUpInside];
        [vContent addSubview:yyyymmddBtn];
        
        
        NSDateFormatter *formatterMin = [[NSDateFormatter alloc] init];
        [formatterMin setDateFormat:@"HH:mm"];
        NSString *currentMin = [formatterMin stringFromDate:[NSDate date]];
        hhmmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hhmmBtn.frame = CGRectMake(yyyymmddBtn.frame.size.width+yyyymmddBtn.frame.origin.x+30, y-10, 149, 51);
        [hhmmBtn setBackgroundImage:[UIImage imageNamed:@"IKRegisterTimerSec"] forState:UIControlStateNormal];
        [hhmmBtn setTitleColor:[UIColor colorWithRed:150.f/255.f green:150.f/255.f blue:150.f/255.f alpha:1.0] forState:UIControlStateNormal];
        [hhmmBtn setTitle:currentMin forState:UIControlStateNormal];
        hhmmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        hhmmBtn.tag = 999;
        [hhmmBtn addTarget:self action:@selector(popTimePicker:) forControlEvents:UIControlEventTouchUpInside];
        [vContent addSubview:hhmmBtn];
        
        self.visit = [NSEntityDescription insertNewObjectForEntityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];
        self.visit.hospital = [IKDataProvider currentHospital];
        
    }
    return self;
    
}


- (id)initWithFrame:(CGRect)frame clientInfo:(IKVisitCDSO *)v showType:(int)showType{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        self.visit = v;
        if (!self.visit){
            self.visit = [NSEntityDescription insertNewObjectForEntityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];
            self.visit.hospital = [IKDataProvider currentHospital];
        }
        
        vContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 737, 475)];
        vContent.clipsToBounds = YES;
        vContent.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:vContent];
        
        if (0==showType){
            IKScanView *vScan = [IKScanView view];
            vScan.delegate = self;
            vScan.tag = dCurrentPage;
            vScan.center = CGPointMake(frame.size.width/2, frame.size.height/2);
            
            vScan.frame = vContent.bounds;
            [vContent addSubview:vScan];
        }else if (1==showType){
            
        }else if (2==showType){
            bCanGoBack = NO;
            
            IKSignNameView *vSign = [IKSignNameView view];
            vSign.tag = 2;
            vSign.delegate = self;
            [vContent addSubview:vSign];
        }
        
        
        
    }
    return self;
}

+ (void)show{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    IKAddClientView *vAddClient = [[IKAddClientView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    vAddClient.alpha = 0;
    [w.rootViewController.view addSubview:vAddClient];
    [UIView animateWithDuration:.3f animations:^{
        vAddClient.alpha = 1;
    }];
}

+ (void)showAddSignature:(IKVisitCDSO *)v{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    IKAddClientView *vAddClient = [[IKAddClientView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) clientInfo:v showType:2];
    vAddClient.visit = v;
    vAddClient.alpha = 0;
    [w.rootViewController.view addSubview:vAddClient];
    [UIView animateWithDuration:.3f animations:^{
        vAddClient.alpha = 1;
    }];
}

+ (void)showAddSignatureOfVisit:(IKVisitCDSO *)v{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    IKAddClientView *vAddClient = [[IKAddClientView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) clientInfo:v showType:2];
    vAddClient.addedVisit = YES;
    vAddClient.visit = v;
    vAddClient.alpha = 0;
    [w.rootViewController.view addSubview:vAddClient];
    [UIView animateWithDuration:.3f animations:^{
        vAddClient.alpha = 1;
    }];
}

- (void)showAddSignature{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(vContent.frame, pt)){
        if (!self.addedVisit){
            [[IKDataProvider managedObjectContext] deleteObject:self.visit];
            [[IKDataProvider managedObjectContext] save:nil];
        }
        
        [self dismiss];
    }
}

- (void)dismiss{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)popTimePicker:(UIButton*)btn{
    
    if(btn.tag == 99){
        IKDatePickerViewController *vcDatePicker = [[IKDatePickerViewController alloc] init];
        [vcDatePicker.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        vcDatePicker.datePicker.date = [NSDate date];
        pcTime = [[UIPopoverController alloc] initWithContentViewController:vcDatePicker];
        [pcTime presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        
        IKMinitePickerViewController *vcDatePicker = [[IKMinitePickerViewController alloc] init];
        [vcDatePicker.datePicker addTarget:self action:@selector(minChanged:) forControlEvents:UIControlEventValueChanged];
        vcDatePicker.datePicker.date = [NSDate date];
        pcTime = [[UIPopoverController alloc] initWithContentViewController:vcDatePicker];
        [pcTime presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    
}
- (void)dateChanged:(UIDatePicker *)picker{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    datePlan = picker.date;
    [yyyymmddBtn setTitle:[formatter stringFromDate:datePlan] forState:UIControlStateNormal];
    
    NSDateFormatter *formatterMin = [[NSDateFormatter alloc] init];
    [formatterMin setDateFormat:@"HH:mm"];
    NSString *currentMin = [formatterMin stringFromDate:[NSDate date]];
    [hhmmBtn setTitle:currentMin forState:UIControlStateNormal];
    minPlan =[NSDate date];
}

- (void)minChanged:(UIDatePicker *)picker{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSDateFormatter *formatter_compare = [[NSDateFormatter alloc] init];
    [formatter_compare setDateFormat:@"yyyy-MM-dd"];
    
    
    NSDateFormatter *formatter_cutSecond = [[NSDateFormatter alloc] init];
    [formatter_cutSecond setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    
    NSDate * date = [[NSDate alloc] initWithTimeInterval:(-14*24*60*60) sinceDate:[NSDate date]];//往前推14天
    
    if ([[formatter_compare stringFromDate:datePlan] isEqualToString:[formatter_compare stringFromDate:[NSDate date]]]||!datePlan) {//当年月日是当天的情况
        if (![picker.date isEqualToDate:[picker.date earlierDate:[NSDate date]]]) {
            [UIAlertView showAlertWithTitle:@"" message:@"选取时间不能大于当前时间,请重选" cancelButton:nil];
            return;
        }
    }if ([[formatter_compare stringFromDate:datePlan] isEqualToString:[formatter_compare stringFromDate:date]]) {//如果往前推14天便是 已经选区过dateplan  所以没必要加 dateplan != nil判断
        NSLog(@"%@__________%@  :::::::::%@__________%@",picker.date,[NSDate date],[formatter_cutSecond stringFromDate:picker.date],[formatter_cutSecond stringFromDate:[NSDate date]]);
        
        if ([picker.date isEqualToDate:[picker.date earlierDate:[NSDate date]]]&&![[formatter_cutSecond stringFromDate:picker.date] isEqualToString:[formatter_cutSecond stringFromDate:[NSDate date]]]) {
            [UIAlertView showAlertWithTitle:@"" message:@"选取时间不能大于当前时间14天,请重选" cancelButton:nil];
            return;
        }
    }
    
    minPlan = picker.date;
    [hhmmBtn setTitle:[formatter stringFromDate:minPlan] forState:UIControlStateNormal];
}

- (void)showAddPhoto{
   
    IKAddPhotoView *vAddPhoto = [IKAddPhotoView view];
    vAddPhoto.delegate = self;
    vAddPhoto.tag = 1;
    dCurrentPage = 1;
    vAddPhoto.transform = CGAffineTransformMakeTranslation(vAddPhoto.frame.size.width, 0);
    [vContent addSubview:vAddPhoto];
    [UIView animateWithDuration:.3f animations:^{
        vAddPhoto.transform = CGAffineTransformIdentity;
    }];
}

-(void)showSecondAddPhoto{//证件照
    
    bCanGoBack = NO;
    IKAddSecondPhotoView *vAddPhoto = [IKAddSecondPhotoView view];
    vAddPhoto.delegate = self;
    vAddPhoto.tag = 2;
    dCurrentPage = 2;
    vAddPhoto.transform = CGAffineTransformMakeTranslation(vAddPhoto.frame.size.width, 0);
    [vContent addSubview:vAddPhoto];
    [UIView animateWithDuration:.3f animations:^{
        vAddPhoto.transform = CGAffineTransformIdentity;
    }];
    //wucy 3月4号
    [self performSelector:@selector(finishedForProfilePicture) withObject:nil afterDelay:.3f];
    self.addedVisit =YES;
}

- (void)showSignName{
    IKSignNameView *vSignName = [IKSignNameView view];
    vSignName.delegate = self;
    vSignName.tag = 2;
    dCurrentPage = 2;
    vSignName.transform = CGAffineTransformMakeTranslation(vSignName.frame.size.width, 0);
    [vContent addSubview:vSignName];
    [UIView animateWithDuration:.3f animations:^{
        vSignName.transform = CGAffineTransformIdentity;
    }];
    
}

#pragma mark - IKPopCenterView Delegate
- (BOOL)canShowPrev:(IKPopCenterView *)v{
    return v.tag>1 && bCanGoBack;
}

- (BOOL)canShowNext:(IKPopCenterView *)v{
    return v.tag<2;
}

- (void)cardNoEntered:(NSString *)cardNo{
    [SVProgressHUD showWithStatus:@"正在获取保险信息，请稍候"];
    sw_dispatch_async_on_background_thread(^{
        @autoreleasepool {
            NSDictionary *dict = [IKDataProvider getMemberInfo:[NSDictionary dictionaryWithObjectsAndKeys:cardNo,@"CardNo", nil]];
            NSLog(@"Member Info:%@",dict);
            
            
            NSString *isBirthday = [dict objectForKey:@"isBirthday"];
            aryPeopleList = [dict objectForKey:@"data"];
            
        
            
            if (aryPeopleList.count>0){
                sw_dispatch_sync_on_main_thread(^{
                    [SVProgressHUD dismiss];
                    
                    if (1==aryPeopleList.count&&[isBirthday isEqualToString:@"N"]){
                        NSDictionary *people = [aryPeopleList objectAtIndex:0];
                        
                        if (![people objectForKey:@"providerID"]){
                            NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:people];
                            NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
                            if (providerID)
                                [mut setObject:providerID forKey:@"providerID"];
                            
                            NSString *currentTime = @"";
                            
                            if (!datePlan&&!minPlan){
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                currentTime = [formatter stringFromDate:[NSDate date]];
                            }
                            if (datePlan&&minPlan) {
                                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                                NSString *date  =  [dateformatter stringFromDate:datePlan];
                                NSDateFormatter *minformatter = [[NSDateFormatter alloc] init];
                                [minformatter setDateFormat:@"HH:mm"];
                                NSString *min = [minformatter stringFromDate:minPlan];
                                currentTime = [NSString stringWithFormat:@"%@ %@:00",date,min];
                            }if (datePlan&&!minPlan) {
                                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                                NSString *date  =  [dateformatter stringFromDate:datePlan];
                                NSString *min = hhmmBtn.titleLabel.text;
                                currentTime = [NSString stringWithFormat:@"%@ %@:00",date,min];
                            }if (!datePlan&&minPlan) {
                                NSString *date = yyyymmddBtn.titleLabel.text;
                                NSDateFormatter *minformatter = [[NSDateFormatter alloc] init];
                                [minformatter setDateFormat:@"HH:mm"];
                                NSString *min = [minformatter stringFromDate:minPlan];
                                currentTime = [NSString stringWithFormat:@"%@ %@:00",date,min];
                            }
                            [mut setObject:currentTime forKey:@"registrationTime"];
                            people = mut;
                        }
                        
                        
                        
                        [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kGettinginformation")];
                        sw_dispatch_async_on_background_thread(^{
                            @autoreleasepool {
                                NSDictionary *dict = [IKDataProvider getVisitInfoV2:people];
                                NSLog(@"Visit Info:%@",dict);
                                sw_dispatch_sync_on_main_thread(^{
                                    if ([dict objectForKey:@"data"]){
                                        [SVProgressHUD dismiss];
                                        dicClientInfo = [dict objectForKey:@"data"];
                                        self.visit.detailInfo = dicClientInfo;
                                        
                                        if (self.visit.idphotoList.count>0) {//判断是否存在身份证件  如果存在则无需拍照
                                            [self performSelector:@selector(finished) withObject:nil afterDelay:.3f];
                                        }else{
                                            
                                            [self showSecondAddPhoto];//如果不存在则弹出身份证件照拍摄界面
                                            
                                        }
                                        
                                    }else{
                                        NSString *str = [dict objectForKey:@"errStr"];
                                        if (str){
                                            [SVProgressHUD dismiss];
                                            [UIAlertView showAlertWithTitle:nil message:str cancelButton:nil];
                                        }else
                                            [SVProgressHUD showErrorWithStatus:@"获取就诊信息失败，请检查网络后再重试"];
                                    }
                                });
                                
                            }
                        });
                    }else{
                        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"请选择就诊人" delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:nil];
                        
                        for (int i=0;i<aryPeopleList.count;i++){
                            
                            NSString *name = [[aryPeopleList objectAtIndex:i] objectForKey:@"MemberName"];
                            
                            [as addButtonWithTitle:name];
                        }
//                        [as addButtonWithTitle:@"try"]; //感觉没必要  不知道为什么加这个 模拟器中存在这个按钮 真机中不存在
                        [as showInView:self];
                    }
                });
            }else{
                sw_dispatch_sync_on_main_thread(^{
                    NSString *str = [dict objectForKey:@"errStr"];
                    if (str){
                        [SVProgressHUD dismiss];
                        [UIAlertView showAlertWithTitle:nil message:str cancelButton:nil];
                    }else
                        [SVProgressHUD showErrorWithStatus:@"没有查询到对应保险信息，请检查网络后再重试"];
                });
                
            }
        }
    });
}

- (void)photoAdded:(NSArray *)photos{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    for (int i=0;i<photos.count;i++){
        NSDate *date = [[photos objectAtIndex:i] objectForKey:@"date"];
        
        NSString *dateString = [formatter stringFromDate:date];
        
        NSString *seqID = [NSString stringWithFormat:@"%@%@%@",self.visit.providerID,self.visit.memberID,dateString];
        
        IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
        if (!photo){
            photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
            
            UIImage *img = [[photos objectAtIndex:i] objectForKey:@"image"];
            
            photo.seqID = seqID;
            photo.visit = self.visit;
            photo.createTime = date;
            photo.image = img;
            photo.type = [NSNumber numberWithInt:IKPhotoTypeInsuranceCard];
        }
        
        photo.modifyTime = [NSDate date];
    }
    
    
    if (self.visit.idphotoList.count>0){//判断是否存在证件
        [self performSelector:@selector(finished) withObject:nil afterDelay:.3f];
    }else{
        [self showSecondAddPhoto];
    }
}

- (void)secondPhotoAdded:(NSArray*)photos{//
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    if (photos.count>0){
        for (int i=0;i<photos.count;i++){
            @autoreleasepool {
                NSMutableDictionary *mut = [NSMutableDictionary dictionary];

                NSDate *date = [[photos objectAtIndex:i] objectForKey:@"date"];
                
                NSString *dateString = [formatter stringFromDate:date];
                
                NSString *seqID =  [NSString stringWithFormat:@"%@%@%@",self.visit.providerID,self.visit.memberID,dateString];//seqID
                
                [mut setObject:seqID forKey:@"seqID"];
                
                NSDateFormatter *formatter_update = [[NSDateFormatter alloc] init];
                [formatter_update setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                [mut setObject:[formatter_update stringFromDate:date] forKey:@"createTime"];//拍摄时间
                [mut setObject:[formatter_update stringFromDate:[NSDate date]]  forKey:@"modifyTime"];//修改时间
                
                if (self.visit){
                [mut setObject:self.visit.depID forKey:@"depID"];
                [mut setObject:self.visit.providerID forKey:@"providerID"];
                [mut setObject:self.visit.memberID forKey:@"memberID"];
                }
                
                [mut setObject:[NSString stringWithFormat:@"%d",IKPhotoTypeIDCard] forKey:@"type"];//身份证件照 ＝1
                
                
                UIImage *img = [[photos objectAtIndex:i] objectForKey:@"image"];//图片
                
                NSData *data = UIImageJPEGRepresentation(img,1.0);// uiimage 转 nsdata

                NSString *base64String = [data base64Encoding];//base64转码
             
                if (base64String){
                    [mut setObject:base64String forKey:@"photoPath"];
                       BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@[mut],@"data",@"1",@"count",(isInLocal?@"1":@"0"),@"internetType",nil];
                    
                    NSDictionary *dict = [IKDataProvider syncPhoto:param];
                    
                    NSString *result = [dict objectForKey:@"result"];
                    
                    int j = i+1;
                    if (result && result.intValue==0){
                        //  成功上传
                          NSLog(@"上传第 %d 张图片成功",j);
                        
                        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传第 %d 张图片成功",j]];
                        
                        sw_dispatch_sync_on_main_thread(^{

                            IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];//查看coredata看看是否存在图片 如果存在只修改modifyTime
                            if (!photo){
                                photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];//添加图片
                                photo.seqID = seqID;
                                photo.visit = self.visit;
                                photo.createTime = date;
                                photo.image = img;
                                photo.type = [NSNumber numberWithInt:IKPhotoTypeIDCard];
                                photo.uploaded = [NSNumber numberWithBool:YES];
                            }
                            
                                photo.modifyTime = [NSDate date];
//                            if (!photo.visit.hospital){
//                                return ;
//                            }
                            
                        });
                        
                        
                    }else{
                        NSLog(@"上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]);
//                        [UIAlertView showAlertWithTitle:@"" message:[NSString stringWithFormat:@"上传第 %d 张图片失败:%@",i,[dict objectForKey:@"errStr"]] cancelButton:nil];
                        
                        return;
                    }
                }
            }
        }
    }
    
    

    [self performSelector:@selector(finished) withObject:nil afterDelay:.3f];
    
    
    
}

- (void)signAdded:(UIImage *)sign{
    if (sign){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        
        NSDate *date = [NSDate date];
        
        NSString *dateString = [formatter stringFromDate:date];
        
        NSString *seqID = [NSString stringWithFormat:@"%@%@%@",self.visit.providerID,self.visit.memberID,dateString];
        
        IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
        if (!photo){
            photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
            
            
            
            photo.seqID = seqID;
            photo.visit = self.visit;
            photo.createTime = date;
            photo.image = sign;
            photo.type = [NSNumber numberWithInt:IKPhotoTypeSignature];
        }
        
        photo.modifyTime = [NSDate date];
    }
 
    [SVProgressHUD showWithStatus:@"正在保存"];
    
    [self performSelector:@selector(finished) withObject:nil afterDelay:.3f];
}

- (void)showNext:(IKPopCenterView *)v{
    NSArray *names = [@"IKScanView,IKAddPhotoView,IKSignNameView" componentsSeparatedByString:@","];
    Class IKPC = NSClassFromString([names objectAtIndex:v.tag+1]);
    IKPopCenterView *vPC = [IKPC view];
    vPC.delegate = self;
    vPC.tag = ++dCurrentPage;
    vPC.transform = CGAffineTransformMakeTranslation(vPC.frame.size.width, 0);
    [vContent addSubview:vPC];
    [UIView animateWithDuration:.3f animations:^{
        vPC.transform = CGAffineTransformIdentity;
    }];
}

- (void)showPrev:(IKPopCenterView *)v{
    [UIView animateWithDuration:.3f animations:^{
        v.transform = CGAffineTransformMakeTranslation(v.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
    }];
    dCurrentPage--;
    
    if (0==dCurrentPage){
        for (UIView *v in vContent.subviews){
            if ([v isKindOfClass:[IKScanView class]]){
                [(IKScanView *)v startScan];
            }
        }
    }
}

- (void)finished{
    
    visit.createTime = [NSDate date];
    visit.modifyTime = visit.createTime;
    
    
    [SVProgressHUD dismiss];
    NSError *error = nil;
    [[IKDataProvider managedObjectContext] save:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitAdded" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:visit,@"visit", nil]];
    [self dismiss];
}
- (void)finishedForProfilePicture{
    
    visit.createTime = [NSDate date];
    visit.modifyTime = visit.createTime;
    
    
    [SVProgressHUD dismiss];
    NSError *error = nil;
    [[IKDataProvider managedObjectContext] save:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitAdded" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:visit,@"visit", nil]];
    
}
#pragma mark - UIAlertView Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (0!=buttonIndex){
        NSDictionary *people = [aryPeopleList objectAtIndex:buttonIndex-1];
        
        if (![people objectForKey:@"providerID"]){
            
            NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:people];
            NSString *providerID = [[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"];
            if (providerID)
                [mut setObject:providerID forKey:@"providerID"];
            NSString *currentTime = @"";
            
            if (!datePlan&&!minPlan){
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                currentTime = [formatter stringFromDate:[NSDate date]];
            }
            if (datePlan&&minPlan) {
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                NSString *date  =  [dateformatter stringFromDate:datePlan];
                NSDateFormatter *minformatter = [[NSDateFormatter alloc] init];
                [minformatter setDateFormat:@"HH:mm"];
                NSString *min = [minformatter stringFromDate:minPlan];
                currentTime = [NSString stringWithFormat:@"%@ %@:00",date,min];
            }if (datePlan&&!minPlan) {
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                NSString *date  =  [dateformatter stringFromDate:datePlan];
                NSString *min = hhmmBtn.titleLabel.text;
                currentTime = [NSString stringWithFormat:@"%@ %@:00",date,min];
            }if (!datePlan&&minPlan) {
                NSString *date = yyyymmddBtn.titleLabel.text;
                NSDateFormatter *minformatter = [[NSDateFormatter alloc] init];
                [minformatter setDateFormat:@"HH:mm"];
                NSString *min = [minformatter stringFromDate:minPlan];
                currentTime = [NSString stringWithFormat:@"%@ %@:00",date,min];
            }
            [mut setObject:currentTime forKey:@"registrationTime"];
            people = mut;
        }
        
        
        [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kGettinginformation")];
        sw_dispatch_async_on_background_thread(^{
            @autoreleasepool {
                NSDictionary *dict = [IKDataProvider getVisitInfoV2:people];
                NSLog(@"Visit Info:%@",dict);
                sw_dispatch_sync_on_main_thread(^{
                    if ([dict objectForKey:@"data"]){
                        [SVProgressHUD dismiss];
                        dicClientInfo = [dict objectForKey:@"data"];
                        self.visit.detailInfo = dicClientInfo;
                        
                        
                        if (self.visit.idphotoList.count>0) {//判断是否存在身份证件  如果存在则无需拍照
                            [self performSelector:@selector(finished) withObject:nil afterDelay:.3f];
                        }else{
                            
                            [self showSecondAddPhoto];//如果不存在则弹出身份证件照拍摄界面
                            
                        }
                        


                    }else{
                        NSString *str = [dict objectForKey:@"errStr"];
                        if (str){
                            [SVProgressHUD dismiss];
                            [UIAlertView showAlertWithTitle:nil message:str cancelButton:nil];
                        }else
                            [SVProgressHUD showErrorWithStatus:@"获取就诊信息失败，请检查网络后再重试"];
                    }
                });
                
            }
        });
    }else{
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kCancel")]){
            [self dismiss];
        }
    }
}

@end
