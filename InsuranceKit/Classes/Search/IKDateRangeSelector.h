//
//  IKDateRangeSelector.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKMonthView.h"

@protocol IKDateRangerDelegate

- (void)didSelectStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end

@interface IKDateRangeSelector : UIView<IKMonthViewDelegate>{
    UIView *vContent;
    IKMonthView *vStart,*vEnd;
}

@property (nonatomic,weak) id<IKDateRangerDelegate> delegate;

+ (void)showAtPoint:(CGPoint)pt delegate:(id<IKDateRangerDelegate>)dele;

@end
