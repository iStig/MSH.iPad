//
//  IKPlanCell.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKPlanCell.h"
#import "IKApplyView.h"

@implementation IKPlanCell
@synthesize indexPath,delegate,dicInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] init];
        self.backgroundColor = [UIColor clearColor];
        
        self.dicInfo = [NSMutableDictionary dictionary];
        
        float w = (kContentWidth-kContentPadding*2-20)/3;
        
        NSArray *titles = @[LocalizeStringFromKey(@"kMedicine"),LocalizeStringFromKey(@"kDosage"),LocalizeStringFromKey(@"ktimePerweek")];// [@"药名,剂量,每周次数" componentsSeparatedByString:@","];
        for (int i=0;i<3;i++){
            float x = kContentPadding+i*(w+10);
            
            
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectZero font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.62 alpha:1]];
            lbl.text = [titles objectAtIndex:i];
            [lbl sizeToFit];
            lbl.frame = CGRectMake(x, 0, lbl.frame.size.width, 56);
            [self.contentView addSubview:lbl];
            
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(lbl.frame.origin.x+lbl.frame.size.width+5, 0, w-lbl.frame.size.width-5, 56)];
            tf.font = lbl.font;
            tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            tf.delegate = self;
            tf.tag = 100+i;
            [self.contentView addSubview:tf];

        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    int index = textField.tag%10;
    
    NSArray *keys = [@"name,amount,times" componentsSeparatedByString:@","];
    
    NSString *content = textField.text;
    
    if (content)
        [self.dicInfo setObject:content forKey:[keys objectAtIndex:index]];
    else
        [self.dicInfo removeObjectForKey:[keys objectAtIndex:index]];
        
    [self.delegate planChanged:self];
}

- (void)setDicInfo:(NSMutableDictionary *)info{
    dicInfo = info;
    NSArray *keys = [@"name,amount,times" componentsSeparatedByString:@","];
    
    for (int i=0;i<3;i++){
        UITextField *tf = (UITextField *)[self.contentView viewWithTag:100+i];
        tf.text = [info objectForKey:[keys objectAtIndex:i]];
    }
}

- (NSMutableDictionary *)dicInfo{
    return dicInfo;
}

@end
