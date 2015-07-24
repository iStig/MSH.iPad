//
//  IKDateRangeSelector.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKDateRangeSelector.h"
#import "IKAppDelegate.h"

@implementation IKDateRangeSelector
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame point:(CGPoint)pt
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        vContent = [[UIView alloc] initWithFrame:CGRectMake(pt.x, pt.y, 266*2+16, 305)];
        [self addSubview:vContent];
        
        // Initialization code
        vStart = [[IKMonthView alloc] initWithFrame:CGRectMake(0, 0, 266, 305) title:LocalizeStringFromKey(@"kStartTime") date:[NSDate date]];
        vStart.delegate = self;
        [vContent addSubview:vStart];
        
        vEnd = [[IKMonthView alloc] initWithFrame:CGRectMake(279, 0, 266, 305) title:LocalizeStringFromKey(@"kEndTime") date:[NSDate date]];
        vEnd.delegate = self;
        [vContent addSubview:vEnd];
    }
    return self;
}

+ (void)showAtPoint:(CGPoint)pt delegate:(id)dele{
    
    
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKDateRangeSelector *v = [[IKDateRangeSelector alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) point:pt];
    v.delegate = dele;
    
    
    
    v.alpha = 0;
    
    [w.rootViewController.view addSubview:v];
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(vContent.frame, pt)){
        [self dismiss];
    }
}

- (void)dismiss{
    [self.delegate didSelectStartDate:vStart.selectedDate endDate:vEnd.selectedDate];
    
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - IKMonthView Delegate
- (BOOL)canGoToNextMonth:(IKMonthView *)monthView{
    if (monthView==vStart){
        if (vStart.dYear<vEnd.dYear || vStart.dMonth<vEnd.dMonth)
            return YES;
        else
            return NO;
    }else{
        if ((vStart.dYear==vEnd.dYear && vEnd.dMonth-vStart.dMonth<=2) || (vStart.dYear<vEnd.dYear && (12-vStart.dMonth+vEnd.dMonth)<=2))
            return YES;
        else
            return NO;
    }
}

- (BOOL)canGoToPrevMonth:(IKMonthView *)monthView{
    if (monthView==vStart){
        if ((vStart.dYear==vEnd.dYear && vEnd.dMonth-vStart.dMonth<=2) || (vStart.dYear<vEnd.dYear && (12-vStart.dMonth+vEnd.dMonth)<=2))
            return YES;
        else
            return NO;
    }
    else{
        if (vStart.dYear<vEnd.dYear || vStart.dMonth<vEnd.dMonth)
            return YES;
        else
            return NO;
    }
}

- (BOOL)canSelectDate:(NSDate *)date inMonthView:(IKMonthView *)monthView{
    if (monthView==vStart){
        if (!vEnd.selectedDate || ([vEnd.selectedDate timeIntervalSinceDate:date]>=0 && [vEnd.selectedDate timeIntervalSinceDate:date]<=3600*24*90))
            return YES;
        else
            return NO;
    }else{
        if (!vStart.selectedDate || ([date timeIntervalSinceDate:vStart.selectedDate]>=0 && [date timeIntervalSinceDate:vStart.selectedDate]<=3600*24*90))
            return YES;
        else
            return NO;
    }
}

@end
