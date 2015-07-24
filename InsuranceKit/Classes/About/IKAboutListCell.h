//
//  IKAboutListCell.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKAboutListCell : UITableViewCell{
    UILabel *lblTitle;
    UIView *line;
}
@property (nonatomic,strong) NSString *title;

@end
