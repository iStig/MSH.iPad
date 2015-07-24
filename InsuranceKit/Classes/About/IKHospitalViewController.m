//
//  IKHospitalViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-9-19.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKHospitalViewController.h"

@interface IKHospitalViewController ()

@end

@implementation IKHospitalViewController

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
    
    titleAry = @[@"   a.我们的医院代表的服务质量如何？",@"   b.本季度，我们的医院代表是否按照工作时间准时到岗？",@"   c.对于医院/客户的问题，我们的医院代表能否及时答复",@"   d.我们的医院代表能否配合医院工作？",@"2.我们的24小时电话服务热线能否及时接通？",@"3.我们的24小时电话客服人员能否及时解决您的疑问？",@"4.我们指定的网络医院联系人有与您定期沟通吗？",@"5.我们的财务部在付款后，有及时通知你们吗？",@"6.对于服务质量的进一步提高，您的建议是："];
    
    titles_cell_normal = @[LocalizeStringFromKey(@"kExcellent"),
                           LocalizeStringFromKey(@"kGood"),
                           LocalizeStringFromKey(@"kNormal"),
                           LocalizeStringFromKey(@"kBad")];
    
    titles_cell_delay = @[@"完全准时",@"有迟到",@"有无故缺席"];
    titles_cell_communite = @[@"每两周",@"每个月",@"每个季度",@"从不"];
    evaluateDic = [NSMutableDictionary dictionary];
    
    
    [evaluateDic setObject:@"" forKey:@"service"];
    [evaluateDic setObject:@"" forKey:@"workTime"];
    [evaluateDic setObject:@"" forKey:@"reply"];
    [evaluateDic setObject:@"" forKey:@"cooperate"];
    
    [evaluateDic setObject:LocalizeStringFromKey(@"kExcellent")  forKey:@"hoteline"];
    [evaluateDic setObject:LocalizeStringFromKey(@"kExcellent")  forKey:@"handle"];
    
    [evaluateDic setObject:@"每两周" forKey:@"communicate"];
    
    [evaluateDic setObject:LocalizeStringFromKey(@"kExcellent") forKey:@"payment"];
    
    [evaluateDic setObject:@"" forKey:@"suggest"];
    
    
    [self addBGColor:[UIColor colorWithRed:.98 green:.96 blue:.96 alpha:1]];
    
    tvList = [[UITableView alloc] initWithFrame:CGRectZero];
    [tvList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HospitalInfo"];
    tvList.delegate = self;
    tvList.dataSource = self;
    tvList.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvList.showsVerticalScrollIndicator = NO;
    tvList.backgroundColor = self.view.backgroundColor;
    
    
    [self.view addSubview:tvList];
}


- (void)viewWillLayoutSubviews{
    tvList.frame = CGRectMake(20, 10, self.view.frame.size.width-20*2, self.view.frame.size.height-10);
}



#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier0 = @"identifier0";
    static NSString *identifier1 = @"identifier1";
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
    
    
    if (indexPath.row == 2||indexPath.row == 3||indexPath.row == 4||indexPath.row == 5||indexPath.row == 7) {
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
                if (indexPath.row == 4||indexPath.row == 5||indexPath.row == 7) {
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
    
    if (indexPath.row == 1) {
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
                btn.frame = CGRectMake(10 +i*(22 + 10 +75 +25+10 ), 36, 22, 22);
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_selected"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_unselected"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(mainClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 100+i;
                
                [cell.contentView addSubview:btn];
                
                UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(btn.frame.origin.x +22+10 , 36, 75+25+10 , 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
                lblTitle.textAlignment = NSTextAlignmentLeft;
                lblTitle.tag = 200+i;
                [cell.contentView addSubview:lblTitle];
            }
        }
        
        UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:90];
        lblTitle.text =[titleAry objectAtIndex:indexPath.row];
        for (int i = 0; i <3; i++) {
            UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:i+200];
            lblTitle.text =[titles_cell_delay objectAtIndex:i];
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
            
            for (int i = 0; i < 4; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10 +i*(22 + 10 +75 +25 ), 36, 22, 22);
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_selected"] forState:UIControlStateSelected];
                [btn setBackgroundImage:[UIImage imageNamed:@"evaluate_unselected"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(mainClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 100+i;
                btn.selected = i==0?YES:NO;
                
                [cell.contentView addSubview:btn];
                
                UILabel *lblTitle = [UILabel createLabelWithFrame:CGRectMake(btn.frame.origin.x +22+10 , 36, 75+25 , 24) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor colorWithWhite:.67 alpha:1]];
                lblTitle.textAlignment = NSTextAlignmentLeft;
                lblTitle.tag = 200+i;
                [cell.contentView addSubview:lblTitle];
            }
        }
        
        UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:90];
        lblTitle.text =[titleAry objectAtIndex:indexPath.row];
        for (int i = 0; i <4; i++) {
            UILabel *lblTitle = (UILabel*)[cell.contentView viewWithTag:i+200];
            lblTitle.text =[titles_cell_communite objectAtIndex:i];
        }
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
    if (indexPath.row == 8) {
        return 170;
    }
    return 80;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
   
    int pathIndex = [tvList indexPathForCell:cell].row;
    
    
    
    
    //indexpath ＝ 0 2 3 4 5 7
    if (pathIndex == 0||pathIndex == 2||pathIndex == 3||pathIndex == 4 ||pathIndex == 5||pathIndex == 7) {
        
        for (int i =100; i<104; i++) {
            UIButton *button = (UIButton*)[cell viewWithTag:i];
            
            
            if (i == btn.tag) {//当轮询到当前选中按钮
                
                NSString *key = @"";
                NSString *value = @"";
                switch (pathIndex) {
                    case 0:
                        key = @"service";
                        break;
                    case 2:
                        key = @"reply";
                        break;
                    case 3:
                        key = @"cooperate";
                        break;
                    case 4:
                        key = @"hoteline";
                        break;
                        
                    case 5:
                        key = @"handle";
                        break;
                        
                    case 7:
                        key = @"payment";
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
    
    
    //indexpath ＝ 6
    if (pathIndex == 6) {
        
        for (int i =100; i<104; i++) {
            UIButton *button = (UIButton*)[cell viewWithTag:i];
            
            
            if (i == btn.tag) {//当轮询到当前选中按钮
                
                NSString *key = @"";
                NSString *value = @"";
                switch (pathIndex) {
                    case 6:
                        key = @"communicate";
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
                        value = [titles_cell_communite objectAtIndex:(i-100)];
                        break;
                    case 1:
                        value = [titles_cell_communite objectAtIndex:(i-100)];
                        break;
                    case 2:
                        value = [titles_cell_communite objectAtIndex:(i-100)];
                        break;
                    case 3:
                        value = [titles_cell_communite objectAtIndex:(i-100)];
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
    
    
    //indexpath ＝ 1
    if (pathIndex == 1) {
        
        for (int i =100; i<103; i++) {
            UIButton *button = (UIButton*)[cell viewWithTag:i];
            
            if (i == btn.tag) {//当轮询到当前选中按钮
                
                NSString *key = @"";
                NSString *value = @"";
                switch (pathIndex) {
                    case 1:
                        key = @"workTime";
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
                        value = [titles_cell_delay objectAtIndex:(i-100)];
                        break;
                    case 1:
                        value = [titles_cell_delay objectAtIndex:(i-100)];
                        break;
                    case 2:
                        value = [titles_cell_delay objectAtIndex:(i-100)];
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
        [evaluateDic setObject:noteView.text forKey:@"suggest"];
        NSString*   access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        
        [evaluateDic setObject:access_token forKey:@"key"];
        
        NSLog(@"%@",evaluateDic);
        
        
        NSDictionary *dict = [IKDataProvider hospitalSatisfaction:evaluateDic];//接口解析错误  json数据可能存在特殊字符
        
        
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
    // to update NoteView
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
