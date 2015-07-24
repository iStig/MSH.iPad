//
//  IKAppDelegate.m
//  InsuranceKit
//
//  Created by Stan Wu on 13-11-9.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "IKAppDelegate.h"
#import "IKDataProvider.h"
#import "RedLaserSDK.h"
#import "IKGuideViewController.h"

@implementation IKAppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
  //  [InternationalControl initUserLanguage];//初始化应用语言
    
    if ([[InternationalControl userLanguage] length]>0) {
        [InternationalControl setUserlanguage:[InternationalControl userLanguage] ];
    }
    else{
        [InternationalControl setUserlanguage:@"zh-Hans"];
    }
    
    invalidKeyDetected = NO;
    // Override point for customization after application launch.
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:.13 alpha:1] size:CGSizeMake(1024, 44)] forBarMetrics:UIBarMetricsDefault];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.clipsToBounds = YES;
    

    
    vcLogin = [[IKLoginViewController alloc] init];
    vcLogin.delegate = self;

    

    
    BOOL guideShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"GuideShown"];
    if (guideShown){
        window.rootViewController = vcLogin;
        if ([IKAppDelegate isTestVersion]){
            UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:LocalizeStringFromKey(@"KChoosenetwork") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"KInterNetwork"),LocalizeStringFromKey(@"KInternetNetwork"), nil];
            [alert show];
        }
    }else{
        IKGuideViewController *vcGuide = [[IKGuideViewController alloc] init];
        window.rootViewController = vcGuide;
    }
    
    [window makeKeyAndVisible];
    
//    if (guideShown && [IKAppDelegate isTestVersion]){
//        UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:LocalizeStringFromKey(@"KChoosenetwork") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"KInterNetwork"),LocalizeStringFromKey(@"KInternetNetwork"), nil];
//        [alert show];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeLanguge object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:kChangeLanguge object:nil];
    
    
//    [self performSyncTask];
//    [NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(performSyncTask) userInfo:nil repeats:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"LogoutAccount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invalidKey) name:@"InvalidKey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkFailed) name:@"NetworkFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideRemoved) name:@"GuideRemoved" object:nil];
    [self getLocation];
    

    NSLog(@"License Status:%d",RL_CheckReadyStatus());
    
    return YES;
}

- (void)guideRemoved{
    window.rootViewController = vcLogin;
    if ([IKAppDelegate isTestVersion]){
        UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:LocalizeStringFromKey(@"KChoosenetwork") message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:LocalizeStringFromKey(@"KInterNetwork"),LocalizeStringFromKey(@"KInternetNetwork"), nil];
        [alert show];
    }
}

- (void)showGuideView{
    IKGuideViewController *vcGuide = [[IKGuideViewController alloc] init];
    [window.rootViewController presentViewController:vcGuide animated:NO completion:nil];
}


- (void)changeLanguage:(NSNotification *)notification
{
    
        
    
}

- (void)invalidKey{
    if (!invalidKeyDetected){
        invalidKeyDetected = YES;
        sw_dispatch_sync_on_main_thread(^{
            [self logout];
            
            [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kTimeoutpleasesigninagain") cancelButton:nil];
        });
    }
    
    
}

- (void)networkFailed{
    if (!networkFailed){
        networkFailed = YES;
        sw_dispatch_sync_on_main_thread(^{
            [UIAlertView showAlertWithTitle:nil message:LocalizeStringFromKey(@"kNetworkFailed") cancelButton:nil];
        });
    }
}

+ (BOOL)isTestVersion{
    return YES;
}

- (void)logout{
    if (![window.rootViewController isKindOfClass:[IKLoginViewController class]]){
        vcLogin = [[IKLoginViewController alloc] init];
        vcLogin.delegate = self;
        window.rootViewController = vcLogin;
    }
}

- (UIImagePickerController *)imagePicker{
    if (!imagePicker){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    return imagePicker;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"KInterNetwork")]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsInLocal"];
    }else if ([buttonTitle isEqualToString:LocalizeStringFromKey(@"KInternetNetwork")]){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsInLocal"];
    }
    
    if ([[alertView message] isEqualToString:LocalizeStringFromKey(@"kNetworkFailed")]){
        networkFailed = NO;
    }
}

- (void)performSyncTask{
    sw_dispatch_async_on_background_thread(^{
        @autoreleasepool {
            [IKDataProvider performSyncTask];
        }
    });
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
-(void)uploadSuccess{
    UIApplication *application =[UIApplication sharedApplication];
    [application endBackgroundTask:_bgTask];
    _bgTask = UIBackgroundTaskInvalid;
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSuccess) name:@"RefreshNotSubmitClaimsApplyList" object:nil];
    NSDate *nowDate =[NSDate date];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:nowDate forKey:@"date"];
    [defaults synchronize];
    
//    __block UIBackgroundTaskIdentifier bgTask1;// 后台任务标识
    
    // 结束后台任务
//    void (^endBackgroundTask)() = ^(){
//        [application endBackgroundTask:bgTask1];
//        bgTask1 = UIBackgroundTaskInvalid;
//    };
    _bgTask = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{ // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        NSLog(@"------11111");
        
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       // Do the work associated with the task, preferably in chunks.
//                       while ([[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults]objectForKey:@"date"]]<100) {
//                           NSLog(@"<30");
//                           [NSThread sleepForTimeInterval:1];
//                       }
                       
                   });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshNotSubmitClaimsApplyList" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSDate *last = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastLoginTime"];
    NSDate *now = [NSDate date];
    
    if ((!last || [now timeIntervalSinceDate:last]>3600) && ![window.rootViewController isKindOfClass:[IKGuideViewController class]]){
        vcLogin = [[IKLoginViewController alloc] init];
        vcLogin.delegate = self;
        window.rootViewController = vcLogin;
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

#pragma mark - IKLoginViewControllerDelegate
- (void)accountDidLogin{
    [IKDataProvider removeCacheData];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastLoginTime"];
    
    vcHome = [[IKHomeViewController alloc] init];
    window.rootViewController = vcHome;
}

#pragma mark Core Data stack
- (NSManagedObjectModel *)managedObjectModel
{
	if (managedObjectModel!= nil) {
        return managedObjectModel;
    }
    
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[@"IKDataBase.momd" bundlePath]]];
    
    return managedObjectModel;
}





/**
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and the application's store added to it.
 **/
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

	NSString *storePath = [@"DataBase.sqlite" temporaryPath];
    
    
    
    
    
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    
    
    
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
	
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,nil];
    
	NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
	                                                                              configuration:nil
	                                                                                        URL:storeURL
	                                                                                    options:options
	                                                                                      error:&error];
    
    
    if (!persistentStore){
        if ([[NSFileManager defaultManager] fileExistsAtPath:storePath])
            [[NSFileManager defaultManager] removeItemAtPath:storePath error:nil];
        persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                   configuration:nil
                                                                             URL:storeURL
                                                                         options:options
                                                                           error:&error];

        if (!persistentStore)
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
	
    return persistentStoreCoordinator;
}

/**
 * Returns the managed object context for the application.
 * If the context doesn't already exist, it is created and
 * bound to the persistent store coordinator for the application.
 **/
- (NSManagedObjectContext *)managedObjectContext{
    if (managedObjectContext!=nil)
        return managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

#pragma mark - Location Services
- (void)getLocation{
    BOOL bGPSEnabled = [CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus gpsStatus = [CLLocationManager authorizationStatus];
    
    BOOL bCanStartGPS = NO;
    NSString *msg = nil;
    switch (gpsStatus) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusAuthorized:
            bCanStartGPS = YES;
            break;
        case kCLAuthorizationStatusDenied:
            bCanStartGPS = !bGPSEnabled;
            if (!bCanStartGPS)
                msg = @"请在\"设置\"中允许本程序获取GPS地理位置信息";
            break;
        case kCLAuthorizationStatusRestricted:
            msg = @"地理位置服务被限制使用，将无法查找周围的异性";
            break;
        default:
            break;
    }
    
    if (bCanStartGPS){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 100;
        
        [locationManager startUpdatingLocation];
    }else
        [UIAlertView showAlertWithTitle:nil message:msg cancelButton:LocalizeStringFromKey(@"kOk")];
}

- (void)updateLocation{
    @autoreleasepool {
        NSString *terminalid = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
        
        if ([IKDataProvider currentHospitalInfo]){
            NSDictionary *hospitalInfo = [IKDataProvider currentHospitalInfo];
            
            NSString *providerID = [hospitalInfo objectForKey:@"providerID"];
            NSString *providerName = [hospitalInfo objectForKey:@"providerNameCNH"];
            
            NSDictionary *location = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyLocation"];
            
            NSString *longitude = [location objectForKey:@"longitude"];
            NSString *latitude = [location objectForKey:@"latitude"];
            
            NSDictionary *dict = [IKDataProvider recordLocation:[NSDictionary dictionaryWithObjectsAndKeys:terminalid,@"terminalid",providerID,@"providerid",providerName,@"providername",longitude,@"longitude",latitude,@"latitude", nil]];
            
            int result = [[dict objectForKey:@"result"] intValue];
            
            if (result==0 && dict){
                NSLog(@"定位成功");
            }else{
                NSLog(@"定位失败:%@",dict);
            }
        }
    }
}
#pragma mark - CLLocationManger Delegate
//用CLLoction获取到当前的经纬度
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    //    NSLog(@"End:%lf",[[NSDate date] timeIntervalSince1970]);
    CLLocationDistance dlat = newLocation.coordinate.latitude;//得到纬度
    
    CLLocationDistance dlong = newLocation.coordinate.longitude;//得到经度
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lf",dlong],@"longitude",
                          [NSString stringWithFormat:@"%lf",dlat],@"latitude",nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"MyLocation"];
    NSLog(@"My Location:%@",dict);
    [NSThread detachNewThreadSelector:@selector(updateLocation) toTarget:self withObject:nil];
    
    [locationManager stopUpdatingLocation];
    
    [locationManager performSelector:@selector(startUpdatingLocation) withObject:self afterDelay:60*5];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error:%@",error);
    int code = [error code];
    //    NSString *title = @"获取地理位置信息失败";
    NSString *msg = nil;
    switch (code) {
        case 0:{
            //kCLErrorLocationUnknown
            msg = @"发生未知错误,请稍后再重试";
        }
            break;
        case 1:{
            //kCLErrorDenied
            msg = @"请求地理信息被拒绝，请在定位服务中，允许\"MSH\" 使用定位服务再重试";
        }break;
        case 2:{
            //kCLErrorNetwork
            msg = @"网络错误，请检查您的网络设置后再重试";
        }break;
        case 3:{
            //kCLErrorHeadingFailture
        }break;
        case 4:{
            //kCLErrorRegionMonitoringDenied
        }break;
        case 5:{
            //kCLErrorRegionMonitoringFailture
        }break;
        case 6:{
            //kCLErrorRegionMonitoringSetupDelayed
        }break;
        default:
            break;
    }
    NSLog(@"GPS Error:%@",msg);
    [locationManager stopUpdatingLocation];
    [locationManager performSelector:@selector(startUpdatingLocation) withObject:self afterDelay:60*5];
}


@end
