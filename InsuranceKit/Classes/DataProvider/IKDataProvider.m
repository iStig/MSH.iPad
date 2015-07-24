//
//  IKDataProvider.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-14.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKDataProvider.h"
#import "IKAppDelegate.h"
#import "IKPhotoCDSO.h"
#import "IKVisitCDSO.h"
#import "IKHospitalCDSO.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSData+CommonCrypto.h"

static IKDataProvider *sharedDataProvider;

@interface ASIFormDataRequest(IK)

- (void)appendParameters:(NSDictionary *)parameters;

@end

@implementation ASIFormDataRequest(IK)

- (void)appendParameters:(NSDictionary *)parameters{
    BOOL hasData = NO;
    NSArray *keys = parameters.allKeys;
    
    for (NSString *key in keys){
        if ([[parameters objectForKey:key] isKindOfClass:[NSData class]]){
            hasData = YES;
            break;
        }
    }

    for (NSString *key in keys){
        [self setPostValue:[parameters objectForKey:key] forKey:key];
    }
    

}

@end


@implementation IKDataProvider

static NSDictionary *apiInfo = nil;
static BOOL isData = NO;

+ (IKDataProvider *)sharedDataProvider{
    if (!sharedDataProvider)
        sharedDataProvider = [[super allocWithZone:NULL] init];
    
    return sharedDataProvider;
}

+ (id)allocWithZone:(NSZone *)zone{
    return [self sharedDataProvider];
}


+ (NSDictionary *)login:(NSDictionary *)parameters{
    NSDictionary *dict = [IKDataProvider getData:@"login" parameters:parameters];
    
    NSString *key = [dict objectForKey:@"key"];
    if (key){
        [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"access_token"];
    }
    
    return dict;
}

+ (NSDictionary *)getAccountList:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getAccountList" parameters:parameters];
}

+ (NSDictionary *)getProviderInfo:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getProviderInfo" parameters:parameters];
}

+ (NSDictionary *)getCopayInfo:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getCopayInfo" parameters:parameters];
}

//  根据保险卡号或者被保险人id，获取被保险人基本信息
+ (NSDictionary *)getMemberInfo:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getMemberInfo" parameters:parameters];
}

//  获取就诊信息
+ (NSDictionary *)getVisitInfo:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getVisitInfo" parameters:parameters];
}
//根据被保险人id、附属人ID，获取就诊信息V2版本  替换原先V1版本 + (NSDictionary *)getVisitInfo:(NSDictionary *)parameters
+ (NSDictionary *)getVisitInfoV2:(NSDictionary *)parameters{

 return [IKDataProvider getData:@"getVisitInfoV2" parameters:parameters];
}

//  获取新闻
+ (NSDictionary *)getNews:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getNews" parameters:parameters];
}

//  修改密码
+ (NSDictionary *)updatePassword:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"updatePassword" parameters:parameters];
}

//  获取版本信息
+ (NSDictionary *)getVersionInfo:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getVersionInfo" parameters:parameters];
}

//  回访客户登记表提交
+ (NSDictionary *)syncClientRecord:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"syncClientRecord" parameters:parameters];
}

//  同步就诊信息到服务器
+ (NSDictionary *)syncVisitInfo:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"syncVisitInfo" parameters:parameters];
}

//  查询授权申请列表
+ (NSDictionary *)getAuthList:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getAuthList" parameters:parameters];
}

//  查询理赔申请列表
+ (NSDictionary *)getClaimList:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getClaim" parameters:parameters];
}

//  查询理赔申请详情
+ (NSDictionary *)getClaimDetail:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"ClaimsDetail" parameters:parameters];
}

//  根据理赔号码获取病例照片
+ (NSDictionary *)getReportImage:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"ClaimsNoGetReportImage" parameters:parameters];
}



//  提交理赔申请详情
+ (NSDictionary *)getClaimInsert:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"ClaimsInsert" parameters:parameters];
}

//  修改理赔申请详情
+ (NSDictionary *)getClaimUpdate:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"ClaimsUpdate" parameters:parameters];
}

//  删除理赔申请详情
+ (NSDictionary *)getClaimDelete:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"ClaimsDelete" parameters:parameters];
}

//  查询就诊记录列表
+ (NSDictionary *)getMedicalRecordsList:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getMedicalRecords" parameters:parameters];
}

// 获取理赔状态列表
+ (NSDictionary *)getClaimStateList:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getClaimState" parameters:parameters];
}
//  提交事先授权信息
+ (NSDictionary *)submitApply:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"submitApply" parameters:parameters];
}

//  修改事先授权信息
+ (NSDictionary *)modifyApply:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"modifyApply" parameters:parameters];
}

//  上传图片
+ (NSDictionary *)syncPhoto:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"syncPhoto" parameters:parameters];
}

//  获取担保函信息
+ (NSDictionary *)getBackMailInfo:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getBackMailInfo" parameters:parameters];
}

//  获取授权详细信息
+ (NSDictionary *)getAuthDetail:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"getAuthDetail" parameters:parameters];
}

//  发送自付额统计邮件
+ (NSDictionary *)sendMail:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"sendMail" parameters:parameters];
}

//  删除授权申请
+ (NSDictionary *)deleteAuth:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"deleteAuth" parameters:parameters];
}

//  记录地理位置
+ (NSDictionary *)recordLocation:(NSDictionary *)parameters{
    return [IKDataProvider getData:@"recordLocation" parameters:parameters];
}

// 客户满意度调查提交
+ (NSDictionary *)customerSatisfaction:(NSDictionary *)parameters{
   return [IKDataProvider getData:@"customerSatisfaction" parameters:parameters];
}
// 医院满意度调查提交
+ (NSDictionary *)hospitalSatisfaction:(NSDictionary *)parameters{
   return [IKDataProvider getData:@"hospitalSatisfaction" parameters:parameters];
    
}

#pragma mark - Basic Methods
+ (NSDictionary *)apiInfo{
    if (apiInfo)
        return apiInfo;
    else{
        apiInfo = [NSDictionary dictionaryWithContentsOfFile:[@"api.plist" bundlePath]];
        return apiInfo;
    }
}

+ (NSString *)paramString:(NSDictionary *)parameters{
    NSArray *keys = parameters.allKeys;
    NSMutableString *mutstr = [NSMutableString string];
    
    for (int i=0;i<keys.count;i++){
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [parameters objectForKey:key];
        
        value = [value URLEncode];
        [mutstr appendFormat:@"&%@=%@",[keys objectAtIndex:i],value];
    }
    
    BOOL isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
    if (isInLocal)
        [mutstr appendString:@"&internetType=1"];
    
    
    
    return mutstr;
}

+ (NSDictionary *)getData:(NSString *)api parameters:(NSDictionary *)parameters{
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    
    
    NSMutableArray *toencryptkeys = [NSMutableArray array];
    NSMutableArray *toencryptvalues = [NSMutableArray array];
    for (NSString *key in parameters.allKeys){
        
        
        if ([key isEqualToString:@"data"]) {//当key中存在  data时候
      
            NSMutableArray *datatoencryptkeys = [NSMutableArray array];
            NSMutableArray *datatoencryptvalues = [NSMutableArray array];
            
            NSMutableDictionary *value_data_dic = [[parameters objectForKey:key]  objectAtIndex:0];
            NSMutableDictionary *mut_dic = [NSMutableDictionary dictionaryWithDictionary:value_data_dic];

            
            for (NSString *key_data in value_data_dic.allKeys){

                
                NSString *value_data = [value_data_dic objectForKey:key_data];
                
//                if ([IKAppDelegate isTestVersion]){
                    NSSet *encrypt = [NSSet setWithArray:[@"providerid,userid,cardno,memberid,depid,caseid,visitid,claimsno,seqid" componentsSeparatedByString:@","]];
                    
                    if ([encrypt containsObject:[key_data lowercaseString]]) {
                        NSLog(@"yes");
                    }
                    
                    if (([encrypt containsObject:[key_data lowercaseString]] || [[key_data lowercaseString] rangeOfString:@"id"].location!=NSNotFound) && [value_data length]>0){
                        [datatoencryptkeys addObject:key_data];
                        [datatoencryptvalues addObject:value_data];
                    }
               
               // }
                
            }
            
            
            if ([datatoencryptkeys count]>0){
                
        
                
                NSArray *encryptedValues = [IKDataProvider encryptedParams:datatoencryptvalues];
                for (int i=0;i<encryptedValues.count;i++){
                    NSString *key_encrypt = [datatoencryptkeys objectAtIndex:i];
                    NSString *value_encrypt = [encryptedValues objectAtIndex:i];
                    [mut_dic setObject:value_encrypt forKey:key_encrypt];
                }
                
                
                
                [mut setObject:@[mut_dic] forKey:@"data"];
                
            }

            

        }
        else{
        NSString *value = [parameters objectForKey:key];
        
//        if ([IKAppDelegate isTestVersion]){
            NSSet *encrypt = [NSSet setWithArray:[@"providerid,userid,cardno,memberid,depid,caseid,visitid,claimsno,seqid" componentsSeparatedByString:@","]];
            
            if ([encrypt containsObject:[key lowercaseString]]) {
                NSLog(@"yes");
            }
            
            if (([encrypt containsObject:[key lowercaseString]] || [[key lowercaseString] rangeOfString:@"id"].location!=NSNotFound) && [value length]>0){
                [toencryptkeys addObject:key];
                [toencryptvalues addObject:value];
            }
//                value = [IKDataProvider encryptedParam:value];
       // }
        
//        [mut setObject:value forKey:key];
        
    }
}
    
    
    if ([toencryptkeys count]>0){
        
    NSArray *encryptedValues = [IKDataProvider encryptedParams:toencryptvalues];
    for (int i=0;i<encryptedValues.count;i++){
        NSString *key = [toencryptkeys objectAtIndex:i];
        NSString *value = [encryptedValues objectAtIndex:i];
        [mut setObject:value forKey:key];
    }
}
    
    
    
    
    NSString *access_token = nil;
    if (![api isEqualToString:@"login"]){
        access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    }

    NSDictionary *not_encrypted = parameters;
    parameters = [NSDictionary dictionaryWithDictionary:mut];
    
    if ([InternationalControl isEnglish]){
        NSMutableDictionary *mutmut = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [mutmut setObject:@"1" forKey:@"language"];
        parameters = [NSDictionary dictionaryWithDictionary:mutmut];
    }
    
    
    BOOL isInLocal,isInTest;
    if ([IKAppDelegate isTestVersion]){
        isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
        isInTest = YES;
    }else{
        isInLocal = NO;
        isInTest = NO;
    }
    
    
    NSString *baseURL = [[IKDataProvider apiInfo] objectForKey:isInTest?(isInLocal?@"baseURLInner":@"baseURL"):@"baseURLFinal"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",baseURL,[[IKDataProvider apiInfo] objectForKey:api],(access_token?[NSString stringWithFormat:@"?key=%@",access_token]:@"")]];
    NSData *responseData = nil;
    
    
    ASIHTTPRequest *request = nil;

    if ([api isEqualToString:@"syncVisitInfo"] || [api isEqualToString:@"submitApply"] || [api isEqualToString:@"syncClientRecord"] ||
        [api isEqualToString:@"syncPhoto"] || [api isEqualToString:@"modifyApply"] || [api isEqualToString:@"encryptParmas"]|| [api isEqualToString:@"customerSatisfaction"]|| [api isEqualToString:@"hospitalSatisfaction"]||[api isEqualToString:@"ClaimsInsert"]||[api isEqualToString:@"ClaimsUpdate"]){
        if ([parameters objectForKey:@"language"]){
            NSMutableDictionary *mutparam = [NSMutableDictionary dictionaryWithDictionary:parameters];
            [mutparam removeObjectForKey:@"language"];
            parameters = [NSDictionary dictionaryWithDictionary:mutparam];
        }
       // parameters = [IKDataProvider encryptDictionary:not_encrypted];
        
        request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setValidatesSecureCertificate:NO];
        [request setDidFailSelector:@selector(requestFailed:)];
        request.timeOutSeconds = 30;
        [request setDelegate:[IKDataProvider sharedDataProvider]];
        [request setRequestMethod:@"POST"];
        [request addRequestHeader:@"Accept-Encoding" value:@"gzip"];
        [request addRequestHeader:@"Cache-Control" value:@"no-cache"];
        [request addRequestHeader:@"Content-Type" value:@"application/json;charset=utf8"];
        [request appendPostData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
        [request startSynchronous];
        
        responseData = [request responseData];
    }else{
        request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setDelegate:[IKDataProvider sharedDataProvider]];
        [request setDidFailSelector:@selector(requestFailed:)];
        request.timeOutSeconds = 30;
        [request setValidatesSecureCertificate:NO];
        [request addRequestHeader:@"Accept-Encoding" value:@"gzip"];
        [request addRequestHeader:@"Cache-Control" value:@"no-cache"];
        [(ASIFormDataRequest *)request appendParameters:parameters];
        [request startSynchronous];
        responseData = [request responseData];
    }

    NSError *error = nil;
    
    [request setTimeOutSeconds:60];
    
    if (!responseData) {
        return  nil;
    }
    NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    if (error){
        NSLog(@"Parse Json Error:%@",error);
        NSLog(@"API:%@,Response String:%@",api,[request responseString]);
//        NSString *responseString= [request responseString];
//        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//        
//        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        
//        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        
//        NSLog(@"responseString = %@",responseString);
    }
    else{
        int result = [[dict objectForKey:@"result"] intValue];
        if (3==result){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InvalidKey" object:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
        }
        
        return dict;
    }
    
    
    return nil;
}

+ (NSDictionary *)getData:(NSString *)api parameters:(NSDictionary *)parameters encrypt:(BOOL)encrypt{
    if (encrypt){
        NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:parameters];
        
        
        
        NSMutableArray *toencryptkeys = [NSMutableArray array];
        NSMutableArray *toencryptvalues = [NSMutableArray array];
        for (NSString *key in parameters.allKeys){
            NSString *value = [parameters objectForKey:key];
            
         //   if ([IKAppDelegate isTestVersion]){
                NSSet *encrypt = [NSSet setWithArray:[@"providerid,userid,cardno,memberid,depid,caseid,visitid,claimsno,seqid" componentsSeparatedByString:@","]];
                
                if (([encrypt containsObject:[key lowercaseString]] || [[key lowercaseString] rangeOfString:@"id"].location!=NSNotFound)&& [value length]>0){
                    [toencryptkeys addObject:key];
                    [toencryptvalues addObject:value];
                }
                //                value = [IKDataProvider encryptedParam:value];
           // }
            
            //        [mut setObject:value forKey:key];
        }
        
        NSArray *encryptedValues = [IKDataProvider encryptedParams:toencryptvalues];
        for (int i=0;i<encryptedValues.count;i++){
            NSString *key = [toencryptkeys objectAtIndex:i];
            NSString *value = [encryptedValues objectAtIndex:i];
            [mut setObject:value forKey:key];
        }
        
        parameters = [NSDictionary dictionaryWithDictionary:mut];
    }
    
    
    
    NSString *access_token = nil;
    if (![api isEqualToString:@"login"]){
        access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    }
    
    
    
    
    BOOL isInLocal,isInTest;
    if ([IKAppDelegate isTestVersion]){
        isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
        isInTest = YES;
    }else{
        isInLocal = NO;
        isInTest = NO;
    }
    
    
    NSString *baseURL = [[IKDataProvider apiInfo] objectForKey:isInTest?(isInLocal?@"baseURLInner":@"baseURL"):@"baseURLFinal"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",baseURL,[[IKDataProvider apiInfo] objectForKey:api],(access_token?[NSString stringWithFormat:@"?key=%@",access_token]:@"")]];
    NSData *responseData = nil;
    
    
    ASIHTTPRequest *request = nil;
    
    
    if ([api isEqualToString:@"syncVisitInfo"] || [api isEqualToString:@"submitApply"] || [api isEqualToString:@"syncClientRecord"] ||
        [api isEqualToString:@"syncPhoto"] || [api isEqualToString:@"modifyApply"] || [api isEqualToString:@"encryptParmas"]){
        request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setValidatesSecureCertificate:NO];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDelegate:[IKDataProvider sharedDataProvider]];
        request.timeOutSeconds = 30;
        [request setRequestMethod:@"POST"];
        [request addRequestHeader:@"Accept-Encoding" value:@"gzip"];
        [request addRequestHeader:@"Cache-Control" value:@"no-cache"];
        [request addRequestHeader:@"Content-Type" value:@"application/json;charset=utf8"];
        [request appendPostData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
        [request startSynchronous];
        responseData = [request responseData];
    }else{
        request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setValidatesSecureCertificate:NO];
        request.timeOutSeconds = 30;
        [request setDidFailSelector:@selector(requestFailed:)];
        [request setDelegate:[IKDataProvider sharedDataProvider]];
        [request addRequestHeader:@"Accept-Encoding" value:@"gzip"];
        [request addRequestHeader:@"Cache-Control" value:@"no-cache"];
        [(ASIFormDataRequest *)request appendParameters:parameters];
        [request startSynchronous];
        responseData = [request responseData];
    }
    
    
    
    
    
    NSError *error = nil;
    if (!responseData) {
        return  nil;
    }
    NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    if (error){
        NSLog(@"Parse Json Error:%@",error);
        NSLog(@"API:%@,Response String:%@",api,[request responseString]);
    }
    else{
        int result = [[dict objectForKey:@"result"] intValue];
        if (3==result){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"InvalidKey" object:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
        }
        
        return dict;
    }
    
    
    return nil;
}

#pragma mark -  Request Failed Handle
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"ASIHttpRequest Error:%@",error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkFailed" object:nil];
}


#pragma mark - Local Data Provider
+ (NSDictionary *)currentHospitalInfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentHospitalInfo"];
}

+ (void)saveHospitalInfo:(NSDictionary *)hospitalInfo{
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentHospitalInfo"]];
    
    [mut setValuesForKeysWithDictionary:hospitalInfo];
    
    [[NSUserDefaults standardUserDefaults] setObject:mut forKey:@"CurrentHospitalInfo"];
}

+ (NSArray *)getLocalClientsList{
    NSString *path = [@"ClientsList.plist" documentPath];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
//        [[NSFileManager defaultManager] copyItemAtPath:[@"ClientsList.plist" bundlePath] toPath:path error:nil];
    
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSArray *)getLocalPhotoListOfClient:(NSDictionary *)info{
    NSArray *photolist = [info objectForKey:@"photolist"];
    
    return photolist;
}

+ (void)updateClientInfo:(NSDictionary *)info{
    NSMutableArray *clients = [NSMutableArray arrayWithArray:[IKDataProvider getLocalClientsList]];
    BOOL bFinded = NO;
    for (NSDictionary *client in clients){
        if ([[client objectForKey:@"visitID"] intValue]==[[info objectForKey:@"visitID"] intValue]){
            [clients replaceObjectAtIndex:[clients indexOfObject:client] withObject:info];
            bFinded = YES;
            break;
        }
    }
    if (!bFinded)
        [clients addObject:info];
    
    [clients writeToFile:[@"ClientsList.plist" documentPath] atomically:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshVisitClientList" object:nil];
}

+ (void)saveLocalPhoto:(UIImage *)photo ofClient:(NSDictionary *)info{
    NSDate *saveDate = [NSDate date];
    NSString *filename = [NSString stringWithFormat:@"%.2lf",[saveDate timeIntervalSince1970]];
    
    [UIImagePNGRepresentation(photo) writeToFile:[filename imageCachePath] atomically:YES];
    [UIImagePNGRepresentation([photo resizedGrayscaleImage:CGSizeMake(photo.size.width/10, photo.size.height/10)]) writeToFile:[[filename stringByAppendingString:@"_thumbnail"] imageCachePath] atomically:YES];
    
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:info];
    NSMutableArray *mutary = [NSMutableArray arrayWithArray:[info objectForKey:@"photolist"]];
    [mutary addObject:[NSDictionary dictionaryWithObjectsAndKeys:saveDate,@"time",filename,@"path", nil]];
    [mut setObject:mutary forKey:@"photolist"];
    
    [IKDataProvider updateClientInfo:mut];
}

+ (void)addClient:(NSDictionary *)info{
    [IKDataProvider updateClientInfo:info];
}

+ (NSArray *)savedPhotos{
    NSArray *ary = [NSArray arrayWithContentsOfFile:[@"LocalPhotos.plist" documentPath]];
    
    return ary;
}

+ (void)savePhoto:(UIImage *)photo{
    NSDate *saveDate = [NSDate date];
    NSString *filename = [NSString stringWithFormat:@"%.2lf",[saveDate timeIntervalSince1970]];
    
    [UIImagePNGRepresentation(photo) writeToFile:[filename imageCachePath] atomically:YES];
    [UIImagePNGRepresentation([photo resizedGrayscaleImage:CGSizeMake(photo.size.width/10, photo.size.height/10)]) writeToFile:[[filename stringByAppendingString:@"_thumbnail"] imageCachePath] atomically:YES];
    
    NSMutableArray *ary = [NSMutableArray arrayWithArray:[IKDataProvider savedPhotos]];
    [ary addObject:filename];
    
    [ary writeToFile:[@"LocalPhotos.plist" documentPath] atomically:YES];
}

+ (NSString *)categoryName:(int)category{
  //  NSArray *names = [@"门诊检查/手术,住院治疗/手术,生育,耐用型医疗设备,化学治疗,放射治疗,理疗,其他" componentsSeparatedByString:@","];
    
       NSArray *names  = @[LocalizeStringFromKey(@"kOutpatientExam/Surgery"),
                           LocalizeStringFromKey(@"kInpatientTreatmentSurgery"),
                           LocalizeStringFromKey(@"kDelivery"),
                           LocalizeStringFromKey(@"kDurableMedicalEquipment"),
                           LocalizeStringFromKey(@"kChemotherapy"),
                           LocalizeStringFromKey(@"kRadiotherapy"),
                           LocalizeStringFromKey(@"kTherapy"),
                           LocalizeStringFromKey(@"kOthers")];
    if (category==0)
        category = 7;
    
    if (category-1<names.count && category>=1)
        return [names objectAtIndex:category-1];
    else
        return [NSString stringWithFormat:@"%d",category];
}

//  添加上传就诊信息同步任务
+ (void)addVisitSyncTask:(NSDictionary *)task{
    NSMutableArray *ary = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"VisitSyncTask"]];
    [ary addObject:task];
    [[NSUserDefaults standardUserDefaults] setObject:ary forKey:@"VisitSyncTask"];
}


//  定时执行任务
+ (void)performSyncTask{
    [IKDataProvider performVistAndImageSyncTask];
//    [IKDataProvider performUploadAuthTask];
}



+ (void)performVistAndImageSyncTask{
    //  Upload Photo
    NSArray __block *photos = nil;
    sw_dispatch_sync_on_main_thread(^{
        photos = [IKPhotoCDSO allNotUploadedPhotosInfo];
    });
    
    if (photos.count>0){
        for (int i=0;i<photos.count;i++){
            @autoreleasepool {
                NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:[photos objectAtIndex:i]];
                
                NSString *seqID = [mut objectForKey:@"seqID"];
                
                NSString *base64String = [[NSData dataWithContentsOfFile:[seqID imageCachePath]] base64Encoding];
                if (base64String){
                    [mut setObject:base64String forKey:@"photoPath"];
                    
                    BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@[mut],@"data",@"1",@"count",(isInLocal?@"1":@"0"),@"internetType", nil];
                    
                    NSDictionary *dict = [IKDataProvider syncPhoto:param];
                    
                    NSString *result = [dict objectForKey:@"result"];
                    if (result && result.intValue==0){
                        //  成功上传
                        NSLog(@"上传图片成功");
                        sw_dispatch_sync_on_main_thread(^{
                            [IKPhotoCDSO updateUploadedPhoto:seqID];
                        });
                    }else{
                        NSLog(@"上传图片失败:%@",[dict objectForKey:@"errStr"]);
                    }
                }
            }
        }
        
        
    }
    
    //  Upload Visit
    NSArray __block *visits = nil;
    sw_dispatch_sync_on_main_thread(^{
        visits = [IKVisitCDSO allNotUpdatedVisitInfo];
    });
    
    if (visits.count>0){
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:visits,@"data",[NSString stringWithFormat:@"%d",(int)visits.count],@"count", nil];
        
        NSDictionary *dict = [IKDataProvider syncVisitInfo:param];
        
        NSString *result = [dict objectForKey:@"result"];
        if (result && result.intValue==0){
            //  成功上传
            NSLog(@"上传就诊成功");
            sw_dispatch_sync_on_main_thread(^{
                [IKVisitCDSO updateUploadTime:visits];
            });
        }else{
            NSLog(@"上传就诊信息失败:%@",[dict objectForKey:@"errStr"]);
        }
    }
}

+ (void)performSyncContactInfoSyncTask{
    NSArray *ary = [[NSUserDefaults standardUserDefaults] objectForKey:@"FailLogContactInfo"];
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:ary,@"data",[NSString stringWithFormat:@"%d",ary.count],@"count", nil];
    
    NSDictionary *dict = [IKDataProvider syncClientRecord:info];
    int result = [[dict objectForKey:@"result"] intValue];
    if (0==result && dict){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FailLogContactInfo"];
    }
}

//  即时提交一条就诊信息
+ (NSDictionary *)performVisitSyncTaskOnce:(IKVisitCDSO *)visit{
    
//    BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];   ,(isInLocal?@"1":@"0"),@"internetType"
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@[visit.visitInfo],@"data",@"1",@"count",nil];
    
    NSDictionary *dict = [IKDataProvider syncVisitInfo:param];
    
    return dict;
}

//  添加需要删除的图片的流水号
+ (void)addDeletedPhotoSeqID:(NSString *)seqID{
    NSMutableArray *ary = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"DeletedPhotos"]];
    [ary addObject:seqID];
    
    [[NSUserDefaults standardUserDefaults] setObject:ary forKey:@"DeletedPhotos"];
}

//+ (void)addAuthTask:(NSDictionary *)authInfo{
//    NSMutableArray *ary = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"AuthorizationTasks"]];
//    [ary addObject:authInfo];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:ary forKey:@"AuthorizationTasks"];
//}
/*
+ (void)performUploadAuthTask{
    NSMutableArray *mut = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"AuthorizationTasks"]];
    NSArray *ary = [NSArray arrayWithArray:mut];
    
    for (int i=ary.count-1;i>=0;i--){
        NSDictionary *authInfo = [ary objectAtIndex:i];
        NSString *visitID = [authInfo objectForKey:@"visitID"];
        NSArray *reportImages = [authInfo objectForKey:@"reportImages"];
        
        for (NSDictionary *imgInfo in reportImages){
            NSString *seqID = [imgInfo objectForKey:@"seqID"];
            BOOL  isInLocal = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsInLocal"];
            
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@[imgInfo],@"data",@"1",@"count",(isInLocal?@"1":@"0"),@"internetType", nil];

            NSDictionary *dict = [IKDataProvider syncPhoto:param];
            NSString *result = [dict objectForKey:@"result"];
            int j = i+1;
            if (result && result.intValue==0){
                //  成功上传
                NSLog(@"上传第 %d 张图片成功",j);
                
                //    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传第 %d 张图片成功",j]];
                
                sw_dispatch_sync_on_main_thread(^{
                    
                    IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];//查看coredata看看是否存在图片 如果存在只修改modifyTime
                    if (!photo){
                        
                        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[IKDataProvider managedObjectContext]];//添加图片
                        photo.seqID = seqID;
                        photo.visit = [IKVisitCDSO vistWithID:visitID];
                        photo.createTime = [NSDate date];
                        
                        NSString *photoPath = [imgInfo objectForKey:@"photoPath"];
                        NSData *data = [NSData dataWithBase64EncodedString:photoPath];
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        
                        photo.image = img;
                        photo.type = [NSNumber numberWithInt:IKPhotoTypeRecords];
                        
                    }
                    
                    photo.modifyTime = [NSDate date];
                    //                            if (!photo.visit.hospital){
                    //                                return ;
                    //                            }
                    
                });
                
                
                
            }else{
                //   [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]]];
                NSLog(@"上传第 %d 张图片失败:%@",j,[dict objectForKey:@"errStr"]);
                
            }
        }
        
        NSDictionary *dict = [IKDataProvider submitApply:authInfo];
        sw_dispatch_sync_on_main_thread(^{
            int result = [[dict objectForKey:@"result"] intValue];
            if (0==result && dict){
                for (NSDictionary *imgInfo in reportImages){
                    NSString *seqID = [imgInfo objectForKey:@"seqID"];
                    IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
                    if (photo)
                        photo.uploaded = [NSNumber numberWithBool:YES];
                    
                    [mut removeObjectAtIndex:i];
                }
            }else{
                for (NSDictionary *imgInfo in reportImages){
                    NSString *seqID = [imgInfo objectForKey:@"seqID"];
                    IKPhotoCDSO *photo = [IKPhotoCDSO photoWithSeqID:seqID];
                    if (photo)
                        photo.uploaded = [NSNumber numberWithBool:NO];
                }
            }
            
            NSError *error = nil;
            [[IKDataProvider managedObjectContext] save:&error];
        });
    }
    
   if ([mut count]>0)
       [[NSUserDefaults standardUserDefaults] setObject:ary forKey:@"AuthorizationTasks"];
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AuthorizationTasks"];
}
 */

//  登录其他医院后，删除以前其他医院的数据
+ (void)removeCacheData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EmailReceiver"];
    
    NSArray *ary = [IKHospitalCDSO otherHospitals];
    for (IKHospitalCDSO *hos in ary)
        [hos remove];
}

#pragma mark - Permissions
+ (BOOL)canEditPayment{
    NSString *permission = [[IKDataProvider currentHospitalInfo] objectForKey:@"permission"];
    
    return permission?[permission rangeOfString:@"3"].location!=NSNotFound:NO;
}

+ (BOOL)canEditApply{
    NSString *permission = [[IKDataProvider currentHospitalInfo] objectForKey:@"permission"];
    
    return permission?[permission rangeOfString:@"2"].location!=NSNotFound:NO;
}


+ (BOOL)canEditClaims{
    NSString *permission = [[IKDataProvider currentHospitalInfo] objectForKey:@"permission"];
    return permission?[permission rangeOfString:@"4"].location!=NSNotFound:NO;
}


//  Core Data
+ (IKHospitalCDSO *)currentHospital{
    return [IKHospitalCDSO hospitalWithProviderID:[[IKDataProvider currentHospitalInfo] objectForKey:@"providerID"]];
}

+ (NSManagedObjectContext *)managedObjectContext{
    IKAppDelegate *appdelegate = (IKAppDelegate *)[UIApplication sharedApplication].delegate;

    NSAssert([[NSThread currentThread] isMainThread],@"Core Data Must Be On Main Thread");
    
    return appdelegate.managedObjectContext;
}

#pragma mark - AES Encrypt
+ (NSArray *)encryptedParams:(NSArray *)params{
    NSDictionary *newparams = [NSDictionary dictionaryWithObject:params forKey:@"list"];
    NSDictionary *dict = [IKDataProvider getData:@"encryptParmas" parameters:newparams encrypt:NO];
    NSArray *ary = [dict objectForKey:@"list"];
    
    return ary;
}

+ (NSDictionary *)encryptDictionary:(NSDictionary *)parameters{
    NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSMutableArray *toencryptkeys = [NSMutableArray array];
    NSMutableArray *toencryptvalues = [NSMutableArray array];
    
    for (NSString *key in parameters.allKeys){
        NSString *value = [parameters objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]])
            value = (NSString *)[IKDataProvider encryptDictionary:(NSDictionary *)value];
        else if ([value isKindOfClass:[NSArray class]])
            value = (NSString *)[IKDataProvider encryptArray:(NSArray *)value];
        [mut setObject:value forKey:key];

        
    //    if ([IKAppDelegate isTestVersion]){
            NSSet *encrypt = [NSSet setWithArray:[@"providerid,userid,cardno,memberid,depid,caseid,visitid,claimsno,seqid" componentsSeparatedByString:@","]];
            
            if (([encrypt containsObject:[key lowercaseString]] || [[key lowercaseString] rangeOfString:@"id"].location!=NSNotFound)&& [value length]>0){
                [toencryptkeys addObject:key];
                [toencryptvalues addObject:value];
            }
            //                value = [IKDataProvider encryptedParam:value];
       // }
        
        //        [mut setObject:value forKey:key];
    }
    
    NSArray *encryptedValues = [IKDataProvider encryptedParams:toencryptvalues];
    for (int i=0;i<encryptedValues.count;i++){
        NSString *key = [toencryptkeys objectAtIndex:i];
        NSString *value = [encryptedValues objectAtIndex:i];
        [mut setObject:value forKey:key];
    }
    
    parameters = [NSDictionary dictionaryWithDictionary:mut];
    
    return parameters;
}

+ (NSArray *)encryptArray:(NSArray *)parameters{
    NSMutableArray *mut = [NSMutableArray array];

    for (int i=0;i<parameters.count;i++){
        NSString *value = [parameters objectAtIndex:i];
        if ([value isKindOfClass:[NSDictionary class]])
            [mut addObject:[IKDataProvider encryptDictionary:(NSDictionary *)value]];
        else if ([value isKindOfClass:[NSArray class]])
            [mut addObject:[IKDataProvider encryptArray:(NSArray *)value]];
        else
            [mut addObject:value];
    }
    
    return [NSArray arrayWithArray:mut];
}



@end
