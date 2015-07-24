//
//  IKShootingView.m
//  InsuranceKit
//
//  Created by K.E. on 15/1/26.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import "IKShootingView.h"
#import "IKApplyClaimsPhotoInformation.h"
#import "IKPhotoCDSO.h"
#import "IKDecodeWithUTF8.h"
@implementation IKShootingView

@synthesize key,necessary,lineColor,otherVisitInfo;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title shootingPagesTextColor:(UIColor*)color shootingPagesText:(NSString *)shootingPagesText photoImgName:(NSString *)photoImgName claimType:(NSInteger)claimType  visit:(IKVisitCDSO *)visi
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
          claimPhotoType = claimType;
       
      
        self.necessary = NO;
        
        photoImageview =[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 40, 41)];
        [photoImageview setUserInteractionEnabled:YES];
        [photoImageview setImage:[UIImage imageNamed:photoImgName]];
        [self addSubview:photoImageview];
        
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:20]];
        
        lblTitle = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(photoImageview.frame)+10, 5, size.width, 25) font:[UIFont systemFontOfSize:20] textColor:[UIColor colorWithWhite:.15 alpha:1]];
        [self addSubview:lblTitle];
        lblTitle.text = title;
//        lblTitle.textColor = color;
        
        lblShootingPages =[UILabel createLabelWithFrame:CGRectMake(lblTitle.frame.origin.x, CGRectGetMaxY(lblTitle.frame), 100, 15) font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithWhite:.15 alpha:1]];
        [self addSubview:lblShootingPages];
        lblShootingPages.text = shootingPagesText;
        lblShootingPages.textColor = color;
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-.5f, frame.size.width, .5f)];
        line.backgroundColor = [UIColor colorWithWhite:.87 alpha:1];
        [self addSubview:line];
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button .frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        button.tag =claimType;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
//        [self insertSubview:button aboveSubview:];
        
//        aryReportImages = [NSMutableArray array];
        self.visit = visi;
        if (self.visit) {
            
            [self vistWithID:self.visit.visitID];
        }
        isPad = YES;
    }
    
    return self;
}

-(void)vistWithID:(NSString *)visit{
    NSLog(@"Read visit begin =====");
   [self.visit dump];
    NSLog(@"========Read visit end");
    NSArray *imgArr = self.visit.getShootingPhotoList;
    NSMutableArray *imageInsuranceCardArr = [NSMutableArray array];
    NSMutableArray *imagePhotoTypeClaimArr = [NSMutableArray array];
    NSMutableArray *imageOtherListArr = [NSMutableArray array];
    for (int i = 0; i<imgArr.count; i++) {
        IKPhotoCDSO *photo = [imgArr objectAtIndex:i];
        if (photo.type == [NSNumber numberWithInteger:IKPhotoTypeInsuranceCard]) {
            
            
            [imageInsuranceCardArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:photo.createTime,@"date",photo.image,@"image",photo.seqID,@"seqID",photo.type,@"type", nil]];
        }
       
       else if (photo.type == [NSNumber numberWithInteger:IKPhotoTypeClaimClaimsPaymentList]) {
            [imagePhotoTypeClaimArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:photo.createTime,@"date",photo.image,@"image",photo.seqID,@"seqID",photo.type,@"type", nil]];
        }
//        IKPhotoCDSO *photo2 = [self signatureClaimsOtherListImage:[imgArr objectAtIndex:i]];
         else if (photo.type == [NSNumber numberWithInteger:IKPhotoTypeClaimClaimsOtherList]) {
            [imageOtherListArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:photo.createTime,@"date",photo.image,@"image",photo.seqID,@"seqID",photo.type,@"type", nil]];
        }
        
        
    }
    
    self.photoCardArr= [NSMutableArray arrayWithArray:imageInsuranceCardArr];
    self.photoOtherArr= [NSMutableArray arrayWithArray:imageOtherListArr];
    self.photoPaymentArr= [NSMutableArray arrayWithArray:imagePhotoTypeClaimArr];
    
   
    [self setDataAryReportImages];
    [self setLblShootingPagesText];
   
  
   
}

-(void)setDataAryReportImages{

    aryReportImages = [NSMutableArray arrayWithArray:self.photoCardArr];
    [aryReportImages addObjectsFromArray: self.photoOtherArr];
    [aryReportImages addObjectsFromArray:self.photoPaymentArr];
    
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"getAryReportImages"  object:aryReportImages];
    
//    [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoAllArr = aryReportImages;
    [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoOtherArr = (NSMutableArray*)self.photoOtherArr;
    [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoCardArr = (NSMutableArray*)self.photoCardArr;
    [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoPaymentArr = (NSMutableArray*)self.photoPaymentArr;

}
-(void)setLblShootingPagesText{

    switch (claimPhotoType) {
        case claimTypeShootingRecords:
        {
            NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),self.photoCardArr.count,LocalizeStringFromKey(@"kPcs")];
            NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
            lblShootingPages.text = self.photoCardArr.count>0?str:str1;
            
        }
            break;
        case claimTypeShootingPayDetail:
        {
            NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),self.photoPaymentArr.count,LocalizeStringFromKey(@"kPcs")];
            NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
            lblShootingPages.text = self.photoPaymentArr.count>0?str:str1;
            
        }
            break;
        case claimTypeShootingOther:
        {
            NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),self.photoOtherArr.count,LocalizeStringFromKey(@"kPcs")];
            NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
            lblShootingPages.text = self.photoOtherArr.count>0?str:str1;
            
        }
            break;
            
        default:
            break;
    }
}
-(void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case claimTypeShootingRecords:
        {
            claimPhotoType = claimTypeShootingRecords;
            IKSelectPhotoFromRecordsView *v = [IKSelectPhotoFromRecordsView view];
            v.delegate = self;
            v.canEditPhoto = [self canBeEdit];
            v.isPad = isPad;
            v.dicVisitInfo = dicApplyInfo;
            v.visit = self.visit;
            v.status =self.photoStatus;
            v.otherVisitInfo = otherVisitInfo;//适用于不存在于本地coredata数据库中的visit
            if (isPad) {
                v.aryList = [NSMutableArray arrayWithArray:self.photoCardArr];
            }
            else{
                v.aryList = [NSMutableArray arrayWithArray:aryReportImages_noPad];
            }
            
            [v show];
        }
            break;
        case claimTypeShootingPayDetail:
        {
            claimPhotoType = claimTypeShootingPayDetail;

            IKSelectPhotoPayDetailView *v = [IKSelectPhotoPayDetailView view];
            v.delegate = self;
            v.canEditPhoto = [self canBeEdit];
            v.isPad = isPad;
            v.dicVisitInfo = dicApplyInfo;
            v.visit = self.visit;
            v.status =self.photoStatus;
            v.otherVisitInfo = otherVisitInfo;//适用于不存在于本地coredata数据库中的visit
            if (isPad) {
                v.aryList = [NSMutableArray arrayWithArray:self.photoPaymentArr];
            }
            else{
                v.aryList = [NSMutableArray arrayWithArray:aryReportImages_noPad];
            }
            
            [v show];
        }
            break;
        case claimTypeShootingOther:
        {
             claimPhotoType = claimTypeShootingOther;
            
            IKSelectPhotoOtherView *v = [IKSelectPhotoOtherView view];
            v.delegate = self;
            v.canEditPhoto = [self canBeEdit];
            v.isPad = isPad;
            v.dicVisitInfo = dicApplyInfo;
            v.status =self.photoStatus;
            v.visit = self.visit;
            v.otherVisitInfo = otherVisitInfo;//适用于不存在于本地coredata数据库中的visit
            if (isPad) {
                v.aryList = [NSMutableArray arrayWithArray:self.photoOtherArr];
            }
            else{
                v.aryList = [NSMutableArray arrayWithArray:aryReportImages_noPad];
            }
            
            [v show];
        }
            break;
        default:
            break;
    }
    
}

- (void)recordsAdded:(NSArray *)photos{
//   
//    aryReportImages = [NSMutableArray arrayWithArray:photos];
//     NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),aryReportImages.count,LocalizeStringFromKey(@"kPcs")];
//    NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
//    lblShootingPages.text = aryReportImages.count>0?str:str1;
    
    
    
    switch (claimPhotoType) {
        case claimTypeShootingRecords:
        {
//            self.photoCardArr = [NSMutableArray arrayWithArray:photos];
            self.photoCardArr = photos;
            //            aryReportImages = [NSMutableArray arrayWithArray:photos];
            NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),self.photoCardArr.count,LocalizeStringFromKey(@"kPcs")];
            NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
            lblShootingPages.text = self.photoCardArr.count>0?str:str1;
            
            
        }
            break;
        case claimTypeShootingPayDetail:
        {
             self.photoPaymentArr = photos;
//            self.photoPaymentArr = [NSMutableArray arrayWithArray:photos];
            NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),self.photoPaymentArr.count,LocalizeStringFromKey(@"kPcs")];
            NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
            lblShootingPages.text = self.photoPaymentArr.count>0?str:str1;
        }
            break;
            
        case claimTypeShootingOther:
        {
             self.photoOtherArr = photos;
//            self.photoOtherArr = [NSMutableArray arrayWithArray:photos];
            NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),self.photoOtherArr.count,LocalizeStringFromKey(@"kPcs")];
            NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
            lblShootingPages.text = self.photoOtherArr.count>0?str:str1;
        }
            break;
            
        default:
            NSAssert(NO, @" claimType!");
            break;
    }
    
    
    [self getAryReportImages];
    
    
    
}
-(void)getAryReportImages{

    NSMutableArray *array1 = [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoOtherArr;
    NSMutableArray *array2 = [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoPaymentArr;
    NSMutableArray *array3 = [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoCardArr;
    
    aryReportImages = [NSMutableArray arrayWithArray:array1];
    [aryReportImages addObjectsFromArray:array2];
    [aryReportImages addObjectsFromArray:array3];
    
//    [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoAllArr = aryReportImages;

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"getAryReportImages"  object:aryReportImages];
    
    [self.delegate selectImageArr:aryReportImages];


}
- (void)showInfo{//传了visit参数的情况
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([visit.serviceType intValue]>0) {
        
        if (visit.serviceType.intValue == 1) {
            
            
            
            btn.tag = 3-1;
            
        }if (visit.serviceType.intValue == 3) {
            
            btn.tag = 1-1;
            
        }else if(visit.serviceType.intValue !=1&&visit.serviceType.intValue !=3){
            
            
            
            btn.tag = [visit.serviceType intValue]-1;
        }
        
        
        
        
        
        [self methodClicked:btn];
    }
    
    
}


- (void)showInfo:(NSDictionary *)info{
    
    if (!info){
        self.userInteractionEnabled = NO;
        return;
    }else{
        
        
        
    };
    
    
    dicApplyInfo = info;
    
    isPad  = [[dicApplyInfo objectForKey:@"isPad"] isEqualToString:@"Y"]?YES:NO;
    if (!isPad) {//加入时非pad端提交的内容
        [self getClaimImages];
    }
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = [[info objectForKey:@"visitType"] intValue]-1;
    
    [self methodClicked:btn];
    
    
    aryReportImages = [NSMutableArray arrayWithArray:[dicApplyInfo objectForKey:@"reportImgDetail"]];
    NSMutableArray *shootingRecordsAry =[NSMutableArray array];
    NSMutableArray *shootingPayDetailAry =[NSMutableArray array];
    NSMutableArray *shootingOtherAry =[NSMutableArray array];
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
     NSInteger type =[[photoInfo objectForKey:@"type"] integerValue];
        
        switch (type) {
            case IKPhotoTypeInsuranceCard:
            {
                [shootingRecordsAry addObject:photoInfo];
                
            }
                break;
            case IKPhotoTypeClaimClaimsPaymentList:
            {
                [shootingPayDetailAry addObject:photoInfo];
            }
                break;
            case IKPhotoTypeClaimClaimsOtherList:
            {
                
                [shootingOtherAry addObject:photoInfo];
            }
                break;
                
            default:
                break;
        }
    }
    self.photoCardArr = shootingRecordsAry;
    self.photoPaymentArr =shootingPayDetailAry;
    self.photoOtherArr = shootingOtherAry;
    [self setDataAryReportImages];
    [self shootingStatus:shootingRecordsAry ary2:shootingPayDetailAry ary3:shootingOtherAry];
}
-(void)shootingStatus:(NSMutableArray *)ary1 ary2:(NSMutableArray *)ary2 ary3:(NSMutableArray *)ary3{
    switch (claimPhotoType) {
        case claimTypeShootingRecords:
        {
            if (isPad) {
                NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),ary1.count,LocalizeStringFromKey(@"kPcs")];
                NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
                lblShootingPages.text = ary1.count>0?str:str1;
            }
            
        }
            break;
        case claimTypeShootingPayDetail:
        {
            if (isPad) {
            NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),ary2.count,LocalizeStringFromKey(@"kPcs")];
                NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
                lblShootingPages.text = ary2.count>0?str:str1;
            }
            
        }
            break;
        case claimTypeShootingOther:
        {
            if (isPad) {
                NSString *str =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),ary3.count,LocalizeStringFromKey(@"kPcs")];
                NSString *str1 =[NSString stringWithFormat:@"%@%d%@", LocalizeStringFromKey(@"kShootingFinished"),0,LocalizeStringFromKey(@"kPcs")];
                lblShootingPages.text = ary3.count>0?str:str1;
            }
            
        }
            break;
            
        default:
            break;
    }

}
- (void)methodClicked:(UIButton *)btn{
//    int index = (int)btn.tag%10;
//    
//    visitType = index+1;
//    
//    NSArray *categories = [@"1,2,3,4,5" componentsSeparatedByString:@","];
//    for (int i=0;i<categories.count;i++){
//        UIButton *b = (UIButton *)[vMethodList viewWithTag:200+i];
//        b.selected = i==index;
//        
//    }
    
    
    
}

-(BOOL)canBeEdit{
    BOOL isUpdate = [[dicApplyInfo objectForKey:@"isUpdate"] boolValue];
    return isUpdate;
    
}

- (IKPhotoCDSO *)signatureInsuranceCardImage:(IKPhotoCDSO *)photo{
   
        if (photo.type.intValue==IKPhotoTypeInsuranceCard){
            return photo;
            
        }
   
    return nil;
   
}

- (IKPhotoCDSO *)signatureClaimsPaymentListImage:(NSArray *)imgArr{
    IKPhotoCDSO *sign = nil;
    for (IKPhotoCDSO *photo in imgArr){
        if (photo.type.intValue==IKPhotoTypeClaimClaimsPaymentList){
            sign = photo;
            break;
        }
    }
    
    return sign;
}

- (IKPhotoCDSO *)signatureClaimsOtherListImage:(NSArray *)imgArr{
    IKPhotoCDSO *sign = nil;
    for (IKPhotoCDSO *photo in imgArr){
        if (photo.type.intValue==IKPhotoTypeClaimClaimsOtherList){
            sign = photo;
            break;
        }
    }
    
    return sign;
}

//- (void)methodClicked:(UIButton *)btn{
//    int index = (int)btn.tag%10;
//    
//    visitType = index+1;
//    
//    NSArray *categories = [@"1,2,3,4,5" componentsSeparatedByString:@","];
//    for (int i=0;i<categories.count;i++){
//        UIButton *b = (UIButton *)[vMethodList viewWithTag:200+i];
//        b.selected = i==index;
//        
//    }
//    
//    
//    
//}
//
//
//
//- (void)dateClicked:(UIButton *)btn{
//    
//    IKUnlimitDatePickerController *vcDatePicker = [[IKUnlimitDatePickerController alloc] init];
//    vcDatePicker.datePicker.tag = btn.tag;
//    [vcDatePicker.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//    beginDate = [[UIPopoverController alloc] initWithContentViewController:vcDatePicker];
//    
//    [beginDate presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//}
//
//- (void)dateChanged:(UIDatePicker *)picker{
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    if (picker.tag == 1){
//        lblDate.text = [formatter stringFromDate:picker.date];
//        //   dateBegin = picker.date;
//    }
//    else {
//        lblEndDate.text = [formatter stringFromDate:picker.date];
//        // dateEnd = picker.date;
//    }
//    
//    
//}


- (void)getClaimImages{
    @autoreleasepool {
        NSDictionary *dict = [IKDataProvider getReportImage:@{@"claimsNo":_claimsNo}];
        
        NSLog(@"Claim images:%@",dict);
        sw_dispatch_sync_on_main_thread(^{
            
            //            aryReportImages_noPad = [NSMutableArray arrayWithArray:@[@"http://192.168.1.222:8090/MSHPadService/upload/image/p00001063STRONGTECH-000120141112192907824.png",@"http://192.168.1.222:8090/MSHPadService/upload/image/P00000004ALLIANZ-000420141112214108183.png"]];
            
            //                     aryReportImages_noPad = [NSMutableArray arrayWithArray:@[@"http://180.169.59.202:8090/MSHPadService/upload/image/P00000004ALLIANZ-000420141112214108183.png",@"http://180.169.59.202:8090/MSHPadService/upload/image/p00001063STRONGTECH-000120141112192907824.png"]];
            
            aryReportImages_noPad =  [dict objectForKey:@"reportImgDetail"];
            
            lblShootingPages.text = aryReportImages_noPad.count>0?[NSString stringWithFormat:@"%@%d%@",LocalizeStringFromKey(@"kClicktoaddMRinvoice"),aryReportImages_noPad.count,LocalizeStringFromKey(@"kPcs")]:nil;
            
            
            
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
@end
