//
//  IKVisitCDSO.m
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "IKVisitCDSO.h"
#import "IKPhotoCDSO.h"
#import "IKMemberCDSO.h"
#import "IKDecodeWithUTF8.h"
@interface IKVisitCDSO()

@property (nonatomic) NSData *detail;
@property (nonatomic) NSData *authInfo;

@end

@implementation IKVisitCDSO

@dynamic actualCopay,visitExpenses,serviceType,temp,invisible,paymentEdit,dentalType,shouldPay,totalCopay,visitType;
@dynamic createTime,modifyTime,paymentTime,uploadTime,registrationTime,applyForTime;
@dynamic depID,memberID,memberName,visitID,providerID;
@dynamic photos;
@dynamic detail;
@dynamic detailInfo,authInfoDic;
@dynamic member,hospital;

+ (IKVisitCDSO *)vistWithID:(NSString *)visit{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *visitEntity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"visitID=%@",visit];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
    
    [fetchRequest setEntity:visitEntity];
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

- (NSString *)signature{
    NSString *seqID = nil;
    for (IKPhotoCDSO *photo in self.photos){
        if (photo.type.intValue==IKPhotoTypeSignature){
            seqID = photo.seqID;
            break;
        }
    }
    
    return seqID;
}

- (UIImage *)signatureImage{
    IKPhotoCDSO *sign = nil;
    for (IKPhotoCDSO *photo in self.photos){
        if (photo.type.intValue==IKPhotoTypeSignature){
            sign = photo;
            break;
        }
    }
    
    return sign.image;
}

- (NSString *)medRecImg{
    NSMutableString *mutstr = [NSMutableString string];
    for (IKPhotoCDSO *photo in self.photos){
        if (photo.type.intValue==IKPhotoTypeRecords){
            if (mutstr.length>0)
                [mutstr appendString:@","];
            [mutstr appendString:photo.seqID];
        }
    }
    
    return mutstr;
}

- (NSArray *)photoList{
    return [self.photos allObjects];
}
-(NSArray *)getShootingPhotoList{
    NSArray *arry =[self.photos allObjects];
    NSMutableArray *shootingAry =[NSMutableArray array];
    for (int i =0; i< [arry count]; i++) {
        IKPhotoCDSO *photoCDSO =[arry objectAtIndex:i];
        int type =[photoCDSO.type intValue];
        if (type ==IKPhotoTypeInsuranceCard || type ==IKPhotoTypeClaimClaimsPaymentList ||type==IKPhotoTypeClaimClaimsOtherList) {
            [shootingAry addObject:[arry objectAtIndex:i]];
        }
    }
    return shootingAry;
}
- (NSArray *)recordsList{
    NSMutableArray *mut = [NSMutableArray array];
    for (IKPhotoCDSO *photo in self.photoList){
        if (photo.type.intValue==IKPhotoTypeRecords)
            [mut addObject:photo];
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



- (NSArray *)recordsCaseList{
    NSMutableArray *mut = [NSMutableArray array];
    for (IKPhotoCDSO *photo in self.photoList){
        if (photo.type.intValue==IKPhotoTypeRecords||photo.type.intValue==IKPhotoTypeInsuranceCard)//事件授权病例和理赔申请病例
            [mut addObject:photo];
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




- (NSArray *)allphotoList{
    return self.member.allcardPhotoList;
}

- (NSArray *)idphotoList{
    return self.member.idcardPhotoList;
}
- (NSArray *)insurancephotoList{
    return self.member.insurancecardPhotoList;
    
}

- (NSArray *)signphotoList{
    NSMutableArray *mut = [NSMutableArray array];
    for (IKPhotoCDSO *photo in self.photos){
        if (photo.type.intValue==IKPhotoTypeSignature)
            [mut addObject:photo];
    }
    
    
    
    return mut;
}

- (NSString *)paymentTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:self.paymentTime];
}

- (NSString *)modifyTimeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (!self.modifyTime)
        self.modifyTime = self.createTime;
    
    return [formatter stringFromDate:self.modifyTime];
}

- (NSDictionary *)visitInfo{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    [info setObject:self.visitID forKey:@"visitID"];
    
    if (self.signature)
        [info setObject:self.signature forKey:@"signature"];
    if (self.medRecImg)
        [info setObject:self.medRecImg forKey:@"medRecImg"];
    
    [info setObject:[NSString stringWithFormat:@"%.2f",self.visitExpenses.floatValue] forKey:@"medExpenses"];//折后价格
    [info setObject:[NSString stringWithFormat:@"%.2f",self.totalCopay.floatValue] forKey:@"totalCopay"];//总花费
    [info setObject:[NSString stringWithFormat:@"%.2f",self.actualCopay.floatValue] forKey:@"actualCopay"];//实际支付额
    //    [info setObject:[NSString stringWithFormat:@"%.2f",self.shouldPay.floatValue] forKey:@"shouldPay"];
    
    //@"齿科" = 1,@"住院" =2,@"门诊" =3,@"眼科" =4,@"体检" =5 但接口定义的传参数  serviceType:治疗形式 1—OP（门诊）;2--IP （住院）（传1或2）3-齿科,4-眼科,5-体检（2期新增的类型）
//    if (self.serviceType.intValue>0){
//        if (self.serviceType.intValue == 1) {
//            [info setObject:@"3" forKey:@"serviceType"];
//            
//        }if (self.serviceType.intValue == 3) {
//            [info setObject:@"1" forKey:@"serviceType"];
//        }else if(self.serviceType.intValue !=1&&self.serviceType.intValue !=3){
//            [info setObject:[NSString stringWithFormat:@"%d",self.serviceType.intValue] forKey:@"serviceType"];
//        }
//    }
    if (self.paymentsType.intValue>0){
        if (self.paymentsType.intValue == 1) {
            [info setObject:@"3" forKey:@"serviceType"];
            
        }if (self.paymentsType.intValue == 3) {
            [info setObject:@"1" forKey:@"serviceType"];
        }else if(self.paymentsType.intValue !=1&&self.paymentsType.intValue !=3){
            [info setObject:[NSString stringWithFormat:@"%d",self.paymentsType.intValue] forKey:@"serviceType"];
        }
    }
    if (self.paymentTime)
        [info setObject:self.paymentTimeString forKey:@"paymentTime"];
    if (self.modifyTime)
        [info setObject:self.modifyTimeString forKey:@"modifyTime"];
    
    return info;
}

- (NSDictionary *)detailInfo{
    NSDictionary *dict = self.detail?[NSKeyedUnarchiver unarchiveObjectWithData:self.detail]:nil;
    
    return dict;
}
- (NSDictionary *)authInfoDic{
    NSDictionary *dict = self.authInfo?[NSKeyedUnarchiver unarchiveObjectWithData:self.authInfo]:nil;
    
    return dict;
}

- (void)setAuthInfoDic:(NSDictionary *)dict{
    self.authInfo = dict?[NSKeyedArchiver archivedDataWithRootObject:dict]:nil;
    
//    if (dict){
//        self.depID = [dict objectForKey:@"depID"];
//        self.memberID = [dict objectForKey:@"memberID"];
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    }
    
}


- (void)setDetailInfo:(NSDictionary *)dict{
    self.detail = dict?[NSKeyedArchiver archivedDataWithRootObject:dict]:nil;
    
    if (dict){
        self.depID = [dict objectForKey:@"depID"];
        self.visitID = [dict objectForKey:@"visitID"];
        self.memberID = [dict objectForKey:@"memberID"];
        self.providerID = [dict objectForKey:@"providerID"];
        self.memberName = [dict objectForKey:@"memberName"];
        self.hospital = [IKDataProvider currentHospital];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.registrationTime = [formatter dateFromString:[dict objectForKey:@"registrationTime"]];
        
        IKMemberCDSO *memberCDSO = [IKMemberCDSO meberWithMemberID:self.memberID depID:self.depID];
        if (!memberCDSO){
            memberCDSO = [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:[IKDataProvider managedObjectContext]];
            memberCDSO.hospital = [IKDataProvider currentHospital];
            memberCDSO.memberID = [dict objectForKey:@"memberID"];
            memberCDSO.depID = [dict objectForKey:@"depID"];
            memberCDSO.memberName = [dict objectForKey:@"memberName"];
            memberCDSO.detailInfo = dict;
        }
        
        self.member = memberCDSO;//自动会关联 IKMemberCDSO 中visits为当前visit
        
        //  Download Record Photos If Exist
        NSArray *ary = [dict objectForKey:@"idcardImgDetail"];
        if (ary.count>0){
            for (NSDictionary *photoInfo in ary){
                NSString *seqID = [photoInfo objectForKey:@"seqID"];
//                NSString *urlStr = [photoInfo objectForKey:@"imagePath"];
                 NSString *urlStr = [IKDecodeWithUTF8 getDecodeWithUTF8:[photoInfo objectForKey:@"imagePath"]];
               
                IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
                if (!photo){
                    photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
                    photo.seqID = seqID;
                    photo.uploaded = [NSNumber numberWithBool:YES];
                    photo.type = [NSNumber numberWithInt:IKPhotoTypeIDCard];
                    photo.visit = self;
                    photo.createTime = [NSDate date];
                    // Download photo if not exist
                    sw_dispatch_async_on_background_thread(^{
                        @autoreleasepool {
                            NSString *str = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                            
                            NSURL *url = [NSURL URLWithString:str];
                            NSData *data = [NSData dataWithContentsOfURL:url];
                            [data writeToFile:[seqID imageCachePath] atomically:NO];
                            
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:self];
                        }
                    });
                }else{
                    if (![[NSFileManager defaultManager] fileExistsAtPath:[photo.seqID imageCachePath]]){
                        sw_dispatch_async_on_background_thread(^{
                            @autoreleasepool {
                                
                                NSString *str = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                              
                                NSURL *url = [NSURL URLWithString:str];
                                
                                NSData *data = [NSData dataWithContentsOfURL:url];
                                [data writeToFile:[seqID imageCachePath] atomically:NO];
                                
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:self];
                            }
                        });
                    }
                }
            }
        }
        
        
        
        NSArray *aryInsuranceImg = [dict objectForKey:@"insuranceImgDetail"];
        if (aryInsuranceImg.count>0){
            for (NSDictionary *photoInfo in aryInsuranceImg){
                NSString *seqID = [photoInfo objectForKey:@"seqID"];
                NSString *url = [photoInfo objectForKey:@"imagePath"];
                
                IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
                if (!photo){
                    photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];
                    photo.seqID = seqID;
                    photo.uploaded = [NSNumber numberWithBool:YES];
                    photo.type = [NSNumber numberWithInt:IKPhotoTypeInsuranceCard];
                    photo.visit = self;
                    photo.createTime = [NSDate date];
                    // Download photo if not exist
                    sw_dispatch_async_on_background_thread(^{
                        @autoreleasepool {
                            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
                            [data writeToFile:[seqID imageCachePath] atomically:NO];
                            
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:self];
                        }
                    });
                }else{
                    if (![[NSFileManager defaultManager] fileExistsAtPath:[photo.seqID imageCachePath]]){
                        sw_dispatch_async_on_background_thread(^{
                            @autoreleasepool {
                                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
                                [data writeToFile:[seqID imageCachePath] atomically:NO];
                                
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:nil];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardChanged" object:self];
                            }
                        });
                    }
                }
            }
        }
        
        
        self.modifyTime = [formatter dateFromString:[dict objectForKey:@"modifyTime"]];
    }
}

+ (NSArray *)allNotUpdatedVisitInfo{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *visitEntity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploadTime=nil or modifyTime>uploadTime"];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
    
    [fetchRequest setEntity:visitEntity];
    [fetchRequest setPredicate:predicate];
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    //    [fetchRequest setFetchLimit:1];
    
    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *mut = [NSMutableArray array];
    
    for (IKVisitCDSO *visit in ary){
        if (!visit.visitID)
            continue;
        NSMutableDictionary *mutdict = [NSMutableDictionary dictionary];
        [mutdict setObject:visit.visitID forKey:@"visitID"];
        if (visit.signature)
            [mutdict setObject:visit.signature forKey:@"signature"];
        if (visit.medRecImg)
            [mutdict setObject:visit.medRecImg forKey:@"medRecImg"];
        if (visit.visitExpenses.floatValue>0)
            [mutdict setObject:[NSString stringWithFormat:@"%.2f",visit.visitExpenses.floatValue] forKey:@"medExpenses"];
        if (visit.actualCopay.floatValue>0)
            [mutdict setObject:[NSString stringWithFormat:@"%.2f",visit.actualCopay.floatValue] forKey:@"actualCopay"];
        if (visit.totalCopay.floatValue>0)
            [mutdict setObject:[NSString stringWithFormat:@"%.2f",visit.totalCopay.floatValue] forKey:@"totalCopay"];
        if (visit.paymentTime)
            [mutdict setObject:visit.paymentTimeString forKey:@"paymentTime"];
        [mutdict setObject:visit.modifyTimeString forKey:@"modifyTime"];
        //@"齿科" = 1,@"住院" =2,@"门诊" =3,@"眼科" =4,@"体检" =5 但接口定义的传参数  serviceType:治疗形式 1—OP（门诊）;2--IP （住院）（传1或2）3-齿科,4-眼科,5-体检（2期新增的类型）
        if (visit.serviceType.intValue>0){
            if (visit.serviceType.intValue == 1) {
                [mutdict setObject:@"3" forKey:@"serviceType"];
            }if (visit.serviceType.intValue == 3) {
                [mutdict setObject:@"1" forKey:@"serviceType"];
            }else if(visit.serviceType.intValue !=1&&visit.serviceType.intValue !=3){
                [mutdict setObject:[NSString stringWithFormat:@"%d",visit.serviceType.intValue] forKey:@"serviceType"];
            }
        }
        
        [mutdict setObject:[NSString stringWithFormat:@"%d",visit.serviceType.intValue] forKey:@"serviceType"];
        
        [mut addObject:mutdict];
        
    }
    
    return mut;
}

+ (NSArray *)allNotUpdatedVisit{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *visitEntity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:[IKDataProvider managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uploadTime=nil or modifyTime>uploadTime"];
    //    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES];
    
    [fetchRequest setEntity:visitEntity];
    [fetchRequest setPredicate:predicate];
    //    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    
    NSArray *ary = [[IKDataProvider managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    return ary;
}

+ (void)updateUploadTime:(NSArray *)ary{
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSDictionary *info in ary){
        [set addObject:[info objectForKey:@"visitID"]];
    }
    
    NSDate *now = [NSDate date];
    
    NSArray *aryNot = [IKVisitCDSO allNotUpdatedVisit];
    for (IKVisitCDSO *visit in aryNot){
        if ([set containsObject:visit.visitID])
            visit.uploadTime = now;
        
        if (!visit.hospital)
            [[IKDataProvider managedObjectContext] deleteObject:visit];
    }
    
    
    
    [[IKDataProvider managedObjectContext] save:nil];
}
+ (NSString *)applyForTime:(NSDate *)date{

    NSDateFormatter *formatterDay = [[NSDateFormatter alloc] init];
    [formatterDay setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDay = [formatterDay stringFromDate:date];
    return currentDay;
}
+ (NSDate *)applyForTimeAndMin:(NSDate *)date{
    
    NSDateFormatter *formatterDay = [[NSDateFormatter alloc] init];
    [formatterDay setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString *currentDay = [formatterDay stringFromDate:date];
    return date;
}
-(void)dump{
    NSLog(@"visit id ==%@",self.visitID);
    for(IKPhotoCDSO *photo in self.photos){
        [self dumpPhoto:photo];
    }
}
-(void)dumpPhoto:(IKPhotoCDSO *)photo{
    NSLog(@"photo.seqId == %@",photo.seqID);
}
@end
