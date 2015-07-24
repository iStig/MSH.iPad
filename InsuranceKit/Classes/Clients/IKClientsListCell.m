//
//  IKClientsListCell.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-10.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKClientsListCell.h"

@implementation IKClientsListCell
@synthesize visit;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:.97 green:.93 blue:.94 alpha:1];
        
        lblName = [UILabel createLabelWithFrame:CGRectMake(25, 10, 185, 22) font:[UIFont systemFontOfSize:19] textColor:[UIColor colorWithWhite:.55 alpha:1]];
        [self.contentView addSubview:lblName];

        
        lblGender = [UILabel createLabelWithFrame:CGRectMake(285-20-90, 15, 90, 15) font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithWhite:.55 alpha:1]];
        lblGender.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:lblGender];
        
        
        lblTime = [UILabel createLabelWithFrame:CGRectMake(285-20-130, 50, 130, 14) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithWhite:.55 alpha:1]];
        lblTime.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:lblTime];
        
//        NSArray *statuses = [@"付款,病历,签名" componentsSeparatedByString:@","];
//        for (int i=0;i<3;i++){
//            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(48+71*i, 43, 40, 16) font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor colorWithWhite:.57 alpha:1]];
//            lbl.text = [statuses objectAtIndex:i];
//            [self.contentView addSubview:lbl];
//            lbl.tag = 100+i;
//            
//            UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconCheckNotFinished.png"]];
//            imgv.center = CGPointMake(34+71*i, 51);
//            [self.contentView addSubview:imgv];
//            imgv.tag = 200+i;
//        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 74, 285, 1.0f)];
        line.backgroundColor = [UIColor whiteColor];
        
        UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 285, .5f)];
        line0.backgroundColor = [UIColor colorWithRed:.73 green:.71 blue:.71 alpha:1];
        line0.opaque = YES;
        [line addSubview:line0];
        
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)showInfo{
    BOOL isEnglish = [InternationalControl isEnglish];
    NSDictionary *dicInfo = visit.detailInfo;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    lblName.text = [dicInfo objectForKey:@"memberName"];
    lblStatus.text = [dicInfo objectForKey:@"status"];
    lblTime.text = [formatter stringFromDate:visit.registrationTime];// [dicInfo objectForKey:@"modifyTime"]; [formatter stringFromDate:visit.createTime];
    lblApproval.text = [dicInfo objectForKey:@"approval"];
    lblGender.text = [dicInfo objectForKey:@"gender"];
    if (isEnglish){
        if ([lblGender.text isEqualToString:@"男"])
            lblGender.text = @"M";
        else
            lblGender.text = @"F";
    }
    
//    for (int i=0;i<3;i++){
//        UIImageView *imgv = (UIImageView *)[self.contentView viewWithTag:200+i];
//        BOOL b = NO;
//        switch (i) {
//            case 0:b = self.visit.paymentTime!=nil;break;
//            case 1:b = self.visit.recordsList.count>0;break;
//            case 2:b = self.visit.signatureImage!=nil;break;
//            default:
//                break;
//        }
//        [imgv setImage:[UIImage imageNamed:b?@"IKIconCheckFinished.png":@"IKIconCheckNotFinished.png"]];
//    }
}

- (void)setVisit:(IKVisitCDSO *)v{
    visit = v;
    [self showInfo];
}

- (IKVisitCDSO *)visit{
    return visit;
}


- (void)makeSelected:(BOOL)selected{
    UIColor *textColor = selected?[UIColor whiteColor]:[UIColor colorWithWhite:.55 alpha:1];
    UIColor *bgColor = selected?[UIColor colorWithRed:.99 green:.45 blue:.25 alpha:1]:[UIColor colorWithRed:.97 green:.93 blue:.94 alpha:1];
    
    for (UILabel *lbl in self.contentView.subviews){
        if ([lbl isKindOfClass:[UILabel class]])
            lbl.textColor = textColor;
    }
    self.contentView.backgroundColor = bgColor;
}

@end
