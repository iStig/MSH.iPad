//
//  IKCheckItemSelector.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-4-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IKCheckItemSelector

- (void)didSelectedItems:(NSString *)items;

@end

@interface IKCheckItemSelector : UIView{
    UIView *vContent;
    NSArray *aryTitles;
}

@property (nonatomic,weak) id<IKCheckItemSelector> delegate;

+ (void)showAtPoint:(CGPoint)pt delegate:(id<IKCheckItemSelector>)dele;

@end
