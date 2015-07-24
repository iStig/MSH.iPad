//
//  IKApplyClaimsDetailView.m
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyClaimsDetailView.h"
#import "IKApplyClaimsViewController.h"
#import "IKAppDelegate.h"
#import "IKApplyClaimsPhotoInformation.h"
#import "IKDecodeWithUTF8.h"
@interface IKApplyClaimsDetailUploadInfo :NSObject
@property NSMutableDictionary *parameters;
@property NSMutableDictionary *photo;

@end
@implementation IKApplyClaimsDetailUploadInfo
@end


@implementation IKApplyClaimsDetailView
@synthesize vcApplyClaims,dicAuthInfo,otherVisitInfo;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAryReportImagesClick:) name:@"getAryReportImages" object:nil];

        scvBG = [[UIScrollView alloc] initWithFrame:self.bounds];
        scvBG.contentSize = scvBG.frame.size;
        [self addSubview:scvBG];
        
        visitType = 0;
        aryReportImages = [NSMutableArray array];
        aryReportImages_noPad = [NSMutableArray array];
        
        
        
//        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        UIImageView *imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(22, 24, 152, 50)];
        [imgvBG setImage:[UIImage imageNamed:@"IKBGYellowT.png"]];
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(15, 0, 135, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor]];
        lbl.text = LocalizeStringFromKey(@"kTreatmentfrom");
        [imgvBG addSubview:lbl];
        [scvBG addSubview:imgvBG];
        
        lblDate = [UILabel createLabelWithFrame:CGRectMake(192, 24, 132, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor colorWithWhite:.44 alpha:1]];
        [scvBG addSubview:lblDate];
        lblDate.text = [formatter stringFromDate:[NSDate date]];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconArrowDown.png"]];
        arrow.transform = CGAffineTransformMakeRotation(-M_PI_2);
        arrow.center = CGPointMake(333, 24+25);
        [scvBG addSubview:arrow];
        
        btnDate = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDate.frame = CGRectMake(lblDate.frame.origin.x, lblDate.frame.origin.y, arrow.center.x+10-lblDate.frame.origin.x, 50);
        [scvBG addSubview:btnDate];
        btnDate.tag =1;
        [btnDate addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
      
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(imgvBG.frame.origin.x, imgvBG.frame.origin.y+imgvBG.frame.size.height-3, 320, 1)];
        line.backgroundColor = [UIColor colorWithWhite:.77 alpha:1];
        [scvBG addSubview:line];
        
        
        
        
        NSDateFormatter *formatter_end = [[NSDateFormatter alloc] init];
        [formatter_end setDateFormat:@"yyyy-MM-dd"];
        
        UIImageView *imgvBG_end = [[UIImageView alloc] initWithFrame:CGRectMake(22+343, 24, 152, 50)];
        [imgvBG_end setImage:[UIImage imageNamed:@"IKBGYellowT.png"]];
        UILabel *lbl_end = [UILabel createLabelWithFrame:CGRectMake(15, 0, 135, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor]];
        lbl_end.text = LocalizeStringFromKey(@"kTo");
        [imgvBG_end addSubview:lbl_end];
        [scvBG addSubview:imgvBG_end];
        
        lblEndDate = [UILabel createLabelWithFrame:CGRectMake(192+343, 24, 132, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor colorWithWhite:.44 alpha:1]];
        [scvBG addSubview:lblEndDate];
        lblEndDate.text = [formatter_end stringFromDate:[NSDate date]];
        
        UIImageView *arrow_end = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconArrowDown.png"]];
        arrow_end.transform = CGAffineTransformMakeRotation(-M_PI_2);
        arrow_end.center = CGPointMake(333+343, 24+25);
        [scvBG addSubview:arrow_end];
        
        btnDate_end = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDate_end.frame = CGRectMake(lblEndDate.frame.origin.x, lblEndDate.frame.origin.y, arrow_end.center.x+10-lblEndDate.frame.origin.x, 50);
        [scvBG addSubview:btnDate_end];
        btnDate_end.tag =2;
        [btnDate_end addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *line_end = [[UIView alloc] initWithFrame:CGRectMake(imgvBG_end.frame.origin.x, imgvBG_end.frame.origin.y+imgvBG_end.frame.size.height-3, 320, 1)];
        line_end.backgroundColor = [UIColor colorWithWhite:.77 alpha:1];
        [scvBG addSubview:line_end];
        
        
        imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(22, 94+12, 152, 50)];
        [imgvBG setImage:[UIImage imageNamed:@"IKBGOrangeT.png"]];
        lbl = [UILabel createLabelWithFrame:CGRectMake(15, 0, 135, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor]];
        lbl.text = LocalizeStringFromKey(@"kTreatment");
        [imgvBG addSubview:lbl];
        [scvBG addSubview:imgvBG];
    
        vMethodList = [[UIView alloc] initWithFrame:CGRectMake(175, 74+12, 520, 146)];
        [scvBG addSubview:vMethodList];
        
    //    aryTitles = [@"门诊,住院,齿科,眼科,体检" componentsSeparatedByString:@","];
        
        aryTitles = @[LocalizeStringFromKey(@"kOutpatient"),LocalizeStringFromKey(@"kInpatient"),LocalizeStringFromKey(@"kDental"),LocalizeStringFromKey(@"kVision"),LocalizeStringFromKey(@"kWellness")];
        
        for (int i=0;i<5;i++){
            int row = i/3;
            int col = i%3;
            
            float distance = 20;
            
            NSString *text = [aryTitles objectAtIndex:i];
            CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil]];
            CGSize imgSize = [[UIImage imageNamed:@"IKIconCircleCheckNO.png"] size];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(19+180*col, 20+40*row, col<2?165:115, 36);
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            [btn setTitleColor:[UIColor colorWithWhite:.54 alpha:1] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"IKIconCircleCheckNO.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"IKIconCircleCheckYES.png"] forState:UIControlStateSelected];
            [btn setTitle:text forState:UIControlStateNormal];
            
            btn.imageEdgeInsets = UIEdgeInsetsMake((btn.frame.size.height-imgSize.height)/2, 0, (btn.frame.size.height-imgSize.height)/2, btn.frame.size.width-imgSize.width);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, distance, 0, btn.frame.size.width-imgSize.width-distance-size.width);
            
            btn.tag = 200+i;
            [btn addTarget:self action:@selector(methodClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [vMethodList addSubview:btn];
        }
        

        
        
        imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(22, 94 + 75+20, 152, 50)];
        [imgvBG setImage:[UIImage imageNamed:@"IKBGOrangeT.png"]];
        lbl = [UILabel createLabelWithFrame:CGRectMake(15, 0, 135, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor]];
        lbl.text = LocalizeStringFromKey(@"kPayment");
        [imgvBG addSubview:lbl];
        [scvBG addSubview:imgvBG];
        
        tfExpenses = [[UITextField alloc] initWithFrame:CGRectMake(22+152,  94 + 75+20, 135, 50)];
        tfExpenses.textAlignment = NSTextAlignmentRight;
        tfExpenses.font = [UIFont systemFontOfSize:19];
        tfExpenses.placeholder = LocalizeStringFromKey(@"kPleaseinputtotalamount");
        tfExpenses.textColor = [UIColor colorWithWhite:.44 alpha:1];
        tfExpenses.keyboardType = UIKeyboardTypeNumberPad;
        [scvBG addSubview:tfExpenses];
        tfExpenses.returnKeyType = UIReturnKeyDone;
        tfExpenses.delegate = self;
        
        lblUnit = [UILabel createLabelWithFrame:CGRectMake(tfExpenses.frame.origin.x+tfExpenses.frame.size.width, tfExpenses.center.y-6, 60, 13) font:[UIFont systemFontOfSize:19] textColor:[UIColor lightGrayColor]];
       lblUnit.text = [[IKDataProvider currentHospitalInfo] objectForKey:@"currencyUnit"];
       [scvBG addSubview:lblUnit];
        
    
        line = [[UIView alloc] initWithFrame:CGRectMake(imgvBG.frame.origin.x, imgvBG.frame.origin.y+imgvBG.frame.size.height-3, 320, 1)];
        line.backgroundColor = [UIColor colorWithWhite:.77 alpha:1];
        [scvBG addSubview:line];
        
        
        
//        imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(22, 94 + 75+20 +87, 152, 50)];
//        [imgvBG setImage:[UIImage imageNamed:@"IKBGOrangeT.png"]];
//        lbl = [UILabel createLabelWithFrame:CGRectMake(15, 0, 135, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor]];
//   
//        lbl.text = LocalizeStringFromKey(@"kMedicalrecord");
//        [imgvBG addSubview:lbl];
//        [scvBG addSubview:imgvBG];
        
//        btnAddRecord = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btnAddRecord setImage:[UIImage imageNamed:@"IKCamera.png"] forState:UIControlStateNormal];
//        btnAddRecord.frame =CGRectMake(0, 0, 85, 85);
//        btnAddRecord.center = CGPointMake(235, imgvBG.center.y);
//        [btnAddRecord addTarget:self action:@selector(addRecordClicked) forControlEvents:UIControlEventTouchUpInside];
//        [scvBG addSubview:btnAddRecord];
        
//        lblPhotoNum = [UILabel createLabelWithFrame:CGRectMake(290, 94 + 75+20 +87, 320, 50) font:[UIFont systemFontOfSize:17] textColor:[UIColor colorWithWhite:.44 alpha:1]];
//        lblPhotoNum.text = [NSString stringWithFormat:@"%@,%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),0,LocalizeStringFromKey(@"kPcs")];
//        lblPhotoNum.textAlignment = NSTextAlignmentLeft;
//        [scvBG addSubview:lblPhotoNum];

        imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(22, 94 + 75+20 +87, 152, 50)];
        [imgvBG setImage:[UIImage imageNamed:@"IKBGOrangeT.png"]];
        lbl = [UILabel createLabelWithFrame:CGRectMake(15, 0, 135, 50) font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor]];
        lbl.text = LocalizeStringFromKey(@"kClaimStatus");
        [imgvBG addSubview:lbl];
        [scvBG addSubview:imgvBG];
        
        lblState = [UILabel createLabelWithFrame:CGRectMake(192,94 + 75+20 +87, 250, 50) font:[UIFont systemFontOfSize:17] textColor:[UIColor colorWithWhite:.44 alpha:1]];
        lblState.textAlignment = NSTextAlignmentLeft;
        lblState.text = LocalizeStringFromKey(@"kNew");
        [scvBG addSubview:lblState];
        
    
        btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSubmit.clipsToBounds = YES;
        btnSubmit.layer.cornerRadius = 2;
        btnSubmit.frame = CGRectMake(-100, 0, 150, 40);
        btnSubmit.layer.borderColor = [UIColor colorWithRed:.95 green:.18 blue:.04 alpha:1].CGColor;
        btnSubmit.layer.borderWidth = 1;
        [btnSubmit setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.95 green:.35 blue:.31 alpha:1] size:btnSubmit.frame.size] forState:UIControlStateNormal];
        [btnSubmit setTitle:LocalizeStringFromKey(@"kCommit") forState:UIControlStateNormal];
        [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSubmit.titleLabel.font = [UIFont systemFontOfSize:20];
        btnSubmit.center = CGPointMake(self.frame.size.width*2/3, self.frame.size.height-70);
        [btnSubmit addTarget:self action:@selector(updateClicked) forControlEvents:UIControlEventTouchUpInside];
        [scvBG addSubview:btnSubmit];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.clipsToBounds = YES;
        btnSave.layer.cornerRadius = 2;
        btnSave.frame = CGRectMake(0, 0, 150, 40);
        btnSave.layer.borderColor = [UIColor colorWithRed:.95 green:.18 blue:.04 alpha:1].CGColor;
        btnSave.layer.borderWidth = 1;
        [btnSave setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.95 green:.35 blue:.31 alpha:1] size:btnSubmit.frame.size] forState:UIControlStateNormal];
        [btnSave setTitle:LocalizeStringFromKey(@"kSave") forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSave.titleLabel.font = [UIFont systemFontOfSize:20];
        btnSave.center = CGPointMake(self.frame.size.width/3, self.frame.size.height-70);
        [btnSave addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
        [scvBG addSubview:btnSave];
        isPad = YES;

        
//        [self showInfo];
        
        }
    return self;
}

-(void)getAryReportImagesClick:(NSNotification *)notification{

   aryReportImages =[notification valueForKey:@"object"];

//    NSMutableArray *array1 = [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoOtherArr;
//    NSMutableArray *array2 = [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoPaymentArr;
//    NSMutableArray *array3 = [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoCardArr;
//    
//    aryReportImages = [NSMutableArray arrayWithArray:array1];
//    [aryReportImages addObjectsFromArray:array2];
//    [aryReportImages addObjectsFromArray:array3];



}
-(void)visitType:(NSNumber *)key{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([key intValue]>0) {
        
        if (key.intValue == 1) {
            
            btn.tag = 3-1;
            //            btn.tag = 1-1;//wucy ----3月4号
            
            
        }if (key.intValue == 3) {
            
            
            btn.tag = 1-1;//wucy ----3月4号
            
        }else if(key.intValue !=1&&key.intValue !=3){
            
            
            //            btn.tag = 1-1;
            btn.tag = [key intValue]-1;
        }
        
        
        //        btn.tag = [visit.serviceType intValue]-1;  //wucy ----3月4号
        
        
        [self methodClicked:btn];
    }

}
- (void)showInfo{//传了visit参数的情况
    
    btnSave.hidden = NO;
    btnSubmit.center = CGPointMake(self.frame.size.width*2/3, self.frame.size.height-70);
    
  
    if ([self.key isEqualToString:@"YES"]) {
        [self visitType:visit.paymentsType];
    }else{
        [self visitType:visit.serviceType];
    }
    if([visit.visitExpenses floatValue]==0){
        tfExpenses.text =@"";
    }else{
//        float expensesValues =[visit.visitExpenses floatValue];
        tfExpenses.text = [IKDecodeWithUTF8 notRounding:[NSString stringWithFormat:@"%@", visit.visitExpenses] afterPoint:2];
//    tfExpenses.text =[NSString stringWithFormat:@"%.2f",[visit.visitExpenses floatValue]];//初值为0，改掉
    }
//    tfExpenses.text =@"";
    NSDateFormatter *formatter_end = [[NSDateFormatter alloc] init];
    [formatter_end setDateFormat:@"yyyy-MM-dd"];
    
//    lblDate.text = [formatter_end stringFromDate:visit.registrationTime];
//    lblEndDate.text =[formatter_end stringFromDate:visit.registrationTime];
    if (visit.beginDate) {
        lblDate.text = visit.beginDate;
    }
    if (visit.endDate) {
        lblEndDate.text =visit.endDate;
    }
    
    
}
//-(NSString *)notRounding:(NSString *)price afterPoint:(int)position{
//    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
//    NSDecimalNumber *ouncesDecimal;
//    NSDecimalNumber *roundedOunces;
//    
//    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:price];
//    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
//    return [NSString stringWithFormat:@"%@",roundedOunces];
//}

- (void)showInfo:(NSDictionary *)info{

    if (!info){
        self.userInteractionEnabled = NO;
        return;
    }else{
        
        btnDate.enabled = NO;
        btnDate_end.enabled = NO;
        vMethodList.userInteractionEnabled = NO;
        tfExpenses.enabled = NO;
        
        
        
    };
    

    dicApplyInfo = info;
   
    isPad  = [[dicApplyInfo objectForKey:@"isPad"] isEqualToString:@"Y"]?YES:NO;
    if (!isPad) {//加入时非pad端提交的内容
        [self getClaimImages];
    }
    

    btnSubmit.hidden = ![IKDataProvider canEditClaims]&&!isPad;
  
    btnSave.hidden = YES;
    btnSubmit.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-70);
    
    [btnSubmit setTitle:LocalizeStringFromKey(@"kupdate") forState:UIControlStateNormal];
    lblDate.text = [info objectForKey:@"beginDate"];
    lblEndDate.text =[info objectForKey:@"endDate"];
    NSString *str= [IKDecodeWithUTF8 notRounding:[info objectForKey:@"visitExpenses"] afterPoint:2];
//    NSString *status =[dicAuthInfo objectForKey:@"status"];
//    if ([str isEqualToString:@"0"]) {
//        if ( [status isEqualToString:@"理赔处理中"] ||[status isEqualToString:@"已赔付"]) {
//        tfExpenses.enabled = NO;
//        }else{
//            tfExpenses.enabled = YES;
//        }
//    }
    tfExpenses.text=str;
//    tfExpenses.text = [NSString stringWithFormat:@"%.2f",[[info objectForKey:@"visitExpenses"] floatValue]];
    lblState.text = vcApplyClaims.claimStatus;

    BOOL isUpdate = [[dicApplyInfo objectForKey:@"isUpdate"] boolValue];
    
    btnSubmit.enabled = isUpdate || !dicApplyInfo;//claimEditHistory
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = [[info objectForKey:@"visitType"] intValue]-1;
    
    [self methodClicked:btn];
    
    
    aryReportImages = [NSMutableArray arrayWithArray:[dicApplyInfo objectForKey:@"reportImgDetail"]];
    
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
    if (isPad) {
        if (aryReportImages.count>0) {
            lblPhotoNum.text = [NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),aryReportImages.count,LocalizeStringFromKey(@"kPcs")];
        }else{
            lblPhotoNum.text =[NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),0,LocalizeStringFromKey(@"kPcs")];
        }
//        lblPhotoNum.text = aryReportImages.count>0?[NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),aryReportImages.count,LocalizeStringFromKey(@"kPcs")]:[NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),0,LocalizeStringFromKey(@"kPcs")];

    }
     }


-(BOOL)canBeEdit{
    BOOL isUpdate = [[dicApplyInfo objectForKey:@"isUpdate"] boolValue];
   return isUpdate;

}


- (void)methodClicked:(UIButton *)btn{// 1—门诊;2-住院3-齿科,4-眼科,5-体检
    int index = (int)btn.tag%10;
    
    visitType = index+1;
    
    NSArray *categories = [@"1,2,3,4,5" componentsSeparatedByString:@","];
    for (int i=0;i<categories.count;i++){
        UIButton *b = (UIButton *)[vMethodList viewWithTag:200+i];
        b.selected = i==index;
  
    }
    


}



- (void)dateClicked:(UIButton *)btn{
    
    IKUnlimitDatePickerController *vcDatePicker = [[IKUnlimitDatePickerController alloc] init];
    vcDatePicker.datePicker.tag = btn.tag;
    [vcDatePicker.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    beginDate = [[UIPopoverController alloc] initWithContentViewController:vcDatePicker];
    
    [beginDate presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)dateChanged:(UIDatePicker *)picker{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (picker.tag == 1){
     lblDate.text = [formatter stringFromDate:picker.date];
     //   dateBegin = picker.date;
    }
    else {
     lblEndDate.text = [formatter stringFromDate:picker.date];
      // dateEnd = picker.date;
    }
    
    
}


- (void)getClaimImages{
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider getReportImage:@{@"claimsNo":vcApplyClaims.claimsNo}];
        
        NSLog(@"Claim images:%@",dict);
        sw_dispatch_sync_on_main_thread(^{

//            aryReportImages_noPad = [NSMutableArray arrayWithArray:@[@"http://192.168.1.222:8090/MSHPadService/upload/image/p00001063STRONGTECH-000120141112192907824.png",@"http://192.168.1.222:8090/MSHPadService/upload/image/P00000004ALLIANZ-000420141112214108183.png"]];
            
//                     aryReportImages_noPad = [NSMutableArray arrayWithArray:@[@"http://180.169.59.202:8090/MSHPadService/upload/image/P00000004ALLIANZ-000420141112214108183.png",@"http://180.169.59.202:8090/MSHPadService/upload/image/p00001063STRONGTECH-000120141112192907824.png"]];
            
                      aryReportImages_noPad =  [dict objectForKey:@"reportImgDetail"];
            
                lblPhotoNum.text = aryReportImages_noPad.count>0?[NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),aryReportImages_noPad.count,LocalizeStringFromKey(@"kPcs")]:nil;
            


        });
    }
}




//- (void)addRecordClicked{
//
//    [vcApplyClaims resignTextFieldInFirstResponse];
//    [tfExpenses resignFirstResponder];
//    
//    
// 
//    
//    IKAddRecordsPhotoView *v = [IKAddRecordsPhotoView view];
//    v.delegate = self;
//    v.canEditPhoto = [self canBeEdit];
//    v.isPad = isPad;
//    v.dicVisitInfo = dicApplyInfo;
//    v.visit = self.visit;
//    v.otherVisitInfo = otherVisitInfo;//适用于不存在于本地coredata数据库中的visit
//    if (isPad) {
//          v.aryList = [NSMutableArray arrayWithArray:aryReportImages];
//    }
//    else{
//          v.aryList = [NSMutableArray arrayWithArray:aryReportImages_noPad];
//    }
//  
//    [v show];
//}

-(void)saveClicked{
    NSLog(@"新增 commitClicked");
//    [self saveLocalClicked];
    //    btnSubmit.enabled = NO;
    
//    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kSubmitingClaim")];
    
    
//    if (![IKDataProvider canEditClaims]) {
//        [UIAlertView showAlertWithTitle:nil message:@"您没有权限进行此项操作" cancelButton:nil];
//        [SVProgressHUD dismiss];
//        return;
//    }
    NSDate *startDate= [self judgeTime:lblDate.text];
    NSDate *enDate= [self judgeTime:lblEndDate.text];
    NSTimeInterval timeInterval =[startDate timeIntervalSinceDate:enDate];
    if (timeInterval>0) {
        return;
    }
    if ([tfExpenses.text floatValue]==0){
        [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPleaseinputEstimatedCost") cancelButton:nil];
        [SVProgressHUD dismiss];
        return;
    }
    BOOL finished = YES;
    if (![vcApplyClaims authInfo]) {//左侧信息
        finished = NO;
    }
    
    if (tfExpenses.text.length == 0){//就诊费用
        finished = NO;
    }
    
    if (visitType == 0) {
        finished = NO;
    }
    
    if (!finished){
        [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPleaseinputthecolumnnecessary") cancelButton:nil];
        [SVProgressHUD dismiss];
        return;
    }else{
        IKApplyClaimsDetailUploadInfo *uploadInfo = [IKApplyClaimsDetailUploadInfo new];
        
//        btnSubmit.enabled = NO;
        //        [NSThread detachNewThreadSelector:@selector(showState) toTarget:self withObject:nil];
        //
        
        NSMutableDictionary *mut = [NSMutableDictionary dictionary];
        
        uploadInfo.parameters = mut;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString*   access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        [mut setObject:access_token forKey:@"key"];
        
        
        if (!otherVisitInfo) {
            if (visit){
                
                [mut setObject:visit.visitID forKey:@"visitId"];
                [mut setObject:visit.depID forKey:@"depID"];
                [mut setObject:visit.memberID forKey:@"memberID"];
                [mut setObject:visit.providerID forKey:@"providerID"];
            }else{
                
                [mut  setObject:vcApplyClaims.claimsNo forKey:@"claimsNo"];
                [mut setObject:[dicApplyInfo objectForKey:@"providerID"] forKey:@"providerID"];
                
            }
            
        }else{
            
            [mut setValuesForKeysWithDictionary:otherVisitInfo];
            
        }
        
        //左侧信息
        [mut setValuesForKeysWithDictionary:[vcApplyClaims authInfo]];
        
        //开始日期
        [mut setObject:lblDate.text  forKey:@"beginDate"];
        //结束日期
        [mut setObject:lblEndDate.text forKey:@"endDate"];
        //就诊费用
        NSString *str = [IKDecodeWithUTF8 notRounding:tfExpenses.text afterPoint:2];
        [mut setObject:str forKey:@"visitExpenses"];
        //就诊类别
        [mut setObject:[NSString stringWithFormat:@"%d",visitType] forKey:@"visitType"];
        //病例和发票
        
       aryReportImages = (NSMutableArray *)[vcApplyClaims selectImgArr];
        
        [mut setObject:[self reportImg:aryReportImages]?[self reportImg:aryReportImages]:@"" forKey:@"reportImg"];
        
        
        uploadInfo.photo = [NSMutableDictionary dictionary];
       [self saveUploadInfoToDataBase:uploadInfo];
    }

}
-(NSDate *)judgeTime:(NSString *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date= [dateFormatter dateFromString:time];
    return date;
}
- (void)updateClicked{
    NSDate *startDate= [self judgeTime:lblDate.text];
    NSDate *enDate= [self judgeTime:lblEndDate.text];
    NSTimeInterval timeInterval =[startDate timeIntervalSinceDate:enDate];
    if (timeInterval>0) {
        return;
    }
    if (![IKDataProvider canEditClaims]) {
                [UIAlertView showAlertWithTitle:nil message:@"您没有权限进行此项操作" cancelButton:nil];
        [SVProgressHUD dismiss];
                return;
    }
    
    if ([btnSubmit.titleLabel.text isEqualToString:LocalizeStringFromKey(@"kCommit")]) {
        if ([tfExpenses.text floatValue]==0){
            [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPleaseinputEstimatedCost") cancelButton:nil];
            [SVProgressHUD dismiss];
            return;
        }

    }
    
     BOOL finished = YES;
    if (![vcApplyClaims authInfo]) {//左侧信息
       finished = NO;
    }
    
    if (tfExpenses.text.length == 0){//就诊费用
        finished = NO;
    }
    
    if (visitType == 0) {
        finished = NO;
    }
    
    if (!finished){
     [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPleaseinputthecolumnnecessary") cancelButton:nil];
    [SVProgressHUD dismiss];
        return;
    }else{
        NSInvocationOperation *invocationOperation =[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadStatus) object:nil];
        sleep(0.1);
        [invocationOperation setCompletionBlock:^{
            [self loadPhoto];
        }];
        [invocationOperation start];
    }
    
   
}
-(void)loadStatus{
    [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kSubmitingClaim")];
}
-(void)loadPhoto
{
    btnSubmit.enabled = NO;
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString*   access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [mut setObject:access_token forKey:@"key"];
    if (!otherVisitInfo) {
        if (visit){
            
            [mut setObject:visit.visitID forKey:@"visitId"];
            [mut setObject:visit.depID forKey:@"depID"];
            [mut setObject:visit.memberID forKey:@"memberID"];
            [mut setObject:visit.providerID forKey:@"providerID"];
            
        }else{
            
            [mut  setObject:vcApplyClaims.claimsNo forKey:@"claimsNo"];
            [mut setObject:[dicApplyInfo objectForKey:@"providerID"] forKey:@"providerID"];
        }
    }else{
        
        [mut setValuesForKeysWithDictionary:otherVisitInfo];
        
    }
    
    //左侧信息
    [mut setValuesForKeysWithDictionary:[vcApplyClaims authInfo]];
    
    //开始日期
    [mut setObject:lblDate.text  forKey:@"beginDate"];
    //结束日期
    [mut setObject:lblEndDate.text forKey:@"endDate"];
    //就诊费用
    NSString *str = [IKDecodeWithUTF8 notRounding:tfExpenses.text afterPoint:2];
    [mut setObject:str forKey:@"visitExpenses"];
    //就诊类别
    [mut setObject:[NSString stringWithFormat:@"%d",visitType] forKey:@"visitType"];
    //病例和发票
    aryReportImages = (NSMutableArray *)[vcApplyClaims selectImgArr];
    [mut setObject:[self reportImg:aryReportImages]?[self reportImg:aryReportImages]:@"" forKey:@"reportImg"];
    [self loadOnePhoto:aryReportImages];
    if ([self checkPhotoAllSuccess].count >0) {
        photoIndex ++;
        if (photoIndex>1) {
            return;
        }
        [self loadOnePhoto:[self checkPhotoAllSuccess]];
    }

    
//        [SVProgressHUD showWithStatus:@"正在提交理赔信息"];
    [NSThread detachNewThreadSelector:@selector(submitApply:) toTarget:self withObject:mut];
    
}
-(void)loadOnePhoto:(NSMutableArray *)ary{
     if (ary.count>0){
        for (int i=0;i<ary.count;i++){
            
            @autoreleasepool {
                
                NSMutableDictionary *mutPicture = [NSMutableDictionary dictionary];//上传图片参数
                NSDate *date = [[ary objectAtIndex:i] objectForKey:@"date"];
                if (!date) {//当不存在时间表示是网上留下的图
                    continue;
                }
                NSString *seqID = [[ary objectAtIndex:i] objectForKey:@"seqID"];
                if(seqID ==nil){
                    break;
                }
                [mutPicture setObject:seqID forKey:@"seqID"];
                NSLog(@"seqID====**==== %@"  ,seqID);
                //                NSString *imagePath = [[aryReportImages objectAtIndex:i] objectForKey:@"photoPath"];
                UIImage *img = [[ary objectAtIndex:i] objectForKey:@"image"];//图片
                UIImage *finallyImg =[self judgePhotoSize:img];
                NSDateFormatter *formatter_update = [[NSDateFormatter alloc] init];
                [formatter_update setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                [mutPicture setObject:[formatter_update stringFromDate:date] forKey:@"createTime"];//拍摄时间
                [mutPicture setObject:[formatter_update stringFromDate:[NSDate date]]  forKey:@"modifyTime"];//修改时间
                NSString *type = [[ary objectAtIndex:i] objectForKey:@"type"];
                if (!otherVisitInfo) {
                    if (visit){
                        [mutPicture setObject:visit.depID forKey:@"depID"];
                        [mutPicture setObject:visit.memberID forKey:@"memberID"];
                        [mutPicture setObject:visit.providerID forKey:@"providerID"];
                    }else{
                        
                        //                           [mut setObject:vcApplyClaims.claimsNo forKey:@"claimsNo"];
                        //                           [mut setObject:[dicApplyInfo objectForKey:@"providerID"] forKey:@"providerID"];
                        
                    }
                    
                }else{
                    
                    //                       [mut setValuesForKeysWithDictionary:otherVisitInfo];
                    
                }
                
                //                    [mutPicture setObject:[NSString stringWithFormat:@"%d",IKPhotoTypeInsuranceCard] forKey:@"type"];//在线理赔病历照 = 4
                [mutPicture setObject:type forKey:@"type"];//在线理赔病历照 = 4
                NSData *data;
                if (finallyImg ==nil) {
                    data = UIImageJPEGRepresentation(img,1.0);// uiimage 转 nsdata
                }else{
                    data = UIImageJPEGRepresentation(finallyImg,1.0);// uiimage 转 nsdata
                }
                
                //                NSString *base64String = [data base64Encoding];//base64转码
                NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];//base64转码
                
                if (base64String){
                    [mutPicture setObject:base64String forKey:@"photoPath"];
                    
                    BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@[mutPicture],@"data",@"1",@"count",(isInLocal?@"1":@"0"),@"internetType",nil];
                    NSDictionary *dict = [IKDataProvider syncPhoto:param];
                    NSString *result = [dict objectForKey:@"result"];
                    int j = i+1;
                    if (result && result.intValue==0){
                        //  成功上传
                        NSLog(@"上传第 %d 张图片成功",j);
                        
                        //  [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传第 %d 张图片成功",j]];
                        
                        sw_dispatch_sync_on_main_thread(^{
                            photo = [IKPhotoCDSO photoWithSeqID:seqID];//查看coredata看看是否存在图片 如果存在只修改modifyTime
                            if (!photo){
                                
                                photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];//添加图片
                                photo.seqID = seqID;
                                if (self.visit) {//与visit关联
                                    photo.visit = self.visit;
                                    
                                }else {
                                    
                                    if (!self.otherVisitInfo) {
                                        
                                        IKAppDelegate *delegate =    (IKAppDelegate *)[UIApplication sharedApplication].delegate;
                                        photo.visit = delegate.visit;
                                        
                                    }
                                    
                                }
                                photo.createTime = date;
                                photo.image = img;
                                photo.type = [NSNumber numberWithInt:IKPhotoTypeInsuranceCard];
                                photo.type = [NSNumber numberWithInteger:[type integerValue]];
                                
                                
                            }
                            NSArray *dataAry =[dict objectForKey:@"data"];
                            if ([dataAry count]>0) {
                                NSString *imgPath =[[dataAry objectAtIndex:0] objectForKey:@"imagePath"];
                                
                                NSMutableDictionary *dict =(NSMutableDictionary *)[ary objectAtIndex:i];
                                if (![dict objectForKey:@"imagePath"]) {
                                    [dict setValue:imgPath forKey:@"imagePath"];
                                }
                                if (imgPath ==nil ||imgPath.length ==0) {
                                    photo.uploaded =[NSNumber numberWithBool:NO];
                                    
                                }else{
                                    photo.uploaded =[NSNumber numberWithBool:YES];
                                }
                            }
                            
                            photo.modifyTime = [NSDate date];
                            //                            if (!photo.visit.hospital){
                            //                                return ;
                            //                            }
                            
                        });
                        
                        //                           NSError *error = nil;
                        //                           [[IKDataProvider managedObjectContext] save:&error];
                        
                    }else{
                        
                        //    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]]];
                        NSLog(@"上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]);
                        photo.uploaded =[NSNumber numberWithBool:NO];
                        
                    }
                }
            }
        }
    }
}
-(NSMutableArray *)checkPhotoAllSuccess{
    NSMutableArray *ary =[NSMutableArray array];
    sw_dispatch_sync_on_main_thread(^{
        if (aryReportImages.count>0) {
            for (int i=0;i<aryReportImages.count;i++){
                NSDictionary *dict =[aryReportImages objectAtIndex:i];
//                IKPhotoCDSO *photoCD1 =[IKPhotoCDSO photoWithSeqID:[dict objectForKey:@"seqID"]];
                if ([dict objectForKey:@"imagePath"]==nil ||[[dict objectForKey:@"imagePath"] isEqualToString:@""]) {
                    [ary addObject:dict];
                }
            }
        }
    });
    
    return ary;
}

- (UIImage *)judgePhotoSize:(UIImage *)image{
    UIImage *finnanyImage ;
    if (image.size.width >1024 ||image.size.height >765) {
       finnanyImage= [self scaleToSize:image size:CGSizeMake(1024, 765)];
    }else{
        finnanyImage =image;
    }
    return finnanyImage;
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

-(void)showState{

   [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kSubmitingClaim")];


}

- (void)submitApply:(NSDictionary *)info{
    NSString *reportImgStr =[NSString stringWithFormat:@"%@",[info objectForKey:@"reportImg"]];
    NSMutableDictionary *dictTemp =[NSMutableDictionary dictionary];
    if (reportImgStr ==nil ||reportImgStr.length==0) {
        [dictTemp addEntriesFromDictionary:info];
    }else{
        [dictTemp addEntriesFromDictionary:info];
        [dictTemp setObject:[self reportImgFor:aryReportImages]?[self reportImgFor:aryReportImages]:@"" forKey:@"reportImg"];
    }
    @autoreleasepool {
        NSDictionary *dict = nil;
        
        if (dicApplyInfo){
            dict = [IKDataProvider getClaimUpdate:dictTemp];
        }
        else{
            dict = [IKDataProvider getClaimInsert:dictTemp];
        }
        
        sw_dispatch_sync_on_main_thread(^{
            int result = [[dict objectForKey:@"result"] intValue];
            if (0==result && dict){
                
                    photo.uploaded = [NSNumber numberWithBool:YES];
                if (self.visit) {//与visit关联
                 
                        self.visit.claimEditHistory = [NSNumber numberWithBool:YES];
                    }else {
                        
                        if (!self.otherVisitInfo) {
                            IKAppDelegate *delegate =    (IKAppDelegate *)[UIApplication sharedApplication].delegate;
                            delegate.visit.claimEditHistory = [NSNumber numberWithBool:YES];
                        }
                        
                    }

                [self changeDataBaseType];
//                 btnSubmit.enabled = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshClaimsApplyList" object:nil];
                
                [vcApplyClaims navBack];
                [SVProgressHUD showSuccessWithStatus:LocalizeStringFromKey(@"kSuccessClaim")];
                
            }else{
                btnSubmit.enabled = YES;
                      photo.uploaded = [NSNumber numberWithBool:NO];
                NSLog(@"API Failed:%@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:info options:0 error:nil] encoding:NSUTF8StringEncoding]);
                
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"提交理赔授权信息失败:%@",[dict objectForKey:@"errStr"]]];
            }
            
            NSError *error = nil;
            [[IKDataProvider managedObjectContext] save:&error];
        });
        
    }
}



#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return NO;
}


-(void)changeDataBaseType{
    
   
//    IKVisitCDSO *visitCDSO = [IKVisitCDSO vistWithID:visit.visitID] ;
//    if (!visitCDSO){
//        
//        visitCDSO = [NSEntityDescription insertNewObjectForEntityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];//添加图片
//        
//        
//    }
//    visitCDSO = visit;
    visit.uploaded = YES;
    
    //    [visitCDSO.detailInfo setValue:@"1" forKey: ];
    [[IKDataProvider managedObjectContext] save:nil];
    
    
}
#pragma mark - 4,2号
- (NSString *)reportImgFor:(NSArray *)arrar{
    if (arrar.count>0){
        NSMutableString *mutstr = [NSMutableString string];
        for (NSDictionary *dict in arrar){
            NSString *seqID = [dict objectForKey:@"seqID"];
            NSString *type = [dict objectForKey:@"type"];
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
        for (NSDictionary *dict in arrar){
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
//            photo.type = [NSNumber numberWithInt:IKPhotoTypeInsuranceCard];//在线理赔
//        }
//        
//        photo.modifyTime = [NSDate date];
//    }
//    
//    [[IKDataProvider managedObjectContext] save:nil];
    
    aryReportImages = [NSMutableArray arrayWithArray:photos];
    lblPhotoNum.text = aryReportImages.count>0?[NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),aryReportImages.count,LocalizeStringFromKey(@"kPcs")]:nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)removePhotoesBaseArr{
    
    [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoOtherArr removeAllObjects];
    [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoCardArr removeAllObjects];
    [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoPaymentArr removeAllObjects];
    
}

-(void)saveUploadInfoToDataBase:(IKApplyClaimsDetailUploadInfo *)uploadInfo{
    [self removeDataBasePhotoes];
    [self saveUploadParameterToDataBase:uploadInfo];
    [self saveUploadPhotoToDataBase:uploadInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveUploadInfoSuccess" object:nil];

    [vcApplyClaims navBack];
    

}
-(void)removeDataBaseVisit{
    
    
    IKVisitCDSO *visitCDSO = [IKVisitCDSO vistWithID:visit.visitID] ;
    if (visitCDSO) {
        [[IKDataProvider managedObjectContext] deleteObject:visit];
        [[IKDataProvider managedObjectContext] save:nil];
    }
   
}
-(void)removeDataBasePhotoes{
    
   
    IKVisitCDSO *visitCDSO = [IKVisitCDSO vistWithID:visit.visitID] ;
//     NSArray *photoArr = [visitCDSO.photos allObjects];
    NSArray *photoArr = visitCDSO.getShootingPhotoList;
    if (visitCDSO) {
        if (photoArr.count>0) {
            for (int i =0; i<photoArr.count; i++) {
                IKPhotoCDSO *phot = [photoArr objectAtIndex:i];
//                if ([photo.visit.visitID isEqualToString:visitCDSO.visitID]) {
                     [[IKDataProvider managedObjectContext] deleteObject:phot];
//                }
                
            }
        }
        
        [[IKDataProvider managedObjectContext] save:nil];
        
    }
    
}
-(void)saveUploadParameterToDataBase:(IKApplyClaimsDetailUploadInfo *)uploadInfo{
    
    NSDictionary *parameters = uploadInfo.parameters;
    IKVisitCDSO *visitCDSO = [IKVisitCDSO vistWithID:visit.visitID] ;
    if (!visitCDSO){
        
        visitCDSO = [NSEntityDescription insertNewObjectForEntityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];//添加图片
        
    
    }
    if (visitType==3) {
        visitType =1;
    }else if (visitType ==1){
        visitType =3;
    }
//    visitCDSO= visit;
    visitCDSO.createTime = [NSDate date];
    visitCDSO.visitExpenses =[NSNumber numberWithFloat:tfExpenses.text.floatValue];
    visitCDSO.beginDate = lblDate.text;
    visitCDSO.endDate = lblEndDate.text;
    visitCDSO.uploaded = NO;
    visitCDSO.serviceType = [NSNumber numberWithInt:visitType];
    visitCDSO.authInfoDic = [vcApplyClaims authInfo];
     visitCDSO.applyForTime = [NSDate date];
//    visitCDSO.applyForTimeAndMin = [NSDate date];
    visitCDSO.claimEditHistory = [NSNumber numberWithBool:YES];
    visitCDSO.providerID = visit.providerID;
    visitCDSO.visitID = visit.visitID;


    self.visit = visitCDSO;
    
//    [visitCDSO.detailInfo setValue:@"1" forKey: ];
    [[IKDataProvider managedObjectContext] save:nil];
     btnSave.enabled = NO;
  
    NSLog(@"save begin =======");
    [self.visit dump];
    NSLog(@"===== save end");
}


-(void)saveUploadPhotoToDataBase:(IKApplyClaimsDetailUploadInfo *)uploadInfo{
    
    if (aryReportImages.count>0) {
    
        for (int i=0;i<aryReportImages.count;i++){
        
         NSString *seqID = [[aryReportImages objectAtIndex:i] objectForKey:@"seqID"];
             NSLog(@"seqID======== %@"  ,seqID);
        UIImage *img = [[aryReportImages objectAtIndex:i] objectForKey:@"image"];//图片
        UIImage *image=[self judgePhotoSize:img];
        NSString *type = [[aryReportImages objectAtIndex:i] objectForKey:@"type"];//type
        NSDate *date = [[aryReportImages objectAtIndex:i] objectForKey:@"date"];
// photo = [IKPhotoCDSO photoWithSeqID:seqID];
//            if (!photo){
            
             IKPhotoCDSO * photoCD = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];//添加图片
                photoCD.seqID = seqID;
                if (self.visit) {//与visit关联
                    photoCD.visit = self.visit;
                    
                }else {
                    
                    if (!self.otherVisitInfo) {
                        
                        IKAppDelegate *delegate =    (IKAppDelegate *)[UIApplication sharedApplication].delegate;
                        photoCD.visit = delegate.visit;
                        
                    }
                    
                }
                
                photoCD.createTime = date;
            if (image ==nil) {
                photoCD.image = img;
            }else{
                photoCD.image = image;
            }
            
                photoCD.type = [NSNumber numberWithInt:[type intValue]];
                
//            }
//            else {
//            
//                if (self.visit) {//与visit关联
//                    photo.visit = self.visit;
//                    
//                }
//            
//            }
            photoCD.modifyTime = [NSDate date];

        
        }
        
        NSError *error = nil;
        [[IKDataProvider managedObjectContext] save:&error];
    }
    
    
    
}

@end
