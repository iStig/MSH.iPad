//
//  IKRecordSelector.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-5.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKRecordSelector.h"
#import "IKPhotoViewer.h"
#import "IKAppDelegate.h"
#import "IKPhotoCDSO.h"
#import "IKMemberCDSO.h"
#import "IKImagePickerViewController.h"

@implementation IKRecordSelector


@synthesize delegate,aryList,visit;

- (id)initWithFrame:(CGRect)frame visit:(IKVisitCDSO *)vis delegate:(id<IKRecordSelectorDelegate>)dele selected:(NSArray *)selected{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        self.visit = vis;
        self.delegate = dele;
        
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
        
        if(visit){
            
          //   IKMemberCDSO *member = [IKMemberCDSO meberWithMemberID:visit.memberID depID:visit.depID];
            
      //  aryList = [NSMutableArray arrayWithArray:self.visit.recordsCaseList];
            
            // aryList = [NSMutableArray arrayWithArray:member.allcardPhotoList];
            
            aryList =  [NSMutableArray arrayWithArray:visit.allphotoList];
        }
        
        arySelectedList = [NSMutableArray array];
        for (int i=0;i<selected.count;i++){
            IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:[selected objectAtIndex:i]];
            if (photo)
                [arySelectedList addObject:photo];
        }
        
        cvList = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 30, imgvBG.frame.size.width-30*2, 342) collectionViewLayout:layout];
        [cvList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentifier"];
        cvList.backgroundColor = [UIColor clearColor];
        cvList.delegate = self;
        cvList.dataSource = self;
        [imgvBG addSubview:cvList];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame visitInfo:(NSDictionary *)visitInfo delegate:(id<IKRecordSelectorDelegate>)dele selected:(NSArray *)selected{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
        
        NSString *memberID = [visitInfo objectForKey:@"memberID"];
        NSString *depID = [visitInfo objectForKey:@"depID"]?[visitInfo objectForKey:@"depID"]:@"";
        
        IKMemberCDSO *member = [IKMemberCDSO meberWithMemberID:memberID depID:depID];
        
        self.delegate = dele;
        
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
        
//        aryList = [NSMutableArray arrayWithArray:member.allcardPhotoListAndOtherList];
        aryList = [NSMutableArray arrayWithArray:member.allcardPhotoList];
        arySelectedList = [NSMutableArray array];
        for (int i=0;i<selected.count;i++){
            IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:[selected objectAtIndex:i]];
            if (photo)
                [arySelectedList addObject:photo];
        }
        
        cvList = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 30, imgvBG.frame.size.width-30*2, 342) collectionViewLayout:layout];
        [cvList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentifier"];
        cvList.backgroundColor = [UIColor clearColor];
        cvList.delegate = self;
        cvList.dataSource = self;
        [imgvBG addSubview:cvList];
    }
    return self;
}

- (void)finishClicked{
    NSMutableArray *mut = [NSMutableArray array];
    
    for (IKPhotoCDSO *photo in arySelectedList){
        NSMutableDictionary *mutinfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:photo.seqID,@"seqID",photo.createTime,@"date",photo.image,@"image", nil];
        
        [mut addObject:mutinfo];
    }
    
    [self.delegate recordPhotoSelected:mut
     ];
    
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
+ (void)showWithVisit:(IKVisitCDSO *)vis delegate:(id<IKRecordSelectorDelegate>)dele selected:(NSArray *)selected{
    IKRecordSelector *v = [[IKRecordSelector alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) visit:vis delegate:dele selected:selected];
    
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    v.alpha = 0;
    [w.rootViewController.view addSubview:v];
    
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
}

+ (void)showWithVisitInfo:(NSDictionary *)visitInfo delegate:(id<IKRecordSelectorDelegate>)dele selected:(NSArray *)selected{
    IKRecordSelector *v = [[IKRecordSelector alloc] initWithFrame:CGRectMake(0, 0, 1024, 768) visitInfo:visitInfo delegate:dele selected:selected];
    
    UIWindow *w = ((IKAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    v.alpha = 0;
    [w.rootViewController.view addSubview:v];
    
    [UIView animateWithDuration:.3f animations:^{
        v.alpha = 1;
    }];
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

- (void)addPhotoClicked{
    UICollectionViewCell *cell = [cvList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    UIActionSheet *as = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kAddphoto"),LocalizeStringFromKey(@"kSelectphotofrompersonalalbum"), nil];
    else
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kSelectphotofrompersonalalbum"), nil];
    [as showFromRect:cell.frame inView:cell.superview animated:YES];
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
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:102];
    if (!imgv){
        imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        imgv.tag = 100;
        [cell.contentView addSubview:imgv];
        
        cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        cover.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
        cover.tag = 101;
        cover.hidden = YES;
        [cell.contentView addSubview:cover];
        
        icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IKIconCheckFinished.png"]];
        icon.center = CGPointMake(140-20, 20);
        icon.tag = 102;
        icon.hidden = YES;
        [cell.contentView addSubview:icon];
    }
    
    UIImage *img = [[aryList objectAtIndex:indexPath.row] image];
    
    float r = MIN(img.size.width, img.size.height);
    UIImage *cropped = indexPath.row==0?img:[img croppedImage:CGRectMake((img.size.width-r)/2, (img.size.height-r)/2, r, r)];
    [imgv setImage:cropped];
    
    BOOL selected = NO;
    
    IKPhotoCDSO *photo = [aryList objectAtIndex:indexPath.row];
    for (IKPhotoCDSO *sp in arySelectedList){
        if ([sp.seqID isEqualToString:photo.seqID]){
            selected = YES;
            break;
        }
    }
    
    icon.hidden = !selected;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return aryList.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BOOL selected = NO;
    int index = -1;
    IKPhotoCDSO *photo = [aryList objectAtIndex:indexPath.row];
    for (IKPhotoCDSO *sp in arySelectedList){
        if ([sp.seqID isEqualToString:photo.seqID]){
            selected = YES;
            index = [arySelectedList indexOfObject:sp];
            break;
        }
    }
    
    if (selected){
        if (index>=0)
            [arySelectedList removeObjectAtIndex:index];
    }else{
        [arySelectedList addObject:photo];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
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
    if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kAddphoto")]){
        IKImagePickerViewController *picker = [[IKImagePickerViewController alloc] init];
        picker.chageDirection =NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        
        UIViewController *vc = [UIView rootViewController];
        [vc presentViewController:picker animated:YES completion:^{
            picker.chageDirection =YES;
        }];

        
        
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kSelectphotofrompersonalalbum")]){
        
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kDelete")]){
        //  if uploaded,delete photo on server
        [aryList removeObject:selectedPhotoInfo];
        selectedPhotoInfo = nil;
        [cvList reloadData];
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kViewLarge")]){
        [IKPhotoViewer showFullImage:[selectedPhotoInfo objectForKey:@"image"]];
    }
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    NSDate *date = [NSDate date];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    
    NSString *seqID = [NSString stringWithFormat:@"%@%@%@",self.visit.providerID,self.visit.memberID,dateString];
    
    
    [aryList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"date",img,@"image",seqID,@"seqID", nil]];
    
    [cvList reloadData];
    
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
}



@end
