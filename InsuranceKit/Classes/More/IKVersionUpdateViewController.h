//
//  IKVersionUpdateViewController.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKViewController.h"

@interface IKVersionUpdateViewController : IKViewController{
    UIButton *btnUpdate;
    UILabel *lblCurrentVersion,*lblVersion,*lblSize,*lblContent;
    
    NSDictionary *dicInfo;
}
@property (nonatomic,strong) NSDictionary *dicInfo;

@end
