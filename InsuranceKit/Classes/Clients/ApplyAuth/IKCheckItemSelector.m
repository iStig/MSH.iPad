//
//  IKCheckItemSelector.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-4-16.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKCheckItemSelector.h"
#import "IKAppDelegate.h"

@implementation IKCheckItemSelector
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame point:(CGPoint)pt
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        vContent = [[UIView alloc] initWithFrame:CGRectMake(pt.x, pt.y, 262, 536)];
        vContent.backgroundColor = [UIColor colorWithRed:1 green:.98 blue:.98 alpha:1];
        vContent.layer.borderWidth = 4;
        vContent.layer.borderColor = [UIColor colorWithRed:.88 green:.44 blue:0 alpha:1].CGColor;
        float x = 4+10;
        float y = 4;
        float w = vContent.frame.size.width-x*2;
        float h = (vContent.frame.size.height-y*2)/12;
        
        [self addSubview:vContent];
        
//        aryTitles = [@"请选择一到三项检查,24hrs Holter,Ultrasound,CT,CTA,MRL,PET-CT,Sleep,Study,Gastroscopy,Colonos,Capsule Endoscopy" componentsSeparatedByString:@","];
        
            aryTitles= [[NSString stringWithFormat:@"%@,24hrs Holter,Ultrasound,CT,CTA,MRI,PET-CT,Sleep Study,MRA,Gastroscopy,Colonoscopy,Capsule Endoscopy",LocalizeStringFromKey(@"koptions")] componentsSeparatedByString:@","];
        
        for (int i=0;i<12;i++){
            if (i>0){
                NSString *text = [aryTitles objectAtIndex:i];
                CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil]];
                CGSize imgSize = [[UIImage imageNamed:@"IKIconCircleCheckNO.png"] size];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(x, y+h*i, w, h);
                btn.titleLabel.font = [UIFont systemFontOfSize:17];
                [btn setTitleColor:[UIColor colorWithWhite:.26 alpha:1] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"IKIconCircleCheckNO.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"IKIconCircleCheckYES.png"] forState:UIControlStateSelected];
                [btn setTitle:text forState:UIControlStateNormal];
                
                btn.imageEdgeInsets = UIEdgeInsetsMake((btn.frame.size.height-imgSize.height)/2, btn.frame.size.width-imgSize.width, (btn.frame.size.height-imgSize.height)/2, 0);
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, -(btn.frame.size.width-size.width), 0, 0);
                
                btn.tag = i;
                [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [vContent addSubview:btn];
            }else{
                UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, y, w, h) font:[UIFont boldSystemFontOfSize:20] textColor:[UIColor colorWithRed:.92 green:.9 blue:.91 alpha:1]];
                lbl.text = [aryTitles objectAtIndex:i];
                [vContent addSubview:lbl];
            }
            
            if (0!=11){
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y+h*(i+1), w, 1)];
                line.backgroundColor = [UIColor colorWithRed:.92 green:.9 blue:.91 alpha:1];
                [vContent addSubview:line];
            }
            
        }
    }
    return self;
}

- (void)itemClicked:(UIButton *)btn{
    int count = 0;
    
    for (UIButton *b in vContent.subviews){
        if ([b isKindOfClass:[UIButton class]] && b.isSelected){
            count++;
        }
    }
    
    if (count<3 || (count==3 && btn.selected)){
        btn.selected = !btn.selected;
        
        [self itemsChanged];
    }
}

- (void)itemsChanged{
    NSMutableString *mutstr = [NSMutableString string];

    for (UIButton *b in vContent.subviews){
        if ([b isKindOfClass:[UIButton class]] && b.isSelected){
            NSString *tag = [NSString stringWithFormat:@"%d",b.tag];
            
            if (mutstr.length>0)
                [mutstr appendFormat:@",%@",tag];
            else
                [mutstr appendString:tag];
        }
    }
    
    if (mutstr.length==0)
        [self.delegate didSelectedItems:nil];
    else
        [self.delegate didSelectedItems:mutstr];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(vContent.frame, pt)){
        [self dismiss];
    }
}

- (void)dismiss{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (void)showAtPoint:(CGPoint)pt delegate:(id)dele{
    
    
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKCheckItemSelector *v = [[IKCheckItemSelector alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) point:pt];
    v.delegate = dele;
    
    
    
    v.alpha = 0;
    
    [w.rootViewController.view addSubview:v];
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
