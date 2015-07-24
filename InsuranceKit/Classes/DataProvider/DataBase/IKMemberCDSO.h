//
//  IKMemberCDSO.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-30.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <CoreData/CoreData.h>

@class IKHospitalCDSO;

@interface IKMemberCDSO : NSManagedObject

@property (nonatomic) NSString *memberName,*memberID,*depID;
@property (nonatomic) NSDictionary *detailInfo;
@property (nonatomic) IKHospitalCDSO *hospital;

+ (IKMemberCDSO *)meberWithMemberID:(NSString *)mID depID:(NSString *)dID;

- (NSArray *)visitList;
- (NSArray *)recordPhotoList;
- (NSArray *)allcardPhotoList;
- (NSArray *)idcardPhotoList;
//- (NSArray *)allcardPhotoListAndOtherList;
- (NSArray *)insurancecardPhotoList;
@end
