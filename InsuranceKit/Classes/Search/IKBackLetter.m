//
//  IKBackLetter.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-5.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKBackLetter.h"
#import "IKAppDelegate.h"

@implementation IKBackLetter

- (id)initWithFrame:(CGRect)frame info:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        // Initialization code
        UIImageView *imgvBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 684, 200)];
        imgvBG.backgroundColor = [UIColor whiteColor];
        imgvBG.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:imgvBG];
        
        UIImageView *imgvRect = [[UIImageView alloc] initWithFrame:CGRectMake(8, 12, imgvBG.frame.size.width-8*2, imgvBG.frame.size.height-12*2)];
        imgvRect.backgroundColor = [UIColor whiteColor];
        imgvRect.layer.borderColor = [UIColor colorWithRed:.78 green:.81 blue:.84 alpha:1].CGColor;
        imgvRect.layer.borderWidth = 1;
        [imgvBG addSubview:imgvRect];
        
        NSArray *captions = [@"Service Type,Approved Cost,Approval LOS,Total Discounts,Room Type,Deductible,Expected Date,Co-payment,Comments" componentsSeparatedByString:@","];
        NSArray *titles = [@"福利类别,担保费用,担保住院天数,折扣,病房类型,免赔额,预期时间,自付额,备注" componentsSeparatedByString:@","];
             /* NSArray *titles = @[LocalizeStringFromKey(@"kwelfareType"),
                                  LocalizeStringFromKey(@"kguaranteeFee"),
                                  LocalizeStringFromKey(@"kguaranteeInhospital"),
                                  LocalizeStringFromKey(@"kdisCountFee"),
                                  LocalizeStringFromKey(@"kRoomtype"),
                                  LocalizeStringFromKey(@"kDeductible"),
                                  LocalizeStringFromKey(@"Kexpectedtime"),
                                  LocalizeStringFromKey(@"kCo-pay"),
                                  LocalizeStringFromKey(@"kNotes")];*/
        NSArray *keys = [@"serviceType,approvedCost,approvalLOS,totalDiscounts,roomType,deductible,expectedDate,copayment,comments" componentsSeparatedByString:@","];
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(24, 14, 300, 16) font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
        lbl.text = @"Approval(是否批准):YES";
        [imgvBG addSubview:lbl];
        
        for (int i=0;i<keys.count;i++){
            int row = i/2;
            int col = i%2;
            
            lbl = [UILabel createLabelWithFrame:CGRectMake(24+360*col, 42+30*row, (i==keys.count-1)?600:(col==0?350:300), 16) font:[UIFont systemFontOfSize:15] textColor:[UIColor blackColor]];
            
            NSString *content = [info objectForKey:[keys objectAtIndex:i]];
            
            lbl.text = [NSString stringWithFormat:@"%@(%@):%@",[captions objectAtIndex:i],[titles objectAtIndex:i],content?content:@""];
            if ([[keys objectAtIndex:i] isEqualToString:@"Approved Cost"])
                lbl.text = [NSString stringWithFormat:@"%@(%@):%@ %@",[captions objectAtIndex:i],[titles objectAtIndex:i],[info objectForKey:@"currencyUnit"],content?content:@""];
            [imgvBG addSubview:lbl];
            
            if (i==keys.count-1){
                CGSize size = [lbl.text sizeWithFont:lbl.font constrainedToSize:CGSizeMake(lbl.frame.size.width, FLT_MAX)];
                CGRect frame = lbl.frame;
                frame.size.height = size.height;
                lbl.frame = frame;
                lbl.numberOfLines = 0;
                
                
            }
        }
        
        frame = imgvRect.frame;
        frame.size.height = lbl.frame.origin.y+lbl.frame.size.height+2;
        imgvRect.frame = frame;
        
        frame = imgvBG.frame;
        frame.size.height = imgvRect.frame.size.height+24;
        imgvBG.frame = frame;
        
        imgvBG.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
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

+ (void)showLetter:(NSDictionary *)info{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKBackLetter *v = [[IKBackLetter alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) info:info];
    
    [w.rootViewController.view addSubview:v];
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
}

@end
