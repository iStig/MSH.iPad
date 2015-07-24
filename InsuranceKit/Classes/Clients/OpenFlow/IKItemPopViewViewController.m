//
//  IKItemPopViewViewController.m
//  InsuranceKit
//
//  Created by iStig on 14-10-8.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKItemPopViewViewController.h"

@interface IKItemPopViewViewController ()

@end

@implementation IKItemPopViewViewController
@synthesize base_value,significant_value,correctional_value,prevent_value,title_Values,selectIndex;
- (id)init{
    self = [super init];
    if (self){
        self.preferredContentSize = CGSizeMake(420, 95);
        
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 95)];
        contentV.backgroundColor = [UIColor clearColor];
        [self.view addSubview:contentV];
        
        title_Values = [[NSArray alloc] init];
        
        float x = 62;
        
//       NSArray* aryTitles = [@"基础治疗,预防治疗,重大治疗,矫正治疗" componentsSeparatedByString:@","];

        NSArray* aryTitles = @[LocalizeStringFromKey(@"kBasic"),LocalizeStringFromKey(@"kPreventative"),LocalizeStringFromKey(@"kMajor"),LocalizeStringFromKey(@"kOrthodontics")];
        
      
        
        
        for (int i=0;i<4;i++){
            int row = i/2;
            int col = i%2;
            
            float distance = 10;
            
            NSString *text = [aryTitles objectAtIndex:i];
            CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName, nil]];
            CGSize imgSize = [[UIImage imageNamed:@"IKIconCircleCheckNO.png"] size];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(100+140*col, 15+40*row,60, 30);
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor: [UIColor colorWithRed:144.f/255.f green:141.f/255.f blue:143.f/255.f alpha:1] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"IKIconCircleCheckNO.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"IKIconCircleCheckYES.png"] forState:UIControlStateSelected];
            [btn setTitle:text forState:UIControlStateNormal];
//            [btn setBackgroundColor:[UIColor redColor]];
            btn.imageEdgeInsets = UIEdgeInsetsMake((btn.frame.size.height-imgSize.height)/2, 0, (btn.frame.size.height-imgSize.height)/2, btn.frame.size.width-imgSize.width);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, distance, 0, btn.frame.size.width-imgSize.width-distance-size.width);
            
            btn.tag = 200+i+1;
            [btn addTarget:self action:@selector(methodClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:btn];
        }
        

        UILabel *pay_percent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        pay_percent.text = LocalizeStringFromKey(@"kDentalCo-pay");
        pay_percent.textColor = [UIColor colorWithRed:144.f/255.f green:141.f/255.f blue:143.f/255.f alpha:1];
        pay_percent.backgroundColor = [UIColor clearColor];
        pay_percent.center = CGPointMake(x,95/2);
        pay_percent.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:pay_percent];
        
        
        base_value = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        base_value.text = @"0%";
        base_value.textAlignment = NSTextAlignmentLeft;
        base_value.textColor = [UIColor colorWithRed:144.f/255.f green:141.f/255.f blue:143.f/255.f alpha:1];
        base_value.backgroundColor = [UIColor clearColor];
        base_value.center = CGPointMake(x + 109 + 60,30);
        base_value.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:base_value];
        
        prevent_value = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        prevent_value.text = @"0%";
//        [prevent_value setBackgroundColor:[UIColor orangeColor]];
        prevent_value.textAlignment = NSTextAlignmentRight;
        prevent_value.textColor = [UIColor colorWithRed:144.f/255.f green:141.f/255.f blue:143.f/255.f alpha:1];
        prevent_value.backgroundColor = [UIColor clearColor];
        prevent_value.center = CGPointMake(x +109+160 + 60,30);
        prevent_value.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:prevent_value];
        
        
        
        significant_value = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        significant_value.text = @"0%";
        significant_value.textAlignment = NSTextAlignmentLeft;
        significant_value.textColor = [UIColor colorWithRed:144.f/255.f green:141.f/255.f blue:143.f/255.f alpha:1];
        significant_value.backgroundColor = [UIColor clearColor];
        significant_value.center = CGPointMake(x +109 + 60,68);
        significant_value.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:significant_value];
        
        
        correctional_value = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        correctional_value.text = @"0%";
        correctional_value.textAlignment = NSTextAlignmentRight;
        correctional_value.textColor = [UIColor colorWithRed:144.f/255.f green:141.f/255.f blue:143.f/255.f alpha:1];
        correctional_value.backgroundColor = [UIColor clearColor];
        correctional_value.center = CGPointMake(x + 109+160 + 60,68);
        correctional_value.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:correctional_value];
        
        

        
     
        
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

-(void)setSelectIndex:(NSInteger)index{


    if (index == 0)
        return;
    
    for (id btn in self.view.subviews) {
        if ( [btn isKindOfClass:[UIButton class]]) {
            UIButton *Btn = (UIButton*)btn;
            Btn.selected = (Btn.tag -200 == index);
         
            
        }
  
    }
    



}

-(void)setTitle_Values:(NSArray *)title{

    title_Values =title;
    base_value.text = [title_Values objectAtIndex:0];
    prevent_value.text = [title_Values objectAtIndex:1];
        significant_value.text = [title_Values objectAtIndex:2];
    correctional_value.text = [title_Values objectAtIndex:3];



}

- (void)methodClicked:(UIButton *)btn{
    int index = (int)btn.tag%10;
    NSArray *categories = [@"1,2,3,4" componentsSeparatedByString:@","];
    for (int i=1;i<=categories.count;i++){
        UIButton *b = (UIButton *)[self.view viewWithTag:200+i];
        b.selected = i==index;
    }
    
    [self.delegate itemSelectAtIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
