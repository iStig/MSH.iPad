//
//  IKClientsLogView.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-11.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKClientsLogView.h"
#import "IKPhotoCDSO.h"
#import "IKPhotoViewer.h"
#import "IKImagePickerViewController.h"

@implementation IKClientsLogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:.98 green:.97 blue:.98 alpha:1];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(140, 140);
        layout.minimumInteritemSpacing = 15;
        layout.minimumLineSpacing = 15;
        
        
        
        cvList = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 30, frame.size.width-30*2, 342) collectionViewLayout:layout];
        [cvList registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCellIdentifier"];
        cvList.backgroundColor = [UIColor clearColor];
        cvList.delegate = self;
        cvList.dataSource = self;
        [self addSubview:cvList];
    }
    return self;
}

- (void)showInfo{
    aryList = [NSMutableArray arrayWithArray:visit.recordsList];
    
    [cvList reloadData];
}

- (void)addPhotoClicked{
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
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
        
        [self showInfo];
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"kViewLarge")]){
        UIImage *img = selectedPhoto.image;
        [IKPhotoViewer showFullImage:img];
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
    
    IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
    if (!photo){
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
        
        
        
        photo.seqID = seqID;
        photo.visit = self.visit;
        photo.createTime = date;
        photo.image = img;
        photo.type = [NSNumber numberWithInt:IKPhotoTypeRecords];
    }
    photo.modifyTime = [NSDate date];
    photo.visit.modifyTime = [NSDate date];
    
    [[IKDataProvider managedObjectContext] save:nil];
    
    aryList = [NSMutableArray arrayWithArray:self.visit.recordsList];
    
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

@end
