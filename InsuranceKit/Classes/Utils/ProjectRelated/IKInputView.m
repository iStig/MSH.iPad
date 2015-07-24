//
//  IKInputView.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKInputView.h"
#import "IKDatePickerViewController.h"

@implementation IKInputView
@synthesize key,necessary,lineColor,delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.necessary = NO;
        
       // CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16]];
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        
        lblTitle = [UILabel createLabelWithFrame:CGRectMake(5, 0, size.width, frame.size.height) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.15 alpha:1]];
        [self addSubview:lblTitle];
        lblTitle.text = title;
        
        float w = frame.size.width-10-size.width-5;
        tfInput = [[UITextField alloc] initWithFrame:CGRectMake(5+size.width+5, 0, w, frame.size.height)];
        tfInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfInput.delegate = self;
        tfInput.returnKeyType = UIReturnKeyDone;
        tfInput.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        [self addSubview:tfInput];
        
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-.5f, frame.size.width, .5f)];
        line.backgroundColor = [UIColor colorWithWhite:.87 alpha:1];
        [self addSubview:line];
        
        if ([title rangeOfString:@"日期"].location!=NSNotFound)
            [self changeToDateSelector];
        
        if ([title rangeOfString:@"费"].location!=NSNotFound || [title hasSuffix:@"数"])
            tfInput.keyboardType = UIKeyboardTypeNumberPad;
                                                                
        
    }
    return self;
}




- (id)initWithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.necessary = NO;
        
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16]];
        
        lblTitle = [UILabel createLabelWithFrame:CGRectMake(5, 0, size.width, frame.size.height) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.15 alpha:1]];
        [self addSubview:lblTitle];
        lblTitle.text = title;
        lblTitle.textColor = color;
        
        float w = frame.size.width-10-size.width-5;
        tfInput = [[UITextField alloc] initWithFrame:CGRectMake(5+size.width+5, 0, w, frame.size.height)];
        tfInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfInput.delegate = self;
        tfInput.returnKeyType = UIReturnKeyDone;
        tfInput.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        [self addSubview:tfInput];
        
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-.5f, frame.size.width, .5f)];
        line.backgroundColor = [UIColor colorWithWhite:.87 alpha:1];
        [self addSubview:line];
        
        if ([title rangeOfString:@"日期"].location!=NSNotFound)
            [self changeToDateSelector];
        
        if ([title rangeOfString:@"费"].location!=NSNotFound || [title hasSuffix:@"数"])
            tfInput.keyboardType = UIKeyboardTypeNumberPad;
        
        
    }
    return self;
}

- (void)determineNecessary:(NSString *)category{
    NSArray *commons = [@"depID,medProviderID,ExpectedDate,EstimatedCost,CurrencyUnit,Category" componentsSeparatedByString:@","];
    
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    
    NSArray *categorys = [@"1,2,3,4,5,6,7,99" componentsSeparatedByString:@","];
    for (NSString *str in categorys){
        [mut setObject:[NSMutableArray array] forKey:str];
    }
    
    
//    [[mut objectForKey:@"1"] addObject:@"ExamItem"];
    
    [[mut objectForKey:@"2"] addObject:@"ApplyHospiDays"];
    [[mut objectForKey:@"3"] addObject:@"ApplyHospiDays"];
    
    [[mut objectForKey:@"3"] addObject:@"DeliveryType"];
    
    [[mut objectForKey:@"4"] addObject:@"EquipmentName"];
    
    [[mut objectForKey:@"5"] addObject:@"ServiceType"];
    [[mut objectForKey:@"6"] addObject:@"ServiceType"];
    
    [[mut objectForKey:@"7"] addObject:@"PhysiotherapyItem"];
    [[mut objectForKey:@"7"] addObject:@"phyType"];
    
    
    BOOL isNecessary = NO;
    
    for (NSString *str in commons){
        if ([[str lowercaseString] isEqualToString:[self.key lowercaseString]]){
            isNecessary = YES;
            break;
        }
    }
    
    if (!isNecessary){
        for (NSString *str in [mut objectForKey:category]){
            if ([[str lowercaseString] isEqualToString:[self.key lowercaseString]]){
                isNecessary = YES;
            }
        }
    }
    
    
    self.necessary = isNecessary;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title values:(NSArray *)values{
    self = [super initWithFrame:frame];
    if (self) {
        necessary = YES;
        total = (int)values.count;
        // Initialization code
        CGSize size = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil]];
        
        lblTitle = [UILabel createLabelWithFrame:CGRectMake(5, 0, size.width, frame.size.height) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.15 alpha:1]];
        [self addSubview:lblTitle];
        lblTitle.text = title;
        
        float x = lblTitle.frame.origin.x+lblTitle.frame.size.width+40;
        float w = (frame.size.width-x-5)/total;
        
        for (int i=0;i<values.count;i++){
            float distance = 20;
            
            NSString *text = [values objectAtIndex:i];
            CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil]];
            CGSize imgSize = [[UIImage imageNamed:@"IKIconCircleCheckNO.png"] size];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(x+w*i, 0, w, frame.size.height);
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            [btn setTitleColor:[UIColor colorWithWhite:.54 alpha:1] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"IKIconCircleCheckNO.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"IKIconCircleCheckYES.png"] forState:UIControlStateSelected];
            [btn setTitle:text forState:UIControlStateNormal];
            
            btn.imageEdgeInsets = UIEdgeInsetsMake((btn.frame.size.height-imgSize.height)/2, 0, (btn.frame.size.height-imgSize.height)/2, btn.frame.size.width-imgSize.width);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, distance, 0, btn.frame.size.width-imgSize.width-distance-size.width);
            
            btn.tag = 200+i;
            [btn addTarget:self action:@selector(selectionClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
        }
        
        
        
        line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-.5f, frame.size.width, .5f)];
        line.backgroundColor = [UIColor colorWithWhite:.87 alpha:1];
        [self addSubview:line];
        
        
    }
    return self;
}

- (void)selectionClicked:(UIButton *)btn{
    int index = (int)btn.tag-200;
    for (int i=0;i<total;i++){
        UILabel *lbl = (UILabel *)[self viewWithTag:100+i];
        UIButton *b = (UIButton *)[self viewWithTag:200+i];
        
        lbl.textColor = i==index?[UIColor colorWithRed:.99 green:.62 blue:.5 alpha:1]:[UIColor colorWithWhite:.54 alpha:1];
        b.selected = i==index;
    }
    
    [self.delegate selectionChanged:self];
}

- (void)changeToDateSelector{
    tfInput.userInteractionEnabled = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = tfInput.frame;
    [self addSubview:btn];
    [btn addTarget:self action:@selector(dateClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dateClicked:(UIButton *)btn{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = tfInput.text;
    dateString = [[dateString componentsSeparatedByString:@" "] objectAtIndex:0];
    
    datePlan = [formatter dateFromString:dateString];
    
    IKDatePickerViewController *vcDatePicker = [[IKDatePickerViewController alloc] init];
    [vcDatePicker.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    vcDatePicker.datePicker.date = datePlan?datePlan:[NSDate date];
//    if (self.isFutureDate == YES) {
//     
//        vcDatePicker.datePicker.maximumDate = [NSDate date];
//    }
    pcDate = [[UIPopoverController alloc] initWithContentViewController:vcDatePicker];
    
    [pcDate presentPopoverFromRect:btn.frame inView:btn.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy.MM.dd"];
    
   tfInput.text = [formatter1 stringFromDate:[NSDate date]];
}

- (void)dateChanged:(UIDatePicker *)picker{
    datePlan = picker.date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    
    tfInput.text = [formatter stringFromDate:datePlan];
}

- (NSString *)text{
    if (total>0){
        int selection = 0;
        
        for (int i=0;i<total;i++){
            UIButton *b = (UIButton *)[self viewWithTag:200+i];
            
            if (b.selected){
                selection = i+1;
                break;
            }
        }
        
        if (selection>0)
            return [NSString stringWithFormat:@"%d",selection];
        else
            return nil;
    }
    
    return tfInput.text;
}

- (void)setText:(NSString *)text{
    if (total>0){
        int index = text.intValue-1;
        
        for (int i=0;i<total;i++){
            UILabel *lbl = (UILabel *)[self viewWithTag:100+i];
            UIButton *b = (UIButton *)[self viewWithTag:200+i];
            
            lbl.textColor = i==index?[UIColor colorWithRed:.99 green:.62 blue:.5 alpha:1]:[UIColor colorWithWhite:.54 alpha:1];
            b.selected = i==index;
        }
    }else{
        tfInput.text = text;
    }
}

- (void)setNecessary:(BOOL)ncs{
    necessary = ncs;
    
    if (necessary){
        if ([lblTitle.text rangeOfString:@"*"].location==NSNotFound)
            lblTitle.text = [lblTitle.text stringByAppendingString:@"*"];
        
        lblTitle.text = [lblTitle.text stringByReplacingOccurrencesOfString:@"：*" withString:@"*："];
    }else{
        lblTitle.text = [lblTitle.text stringByReplacingOccurrencesOfString:@"*" withString:@""];
    }
    if (lblTitle.text){
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:lblTitle.text];
        NSRange range = [lblTitle.text rangeOfString:@"*"];
        [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] range:range];
        lblTitle.attributedText = attrStr;
    }
    

    CGSize size = [lblTitle.text sizeWithFont:[UIFont systemFontOfSize:16]];
    CGRect rect = lblTitle.frame;
    rect.size.width = size.width;
    lblTitle.frame = rect;
}

- (BOOL)necessary{
    return necessary;
}

- (UILabel *)titleLabel{
    return lblTitle;
}

- (UITextField *)inputField{
    return tfInput;
}

- (void)setLineColor:(UIColor *)color{
    line.backgroundColor = color;
}

- (UIColor *)lineColor{
    return line.backgroundColor;
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
        
    return NO;
}



@end
