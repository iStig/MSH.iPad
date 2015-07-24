//
//  IKClientClaimsCell.m
//  InsuranceKit
//
//  Created by iStig on 14-10-9.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKClientDataBaseCell.h"
#import "IKStatusSelector.h"
#import "IKBackLetter.h"
@implementation IKClientDataBaseCell
@synthesize dicInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
      
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 94)];
        line.backgroundColor = [UIColor colorWithRed:.86 green:.88 blue:.89 alpha:1];
        line.center = CGPointMake(352, 47);
        [self.contentView addSubview:line];
        
        vBG = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 305, 55)];
        vBG.backgroundColor = [UIColor whiteColor];
        vBG.clipsToBounds = YES;
        vBG.layer.cornerRadius = 4;
        vBG.layer.borderWidth = .5f;
        vBG.layer.borderColor = [UIColor colorWithRed:.84 green:.83 blue:.83 alpha:1].CGColor;
        [self.contentView addSubview:vBG];
        
        lblID = [UILabel createLabelWithFrame:CGRectZero font:[UIFont systemFontOfSize:11] textColor:[UIColor colorWithWhite:.15 alpha:1]];
        [vBG addSubview:lblID];
        
        lblStatus = [UILabel createLabelWithFrame:CGRectZero font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithWhite:.53 alpha:1]];
        [vBG addSubview:lblStatus];
        
        lblPlan = [UILabel createLabelWithFrame:CGRectZero font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithWhite:.53 alpha:1]];
        [vBG addSubview:lblPlan];
        
        lblDate = [UILabel createLabelWithFrame:CGRectZero font:[UIFont systemFontOfSize:11] textColor:[UIColor colorWithWhite:.53 alpha:1]];
        [self.contentView addSubview:lblDate];
        
        
        vCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        vCircle.backgroundColor = [UIColor colorWithRed:.92 green:.95 blue:.96 alpha:1];
        vCircle.clipsToBounds = YES;
        vCircle.layer.cornerRadius = vCircle.frame.size.width/2;
        vCircle.layer.borderWidth = 2;
        vCircle.center = CGPointMake(line.center.x, line.frame.size.height-vCircle.frame.size.height/2);
        [self.contentView addSubview:vCircle];
        
     
        
    }
    return self;
}

- (void)showInfo{
  
    
   
    lblID.text = [dicInfo objectForKey:@"claimsNo"];
    lblPlan.text =[dicInfo objectForKey:@"visitType"];
    lblDate.text = [dicInfo objectForKey:@"submitDate"];
    lblStatus.text = [dicInfo objectForKey:@"status"];
   [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void)setDicInfo:(NSDictionary *)info{
    dicInfo = info;
    
    [self showInfo];
}

-(void)showStates{
    
    CGRect frame;

    NSDictionary *skv = @{@"收到理赔资料":@"0",@"补充病历":@"1",@"理赔处理中":@"2",@"已赔付":@"3",@"其他":@"4"};
    NSDictionary *ckv = @{@"0":[UIColor redColor],@"1":[UIColor greenColor],@"2":[UIColor yellowColor],@"3":[UIColor darkGrayColor],@"4":[UIColor orangeColor]};
    NSString  *dstatus = [dicInfo objectForKey:@"status"];
    UIColor *color = [ckv objectForKey:[skv objectForKey:dstatus]];

   
  
    
    float x = 352,y0 = 13,y1 = 31;
    
    if (10==1){
        frame = vBG.frame;
        frame.origin.x = x;
        vBG.frame = frame;
        
        [lblID sizeToFit];
        frame = lblID.frame;
        frame.origin.x = 41;
        frame.origin.y = y0;
        lblID.frame = frame;
        
        [lblPlan sizeToFit];
        frame = lblPlan.frame;
        frame.origin.x = lblID.frame.origin.x;
        frame.origin.y = y1;
        lblPlan.frame = frame;
        
        [lblStatus sizeToFit];
        frame = lblStatus.frame;
        frame.origin.x = lblPlan.frame.origin.x+lblPlan.frame.size.width+34;
        frame.origin.y = y1;
        lblStatus.frame = frame;
        
        
        [lblDate sizeToFit];
        lblDate.center = CGPointMake(x-41-lblDate.frame.size.width/2, vBG.center.y);
        
    }else{
        frame = vBG.frame;
        frame.origin.x = x-frame.size.width;
        vBG.frame = frame;
        
        [lblID sizeToFit];
        frame = lblID.frame;
        frame.origin.x = vBG.frame.size.width-41-frame.size.width;
        frame.origin.y = y0;
        lblID.frame = frame;
        
        [lblPlan sizeToFit];
        frame = lblPlan.frame;
        frame.origin.x = vBG.frame.size.width-41-frame.size.width;
        frame.origin.y = y1;
        lblPlan.frame = frame;
        
        [lblStatus sizeToFit];
        frame = lblStatus.frame;
        frame.origin.x = lblPlan.frame.origin.x-34-frame.size.width;
        frame.origin.y = y1;
        lblStatus.frame = frame;
        
        
        [lblDate sizeToFit];
        lblDate.center = CGPointMake(x+41+lblDate.frame.size.width/2, vBG.center.y);
    }
    
    srand(time(NULL));
    
    
    vCircle.layer.borderColor = color.CGColor;
    
    
    
}

//获取理赔状态
- (void)loadData{
    @autoreleasepool {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDictionary *dict = [IKDataProvider getClaimStateList:param];
        NSArray *ary = [dict objectForKey:@"data"];
        aryList = [NSMutableArray arrayWithArray:ary];
        sw_dispatch_sync_on_main_thread(^{
        });
        [self showStates];
        NSLog(@"ClaimState List:%@",dict);
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
