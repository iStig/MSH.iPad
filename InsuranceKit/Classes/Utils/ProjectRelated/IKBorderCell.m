//
//  IKBorderCell.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-27.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKBorderCell.h"

@implementation IKBorderCell
@synthesize indexPath,seperatorColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.contentView.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
        self.contentView.clipsToBounds = YES;
        
        lineEdge = [[UIView alloc] initWithFrame:CGRectZero];
        lineEdge.layer.borderColor = [UIColor colorWithRed:.96 green:.5 blue:.13 alpha:1].CGColor;
        lineEdge.layer.borderWidth = 1.0f;
        [self.contentView addSubview:lineEdge];
        
        lineBottom = [[UIView alloc] initWithFrame:CGRectZero];
        lineBottom.backgroundColor = [UIColor colorWithWhite:.89 alpha:1];
        [self.contentView addSubview:lineBottom];
    }
    
    
    return self;
}

- (void)updateShape:(IKBorderCellType)type{
    float w = self.frame.size.width;
    float h = self.frame.size.height;

    switch (type) {
        case IKBorderCellTypeSingle:
            lineEdge.frame = CGRectMake(0, 0, w, h);
            lineBottom.frame = CGRectZero;
            break;
        case IKBorderCellTypeTop:
            lineEdge.frame = CGRectMake(0, 0, w, h+1);
            lineBottom.frame = CGRectMake(0, h-1, w, 1);
            break;
        case IKBorderCellTypeBottom:
            lineEdge.frame = CGRectMake(0, -1, w, h+1);
            lineBottom.frame = CGRectZero;
            break;
        case IKBorderCellTypeMiddle:
            lineEdge.frame = CGRectMake(0, -1, w, h+2);
            lineBottom.frame = CGRectMake(0, h-1, w, 1);
            break;
        default:
            break;
    }
}

- (void)drawRect:(CGRect)rect{
    //    [super drawRect:rect];
    
    [self updateShape:cellType];
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    UIView *v = newSuperview;
    while (v && ![v isKindOfClass:[UITableView class]]) v = v.superview;
    UITableView *tv = (UITableView *)v;
    id<UITableViewDataSource> delegate = tv.dataSource;
    
    int last = (int)[delegate tableView:tv numberOfRowsInSection:indexPath.section]-1;
    
    if (0==indexPath.row && last==indexPath.row)
        cellType = IKBorderCellTypeSingle;
    else if (indexPath.row==0)
        cellType = IKBorderCellTypeTop;
    else if (indexPath.row==last)
        cellType = IKBorderCellTypeBottom;
    else
        cellType = IKBorderCellTypeMiddle;
    
    [self updateShape:cellType];
}

- (void)setIndexPath:(NSIndexPath *)indexp{
    indexPath = indexp;
    
    UIView *v = self;
    while (v && ![v isKindOfClass:[UITableView class]]) v = v.superview;
    UITableView *tv = (UITableView *)v;
    id<UITableViewDataSource> delegate = tv.dataSource;
    
    int last = (int)[delegate tableView:tv numberOfRowsInSection:indexPath.section]-1;
    
    if (0==indexPath.row && last==indexPath.row)
        cellType = IKBorderCellTypeSingle;
    else if (indexPath.row==0)
        cellType = IKBorderCellTypeTop;
    else if (indexPath.row==last)
        cellType = IKBorderCellTypeBottom;
    else
        cellType = IKBorderCellTypeMiddle;
    
    [self updateShape:cellType];
}


@end
