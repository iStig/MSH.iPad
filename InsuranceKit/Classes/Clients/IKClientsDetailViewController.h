//
//  IKClientsDetailViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"
#import "IKCardView.h"

@interface IKClientsDetailViewController : IKViewController{
    UILabel *lblName,*lblBirthday,*lblGender,*lblID,*lblNation,*lblDuration,*lblPEnotes;
    UIButton *btnIDCard,*btnSign,*btnInsuranceCard,*btnPEnotes;
    
    UIImageView *imgvGender;
    UIView *vContent,*vSelectionBG;
    IKView *vInfo,*vPayment,*vLog,*vAuthorization;
    
    NSMutableArray *aryContentViews;
    IKCardView *insuranceCardV,*idCardV;
    CGSize peSize;
    UIPopoverController *peNoteVC;
}

- (void)showType:(int)type;

@end
