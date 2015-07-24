//
//  IKDataProvider.h
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class IKVisitCDSO,IKHospitalCDSO;

@interface IKDataProvider : NSObject

//  登录
+ (NSDictionary *)login:(NSDictionary *)parameters;
//  通过输入账号和密码获取医院账号列表
+ (NSDictionary *)getAccountList:(NSDictionary *)parameters;
//  根据医院ID获取详细信息
+ (NSDictionary *)getProviderInfo:(NSDictionary *)parameters;
//  根据用户输入的日期，查询指定医院的所有自付额信息
+ (NSDictionary *)getCopayInfo:(NSDictionary *)parameters;
//  根据保险卡号或者被保险人id，获取被保险人基本信息
+ (NSDictionary *)getMemberInfo:(NSDictionary *)parameters;
//  获取就诊信息
+ (NSDictionary *)getVisitInfo:(NSDictionary *)parameters;
//根据被保险人id、附属人ID，获取就诊信息V2版本  替换原先V1版本 + (NSDictionary *)getVisitInfo:(NSDictionary *)parameters
+ (NSDictionary *)getVisitInfoV2:(NSDictionary *)parameters;
//  获取新闻
+ (NSDictionary *)getNews:(NSDictionary *)parameters;
//  修改密码
+ (NSDictionary *)updatePassword:(NSDictionary *)parameters;
//  获取版本信息
+ (NSDictionary *)getVersionInfo:(NSDictionary *)parameters;
//  回访客户登记表提交
+ (NSDictionary *)syncClientRecord:(NSDictionary *)parameters;
//  同步就诊信息到服务器
+ (NSDictionary *)syncVisitInfo:(NSDictionary *)parameters;
//  查询授权申请列表
+ (NSDictionary *)getAuthList:(NSDictionary *)parameters;
//  查询理赔申请列表
+ (NSDictionary *)getClaimList:(NSDictionary *)parameters;
//  查询理赔申请详情
+ (NSDictionary *)getClaimDetail:(NSDictionary *)parameters;
//  根据理赔号码获取病例照片
+ (NSDictionary *)getReportImage:(NSDictionary *)parameters;
//  提交理赔申请详情
+ (NSDictionary *)getClaimInsert:(NSDictionary *)parameters;
//  修改理赔申请详情
+ (NSDictionary *)getClaimUpdate:(NSDictionary *)parameters;
//  删除理赔申请详情
+ (NSDictionary *)getClaimDelete:(NSDictionary *)parameters;
//  查询就诊记录列表
+ (NSDictionary *)getMedicalRecordsList:(NSDictionary *)parameters;
// 获取理赔状态列表
+ (NSDictionary *)getClaimStateList:(NSDictionary *)parameters;
//  提交事先授权信息
+ (NSDictionary *)submitApply:(NSDictionary *)parameters;
//  修改事先授权信息
+ (NSDictionary *)modifyApply:(NSDictionary *)parameters;
//  上传图片
+ (NSDictionary *)syncPhoto:(NSDictionary *)parameters;
//  获取担保函信息
+ (NSDictionary *)getBackMailInfo:(NSDictionary *)parameters;
//  获取授权详细信息
+ (NSDictionary *)getAuthDetail:(NSDictionary *)parameters;
//  发送自付额统计邮件
+ (NSDictionary *)sendMail:(NSDictionary *)parameters;
//  删除授权申请
+ (NSDictionary *)deleteAuth:(NSDictionary *)parameters;
//  记录地理位置
+ (NSDictionary *)recordLocation:(NSDictionary *)parameters;
//  加密参数
+ (NSDictionary *)encryptParams:(NSArray *)params;

// 客户满意度调查提交
+ (NSDictionary *)customerSatisfaction:(NSDictionary *)parameters;

// 医院满意度调查提交
+ (NSDictionary *)hospitalSatisfaction:(NSDictionary *)parameters;

//  Local Data Provider
+ (NSDictionary *)currentHospitalInfo;
+ (void)saveHospitalInfo:(NSDictionary *)hospitalInfo;

+ (NSArray *)getLocalClientsList;
+ (NSArray *)getLocalPhotoListOfClient:(NSDictionary *)info;
+ (void)saveLocalPhoto:(UIImage *)photo ofClient:(NSDictionary *)info;
+ (void)addClient:(NSDictionary *)info;
+ (NSArray *)savedPhotos;
+ (void)savePhoto:(UIImage *)photo;

+ (NSString *)categoryName:(int)category;

//  添加上传就诊信息同步任务
+ (void)addVisitSyncTask:(NSDictionary *)task;
//  定时执行任务
+ (void)performSyncTask;
+ (NSDictionary *)performVisitSyncTaskOnce:(IKVisitCDSO *)visit;
//  添加需要删除的图片的流水号
+ (void)addDeletedPhotoSeqID:(NSString *)seqID;
////  添加需要上传的预授权申请
//+ (void)addAuthTask:(NSDictionary *)authInfo;

#pragma mark - Permissions
+ (BOOL)canEditPayment;
+ (BOOL)canEditApply;
+ (BOOL)canEditClaims;

//  Core Data
+ (void)removeCacheData;
+ (IKHospitalCDSO *)currentHospital;

+ (NSManagedObjectContext *)managedObjectContext;

@end
