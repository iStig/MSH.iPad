//
//  IKNewsListCell.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKNewsListCell : UITableViewCell<SWImageViewDelegate>{
    UILabel *lblTitle,*lblContent;
    SWImageView *imgvContent;
    
    NSDictionary *dicInfo;
}
@property (nonatomic,strong) NSDictionary *dicInfo;

@end
