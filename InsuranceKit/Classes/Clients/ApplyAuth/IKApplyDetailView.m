//
//  IKApplyDetailView.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyDetailView.h"
#import "IKDatePickerViewController.h"
#import "IKApplyAuthViewController.h"
#import "IKUnlimitDatePickerController.h"
#import "IKPhotoCDSO.h"
#import "IKAppDelegate.h"
#import "IKItemButton.h"
#import "IKDecodeWithUTF8.h"
@implementation IKApplyDetailView{
    IKPhotoCDSO *photo;
}
@synthesize dicAuthInfo,vcApplyAuth,tfExpenses;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scvBG = [[UIScrollView alloc] initWithFrame:self.bounds];
        scvBG.contentSize = scvBG.frame.size;
        [self addSubview:scvBG];
        
        category = 0;
        datePlan = [NSDate date];
        
        UIFont *titleFont = [UIFont systemFontOfSize:[InternationalControl isEnglish]?15:19];
        
        self.dicAuthInfo = [NSMutableDictionary dictionary];
        aryReportImages = [[NSMutableArray alloc] init];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        
        UIImageView *imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(22, 24, 152, 50)];
        [imgvBG setImage:[UIImage imageNamed:@"IKBGYellowT.png"]];
        UILabel *lbl = [UILabel createLabelWithFrame:imgvBG.bounds font:titleFont textColor:[UIColor whiteColor]];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = LocalizeStringFromKey(@"kExpecteddateofservice");
        [imgvBG addSubview:lbl];
        [scvBG addSubview:imgvBG];
        
        lblDate = [UILabel createLabelWithFrame:CGRectMake(192, 24, 132, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor colorWithWhite:.44 alpha:1]];
        [scvBG addSubview:lblDate];
        lblDate.text = [formatter stringFromDate:[NSDate date]];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconArrowDown.png"]];
        arrow.transform = CGAffineTransformMakeRotation(-M_PI_2);
        arrow.center = CGPointMake(333, 24+25);
        [scvBG addSubview:arrow];
        
        UIButton *btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDate.frame = CGRectMake(lblDate.frame.origin.x, lblDate.frame.origin.y, arrow.center.x+10-lblDate.frame.origin.x, 50);
        [scvBG addSubview:btnDate];
        [btnDate addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(imgvBG.frame.origin.x, imgvBG.frame.origin.y+imgvBG.frame.size.height-3, 320, 1)];
        line.backgroundColor = [UIColor colorWithWhite:.77 alpha:1];
        [scvBG addSubview:line];
        
        imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(365, 24, 152, 50)];
        [imgvBG setImage:[UIImage imageNamed:@"IKBGYellowT.png"]];
        lbl = [UILabel createLabelWithFrame:imgvBG.bounds font:titleFont textColor:[UIColor whiteColor]];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text =LocalizeStringFromKey(@"kEstimatedCost");
        [imgvBG addSubview:lbl];
        [scvBG addSubview:imgvBG];
        
        tfExpenses = [[UITextField alloc] initWithFrame:CGRectMake(515, 24, 135, 50)];
        tfExpenses.textAlignment = NSTextAlignmentRight;
        tfExpenses.font = [UIFont systemFontOfSize:19];
        tfExpenses.placeholder =  LocalizeStringFromKey(@"kPleaseinputtotalamount");
        tfExpenses.textColor = [UIColor colorWithWhite:.44 alpha:1];
        tfExpenses.keyboardType = UIKeyboardTypeNumberPad;
        [scvBG addSubview:tfExpenses];
        tfExpenses.returnKeyType = UIReturnKeyDone;
        tfExpenses.delegate = self;
        
        lblUnit = [UILabel createLabelWithFrame:CGRectMake(tfExpenses.frame.origin.x+tfExpenses.frame.size.width+3, tfExpenses.center.y-3, 60, 13) font:[UIFont systemFontOfSize:12] textColor:[UIColor lightGrayColor]];
        lblUnit.text = [[IKDataProvider currentHospitalInfo] objectForKey:@"currencyUnit"];
        [scvBG addSubview:lblUnit];
        
        
        line = [[UIView alloc] initWithFrame:CGRectMake(imgvBG.frame.origin.x, imgvBG.frame.origin.y+imgvBG.frame.size.height-3, 320, 1)];
        line.backgroundColor = [UIColor colorWithWhite:.77 alpha:1];
        [scvBG addSubview:line];
        
        imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(22, 94, 152, 50)];
        [imgvBG setImage:[UIImage imageNamed:@"IKBGOrangeT.png"]];
        lbl = [UILabel createLabelWithFrame:imgvBG.bounds font:titleFont textColor:[UIColor whiteColor]];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = LocalizeStringFromKey(@"kExpectedProcedure");
        [imgvBG addSubview:lbl];
        [scvBG addSubview:imgvBG];
        
        vMethodList = [[UIView alloc] initWithFrame:CGRectMake(175, 74, 520, 146)];
        [scvBG addSubview:vMethodList];
        
        
//        aryTitles = [@"门诊检查/手术,住院治疗/手术,生育,耐用型医疗设备,化学治疗,放射治疗,理疗,其他" componentsSeparatedByString:@","];
        
         aryTitles = @[LocalizeStringFromKey(@"kOutpatientExam/Surgery"),
                       LocalizeStringFromKey(@"kInpatientTreatmentSurgery"),
                       LocalizeStringFromKey(@"kDelivery"),
                       LocalizeStringFromKey(@"kDurableMedicalEquipment"),
                       LocalizeStringFromKey(@"kChemotherapy"),
                       LocalizeStringFromKey(@"kRadiotherapy"),
                       LocalizeStringFromKey(@"kTherapy"),
                       LocalizeStringFromKey(@"kOthers")];
        
        for (int i=0;i<8;i++){
            int row = i/3;
            int col = i%3;
       

            NSString *text = [aryTitles objectAtIndex:i];
            
            
            IKItemButton *btn = [[IKItemButton alloc] initWithFrame:CGRectMake(19+180*col, 20+40*row, col<2?165:115, 36)];
        
            [btn setTitle:text];
    
            btn.tag = 200+i;
            [btn addTarget:self action:@selector(methodClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.clipsToBounds = YES;
            [vMethodList addSubview:btn];
        }
        
        aryImages = [@"IKViewChecking,IKViewHospitalized,IKViewBirth,IKViewDevice,IKViewChemicalCure,IKViewRadicalCure,IKViewPhysical,IKViewOther" componentsSeparatedByString:@","];
        
        float y = vMethodList.frame.origin.y+vMethodList.frame.size.height;
        vApplyDetail = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, self.frame.size.height-y)];
        [scvBG addSubview:vApplyDetail];
        
        
        btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSubmit.clipsToBounds = YES;
        btnSubmit.layer.cornerRadius = 2;
        btnSubmit.frame = CGRectMake(0, 0, 150, 40);
        btnSubmit.layer.borderColor = [UIColor colorWithRed:.95 green:.18 blue:.04 alpha:1].CGColor;
        btnSubmit.layer.borderWidth = 1;
        [btnSubmit setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.95 green:.35 blue:.31 alpha:1] size:btnSubmit.frame.size] forState:UIControlStateNormal];
        [btnSubmit setTitle:LocalizeStringFromKey(@"kSave") forState:UIControlStateNormal];
        [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSubmit.titleLabel.font = [UIFont systemFontOfSize:20];
        btnSubmit.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-70);
        [btnSubmit addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
        [scvBG addSubview:btnSubmit];
        
        btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.clipsToBounds = YES;
        btnDelete.layer.cornerRadius = 2;
        btnDelete.frame = CGRectMake(0, 0, 150, 40);
        btnDelete.layer.borderColor = [UIColor colorWithRed:.08 green:.32 blue:1 alpha:1].CGColor;
        btnDelete.layer.borderWidth = 1;
        [btnDelete setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.08 green:.64 blue:.98 alpha:1] size:btnDelete.frame.size] forState:UIControlStateNormal];
        [btnDelete setTitle:LocalizeStringFromKey(@"kDelete") forState:UIControlStateNormal];
        [btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnDelete.titleLabel.font = [UIFont systemFontOfSize:20];
        btnDelete.center = CGPointMake(self.frame.size.width*2.0f/3.0f, self.frame.size.height-70);
        [btnDelete addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
        btnDelete.hidden = YES;
        [scvBG addSubview:btnDelete];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowed:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardShowed:(NSNotification *)notice{
    return;
    UIView *v = [UIResponder currentFirstResponder];
    CGRect rect = [[[notice userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float h = MIN(rect.size.height, rect.size.width);
    
    scvBG.frame = CGRectMake(scvBG.frame.origin.x, scvBG.frame.origin.y, scvBG.frame.size.width, self.frame.size.height-h);
    
    if ([v.superview isKindOfClass:[IKInputView class]]){
        CGRect frame = [self convertRect:v.frame fromView:v.superview];
        
        if (frame.origin.y+frame.size.height+44>768-h){
            h = 768-frame.origin.y-frame.size.height-h-44;

            scvBG.contentOffset = CGPointMake(0, -h);
        }
        
        NSLog(@"Current Field:%@",NSStringFromCGRect(v.frame));
    }
    
    
    
}

- (BOOL)isInAuthDetail:(UIView *)tf{
    UIView *v = tf;
    while (v.superview) {
        if ([v isKindOfClass:NSClassFromString(@"IKApplyDetailView")])
            return YES;
        
        v = v.superview;
    }
    
    return NO;
}

- (void)keyboardHidden:(NSNotification *)notice{
    scvBG.frame = self.bounds;
    scvBG.contentOffset = CGPointMake(0, 0);
}

- (void)showInfo:(NSDictionary *)info{
    if (!info){
        self.userInteractionEnabled = NO;
        return;
    }else
        self.userInteractionEnabled = YES;
    
    dicApplyInfo = info;
    
    BOOL isPad = [[info objectForKey:@"isPad"] isEqualToString:@"Y"];
    int status = [[info objectForKey:@"status"] intValue];
    BOOL canEdit = isPad && (status==2 || status==4);
    
    btnDelete.hidden = !canEdit;
    btnSubmit.hidden = !canEdit;
    
    [btnSubmit setTitle:LocalizeStringFromKey(@"kupdate") forState:UIControlStateNormal];
    btnSubmit.center = CGPointMake(self.frame.size.width/3.0f, btnSubmit.center.y);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *expectedDate = [info objectForKey:@"expectedDate"];
    expectedDate = [[expectedDate componentsSeparatedByString:@" "] objectAtIndex:0];
    
    datePlan = [formatter dateFromString:expectedDate];

    lblDate.text = [formatter stringFromDate:datePlan];
    
   tfExpenses.text =[IKDecodeWithUTF8 notRounding:[info objectForKey:@"estimatedCost"] afterPoint:2];
//    tfExpenses.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"estimatedCost"] floatValue]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = [[info objectForKey:@"category"] intValue]-1;
    
    [self methodClicked:btn];
    
    [vApply showInfo:info];
}

- (void)dateClicked:(UIButton *)btn{
    
    IKUnlimitDatePickerController *vcDatePicker = [[IKUnlimitDatePickerController alloc] init];
    [vcDatePicker.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    pcDate = [[UIPopoverController alloc] initWithContentViewController:vcDatePicker];

    [pcDate presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dateChanged:(UIDatePicker *)picker{
    datePlan = picker.date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    lblDate.text = [formatter stringFromDate:datePlan];
}


- (void)methodClicked:(UIButton *)btn{
    int index = (int)btn.tag%10;
    category = index+1;
    NSArray *categories = [@"1,2,3,4,5,6,7,99" componentsSeparatedByString:@","];
    for (int i=0;i<categories.count;i++){
        UILabel *lbl = (UILabel *)[vMethodList viewWithTag:100+i];
        UIButton *b = (UIButton *)[vMethodList viewWithTag:200+i];
        
        lbl.textColor = i==index?[UIColor colorWithRed:.99 green:.62 blue:.5 alpha:1]:[UIColor colorWithWhite:.54 alpha:1];
        b.selected = i==index;
    }
    
    
    NSArray *names = [@"Check,Hospital,Birth,Device,Chemical,Radiant,Physical,Other" componentsSeparatedByString:@","];
    
    
    Class ApplyViewClass = NSClassFromString([NSString stringWithFormat:@"IKApply%@",[names objectAtIndex:index]]);
    
    if (vApply && [vApply isKindOfClass:ApplyViewClass])
        return;
    else{
        if (vApply && vApply.superview)
            [vApply removeFromSuperview];
        
        if (index == 1) {
            vApply = [ApplyViewClass applyView];
            vApply.isFutureDate = [self isFutureDateOrNot];
            [vApplyDetail addSubview:vApply];
        }
        else{
            vApply = [ApplyViewClass applyView];
            [vApplyDetail addSubview:vApply];
        }
        
    }
    vApply.categoryID = [categories objectAtIndex:index];
    [vApply updateNecessaryStatus];
}
-(BOOL)isFutureDateOrNot{
    
    
    
    int diff = (int)[datePlan timeIntervalSinceDate:[NSDate date]];
    
    if (diff>0) {
        
        return YES;
        
    }
    
    return NO;
    
}
- (void)deleteClicked{
    if (![IKDataProvider canEditApply]){
        [UIAlertView showAlertWithTitle:nil message:@"您没有权限进行此项操作" cancelButton:nil];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizeStringFromKey(@"kDeletethepre-authorization") delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") otherButtonTitles:LocalizeStringFromKey(@"kDelete"), nil];
    [alert show];
}
- (void)loadStatus{
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kSubmiting")];
}
-(void)loadPhoto{
    btnSubmit.enabled =NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    
    if (dicApplyInfo && [dicApplyInfo objectForKey:@"caseId"])
        [mut setObject:[dicApplyInfo objectForKey:@"caseId"] forKey:@"caseId"];
    
    //  就诊信息
    if (visit){
        [mut setObject:visit.depID forKey:@"depID"];
        [mut setObject:visit.providerID forKey:@"medProviderID"];
        [mut setObject:visit.memberID forKey:@"memberID"];
        if ([visit.detailInfo objectForKey:@"memberName"])
            [mut setObject:[visit.detailInfo objectForKey:@"memberName"] forKey:@"memberName"];
    }else{
        NSString *depID = [dicApplyInfo objectForKey:@"depID"];
        NSString *providerID = [dicApplyInfo objectForKey:@"medProviderID"];
        NSString *memberID = [dicApplyInfo objectForKey:@"memberID"];
        NSString *memberName = [dicApplyInfo objectForKey:@"memberName"];
        if (depID)
            [mut setObject:depID forKey:@"depID"];
        if (providerID)
            [mut setObject:providerID forKey:@"medProviderID"];
        if (memberID)
            [mut setObject:memberID forKey:@"memberID"];
        if (memberName)
            [mut setObject:memberName forKey:@"memberName"];
    }
    
    
    
    //  预计治疗种类
    [mut setObject:[NSString stringWithFormat:@"%d",category] forKey:@"category"];
    //  预计日期
    [mut setObject:[formatter stringFromDate:datePlan] forKey:@"expectedDate"];
    //  估计费用
    NSString *str =[IKDecodeWithUTF8 notRounding:tfExpenses.text afterPoint:2];
    [mut setObject:str forKey:@"estimatedCost"];
    //  货币单位
    [mut setObject:lblUnit.text forKey:@"currencyUnit"];
    //  治疗信息
    [mut setValuesForKeysWithDictionary:[vApply authInfo]];
    //  左侧信息
    [mut setValuesForKeysWithDictionary:[vcApplyAuth authInfo]];
    
    
    aryReportImages = vcApplyAuth.aryReportImages;
    if (aryReportImages.count>0) {
        for (int i=0;i<aryReportImages.count;i++){
            
            
            
            @autoreleasepool {
                
                NSMutableDictionary *mutPicture = [NSMutableDictionary dictionary];//上传图片参数
                NSDate *date = [[aryReportImages objectAtIndex:i] objectForKey:@"date"];
                if (!date) {//当不存在时间表示是网上留下的图
                    continue;
                }
                
                NSString *seqID = [[aryReportImages objectAtIndex:i] objectForKey:@"seqID"];
                [mutPicture setObject:seqID forKey:@"seqID"];
                
                NSString *imagePath = [[aryReportImages objectAtIndex:i] objectForKey:@"photoPath"];
                UIImage *img = [[aryReportImages objectAtIndex:i] objectForKey:@"image"];//图片
                
                NSDateFormatter *formatter_update = [[NSDateFormatter alloc] init];
                [formatter_update setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                [mutPicture setObject:[formatter_update stringFromDate:date] forKey:@"createTime"];//拍摄时间
                [mutPicture setObject:[formatter_update stringFromDate:[NSDate date]]  forKey:@"modifyTime"];//修改时间
                
                if (visit){
                    [mutPicture setObject:visit.depID forKey:@"depID"];
                    [mutPicture setObject:visit.memberID forKey:@"memberID"];
                    [mutPicture setObject:visit.providerID forKey:@"providerID"];
                }else{
                    
                    
                    NSString *depID = [dicApplyInfo objectForKey:@"depID"];
                    NSString *providerID = [dicApplyInfo objectForKey:@"medProviderID"];
                    NSString *memberID = [dicApplyInfo objectForKey:@"memberID"];
                    
                    [mutPicture setObject:depID forKey:@"depID"];
                    [mutPicture setObject:memberID forKey:@"memberID"];
                    [mutPicture setObject:providerID forKey:@"providerID"];
                    
                }
                
                
                [mutPicture setObject:[NSString stringWithFormat:@"%d",IKPhotoTypeRecords] forKey:@"type"];//事件授权病历照 = 2
                
                NSData *data = UIImageJPEGRepresentation(img,1.0);// uiimage 转 nsdata
                NSString *base64String = [data base64Encoding];//base64转码
                if (base64String){
                    [mutPicture setObject:base64String forKey:@"photoPath"];
                    
                    BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
                    
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@[mutPicture],@"data",@"1",@"count",(isInLocal?@"1":@"0"),@"internetType", nil];
                    NSDictionary *dict = [IKDataProvider syncPhoto:param];
                    NSString *result = [dict objectForKey:@"result"];
                    int j = i+1;
                    if (result && result.intValue==0){
                        //  成功上传
                        NSLog(@"上传第 %d 张图片成功",j);
                        
                        //    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传第 %d 张图片成功",j]];
                        
                        sw_dispatch_sync_on_main_thread(^{
                            
                            photo = [IKPhotoCDSO photoWithSeqID:seqID];//查看coredata看看是否存在图片 如果存在只修改modifyTime
                            if (!photo){
                                
                                photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];//添加图片
                                photo.seqID = seqID;
                                if (self.visit) {//与visit关联
                                    photo.visit = self.visit;
                                }else{
                                    IKAppDelegate *delegate =    (IKAppDelegate *)[UIApplication sharedApplication].delegate;
                                    photo.visit = delegate.visit;
                                }
                                photo.createTime = date;
                                photo.image = img;
                                photo.type = [NSNumber numberWithInt:IKPhotoTypeRecords];
                                
                            }
                            
                            photo.modifyTime = [NSDate date];
                            //                            if (!photo.visit.hospital){
                            //                                return ;
                            //                            }
                            
                        });
                        
                        
                        
                    }else{
                        //   [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]]];
                        NSLog(@"上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]);
                        
                    }
                }
            }
        }
    }
    //        [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kSubmiting")];
    [NSThread detachNewThreadSelector:@selector(submitApply:) toTarget:self withObject:mut];
}

- (void)saveClicked{
    
    
    if (![IKDataProvider canEditApply]){
        [UIAlertView showAlertWithTitle:nil message:@"您没有权限进行此项操作" cancelButton:nil];
        [SVProgressHUD dismiss];
        return;
    }
    
    if ([tfExpenses.text intValue]==0){
        [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPleaseinputEstimatedCost") cancelButton:nil];
        [SVProgressHUD dismiss];
        return;
    }
    
    BOOL finished = YES;
    
    if (category==0)
        finished = NO;
    
    if (tfExpenses.text.length==0)
        finished = NO;
    
    if (![vApply authInfo])
        finished = NO;
    
    if (![vcApplyAuth authInfo])
        finished = NO;
    
    if (!finished){
        
        [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPleaseinputthecolumnnecessary") cancelButton:nil];
        [SVProgressHUD dismiss];
        return;
    }
    else{
        
        NSInvocationOperation *invocation =[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadStatus) object:nil];
        sleep(0.1);
        [invocation setCompletionBlock:^{
            [self loadPhoto];
        }];
        
        [invocation start];
}
}

- (void)submitApply:(NSDictionary *)info{
    @autoreleasepool {
        NSDictionary *dict = nil;
        
        if (dicApplyInfo){
            dict = [IKDataProvider modifyApply:info];
        }
        else{
            dict = [IKDataProvider submitApply:info];
        }
        
        sw_dispatch_sync_on_main_thread(^{
            int result = [[dict objectForKey:@"result"] intValue];
            if (0==result && dict){
                photo.uploaded = [NSNumber numberWithBool:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshApplyList" object:nil];
                [vcApplyAuth navBack];
                [SVProgressHUD showSuccessWithStatus:LocalizeStringFromKey(@"kSuccess")];
            }else{
                btnSubmit.enabled =YES;
                photo.uploaded = [NSNumber numberWithBool:NO];
                NSLog(@"API Failed:%@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:info options:0 error:nil] encoding:NSUTF8StringEncoding]);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@:%@",LocalizeStringFromKey(@"kFail"),[dict objectForKey:@"errStr"]]];
            }
            
            NSError *error = nil;
            [[IKDataProvider managedObjectContext] save:&error];
        });
        
        
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kDelete")]){
        [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kDeleting")];
        
        sw_dispatch_async_on_background_thread(^{
            @autoreleasepool {
                NSDictionary *dict = [IKDataProvider deleteAuth:[NSDictionary dictionaryWithObjectsAndKeys:[dicApplyInfo objectForKey:@"caseId"],@"CaseId", nil]];
                
                sw_dispatch_sync_on_main_thread(^{
                    int result = [[dict objectForKey:@"result"] intValue];
                    if (0==result && dict){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshApplyList" object:nil];
                        
                        [vcApplyAuth navBack];
                        [SVProgressHUD showSuccessWithStatus:@"事先授权信息删除成功"];
                    }else{
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"删除事先授权信息失败:%@",[dict objectForKey:@"errStr"]]];
                    }
                });
            }
        });
    }
}

@end
