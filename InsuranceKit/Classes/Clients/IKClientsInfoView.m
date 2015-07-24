//
//  IKClientsInfoView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKClientsInfoView.h"
#import "IKBorderCell.h"
#import "IKWebPopViewController.h"

@implementation IKClientsInfoView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.97 alpha:1];
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(30, 16, 97, 15) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithRed:.12 green:.69 blue:.96 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kPolicyType");
        [self addSubview:lbl];
        
        lblPlanName = [UILabel createLabelWithFrame:CGRectMake(133, 15, 346, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.2 alpha:1]];
        [self addSubview:lblPlanName];
        
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(30, 46, 97, 15) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithRed:.12 green:.69 blue:.96 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kPolicyNumber");
        [self addSubview:lbl];
        
        lblNumber = [UILabel createLabelWithFrame:CGRectMake(133, 45, 346, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.2 alpha:1]];
        [self addSubview:lblNumber];
        
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(480, 16, 90, 14) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithRed:.12 green:.69 blue:.96 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kStartDate");
        [self addSubview:lbl];
        
        lblStartDate = [UILabel createLabelWithFrame:CGRectMake(556, 15, 110, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.2 alpha:1]];
        [self addSubview:lblStartDate];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(480, 46, 90, 14) font:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithRed:.12 green:.69 blue:.96 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"kEnddate");
        [self addSubview:lbl];
        
        lblEndDate = [UILabel createLabelWithFrame:CGRectMake(556, 45, 110, 16) font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithWhite:.2 alpha:1]];
        [self addSubview:lblEndDate];
        
        
        lblPlanName.text = @"";
        lblNumber.text = @"";
        lblStartDate.text = @"";
        lblEndDate.text = @"";
        
        UIView *vBG = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.frame.size.width, self.frame.size.height-80)];
        vBG.backgroundColor = [UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1];
        [self addSubview:vBG];
        
        
     //   NSArray *titles = [@"免赔额,门诊自付比例,门诊限额,住院自付比例" componentsSeparatedByString:@","];
        NSArray *titles = @[LocalizeStringFromKey(@"kDeductible"),
                            LocalizeStringFromKey(@"kOutpatientCo-pay"),
                            LocalizeStringFromKey(@"kOutpatientlimitation"),
                            LocalizeStringFromKey(@"kInpatientCo-pay")];
        for (int i=0;i<4;i++){
            int row = i/2;
            int col = i%2;
            
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(42+170*col, 94+115*row, 157, 103)];
            imgv.backgroundColor =  (i==1 || i==2)?[UIColor colorWithRed:1 green:.46 blue:0 alpha:1]:[UIColor whiteColor];
            imgv.layer.shadowOpacity = .3f;
            imgv.layer.shadowRadius = 1;
            imgv.layer.shadowOffset = CGSizeMake(0, 0);
            [self addSubview:imgv];
            
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(0, 60, 157, 43) font:[UIFont boldSystemFontOfSize:16] textColor:(i==1 || i==2)?[UIColor whiteColor]:[UIColor colorWithRed:1 green:.46 blue:0 alpha:1]];
            lbl.textAlignment = NSTextAlignmentCenter;
            [imgv addSubview:lbl];
            lbl.text = [titles objectAtIndex:i];
            
            
            lbl = [UILabel createLabelWithFrame:CGRectMake(0, 0, 157, 60) font:[UIFont boldSystemFontOfSize:25] textColor:(i==1 || i==2)?[UIColor whiteColor]:[UIColor colorWithRed:1 green:.46 blue:0 alpha:1]];
            lbl.textAlignment = NSTextAlignmentCenter;
            [imgv addSubview:lbl];
            
            switch (i) {
                case 0:lblMPE = lbl;break;
                case 1:lblMZRatio = lbl;break;
                case 2:lblThreshold = lbl;break;
                case 3:lblZYRatio = lbl;break;
                default:
                    break;
            }
        }
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:36],NSFontAttributeName, nil]]];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[InternationalControl isEnglish]?@"/visit":@"/次" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]]];
        lblMPE.attributedText = attr;
        
        attr = [[NSMutableAttributedString alloc] init];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:36],NSFontAttributeName, nil]]];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]]];
        lblMZRatio.attributedText = attr;
        
        attr = [[NSMutableAttributedString alloc] init];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:36],NSFontAttributeName, nil]]];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[InternationalControl isEnglish]?@"/visit":@"/次" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]]];
        lblThreshold.attributedText = attr;
        
        attr = [[NSMutableAttributedString alloc] init];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:36],NSFontAttributeName, nil]]];
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]]];
        lblZYRatio.attributedText = attr;
        
        
        imgvInstantPay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleMan.png"]];
        imgvInstantPay.center = CGPointMake(534, 200);
//        imgvInstantPay.backgroundColor = [UIColor clearColor];
//        imgvInstantPay.layer.borderColor = [UIColor colorWithWhite:.67 alpha:1].CGColor;
//        imgvInstantPay.layer.cornerRadius = imgvInstantPay.frame.size.width/2;
//        imgvInstantPay.layer.borderWidth = 21;
        [self addSubview:imgvInstantPay];
        
        lblInstantPay = [UILabel createLabelWithFrame:CGRectMake(0, 0, 90, 20) font:[UIFont boldSystemFontOfSize:18] textColor:[UIColor colorWithRed:1 green:.53 blue:0 alpha:1]];
        lblInstantPay.center = CGPointMake(imgvInstantPay.frame.origin.x+imgvInstantPay.frame.size.width+50, 190);
//        lblInstantPay.textAlignment = NSTextAlignmentCenter;
        lblInstantPay.text = LocalizeStringFromKey(@"kNondirectbilling");
        [self addSubview:lblInstantPay];
        
        lbl = [UILabel createLabelWithFrame:CGRectMake(37, 335, 100, 14) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor colorWithWhite:.53 alpha:1]];
        lbl.text = LocalizeStringFromKey(@"k_Memo");
        [self addSubview:lbl];
        
        lblMemo = [[UITextView alloc] initWithFrame:CGRectMake(37, 353, self.frame.size.width-37*2, 45)];
        lblMemo.font = [UIFont boldSystemFontOfSize:14];
        lblMemo.textColor = [UIColor colorWithWhite:.53 alpha:1];
        [lblMemo setEditable:NO];
        lblMemo.backgroundColor = [UIColor clearColor];
//        lblMemo = [UILabel createLabelWithFrame:CGRectMake(37, 353, self.frame.size.width-37*2, 34) font:[UIFont boldSystemFontOfSize:14] textColor:[UIColor colorWithWhite:.53 alpha:1]];
//        lblMemo.numberOfLines = 0;
        lblMemo.text = @"";
        [self addSubview:lblMemo];
        
        
        languageBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 12, 26, 26)];
//        languageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        languageBtn.titleLabel.textAlignment =NSTextAlignmentLeft;
//        [languageBtn setTitle:@"English" forState:UIControlStateNormal];
//        [languageBtn setTitle:@"中文" forState:UIControlStateSelected];
        [languageBtn setBackgroundImage:[UIImage imageNamed:@"IK_en"] forState:UIControlStateNormal];
        [languageBtn setBackgroundImage:[UIImage imageNamed:@"IK_ch"] forState:UIControlStateSelected];
        languageBtn.backgroundColor = [UIColor clearColor];
        languageBtn.selected = [[InternationalControl userLanguage] isEqualToString:@"zh-Hans"]?NO:YES;
//        [languageBtn setTitleColor:[UIColor colorWithRed:.99 green:.45 blue:.25 alpha:1] forState:UIControlStateNormal];
        [languageBtn addTarget:self  action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchUpInside];

        
        tvList = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, frame.size.width, vBG.frame.size.height)];
        tvList.clipsToBounds = YES;
        tvList.delegate = self;
        tvList.dataSource = self;
        tvList.backgroundColor = self.backgroundColor;
//        tvList.separatorColor = [UIColor colorWithWhite:.84 alpha:1];
        tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tvList.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tvList.showsVerticalScrollIndicator = NO;
        [self addSubview:tvList];
        [self showTableHeader];
        [self showTableFooter];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideDutyView) name:@"HideDutyView" object:nil];
        
    }
    return self;
}

- (void)showInfo{
    NSDictionary *dicInfo = visit.detailInfo;
    
    dicRights = [NSMutableDictionary dictionary];
    aryRights = [dicInfo objectForKey:@"liabilitys"];
    
    for (int i=0;i<aryRights.count;i++){
        NSDictionary *right = [aryRights objectAtIndex:i];
        NSString *liabilityId = [right objectForKey:@"liabilityId"];
        [dicRights setObject:@"1" forKey:liabilityId];
    }
    
    lblStartDate.text = [dicInfo objectForKey:@"effDateFrom"];
    lblEndDate.text = [dicInfo objectForKey:@"effDateTo"];
    lblPlanName.text = [dicInfo objectForKey:@"policyType"];
    lblNumber.text = [dicInfo objectForKey:@"policyNo"];
    lblMemo.text = [dicInfo objectForKey:@"notes"];
//    lblMemo.text = @"11111111ooooolvmcdlvdfklnvjkdf mds mdsv mdksvfdklsmkfls;mkdfngkflngkfdlnvjdfklnvdkl vjkslndjkfbjdbvfn vfknvvvvvvvvvvvvvvvvvvvfkfkdlfkdlsfjjknfjdknfjnvjfnvjdnvj";
//    [lblPlanName sizeToFit];
//    [lblNumber sizeToFit];
    
    NSString *franchise = [dicInfo objectForKey:@"franchise"];
    NSString *outpatientMaxLimit = [dicInfo objectForKey:@"outpatientMaxLimit"];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[self amount:franchise] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:36],NSFontAttributeName, nil]]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[self unit:franchise] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]]];
    lblMPE.attributedText = attr;
    
    attr = [[NSMutableAttributedString alloc] init];//[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f",[[[dicInfo objectForKey:@"outCopay"]
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[[dicInfo objectForKey:@"outCopay"] stringByReplacingOccurrencesOfString:@"%" withString:@""] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:36],NSFontAttributeName, nil]]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]]];
    lblMZRatio.attributedText = attr;
    
    attr = [[NSMutableAttributedString alloc] init];//[NSString stringWithFormat:@"%0.2f",[[[dicInfo objectForKey:@"inCopay"] stringByReplacingOccurrencesOfString:@"%" withString:@""] floatValue]]
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[[dicInfo objectForKey:@"inCopay"] stringByReplacingOccurrencesOfString:@"%" withString:@""] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:36],NSFontAttributeName, nil]]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]]];
    lblZYRatio.attributedText = attr;
    
    attr = [[NSMutableAttributedString alloc] init];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[self amount:outpatientMaxLimit] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:36],NSFontAttributeName, nil]]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[self unit:outpatientMaxLimit] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName, nil]]];
    lblThreshold.attributedText = attr;
    
    //  OutpatientMaxLimit
    
    int direct = [[dicInfo objectForKey:@"directbilling"] intValue];
    lblInstantPay.text = direct==1?LocalizeStringFromKey(@"kDirectbilling"):(direct==2?@"门诊非直付":LocalizeStringFromKey(@"kNondirectbilling"));
    lblInstantPay.textColor = direct?[UIColor colorWithRed:1 green:.53 blue:0 alpha:1]:[UIColor colorWithWhite:.53 alpha:1];
    [lblInstantPay sizeToFit];

    [tvList reloadData];
    [self showTableHeader];
    [self showTableFooter];
}

- (NSString *)unit:(NSString *)content{
    NSArray *ary = [content componentsSeparatedByString:@" "];
    if (ary.count==2)
        return [[ary objectAtIndex:0] stringByAppendingString:[InternationalControl isEnglish]?@"/visit":@"/次"];
    else
        return [InternationalControl isEnglish]?@"/visit":@"/次";
}

- (NSString *)amount:(NSString *)content{
    NSArray *ary = [content componentsSeparatedByString:@" "];
    if (ary.count>0)
        return [ary objectAtIndex:0];
    else
        return @"0";
    
}

- (void)showTableHeader{
    if (!vHeader){
        vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 68)];
        vHeader.backgroundColor = [UIColor colorWithRed:.3 green:.43 blue:.51 alpha:1];
    }
    for (UIView *v in vHeader.subviews)
        [v removeFromSuperview];
    
    float w = vHeader.frame.size.width/5;
    float h = vHeader.frame.size.height;
    
    
    
//    NSArray *titles = [@"保险责任,医疗,体检,齿科,眼科" componentsSeparatedByString:@","];
    NSArray *titles =@[LocalizeStringFromKey(@"kBenefit"),
                       LocalizeStringFromKey(@"kHealth"),
                       LocalizeStringFromKey(@"kWellness"),
                       LocalizeStringFromKey(@"kDental"),
                       LocalizeStringFromKey(@"kVision")];
    NSArray *keys = [@"liabilityId,HEALTH,CHECKUP,DENTAL,VISION" componentsSeparatedByString:@","];
    
    NSDictionary *titleInfo = [NSDictionary dictionaryWithObjects:titles forKeys:keys];
    
    for (int i=0;i<1+dicRights.allKeys.count;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w*i, 0, w, h);
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:.31 green:.43 blue:.51 alpha:1] size:CGSizeMake(w, h)] forState:UIControlStateNormal];
        if (i>0){
            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:.52 blue:.55 alpha:1] size:CGSizeMake(w, h)] forState:UIControlStateSelected];
        }
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (0==i)
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        else{
            NSString *key = [dicRights.allKeys objectAtIndex:i-1];
            [btn setTitle:[titleInfo objectForKey:key] forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [vHeader addSubview:btn];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    tvList.tableHeaderView = vHeader;
}

- (void)showTableFooter{
    if (!vFooter){
        vFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 46)];
        UILabel *lbl = [UILabel createLabelWithFrame:vFooter.bounds font:[UIFont boldSystemFontOfSize:16] textColor:[UIColor colorWithWhite:.65 alpha:1]];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = LocalizeStringFromKey(@"kClickshow");
        [vFooter addSubview:lbl];
    }
    
    tvList.tableFooterView = vFooter;
}

- (void)headerClicked:(UIButton *)btn{
    CGRect frame = tvList.frame;
    if (bShowInfoList){
        if (btn.tag==100){
            bShowInfoList = NO;
            frame.origin.y = 400;
            tvList.frame = frame;
            [tvList reloadData];
            [self showTableHeader];
            [self showTableFooter];
        }else{
            dSelectedIndex = btn.tag-101;
            [tvList reloadData];
        }
    }else{
        if (btn.tag!=100){
            bShowInfoList = YES;
            
            dSelectedIndex = btn.tag-101;
            
            frame.origin.y = 80;
            tvList.frame = frame;
            tvList.tableFooterView = nil;
            
            [tvList reloadData];
        }
    }
    
    for (int i=1;i<5;i++){
        UIButton *b = (UIButton *)[vHeader viewWithTag:100+i];
        b.selected = b.tag==btn.tag;
    }
}

-(void)changeLanguage:(UIButton*)btn{

    btn.selected = !btn.selected;
    [tvList reloadData];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self hideDutyView];
}

- (void)hideDutyView{
    CGRect frame = tvList.frame;
    
    bShowInfoList = NO;
    frame.origin.y = 400;
    tvList.frame = frame;
    [tvList reloadData];
    [self showTableHeader];
    [self showTableFooter];
}

- (NSArray *)selectedRights{
    NSString *key = [dicRights.allKeys objectAtIndex:dSelectedIndex];
    
    NSMutableArray *mut = [NSMutableArray array];
    for (int i=0;i<aryRights.count;i++){
        if ([[[aryRights objectAtIndex:i] objectForKey:@"liabilityId"] isEqualToString:key])
            [mut addObject:[aryRights objectAtIndex:i]];
    }
    
    return mut;
}


#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier0 = @"InfoIdentifier";
    static NSString *identifier1 = @"RightsIdentifier";
    
    NSInteger row = indexPath.row;
    
    NSString *identifier = row<6?identifier0:identifier1;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        float widths[] = {.36f,.16f,.16f,.16f,.16f};
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        float x = 0;
        
        for (int i=0;i<5;i++){
            float w = widths[i]*tvList.frame.size.width;
            UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(0==i?(x+5):x, 0, 0==i?(w-5):w, 45) font:[UIFont boldSystemFontOfSize:16] textColor:[UIColor colorWithWhite:.55 alpha:1]];
            x += w;
            lbl.tag = 100+i;
            lbl.textAlignment = 0==i?NSTextAlignmentLeft:NSTextAlignmentCenter;

            [cell.contentView addSubview:lbl];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(32, 44, tableView.frame.size.width-32, 1)];
        line.backgroundColor = [UIColor colorWithRed:.85 green:.88 blue:.9 alpha:1];
        [cell.contentView addSubview:line];
    }
    
    NSDictionary *dict = [[self selectedRights] objectAtIndex:indexPath.row];
    NSArray *keys;
    if (languageBtn.selected) {
  
           keys = [@"welfare,maxLimit,type,remaining,notes" componentsSeparatedByString:@","];
    }else{
   keys = [@"welfareCHN,maxLimit,type,remaining,notes" componentsSeparatedByString:@","];
    }
    
    for (int i=0;i<5;i++){
        UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:100+i];
        
        if (1==i || 3==i)
            lbl.text = [dict objectForKey:[keys objectAtIndex:i]];
        else if (2==i){
            NSString *content = nil;
            NSString *type = [dict objectForKey:[keys objectAtIndex:i]];
            if ([type caseInsensitiveCompare:@"amount"]==NSOrderedSame)
                content =LocalizeStringFromKey(@"k_Amount");
            else if ([type caseInsensitiveCompare:@"visit"]==NSOrderedSame)
                content =LocalizeStringFromKey(@"k_visits");
            else
                content = LocalizeStringFromKey(@"k_days");
            lbl.text = content;
        }
        else
            lbl.text = [dict objectForKey:[keys objectAtIndex:i]];
    }
    
    cell.contentView.backgroundColor = indexPath.row%2==0?[UIColor colorWithRed:.98 green:.95 blue:.96 alpha:1]:[UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!bShowInfoList)
        return 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!bShowInfoList)
        return 0;
    
    return [self selectedRights].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 48)];
    v.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];
    
    float widths[] = {.36f,.16f,.16f,.16f,.16f};
    float x = 0;
    
//    NSArray *titles = [@"福利，限额，类型，余额，备注" componentsSeparatedByString:@"，"];
    
     NSArray *titles = @[LocalizeStringFromKey(@"kWelfare"),LocalizeStringFromKey(@"kLimitation"),LocalizeStringFromKey(@"kType"),LocalizeStringFromKey(@"kBalance"),LocalizeStringFromKey(@"kNotes")];
    for (int i=0;i<5;i++){
        float w = widths[i]*v.frame.size.width;
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, 0, w, 45) font:[UIFont boldSystemFontOfSize:16] textColor:[UIColor colorWithRed:.99 green:.45 blue:.25 alpha:1]];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [titles objectAtIndex:i];
        [v addSubview:lbl];
        
        if (i==0) {
    
            [v addSubview:languageBtn];
        }
        
        x += w;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(32, 47, v.frame.size.width-32, 1)];
    line.backgroundColor = [UIColor colorWithRed:.99 green:.45 blue:.25 alpha:1];
    [v addSubview:line];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableString *htmlString = [NSMutableString string];
    [htmlString appendString:@"<html><body>"];
    
    NSArray *keys = [@"welfare,maxLimit,type,remaining,notes,welfareCHN" componentsSeparatedByString:@","];
 //   NSArray *titles = [@"福利，限额，类型，余额，备注" componentsSeparatedByString:@"，"];
        NSArray *titles = @[LocalizeStringFromKey(@"kWelfare"),LocalizeStringFromKey(@"kLimitation"),LocalizeStringFromKey(@"kType"),LocalizeStringFromKey(@"kBalance"),LocalizeStringFromKey(@"kNotes")];
    NSDictionary *dict = [[self selectedRights] objectAtIndex:indexPath.row];;
    
    for (int i=0;i<5;i++){
        
        NSString *content = nil;

        if (1==i || 3==i)
            content = [dict objectForKey:[keys objectAtIndex:i]];
        else if (2==i){
            NSString *type = [dict objectForKey:[keys objectAtIndex:i]];
            if ([type caseInsensitiveCompare:@"amount"]==NSOrderedSame)
                content = LocalizeStringFromKey(@"k_Amount");
            else if ([type caseInsensitiveCompare:@"visit"]==NSOrderedSame)
                content = LocalizeStringFromKey(@"k_visits");
            else
                content = LocalizeStringFromKey(@"k_days");
        }
        else if (i == 0){
            content =[NSString stringWithFormat:@"%@ / %@", [dict objectForKey:[keys objectAtIndex:i]], [dict objectForKey:[keys objectAtIndex:5]]];
        }else{
            content = [dict objectForKey:[keys objectAtIndex:i]];
        }
        
        [htmlString appendFormat:@"<p>%@:%@</p>",[titles objectAtIndex:i],content];
    }
    
    [htmlString appendString:@"</body></html>"];
    
    IKWebPopViewController *webPop = [[IKWebPopViewController alloc] init];
    webPop.content = htmlString;
    
    pcDetail = [[UIPopoverController alloc] initWithContentViewController:webPop];
    pcDetail.delegate = self;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    [pcDetail presentPopoverFromRect:cell.frame inView:tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - UIPopController Delegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    pcDetail = nil;
}




@end
