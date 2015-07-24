//
//  IKMonthView.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKMonthView.h"
#import "IKAppDelegate.h"
#import "InternationalControl.h"
@implementation IKMonthView
@synthesize selectedDate,dYear,dMonth;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:.12 alpha:1];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(0, 0, frame.size.width, 35) font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor]];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.text = title;
        [self addSubview:lblTitle];
        
        lblDate = [UILabel createLabelWithFrame:CGRectMake(0, 32, frame.size.width, 24) font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor]];
        lblDate.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lblDate];
        lblDate.userInteractionEnabled = NO;
        
        btnPrev = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPrev.frame = CGRectMake(0, 0, 40, 40);
        [btnPrev setImage:[UIImage imageNamed:@"IKButtonPrevMonth.png"] forState:UIControlStateNormal];
        btnPrev.center = CGPointMake(28, lblDate.center.y);
        [self addSubview:btnPrev];
        [btnPrev addTarget:self action:@selector(prevClicked) forControlEvents:UIControlEventTouchUpInside];
        
        btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNext.frame = CGRectMake(0, 0, 40, 40);
        [btnNext setImage:[UIImage imageNamed:@"IKButtonNextMonth.png"] forState:UIControlStateNormal];
        btnNext.center = CGPointMake(frame.size.width-28, lblDate.center.y);
        [self addSubview:btnNext];
        [btnNext addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
        NSMutableArray *ary =[NSMutableArray arrayWithObjects:@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT", nil];
        for (int i=0;i<7;i++){
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(13+i*35, 60, 30, 24) font:[UIFont boldSystemFontOfSize:10] textColor:[UIColor whiteColor]];
            lbl.textAlignment = NSTextAlignmentCenter;
//            lbl.text = [[[formatter weekdaySymbols] objectAtIndex:i] substringToIndex:1];
            if ([InternationalControl isEnglish]) {
                lbl.text = [ary objectAtIndex:i];
            }else{
              lbl.text = [[[formatter weekdaySymbols] objectAtIndex:i] substringFromIndex:2];
            }
            [self addSubview:lbl];
        }
        
        vDays = [[UIView alloc] initWithFrame:CGRectMake(0, 84, frame.size.width, frame.size.height-84)];
        [self addSubview:vDays];
        
        [formatter setDateFormat:@"yyyyMM"];
        NSString *prefex = [formatter stringFromDate:date];
        [formatter setDateFormat:@"yyyyMMdd"];
        
        dYear = [[prefex substringToIndex:4] intValue];
        dMonth = [[prefex substringFromIndex:4] intValue];
        
        lblDate.text = [self dateTitle];
        
        if (0==dMonth)
            dMonth = [[prefex substringFromIndex:5] intValue];
        
        
        [self reloadData];
        
    }
    return self;
}

- (void)dateClicked:(UIButton *)btn{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%04d%02d%02d",dYear,dMonth,btn.tag+1]];
    
    if ([self.delegate canSelectDate:date inMonthView:self]){
        selectedDate = [formatter dateFromString:[NSString stringWithFormat:@"%04d%02d%02d",dYear,dMonth,btn.tag+1]];
        
        for (UIButton *button in vDays.subviews)
            button.selected = button==btn;
    }
}

- (NSString *)dateTitle{
    NSArray *months = [@"一,二,三,四,五,六,七,八,九,十,十一,十二" componentsSeparatedByString:@","];
    
    
    return [InternationalControl isEnglish]?[NSString stringWithFormat:@"%d/%d",dYear,dMonth]:[NSString stringWithFormat:@"%@月%d",[months objectAtIndex:dMonth-1],dYear];
}

- (void)prevClicked{
    if ([self.delegate canGoToPrevMonth:self]){
        selectedDate = nil;
        
        if (dMonth>1)
            dMonth--;
        else{
            dMonth = 12;
            dYear--;
        }
        
        [self reloadData];
    }
}

- (void)nextClicked{
    if ([self.delegate canGoToNextMonth:self]){
        selectedDate = nil;
        
        if (dMonth<12)
            dMonth++;
        else{
            dMonth = 1;
            dYear++;
        }
        
        [self reloadData];
    }
}

- (void)reloadData{
    for (UIView *v in vDays.subviews)
        [v removeFromSuperview];
    
    UIImage *imgNormal = [UIImage imageWithColor:[UIColor colorWithWhite:.57 alpha:1] size:CGSizeMake(30, 28)] ;
    UIImage *imgSelected = [UIImage imageWithColor:[UIColor colorWithRed:.96 green:.5 blue:.13 alpha:1] size:CGSizeMake(30, 28)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%04d%02d01",dYear,dMonth]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
    
    int row = 0;
    
    for (int i=0;i<days;i++){
        NSString *dateString = [NSString stringWithFormat:@"%04d%02d%02d",dYear,dMonth,i+1];

        NSDate *monthDate = [formatter dateFromString:dateString];
        NSInteger week = [[calendar components:NSWeekdayCalendarUnit fromDate:monthDate] weekday];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(13+35*(week-1), 35*row, 30, 28);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 3;
        [btn setBackgroundImage:imgNormal forState:UIControlStateNormal];
        [btn setBackgroundImage:imgSelected forState:UIControlStateSelected];
        [vDays addSubview:btn];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        if (selectedDate && [dateString isEqualToString:[formatter stringFromDate:selectedDate]]){
            btn.selected = YES;
        }else
            btn.selected = NO;
        
        if (week==7)
            row ++;
    }
    
    lblDate.text = [self dateTitle];
}


@end
