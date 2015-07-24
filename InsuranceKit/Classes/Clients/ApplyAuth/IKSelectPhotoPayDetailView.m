//
//  IKAddRecordsPhoto.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-3.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKSelectPhotoPayDetailView.h"
#import "IKAppDelegate.h"
#import "IKPhotoViewer.h"
#import "IKPhotoCDSO.h"
#import "IKApplyClaimsPhotoInformation.h"
#import "IKDecodeWithUTF8.h"
#import "IKImagePickerViewController.h"
@implementation IKSelectPhotoPayDetailView
@synthesize delegate,aryList,dicVisitInfo,otherVisitInfo,canEditPhoto,isPad;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        imgvBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKBGAddUser.png"]];
        imgvBG.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:imgvBG];
        imgvBG.userInteractionEnabled = YES;
        
        UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNext setBackgroundImage:[UIImage imageNamed:@"IKButtonYellow.png"] forState:UIControlStateNormal];
        [btnNext sizeToFit];
        [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnNext setTitle:LocalizeStringFromKey(@"kDone") forState:UIControlStateNormal];
        btnNext.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        btnNext.center = CGPointMake(642, 425);
        [imgvBG addSubview:btnNext];
        [btnNext addTarget:self action:@selector(finishClicked) forControlEvents:UIControlEventTouchUpInside];
        //        @[LocalizeStringFromKey(@"kShootingRecords"),
//        LocalizeStringFromKey(@"kShootingPayDetail"),
//        LocalizeStringFromKey(@"kShootingOther")];
            UILabel *titleLab =[[UILabel alloc] initWithFrame:CGRectMake(30, 20, imgvBG.frame.size.width-60, 20)];
            titleLab.text =LocalizeStringFromKey(@"kShootingPayDetail");
            [titleLab setFont:[UIFont systemFontOfSize:20.0]];
            [titleLab setTextColor:[UIColor colorWithRed:231.f/255.f green:107.f/255.f blue:35.f/255.f alpha:1]];
            [imgvBG addSubview:titleLab];
        
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(140, 140);
        layout.minimumInteritemSpacing = 30;
        layout.minimumLineSpacing = 30;
        
        aryList = [NSMutableArray array];
        canEditPhoto = YES;
        isPad = YES;
        cvList = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 50, imgvBG.frame.size.width-30*2, 342) collectionViewLayout:layout];
        [cvList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentifier"];
        cvList.backgroundColor = [UIColor clearColor];
        cvList.delegate = self;
        cvList.dataSource = self;
        [imgvBG addSubview:cvList];
        
    
    }
    return self;
}

- (void)finishClicked{
      [IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoPaymentArr = aryList;
    [self.delegate recordsAdded:aryList];
    
    [self dismiss];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
+ (id)view{
    IKSelectPhotoPayDetailView *v = [[IKSelectPhotoPayDetailView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    return v;
}

- (void)show{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    self.alpha = 0;
    [cvList reloadData];
    [w.rootViewController.view addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 1;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(imgvBG.frame, pt)){
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

-(BOOL)addPhotoYesOrNo{//0全部1收到理赔资料2补充病历3理赔处理中4已赔付
    if ( [self.status isEqualToString:@"理赔处理中"] ||[self.status isEqualToString:@"已赔付"]) {
        [SVProgressHUD showErrorWithStatus:LocalizeStringFromKey(@"kAddPhotoPrompt")];
        return NO;
    }
    return YES;
}
- (void)addPhotoClicked{
    
    if (![self addPhotoYesOrNo]) {
        return;
    }
    
    
    
    UICollectionViewCell *cell = [cvList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    UIActionSheet *as = nil;

     as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kAddphoto"),LocalizeStringFromKey(@"kSelectphotofromIPADalbum"), nil];
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    //        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kAddphoto"),LocalizeStringFromKey(@"kSelectphotofrompersonalalbum"),LocalizeStringFromKey(@"kSelectphotofromIPADalbum"), nil];
//    else
//        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kSelectphotofrompersonalalbum"), nil];

//    [as showFromRect:cell.frame inView:cell.superview animated:YES];
    [as showFromRect:CGRectMake(cell.frame.origin.x, cell.frame.origin.y+cell.frame.size.height, cell.frame.size.width, cell.frame.size.height) inView:cell.superview animated:YES];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



#pragma mark - UICollectionView Delegate & Data Source
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCellIdentifier" forIndexPath:indexPath];
    
    SWImageView *imgv = (SWImageView *)[cell.contentView viewWithTag:100];
    UIImageView *cover = (UIImageView *)[cell.contentView viewWithTag:101];
    if (!imgv){
        imgv = [[SWImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        imgv.tag = 100;
        [cell.contentView addSubview:imgv];
        
        cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        cover.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
        cover.tag = 101;
        cover.hidden = YES;
        [cell.contentView addSubview:cover];
        
    }
    

    
    if (isPad) {
        
    
    
    UIImage *img = 0==indexPath.row?[UIImage imageNamed:@"IKButtonAddPhoto.png"]:[[aryList objectAtIndex:indexPath.row-1] objectForKey:@"image"];
    
    if (img){
        float r = MIN(img.size.width, img.size.height);
        UIImage *cropped = indexPath.row==0?img:[img croppedImage:CGRectMake((img.size.width-r)/2, (img.size.height-r)/2, r, r)];
        [imgv setImage:cropped];
    }else{
        NSString *seqID = [[aryList objectAtIndex:indexPath.row-1] objectForKey:@"seqID"];
        img = [UIImage imageWithContentsOfFile:[seqID imageCachePath]];
        if (img)
            [imgv setImage:img];
        else
        {
            NSString *str = [[[aryList objectAtIndex:indexPath.row-1] objectForKey:@"imagePath"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSString *urlStr = [IKDecodeWithUTF8 getDecodeWithUTF8:str];
            
            [imgv loadURL:urlStr];
        }
//                  [imgv loadURL:[[[aryList objectAtIndex:indexPath.row-1] objectForKey:@"imagePath"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
        
    }
    }else{
        
        
            UIImage *img = 0==indexPath.row?[UIImage imageNamed:@"IKButtonAddPhoto.png"]:nil;
        if (img){
            float r = MIN(img.size.width, img.size.height);
            UIImage *cropped = indexPath.row==0?img:[img croppedImage:CGRectMake((img.size.width-r)/2, (img.size.height-r)/2, r, r)];
            [imgv setImage:cropped];
        }else{
              NSString *imagePathName = [aryList objectAtIndex:indexPath.row-1];
            
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:[[self imageCachePath:imagePathName] imageCachePath]]){
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imagePathName stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
                [data writeToFile:[[self imageCachePath:imagePathName] imageCachePath] atomically:NO];
            }
            
            
        img = [UIImage imageWithContentsOfFile:[[self imageCachePath:imagePathName] imageCachePath]];
            
            if (img)
                [imgv setImage:img];
            else{
              [imgv loadURL:[[aryList objectAtIndex:indexPath.row-1] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            }
        }
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return aryList.count+1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (0==indexPath.item){
        if (!canEditPhoto&&!isPad) {
             [UIAlertView showAlertWithTitle:nil message:@"无权限操作" cancelButton:nil];
             return;
        }
        [self addPhotoClicked];
    }
    else{
        UIActionSheet *as;
        if (isPad) {
            selectedPhotoInfo = [aryList objectAtIndex:indexPath.row-1];
            
            as = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:LocalizeStringFromKey(@"kCancel")
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:LocalizeStringFromKey(@"kViewLarge"),[selectedPhotoInfo objectForKey:@"imagePath"]?nil:LocalizeStringFromKey(@"kDelete"), nil];
        }else{
        
        
     NSString *str = [aryList objectAtIndex:indexPath.row-1];
            
            aryCacheImage = [self imageCachePath:str];
 
          as  = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:LocalizeStringFromKey(@"kCancel")
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:LocalizeStringFromKey(@"kViewLarge"), nil];
        
        
        
        
        
        }
    
        [as showInView:self];
    }
}


-(NSMutableString*)imageCachePath:(NSString*)str{
    NSMutableString *fileName = [NSMutableString string];
    if(str){
        NSArray *ary = [str componentsSeparatedByString:@"/"];
            [fileName appendString:[ary objectAtIndex:[ary count]-1]];
    }
    
    return fileName;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *cover = (UIImageView *)[cell.contentView viewWithTag:101];
    cover.hidden = NO;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *cover = (UIImageView *)[cell.contentView viewWithTag:101];
    cover.hidden = YES;
}


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kAddphoto")]){//拍照
        IKImagePickerViewController *picker = [[IKImagePickerViewController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.chageDirection =NO;
        UIViewController *vc = [UIView rootViewController];
        [vc presentViewController:picker animated:YES completion:^{
            picker.chageDirection =YES;
        }];
        
        
        
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kSelectphotofromIPADalbum")]){//从相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
        pcPhotoPicker = [[UIPopoverController alloc] initWithContentViewController:picker];
        UICollectionViewCell *cell = [cvList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [pcPhotoPicker presentPopoverFromRect:cell.frame   // did you forget to call this method?
                                       inView:cell.superview
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
    }
    
    else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kDelete")]){
        //  if uploaded,delete photo on server
        [aryList removeObject:selectedPhotoInfo];
        selectedPhotoInfo = nil;
        [cvList reloadData];
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kViewLarge")]){
        
        if (isPad) {
            UIImage *img = [UIImage imageWithContentsOfFile:[[selectedPhotoInfo objectForKey:@"seqID"] imageCachePath]];
            if (!img)
                img = [selectedPhotoInfo objectForKey:@"image"];
            [IKPhotoViewer showFullImage:img];
        }else{
        
            UIImage *img = [UIImage imageWithContentsOfFile:[aryCacheImage imageCachePath]];
            [IKPhotoViewer showFullImage:img];

        
        }
      
    }
    
}
//else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kSelectphotofrompersonalalbum")]){//从病历
//    NSMutableArray *mut = [NSMutableArray array];
//    for (NSDictionary *dict in aryList){
//        [mut addObject:[dict objectForKey:@"seqID"]];
//    }
//    
//    if (otherVisitInfo) {
//        [IKRecordSelector showWithVisitInfo:otherVisitInfo delegate:self selected:mut];
//        
//    }else{
//        if (self.visit)
//            [IKRecordSelector showWithVisit:self.visit delegate:self selected:mut];
//        else
//            [IKRecordSelector showWithVisitInfo:self.dicVisitInfo delegate:self selected:mut];
//    }
//}
#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Picked:%@",info);
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGSize size = img.size;
    float ratio = size.width/size.height;
    
    float w,h;
    if (ratio>1024.0f/768.0f){
        w = 1024;
        h = w/ratio;
    }else{
        h = 768;
        w = h*ratio;
    }
    
    size = CGSizeMake(w, h);
    
    
    img = [img resizedGrayscaleImage:size];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    NSDate *date = [NSDate date];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *seqID ;
    if (otherVisitInfo) {
        seqID = [NSString stringWithFormat:@"%@%@%@",[otherVisitInfo objectForKey:@"providerID"],[otherVisitInfo objectForKey:@"memberID"],dateString];
    }
    else{
        
        seqID = [NSString stringWithFormat:@"%@%@%@",self.visit?self.visit.providerID:[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"],self.visit?self.visit.memberID:[dicVisitInfo objectForKey:@"memberID"],dateString];
    }
     int sub =[self getSub];
    if (sub >= 10) {
        [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPhotoLoadCount") cancelButton:nil];
        
        //        [cvList reloadData];
        
        
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [pcPhotoPicker dismissPopoverAnimated:YES];
        }
        
        [picker dismissViewControllerAnimated:YES completion:NULL];
        picker = nil;
        
        return;
    }else{
        
//        [aryList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"date",img,@"image",seqID,@"seqID", nil]];
        NSString *type = [NSString stringWithFormat:@"%d",IKPhotoTypeClaimClaimsPaymentList];
        [aryList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"date",img,@"image",seqID,@"seqID",type,@"type", nil]];
        [UIImagePNGRepresentation(img) writeToFile:[seqID imageCachePath] atomically:NO];
        
        [cvList reloadData];

        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [pcPhotoPicker dismissPopoverAnimated:YES];
        }
        [picker dismissViewControllerAnimated:YES completion:NULL];
        picker = nil;
        
    }
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    picker = nil;
}

#pragma mark - UIPopOverDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    pcPhotoPicker = nil;
}

#pragma mark - IKRecordSelector Delegate
- (void)recordPhotoSelected:(NSArray *)photos{
    for (NSDictionary *info in photos){
        BOOL bFinded = NO;
        for (NSDictionary *infoAlready in aryList){
            if ([[info objectForKey:@"seqID"] isEqualToString:[infoAlready objectForKey:@"seqID"]]){
                bFinded = YES;
                break;
            }
        }
        if (!bFinded){
              int sub =[self getSub];
            if (sub >= 10) {
                [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kPhotoLoadCount") cancelButton:nil];
                return;
            }
            else{
                [aryList addObject:info];
                [cvList reloadData];
            }
        }
    }
}
-(int)getSub{
    
    int photoCarCount = [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoCardArr count];
    int photoOtherCount = [[IKApplyClaimsPhotoInformation sharedApplyClaimsPhotoInformation].photoOtherArr count];
    int photoPaymentCount = [aryList count];
    int sub =photoCarCount+photoOtherCount+photoPaymentCount;
    return sub;
}

@end
