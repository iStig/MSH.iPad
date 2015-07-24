//
//  IKMonthView.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKMonthView;

@protocol IKMonthViewDelegate

- (BOOL)canGoToPrevMonth:(IKMonthView *)monthView;
- (BOOL)canGoToNextMonth:(IKMonthView *)monthView;
- (BOOL)canSelectDate:(NSDate *)date inMonthView:(IKMonthView *)monthView;

@end

@interface IKMonthView : UIView{
    UILabel *lblDate;
    UIButton *btnPrev,*btnNext;
    UIView *vDays;
    
    NSDate *selectedDate;
    int dYear,dMonth;
}
@property (nonatomic,strong) NSDate *selectedDate;
@property (nonatomic) int dYear,dMonth;
@property (nonatomic,weak) id<IKMonthViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title date:(NSDate *)date;

@end
