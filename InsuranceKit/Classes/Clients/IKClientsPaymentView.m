//
//  IKClientsPaymentView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKClientsPaymentView.h"
#import "IKBorderCell.h"
#import "IKDecodeWithUTF8.h"
@implementation IKClientsPaymentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];
        
        
        
        UIView *vBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 177)];
        vBG.backgroundColor =  [UIColor colorWithRed:233.f/255.f green:239.f/255.f blue:244.f/255.f alpha:1];
        [self addSubview:vBG];
        
        
        
        aryValues = [NSMutableArray arrayWithObjects:[NSMutableDictionary dictionary],[NSMutableDictionary dictionary], nil];
        
        vBG = [[UIView alloc] initWithFrame:CGRectMake(55, 190, 270, 130)];
        vBG.backgroundColor = [UIColor colorWithRed:.93 green:.91 blue:.92 alpha:1];
        vBG.clipsToBounds = YES;
        vBG.layer.cornerRadius = 3;
        [self addSubview:vBG];
        
        
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(17, 17, 200, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kTotalAmount");
        [vBG addSubview:lbl];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(17, 70, 200, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kAmountDiscount");
        [vBG addSubview:lbl];
        
        
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(17, 45, vBG.frame.size.width-34, 13) font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithWhite:.33 alpha:1]];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = @"￥";
        [vBG addSubview:lbl];
        
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(110, 100, vBG.frame.size.width-17-110, 13)  font:[UIFont systemFontOfSize:13] textColor:[UIColor whiteColor]];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = @"￥";
        [vBG addSubview:lbl];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 12, lbl.frame.size.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [lbl addSubview:line];
        
        //本次就诊总费用
        tfTotal = [[UITextField alloc] initWithFrame:CGRectMake(17, 34, 240-23, 29)];
        tfTotal.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfTotal.font = [UIFont systemFontOfSize:28];
        tfTotal.textColor = [UIColor colorWithWhite:.33 alpha:1];
        tfTotal.textAlignment = NSTextAlignmentRight;
        tfTotal.keyboardType = UIKeyboardTypeDecimalPad;
        tfTotal.delegate = self;
        [vBG addSubview:tfTotal];
        
        
        lblDiscount = [[UITextField alloc] initWithFrame:CGRectMake(117, 82, 140-23, 29)];
        lblDiscount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        lblDiscount.font = [UIFont systemFontOfSize:28];
        lblDiscount.textColor = [UIColor colorWithWhite:0 alpha:1];
        lblDiscount.textAlignment = NSTextAlignmentRight;
        lblDiscount.keyboardType = UIKeyboardTypeDecimalPad;
        lblDiscount.delegate = self;
        [vBG addSubview:lblDiscount];
        
        
        vBG = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-55-270, 190, 270, 130)];
        vBG.backgroundColor = [UIColor colorWithRed:.93 green:.91 blue:.92 alpha:1];
        vBG.clipsToBounds = YES;
        vBG.layer.cornerRadius = 3;
        [self addSubview:vBG];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(17, 17, 200, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kDueCo-payment");
        [vBG addSubview:lbl];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(17, 70, 200, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text =LocalizeStringFromKey(@"kActualCo-payment");
        [vBG addSubview:lbl];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(17, 45, vBG.frame.size.width-34, 13) font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithWhite:.33 alpha:1]];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = @"￥";
        [vBG addSubview:lbl];//应付自付额单位
        
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(110, 100, vBG.frame.size.width-17-110, 13) font:[UIFont systemFontOfSize:13] textColor:[UIColor whiteColor]];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = @"￥";
        [vBG addSubview:lbl];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, 12, lbl.frame.size.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [lbl addSubview:line];
        
        lblShouldPaid = [UILabel createLabelWithFrame:CGRectMake(17, 34, 240-23, 29) font:[UIFont systemFontOfSize:28] textColor:[UIColor colorWithWhite:.33 alpha:1]];
        lblShouldPaid.textAlignment = NSTextAlignmentRight;
        [vBG addSubview:lblShouldPaid];
        
        
        tfPaid = [[UITextField alloc] initWithFrame:CGRectMake(117, 82, 140-23, 29)];
        tfPaid.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfPaid.font = [UIFont systemFontOfSize:28];
        tfPaid.textColor = [UIColor colorWithWhite:0 alpha:1];
        tfPaid.textAlignment = NSTextAlignmentRight;
        tfPaid.keyboardType = UIKeyboardTypeDecimalPad;
        [vBG addSubview:tfPaid];
        
        vBG = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width-594)/2, 336, [InternationalControl isEnglish]?614:594, 88)];
        vBG.backgroundColor = [UIColor colorWithRed:222.f/255.f green:218.f/255.f blue:220.f/255.f alpha:1];
        vBG.clipsToBounds = YES;
        vBG.layer.cornerRadius = 3;
        [self addSubview:vBG];
        
        
        UIView* v_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 44, vBG.frame.size.width, 44)];
        v_bg.backgroundColor = [UIColor colorWithRed:.93 green:.91 blue:.92 alpha:1];
        v_bg.clipsToBounds = YES;
        v_bg.layer.cornerRadius = 3;
        [vBG addSubview:v_bg];
        
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(33, 15, 55, 16) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kCo-pay");
        lbl.textAlignment = NSTextAlignmentCenter;
        [vBG addSubview:lbl];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(130, 15, 90, 16) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text =LocalizeStringFromKey(@"kProviderco-pay");
        lbl.textAlignment = NSTextAlignmentCenter;
        [vBG addSubview:lbl];
        [lbl sizeToFit];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(260, 15, 55, 16) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kDeductible");
        lbl.textAlignment = NSTextAlignmentCenter;
        [vBG addSubview:lbl];
        [lbl sizeToFit];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(360, 15, 90, 16) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text =LocalizeStringFromKey(@"kPolicyco-pay");
        lbl.textAlignment = NSTextAlignmentCenter;
        [vBG addSubview:lbl];
        [lbl sizeToFit];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(470, 15, 90, 16) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kExceedOPlimitation");
        lbl.textAlignment = NSTextAlignmentCenter;
        [vBG addSubview:lbl];
        [lbl sizeToFit];
        
        float widths[] = {.17f,.39f,.56f,.765f};
        float x = 0;
        for (int i = 0;i<4;i++) {
            x = widths[i]*594;
            UILabel* lbl_unit = [UILabel createLabelWithFrame:CGRectMake(x, 15,16, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor colorWithWhite:.35 alpha:1]];
            lbl_unit.text = i == 0 ?@"=":@"+";
            lbl_unit.textAlignment = NSTextAlignmentCenter;
            [v_bg addSubview:lbl_unit];
            
        }
        
        
        
        
        lblCopay =[UILabel createLabelWithFrame:CGRectMake(5, 15,90, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor blackColor]];
        lblCopay.textAlignment = NSTextAlignmentCenter;
        
        [v_bg addSubview:lblCopay];
        
        
        lblHospitalCopy =[UILabel createLabelWithFrame:CGRectMake(122, 15,110, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor blackColor]];
        lblHospitalCopy.textAlignment = NSTextAlignmentCenter;
        
        [v_bg addSubview:lblHospitalCopy];
        
        lblfranchise =[UILabel createLabelWithFrame:CGRectMake(252, 15,76, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor blackColor]];
        lblfranchise.textAlignment = NSTextAlignmentCenter;
        
        [v_bg addSubview:lblfranchise];
        
        lblInsuranceCopy =[UILabel createLabelWithFrame:CGRectMake(353, 15,95, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor blackColor]];
        lblInsuranceCopy.textAlignment = NSTextAlignmentCenter;
        
        [v_bg addSubview:lblInsuranceCopy];
        
        
        lblOutpatientMaxLimit =[UILabel createLabelWithFrame:CGRectMake(476, 15,113, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor blackColor]];
        lblOutpatientMaxLimit.textAlignment = NSTextAlignmentCenter;
        
        [v_bg addSubview:lblOutpatientMaxLimit];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake((frame.size.width-594)/2, 429, 594, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor colorWithWhite:.35 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"k_paymentviewNote");
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 2;
        btn.frame = CGRectMake(0, 0, 150, 40);
        btn.layer.borderColor = [UIColor colorWithRed:.95 green:.18 blue:.04 alpha:1].CGColor;
        btn.layer.borderWidth = 1;
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.95 green:.35 blue:.31 alpha:1] size:btn.frame.size] forState:UIControlStateNormal];
        [btn setTitle:LocalizeStringFromKey(@"kSave") forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        btn.center = CGPointMake(frame.size.width/2, frame.size.height-44);
        [self addSubview:btn];
        [btn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
        
        //初始化coverflow  默认选择中间一页
        _openFlowView  = [[AFOpenFlowView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 177)];
        _openFlowView.dataSource = self;
        _openFlowView.viewDelegate = self;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"portlet_cover_default_background.png" ofType:nil];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
        _openFlowView.defaultImage = img;
        
        [self addSubview:_openFlowView];
        
        [_openFlowView setNumberOfImages:5];//设置coverflow页数
        dPaymentType =3;  //调整为 1—齿科;2-住院,3-门诊,4-眼科,5-体检
        dentalType = 0;//  1—基础治疗;2-预防治疗,3-重大治疗,4-矫正治疗
        [_openFlowView setSelectedCover:dPaymentType-1];//设置默认选中页
        [_openFlowView centerOnSelectedCover:NO];//中间页面选中动画是否显示
        
    }
    return self;
}

- (void)showInfo{
    
    NSDictionary * visit_DetailInfo = visit.detailInfo;
    
    
    
    NSArray *item_value =@[
                           @{LocalizeStringFromKey(@"kDental"):[visit_DetailInfo                           objectForKey:@"dentalHCopay"]},
                           @{LocalizeStringFromKey(@"kInpatient"):[visit_DetailInfo objectForKey:@"inHCopay"]},
                           @{LocalizeStringFromKey(@"kOutpatient"):[visit_DetailInfo objectForKey:@"outHCopay"]},
                           @{LocalizeStringFromKey(@"kVision"):[visit_DetailInfo objectForKey:@"visionHCopay"]},
                           @{LocalizeStringFromKey(@"kWellness"):[visit_DetailInfo objectForKey:@"checkupHCopay"]}];
    
    //  NSArray *item_title = @[@"齿科",@"住院",@"门诊",@"眼科",@"体检"];
    
    
    
    
    NSArray *item_title = @[LocalizeStringFromKey(@"kDental"),
                            LocalizeStringFromKey(@"kInpatient"),
                            LocalizeStringFromKey(@"kOutpatient"),
                            LocalizeStringFromKey(@"kVision"),
                            LocalizeStringFromKey(@"kWellness")];
    
    //齿科 Provider Co-Pay
    dentalValues = @[[visit_DetailInfo objectForKey:@"dBasicCopay"],
                     [visit_DetailInfo objectForKey:@"dPreventativeCopay"],
                     [visit_DetailInfo objectForKey:@"dMajorCopay"],
                     [visit_DetailInfo objectForKey:@"dOrthodonticsCopay"]];
    
    dPaymentType = visit.paymentsType.integerValue?visit.paymentsType.integerValue:3;
    [_openFlowView setSelectedCover:dPaymentType-1];//默认选中中间页
    for (int i = 0 ; i<5; i++) {
        
        IKItemView *item  = [[IKItemView alloc] initWithFrame:CGRectMake(0, 0, 227, 130) showItemInfo:[item_title objectAtIndex:i] value:[[item_value objectAtIndex:i] objectForKey:[item_title objectAtIndex:i]] atIndex:i];
        if (i!=dPaymentType-1)
            [item makeSelected:NO];
        else
            [item makeSelected:YES];
        [_openFlowView setContentView:item forIndex:i];
        
    }
    
    
   
    
    if (visit.paymentEdit) {//是否新建  还是数据库中有数据的
        
        NSString *total =[IKDecodeWithUTF8 notRounding:[NSString stringWithFormat:@"%@",visit.totalCopay] afterPoint:2];
        NSString *paid =[IKDecodeWithUTF8 notRounding:[NSString stringWithFormat:@"%@",visit.actualCopay] afterPoint:2];
        NSString *discount =[IKDecodeWithUTF8 notRounding:[NSString stringWithFormat:@"%@",visit.visitExpenses] afterPoint:2];
//        float total = visit.totalCopay.floatValue;//本次就诊总费用
//        float paid = visit.actualCopay.floatValue;//实际自付额
//        float discount = visit.visitExpenses.floatValue;//折后价
        if (visit.paymentsType.floatValue == 1) {// 当为齿科的时候 需要取dentaltype参数
            dentalType = visit.dentalType.floatValue;
        }
        
        tfTotal.text = [total floatValue]>0?total:@"0";
        tfPaid.text = [paid floatValue]>0?paid:@"0";
        lblDiscount.text = [discount floatValue]>0?discount:@"0";
        lblShouldPaid.text = [NSString stringWithFormat:@"%.2f",[self shouldPay]];//应自付额
        
        if ([lblShouldPaid.text floatValue]==0)
            lblShouldPaid.text = @"0";
    }
    
}


- (void)saveClicked{
    
    if (dentalType==0 && dPaymentType == 1){//当为齿科的时候 需要选择齿科类型
        //kDental-pay
        [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kDental-pay") cancelButton:nil];
        return;
    }
    
    
    
    [self endEditing:YES];
    
    if (tfTotal.text.length>0 && tfPaid.text.length>0 &&lblDiscount.text.length>0){
//        visit.totalCopay = [NSNumber numberWithFloat:tfTotal.text.floatValue];//总费用
//        visit.actualCopay = [NSNumber numberWithFloat:tfPaid.text.floatValue];//实际支付额
//        visit.visitExpenses =[NSNumber numberWithFloat:lblDiscount.text.floatValue];//折后价
        NSNumberFormatter *numberFormatter =[[NSNumberFormatter alloc] init];
        visit.totalCopay =[numberFormatter numberFromString:[IKDecodeWithUTF8 notRounding:tfTotal.text afterPoint:2 ]];//总费用
        visit.actualCopay = [numberFormatter numberFromString:[IKDecodeWithUTF8 notRounding:tfPaid.text afterPoint:2]];//实际支付额
        //  visit.shouldPay =[NSNumber numberWithFloat:lblShouldPaid.text.floatValue];//应付自付额  可以不存入db  由数据本身关系自己算出
        visit.visitExpenses =[numberFormatter numberFromString:[IKDecodeWithUTF8 notRounding:lblDiscount.text afterPoint:2]];//折后价
        visit.paymentTime = [NSDate date];
        visit.modifyTime = [NSDate date];
        visit.paymentsType = [NSNumber numberWithInt:dPaymentType];
        visit.paymentEdit = [NSNumber numberWithInt:YES];
        visit.dentalType =  [NSNumber numberWithInt:dentalType];
        
        [[IKDataProvider managedObjectContext] save:nil];
        
        if (self.visit.claimEditHistory) {
            [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kSaved") cancelButton:nil];
        }
        
        sw_dispatch_async_on_background_thread(^{
            NSDictionary *dict = [IKDataProvider performVisitSyncTaskOnce:visit];
            sw_dispatch_sync_on_main_thread(^{
                int result = [[dict objectForKey:@"result"] intValue];
                if (dict && result==0){
                    visit.uploadTime = [NSDate date];
                    [[IKDataProvider managedObjectContext] save:nil];
                    
                    //                    //主动跳转到新增理赔   有一个疑问 是否需要权限配置
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyClaims" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.visit,@"visit", nil]];
                    
                    if(!self.visit.claimEditHistory){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:LocalizeStringFromKey(@"kSubmitclaim") delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kSure") otherButtonTitles:LocalizeStringFromKey(@"kCancel"), nil];
                        [alert show];}
                    
             
                    
                    
                }else{
                    NSLog(@"提交就诊信息失败:%@",dict);
                }
            });
        });
        
        
        
        
    }else{
        [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPleaseinputtotalamountactualco-pay") cancelButton:nil];
    }
}

- (NSString *)unit:(NSString *)content{
    NSArray *ary = [content componentsSeparatedByString:@" "];
    if (ary.count==2)
        return [ary objectAtIndex:0];
    else
        return @"CNY";
}

- (NSString *)amount:(NSString *)content{
    NSArray *ary = [content componentsSeparatedByString:@" "];
    if (ary.count>0)
        return [ary objectAtIndex:0];
    else
        return @"0";
    
}

- (BOOL)isRatio: (NSString*)content{
    if ([content rangeOfString:@"%"].location != NSNotFound)
        return YES;
    else
        return NO;
}


- (float)shouldPay{
    NSDictionary *dicInfo = visit.detailInfo;
    
    isPercent = [self isRatio:[dicInfo objectForKey:@"inCopay"]];//判断是否有百分号
    float shoudPay = 0;
    if (isPercent) {
        float ratio = 0;//providecopay   医院自付额比率
        float total = lblDiscount.text.floatValue;//折后价
        NSString *yearFranchise = [dicInfo objectForKey:@"yearFranchise"];//用于门诊和住院的免赔额
        NSString *todayfranchise = [dicInfo objectForKey:@"franchise"];//用于门诊和住院的免赔额
        NSString *franchise =@"";
        if ([yearFranchise isEqualToString:@"0"]) {
            if ([todayfranchise isEqualToString:@"0"]) {
                franchise =@"";
            }else{
                franchise =todayfranchise;
            }
        }else if ([todayfranchise isEqualToString:@"0"]) {
            if ([yearFranchise isEqualToString:@"0"]) {
                franchise =@"";
            }else{
                franchise =yearFranchise;
            }
        }
        NSString *dentalDeductible = [dicInfo objectForKey:@"dentalDeductible"];//用于齿科的免赔额
        NSString *visionDeductible = [dicInfo objectForKey:@"visionDeductible"];//用于眼科的免赔额
        NSString *wellnessDeductible = [dicInfo objectForKey:@"wellnessDeductible"];//用于体检的免赔额
        
        
        NSString *outpatientMaxLimit = [dicInfo objectForKey:@"outpatientMaxLimit"];
        //  1—齿科;2-住院3-门诊,4-眼科,5-体检franchise
        switch (dPaymentType) {
            case 1:
                ratio = [[dicInfo objectForKey:@"dentalHCopay"] floatValue]/100.0f;
                
                break;
            case 2:
                ratio = [[dicInfo objectForKey:@"inHCopay"] floatValue]/100.0f;
                
                break;
                
            case 3:
                ratio = [[dicInfo objectForKey:@"outHCopay"] floatValue]/100.0f;
               
                break;
                
            case 4:
                ratio = [[dicInfo objectForKey:@"visionHCopay"] floatValue]/100.0f;
                break;
                
            case 5:
                
                ratio = [[dicInfo objectForKey:@"checkupHCopay"] floatValue]/100.0f;
                break;
                
                
            default:
                break;
        }
        
        
        float mpe;//免赔额
        float mzxe = 0;//除去其他的门诊限额
        float yyzfe = total*ratio;//医院自付额
        
        float bxzfe =0;//保险自付额
        float policyRatio = 0;//policy copay
        
        BOOL skip = NO;
        
        switch (dPaymentType) {
            case 1:
                if (dPaymentType == 1 && dentalType == 0) {
                    [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kDental-pay") cancelButton:nil];
                    return NO;
                }
                policyRatio= [[dentalValues objectAtIndex:(dentalType -1) ]floatValue]/100.0;
                mpe = [[self amount:dentalDeductible] floatValue];//齿科免赔额
                if (total - yyzfe <=mpe) {
                    skip = YES;
                    mpe = total - yyzfe;
                    bxzfe = 0;
                }else{
                    bxzfe  = (total - yyzfe - mpe)*policyRatio;
                }

                
                break;
            case 2:
                policyRatio = [[dicInfo objectForKey:@"inCopay"] floatValue]/100.0f;
                mpe = [[self amount:franchise] floatValue];//住院免赔额
                if (total - yyzfe <=mpe) {
                    skip = YES;
                    mpe = total - yyzfe;
                    bxzfe = 0;
                }else{
                    bxzfe  = (total - yyzfe - mpe)*policyRatio;
                }
                break;
            case 3:
                
                mzxe = [[self amount:outpatientMaxLimit] floatValue];
                policyRatio = [[dicInfo objectForKey:@"outCopay"] floatValue]/100.0f;
                mpe = [[self amount:franchise] floatValue];//门诊免赔额
                
                if (total - yyzfe <=mpe) {
                    skip = YES;
                    mpe = total - yyzfe;
                    bxzfe = 0;
                }else{
                    bxzfe  = (total - yyzfe - mpe)*policyRatio;
                }
                
                
               break;
                
            case 4:
       
                policyRatio = [[dicInfo objectForKey:@"visionCopay"] floatValue]/100.0f;
                
                mpe = [[self amount:visionDeductible] floatValue];//眼科免赔额
                // policyRatio = 0;//默认为0
                if (total - yyzfe <=mpe) {
                    skip = YES;
                    mpe = total - yyzfe;
                    bxzfe = 0;
                }else{
                    bxzfe  = (total - yyzfe - mpe)*policyRatio;
                }
                break;
                
            case 5:
                policyRatio = [[dicInfo objectForKey:@"wellnessCopay"] floatValue]/100.0f;
                mpe = [[self amount:wellnessDeductible] floatValue];//眼科免赔额
                // policyRatio = 0;//默认为0
                if (total - yyzfe <=mpe) {
                    skip = YES;
                    mpe = total - yyzfe;
                    bxzfe = 0;
                }else{
                    bxzfe  = (total - yyzfe - mpe)*policyRatio;
                }
                break;
                
                
            default:
                break;
        }
        
        
        if (skip) {
            shoudPay = yyzfe + mpe;
            lblOutpatientMaxLimit.text =  [NSString stringWithFormat:@"%.2f",0.00];//超门诊上限
            lblfranchise.text =  [NSString stringWithFormat:@"%.2f",mpe];//免赔额
            lblCopay.text = [NSString stringWithFormat:@"%.2f",shoudPay];//自付额
            lblHospitalCopy.text = [NSString stringWithFormat:@"%.2f",yyzfe];//医院自付额
            lblInsuranceCopy.text =  [NSString stringWithFormat:@"%.2f",bxzfe];//保险自付额
        }else{
            if (mzxe == 0) {
                shoudPay = yyzfe + mpe +bxzfe;
                lblOutpatientMaxLimit.text =  [NSString stringWithFormat:@"%.2f",0.00];//超门诊上限
            }
            else{
                if ((total-yyzfe-mpe -bxzfe)>mzxe) {
                    shoudPay = yyzfe + mpe +bxzfe +(total - yyzfe -mpe -bxzfe -mzxe);
                }else{
                    shoudPay = yyzfe + mpe +bxzfe;
                }
                
                if (total-yyzfe-mpe-bxzfe-mzxe > 0) {
                    lblOutpatientMaxLimit.text =  [NSString stringWithFormat:@"%.2f",total-yyzfe-mpe-bxzfe-mzxe];//超门诊上限
                }else{
                    lblOutpatientMaxLimit.text =  [NSString stringWithFormat:@"%.2f",0.00];//超门诊上限
                }
            }
            lblfranchise.text =  [NSString stringWithFormat:@"%.2f",mpe];//免赔额
            lblCopay.text = [NSString stringWithFormat:@"%.2f",shoudPay];//自付额
            lblHospitalCopy.text = [NSString stringWithFormat:@"%.2f",yyzfe];//医院自付额
            lblInsuranceCopy.text =  [NSString stringWithFormat:@"%.2f",bxzfe];//保险自付额
        }
    }
    return shoudPay;
}


- (void)typeClicked:(UIButton *)sender{
    
    
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField==tfTotal){
//        tfTotal.text = [NSString stringWithFormat:@"%.2f",tfTotal.text.floatValue];
//        lblDiscount.text = [NSString stringWithFormat:@"%.2f",tfTotal.text.floatValue];
//        lblShouldPaid.text = [NSString stringWithFormat:@"%.2f",[self shouldPay]];
        tfTotal.text = [IKDecodeWithUTF8 notRounding:tfTotal.text afterPoint:2];
        lblDiscount.text = [IKDecodeWithUTF8 notRounding:tfTotal.text afterPoint:2];
        lblShouldPaid.text = [NSString stringWithFormat:@"%.2f",[self shouldPay]];
    }
    else if (textField==tfPaid){
        tfPaid.text = [IKDecodeWithUTF8 notRounding:tfPaid.text afterPoint:2];
//        tfPaid.text = [NSString stringWithFormat:@"%.2f",tfPaid.text.floatValue];
    }else if (textField==lblDiscount){
//        lblDiscount.text = [NSString stringWithFormat:@"%.2f",lblDiscount.text.floatValue];
        lblDiscount.text = [IKDecodeWithUTF8 notRounding:lblDiscount.text afterPoint:2];
        lblShouldPaid.text = [NSString stringWithFormat:@"%.2f",[self shouldPay]];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if (textField==tfTotal){
        
        
        if (dPaymentType == 1 && dentalType == 0) {
            [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kDental-pay") cancelButton:nil];
            return NO;
            
        }
        
    }
    
    return YES;
}

#pragma mark -
#pragma mark AFOpenFlowViewDelegate
- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index {
    
    
    
    NSLog(@"%d",index);
    
    dPaymentType = index +1;
    
    
    
    if (dentalType==0 && dPaymentType == 1) {
        
    }else{
        
        if ([tfTotal.text length]>0) {
            lblShouldPaid.text = [NSString stringWithFormat:@"%.2f",[self shouldPay]];//应自付额
            
            if ([lblShouldPaid.text floatValue]==0)
                lblShouldPaid.text = @"0";
        }
    }
    
    
    NSDictionary * visit_DetailInfo = visit.detailInfo;
    
    
    
    NSArray *item_value =@[
                           @{LocalizeStringFromKey(@"kDental"):[visit_DetailInfo                           objectForKey:@"dentalHCopay"]},
                           @{LocalizeStringFromKey(@"kInpatient"):[visit_DetailInfo objectForKey:@"inHCopay"]},
                           @{LocalizeStringFromKey(@"kOutpatient"):[visit_DetailInfo objectForKey:@"outHCopay"]},
                           @{LocalizeStringFromKey(@"kVision"):[visit_DetailInfo objectForKey:@"visionHCopay"]},
                           @{LocalizeStringFromKey(@"kWellness"):[visit_DetailInfo objectForKey:@"checkupHCopay"]}];
    
    //  NSArray *item_title = @[@"齿科",@"住院",@"门诊",@"眼科",@"体检"];
    
    
    
    
    NSArray *item_title = @[LocalizeStringFromKey(@"kDental"),
                            LocalizeStringFromKey(@"kInpatient"),
                            LocalizeStringFromKey(@"kOutpatient"),
                            LocalizeStringFromKey(@"kVision"),
                            LocalizeStringFromKey(@"kWellness")];
    
    //齿科 Provider Co-Pay
    dentalValues = @[[visit_DetailInfo objectForKey:@"dBasicCopay"],
                     [visit_DetailInfo objectForKey:@"dPreventativeCopay"],
                     [visit_DetailInfo objectForKey:@"dMajorCopay"],
                     [visit_DetailInfo objectForKey:@"dOrthodonticsCopay"]];
    
    
    for (int i = 0 ; i<5; i++) {
        
        IKItemView *item  = [[IKItemView alloc] initWithFrame:CGRectMake(0, 0, 227, 130) showItemInfo:[item_title objectAtIndex:i] value:[[item_value objectAtIndex:i] objectForKey:[item_title objectAtIndex:i]] atIndex:i];
        if (i!=index)
            [item makeSelected:NO];
        else
            [item makeSelected:YES];
        [_openFlowView setContentView:item forIndex:i];
        
    }
    
}


- (void)openFlowView:(AFOpenFlowView *)openFlowView didWannaCheckIndex:(int)index {
    
    NSLog(@"%d",index);
    
    if (index == 0) {
        IKItemPopViewViewController *popItem = [[IKItemPopViewViewController alloc] init];
        popItem.title_Values = dentalValues;// 基础  预防  重大  矫正
        popItem.selectIndex = dentalType;
        popItem.delegate =self;
        popItemVC = [[UIPopoverController alloc] initWithContentViewController:popItem];
        [popItemVC presentPopoverFromRect:_openFlowView.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}


#pragma mark -
#pragma mark IKItemPopSelect
-(void)itemSelectAtIndex:(int)index{
    
    NSLog(@"%d",index);
    dentalType = index;
    
    if ([tfTotal.text length]>0) {
        
        if (dentalType==0 && dPaymentType == 1) {
            
        }else{
            
            
            lblShouldPaid.text = [NSString stringWithFormat:@"%.2f",[self shouldPay]];//应自付额
            
            if ([lblShouldPaid.text floatValue]==0)
                lblShouldPaid.text = @"0";
        }
        
        
        
    }
    
    
}

#pragma mark -
#pragma mark AFOpenFlowViewDataSource

- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index {
    NSLog(@"%d",index);
    
    
}

- (UIImage *)defaultImage {
    NSString *pathx = [[NSBundle mainBundle] pathForResource:@"portlet_cover_default_background.png" ofType:nil];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:pathx];
    return image;
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
//    if ([buttonTitle isEqualToString:@"确认"]){
    if (buttonIndex ==0){

        //主动跳转到新增理赔   有一个疑问 是否需要权限配置
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyClaims" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.visit,@"visit",@"YES",@"key", nil]];
        
    }
}



@end
