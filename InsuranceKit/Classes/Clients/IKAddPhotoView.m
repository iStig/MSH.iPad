//
//  IKAddPhotoView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-13.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKAddPhotoView.h"
#import "IKImagePickerViewController.h"
@implementation IKAddPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(140, 140);
        layout.minimumInteritemSpacing = 30;
        layout.minimumLineSpacing = 30;
        
        aryList = [NSMutableArray array];
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectMake(30, 15, 200, 23) font:[UIFont boldSystemFontOfSize:22] textColor:[UIColor colorWithWhite:.44 alpha:1]];
        [self addSubview:lbl];
        lbl.text = @"请拍摄保险卡";
        
        cvList = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 50, frame.size.width-30*2, 342) collectionViewLayout:layout];
        [cvList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentifier"];
        cvList.backgroundColor = [UIColor clearColor];
        cvList.delegate = self;
        cvList.dataSource = self;
        [self addSubview:cvList];
    }
    return self;
}

- (void)addPhotoClicked{
    UICollectionViewCell *cell = [cvList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    UIActionSheet *as = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kAddphoto"),LocalizeStringFromKey(@"kSelectphotofromIPADalbum"), nil];
    else
        as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizeStringFromKey(@"kCancel") destructiveButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"kSelectphotofromIPADalbum"), nil];
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

- (void)showNextClicked{
    [self.delegate photoAdded:aryList];
}

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
    
    UIImage *img = 0==indexPath.row?[UIImage imageNamed:@"IKButtonAddPhoto.png"]:[[aryList objectAtIndex:indexPath.row-1] objectForKey:@"image"];
    
    float r = MIN(img.size.width, img.size.height);
    UIImage *cropped = indexPath.row==0?img:[img croppedImage:CGRectMake((img.size.width-r)/2, (img.size.height-r)/2, r, r)];
    [imgv setImage:cropped];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return aryList.count+1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (0==indexPath.item){
        IKImagePickerViewController *picker = [[IKImagePickerViewController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.chageDirection =NO;
    
        UIViewController *vc = [UIView rootViewController];
        [vc presentViewController:picker animated:YES completion:^{
            picker.chageDirection =YES;
        }];

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


#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

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
    
    [aryList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"date",img,@"image", nil]];
    
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
