 //
//  IKClientsDetailViewController.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKClientsDetailViewController.h"
#import "IKClientsInfoView.h"
#import "IKClientsPaymentView.h"
#import "IKClientsLogView.h"
#import "IKClientsAuthorizationView.h"
#import "IKAddClientView.h"
#import "IKPhotoCDSO.h"
#import "IKPhotoViewer.h"
#import "IKPEnoteViewController.h"
#import "IKClientsClaimsView.h"

#define IKVISITINFO_FONT 14

@interface IKClientsDetailViewController ()

@end

@implementation IKClientsDetailViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    float width = 1024-42-278;
    NSDictionary *dicInfo = visit.detailInfo;
    
    self.view.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.97 alpha:1];
    
//    imgvGender = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconGenderMale.png"]];
//    imgvGender.frame = CGRectMake(0, 0, 40, 40);
//    imgvGender.center = CGPointMake(413, 95);
//    [self.view addSubview:imgvGender];
    
    float x = 33,y =33;
    
    float w = 30;
    NSString *language = [InternationalControl userLanguage];
    if ([language isEqualToString:@"en"])
        w = 100;
    lblName = [UILabel createLabelWithFrame:CGRectMake(x, y, 400, 20) font:[UIFont boldSystemFontOfSize:17] textColor:[UIColor blackColor]];
    [self.view addSubview:lblName];
    lblName.text = [dicInfo objectForKey:@"name"];

    UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(x, y+32, w, 13) font:[UIFont systemFontOfSize:IKVISITINFO_FONT] textColor:[UIColor colorWithWhite:.85 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"kBirthday");
    [self.view addSubview:lbl];
    
    lbl = [UILabel createLabelWithFrame:CGRectMake(x, y+32+22, w, 13) font:[UIFont systemFontOfSize:IKVISITINFO_FONT] textColor:[UIColor colorWithWhite:.85 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"kNationality");
    [self.view addSubview:lbl];
    
    lbl = [UILabel createLabelWithFrame:CGRectMake(x, y+32+22+24, w, 13) font:[UIFont systemFontOfSize:IKVISITINFO_FONT] textColor:[UIColor colorWithWhite:.85 alpha:1]];
    lbl.text = LocalizeStringFromKey(@"kCertificateNumber");
    [self.view addSubview:lbl];
    
    lblPEnotes = [UILabel createLabelWithFrame:CGRectMake(x, 150, 515, 30) font:[UIFont systemFontOfSize:17] textColor:[UIColor redColor]];
    
    lblPEnotes.text = [dicInfo objectForKey:@"peNotes"];
 
    [self.view addSubview:lblPEnotes];
    

    
    x = x + w + 8;
    lblBirthday = [UILabel createLabelWithFrame:CGRectMake(x, y+32, 150, 13) font:[UIFont boldSystemFontOfSize:IKVISITINFO_FONT] textColor:[UIColor colorWithWhite:.52 alpha:1]];
    lblBirthday.text = [dicInfo objectForKey:@"birthday"];
    [self.view addSubview:lblBirthday];
    
    lblNation = [UILabel createLabelWithFrame:CGRectMake(x, y+31+22, 150, 13) font:[UIFont boldSystemFontOfSize:IKVISITINFO_FONT] textColor:[UIColor colorWithWhite:.52 alpha:1]];
    [self.view addSubview:lblNation];
    
    lblID = [UILabel createLabelWithFrame:CGRectMake(x, y+30 +22+24, 196, 30) font:[UIFont boldSystemFontOfSize:IKVISITINFO_FONT] textColor:[UIColor colorWithWhite:.52 alpha:1]];
    lblID.numberOfLines = 2;
    lblID.text = [dicInfo objectForKey:@"ID"];
  //  CGSize size = [lblID.text sizeWithFont:lblID.font constrainedToSize:CGSizeMake(lblID.frame.size.width, 1000)];
    CGSize size = [lblID.text boundingRectWithSize:CGSizeMake(lblID.frame.size.width, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes: @{NSFontAttributeName: [UIFont boldSystemFontOfSize:IKVISITINFO_FONT]} context:nil].size;
    CGRect frame = lblID.frame;
    frame.size = size;
    lblID.frame = frame;
    [self.view addSubview:lblID];
    
    
//    btnSign = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnSign.frame = CGRectMake(0, 0, 87, 87);
//    [btnSign setBackgroundImage:[UIImage imageNamed:@"IKIconSign.png"] forState:UIControlStateNormal];
//    btnSign.center = CGPointMake(84, 80);
//    [self.view addSubview:btnSign];
//    [btnSign addTarget:self action:@selector(signClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    lbl = [UILabel createLabelWithFrame:CGRectZero font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithWhite:.52 alpha:1]];
//    lbl.text = @"签名";
//    [lbl sizeToFit];
//    lbl.center = CGPointMake(84, 140);
//    [self.view addSubview:lbl];
    
    
    btnIDCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnIDCard setBackgroundImage:[UIImage imageNamed:@"IKCoverCard.png"] forState:UIControlStateNormal];
    [btnIDCard sizeToFit];
    btnIDCard.layer.cornerRadius = 5;
    btnIDCard.layer.masksToBounds = YES;
    [btnIDCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnIDCard.center = CGPointMake(610, 75);
    btnIDCard.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 17, 1);
    btnIDCard.titleLabel.font = [UIFont systemFontOfSize:13];
    btnIDCard.titleLabel.textAlignment = NSTextAlignmentCenter;
    btnIDCard.titleEdgeInsets = UIEdgeInsetsMake(61, 0, 0, 0);
    [self.view addSubview:btnIDCard];
    [btnIDCard addTarget:self action:@selector(idcardClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *idCardLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 79-18, 83, 18)];
    idCardLab.font = [UIFont systemFontOfSize:13];
    idCardLab.textAlignment = NSTextAlignmentCenter;
    idCardLab.textColor = [UIColor whiteColor];
    idCardLab.text = LocalizeStringFromKey(@"kPhotoID");
    [btnIDCard addSubview:idCardLab];
    
    
//    btnInsuranceCard = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnInsuranceCard setBackgroundImage:[UIImage imageNamed:@"IKCoverCard.png"] forState:UIControlStateNormal];
//    [btnInsuranceCard sizeToFit];
//    btnInsuranceCard.layer.cornerRadius = 5;
//    btnInsuranceCard.layer.masksToBounds = YES;
//    [btnInsuranceCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnInsuranceCard.center = CGPointMake(610, 75);
//    btnInsuranceCard.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 17, 1);
//    btnInsuranceCard.titleLabel.font = [UIFont systemFontOfSize:13];
//    btnInsuranceCard.titleLabel.textAlignment = NSTextAlignmentCenter;
//    btnInsuranceCard.titleEdgeInsets = UIEdgeInsetsMake(61, 0, 0, 0);
//    [btnInsuranceCard bringSubviewToFront:btnInsuranceCard.titleLabel];
//    [self.view addSubview:btnInsuranceCard];
//    [btnInsuranceCard addTarget:self action:@selector(insurancecardClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    UILabel *idInsuranceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 79-18, 83, 18)];
//    idInsuranceLab.font = [UIFont systemFontOfSize:13];
//    idInsuranceLab.textAlignment = NSTextAlignmentCenter;
//    idInsuranceLab.textColor = [UIColor whiteColor];
//    idInsuranceLab.text = @"保险卡";
//    [btnInsuranceCard addSubview:idInsuranceLab];
    
    


    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 233, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.91 alpha:1];
    [self.view addSubview:line];
    

    
//    lbl = [UILabel createLabelWithFrame:CGRectMake(325, 0, 70, 55) font:[UIFont boldSystemFontOfSize:12] textColor:[UIColor blackColor]];
//    lbl.text = @"证件影像";
//    [self.view addSubview:lbl];
//    
//    lbl = [UILabel createLabelWithFrame:CGRectMake(18, 12, 160, 13) font:[UIFont boldSystemFontOfSize:12] textColor:[UIColor blackColor]];
//    lbl.text = @"保险卡有效期：";
//    [self.view addSubview:lbl];
//    
//    lblDuration = [UILabel createLabelWithFrame:CGRectMake(18, 33, 160, 14) font:[UIFont boldSystemFontOfSize:13] textColor:[UIColor blackColor]];
//    [self.view addSubview:lblDuration];
//    lblDuration.text = [dicInfo objectForKey:@"duration"];
    
    
    //  顶部选择区域
    vSelectionBG = [[UIView alloc] initWithFrame:CGRectMake(0, 191, width, 42)];
//    vSelectionBG.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
//    vSelectionBG.layer.shadowOpacity = .3f;
//    vSelectionBG.layer.shadowOffset = CGSizeMake(0, 0);
//    vSelectionBG.layer.shadowRadius = 2;
    [self.view addSubview:vSelectionBG];
    w = vSelectionBG.frame.size.width/4;
   // NSArray *titles = [@"保险信息查询，收取自付额，申请理赔，申请授权" componentsSeparatedByString:@"，"];
    NSArray *titles =@[LocalizeStringFromKey(@"kPolicy"),
                       LocalizeStringFromKey(@"kCalculateCo-payment"),
                       LocalizeStringFromKey(@"kClaim"),
                       LocalizeStringFromKey(@"kPre-Authorization")];
    for (int i=0;i<4;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w*i, 0, w, 42);
        [btn setTitleColor:[UIColor colorWithWhite:.59 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:.15 alpha:1] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [vSelectionBG addSubview:btn];
        [btn addTarget:self action:@selector(typeClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        
        if (0==i)
            btn.selected = YES;
    }
    UIView *rect = [[UIView alloc] initWithFrame:CGRectMake(w/2-111/2, 40, 111, 2)];
    rect.backgroundColor = [UIColor colorWithRed:0 green:.59 blue:.96 alpha:1];
    [vSelectionBG addSubview:rect];
    rect.tag = 200;
    
    vContent = [[UIView alloc] initWithFrame:CGRectMake(0, 234, width, 768-234-20)];
    vContent.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.97 alpha:1];
    [self.view insertSubview:vContent belowSubview:vSelectionBG];
    
    
    aryContentViews = [NSMutableArray array];
    for (int i=0;i<4;i++)
        [aryContentViews addObject:[NSNull null]];
    
    [self showType:0];
    
    [self showInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfo) name:@"RefreshIDCardPhoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIDCardPhoto:) name:@"IDCardChanged" object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideDutyView" object:nil];
}

- (void)updateIDCardPhoto:(NSNotification *)notice{
    if ([self.visit.visitID isEqualToString:[(IKVisitCDSO *)notice.object visitID]]){
        if (visit.idphotoList.count>0){
            IKPhotoCDSO *photo = [visit.idphotoList objectAtIndex:0];
//            UIImage *img = photo.image;
            UIImage *img = [self judgePhotoSize:photo.image];
            [btnIDCard setImage:img forState:UIControlStateNormal];
        }else{
            [btnIDCard setImage:nil forState:UIControlStateNormal];
        }
        
        
        
        if (visit.insurancephotoList.count>0){
            IKPhotoCDSO *photo = [visit.insurancephotoList objectAtIndex:0];
            UIImage *img = photo.image;
            [btnInsuranceCard setImage:img forState:UIControlStateNormal];
        }else{
            [btnInsuranceCard setImage:nil forState:UIControlStateNormal];
        }
        
        
    }
}

- (void)showInfo{
    self.view.userInteractionEnabled = visit!=nil;
    
    NSDictionary *dicInfo = visit.detailInfo;
    
    lblName.text = [dicInfo objectForKey:@"memberName"];
    lblBirthday.text = [dicInfo objectForKey:@"birthdate"];
    lblGender.text = [dicInfo objectForKey:@"gender"];
    lblID.text = visit?[NSString stringWithFormat:@"%@%@",visit.memberID,visit.depID.length>0?[@"-" stringByAppendingString:visit.depID]:@""]:nil;
    lblDuration.text = [dicInfo objectForKey:@"duration"];
    lblNation.text = [dicInfo objectForKey:@"nationality"];
    
    lblPEnotes.text = [dicInfo objectForKey:@"peNotes"];

    
       peSize = [lblPEnotes.text boundingRectWithSize:CGSizeMake(lblPEnotes.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes: @{NSFontAttributeName:lblPEnotes.font} context:nil].size;
    
    
    
    if (peSize.height/21 > 1) {
        
        btnPEnotes = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPEnotes.frame = CGRectMake(33+515, 150, 120, 30);
        [btnPEnotes setTitle:LocalizeStringFromKey(@"kAllPatients") forState:UIControlStateNormal];
        [btnPEnotes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnPEnotes setImage:[UIImage imageNamed:@"IKPENotesAlert.png"] forState:UIControlStateNormal];
        btnPEnotes.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0,0 );
        btnPEnotes.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        btnPEnotes.backgroundColor = [UIColor clearColor];
        [btnPEnotes setTitleColor:[UIColor colorWithRed:32.0/255.f green:144.0/255.f blue:248.0/255.f alpha:1] forState:UIControlStateNormal];
        btnPEnotes.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:btnPEnotes];
        [btnPEnotes addTarget:self action:@selector(peNoteClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }


    
    
    if (visit.idphotoList.count>0){
        IKPhotoCDSO *photo = [visit.idphotoList objectAtIndex:0];
//        UIImage *img = photo.image;
        UIImage *img = [self judgePhotoSize:photo.image];
        [btnIDCard setImage:img forState:UIControlStateNormal];
    }else{
        [btnIDCard setImage:nil forState:UIControlStateNormal];
    }
    
    
    if (visit.insurancephotoList.count>0){
        IKPhotoCDSO *photo = [visit.insurancephotoList objectAtIndex:0];
        UIImage *img = photo.image;

        [btnInsuranceCard setImage:img forState:UIControlStateNormal];
    }else{
        [btnInsuranceCard setImage:nil forState:UIControlStateNormal];
    }
    
    CGSize size =  [lblID.text boundingRectWithSize:CGSizeMake(lblID.frame.size.width, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes: @{NSFontAttributeName: [UIFont boldSystemFontOfSize:IKVISITINFO_FONT]} context:nil].size;
    CGRect frame = lblID.frame;
    frame.size = size;
    lblID.frame = frame;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)signClicked{
//    if (visit.signatureImage){
//        [IKPhotoViewer showSignPhoto:self.visit];
//    }else
//        [IKAddClientView showAddSignatureOfVisit:visit];
//}


-(void)peNoteClicked:(UIButton*)btn{

    IKPEnoteViewController *peVC = [[IKPEnoteViewController alloc] init];
    peVC.penoteLab.text = lblPEnotes.text;
   
//    NSString *str =peVC.penoteLab.text;
//   CGFloat height =[str boundingRectWithSize:CGSizeMake(peVC.penoteLab.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
//    CGRect rect =peVC.penoteLab.frame;
//    rect.size.height =height+20;
//    peVC.penoteLab.frame =rect;
    
    peNoteVC = [[UIPopoverController alloc] initWithContentViewController:peVC];
//    peNoteVC.popoverContentSize =CGSizeMake(415 , 200);
    [peNoteVC presentPopoverFromRect:lblPEnotes.frame inView:lblPEnotes.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    NSLog(@"");
}

- (void)insurancecardClicked{

    [IKPhotoViewer showInsuranceCardPhoto:self.visit];

}

- (void)idcardClicked{
    [IKPhotoViewer showIDCardPhoto:self.visit];
}

- (void)typeClicked:(UIButton *)btn{
    
    BOOL isDirectbilling  = [[self.visit.detailInfo objectForKey:@"directbilling"] intValue] == 1?YES:NO;
  
    if (btn.tag%100==1 && !isDirectbilling){
        [UIAlertView showAlertWithTitle:nil message:@"该客户不能直付，应收取全额费用" cancelButton:nil];
        
        return;
    }
    
    if (btn.tag%100==1 && ![IKDataProvider canEditPayment]){
        [UIAlertView showAlertWithTitle:nil message:@"您没有权限进行此项操作" cancelButton:nil];
        
        return;
    }
    UIView *sv = btn.superview;
    UIView *rect = [sv viewWithTag:200];
    for (int i=0;i<4;i++){
        UIButton *button = (UIButton *)[sv viewWithTag:100+i];
        button.selected = btn.tag==100+i;
        if (button.selected){
            rect.center = CGPointMake(button.center.x, rect.center.y);
        }
    }
    
    [self showType:btn.tag-100];
}

- (void)showType:(NSInteger)type{
    NSArray *classes = [@"Info,Payment,Claims,Authorization" componentsSeparatedByString:@","];
    Class IKV = NSClassFromString([NSString stringWithFormat:@"IKClients%@View",[classes objectAtIndex:type]]);
    
    
    if ([[aryContentViews objectAtIndex:type] isKindOfClass:[NSNull class]]){
        id v = [[IKV alloc] initWithFrame:vContent.bounds];
        if (self.visit) {
            ((IKView *)v).visit = self.visit;
        }
        [vContent addSubview:(UIView *)v];
        [aryContentViews replaceObjectAtIndex:type withObject:v];
    }else{
        UIView *v = (UIView *)[aryContentViews objectAtIndex:type];
        [vContent addSubview:v];
    }
    
    for (int i=0;i<4;i++){
        UIView *v = [aryContentViews objectAtIndex:i];
        if (![v isKindOfClass:[NSNull class]] && i!=type)
            [v removeFromSuperview];
    }
}

- (UIImage *)judgePhotoSize:(UIImage *)image{
    UIImage *finnanyImage ;
    if (image.size.width >1024 ||image.size.height >765) {
        finnanyImage= [self scaleToSize:image size:CGSizeMake(1024, 765)];
    }else{
        finnanyImage =image;
    }
    return finnanyImage;
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

@end
