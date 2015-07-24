//
//  IKBorderCell.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-27.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum{
    IKBorderCellTypeTop = 1,
    IKBorderCellTypeMiddle,
    IKBorderCellTypeBottom,
    IKBorderCellTypeSingle
}IKBorderCellType;

@interface IKBorderCell:UITableViewCell{
    UIView *lineEdge,*lineBottom;
    
    IKBorderCellType cellType;
    NSIndexPath *indexPath;
    UIColor *seperatorColor;
}
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UIColor *seperatorColor;
@end