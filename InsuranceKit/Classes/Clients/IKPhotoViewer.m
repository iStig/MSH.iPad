//
//  IKPhotoViewer.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-5.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKPhotoViewer.h"
#import "IKAppDelegate.h"
#import "IKPhotoCDSO.h"
#import "IKImagePickerViewController.h"
@implementation IKPhotoViewer
@synthesize aryList,vcParent,visit,photos,uploadNotPhotoAry;

- (id)initWithFrame:(CGRect)frame visit:(IKVisitCDSO *)vis type:(int)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.visit = vis;
        viewerType = type;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        switch (viewerType) {
            case IKPhotoViewerTypeIDCard:{
                imgvBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKBGAddUser.png"]];
                imgvBG.center = CGPointMake(frame.size.width/2, frame.size.height/2);
                [self addSubview:imgvBG];
                imgvBG.userInteractionEnabled = YES;
                
                UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnNext setBackgroundImage:[UIImage imageNamed:@"IKButtonYellow.png"] forState:UIControlStateNormal];
                [btnNext sizeToFit];
                [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnNext setTitle:LocalizeStringFromKey(@"kDone")  forState:UIControlStateNormal];
                btnNext.titleLabel.font = [UIFont boldSystemFontOfSize:20];
                btnNext.center = CGPointMake(642, 425);
                [imgvBG addSubview:btnNext];
                [btnNext addTarget:self action:@selector(finishClicked) forControlEvents:UIControlEventTouchUpInside];
                
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.itemSize = CGSizeMake(140, 140);
                layout.minimumInteritemSpacing = 30;
                layout.minimumLineSpacing = 30;
                
                aryList = [NSMutableArray array];
                photos = [NSMutableArray array];
                uploadNotPhotoAry =[NSMutableArray array];
                cvList = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 30, imgvBG.frame.size.width-30*2, 342) collectionViewLayout:layout];
                [cvList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentifier"];
                cvList.backgroundColor = [UIColor clearColor];
                cvList.delegate = self;
                cvList.dataSource = self;
                [imgvBG addSubview:cvList];
            }
                break;
            case IKPhotoViewerTypeSign:{
                imgvBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKBGAddUser.png"]];
                imgvBG.center = CGPointMake(frame.size.width/2, frame.size.height/2);
                [self addSubview:imgvBG];
                imgvBG.userInteractionEnabled = YES;
                

                
                imgvPhoto = [[UIImageView alloc] initWithFrame:imgvBG.bounds];
                [imgvPhoto setImage:self.visit.signatureImage];
//                imgvPhoto.center = CGPointMake(imgvBG.frame.size.width/2, imgvBG.frame.size.height/2);
                [imgvBG addSubview:imgvPhoto];
            }
                break;
            case IKPhotoViewerTypeFullscreen:{
                imgvPhoto = [[UIImageView alloc] initWithImage:self.visit.signatureImage];
                imgvPhoto.center = CGPointMake(1024/2, 768/2);
                [self addSubview:imgvPhoto];
            }
                break;
            case IKPhotoViewerTypeInsurance:{
                imgvBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKBGAddUser.png"]];
                imgvBG.center = CGPointMake(frame.size.width/2, frame.size.height/2);
                [self addSubview:imgvBG];
                imgvBG.userInteractionEnabled = YES;
                
                UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnNext setBackgroundImage:[UIImage imageNamed:@"IKButtonYellow.png"] forState:UIControlStateNormal];
                [btnNext sizeToFit];
                [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnNext setTitle:LocalizeStringFromKey(@"kDone")  forState:UIControlStateNormal];
                btnNext.titleLabel.font = [UIFont boldSystemFontOfSize:20];
                btnNext.center = CGPointMake(642, 425);
                [imgvBG addSubview:btnNext];
                [btnNext addTarget:self action:@selector(finishClicked) forControlEvents:UIControlEventTouchUpInside];
                
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.itemSize = CGSizeMake(140, 140);
                layout.minimumInteritemSpacing = 30;
                layout.minimumLineSpacing = 30;
                
                aryList = [NSMutableArray array];
                
                cvList = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 30, imgvBG.frame.size.width-30*2, 342) collectionViewLayout:layout];
                [cvList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentifier"];
                cvList.backgroundColor = [UIColor clearColor];
                cvList.delegate = self;
                cvList.dataSource = self;
                [imgvBG addSubview:cvList];
            }
                break;

                
            default:
                break;
        }
        
        if (0==viewerType){
            
        }else{
            
        }
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)img{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        viewerType = IKPhotoViewerTypeFullscreen;
        
        imgvPhoto = [[UIImageView alloc] initWithImage:img];
        float ratio = img.size.width/img.size.height;
        
        float w,h;
        
        if (ratio>1024.0f/768.0f){
            w = 1024-100*2;
            h = w/ratio;
        }else{
            h = 768-50*2;
            w = h*ratio;
        }
        
        imgvPhoto.frame = CGRectMake((1024-w)/2, (768-h)/2, w, h);
        [self addSubview:imgvPhoto];
    }
    return self;
}

+ (void)showIDCardPhoto:(IKVisitCDSO *)visit{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKPhotoViewer *v = [[IKPhotoViewer alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) visit:visit type:IKPhotoViewerTypeIDCard];
    
    [v reloadData];
//    [cvList reloadData];
    
    [w.rootViewController.view addSubview:v];
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
}



+ (void)showInsuranceCardPhoto:(IKVisitCDSO *)visit{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKPhotoViewer *v = [[IKPhotoViewer alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) visit:visit type:IKPhotoViewerTypeInsurance];
    
    [v reloadData];
    //    [cvList reloadData];
    
    [w.rootViewController.view addSubview:v];
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
}

+ (void)showSignPhoto:(IKVisitCDSO *)visit{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKPhotoViewer *v = [[IKPhotoViewer alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) visit:visit type:IKPhotoViewerTypeSign];
    [v reloadData];

    
    [w.rootViewController.view addSubview:v];
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
}

+ (void)showFullImage:(UIImage *)img{
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    IKPhotoViewer *v = [[IKPhotoViewer alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) image:img];
    [v reloadData];

    
    [w.rootViewController.view addSubview:v];
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
}

- (void)reloadData{
    if (0==viewerType){
        aryList = [NSMutableArray arrayWithArray:self.visit.idphotoList];
        uploadNotPhotoAry =[self getUploadNotPhotos];
    }if (3 == viewerType) {
        aryList = [NSMutableArray arrayWithArray:self.visit.insurancephotoList];
    }
    
    [cvList reloadData];
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
-(NSMutableArray *)getUploadNotPhotos{
    NSMutableArray *ary =[NSMutableArray array];
    for (int i =0; i<[aryList count]; i++) {
        IKPhotoCDSO *uploadPhoto =[aryList objectAtIndex:i];
        if ( [uploadPhoto.uploaded boolValue] ==NO) {
            [ary addObject:uploadPhoto];
        }
    }
    return ary;
}
-(void)loadStatus{
     [SVProgressHUD showWithStatus:LocalizeStringFromKey(@"kLoadPhoto")];
    
    if (photos.count ==0 ){//&&[uploadNotPhotoAry count]==0
        [self loaddismis];
    }
}
-(void)loadPhoto{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    
    if (photos.count>0){
        [self uploadPhotos:photos formatter:formatter];
    }
//    if (uploadNotPhotoAry.count>0){
//        [self uploadPhotos:uploadNotPhotoAry formatter:formatter];
//    }
    [self loaddismis];
    
}
-(void)uploadPhotos:(NSMutableArray *)ary formatter:(NSDateFormatter *)formatter{
        for (int i=0;i<ary.count;i++){
        @autoreleasepool {
            NSMutableDictionary *mut = [NSMutableDictionary dictionary];
            NSDate *date;
            if ([[ary objectAtIndex:i] objectForKey:@"createTime"]) {
                date = [[ary objectAtIndex:i] objectForKey:@"createTime"];
            }
            
            
            NSString *dateString = [formatter stringFromDate:date];
            
            NSString *seqID =  [NSString stringWithFormat:@"%@%@%@",self.visit.providerID,self.visit.memberID,dateString];//seqID
            
            [mut setObject:seqID forKey:@"seqID"];
            
            NSDateFormatter *formatter_update = [[NSDateFormatter alloc] init];
            [formatter_update setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            [mut setObject:[formatter_update stringFromDate:date] forKey:@"createTime"];//拍摄时间
            [mut setObject:[formatter_update stringFromDate:[NSDate date]]  forKey:@"modifyTime"];//修改时间
            
            if (self.visit){
                [mut setObject:self.visit.depID forKey:@"depID"];
                [mut setObject:self.visit.providerID forKey:@"providerID"];
                [mut setObject:self.visit.memberID forKey:@"memberID"];
            }
            
            [mut setObject:[NSString stringWithFormat:@"%d",IKPhotoTypeIDCard] forKey:@"type"];//身份证件照 ＝1
            
            
            UIImage *img = [[ary objectAtIndex:i] objectForKey:@"image"];//图片
            UIImage *finallyImg =[self judgePhotoSize:img];
            NSData *data;
            if (finallyImg ==nil) {
                data = UIImageJPEGRepresentation(img,1.0);// uiimage 转 nsdata
            }else{
                data = UIImageJPEGRepresentation(finallyImg,1.0);// uiimage 转 nsdata
            }
            NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];//base64转码
            if (base64String){
                [mut setObject:base64String forKey:@"photoPath"];
                BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@[mut],@"data",@"1",@"count",(isInLocal?@"1":@"0"),@"internetType", nil];
                
                NSDictionary *dict = [IKDataProvider syncPhoto:param];
                
                NSString *result = [dict objectForKey:@"result"];
                
                int j = i+1;
                if (result && result.intValue==0){
                    //  成功上传
                    NSLog(@"新上传第 %d 张图片成功",j);
                    
                    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"新上传第 %d 张图片成功",j]];
                    
                    sw_dispatch_sync_on_main_thread(^{
                        
                        IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
                        photo.uploaded = [NSNumber numberWithBool:YES];
                        [[IKDataProvider managedObjectContext] refreshObject:photo mergeChanges:YES];
                        [[IKDataProvider managedObjectContext] save:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshIDCardPhoto" object:nil];
                    });
                }else{
                    
                    sw_dispatch_sync_on_main_thread(^{
                        IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
                        //   photo.uploaded = [NSNumber numberWithBool:YES];
                        photo.uploaded = [NSNumber numberWithBool:NO];
                        [[IKDataProvider managedObjectContext] deleteObject:photo];
                        [[IKDataProvider managedObjectContext] save:nil];
                    });
                    
                    NSLog(@"新上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]);
//                    [UIAlertView showAlertWithTitle:@"" message:[NSString stringWithFormat:@"新上传第 %d 张图片失败:%@",i,[dict objectForKey:@"errStr"]] cancelButton:nil delegate:self];
                     [UIAlertView showAlertWithTitle:@"" message:[NSString stringWithFormat:@"网络连接失败"] cancelButton:nil delegate:self];
                    
                    
                    return;
                }
            }
        }
    }
}
    
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        [self loaddismis];
    }
}
- (void)finishClicked{
    
    NSInvocationOperation *invocationOperation =[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadStatus) object:nil];
    sleep(0.1);
    NSLog(@"111");
    [invocationOperation setCompletionBlock:^{
        [self loadPhoto];
         NSLog(@"1222");
    }];
    [invocationOperation start];
}

- (void)loaddismis {
    [self dismiss];
    [SVProgressHUD dismiss];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (viewerType!=IKPhotoViewerTypeIDCard||viewerType!=IKPhotoTypeInsuranceCard){
        [self dismiss];
    }else{
        CGPoint pt = [[touches anyObject] locationInView:self];
        if (!CGRectContainsPoint(imgvBG.frame, pt)){
            [self dismiss];
        }
    }
}

- (void)dismiss{
//    [UIView animateWithDuration:.0f animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
           self.alpha = 0;
           [self removeFromSuperview];
}

- (void)addPhotoClicked{
    if (IKPhotoViewerTypeIDCard==viewerType){
        UICollectionViewCell *cell = [cvList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        
        UIActionSheet *as = nil;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kAddphoto"),LocalizeStringFromKey(@"kSelectphotofromIPADalbum"), nil];
        else
            as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kSelectphotofromIPADalbum"), nil];
        [as showFromRect:cell.frame inView:cell.superview animated:YES];
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            IKImagePickerViewController *picker = [[IKImagePickerViewController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.chageDirection =NO;
            UIViewController *vc = [UIView rootViewController];
            [vc presentViewController:picker animated:YES completion:^{
                picker.chageDirection =YES;
            }];
            
            //        pcPhotoPicker = [[UIPopoverController alloc] initWithContentViewController:picker];
            //
            //        [pcPhotoPicker presentPopoverFromRect:CGRectMake(0, 0, 140, 140) inView:cvList permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else{
            [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kCameraMissed") cancelButton:nil];
        }
    }
    
    
    
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
    
    UIImageView *imgv = (UIImageView *)[cell.contentView viewWithTag:100];
    UIImageView *cover = (UIImageView *)[cell.contentView viewWithTag:101];
    if (!imgv){
        imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        imgv.tag = 100;
        [cell.contentView addSubview:imgv];
        
        cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        cover.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
        cover.tag = 101;
        cover.hidden = YES;
        [cell.contentView addSubview:cover];
    }
    
    UIImage *img = 0==indexPath.row?[UIImage imageNamed:@"IKButtonAddPhoto.png"]:[[aryList objectAtIndex:indexPath.row-1] image];
    
    float r = MIN(img.size.width, img.size.height);
    UIImage *cropped = indexPath.row==0?img:[img croppedImage:CGRectMake((img.size.width-r)/2, (img.size.height-r)/2, r, r)];
    [imgv setImage:cropped];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return aryList.count+1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (0==indexPath.item)
        [self addPhotoClicked];
    else{
        selectedPhoto = [aryList objectAtIndex:indexPath.row-1];
        
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:LocalizeStringFromKey(@"kCancel")
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:LocalizeStringFromKey(@"kViewLarge"),LocalizeStringFromKey(@"kDelete"), nil];
        [as showInView:self];
    }
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
    
    
    [photos addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"createTime",img,@"image", nil]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    NSDate *date = [NSDate date];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *seqID = [NSString stringWithFormat:@"%@%@%@",self.visit.providerID,self.visit.memberID,dateString];
    
    IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
    if (!photo){
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
        
        photo.seqID = seqID;
        photo.visit = self.visit;
        photo.createTime = date;
        photo.image = img;
        photo.uploaded = [NSNumber numberWithBool:NO];
        switch (viewerType) {
            case 0:
                photo.type = [NSNumber numberWithInt:IKPhotoTypeIDCard];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:nil];
                break;
            case 1:
                photo.type = [NSNumber numberWithInt:IKPhotoTypeSignature];
                break;
            case 2:
                photo.type = [NSNumber numberWithInt:IKPhotoTypeSignature];
                break;
            case 3:
                photo.type = [NSNumber numberWithInt:IKPhotoTypeInsuranceCard];
                break;
                
            default:
                break;
        }
        
    }
    
    photo.modifyTime = [NSDate date];
    [[IKDataProvider managedObjectContext] save:nil];

    [self reloadData];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    picker = nil;
    
 
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    picker = nil;
}

#pragma mark - UIPopOverDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    pcPhotoPicker = nil;
    cvList.superview.transform = CGAffineTransformIdentity;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kDelete")]){
        //  if uploaded,delete photo on server
        if (selectedPhoto.uploaded.boolValue)
            [IKDataProvider addDeletedPhotoSeqID:selectedPhoto.seqID];
        
        [[IKDataProvider managedObjectContext] deleteObject:selectedPhoto];
        [[IKDataProvider managedObjectContext] save:nil];
        selectedPhoto = nil;
        
        [self reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:visit userInfo:nil];
        
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kViewLarge")]){
        [IKPhotoViewer showFullImage:selectedPhoto.image];
        
//        UIImage *img = selectedPhoto.image;
//        if (img.size.width>0){
//            imgvPhoto = [[UIImageView alloc] initWithImage:img];
//            float ratio = img.size.width/img.size.height;
//            
//            float w,h;
//            
//            if (ratio>1024.0f/768.0f){
//                w = 1024-100*2;
//                h = w/ratio;
//            }else{
//                h = 768-50*2;
//                w = h*ratio;
//            }
//            
//            imgvPhoto.frame = CGRectMake((1024-w)/2, (768-h)/2, w, h);
//            [self addSubview:imgvPhoto];
//        }
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kAddphoto")]){//拍照
        IKImagePickerViewController *picker = [[IKImagePickerViewController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
//        picker.allowsEditing = YES;
//        picker.cameraViewTransform = CGAffineTransformMakeRotation(M_PI*360/180);
        UIViewController *vc = [UIView rootViewController];
//        NSLog(@"%f,%f",vc.view.frame.size.width,vc.view.frame.size.height);
        picker.chageDirection =NO;
        [vc presentViewController:picker animated:YES completion:^{
            picker.chageDirection =YES;
        }];
        
        
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kSelectphotofromIPADalbum")]){//从相册
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        
//        cvList.superview.transform = CGAffineTransformMakeTranslation(200, 0);
        
        pcPhotoPicker = [[UIPopoverController alloc] initWithContentViewController:picker];
        pcPhotoPicker.delegate = self;
        UICollectionViewCell *cell = [cvList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [pcPhotoPicker presentPopoverFromRect:cell.frame   // did you forget to call this method?
                                       inView:cell.superview
                     permittedArrowDirections:UIPopoverArrowDirectionRight
                                     animated:YES];
    }
}

@end
