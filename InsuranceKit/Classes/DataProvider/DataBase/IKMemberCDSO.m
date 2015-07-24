//
//  IKMemberCDSO.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-30.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKMemberCDSO.h"
#import "IKVisitCDSO.h"
#import "IKPhotoCDSO.h"

@interface IKMemberCDSO()

@property (nonatomic) NSSet *visits;
@property (nonatomic) NSData *detail;

@end

@implementation IKMemberCDSO
@dynamic memberID,memberName,depID;
@dynamic detail,detailInfo,visits;
@dynamic hospital;

+ (IKMemberCDSO *)meberWithMemberID:(NSString *)mID depID:(NSString *)dID{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Member" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(memberID=%@ && depID=%@)",mID,dID];

    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];

    [fetchRequest setFetchLimit:1];
    
    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    if (0==ary.count){
        return nil;
    }else{
        return [ary objectAtIndex:0];
    }
}


#pragma mark - Properties
- (NSArray *)visitList{
    return [self.visits allObjects];
}

- (NSArray *)recordPhotoList{
    NSMutableArray *mut = [NSMutableArray array];
    for (IKVisitCDSO *visit in self.visits){
        for (IKPhotoCDSO *photo in visit.photoList){
            if (photo.type.intValue==IKPhotoTypeRecords)
                [mut addObject:photo];
        }
    }
    
    [mut sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        IKPhotoCDSO *photo1 = obj1;
        IKPhotoCDSO *photo2 = obj2;
        
        double interval = [photo2.createTime timeIntervalSinceDate:photo1.createTime];
        if (0==interval)
            return NSOrderedSame;
        else if (interval<0)
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    return mut;
}

- (NSArray *)allcardPhotoList{
    NSMutableArray *mut = [NSMutableArray array];
    for (IKVisitCDSO *visit in self.visits){
        for (IKPhotoCDSO *photo in visit.photoList){
            if (photo.type.intValue==IKPhotoTypeRecords||photo.type.intValue==IKPhotoTypeInsuranceCard)
                [mut addObject:photo];
        }
    }
    
    [mut sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        IKPhotoCDSO *photo1 = obj1;
        IKPhotoCDSO *photo2 = obj2;
        
        double interval = [photo2.createTime timeIntervalSinceDate:photo1.createTime];
        if (0==interval)
            return NSOrderedSame;
        else if (interval<0)
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    return mut;
}
//wucy 3.11
- (NSArray *)allcardPhotoListAndOtherList{
    NSMutableArray *mut = [NSMutableArray array];
    for (IKVisitCDSO *visit in self.visits){
        for (IKPhotoCDSO *photo in visit.photoList){
            if (photo.type.intValue==IKPhotoTypeRecords||photo.type.intValue==IKPhotoTypeInsuranceCard||photo.type.intValue==IKPhotoTypeClaimClaimsPaymentList||photo.type.intValue==IKPhotoTypeClaimClaimsOtherList)
                [mut addObject:photo];
        }
    }
    
    [mut sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        IKPhotoCDSO *photo1 = obj1;
        IKPhotoCDSO *photo2 = obj2;
        
        double interval = [photo2.createTime timeIntervalSinceDate:photo1.createTime];
        if (0==interval)
            return NSOrderedSame;
        else if (interval<0)
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    return mut;
}
- (NSArray *)idcardPhotoList{

    NSMutableArray *mut = [NSMutableArray array];
    for (IKVisitCDSO *visit in self.visits){
        for (IKPhotoCDSO *photo in visit.photoList){
            if (photo.type.intValue==IKPhotoTypeIDCard)
                [mut addObject:photo];
        }
    }
    
    [mut sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        IKPhotoCDSO *photo1 = obj1;
        IKPhotoCDSO *photo2 = obj2;
        
        double interval = [photo2.createTime timeIntervalSinceDate:photo1.createTime];
        if (0==interval)
            return NSOrderedSame;
        else if (interval<0)
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    return mut;
}
- (NSArray *)insurancecardPhotoList{
    NSMutableArray *mut = [NSMutableArray array];
    for (IKVisitCDSO *visit in self.visits){
        for (IKPhotoCDSO *photo in visit.photoList){
            if (photo.type.intValue==IKPhotoTypeInsuranceCard)
                [mut addObject:photo];
        }
    }
    
    [mut sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        IKPhotoCDSO *photo1 = obj1;
        IKPhotoCDSO *photo2 = obj2;
        
        double interval = [photo2.createTime timeIntervalSinceDate:photo1.createTime];
        if (0==interval)
            return NSOrderedSame;
        else if (interval<0)
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    
    return mut;
}

- (NSDictionary *)detailInfo{
    NSDictionary *dict = self.detail?[NSKeyedUnarchiver unarchiveObjectWithData:self.detail]:nil;
    
    return dict;
}

- (void)setDetailInfo:(NSDictionary *)dict{
    self.detail = dict?[NSKeyedArchiver archivedDataWithRootObject:dict]:nil;
    
    if (dict){
        self.depID = [dict objectForKey:@"depID"];
        self.memberID = [dict objectForKey:@"memberID"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
}

@end
