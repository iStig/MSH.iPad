//
//  IKVisitCDSO.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IKDataProvider.h"


@class IKMemberCDSO,IKHospitalCDSO;

@interface IKVisitCDSO : NSManagedObject

@property (nonatomic) NSNumber*actualCopay,*visitExpenses,*serviceType,*temp,*invisible,*dentalType,*paymentEdit,*shouldPay,*totalCopay,*claimEditHistory,*visitType, *paymentsType;
@property (nonatomic) NSDate *createTime,*modifyTime,*paymentTime,*uploadTime,*registrationTime, *applyForTime;
@property (nonatomic) NSString *depID,*memberID,*memberName,*visitID,*providerID,*beginDate,*endDate;
@property (nonatomic) NSDictionary *detailInfo, *authInfoDic;
@property (nonatomic) IKMemberCDSO *member;
@property (nonatomic) IKHospitalCDSO *hospital;
@property (nonatomic) NSSet *photos;
@property (nonatomic,assign) BOOL uploaded;
+ (IKVisitCDSO *)vistWithID:(NSString *)visit;

- (NSString *)signature;
- (UIImage *)signatureImage;
- (NSString *)medRecImg;
- (NSArray *)photoList;
- (NSArray *)getShootingPhotoList;
- (NSArray *)recordsList;
- (NSArray *)recordsCaseList;
- (NSArray *)allphotoList;
- (NSArray *)idphotoList;
- (NSArray *)insurancephotoList;

- (NSArray *)signphotoList;

- (NSString *)paymentTimeString;
- (NSString *)modifyTimeString;

- (NSDictionary *)visitInfo;

+ (NSArray *)allNotUpdatedVisitInfo;
+ (void)updateUploadTime:(NSArray *)ary;

+ (NSString *)applyForTime:(NSDate *)date;
+ (NSDate *)applyForTimeAndMin:(NSDate *)date;
+ (void)removeCacheData;

-(void)dump;

@end
