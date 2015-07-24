//
//  IKCustomerViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-9-19.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKCustomerViewController.h"

@interface IKCustomerViewController ()

@end

@implementation IKCustomerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleAry = @[@"   a.我们的医院代表是否态度友好，乐于为您提供服务？",@"   b.对于您的咨询,医院代表是否能及时答复?",@"   c.我们的医院代表能否协助您解决就医的问题？",@"2.您对该医院的服务满意吗？",@"3.该医院的医生与您的沟通时间？",@"4.您对该医院的医生的英文满意吗？",@"5.该医院有过度医疗行为吗？",@"6.对于该医院您愿意推荐医生是：",@"7.对于服务质量的进一步提高，您的建议是："];
    
    
    
    titles_cell_min = @[@"<10分钟",@"20-30分钟",@"40-50分钟",@">60分钟"];
    
    titles_cell_treatment = @[@"没有",@"过度检查",@"过度治疗"];
    
    titles_cell_normal = @[LocalizeStringFromKey(@"kExcellent"),
                           LocalizeStringFromKey(@"kGood"),
                           LocalizeStringFromKey(@"kNormal"),
                           LocalizeStringFromKey(@"kBad")];
    
    //1:  a  b  c
    evaluateDic = [NSMutableDictionary dictionary];
    [evaluateDic setObject:@""  forKey:@"service"];
    [evaluateDic setObject:@""  forKey:@"reply"];
    [evaluateDic setObject:@""  forKey:@"solveProblem"];
    //2
    [evaluateDic setObject:LocalizeStringFromKey(@"kExcellent")  forKey:@"attitude"];
    
    //3  4 5
    [evaluateDic setObject:@"<10分钟"  forKey:@"communicateTime"];
    [evaluateDic setObject:LocalizeStringFromKey(@"kExcellent")  forKey:@"english"];
    [evaluateDic setObject:@"没有"  forKey:@"excessiveMedical"];
    
    //6  7
    [evaluateDic setObject:@"" forKey:@"recommendDoctor"];
    [evaluateDic setObject:@"" forKey:@"suggest"];
    //name  phone
    [evaluateDic setObject:@"" forKey:@"guestname"];
    [evaluateDic setObject:@"" forKey:@"phone"];
    
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];
    
    tvList = [[UITableView alloc] initWithFrame:CGRectZero];
    [tvList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CustomerInfo"];
    tvList.delegate = self;
    tvList.dataSource = self;
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvList.showsVerticalScrollIndicator = NO;
    tvList.backgroundColor = [UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1];
    [self.view addSubview:tvList];
}


- (void)viewWillLayoutSubviews{
    tvList.frame = CGRectMake(20, 10, self.view.frame.size.width-20*2, self.view.frame.size.height-10);
}


#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *identifier0 = @"identifier0";
    static NSString *identifier1 = @"identifier1";
    //    static NSString *identifier2 = @"identifier2";
    //    static NSString *identifier3 = @"identifier3";
    //    static NSString *identifier4 = @"identifier4";
    //    static NSString *identifier5 = @"identifier5";
    //    static NSString *identifier6 = @"identifier6";
    static NSString *identifier7 = @"identifier7";
    static NSString *identifier8 = @"identifier8";
    static NSString *identifier9 = @"identifier9";
    
    
    
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier0];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            UILabel *lblMainTitle = [UILabel createLabelWithFrame:CGRectMake(0 , 4,  tableView.frame.size.width, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor blackColor]];
            lblMainTitle.textAlignment = NSTextAlignmentLeft;
            lblMainTitle.tag = 80;
            [cell.contentView addSubview:lblMainTitle];
            
            float hight = 40;
            
            UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(0, hight, tableView.frame.size.width, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
            lblTitle.textAlignment = NSTextAlignmentLeft;
            lblTitle.tag = 90;
            [cell.contentView addSubview:lblTitle];
            
            
            for (int i = 0; i < 4; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10 +i*(22 + 10 +75 ), 36+hight, 22, 22);
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_selected"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_unselected"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(mainClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 100+i;
                
                [cell.contentView addSubview:btn];
                
                UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(btn.frame.origin.x +22+10 , 36+hight, 75, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
                lblTitle.textAlignment = NSTextAlignmentLeft;
                lblTitle.tag = 200+i;
                [cell.contentView addSubview:lblTitle];
            }
        }
        
        UILabel *lblMainTitle = (UILabel*)[cell.contentView viewWithTag:80];
        lblMainTitle.text = @"1.如有医院代表,请回答如下问题；如无医院代表，请直接到第2题";
        
        UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:90];
        lblTitle.text =[titleAry objectAtIndex:indexPath.row];
        for (int i = 0; i <4; i++) {
            UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:i+200];
            lblTitle.text =[titles_cell_normal objectAtIndex:i];
        }
        
        return cell;
    }
    
    
    
    if (indexPath.row == 1||indexPath.row == 2||indexPath.row == 3||indexPath.row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
            lblTitle.textAlignment = NSTextAlignmentLeft;
            lblTitle.tag = 90;
            [cell.contentView addSubview:lblTitle];
            
            
            for (int i = 0; i < 4; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10 +i*(22 + 10 +75 ), 36, 22, 22);
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_selected"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_unselected"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(mainClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 100+i;
                if (indexPath.row == 3 || indexPath.row ==5) {
                    btn.selected = i==0?YES:NO;
                }
                
                [cell.contentView addSubview:btn];
                
                UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(btn.frame.origin.x +22+10 , 36, 75, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
                lblTitle.textAlignment = NSTextAlignmentLeft;
                lblTitle.tag = 200+i;
                [cell.contentView addSubview:lblTitle];
            }
        }
        
        
        UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:90];
        lblTitle.text =[titleAry objectAtIndex:indexPath.row];
        for (int i = 0; i <4; i++) {
            UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:i+200];
            lblTitle.text =[titles_cell_normal objectAtIndex:i];
        }
        
        return cell;
    }
    
    
    if (indexPath.row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
            lblTitle.textAlignment = NSTextAlignmentLeft;
            lblTitle.tag = 90;
            [cell.contentView addSubview:lblTitle];
            
            
            for (int i = 0; i < 4; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10 +i*(22 + 10 +75 + 25), 36, 22, 22);
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_selected"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_unselected"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(mainClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 100+i;
                btn.selected = i==0?YES:NO;
                [cell.contentView addSubview:btn];
                
                UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(btn.frame.origin.x +22+10 , 36, 100, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
                lblTitle.textAlignment = NSTextAlignmentLeft;
                lblTitle.tag = 200+i;
                [cell.contentView addSubview:lblTitle];
            }
        }
        
        
        UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:90];
        lblTitle.text =[titleAry objectAtIndex:indexPath.row];
        for (int i = 0; i <4; i++) {
            UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:i+200];
            lblTitle.text =[titles_cell_min objectAtIndex:i];
        }
        
        return cell;
    }
    
    
    
    if (indexPath.row == 6) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
            lblTitle.textAlignment = NSTextAlignmentLeft;
            lblTitle.tag = 90;
            [cell.contentView addSubview:lblTitle];
            
            
            for (int i = 0; i < 3; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10 +i*(22 + 10 +75 +25 ), 36, 22, 22);
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_selected"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_unselected"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(mainClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 100+i;
                btn.selected = i==0?YES:NO;
                [cell.contentView addSubview:btn];
                
                UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(btn.frame.origin.x +22+10 , 36, 100, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
                lblTitle.textAlignment = NSTextAlignmentLeft;
                lblTitle.tag = 200+i;
                [cell.contentView addSubview:lblTitle];
            }
        }
        
        
        UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:90];
        lblTitle.text =[titleAry objectAtIndex:indexPath.row];
        for (int i = 0; i < 3; i++) {
            UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:i+200];
            lblTitle.text =[titles_cell_treatment objectAtIndex:i];
        }
        
        return cell;
    }
    
    
    if (indexPath.row == 7) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier7];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier7];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            
            UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(0, 0, 258, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
            lblTitle.textAlignment = NSTextAlignmentLeft;
            lblTitle.tag = 90;
            [cell.contentView addSubview:lblTitle];
            
            if (!docterName) {
                docterName = [[UITextField alloc] init];
                [docterName setFrame:CGRectMake(lblTitle.frame.size.width, 0 , 100,24)];
                [docterName setFont:[UIFont boldSystemFontOfSize:17]];
                docterName.backgroundColor = [UIColor clearColor];
                docterName.textColor = [UIColor colorWithWhite:.67 alpha:1];
                [cell.contentView addSubview:docterName];
            }
            
            
            UIView *nameline = [[UIView alloc] initWithFrame:CGRectMake(lblTitle.frame.size.width, 25, 100, 1)];
            nameline.backgroundColor = [UIColor colorWithWhite:.67 alpha:1];
            [cell.contentView addSubview:nameline];
            
            
            
        }
        
        
        UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:90];
        lblTitle.text =[titleAry objectAtIndex:indexPath.row];
        
        
        return cell;
        
        
    }
    
    if (indexPath.row == 8) {
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier8];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier8];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
            lblTitle.textAlignment = NSTextAlignmentLeft;
            lblTitle.tag = 90;
            [cell.contentView addSubview:lblTitle];
            
            
            if (!noteView) {
                noteView = [[IKTextView alloc] init];
                [noteView setFrame:CGRectMake(10, 25, 657-20, 190-36-24)];
                [noteView setDelegate:self];
                [noteView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
                noteView.backgroundColor = [UIColor clearColor];
                noteView.textColor = [UIColor colorWithWhite:.67 alpha:1];
                [cell.contentView  addSubview:noteView];
                
                
                UILabel *namelbl= [UILabel createLabelWithFrame:CGRectMake(10, noteView.frame.size.height + 25, 100, 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
//                namelbl.textAlignment = NSTextAlignmentRight;
                NSString *str =LocalizeStringFromKey(@"kYourName");
                CGSize size =[self getStringRect:str font:[UIFont boldSystemFontOfSize:17.0]];
                namelbl.text = LocalizeStringFromKey(@"kYourName");
                CGRect rect =namelbl.frame;
                rect.size.width =size.width;
                namelbl.frame =rect;
                [cell.contentView addSubview:namelbl];
                
                if (!nameText) {
                    nameText = [[UITextField alloc] init];
                    [nameText setFrame:CGRectMake(namelbl.frame.size.width+namelbl.frame.origin.x, noteView.frame.size.height + 25 , 150,24)];
                    [nameText setFont:[UIFont boldSystemFontOfSize:17]];
                    nameText.backgroundColor = [UIColor clearColor];
                    nameText.textColor = [UIColor colorWithWhite:.67 alpha:1];
                    [cell.contentView addSubview:nameText];
                }
                
                
                UIView *nameline = [[UIView alloc] initWithFrame:CGRectMake(namelbl.frame.size.width+namelbl.frame.origin.x,  noteView.frame.size.height + 25 +25, 150, 1)];
                nameline.backgroundColor = [UIColor colorWithWhite:.67 alpha:1];
                [cell.contentView addSubview:nameline];
                
                
                UILabel *maillbl= [UILabel createLabelWithFrame:CGRectMake(nameline.frame.origin.x + 180, noteView.frame.size.height + 25, 160, 24)  font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithRed:.99 green:.57 blue:.44 alpha:1]];
                maillbl.textAlignment = NSTextAlignmentRight;
                maillbl.text = LocalizeStringFromKey(@"kContactEmail");// "kContactEmail"  = "联系邮箱";
                [cell.contentView addSubview:maillbl];
                
                if (!mailtext) {
                    mailtext = [[UITextField alloc] init];
                    [mailtext setFrame:CGRectMake(maillbl.frame.origin.x+maillbl.frame.size.width, noteView.frame.size.height + 25, 300,24)];
                    [mailtext setFont:[UIFont boldSystemFontOfSize:17]];
                    mailtext.backgroundColor = [UIColor clearColor];
                    mailtext.textColor = [UIColor colorWithWhite:.67 alpha:1];
                    [cell.contentView addSubview:mailtext];
                }
                
                
                UIView *mailline = [[UIView alloc] initWithFrame:CGRectMake(maillbl.frame.origin.x+maillbl.frame.size.width,  noteView.frame.size.height + 25 +25, 200, 1)];
                mailline.backgroundColor = [UIColor colorWithWhite:.67 alpha:1];
                [cell.contentView addSubview:mailline];
            }
        }
        
        UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:90];
        lblTitle.text =[titleAry objectAtIndex:indexPath.row];
        
        return cell;
    }
    
    
    
    
    if (indexPath.row == 9) {
        
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier9];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier9];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            
            UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            savebtn.frame = CGRectMake((657 - 135)/2, 22, 135, 36);
            [savebtn setBackgroundImage:[UIImage imageNamed:@"save_evaluate"] forState:UIControlStateNormal];
            [savebtn setTitle:@"保 存" forState:UIControlStateNormal];
            [savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [savebtn addTarget:self action:@selector(saveClicked:) forControlEvents:UIControlEventTouchUpInside];
            savebtn.tag = 999;
            [cell.contentView addSubview:savebtn];
            
        }
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 120;
    }
    if (indexPath.row == 7) {
        return 60;
    }
    if (indexPath.row == 8) {
        return 190;
    }
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGSize)getStringRect:(NSString*)aString font:(UIFont *)font
{
    CGSize size;
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] ;
    size = [aString boundingRectWithSize:CGSizeMake(200, 24)  options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return  size;
    
}

#pragma mark  - BUTTON_ACTION
- (void)mainClicked:(UIButton *)btn{
    
    NSLog(@"%d",btn.tag);
//    UITableViewCell *cell = (UITableViewCell*)[btn.superview superview].superview;
    UITableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        cell = (UITableViewCell*)[btn.superview superview];
    }
    else{
        cell = (UITableViewCell*)[btn.superview superview].superview;
    }
    int pathIndex = [tvList indexPathForCell:cell].row;//当前激活的cell的index
    
    //indexpath ＝  0 1 2 3 5
    if (pathIndex == 0||pathIndex == 1||pathIndex == 2||pathIndex == 3||pathIndex == 5) {
        
        for (int i =100; i<104; i++) {
            UIButton *button = (UIButton*)[cell viewWithTag:i];
            
            
            if (i == btn.tag) {//当轮询到当前选中按钮
                
                NSString *key = @"";
                NSString *value = @"";
                switch (pathIndex) {
                    case 0:
                        key = @"service";
                        break;
                    case 1:
                        key = @"reply";
                        break;
                    case 2:
                        key = @"solveProblem";
                        break;
                        
                    case 3:
                        key = @"attitude";
                        break;
                        
                    case 5:
                        key = @"english";
                        break;
                    default:
                        break;
                }
                if (button.selected){//已经选中就返回
                    return;
                }else{ //未选中则继续 并致选中状态
                    button.selected = YES;
                }
                switch (i) {
                    case IKEvaluate_Excellent:
                        value = [titles_cell_normal objectAtIndex:(i-100)];
                        break;
                    case IKEvaluate_Fine:
                        value = [titles_cell_normal objectAtIndex:(i-100)];
                        break;
                    case IKEvaluate_Common:
                        value = [titles_cell_normal objectAtIndex:(i-100)];
                        break;
                    case IKEvaluate_Bad:
                        value = [titles_cell_normal objectAtIndex:(i-100)];
                        break;
                    default:
                        break;
                        
                        
                }
                [evaluateDic setObject:value forKey:key];
            }else{
                button.selected = NO;
            }
        }
    }
    
    
    //indexpath ＝ 4
    if (pathIndex == 4) {
        
        for (int i =100; i<104; i++) {
            UIButton *button = (UIButton*)[cell viewWithTag:i];
            
            
            if (i == btn.tag) {//当轮询到当前选中按钮
                
                NSString *key = @"";
                NSString *value = @"";
                switch (pathIndex) {
                    case 4:
                        key = @"communicateTime";
                        break;
                    default:
                        break;
                }
                if (button.selected){//已经选中就返回
                    return;
                }else{ //未选中则继续 并致选中状态
                    button.selected = YES;
                }
                switch (i-100) {
                    case 0:
                        value = [titles_cell_min objectAtIndex:(i-100)];
                        break;
                    case 1:
                        value = [titles_cell_min objectAtIndex:(i-100)];
                        break;
                    case 2:
                        value = [titles_cell_min objectAtIndex:(i-100)];
                        break;
                    case 3:
                        value = [titles_cell_min objectAtIndex:(i-100)];
                        break;
                    default:
                        break;
                        
                        
                }
                [evaluateDic setObject:value forKey:key];
            }else{
                button.selected = NO;
            }
        }
    }
    
    
    //indexpath ＝ 6
    if (pathIndex == 6) {
        
        for (int i =100; i<103; i++) {
            UIButton *button = (UIButton*)[cell viewWithTag:i];
            
            
            if (i == btn.tag) {//当轮询到当前选中按钮
                
                NSString *key = @"";
                NSString *value = @"";
                switch (pathIndex) {
                    case 6:
                        key = @"excessiveMedical";
                        break;
                    default:
                        break;
                }
                if (button.selected){//已经选中就返回
                    return;
                }else{ //未选中则继续 并致选中状态
                    button.selected = YES;
                }
                switch (i-100) {
                    case 0:
                        value = [titles_cell_treatment objectAtIndex:(i-100)];
                        break;
                    case 1:
                        value = [titles_cell_treatment objectAtIndex:(i-100)];
                        break;
                    case 2:
                        value = [titles_cell_treatment objectAtIndex:(i-100)];
                        break;
                    default:
                        break;
                        
                        
                }
                [evaluateDic setObject:value forKey:key];
            }else{
                button.selected = NO;
            }
        }
    }
}


- (void)saveClicked:(UIButton *)btn{
    NSLog(@"%d",btn.tag);
    btn.enabled =NO;
    @autoreleasepool {
        
        [evaluateDic setObject:docterName.text forKey:@"recommendDoctor"];
        [evaluateDic setObject:noteView.text forKey:@"suggest"];
        [evaluateDic setObject:nameText.text forKey:@"guestname"];
        [evaluateDic setObject:mailtext.text forKey:@"phone"];
        NSString*   access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        [evaluateDic setObject:access_token forKey:@"key"];
        
        NSDictionary *dict = [IKDataProvider customerSatisfaction:evaluateDic];  //接口解析错误  json数据可能存在特殊字符
        
        
        if (dict) {
            btn.enabled =YES;
            NSString *result = [dict objectForKey:@"result"];
            
            
            if (result && result.intValue==0) {
                [UIAlertView showAlertWithTitle:nil message:@"评价成功" cancelButton:nil];
            }else {
                NSString *errStr = [dict objectForKey:@"errStr"];
                
                if (errStr) {
                    [UIAlertView showAlertWithTitle:nil message:errStr cancelButton:nil];
                }
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // to update NoteView  更新iktextview上的线
    if ([scrollView isKindOfClass:[IKTextView class]]) {
        [scrollView setNeedsDisplay];
    }
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
