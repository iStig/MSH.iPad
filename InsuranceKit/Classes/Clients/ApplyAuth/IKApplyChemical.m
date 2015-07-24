//
//  IKApplyChemical.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKApplyChemical.h"

@implementation IKApplyChemical

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        keys = [@"serviceType,expectedHospiDay,totalCourse,curCourse" componentsSeparatedByString:@","];
        
        IKInputView *input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 0, frame.size.width-2*kContentPadding, 56) title:LocalizeStringFromKey(@"kServiceType") values:@[LocalizeStringFromKey(@"kOutpatient"),LocalizeStringFromKey(@"kInpatient"),LocalizeStringFromKey(@"kDaycase")]];
        input.key = [keys objectAtIndex:0];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56, frame.size.width-2*kContentPadding, 56) title:LocalizeStringFromKey(@"kExpectedLengthofStayPerRound")];
        input.key = [keys objectAtIndex:1];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(kContentPadding, 56*2, 325, 56) title:LocalizeStringFromKey(@"kTotalChemotherapyCourse")];
        input.key = [keys objectAtIndex:2];
        [self addSubview:input];
        
        input = [[IKInputView alloc] initWithFrame:CGRectMake(365, 56*2, 310, 56) title:LocalizeStringFromKey(@"kCurrentlyincourse")];
        input.key = [keys objectAtIndex:3];
        [self addSubview:input];
        
        aryPlan = [NSMutableArray array];
        for (int i=0;i<1;i++)
            [aryPlan addObject:[NSMutableDictionary dictionary]];
        
        float y = input.frame.origin.y+input.frame.size.height;
        tvPlan = [[UITableView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, frame.size.height-y)];
        tvPlan.delegate = self;
        tvPlan.dataSource = self;
        tvPlan.separatorStyle = UITableViewCellSeparatorStyleNone;
        tvPlan.backgroundColor = [UIColor clearColor];
        [self addSubview:tvPlan];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
+ (id)applyView{
    IKApplyChemical *apply = [[IKApplyChemical alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 420)];
    
    return apply;
}

- (NSDictionary *)authInfo{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    
    BOOL finished = YES;
    
    for (IKInputView *v in self.subviews){
        if ([v isKindOfClass:[IKInputView class]]){
            if (v.text && v.text.length>0)
                [info setObject:v.text forKey:v.key];
            else{
                [info setObject:@"" forKey:v.key];
                if (v.necessary){
                    finished = NO;
                    break;
                }
            }
        }
    }
    
    if ([self treatmentPlanList].count==0)
        finished = NO;
    else{
        NSString *chemPlan = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[self treatmentPlanList] options:0 error:nil] encoding:NSUTF8StringEncoding];
        [info setObject:chemPlan forKey:@"chemPlan"];
    }
    
    if (finished)
        return info;
    else
        return nil;
}

- (void)showInfo:(NSDictionary *)info{
    [super showInfo:info];
    
    NSString *chemPlan = [info objectForKey:@"chemPlan"];
    
    NSArray *ary = [NSJSONSerialization JSONObjectWithData:[chemPlan dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    NSMutableArray *mut = [NSMutableArray array];
    for (int i=0;i<ary.count;i++){
        [mut addObject:[NSMutableDictionary dictionaryWithDictionary:[ary objectAtIndex:i]]];
    }
    
    aryPlan = mut;
    
    [tvPlan reloadData];
}

- (NSArray *)treatmentPlanList{
    NSMutableArray *ary = [NSMutableArray array];
    for (NSDictionary *dict in aryPlan){
        if (dict.allKeys.count==3)
            [ary addObject:dict];
    }
    
    return ary.count>0?ary:nil;
}

- (void)addClicked{
    [aryPlan addObject:[NSMutableDictionary dictionary]];
    
    [tvPlan reloadData];
}

- (void)reduceClicked{
    if (aryPlan.count>0)
        [aryPlan removeLastObject];
    
    btnReduce.enabled = aryPlan.count>0;
    
    [tvPlan reloadData];
}

#pragma mark - UITableView Data Source & Delegte
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PlanCellIdentifer";
    
    IKPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[IKPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.delegate = self;
        
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(0, 55.5f, tableView.frame.size.width, .5f);
        line.backgroundColor = [UIColor colorWithWhite:.77 alpha:1].CGColor;
        [cell.contentView.layer addSublayer:line];
    }
    
    cell.dicInfo = [NSMutableDictionary dictionaryWithDictionary:[aryPlan objectAtIndex:indexPath.row]];
    cell.indexPath = indexPath;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return aryPlan.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!vHeader){
        vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tvPlan.frame.size.width, 50)];
        vHeader.backgroundColor = [UIColor colorWithRed:.97 green:.95 blue:.96 alpha:1];
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(25, 0, 100, 50) font:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor]];
        lbl.text = LocalizeStringFromKey(@"kChemotherapyPlan");
        [vHeader addSubview:lbl];
        
        btnReduce = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnReduce setImage:[UIImage imageNamed:@"IKButtonReducePlan.png"] forState:UIControlStateNormal];
        [btnReduce sizeToFit];
        [btnReduce addTarget:self action:@selector(reduceClicked) forControlEvents:UIControlEventTouchUpInside];
        btnReduce.center = CGPointMake(vHeader.frame.size.width-130, 25);
        [vHeader addSubview:btnReduce];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"IKButtonAddPlan.png"] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
        btn.center = CGPointMake(vHeader.frame.size.width-50, 25);
        [vHeader addSubview:btn];
    }
    
    
    
    
    
    return vHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - IKPlanCell Delegate
- (void)planChanged:(IKPlanCell *)cell{
    [aryPlan replaceObjectAtIndex:cell.indexPath.row withObject:cell.dicInfo];
    
}
@end
