//
//  IKPhotoCDSO.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKPhotoCDSO.h"

@implementation IKPhotoCDSO

@dynamic seqID;
@dynamic createTime,modifyTime,createTimeString,modifyTimeString;
@dynamic type,uploaded;

@dynamic visit;

@dynamic image;

+ (IKPhotoCDSO *)photoWithSeqID:(NSString *)seq{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *photoEntity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seqID=%@",seq];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
    
    [fetchRequest setEntity:photoEntity];
    [fetchRequest setPredicate:predicate];
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchLimit:1];
    
    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (0==ary.count){
        return nil;
    }else{
        return [ary objectAtIndex:0];
    }
}

- (NSString *)base64String{
    NSData *data = [NSData dataWithContentsOfFile:[self.seqID imageCachePath]];
    
    return [data base64Encoding];
}

- (UIImage *)image{
    if (self.seqID){
        UIImage *img = [UIImage imageWithContentsOfFile:[self.seqID imageCachePath]];
        
        return img;
    }else
        return nil;
    
}

- (void)setImage:(UIImage *)img{
//    for (int i=0;i<10;i++){
//        NSData *data = UIImageJPEGRepresentation(img, ((float)(i+1))/10.0f);
//        NSLog(@"Quality:%d,FileSize:%.1f",i,((float)data.length/1024.0f));
//    }
    
    [UIImageJPEGRepresentation(img, .1f) writeToFile:[self.seqID imageCachePath] atomically:NO];
    
//    [UIImagePNGRepresentation(img) writeToFile:[self.seqID imageCachePath] atomically:NO];
}

- (NSString *)createTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (!self.createTime)
        self.createTime = self.modifyTime;
    
    return [formatter stringFromDate:self.createTime];
}

- (NSString *)modifyTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:self.modifyTime];
}

+ (NSArray *)allNotUploadedPhotosInfo{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *photoEntity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded=NO || uploaded=nil",nil];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
    
    [fetchRequest setEntity:photoEntity];
    [fetchRequest setPredicate:predicate];
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
//    [fetchRequest setFetchLimit:1];
    
    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *mut = [NSMutableArray array];
    
    for (IKPhotoCDSO *photo in ary){
        NSMutableDictionary *mutdict = [NSMutableDictionary dictionary];
        if (photo.seqID ==nil) {
            return nil;
        }
        [mutdict setObject:photo.seqID forKey:@"seqID"];
        [mutdict setObject:photo.createTimeString forKey:@"createTime"];
        [mutdict setObject:photo.modifyTimeString forKey:@"modifyTime"];
        if (photo.visit){
            [mutdict setObject:photo.visit.depID forKey:@"depID"];
            [mutdict setObject:photo.visit.providerID forKey:@"providerID"];
            [mutdict setObject:photo.visit.memberID forKey:@"memberID"];
        }
        
        [mutdict setObject:[NSString stringWithFormat:@"%d",photo.type.intValue] forKey:@"type"];
//        [mutdict setObject:photo.base64String forKey:@"photoPath"];
        
        [mut addObject:mutdict];
    }
    
    return mut;
}

//+ (NSArray *)allNotUploadedPhotos{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    NSEntityDescription *photoEntity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploaded=NO || uploaded=nil",nil];
//    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
//    
//    [fetchRequest setEntity:photoEntity];
//    [fetchRequest setPredicate:predicate];
//    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
////    [fetchRequest setFetchLimit:1];
//    
//    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
//    
//    return ary;
//}

//+ (void)updateUploadedStatus:(NSArray *)ary{
//    NSMutableSet *set = [NSMutableSet set];
//    
//    for (NSDictionary *info in ary){
//        [set addObject:[info objectForKey:@"seqID"]];
//    }
//    
//    
//    NSArray *aryNot = [IKPhotoCDSO allNotUploadedPhotos];
//    for (IKPhotoCDSO *photo in aryNot){
//        if ([set containsObject:photo.seqID])
//            photo.uploaded = [NSNumber numberWithBool:YES];
//    }
//    
//    [[IKDataProvider managedObjectContext] save:nil];
//    
//    
//}

+ (void)updateUploadedPhoto:(NSString *)photoID{
    IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:photoID];
    photo.uploaded = [NSNumber numberWithBool:YES];
    
    if (!photo.visit.hospital)
        [[IKDataProvider managedObjectContext] deleteObject:photo];
    
    [[IKDataProvider managedObjectContext] save:nil];
}



@end
