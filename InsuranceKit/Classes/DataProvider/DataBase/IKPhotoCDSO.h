//
//  IKPhotoCDSO.h
//  InsuranceKit
//
//  Created by Stan Wu on 14-3-2.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*
 *
 *  图片类型 1--证件照；2--病历；3—-签名； 4--保险卡；  // 修改成：图片类型1---证件照；2—事先授权病历照；3—签名,4-在线理赔病历照 ,5-理赔拍摄付款明细，6-理赔拍摄其他

 *
 */

typedef enum {
    IKPhotoTypeIDCard=1,
    IKPhotoTypeRecords,
    IKPhotoTypeSignature,
    IKPhotoTypeInsuranceCard,
    IKPhotoTypeClaimClaimsPaymentList,
    IKPhotoTypeClaimClaimsOtherList,
    }IKPhotoType;

@class IKVisitCDSO;

@interface IKPhotoCDSO : NSManagedObject

@property (nonatomic) NSString *seqID;
@property (nonatomic) NSDate *createTime,*modifyTime;
@property (nonatomic) NSNumber *type,*uploaded;
@property (nonatomic) UIImage *image;

@property (nonatomic,readonly) NSString *createTimeString,*modifyTimeString;
@property (nonatomic,readonly) NSString *base64String;
@property (nonatomic) IKVisitCDSO *visit;

+ (IKPhotoCDSO *)photoWithSeqID:(NSString *)seq;
+ (NSArray *)allNotUploadedPhotosInfo;
//+ (NSArray *)allNotUploadedPhotos;
//+ (void)updateUploadedStatus:(NSArray *)ary;
+ (void)updateUploadedPhoto:(NSString *)photoID;


@end
